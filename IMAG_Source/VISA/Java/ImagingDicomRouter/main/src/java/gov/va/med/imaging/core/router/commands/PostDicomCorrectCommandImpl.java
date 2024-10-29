/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.GUID;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.core.interfaces.StorageCredentials;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.storage.StorageContext;
import gov.va.med.imaging.core.router.worklist.InternalWorkListRouter;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.dicom.common.exceptions.Part10FileException;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.WorkItemTag;
import gov.va.med.imaging.exchange.business.WorkListTypes;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomCorrectInfo;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.InstrumentConfig;
import gov.va.med.imaging.exchange.business.dicom.PatientStudyInfo;
import gov.va.med.imaging.exchange.business.dicom.PatientStudyLookupResults;
import gov.va.med.imaging.exchange.business.dicom.Series;
import gov.va.med.imaging.exchange.business.dicom.exceptions.DicomException;
import gov.va.med.imaging.exchange.business.dicom.importer.DicomCorrectFile;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItemFilter;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItemStatuses;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItemSubtypes;
import gov.va.med.imaging.exchange.business.storage.NetworkLocationInfo;
import gov.va.med.imaging.exchange.business.storage.Provider;
import gov.va.med.imaging.exchange.business.storage.StorageServerDatabaseConfiguration;
import gov.va.med.imaging.exchange.business.storage.exceptions.UpdateException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import gov.va.med.logging.Logger;

import com.sun.org.apache.xerces.internal.impl.dv.xs.FullDVFactory;

/**
 * This command is the driver for storing a DICOM instance. It performs validation
 * of the patient and imaging service request, check UIDs and coerces them if necessary,
 * determines whether the instance is an "old" or "new" SOP class, and stores the
 * instance appropriately.
 * 
 * @author vhaiswlouthj
 * 
 */
public class PostDicomCorrectCommandImpl extends AbstractDicomCommandImpl<Void>
{
	private static final long serialVersionUID = -4963797794965394068L;
	private static final DicomServerConfiguration config = DicomServerConfiguration.getConfiguration();
    private static Logger logger = Logger.getLogger(PostDicomCorrectCommandImpl.class);
    
	private final IDicomDataSet dds;
	private final DicomAE dicomAE;
	private InstrumentConfig instrument;
	private boolean isNetworkImport = false;
	private final PatientStudyLookupResults patientStudyLookupResults;

	private final InputStream inputStream;

	// DICOM import variables
	private final String originIndex;
	
	private DicomCorrectInfo dicomCorrectInfo;
	
	private String fullStagingPath = null;
	private String pathToCopyImageFrom = null;
	
	private static HashMap<String, ImporterWorkItem> stagingCache = new HashMap<String, ImporterWorkItem>();
	
	/**
	 * @param router
	 * @param asynchronousMethodProcessor
	 */
	public PostDicomCorrectCommandImpl(
			IDicomDataSet dds, 
			DicomAE dicomAE,
			PatientStudyLookupResults patientStudyLookupResults,
			InstrumentConfig instrument, 
			boolean isNetworkImport,
			String originIndex,
			InputStream inputStream)
	{
		super();
		this.dds = dds;
		this.dicomAE = dicomAE;
		this.instrument= instrument;
		this.isNetworkImport = isNetworkImport;
		this.inputStream = inputStream;
		this.patientStudyLookupResults = patientStudyLookupResults;
		this.originIndex = originIndex + "";
	}

	@Override
	public Void callSynchronouslyInTransactionContext() throws MethodException, ConnectionException
	{
		sendToDicomCorrect();
		return null;
	}
	
