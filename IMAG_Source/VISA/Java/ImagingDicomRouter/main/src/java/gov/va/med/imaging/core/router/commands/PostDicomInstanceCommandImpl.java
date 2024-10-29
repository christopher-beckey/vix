/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.common.DicomFileMetaInfo;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.stats.DicomServiceStats;
import gov.va.med.imaging.dicom.dcftoolkit.common.DataSetByteReader;
import gov.va.med.imaging.dicom.dcftoolkit.common.mediainterchange.AbyssOutputStream;
import gov.va.med.imaging.dicom.dcftoolkit.common.mediainterchange.Part10Files;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.DicomStorageResults;
import gov.va.med.imaging.exchange.business.dicom.InstrumentConfig;
import gov.va.med.imaging.exchange.business.dicom.PatientStudyInfo;
import gov.va.med.imaging.exchange.business.dicom.PatientStudyLookupResults;
import gov.va.med.imaging.exchange.business.dicom.UIDCheckInfo;
import gov.va.med.imaging.exchange.business.dicom.UIDCheckResult;
import gov.va.med.imaging.exchange.business.dicom.UIDCheckResults;
import gov.va.med.imaging.exchange.business.dicom.DicomUtils;
import gov.va.med.imaging.exchange.business.dicom.exceptions.DicomException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.io.IOException;
import java.io.InputStream;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;

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
public class PostDicomInstanceCommandImpl extends AbstractDicomCommandImpl<DicomStorageResults>
{
	private static final long serialVersionUID = -4963797794965394068L;
	private static final String studyIUIDTag = "0008,0018";
	private static final String seriesIUIDTag = "0008,0018";
	private static final String sopIUIDTag = "0008,0018";
	private static final DicomServerConfiguration config = DicomServerConfiguration.getConfiguration();
    private static Logger logger = Logger.getLogger(PostDicomInstanceCommandImpl.class);
    private static final InternalDicomRouter router = InternalDicomContext.getRouter();

	private final IDicomDataSet dds;
	private final DicomAE dicomAE;
	private InstrumentConfig instrument;
	private final DicomFileMetaInfo metaData;
	private int iodValidationStatus;
	private boolean isAlreadyReconciled = false;
	
	// DICOM import variables
	private String originIndex = "";
	
	/**
	 * @param router
	 * @param asynchronousMethodProcessor
	 */
	public PostDicomInstanceCommandImpl(IDicomDataSet dds, 
			DicomAE dicomAE,
			InstrumentConfig instrument, 
			DicomFileMetaInfo metaData, 
			int iodValidationStatus, 
			boolean isAlreadyReconciled,
			String originIndex)
	{
		super();
		this.dds = dds;
		this.dicomAE = dicomAE;
		this.instrument= instrument;
		this.metaData = metaData; // if null it means dds is fed from a correctly stored Part10 file, else from DICOM feed
		this.iodValidationStatus = iodValidationStatus;
		this.isAlreadyReconciled = isAlreadyReconciled;
		
		// DICOM import fields
		this.originIndex = originIndex;
		
	}
	/**
	 * @param router
	 * @param asynchronousMethodProcessor
	 */
	public PostDicomInstanceCommandImpl(IDicomDataSet dds, 
			DicomAE dicomAE,
			InstrumentConfig instrument, 
			DicomFileMetaInfo metaData, 
			int iodValidationStatus)
	{
		super();
		this.dds = dds;
		this.dicomAE = dicomAE;
		this.instrument= instrument;
		this.metaData = metaData; // if null it means dds is fed from a correctly stored Part10 file, else from DICOM feed
		this.iodValidationStatus = iodValidationStatus;
		this.isAlreadyReconciled = false;
	}

