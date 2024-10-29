package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.Command;
import gov.va.med.imaging.core.router.commands.storage.ProcessAsyncStorageQueueCommandImpl;
import gov.va.med.imaging.dicom.DicomContext;
import gov.va.med.imaging.dicom.DicomRouter;
import gov.va.med.imaging.exchange.business.EmailMessage;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.storage.AsyncStorageRequest;

import gov.va.med.logging.Logger;
/*
 * Overrides a method in the asynchronous storage queue periodic command (defined in Core Router project)
 * to be able to submit e-mail requests upon permanently failed archive attempts.
 * 
 * @author VHAISWTITTOC
 * 
 */
@RouterCommandExecution(asynchronous = true, distributable = false)
public class ProcessAsyncStorageQueueSendEmailCommandImpl extends
		ProcessAsyncStorageQueueCommandImpl {

	private static final long serialVersionUID = 4923784727345L;
	private Logger logger = Logger.getLogger(ProcessAsyncStorageQueueSendEmailCommandImpl.class);

	/**
	 * @param request
	 * @param eMailTos
	 * @param subjectLine
	 * @param threadId
	 * 
	 * post Error message to e-mail queue (override)
	 * this postToEmailQ is the override of the protected equivalent signature within the ProcessAsyncStorageQueueCommandImpl call in CoreRouter project.
	 */
	@Override
	public void postToEmailQ(AsyncStorageRequest request, String[] eMailTos, String subjectLine,
			String threadId) {
		EmailMessage email = new EmailMessage(eMailTos,
				subjectLine,
				request.getLastError()); // the message body
		DicomRouter rtr = DicomContext.getRouter();
		try { 
			rtr.postToEmailQueue(email, threadId);
		} 
		catch (MethodException me) {
            logger.error("Error queueing Email for \n'{}' - ThreadID{}", request.getLastError(), threadId);
		} 
		catch (ConnectionException ce) {
            logger.error("DB Connection error while queueing Email for \n'{}' - ThreadID{}", request.getLastError(), threadId);
		}
	}

	@Override
	public Command<Boolean> getNewPeriodicInstance() throws MethodException {
		ProcessAsyncStorageQueueSendEmailCommandImpl command = new ProcessAsyncStorageQueueSendEmailCommandImpl();
		command.setPeriodic(DicomServerConfiguration.getConfiguration().isArchiveEnabled());
		command.setPeriodicExecutionDelay(this.getPeriodicExecutionDelay());
		command.setCommandContext(this.getCommandContext());
		return command;
	}
}
