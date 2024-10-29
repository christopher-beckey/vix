package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.interfaces.router.AsynchronousCommandResult;
import gov.va.med.imaging.core.interfaces.router.AsynchronousCommandResultListener;

import java.util.concurrent.CountDownLatch;

import gov.va.med.logging.Logger;

public class StorageCommitWaiter implements AsynchronousCommandResultListener {
	private CountDownLatch doneSignal;
	private int result=-1;
	private static Logger logger = Logger.getLogger(StorageCommitWaiter.class);
    
	public static Logger getLogger() {
		return logger;
	}

	public int getResult() {
		return result;
	}
	
	public StorageCommitWaiter(CountDownLatch doneSignal) {
		this.doneSignal = doneSignal;
	}

	/**
	 * This method receives the result of an
	 * PostStorageCommitSendRequestCommandImpl
	 */
	public void commandComplete(AsynchronousCommandResult commandResult) {
		// Get the command
		PostSendSCResponseCommandImpl cmd = (PostSendSCResponseCommandImpl) commandResult
				.getCommand();

		// Command failed - cross command off the waiting list.
		if (commandResult.isError()) 
		{
			getLogger().warn("Error Message");
			result = -1;
		} else if (commandResult.getResult() != null) {
			// Overwrite the uninitialized ExamSite in the map.
			result = (Integer)commandResult.getResult();
		}

		doneSignal.countDown();
	}

}
