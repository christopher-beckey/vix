package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.facade.InternalContext;
import gov.va.med.imaging.exchange.business.DurableQueue;
import gov.va.med.imaging.exchange.business.DurableQueueMessage;
import gov.va.med.imaging.exchange.business.EmailMessage;
import gov.va.med.imaging.exchange.business.QueuedEmailMessage;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.util.Calendar;
import java.util.Date;

import gov.va.med.logging.Logger;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.XStreamException;

/**
 * This command is submitting an e-mail context to the Email Queue.
 * 
 * @author vhaiswtittoc
 * 
 */
public class PostToEmailQueueCommandImpl extends AbstractDicomCommandImpl<Boolean>
{
	private static final long serialVersionUID = -4963797794965394067L;
	private static final DicomServerConfiguration config = DicomServerConfiguration.getConfiguration();
    private static Logger logger = Logger.getLogger(PostDicomInstanceCommandImpl.class);
	private final static String EMAIL_QUEUE_NAME = "E-Mail Queue";

	private final EmailMessage email;
	private final String scpContext;

	/**
	 * @param router
	 * @param asynchronousMethodProcessor
	 */
	public PostToEmailQueueCommandImpl(EmailMessage email, String scpContext)
	{
		super();
		String timeStamp= new Date().toString(); 
    	email.setMessageBody(email.getMessageBody() + "\nSubmitted by: " + timeStamp); // add time stamp of original message generation
		this.email = email;
		this.scpContext= scpContext;
	}
	
	@Override
	public Boolean callSynchronouslyInTransactionContext() throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		String siteID = DicomServerConfiguration.getConfiguration().getSiteId();
		transactionContext.setServicedSource(siteID);
		
		Boolean emailQueueingResult = false;
		
		try
		{			
			RoutingToken routingToken = config.getRoutingToken();
			DurableQueue queue = InternalContext.getRouter().getDurableQueueByName(routingToken, EMAIL_QUEUE_NAME);
			String msgGroupID = config.getHostName(); // localhost
			QueuedEmailMessage queuedEmail = new QueuedEmailMessage(email);
			Calendar postingTime = Calendar.getInstance();
			queuedEmail.setDateTimePosted(postingTime);
			String serializedEmail = serializeUsingXStream(queuedEmail);
			DurableQueueMessage message = new DurableQueueMessage(queue, msgGroupID, serializedEmail);
			
			InternalContext.getRouter().enqueueDurableQueueMessage(routingToken, message);
            logger.info("Email request queued - {}.", scpContext);
		   	emailQueueingResult = true;
		}
		catch (Exception e)
		{
			logger.error(e.getMessage(), e);
			throw new MethodException(e);
		}	
		return emailQueueingResult;
	}
	
	
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.email.getRecipients() == null) ? 0 : this.email.getRecipients().hashCode());
		result = prime * result + ((this.email.getSubjectLine() == null) ? 0 : this.email.getSubjectLine().hashCode());
		result = prime * result + ((this.email.getMessageBody() == null) ? 0 : this.email.getMessageBody().hashCode());
		result = prime * result + ((this.scpContext == null) ? 0 : this.scpContext.hashCode());

		return result;
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj)
	{
		// Perform cast for subsequent tests
		final PostToEmailQueueCommandImpl other = (PostToEmailQueueCommandImpl) obj;

		// Check the studyUrn
		boolean areFieldsEqual = areFieldsEqual(this.email.getRecipients(), other.email.getRecipients());
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.email.getSubjectLine(), other.email.getSubjectLine());
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.email.getMessageBody(), other.email.getMessageBody());
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.scpContext, other.scpContext);

		return areFieldsEqual;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see gov.va.med.imaging.core.router.AsynchronousCommandProcessor#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		StringBuffer sb = new StringBuffer();

		sb.append(this.email.getRecipients().toString());
		sb.append(this.email.getSubjectLine());
		sb.append(this.email.getMessageBody());
		sb.append(this.scpContext);

		return sb.toString();
	}
	
	private String serializeUsingXStream(QueuedEmailMessage emailMessage){
		XStream xstream = new XStream();
		return xstream.toXML(emailMessage);
	}

}