	private void sendToDicomCorrect() throws MethodException, ConnectionException
	{
		if(logger.isDebugEnabled()){logger.debug("Entering DICOM Correct");}
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		String siteID = DicomServerConfiguration.getConfiguration().getSiteId();
		transactionContext.setServicedSource(siteID);
		
		//This method gets specific information about the DICOM object from the dataset.
		dicomCorrectInfo = this.dds.getPartialDicomCorrectInfo();

		// See if this is a resend. If so, halt processing. 
		if (isResend(isNetworkImport))
		{
			if(logger.isDebugEnabled()){logger.debug("DICOM object already exists in a DICOM correct work item (it's a resend from the modality).");}
			return;
		}
		
		// Not a resend. Continue processing...
		// Get the AE Port and Thread ID for later error logging
		String aeTitle = dicomAE.getRemoteAETitle();
		int port = instrument.getPort();
		long threadId = Thread.currentThread().getId();
		String aePortAndThreadId= "[" + aeTitle + "->" + port + "/" + threadId + "]";
		
		try
		{
			// Find or create an ImporterWorkItem
			ImporterWorkItem importerWorkItem = findOrCreateImporterWorkItem(
					dds, dicomCorrectInfo, patientStudyLookupResults, 
					isNetworkImport, originIndex, instrument);
			
			// If the pathToCopyFrom is null (which is the normal case) it means we should write 
			// the image from the stream.
			//
			// If a sourcePath was provided, however, this means that we attempted to append
			// the image to an existing DICOM correct work item, but the work item changed status 
			// out from under us. In this case, just move the file from the old path to the new path.
			String fileNameBase = createUniqueFileNameBase();
			if (pathToCopyImageFrom == null)
			{
				if(logger.isDebugEnabled()){logger.debug("Writing DICOM object to the file system using the input stream.");}
				writeDicomStreamToPath(inputStream, importerWorkItem, fileNameBase);
			}
			else
			{
				if(logger.isDebugEnabled()){logger.debug("Copying the DICOM object to new work item. The original write failed because the work item changed status during the write.");}
				copyFileFromOldStagingDirectoryToNew(importerWorkItem, fileNameBase);
			}
			
			// Create the DicomCorrectFile record
			DicomCorrectFile dicomCorrectFile = createDicomCorrectFile(fileNameBase);

			// Build the tags and add them to a list
			List<WorkItemTag> dicomCorrectTags = dicomCorrectFile.encodeToTags(getStudySeriesSopUids());

			// Add the tags to the staging work item
			List<String> allowedStatuses = new ArrayList<String>();
			allowedStatuses.add(ImporterWorkItemStatuses.Staging);
			allowedStatuses.add(ImporterWorkItemStatuses.New);

			if(logger.isDebugEnabled()){logger.debug("Posting tags to the work item for this DICOM object.");}
			WorkListContext.getInternalRouter().postWorkItemTags(
					importerWorkItem.getId(), 
					allowedStatuses, 
					dicomCorrectTags, 
					"",
					"Importer:" + config.getHostName());
		

			// Update the work item status to "New" if it's currently "Staging"
			updateWorkItemStatusIfNecessary(importerWorkItem, dicomCorrectInfo, dicomCorrectTags);
			
		}
		catch (InvalidUserCredentialsException e)
		{
			// Just rethrow this one: it's fatal
			throw e;
		}
		catch (Part10FileException X)
		{
            logger.error("DICOM Correct: Could not create file for DICOM object {}.", aePortAndThreadId);
			throw new MethodException(X);
		}
		catch (IOException e)
		{
            logger.error("DICOM Correct: Could not create file for DICOM object {}.", aePortAndThreadId);
			throw new MethodException(e);
		}
		catch (UpdateException e)
		{
			// The status was changed out from under us. Go ahead and create a new workitem, 
			// sending the filename over to allow for a copy instead of a write from the stream.
			pathToCopyImageFrom = fullStagingPath;
			sendToDicomCorrect();
		}
		catch (Exception e)
		{
            logger.error("DICOM Correct: exception occurred {}.", aePortAndThreadId);
			throw new MethodException(e);
		}

        logger.warn("{}: DICOM object {} did not match a Patient/Study combination in VistA Imaging.  DICOM object is in queue for reconcilation.", this.getClass().getName(), dds.getSOPInstanceUID());

        logger.error("AETitle {}: DICOM Object {} did not match a Patient/Study combination in VistA Imaging. \nDICOM object is in queue for reconcilation.", dicomAE.getRemoteAETitle(), dds.getSOPInstanceUID());
		
	}
	