	@Override
	public DicomStorageResults callSynchronouslyInTransactionContext() throws MethodException, ConnectionException
	{
        logger.info("{}: Executing Router command.", this.getClass().getName());
		
		validateAndCorrectInstrumentIfNecessary();
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		String siteID = DicomServerConfiguration.getConfiguration().getSiteId();
		transactionContext.setServicedSource(siteID);
		
		UIDCheckResults uidCheckResults = null;
		String sAEPortAndThreadID= "[" + dicomAE.getRemoteAETitle() + "->" + 
								   instrument.getPort() + "/" + Long.toString(Thread.currentThread().getId()) + "]";

		// Set the origin index from the AE, but only if it has not yet been set. We don't want to
		// overwrite the origin index of things coming in through DICOM correct, etc.
		if (originIndex == null || originIndex.trim().equals(""))
		{
			originIndex = dicomAE.getOriginIndex();
			
			// if it's still empty or null, default to VA
			if (originIndex == null || originIndex.trim().equals(""))
			{
				originIndex = "V";
			}
		}
		DataSetByteReader dbr = null;
		ReadableByteChannel ddsMessageChannel = null;
		InputStream ddsInputStream = null;
		InputStream dbrInputStream = null;
		
    	try
		{	
			if (dicomAE.isForceReconciliation() && !isAlreadyReconciled)
			{
				// This is a network import that has not already been through reconciliation. 
            	// Send object straight to DICOM correct.
				if(logger.isDebugEnabled()){logger.debug("Detected a network import. Sending to DICOM correct for reconciliation.");}
				dbr = Part10Files.getDicomFileReadableByteChannel(dds, metaData);
				
				// Fortify change: created and stored into local variable to close later; second round
				dbrInputStream = dbr.getInputStream();
				
				ddsMessageChannel = Channels.newChannel(dbrInputStream);
				ddsInputStream = Part10Files.getDicomFileInputStream(ddsMessageChannel);
				router.postDicomCorrect(dds, dicomAE, null, instrument, true, originIndex, ddsInputStream);
			}
			else {
				//
				// Check the patient study info. If OK, continue. Otherwise, send to DICOM correct
				PatientStudyInfo patientStudyInfo = dds.getPatientStudyInfo(instrument);
				patientStudyInfo.setSiteID(siteID);

				if(logger.isDebugEnabled()){logger.debug("Performing patient/study lookup.");}
				PatientStudyLookupResults patientStudyLookupResults = router.getPatientStudyLookupResults(patientStudyInfo);
	
				// If Patient Study lookup passed, continue processing. Otherwise, send to DICOM correct
				if (patientStudyLookupResults.isOk())
				{
					// Patient/Order lookup is OK. Check for duplicate Instance UIDs and/or a SOP instance resend; 
					// Correct the UIDs if necessary.
					if(logger.isDebugEnabled()){logger.debug("Patient/study lookup successful. Checking and correcting UIDs.");}
					uidCheckResults = checkAndCorrectUIDs(patientStudyLookupResults.getPatienStudyInfo(), instrument, sAEPortAndThreadID);
					
					dbr = Part10Files.getDicomFileReadableByteChannel(dds, metaData);
					
					// Fortify change: created and stored into local variable to close later; second round
					dbrInputStream = dbr.getInputStream();
					
					ddsMessageChannel = Channels.newChannel(dbrInputStream);
					ddsInputStream = Part10Files.getDicomFileInputStream(ddsMessageChannel);

					// If this is not a SOP resend, go ahead and store the instance.
					if (!uidCheckResults.isSOPInstanceResend())
					{
						if(logger.isDebugEnabled()){logger.debug("Not a resend. Begin storage processing.");}
						storeInstance(dicomAE, patientStudyLookupResults, uidCheckResults, iodValidationStatus, ddsMessageChannel, ddsInputStream);
	
					}
					else{
						//This input stream is a throw away because it is a duplicate.
						writeStreamToAbyss(ddsInputStream);
					}
					// see all error handling in receiveIOD (DICOMStorageSCPImpl)
				}
				else	// Patient/Study lookup failed
				{
                    logger.warn("{} Patient/Order lookup failed: ", sAEPortAndThreadID);
					for (String errorMessage : patientStudyLookupResults.getErrorMessages())
					{
                        logger.warn("{} * {}", sAEPortAndThreadID, errorMessage);
					}
                    logger.warn("{}   Pid={}; Case#={}", sAEPortAndThreadID, patientStudyInfo.getPatientID(), patientStudyInfo.getStudyAccessionNumber());
	
					// Network imports = forced reconciliation
					boolean isNetworkImport = dicomAE.isForceReconciliation() ? true : false;
					dbr = Part10Files.getDicomFileReadableByteChannel(dds, metaData);
					
					// Fortify change: created and stored into local variable to close later; second round
					dbrInputStream = dbr.getInputStream();
					
					ddsMessageChannel = Channels.newChannel(dbrInputStream);

					ddsInputStream = Part10Files.getDicomFileInputStream(ddsMessageChannel);
					router.postDicomCorrect(dds, dicomAE, patientStudyLookupResults, instrument, isNetworkImport, originIndex, ddsInputStream);
				}
			}

		}
		catch (InvalidUserCredentialsException e){
			// Just rethrow this one: it's fatal
			throw e;
		}  // QN: Don't need these two.
		catch (ConnectionException cX){
			throw new ConnectionException(cX);
		}
		catch (MethodException mX){
			throw new MethodException(mX);
		}
		catch (Exception e)
		{
			logger.error(e.getMessage(), e);
			throw new MethodException(e);
		}
		finally
		{
			// Fortify change: check for null first, added closing of 'dbrInputStream' for second round
        	// OLD:
           /* 
			try {
				ddsInputStream.close();
				ddsMessageChannel.close();
				dbr.closeInputStream();
				ddsInputStream = null;
				ddsMessageChannel = null;
				dbr = null;
			} 
			catch (Exception X) {
				logger.error(this.getClass().getName()+" :"+X.getMessage(), X);
			}
			*/
			try{ if(dbrInputStream != null) { dbrInputStream.close(); } } catch(Exception exc) {
                logger.error("{} :{}", this.getClass().getName(), exc.getMessage(), exc);}
			
        	try{ if(ddsInputStream != null) { ddsInputStream.close(); } } catch(Exception exc) {
                logger.error("{} :{}", this.getClass().getName(), exc.getMessage(), exc);}
        	
        	try{ if(ddsMessageChannel != null) { ddsMessageChannel.close(); } } catch(Exception exc) {
                logger.error("{} :{}", this.getClass().getName(), exc.getMessage(), exc);}
        	
        	try{ if(dbr != null) { dbr.closeInputStream(); } } catch(Exception exc) {
                logger.error("{} :{}", this.getClass().getName(), exc.getMessage(), exc);}
        	
		}
    	
		return new DicomStorageResults(uidCheckResults);
	}

	
	private void validateAndCorrectInstrumentIfNecessary() 
	{
		String accessionNumber = dds.getStudy().getAccessionNumber() + "";
		DicomUtils du = new DicomUtils();
		String serviceFromAccessionNumber = du.getServiceFromAccessionNumber(accessionNumber); // "RAD", "CON" or "LAB";
		String serviceFromInstrument = instrument.getService();

		// If the correct service based on the accession number does not match the instrument it came in on, 
		// find an instrument of the correct type and replace it.
		if (!serviceFromInstrument.equals(serviceFromAccessionNumber))
		{
			switchToValidInstrumentForService(serviceFromAccessionNumber);
		}
		
	}
	private void switchToValidInstrumentForService(String serviceFromAccessionNumber) 
	{
		for (InstrumentConfig currentInstrument : config.getInstruments())
		{
			if (currentInstrument.getService().equals(serviceFromAccessionNumber))
			{
				instrument = currentInstrument;
				break;
			}
		}
	}
	
