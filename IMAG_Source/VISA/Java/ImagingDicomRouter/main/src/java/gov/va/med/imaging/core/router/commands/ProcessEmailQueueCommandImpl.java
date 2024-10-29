package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.Command;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.core.router.facade.InternalContext;
import gov.va.med.imaging.exchange.business.DurableQueue;
import gov.va.med.imaging.exchange.business.DurableQueueMessage;
import gov.va.med.imaging.exchange.business.QueuedEmailMessage;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.notifications.Notification;
import gov.va.med.imaging.notifications.NotificationFacade;
import gov.va.med.imaging.notifications.NotificationTypes;
import gov.va.med.imaging.notifications.email.NotificationEmailConfiguration;
import gov.va.med.imaging.notifications.email.NotificationEmailProtocol;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

import gov.va.med.logging.Logger;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.XStreamException;

/**
 * Checks queued email messages stored in VistA.  Finds like email messages and combined them into
 *  a single email message to avoid generating too much email traffic for the recipients.  Determines 
 *  if an email message is to be sent immediately or sent later.  Error email message are sent immediately.
 *  Warning messages are sent later.  There is logic to not allow an email message to sit in the queue for more
 *  than a day.    
 * 
 * @author VHAISWTITTOC and VHAISWPETERB
 *
 */