	private static synchronized ImporterWorkItem findOrCreateImporterWorkItem(
			IDicomDataSet dds,
			DicomCorrectInfo dicomCorrectInfo, 
			PatientStudyLookupResults patientStudyLookupResults,
			boolean isNetworkImport,
			String originIndex,
			InstrumentConfig instrument) throws MethodException, ConnectionException, DicomException, IOException
	{
		//
		// If we find a work item in the staging cache (in the database with a status of Staging) return it.
		//
		String stagingCacheKey = getStagingCacheKey(dicomCorrectInfo);
		if (stagingCache.containsKey(stagingCacheKey))
		{
			if(logger.isDebugEnabled()){logger.debug("Using an existing work item found in the staging cache.");}
			return stagingCache.get(stagingCacheKey);
		}
		
		//
		// If we find a work item in the database in New status, return it.
		//
		ImporterWorkItem importerWorkItem = findDicomCorrectWorkItem(dicomCorrectInfo, ImporterWorkItemStatuses.New, isNetworkImport);
		if (importerWorkItem != null)
		{
			if(logger.isDebugEnabled()){logger.debug("Using an existing work item found in the database.");}
			return importerWorkItem;
		}
		
		//
		// We didn't find an existing one in either Staging or New status. We need to create a new one in 
		// Staging status, and store it in the staging cache.
		//
		if(logger.isDebugEnabled()){logger.debug("No work item found in a suitable status. Creating a new one.");}
		
		// Find the current write location
		StorageServerDatabaseConfiguration storageConfig = StorageServerDatabaseConfiguration.getConfiguration();
		Provider provider = storageConfig.getPrimaryStorageProviderForSite(config.getSiteId());
		NetworkLocationInfo networkLocationInfo = StorageContext.getDataSourceRouter().getCurrentWriteLocation(provider);
			
		String networkLocationIen = networkLocationInfo.getNetworkLocationIEN();
		String serverPath = networkLocationInfo.getPhysicalPath();
		
		if (!serverPath.endsWith("\\"))
		{
			serverPath += "\\";
		}
			
		// Create a path for the study
		String mediaBundleStagingRootDirectory = getMediaBundleStagingRootDirectory(isNetworkImport);
			
		PatientStudyInfo patientStudyInfo = dds.getPatientStudyInfo(instrument);

		importerWorkItem = ImporterWorkItem.createDicomCorrectWorkItem(
				getDicomCorrectSubtype(isNetworkImport), 
				config.getHostName(), 
				dicomCorrectInfo.getPatientName(),
				dicomCorrectInfo.getAccessionNumber(),
				dicomCorrectInfo.getStudyUID(),
				dicomCorrectInfo.getPid(),
				patientStudyInfo.getPatientBirthDate(),
				patientStudyInfo.getPatientSex(),
				ImporterWorkItemStatuses.Staging, 
				getUpdatingSystem(), 
				Integer.parseInt(networkLocationIen),
				dds.getStudy().getStudyDate(),
				dds.getStudy().getStudyTime(),
				dds.getStudy().getDescription(),
				mediaBundleStagingRootDirectory,
				config.getSiteId(),
				originIndex,
				instrument);
		
		if (!isNetworkImport)
		{
			importerWorkItem.getWorkItemDetails().setDicomCorrectReason(getDicomCorrectReason(patientStudyLookupResults));
		}
		
		importerWorkItem.getWorkItemDetails().setInstrumentNickName(instrument.getNickName());

		// Convert to a raw work item
		WorkItem workItem = importerWorkItem.getRawWorkItem();

		// Serialize the workItemDetails object to the standard file on the share
		writeWorkItemDetailsToDisk(networkLocationInfo, 
				importerWorkItem, 
				importerWorkItem.getWorkItemDetailsReference().getMediaBundleStagingRootDirectory());

		// Create the work item in VistA
		WorkItem rawWorkItem = WorkListContext.getInternalRouter().createWorkItem(workItem);
		
		importerWorkItem.setId(rawWorkItem.getId());
		
		// Add the reference to the stagingCache and return it
		stagingCache.put(stagingCacheKey, importerWorkItem);
		return importerWorkItem;
	}
	
