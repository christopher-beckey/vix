/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.GUID;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.ParentREFDeletedMethodException;
import gov.va.med.imaging.core.router.facade.InternalContext;
import gov.va.med.imaging.core.router.storage.StorageContext;
import gov.va.med.imaging.core.router.storage.StorageDataSourceRouter;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.exchange.business.DurableQueue;
import gov.va.med.imaging.exchange.business.DurableQueueMessage;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.InstanceFile;
import gov.va.med.imaging.exchange.business.dicom.InstrumentConfig;
import gov.va.med.imaging.exchange.business.dicom.PatientRef;
import gov.va.med.imaging.exchange.business.dicom.PatientStudyLookupResults;
import gov.va.med.imaging.exchange.business.dicom.ProcedureRef;
import gov.va.med.imaging.exchange.business.dicom.SOPInstance;
import gov.va.med.imaging.exchange.business.dicom.Series;
import gov.va.med.imaging.exchange.business.dicom.Study;
import gov.va.med.imaging.exchange.business.dicom.UIDCheckResults;
import gov.va.med.imaging.exchange.business.dicom.rdsr.Dose;
import gov.va.med.imaging.exchange.business.storage.Artifact;
import gov.va.med.imaging.exchange.business.storage.ArtifactDescriptor;
import gov.va.med.imaging.exchange.business.storage.Key;
import gov.va.med.imaging.exchange.business.storage.KeyList;
import gov.va.med.imaging.exchange.business.storage.Place;
import gov.va.med.imaging.exchange.business.storage.StorageServerConfiguration;
import gov.va.med.imaging.exchange.business.storage.StorageServerDatabaseConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.io.FileDescriptor;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.channels.ReadableByteChannel;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * This command is the driver for storing a DICOM instance. It performs validation
 * of the patient and imaging service request, check UIDs and coerces them if necessary,
 * determines whether the instance is an "old" or "new" SOP class, and stores the
 * instance appropriately.
 * 
 * @author vhaiswlouthj
 * 
 */
public class PostDicomInstanceToNewStructureCommandImpl extends AbstractDicomCommandImpl<Boolean>
{
	private static final long serialVersionUID = -4963797794965394068L;
	private static final String ASYNC_ICON_QUEUE = "ASYNC_ICON_QUEUE";
	private static final DicomServerConfiguration config = DicomServerConfiguration.getConfiguration();
    private static Logger logger = Logger.getLogger(PostDicomInstanceToNewStructureCommandImpl.class);
    private static final int NO_RETRY = 0;
    private static final int ONE_RETRY_ONLY = 1;

	private final IDicomDataSet dds;
	private final PatientStudyLookupResults patientStudyLookupResults;
	private final UIDCheckResults uidCheckResults;
	private final InstrumentConfig instrument;
	private final int iodValidationStatus;
	private final ReadableByteChannel instanceChannel;
	private final InputStream inputStream;
    private final String curRAIDLocation="C:\\ImageLocalTest\\";
    private final DicomAE dicomAE;
    
	// DICOM import variables
	private final String originIndex;

