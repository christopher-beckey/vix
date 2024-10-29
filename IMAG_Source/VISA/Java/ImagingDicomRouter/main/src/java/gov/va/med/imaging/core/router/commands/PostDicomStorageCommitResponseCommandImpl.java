/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.AsynchronousCommandResult;
import gov.va.med.imaging.core.interfaces.router.AsynchronousCommandResultListener;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import gov.va.med.logging.Logger;

/**
 * This command is the driver for storing a DICOM storage Commit request. It performs validation
 * of the DICOM request before storing the data
 * 
 * @author vhaiswtittoc
 * 
 */
public class PostDicomStorageCommitResponseCommandImpl extends AbstractDicomCommandImpl<Integer>
{
	private static final long serialVersionUID = -4963797794965394068L;
    private static Logger logger = Logger.getLogger(PostDicomStorageCommitResponseCommandImpl.class);
    private static final InternalDicomRouter internalRouter = InternalDicomContext.getRouter();
//    private int MAX_WAIT_SECONDS = 120;
    
	private StorageCommitWorkItem sCWI;
	/**
	 * @param router
	 * @param asynchronousMethodProcessor
	 */
	public PostDicomStorageCommitResponseCommandImpl(StorageCommitWorkItem scWI)
	{
		super();
		this.sCWI = scWI;
	}

	@Override
	public Integer callSynchronouslyInTransactionContext() throws MethodException, ConnectionException
	{
        logger.info("{}: Executing Router command.", this.getClass().getName());
		
		Integer status=-1;
		TransactionContext transactionContext = TransactionContextFactory.get();
		String siteID = DicomServerConfiguration.getConfiguration().getSiteId();
		transactionContext.setServicedSource(siteID);

		try {
			status = scSendSCWIResponse(sCWI);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new MethodException(e);
		}
//		return null; // used for Void return type
		return status;
	}

	private Integer scSendSCWIResponse(StorageCommitWorkItem scWI)
		throws MethodException, ConnectionException
	{
		Integer status=-1;

        logger.info("{}: Submitting DICOM SC Response (taID={}) requester. [{}].", this.getClass().getName(), scWI.getTransactionUID(), scWI.getApplicationName());

		try {
            CountDownLatch doneSignal = new CountDownLatch(1); // unused now
            StorageCommitWaiter scWaiter = new StorageCommitWaiter(doneSignal); // unused now
		
            status = internalRouter.postSendSCResponse(scWI, scWaiter); // this is a synchronous child command now (5/29/13)!
            
//			// Wait for results to be accumulated by the scWaiter.
//            try
//            {
//                 doneSignal.await(MAX_WAIT_SECONDS, TimeUnit.SECONDS);
//            }
//            catch (InterruptedException e) { 
//                 getLogger().warn("Unexpected InterruptedException, ignoring ....");
//            }
//            status = scWaiter.getResult();
   		} 
		catch (Exception e) {
            logger.info("{}: Error sending SC Response (taID={}): {}[{}].", this.getClass().getName(), scWI.getTransactionUID(), e.getMessage(), scWI.getApplicationName());
			return status;
		}
		return status;
	}

	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.sCWI == null) ? 0 : this.sCWI.hashCode());
		
		return result;
	}

	@Override
	public boolean equals(Object obj)
	{
		// Perform cast for subsequent tests
		final PostDicomStorageCommitResponseCommandImpl other = (PostDicomStorageCommitResponseCommandImpl) obj;

		// Check the studyUrn
		boolean areFieldsEqual = areFieldsEqual(this.sCWI, other.sCWI);
		
		return areFieldsEqual;
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj)
	{
		// Perform cast for subsequent tests
		final PostDicomStorageCommitResponseCommandImpl other = (PostDicomStorageCommitResponseCommandImpl) obj;

		// Check the studyUrn
		boolean areFieldsEqual = areFieldsEqual(this.sCWI, other.sCWI);
		
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

		sb.append(this.sCWI.toString());

		return sb.toString();
	}
// ==================================

	
}