	private static synchronized void updateWorkItemStatusIfNecessary(ImporterWorkItem importerWorkItem, DicomCorrectInfo dicomCorrectInfo, List<WorkItemTag> dicomCorrectTags) 
			throws MethodException, ConnectionException
	{
		//
		// If we find the work item still in the staging cache, we just finished writing the first DICOM file to the 
		// disk under this work item. Update the status to New so that the work item shows up in the GUI, and remove
		// the item from the cache
		//
		String stagingCacheKey = getStagingCacheKey(dicomCorrectInfo);
		if (stagingCache.containsKey(stagingCacheKey))
		{
			if(logger.isDebugEnabled()){logger.debug("The first DICOM object has been successfully written to this work item. Promoting the status from Staging to New.");}

			// Remove from the cache
			stagingCache.remove(stagingCacheKey);
		
			// Update the status to New
			WorkListContext.getInternalRouter().updateWorkItem(
					importerWorkItem.getId(), 
					ImporterWorkItemStatuses.Staging, 
					ImporterWorkItemStatuses.New, 
					importerWorkItem.getRawWorkItem().getMessage(), 
					"", 
					getUpdatingSystem());
		}
	}
	
	private DicomCorrectFile createDicomCorrectFile(String fileNameBase) 
	{
		// Get data for the tags
		Series series = dds.getSeries(new DicomAE(),instrument);
		DicomCorrectFile dicomCorrectFile = new DicomCorrectFile(
				dds.getStudyInstanceUID(), 
				dds.getSeriesInstanceUID(),
				dds.getSOPInstanceUID(), 
				series.getDescription(),
				series.getSeriesDateTime(),
				series.getModality(),
				series.getSeriesNumber(),
				dds.getReceivedTransferSyntax(),
				series.getFacility(),
				series.getInstitutionAddress(),
				fileNameBase);

		return dicomCorrectFile;
	}

	private static ImporterWorkItem findDicomCorrectWorkItem(DicomCorrectInfo dicomCorrectInfo, String status, boolean isNetworkImport) 
	throws MethodException, ConnectionException 
	{
		ImporterWorkItem importerWorkItem = null;
		InternalWorkListRouter router = WorkListContext.getInternalRouter();

		ImporterWorkItemFilter filter = new ImporterWorkItemFilter();
		filter.setType(WorkListTypes.DicomImporter);
		filter.setPlaceId(config.getSiteId());
		filter.setSubtype(getDicomCorrectSubtype(isNetworkImport));
		filter.setStatus(status);
		filter.setAccessionNumber(dicomCorrectInfo.getAccessionNumber());
		filter.setStudyUid(dicomCorrectInfo.getStudyUID());
		filter.setPatientId(dicomCorrectInfo.getPid());
		
		List<WorkItem> workItems = router.getWorkItemList(filter.getRawWorkItemFilter());
		
		if (workItems != null && workItems.size() > 0)
		{
			// The find call only returns the header - no WorkItemDetails. Get the full raw workitem and convert it to 
			// an ImporterWorkItem
			WorkItem item = workItems.get(0);
			item = router.getAndTransitionWorkItem(item.getId(), item.getStatus(), item.getStatus(), item.getUpdatingUser(), item.getUpdatingApplication());
			importerWorkItem = ImporterWorkItem.buildShallowImporterWorkItem(item);

		}
		
		return importerWorkItem;
	}
	
	/**
	 * Builds a key for use in the stagingCache
	 * @param dicomCorrectInfo
	 * @return
	 */
	private static String getStagingCacheKey(DicomCorrectInfo dicomCorrectInfo)
	{
		String accessionNumber = dicomCorrectInfo.getAccessionNumber();
		String patientId = dicomCorrectInfo.getPid();
		String studyUid = dicomCorrectInfo.getStudyUID();
		
		return accessionNumber + "_" + patientId + "_" + studyUid;
	}