	private UIDCheckResults checkAndCorrectUIDs(PatientStudyInfo patientStudyInfo, InstrumentConfig instrument, String context) throws MethodException, ConnectionException
	{
		// Get the incoming UIDs
		String studyUID = dds.getStudyInstanceUID();
		String seriesUID = dds.getSeriesInstanceUID();
		String sopInstanceUID = dds.getSOPInstanceUID();

		//Prep for statistical information
		String manufacturer = "";
		String model = "";
		try{
			manufacturer = dds.getDicomElement("0008,0070").getStringValue();
			model = dds.getDicomElement("0008,1090").getStringValue();
		}
		catch(Exception X){
			//Nothing needs to be done.
		}
		
		UIDCheckInfo uidCheckInfo = new UIDCheckInfo(patientStudyInfo.getPatientDFN(), patientStudyInfo.getStudyAccessionNumber(), patientStudyInfo.getSiteID(), instrument.getNickName(), studyUID, seriesUID, sopInstanceUID);

		// Get the individual UID Check Result objects
		UIDCheckResult studyResult = router.getStudyUIDCheckResult(uidCheckInfo);
		UIDCheckResult seriesResult = router.getSeriesUIDCheckResult(uidCheckInfo);
		UIDCheckResult sopInstanceResult = router.getSOPInstanceUIDCheckResult(uidCheckInfo);

		UIDCheckResults uidCheckResults = new UIDCheckResults(studyResult, seriesResult, sopInstanceResult);

		boolean isUIDDuplicated = false;
		// Only bother to fix the UIDs in the Stream if this is not a resend
		if (!uidCheckResults.isSOPInstanceResend())
		{
			// Fix the StudyUID if necessary
			if (studyResult.isDuplicateUID() || studyResult.isIllegalUID())
			{
				dds.insertToOriginalAttributeSequence(studyIUIDTag, studyResult.getOriginalUID(), context);
				dds.setStudyInstanceUID(studyResult.getCorrectedUID());
				isUIDDuplicated = true;
			}
	
			// Fix the SeriesUID if necessary
			if (seriesResult.isDuplicateUID() || seriesResult.isIllegalUID())
			{
				dds.insertToOriginalAttributeSequence(seriesIUIDTag, seriesResult.getOriginalUID(), context);
				dds.setSeriesInstanceUID(seriesResult.getCorrectedUID());
				isUIDDuplicated = true;
			}
	
			// Fix the SOPInstanceUID if necessary
			if (sopInstanceResult.isDuplicateUID() || sopInstanceResult.isIllegalUID())
			{
				dds.insertToOriginalAttributeSequence(sopIUIDTag, sopInstanceResult.getOriginalUID(), context);
				dds.setSOPInstanceUID(sopInstanceResult.getCorrectedUID());
				isUIDDuplicated = true;
			}
			if(isUIDDuplicated){
				DicomServiceStats.getInstance().incrementDuplicateInstanceUIDsCount(manufacturer, model);
			}
		}
		return uidCheckResults;
	}