	/**
	 * @param router
	 * @param asynchronousMethodProcessor
	 */
	public PostDicomInstanceToNewStructureCommandImpl(IDicomDataSet dds, DicomAE dicomAE, 
			PatientStudyLookupResults patientStudyLookupResults, UIDCheckResults uidCheckResults, 
			InstrumentConfig instrument, int iodValidationStatus, ReadableByteChannel instanceChannel, 
			InputStream inputStream, String originIndex)
	{
		super();
		this.dds = dds;
		this.dicomAE = dicomAE;
		this.instanceChannel = instanceChannel;
		this.patientStudyLookupResults = patientStudyLookupResults;
		this.uidCheckResults = uidCheckResults;
		this.instrument = instrument;
		this.iodValidationStatus = iodValidationStatus;
		this.inputStream = inputStream;
		
		// DICOM import fields
		this.originIndex = originIndex;

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see gov.va.med.imaging.core.router.AsynchronousCommandProcessor#callInTransactionContext()
	 */
	@Override
	public Boolean callSynchronouslyInTransactionContext() throws MethodException, ConnectionException
	{
			
        String sourceAEAndPort = "[" + dicomAE.getRemoteAETitle() + "->" + instrument.getPort() + "/" + 
        							Long.toString(Thread.currentThread().getId()) + "]";

		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setServicedSource(DicomServerConfiguration.getConfiguration().getSiteId());
		
	    InternalDicomRouter router = InternalDicomContext.getRouter();
	    PatientRef patientRef= null;
	    ProcedureRef procedureRef= null;
	    Study study = null;
	    Series series = null;
	    SOPInstance sopInstance = null;
		
	    boolean retry = false;
	    int retryAttempt = ONE_RETRY_ONLY;
		do{
			// Extract business objects from the DICOM Dataset
			patientRef = dds.getPatientRef();
			patientRef.setEnterprisePatientId(patientStudyLookupResults.getPatienStudyInfo().getPatientDFN());		
			procedureRef = dds.getProcedureRef(instrument);
			study = dds.getStudy();
			series = dds.getSeries(dicomAE, instrument);
			sopInstance = dds.getSOPInstance();
            logger.info("DICOM Header data extracted for DB processing {}.", sourceAEAndPort);
	   	
			try{
				// Find or create the Patient Ref, Procedure Ref, Study, Series  and SOP Instance entries.
				patientRef = router.getOrCreatePatientRef(patientRef);
                logger.info("Patient REF Found or Created {}.", sourceAEAndPort);
		
				procedureRef = router.getOrCreateProcedureRef(patientRef, procedureRef);
				if(logger.isDebugEnabled()){
                    logger.debug("{}: Procedure REF: {}", this.getClass().getName(), procedureRef.toString());}
                logger.info("Procedure REF Found or Created {}.", sourceAEAndPort);
		
				if (uidCheckResults.getStudyResult().isDuplicateUID() || uidCheckResults.getStudyResult().isIllegalUID()) {
					if (uidCheckResults.getStudyResult().isDuplicateUID())
                        logger.info("Duplicate Study UID replaced {}.", sourceAEAndPort);
					else
                        logger.info("Illegal Study UID replaced {}.", sourceAEAndPort);
				   	study.setOriginalStudyIUID(uidCheckResults.getStudyResult().getOriginalUID());
				}
				study.setOriginIX(originIndex);
				study = router.getOrCreateStudy(patientRef, procedureRef, study);
                logger.info("Study Found or Created {}.", sourceAEAndPort);
		
				if (uidCheckResults.getSeriesResult().isDuplicateUID() || uidCheckResults.getSeriesResult().isIllegalUID()) {
					if (uidCheckResults.getSeriesResult().isDuplicateUID())
                        logger.info("Duplicate Series UID replaced {}..", sourceAEAndPort);
					else
                        logger.info("Illegal Series UID replaced {}.", sourceAEAndPort);
					series.setOriginalSeriesIUID(uidCheckResults.getSeriesResult().getOriginalUID());
				}
				// insert TIU Note Reference to series if service type is CONSULT
				if (procedureRef.getPackageIX().startsWith("CON")) {
					series.setStudyIEN(study.getIEN());
					series = router.getTIUPointer(series);
				}
				series = router.getOrCreateSeries(study, series, new Integer(iodValidationStatus));
                logger.info("Series Found or Created{}.", sourceAEAndPort);
		
				if (uidCheckResults.getSOPInstanceResult().isDuplicateUID() || uidCheckResults.getSOPInstanceResult().isIllegalUID()) {
					if (uidCheckResults.getSOPInstanceResult().isDuplicateUID())
                        logger.info("Duplicate SOP Instance UID replaced {}.", sourceAEAndPort);
					else
                        logger.info("Illegal SOP Instance  UID replaced {}.", sourceAEAndPort);
					sopInstance.setOriginalSOPInstanceUID(uidCheckResults.getSOPInstanceResult().getOriginalUID());
				}
				sopInstance.setSeriesIEN(series.getIEN());
				sopInstance = router.postSOPInstance(series, sopInstance);
                logger.info("SOP Instance Created {}.", sourceAEAndPort);
			   	// If this is an RDSR, store dosage information
			   	if (dds.isRadiationDoseStructuredReport())
			   	{
			   		router.processRadiationDose(dds, patientRef, procedureRef, study, series);
                    logger.info("Radiation Dose Created {}.", sourceAEAndPort);
			   	}
			   	retry = false;
			}
			catch (InvalidUserCredentialsException e)
			{
				// Just rethrow this one: it's fatal
				throw e;
			}
			catch(ParentREFDeletedMethodException piendX){
				router.deleteStudyAndSeriesCache();
				retry = (retryAttempt == NO_RETRY) ? false : true;
				retryAttempt--;
			}
	    } while(retry);

	    
	    //Store 
	   	String token = storeArtifact(patientRef, procedureRef, study, series, sopInstance, sourceAEAndPort);

        logger.info("Original Artifact Stored {}.", sourceAEAndPort);
	   			
		// Create the Instance File entry
		InstanceFile instanceFile = createInstanceFileEntry(sourceAEAndPort,
				router, sopInstance, token);
		
		// Queue up the Icon Image creation
		queueIconImageCreation(sourceAEAndPort, sopInstance, instanceFile);
		return true;
	}

	private String storeArtifact(PatientRef patientRef, ProcedureRef procedureRef, Study study,
			Series series, SOPInstance sopInstance, String srcAEAndPort) throws MethodException,
			ConnectionException {
		StorageServerConfiguration config = StorageServerConfiguration.getConfiguration();
		StorageServerDatabaseConfiguration dbConfig = StorageServerDatabaseConfiguration.getConfiguration();
		
		ArtifactDescriptor artifactDescriptor = dbConfig.getArtifactDescriptorByTypeAndFormat("MedicalImage", "DICOM");
		
		// Create the keylist
		KeyList keyList = new KeyList();
		keyList.getKeyList().add(new Key(1, "SiteDFN=" + getLocalSiteId() + "-" + patientRef.getEnterprisePatientId()));
		keyList.getKeyList().add(new Key(2, "SiteAcc=" + getLocalSiteId() + "-" + procedureRef.getProcedureID()));
		keyList.getKeyList().add(new Key(3, "StudyId=" + study.getStudyIUID()));
		keyList.getKeyList().add(new Key(4, "SeriesId=" + series.getSeriesIUID()));
		keyList.getKeyList().add(new Key(5, "SOPId=" + sopInstance.getSOPInstanceUID()));
		
		String createdBy = "VI DICOM Storage SCP";
		
		Long t0=System.currentTimeMillis();

		String token = StorageContext.getBusinessRouter().postArtifactByStream(inputStream, instanceChannel, artifactDescriptor, getLocalSiteId(), keyList, createdBy);

		// timelog
		Long deltaT=System.currentTimeMillis()-t0;
        logger.info("StoreArtifact time = {} ms {}.", deltaT.toString(), srcAEAndPort);

		
		return token;
	}

	private String temporaryStorage(String sourceAEAndPort) {
		// **** Storage will replace this section ***********************************************
		//
		// Determine where to write the file and write it out
		GUID guid = new GUID();
		String fileName = guid.toShortString() + ".DCM";
		String fullFSpec = curRAIDLocation + fileName;

		String diagnosticMessage = ";  Error Writing Input Stream to " + fullFSpec + " " + sourceAEAndPort + ".";
		Integer bytesOut = 0;
		Long t0 = System.currentTimeMillis();

		// Write the file
		// Fortify: use try-with-resources
		try (FileOutputStream targetFileStream = new FileOutputStream(fullFSpec);) 
		{
			ByteStreamPump bSP = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToFile);
			// don't create 'inputStream' object so shouldn't close 
			bytesOut = bSP.xfer(inputStream, targetFileStream);
			FileDescriptor fd = targetFileStream.getFD();
			fd.sync();
		} 
		catch (Exception e)
		{
            logger.error("{}{}", e.getMessage(), diagnosticMessage, e);
			return "";
		}
		
		Long deltaT = System.currentTimeMillis() - t0;
        logger.info("Store Stream time = {} ms for {} bytes {}.", deltaT.toString(), bytesOut, sourceAEAndPort);
	   	
	   	// *******************************************************************************************
	   	
		return fileName;
	}
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#hashCode()
	 */
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.dds == null) ? 0 : this.dds.hashCode());
		result = prime * result + ((this.instanceChannel == null) ? 0 : this.instanceChannel.hashCode());
		result = prime * result + ((this.instrument == null) ? 0 : this.instrument.hashCode());
		return result;
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj)
	{
		// Perform cast for subsequent tests
		final PostDicomInstanceToNewStructureCommandImpl other = (PostDicomInstanceToNewStructureCommandImpl) obj;

		// Check the unique fields
		boolean areFieldsEqual = areFieldsEqual(this.dds, other.dds);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.instanceChannel, other.instanceChannel);
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

		sb.append(this.dds.toString());
		sb.append(this.instanceChannel.toString());

		return sb.toString();
	}

	/**
	 * @param sourceAEAndPort
	 * @param router
	 * @param sopInstance
	 * @param token
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	private InstanceFile createInstanceFileEntry(String sourceAEAndPort, InternalDicomRouter router,
					SOPInstance sopInstance, String token) throws MethodException,
					ConnectionException {
		
        StorageDataSourceRouter storageDataSourceRouter = StorageContext.getDataSourceRouter();

		InstanceFile instanceFile = dds.getInstanceFile();
		instanceFile.setArtifactToken(token);
		instanceFile.setIsOriginal("1"); // Yes
		instanceFile.setIsConfidential("0"); // No
		instanceFile.setDeletedBy("");
		instanceFile.setDeleteDateTime("");
		instanceFile.setDeleteReason("");
		instanceFile.setCompressionMethod("none");
		instanceFile.setCompressionRatio("1.0");
		instanceFile.setDerivationDesc("original");

		instanceFile.setSOPInstanceIEN(sopInstance.getIEN());
        Artifact artifact = storageDataSourceRouter.getArtifactByToken(token);
        instanceFile.setArtifactFileId(artifact.getId()); // added 9/13/11
		instanceFile = router.postInstanceFile(sopInstance, instanceFile);
        logger.info("Instance File Created {}.", sourceAEAndPort);
		return instanceFile;
	}

	/**
	 * @param sourceAEAndPort
	 * @param sopInstance
	 * @param instanceFile
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	private void queueIconImageCreation(String sourceAEAndPort,SOPInstance sopInstance, InstanceFile instanceFile)
						throws MethodException, ConnectionException {
		RoutingToken routingToken = config.getRoutingToken();
		DurableQueue queue = InternalContext.getRouter().getDurableQueueByName(routingToken, ASYNC_ICON_QUEUE);
		Place place = StorageServerDatabaseConfiguration.getConfiguration().getPlace(getLocalSiteId());
		String initialRetryCount = "0";
		DurableQueueMessage message = new DurableQueueMessage(queue, Integer.toString(place.getId()), instanceFile.getArtifactToken() + "^" 
							+ sopInstance.getIEN() + "^" + sopInstance.getSOPClassUID() + "^" + initialRetryCount);	
		InternalContext.getRouter().enqueueDurableQueueMessage(routingToken, message);
        logger.info("Icon Image creation request queued {}.", sourceAEAndPort);
	}
}