	/**
	 * Return the correct subtype (DICOM Correct or NetworkImport)
	 * @param isNetworkImport
	 * @return
	 */
	private static String getDicomCorrectSubtype(boolean isNetworkImport) 
	{
		return isNetworkImport ? 
				ImporterWorkItemSubtypes.NetworkImport : 
				ImporterWorkItemSubtypes.DicomCorrect;
	}

	/**
	 * Get the updating system name, which is "Importer:hostName"
	 * @return
	 */
	private static String getUpdatingSystem() {
		return "Importer:" + config.getHostName();
	}
	
	/**
	 * Build a string containing the DICOM correct reason for later display in the GUI
	 * 
	 * @param patientStudyLookupResults
	 * @return
	 */
	private static String getDicomCorrectReason(PatientStudyLookupResults patientStudyLookupResults) 
	{
		StringBuilder sb = new StringBuilder();
		
		for (String messageLine : patientStudyLookupResults.getErrorMessages())
		{

			// Only add the line if it's an actual message and not a code.
			if (!messageLine.startsWith("-"))
			{
				// Add a comma and space before the next line if not the first message line
				if (sb.length() > 0)
					sb.append(", ");

				sb.append(messageLine);
			}
		}
		
		return sb.toString();
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

	/**
	 * Checks to see if this instance is already present in a DICOM correct work item
	 * 
	 * @param isNetworkImport
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	private boolean isResend(boolean isNetworkImport) 
	throws MethodException, ConnectionException 
	{
		InternalWorkListRouter router = WorkListContext.getInternalRouter();
		ImporterWorkItemFilter filter = new ImporterWorkItemFilter();
		
		filter.setType(WorkListTypes.DicomImporter);
		filter.setSubtype(getDicomCorrectSubtype(isNetworkImport));
		filter.setStatus("New");
		filter.setAccessionNumber(dicomCorrectInfo.getAccessionNumber());
		filter.setStudySeriesSopUids(getStudySeriesSopUids());
		filter.setPatientId(dicomCorrectInfo.getPid());
		
		List<WorkItem> workItems = router.getWorkItemList(filter.getRawWorkItemFilter());
		
		if (workItems != null && workItems.size() > 0)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	/**
	 * Get the concatenated study, series, and sop instance UIDs for use in checking for
	 * a resend.
	 * 
	 * @return
	 */
	private String getStudySeriesSopUids() 
	{
		return 	dds.getStudyInstanceUID() + "_" + 
        	    dds.getSeriesInstanceUID() + "_" +
        	    dds.getSOPInstanceUID();
	}

	/**
	 * Write the DICOM stream to the staging directory
	 * 
	 * @param inputStream
	 * @param path
	 * @param writeLocationInfo
	 * @throws Part10FileException
	 * @throws IOException
	 * @throws ConnectionException 
	 * @throws MethodException 
	 */
	private void writeDicomStreamToPath(InputStream inputStream, ImporterWorkItem importerWorkItem, String fileNameBase) 
	throws Part10FileException, IOException, MethodException, ConnectionException 
	{
		// Find the write location for this work item
		String networkLocationIen = Integer.toString(importerWorkItem.getWorkItemDetailsReference().getNetworkLocationIen());
		NetworkLocationInfo networkLocationInfo = StorageContext.getDataSourceRouter().getNetworkLocationDetails(networkLocationIen);

		// Get the server path
		String serverPath = networkLocationInfo.getPhysicalPath();
		if (!serverPath.endsWith("\\"))
		{
			serverPath += "\\";
		}
			
		// Get the media bundle path
		String mediaBundleStagingRootDirectory = importerWorkItem.getWorkItemDetailsReference().getMediaBundleStagingRootDirectory();
		if (!mediaBundleStagingRootDirectory.endsWith("\\"))
		{
			mediaBundleStagingRootDirectory += "\\";
		}
			
		// Build the full path
		fullStagingPath = serverPath + mediaBundleStagingRootDirectory + fileNameBase + ".dcm";
		
		SmbStorageUtility util = new SmbStorageUtility();
		OutputStream targetFileStream = null;
		try{
			targetFileStream = util.openOutputStream(fullStagingPath, (StorageCredentials)networkLocationInfo);
	
			// funnel in stream to out stream
			ByteStreamPump bSP = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToFile);
			bSP.xfer(inputStream, targetFileStream);
			targetFileStream.flush();
			targetFileStream.close();
            logger.warn("Wrote file: {}", fullStagingPath);
		}
		catch(IOException ioX){
			if(targetFileStream != null){
				try{
					targetFileStream.close();
				}
				catch(Exception X){
					//ignore.
				}
				try{
					util.deleteFile(fullStagingPath, (StorageCredentials)networkLocationInfo);
				}
				catch(Exception X){
                    logger.error("{}: Failed to delete incomplete file {}", this.getClass().getName(), fullStagingPath);
				}
			}
			throw new IOException("Failed to write stream to path "+ fullStagingPath, ioX);
		}

	}
	
