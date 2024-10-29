package gov.va.med.imaging.core.router.commands.dicom;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.Command;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.dicom.DicomContext;
import gov.va.med.imaging.dicom.DicomRouter;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.exchange.business.ServiceRegistration;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.SCWorkItemQueryParameters;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;
import gov.va.med.imaging.exchange.business.storage.exceptions.RetrievalException;
import gov.va.med.imaging.notifications.NotificationFacade;
import gov.va.med.imaging.notifications.NotificationTypes;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
// import gov.va.med.imaging.url.vista.StringUtils;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import gov.va.med.logging.Logger;

@RouterCommandExecution(asynchronous = true, distributable = false)
public class ProcessStoreCommitWorkItemCommandImpl extends
		AbstractCommandImpl<Boolean> {

	private static final long serialVersionUID = 4923784727343L;
	private Logger logger = Logger.getLogger(ProcessStoreCommitWorkItemCommandImpl.class);
	private RoutingToken routingToken;
	private String hostName="";
	private Long holdToDeleteMillis = (long) 24*3600*1000; // one day
	private int queueLimit = 100;
	private int lastIENReceived = 0;

	// SC status constants -- set only by persistence layer
	private final static String SC_RECEIVED = "RECEIVED"; // a new SC workitem has been received
	private final static String SC_IN_PROGRESS = "IN PROGRESS"; // an SC workitem is under lookup
	private final static String SC_SUCCESS = "SUCCESS"; // all DICOM SOP instances of a workitem are archived
	private final static String SC_FAILURE = "FAILURE"; // not all or none of the DICOM SOP instances of a workitem are archived
	// SC status constants -- set only by business layer
	private final static String SC_SUCCESS_SENT = "SUCCESS SENT"; // the SC N-EVENT-REPORT (with all SOP instances archived) is successfully sent
	private final static String SC_FAILURE_SENT = "FAILURE SENT"; // the SC N-EVENT-REPORT (with mixed SOP instances archive statuses) is successfully sent
	private final static String SC_SENDING_RESPONSE_FAILED = "SENDING RESPONSE FAILED"; // the sending of the SC N-EVENT-REPORT message has failed (again)

	private static ServiceRegistration registration;

	public ProcessStoreCommitWorkItemCommandImpl() {
		super();
	}
	
	public ProcessStoreCommitWorkItemCommandImpl(Integer queueLimit) {
		super();
		this.queueLimit = queueLimit.intValue();
	}

	@Override
	public Boolean callSynchronouslyInTransactionContext() throws MethodException, ConnectionException {

		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setServicedSource(getLocalSiteId());

    	// get hostname from config
    	hostName=DicomServerConfiguration.getConfiguration().getHostName();

		DicomRouter router = DicomContext.getRouter();
		InternalDicomRouter internalRouter = InternalDicomContext.getRouter();
		try {
			SCWorkItemQueryParameters parameters = new SCWorkItemQueryParameters();
			parameters.setHostname(hostName);
			parameters.setQueueLimit(queueLimit);
			parameters.setLastIENReceived(lastIENReceived);

			List<StorageCommitWorkItem> scWIs;
			while((scWIs = internalRouter.getStoreCommitWorkItemList(parameters)) != null){
			//if ((scWIs==null) || (scWIs.size()==0)){
				// start processing work items
				processSCWorkItems(router, internalRouter, scWIs);
				parameters.setLastIENReceived(lastIENReceived);
			}			
		} catch (RetrievalException re) {
            logger.error("Error listing/processing of storage commit workitems for {}: ", hostName, re);
		} catch (MethodException me) {
            logger.error("Error listing/processing of storage commit workitems for {}: ", hostName, me);
			rethrowIfFatalException(me);
		} catch (ConnectionException ce) {
            logger.error("Error listing/processing of storage commit workitems for {}: ", hostName, ce);
		}
        logger.info("No more Storage Commit work items to process for host {}.", hostName);
		return true;
	}

	private void processSCWorkItems(DicomRouter dR, InternalDicomRouter iDR, List<StorageCommitWorkItem> scWIs)
	throws MethodException, ConnectionException {

		StorageCommitWorkItem scWI;
		String scWIID="";
		String wiStatus="";
		Long responseTimeStamp=0L;
		
		// 		make sure one exception does not prevent the rest of the work items to be processed
		Iterator<StorageCommitWorkItem> iter = scWIs.iterator();
		while(iter.hasNext()) {
			try {
				scWI = (StorageCommitWorkItem) iter.next();

				if(scWI.getId() > this.lastIENReceived){
					this.lastIENReceived = scWI.getId();
				}
				// decipher list entry
				scWIID = String.valueOf(scWI.getId());
				wiStatus= scWI.getStatus();
				responseTimeStamp = scWI.getResponseTimeStamp();
				if (responseTimeStamp==null) responseTimeStamp = 0L;

				
				if (wiStatus.equalsIgnoreCase(SC_SUCCESS_SENT) || wiStatus.equalsIgnoreCase(SC_FAILURE_SENT)) {
					// Delete
					deleteSCWI(iDR, scWIID);
					continue;
				}
				
				// check for SC item to be deleted (after so many SC_SENDING_RESPONSE_FAILED-s and delete timeout)
				if (wiStatus.equalsIgnoreCase(SC_SENDING_RESPONSE_FAILED)
						&& (responseTimeStamp + holdToDeleteMillis) < System.currentTimeMillis() 
						&& scWI.getRetriesLeft() <= 0) {
					// Delete
					deleteSCWI(iDR, scWIID);
					continue;
				}
				
				if(wiStatus.equalsIgnoreCase(SC_RECEIVED)){
					scWI = GetSCWI(iDR, scWIID, true); // get the SC WI with lookup
					wiStatus = scWI.getStatus();
				}
				
				// Check item if ready to send because of status and due time
				if ((wiStatus.equalsIgnoreCase(SC_SUCCESS) 
						|| wiStatus.equalsIgnoreCase(SC_FAILURE) 
						|| wiStatus.equalsIgnoreCase(SC_SENDING_RESPONSE_FAILED))
							&& responseTimeStamp < System.currentTimeMillis()
							&& scWI.getRetriesLeft() > 0){
					// Send SC item
					scWI = GetSCWI(iDR, scWIID, true); // get the SC WI without lookup
					if(scWI != null){
						wiStatus = sendSCResponse(dR, scWI); // sets SC_SUCCESS_SENT, SC_FAILURE_SENT or SC_SENDING_RESPONSE_FAILED
						
						// Update status of SC work item if FAILURE or SUCCESS. 
						//	Note: "retries left" countdown induced within update if status is "SC SENDING RESPONSE FAILED"
						//The M code does the decrementing.  But it requires a status of
						//	SC_SENDING_RESPONSE_FAILED to trigger the decrement.
						updateSCWIStatus(iDR, scWIID, wiStatus);
					}					
				}
			}
			catch (RetrievalException re) {
                logger.error("Error processing storage commit workitem <{}> for {}: ", scWIID, hostName, re);
			}
		}
	}

	// .......................... SC WI processing methods .. ......................................

	private StorageCommitWorkItem GetSCWI(InternalDicomRouter iDR, String scWIID, boolean doProcess)
	throws MethodException, ConnectionException
	{
		StorageCommitWorkItem scWI=null;

		scWI = iDR.getStoreCommitWorkItem(scWIID, doProcess);
 
		return scWI;
	}

	// updateSCWIStatus hardcoded to auto decrement the retriesLeft field of the WI option if wiStatus is 
	//		SENDING RESPONSE FAILED (see generateUpdateQuery)
	private Boolean updateSCWIStatus(InternalDicomRouter iDR, String scWIID, String wiStatus)
	throws MethodException, ConnectionException
	{
		return iDR.postStoreCommitWorkItemStatus(scWIID, wiStatus);
	}
	
	private boolean deleteSCWI(InternalDicomRouter iDR, String scWIID)
	throws MethodException, ConnectionException
	{
		return iDR.postDeleteStoreCommitWorkItem(scWIID);
	}
	
	private String sendSCResponse(DicomRouter dR, StorageCommitWorkItem scWI)
	throws MethodException, ConnectionException {
		Integer status=-1;
		String returnStatus="";
		
		// construct DICOM message and send it
		status = dR.postDicomStorageCommitResponse(scWI);
		
		if (status == 0) {
			if(logger.isDebugEnabled()){
                logger.debug("WorkItem {} Status after send SC response success is {}", scWI.getId(), scWI.getStatus());}
			if ((scWI.getStatus().equalsIgnoreCase(SC_SUCCESS)) || (scWI.getStatus().equalsIgnoreCase(SC_SENDING_RESPONSE_FAILED)))
				returnStatus = SC_SUCCESS_SENT;
			else // SC_FAILURE or before
				returnStatus = SC_FAILURE_SENT;				
		}
		else {
            logger.error("Error = {}; Sending Storage Commit Response for workitem <{}> from {}.", status, scWI.getId(), hostName);
			// if send failed, set status to SENDING RESPONSE FAILED
			returnStatus = SC_SENDING_RESPONSE_FAILED;
		}
		if(logger.isDebugEnabled()){
            logger.debug("sendSCResponse returnStatus after send SC response is {}", returnStatus);}
		return returnStatus;
	}
	// ................................................................................................
	
	@Override
	public boolean equals(Object obj) {
		return false;
	}

	@Override
	public Command<Boolean> getNewPeriodicInstance() throws MethodException {
		ProcessStoreCommitWorkItemCommandImpl command = new ProcessStoreCommitWorkItemCommandImpl(getQueueLimit());
		command.setPeriodic(true);
		command.setPeriodicExecutionDelay(this.getPeriodicExecutionDelay());
		command.setCommandContext(this.getCommandContext());
		return command;
	}

	public RoutingToken getRoutingToken() {
		if (routingToken == null)
			routingToken = getCommandContext().getLocalSite().getArtifactSource().createRoutingToken();
		return routingToken;
	}

	@Override
	protected String parameterToString() {
		return Integer.toString(queueLimit);
	}

	public Integer getQueueLimit() {
		return new Integer(queueLimit);
	}

	public static void setRegistration(ServiceRegistration registration) {
		ProcessStoreCommitWorkItemCommandImpl.registration = registration;
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
		String message = "The ProcessStoreCommitWorkItem periodic command has shut down due to invalid HDIG service account credentials.";
		NotificationFacade.sendNotification(NotificationTypes.InvalidServiceAccountCredentials, subject, message);
	}
}