@RouterCommandExecution(asynchronous = true, distributable = false)
public class ProcessEmailQueueCommandImpl extends
		AbstractCommandImpl<Boolean> {

	private static final long serialVersionUID = 4923784727344L;
	private final static String EMAIL_QUEUE_NAME = "E-Mail Queue";
	private Logger logger = Logger.getLogger(ProcessEmailQueueCommandImpl.class);
	private static final DicomServerConfiguration config = getConfig();
	private static final NotificationEmailConfiguration emailConfig = getEmailConfig();

    private DurableQueue emailQueue;

	public ProcessEmailQueueCommandImpl() {
	}

	@Override
	public Boolean callSynchronouslyInTransactionContext()
			throws MethodException, ConnectionException {
		logger.info("Checking " + EMAIL_QUEUE_NAME + " for E-mail messages to send");
		ProcessEmails();
		return true;
	}

	@Override
	public boolean equals(Object obj) {
		return false;
	}

	@Override
	public Command<Boolean> getNewPeriodicInstance() throws MethodException {
		ProcessEmailQueueCommandImpl command = new ProcessEmailQueueCommandImpl();
		command.setPeriodic(true);
		command.setPeriodicExecutionDelay(this.getPeriodicExecutionDelay());
		return command;
	}

	public List<Class<? extends MethodException>> getFatalPeriodicExceptionClasses()
	{
		List<Class<? extends MethodException>> fatalExceptions = new ArrayList<Class<? extends MethodException>>();
		fatalExceptions.add(InvalidUserCredentialsException.class);
		return fatalExceptions;
	}

	/**
	 * This method is called when a periodic command has thrown a fatal exception as defined by the list in getFatalPeriodicExceptionClasses(). At the point when this method is called
	 * the periodic command has already stopped executing and will not execute again.  This method is meant to allow the command to alert someone of the failure (such as by sending 
	 * an email message)
	 * @param t
	 */
	public void handleFatalPeriodicException(Throwable t)
	{
		String subject = "Invalid HDIG service account credentials";
		String message = "The ProcessEmailQueue periodic command has shut down due to invalid HDIG service account credentials.";
		NotificationFacade.sendNotification(NotificationTypes.InvalidServiceAccountCredentials, subject, message);
	}

	/**
	 * @return
	 */
	protected static DicomServerConfiguration getConfig() {
		return DicomServerConfiguration.getConfiguration();
	}

	protected static NotificationEmailConfiguration getEmailConfig(){
		return NotificationEmailConfiguration.getConfiguration();
	}

	@Override
	protected String parameterToString() {
		return "";
	}

	protected void ProcessEmails() throws MethodException, ConnectionException
    {
         //
         // Get the next queued Email  message
         //
         RoutingToken routingToken = config.getRoutingToken();
         DurableQueue queue = getEmailQueue();
         String msgGroupID = config.getHostName(); // localhost
         
         QueuedEmailMessage queuedEmail = null;
         DurableQueueMessage message = null;
         ArrayList<QueuedEmailMessage> emailMessages = new ArrayList<QueuedEmailMessage>();
         boolean moreMessages = true;
         // collect messages up to a MB
         while (moreMessages){
        	//get the next message from Durable Queue.
        	message = getQueueMessage(routingToken, queue, msgGroupID);
        	
        	if (message != null){ // new message
	            //get the message from the durable queue message and de-serialize it into a
	            //	email message object.
	            try{
	        		queuedEmail = deserializeUsingXStream(message.getMessage());
		            
		            //determine if this email message matches another email message already in the list.
		            //	Use the Subject Line for matching.  This is because nothing else makes much sense.
		            int emailIndex = emailMessages.indexOf(queuedEmail); 
		            if(emailIndex < 0){
		            	//if there is no match, add this new email message to the list.
		            	emailMessages.add(queuedEmail);	            	
		            }
		            else{
		            	QueuedEmailMessage m = (QueuedEmailMessage)emailMessages.get(emailIndex);
		            	//if there is a match, add subject line and body to existing email body.
		            	//	increment message count.
	            		StringBuffer buf = new StringBuffer(m.getMessageBody());
	            		StringBuffer addString = new StringBuffer("\r\n--------------------------------------------\r\n"+ 
	            				"Subject: "+queuedEmail.getSubjectLine()+"\r\nMessage:\r\n"+queuedEmail.getMessageBody());
	            		buf.append(addString);
	            		m.setMessageBody(buf.toString());
	            		m.setMessageCount(m.getMessageCount() + queuedEmail.getMessageCount());
	            		m.setBodyByteSize(m.getBodyByteSize() + queuedEmail.getBodyByteSize());
		            }
	            }
	            catch(XStreamException xsX){
                    logger.error("{}: Bad Durable Queue Message. Will skip message {}", this.getClass().getName(), message.getId());
	    			logger.error(xsX.getMessage(), xsX);
	            }
        	}
        	else{
                logger.info("No more entries in " + EMAIL_QUEUE_NAME + " for {}.  Back to sleep.", msgGroupID);
	       	 	moreMessages = false;
        	}
        }
		transverseQueuedEmailMessageCollection(routingToken, queue, msgGroupID, emailMessages);
    }


	/**
	 * Re-queue email message back into VISA queue mechanism.
	 * 
	 * @param routingToken
	 * @param queue represents the DurableQueue for emails.
	 * @param msgGroupID represents the hostname of the HDIG.
	 * @param queuedEmail represents the email message.
	 * @return
	 * @throws ConnectionException
	 * @throws MethodException
	 */
	protected Boolean requeue(RoutingToken routingToken, DurableQueue queue, String msgGroupID, QueuedEmailMessage queuedEmail, Boolean doCount) 
    throws ConnectionException, MethodException
    {
		if(queuedEmail.getRetryCount() < queue.getNumRetries()){
			if (doCount) {
				queuedEmail.incrementRetryCount();
			}
	    	String serializedEmail = serializeUsingXStream(queuedEmail);
			DurableQueueMessage message = new DurableQueueMessage(queue, msgGroupID, serializedEmail);
			try {
				setQueueMessage(routingToken, message);
				if(logger.isDebugEnabled()){
                    logger.debug("{}: Email job requeued with subject, \n{}", this.getClass().getName(), queuedEmail.getSubjectLine());}
			}
			catch(Exception X) {
                logger.error("{}: Failed to requeue Email with subject, \n{}. \nNo Email will be sent.", this.getClass().getName(), queuedEmail.getSubjectLine());
			}
			return true;
		}
		else{
			//false, log message and throw away the message.
            logger.error("{}: Failed to send Email after maximum number of retries with subject, \n{} \nNo Email will be sent.", this.getClass().getName(), queuedEmail.getSubjectLine());
			return false;
		}		
    }
    
	/**
	 * Send email message.
	 * 
	 * @param emailMessage
	 */
	protected void sendMail(QueuedEmailMessage emailMessage)
	{
	    NotificationEmailProtocol nEmailProtocol= new NotificationEmailProtocol();
	    List<InternetAddress> eMailTOs=new ArrayList<InternetAddress>();
	    ArrayList<String> emailRecipients = emailMessage.getRecipients();
	    	for (String tos: emailRecipients)
	    		try{
	    			eMailTOs.add(new InternetAddress(tos));
		        } 
		        catch (AddressException ae) 
		        {
                    logger.warn("{}: Bad email address, {}", this.getClass().getName(), tos);
		        }
		Notification eMailMsg = Notification.getGenericNotification(emailMessage.getSubjectLine(), emailMessage.getMessageBody());
		nEmailProtocol.sendTo(eMailTOs, eMailMsg);
	}

	/**
	 * Get DurableQueue containing email messages.  This was created primarily for unit testing.
	 * 
	 * @return
	 * @throws ConnectionException
	 * @throws MethodException
	 */
	protected DurableQueue getEmailQueue() throws ConnectionException, MethodException
	{
		if (emailQueue == null){
			emailQueue = InternalContext.getRouter().getDurableQueueByName(config.getRoutingToken(), EMAIL_QUEUE_NAME);
		}
		return emailQueue;
	}

	/**
	 * Get the next email message in the queue.  This was created primarily for unit testing.
	 * 
	 * @param routingToken
	 * @param queue represents the DurableQueue for emails.
	 * @param msgGroupID represents the hostname of the HDIG.
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	protected DurableQueueMessage getQueueMessage(RoutingToken routingToken,
			DurableQueue queue, String msgGroupID) throws MethodException,
			ConnectionException {
		return InternalContext.getRouter().dequeueDurableQueueMessage(routingToken, queue.getId(), msgGroupID);
	}
	
	protected QueuedEmailMessage deserializeUsingXStream(String serializedXml)throws XStreamException{
		XStream xstream = new XStream();
		return (QueuedEmailMessage)xstream.fromXML(serializedXml);
	}

	protected String serializeUsingXStream(QueuedEmailMessage emailMessage){
		XStream xstream = new XStream();
		return xstream.toXML(emailMessage);
	}

	/**
	 * Re-queue an email message in the queue.  This was created primarily for unit testing.
	 * 
	 * @param routingToken
	 * @param message represents the email message.
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	private void setQueueMessage(RoutingToken routingToken,
			DurableQueueMessage message) throws MethodException,
			ConnectionException {
		InternalContext.getRouter().enqueueDurableQueueMessage(routingToken, message);
	}

	/**
	 * A collection of email messages was built from the queue.  This method now determines what should happen
	 * 	to the email messages.  Email messages could be sent out immediately or it could be place back into
	 *  the queue for later transmission.  Basically, error messages are sent out immediately and warning
	 *  warning message are re-queued for later.
	 *  
	 * @param routingToken
	 * @param queue represents the DurableQueue for emails.
	 * @param msgGroupID represents the hostname of the HDIG.
	 * @param emailMessages represents the collection of email messages.
	 * @throws ConnectionException
	 * @throws MethodException
	 */
    private void transverseQueuedEmailMessageCollection(RoutingToken routingToken, DurableQueue queue, String msgGroupID,
						ArrayList<QueuedEmailMessage> emailMessages)throws ConnectionException, MethodException {
		int maxMessagesPerEmail = emailConfig.getMaximumMessageCountPerEmail();
		int maxBytesPerEmail = emailConfig.getMaximumByteSizePerEmail();
    	for(QueuedEmailMessage queuedEmail : emailMessages){
	        if(((queuedEmail.getSubjectLine().contains("DUP/")) || (queuedEmail.getSubjectLine().contains("IOD Violation")))){ 
        		Calendar now = Calendar.getInstance();
        		int nowDay = now.get(Calendar.DAY_OF_YEAR);
        		int postDay = queuedEmail.getDateTimePosted().get(Calendar.DAY_OF_YEAR);
	        	if((queuedEmail.getMessageCount() >= maxMessagesPerEmail) 
	        			|| (queuedEmail.getBodyByteSize() >= maxBytesPerEmail) 
	        			|| (postDay < nowDay)){
	        		sendQueuedEmailMessage(routingToken, queue, msgGroupID, queuedEmail);
	        	}
	        	else{
        			requeue(routingToken, queue, msgGroupID, queuedEmail, false); // do not count retry -- this is a NOOP
	        	}
	        }
	        else{
	            sendQueuedEmailMessage(routingToken, queue, msgGroupID, queuedEmail);
	        }
		}
	}

	/**
	 * Prepares email message to be sent out.
	 * 
	 * @param routingToken
	 * @param queue represents the DurableQueue for emails.
	 * @param msgGroupID represents the hostname of the HDIG.
	 * @param queuedEmail represents an email message.
	 * @throws ConnectionException
	 * @throws MethodException
	 */
	private void sendQueuedEmailMessage(RoutingToken routingToken,
			DurableQueue queue, String msgGroupID,
			QueuedEmailMessage queuedEmail) throws ConnectionException,
			MethodException {
		try {
			int msgCount = queuedEmail.getMessageCount();
		    if (msgCount > 1){ // place counter on end
				String temp = queuedEmail.getSubjectLine(); 
				temp = temp.concat("(Qty: " + String.valueOf(msgCount) + ")");
				queuedEmail.setSubjectLine(temp);
			}
		    sendMail(queuedEmail);
		}
		catch (Exception X){
			logger.error(X.getMessage(), X);
			requeue(routingToken, queue, msgGroupID, queuedEmail, true); // do count retries
		}
	}
}