	private void copyFileFromOldStagingDirectoryToNew(ImporterWorkItem importerWorkItem, String fileNameBase) throws MethodException, ConnectionException
	{
		// Find the write location for this work item
		String networkLocationIen = Integer.toString(importerWorkItem.getWorkItemDetailsReference().getNetworkLocationIen());
		NetworkLocationInfo networkLocationInfo = StorageContext.getDataSourceRouter().getNetworkLocationDetails(networkLocationIen);

		// Get the server path
		String serverPath = networkLocationInfo.getPhysicalPath();
		if (!serverPath.endsWith("\\"))
		{
			serverPath += "\\";
		}
			
		// Get the media bundle path
		String mediaBundleStagingRootDirectory = importerWorkItem.getWorkItemDetailsReference().getMediaBundleStagingRootDirectory();
		if (!mediaBundleStagingRootDirectory.endsWith("\\"))
		{
			mediaBundleStagingRootDirectory += "\\";
		}
			
		// Build the full path
		fullStagingPath = serverPath + mediaBundleStagingRootDirectory + fileNameBase + ".dcm";
		
		SmbStorageUtility util = new SmbStorageUtility();
		
		try 
		{
            logger.info("Copying DICOM file from [{}] to [{}]", pathToCopyImageFrom, fullStagingPath);
			util.copyFile(pathToCopyImageFrom, fullStagingPath, (StorageCredentials)networkLocationInfo);
			util.deleteFile(pathToCopyImageFrom, (StorageCredentials)networkLocationInfo);
		} 
		catch (IOException e) 
		{
            logger.error("Error moving file [{}] to [{}]: {}", pathToCopyImageFrom, fullStagingPath, e.getStackTrace());
		}
	}

	/**
	 * Build the media bundle staging root directory name, including site id, subtype, etc.
	 * @param isNetworkImport
	 * @return
	 */
	private static String getMediaBundleStagingRootDirectory(boolean isNetworkImport) {
		
		// Create a path for the study
		String mediaBundleStagingRootDirectory = 
			"ImporterStaging\\" + 
			config.getSiteId() + "\\" + getDicomCorrectSubtype(isNetworkImport) + "\\" + 
			new GUID().toShortString() + "\\";
		
		return mediaBundleStagingRootDirectory;
		
	}

	/**
	 * Create a file name base, which is just a GUID
	 * 
	 * @return
	 */
	private static String createUniqueFileNameBase() 
	{
		return (new GUID().toShortString());
	}

	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.dds == null) ? 0 : this.dds.hashCode());
		result = prime * result + ((this.dicomAE == null) ? 0 : this.dicomAE.hashCode());
		result = prime * result + ((this.instrument == null) ? 0 : this.instrument.hashCode());
		
		return result;
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj)
	{
		// Perform cast for subsequent tests
		final PostDicomCorrectCommandImpl other = (PostDicomCorrectCommandImpl) obj;

		// Check the studyUrn
		boolean areFieldsEqual = areFieldsEqual(this.dds, other.dds);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.dicomAE, other.dicomAE);
		areFieldsEqual = areFieldsEqual && areFieldsEqual(this.instrument, other.instrument);
		
		return areFieldsEqual;
	}
}