	private void storeInstance(DicomAE dicomAE, PatientStudyLookupResults patientStudyLookupResults,
								UIDCheckResults uidCheckResults, int iodValidationStatus, 
								ReadableByteChannel ddsMessageChannel, InputStream ddsInputStream)
										throws DicomException, MethodException, ConnectionException
	{
		String sAEPortAndThreadID= "[" + dicomAE.getRemoteAETitle() + "->" + 
		   instrument.getPort() + "/" + Long.toString(Thread.currentThread().getId()) + "]";

		String theSOP = dds.getDicomElement("0008,0016").getStringValue();
		String theMty = dds.getDicomElement("0008,0060").getStringValue();
		//	DicomDataSet must turn to stream only after last modification!

		
		// SOP SWITCHING: If this is an instance of an "old" SOP class, call the command to send it to 2005.
		//                Otherwise, send it to the new DB structure
		//
		// NOTE: Only if the "ignoreSopSwitch" flag is set true in DicomServewrConfiguration.config
		// 		 send all SOPs to new structure! 
		//	
		if ((!config.isIgnoreSopSwitch()) && config.isCurrentStorageSOPClass(theSOP))
		{
			// Store in 2005 -- only P99 Known SOPs
            logger.info("Previously supported SOP class ({}[{}]) detected. Delegating to 2005 processing command {}.", theSOP, theMty, sAEPortAndThreadID);
            logger.info("{}: Sending DICOM object {} to legacy DICOM Gateway for processing.", this.getClass().getName(), dds.getSOPInstanceUID());
			router.postDicomInstanceTo2005(dds, dicomAE, instrument, ddsMessageChannel, 
					ddsInputStream, originIndex);
	        DicomServiceStats.getInstance().incrementInboundObjectsPassedToLegacyGWCount(dds.getSourceAET());
		}
		else
		{
            logger.info("New SOP class ({}[{}]) is being stored to the new structure  {}.", theSOP, theMty, sAEPortAndThreadID);
			// Store in new structure
			router.postDicomInstanceToNewStructure(dds, dicomAE, patientStudyLookupResults, 
					uidCheckResults, instrument, iodValidationStatus, ddsMessageChannel, 
					ddsInputStream, originIndex);
	        DicomServiceStats.getInstance().incrementInboundObjectsPassedToHDIGDataStructureCount(dds.getSourceAET());			
		}
	}
	
	/**
	 * Ran into a problem with duplicate objects.  Duplicate objects are not written/stored to any output.
	 * This causes a problem with the DataSetByteReader.  DataSetByteReader throws a bunch of exceptions
	 * in the log.  Basically, the object must be dumped from the InputStream to somewhere.
	 * It is the intent for this to be a temporary solution until we have time to speak with Laurel Bridge.
	 * 
	 * @param inputStream
	 */
	private void writeStreamToAbyss(InputStream inputStream){
		
		AbyssOutputStream abyss = new AbyssOutputStream();
		ByteStreamPump bSP = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToByteArray);
		try {
			bSP.xfer(inputStream, abyss);
		} 
		catch (IllegalArgumentException e) {
			//do nothing
		} 
		catch (IOException e) {
			//do nothing
		}
	}

	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.dds == null) ? 0 : this.dds.hashCode());
		result = prime * result + ((this.dicomAE == null) ? 0 : this.dicomAE.hashCode());
		result = prime * result + ((this.instrument == null) ? 0 : this.instrument.hashCode());
		result = prime * result + ((this.metaData == null) ? 0 : this.metaData.hashCode());
		
		return result;
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj)
	{
		// Perform cast for subsequent tests
		final PostDicomInstanceCommandImpl other = (PostDicomInstanceCommandImpl) obj;

		// Check the studyUrn
		boolean areFieldsEqual = areFieldsEqual(this.dds, other.dds);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.dicomAE, other.dicomAE);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.instrument, other.instrument);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.metaData, other.metaData);
		
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
		sb.append(this.dicomAE.toString());

		return sb.toString();
	}
}
