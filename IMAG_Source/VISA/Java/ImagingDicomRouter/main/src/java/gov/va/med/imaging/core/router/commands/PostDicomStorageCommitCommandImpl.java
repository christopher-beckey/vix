/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.InstrumentConfig;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;
import gov.va.med.imaging.exchange.business.storage.exceptions.RetrievalException;
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
public class PostDicomStorageCommitCommandImpl extends AbstractDicomCommandImpl<Integer>
{
	private static final long serialVersionUID = -4963797794965394068L;
	private static final DicomServerConfiguration config = DicomServerConfiguration.getConfiguration();
    private static Logger logger = Logger.getLogger(PostDicomStorageCommitCommandImpl.class);
    private static final InternalDicomRouter router = InternalDicomContext.getRouter();
	private final static char status_separator_M = '`';

	private final StorageCommitWorkItem sCWI;
	private final DicomAE dicomAE;
	private InstrumentConfig instrument;
	/**
	 * @param router
	 * @param asynchronousMethodProcessor
	 */
	public PostDicomStorageCommitCommandImpl(StorageCommitWorkItem scWI, 
			DicomAE dicomAE,
			InstrumentConfig instrument)
	{
		super();
		this.sCWI = scWI;
		this.dicomAE = dicomAE;
		this.instrument= instrument;
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
			status = storeSCWI(sCWI, dicomAE);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new MethodException(e);
		}	
		return status;
	}

	private Integer storeSCWI(StorageCommitWorkItem scWI, DicomAE dicomAE)
		throws MethodException, ConnectionException
	{
		String sAEPortAndThreadID= "[" + dicomAE.getRemoteAETitle() + "->" + 
		   instrument.getPort() + "/" + Long.toString(Thread.currentThread().getId()) + "]";
		StorageCommitWorkItem scWIOut=null;

        logger.info("{}: Submitting DICOM SC Request (taID={}) to temporary storage. [{}].", this.getClass().getName(), scWI.getTransactionUID(), sAEPortAndThreadID);
		try {
			scWIOut = router.postStoreCommitWorkItem(scWI);
		} 
		catch (RetrievalException re) {
			String[] results = StringUtil.split(re.getMessage(), ""+status_separator_M);
            logger.info("{}: Error storing SC Request (taID={}): {}[{}].", this.getClass().getName(), scWI.getTransactionUID(), re.getMessage(), sAEPortAndThreadID);
			return Integer.decode(results[0]);
		}
//		summaryLogger.info("Stored Storage Commitment Request from remote AE " + dicomAE.getRemoteAETitle() + ".");
		return 0;
	}

	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.sCWI == null) ? 0 : this.sCWI.hashCode());
		result = prime * result + ((this.dicomAE == null) ? 0 : this.dicomAE.hashCode());
		result = prime * result + ((this.instrument == null) ? 0 : this.instrument.hashCode());
		
		return result;
	}

	@Override
	public boolean equals(Object obj)
	{
		// Perform cast for subsequent tests
		final PostDicomStorageCommitCommandImpl other = (PostDicomStorageCommitCommandImpl) obj;

		// Check the studyUrn
		boolean areFieldsEqual = areFieldsEqual(this.sCWI, other.sCWI);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.dicomAE, other.dicomAE);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.instrument, other.instrument);
		
		return areFieldsEqual;
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj)
	{
		// Perform cast for subsequent tests
		final PostDicomStorageCommitCommandImpl other = (PostDicomStorageCommitCommandImpl) obj;

		// Check the studyUrn
		boolean areFieldsEqual = areFieldsEqual(this.sCWI, other.sCWI);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.dicomAE, other.dicomAE);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.instrument, other.instrument);
		
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
		sb.append(this.dicomAE.toString());

		return sb.toString();
	}
}
