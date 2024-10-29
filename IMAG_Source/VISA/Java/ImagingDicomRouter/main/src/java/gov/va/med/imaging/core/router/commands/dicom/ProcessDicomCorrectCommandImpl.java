/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: 
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswpeterb
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

*/

package gov.va.med.imaging.core.router.commands.dicom;

import gov.va.med.imaging.GUID;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.StorageCredentials;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.Command;
import gov.va.med.imaging.core.router.PeriodicCommandList;
import gov.va.med.imaging.core.router.commands.AbstractDicomCommandImpl;
import gov.va.med.imaging.core.router.storage.StorageContext;
import gov.va.med.imaging.core.router.storage.StorageDataSourceRouter;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.datasource.DicomImporterDataSourceSpi;
import gov.va.med.imaging.dicom.DicomContext;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.stats.DicomServiceStats;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomStorageSCPException;
import gov.va.med.imaging.dicom.dcftoolkit.common.mediainterchange.ReadPart10FileWorkUnit;
import gov.va.med.imaging.dicom.dcftoolkit.common.validation.DoIODValidationImpl;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.exchange.business.EmailMessage;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.WorkItemCounts;
import gov.va.med.imaging.exchange.business.WorkItemFilter;
import gov.va.med.imaging.exchange.business.WorkListTypes;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomCorrectEntry;
import gov.va.med.imaging.exchange.business.dicom.DicomCorrectInfo;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.DicomStorageResults;
import gov.va.med.imaging.exchange.business.dicom.DicomUid;
import gov.va.med.imaging.exchange.business.dicom.DicomUtils;
import gov.va.med.imaging.exchange.business.dicom.ImporterPurgeDelays;
import gov.va.med.imaging.exchange.business.dicom.InstrumentConfig;
import gov.va.med.imaging.exchange.business.dicom.UIDCheckResults;
import gov.va.med.imaging.exchange.business.dicom.exceptions.DicomException;
import gov.va.med.imaging.exchange.business.dicom.exceptions.IODViolationException;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItemDetails;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItemStatuses;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItemSubtypes;
import gov.va.med.imaging.exchange.business.dicom.importer.NonDicomFile;
import gov.va.med.imaging.exchange.business.dicom.importer.Order;
import gov.va.med.imaging.exchange.business.dicom.importer.OrderFilter;
import gov.va.med.imaging.exchange.business.dicom.importer.Procedure;
import gov.va.med.imaging.exchange.business.dicom.importer.Reconciliation;
import gov.va.med.imaging.exchange.business.dicom.importer.Series;
import gov.va.med.imaging.exchange.business.dicom.importer.SopInstance;
import gov.va.med.imaging.exchange.business.dicom.importer.StatusChangeDetails;
import gov.va.med.imaging.exchange.business.dicom.importer.Study;
import gov.va.med.imaging.exchange.business.storage.NetworkLocationInfo;
import gov.va.med.imaging.notifications.NotificationFacade;
import gov.va.med.imaging.notifications.NotificationTypes;
import gov.va.med.imaging.retry.RetryableWorkUnitCommand;
import gov.va.med.imaging.router.commands.dicom.provider.DicomCommandContext;
import gov.va.med.imaging.utils.ExceptionUtilities;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;

import gov.va.med.logging.Logger;

import com.lbs.DCS.DCSException;
import com.lbs.DCS.DicomFileInput;

@RouterCommandExecution(asynchronous = true, distributable = false)
public class ProcessDicomCorrectCommandImpl extends
		AbstractDicomCommandImpl<Boolean> {

	private static final String COMPLETE = "COMPLETE";
	private static final String EXAMINED = "EXAMINED";
	private static final long serialVersionUID = -6437742324303531927L;
	private static final DicomServerConfiguration config = DicomServerConfiguration.getConfiguration();
    private static final InternalDicomRouter router = InternalDicomContext.getRouter();	
    private static final StorageDataSourceRouter storageRouter = StorageContext.getDataSourceRouter();	
    
    //private int purgeDelayDays = 7;

	private Logger logger = Logger.getLogger(this.getClass());
	
	public ProcessDicomCorrectCommandImpl() {
	}

	@Override
	public Boolean callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException 
	{
		// Wait until DICOM listener is started
		if (!config.isDicomStarted()) 
		{
			logger.warn("Unable to process importer work items. DICOM services failed to initialize on this HDIG");
			return true; 
		}

		// If other instances are running, and I am NOT marked as terminated, 
		// mark the other instances as terminated and then sleep till they're dead
		if (PeriodicCommandList.get().isAnotherInstancePresent(this) && !this.isPeriodicProcessingTerminated())
		{
			if(logger.isDebugEnabled()){logger.debug("Sleeping because there are other instances of ProcessDicomCorrect currently running...");}
			PeriodicCommandList.get().terminateOtherInstances(this);
			return true;
		}
		
		// Look for and process requests that were in process by me, but interrupted midstream by 
		// a server shutdown, etc.
		try
		{
			if(logger.isDebugEnabled()){logger.debug("Searching for interrupted work items to continue processing");}
			processHungImporterRequests();
		}
		catch (Exception e)
		{
			logger.error("Error processing hung requests", e);
			rethrowIfFatalException(e);
		}
		
		// Process Purge Requests
		try
		{
			if(logger.isDebugEnabled()){logger.debug("Looking for work items to purge");}
			processPurgeRequests();
		}
		catch (Exception e)
		{
			logger.error("Error processing importer purge requests", e);
			rethrowIfFatalException(e);
		}
		
		// Process Normal Import Requests
		try
		{
			processImporterRequests();
		}
		catch (Exception e)
		{
			logger.error("Error processing import requests", e);
			rethrowIfFatalException(e);
		}
		
		// Update DICOM correct and Importer statistics...
		try
		{
			if(logger.isDebugEnabled()){logger.debug("Updating DICOM Correct statistics");}
			updateDicomCorrectStatistics();
		}
		catch (Exception e)
		{
			logger.error("Error updating Importer and DICOM Correct statistics", e);
			rethrowIfFatalException(e);
		}
		
		// Done with all work for now...
		logger.info("Importer processing complete. Back to sleep...");
		return true;
		
	}

	private void processHungImporterRequests() throws MethodException
	{
		ImporterWorkItem importerWorkItem = getHungImporterWorkItem();
		
		while(importerWorkItem != null)
		{
			try
			{
				// We have a hung work item to continue processing. Get the network location info so we can read the files
				String networkLocationIen = Integer.toString(importerWorkItem.getWorkItemDetails().getNetworkLocationIen());
				NetworkLocationInfo networkLocationInfo = storageRouter.getNetworkLocationDetails(networkLocationIen);
	
				// Preprocess the work item and remove objects from the study list that no longer exist on disk
				preprocessResumedHungWorkItem(importerWorkItem, networkLocationInfo);
				
				// Now that it's cleaned up, just pass it back to the normal work item processing flow
				processWorkItem(importerWorkItem, networkLocationInfo);
			}
			catch (Exception e)
			{
				String message = "Error processing hung work item";
				
				if (importerWorkItem != null)
					message += " with id = " + importerWorkItem.getId();
				
				logger.error(message, e);
				
				// Rethrow the exception if it's fatal
				rethrowIfFatalException(e);
			}

			// Get the next hung work item, if any
			importerWorkItem = getHungImporterWorkItem();
		}

	}
	
	/**
	 * This class preprocess a hung work item, removing references for instances/series/studies 
	 * that have already been processed
	 * @param importerWorkItem
	 * @throws ConnectionException 
	 * @throws MethodException 
	 * @throws IOException 
	 */
	private void preprocessResumedHungWorkItem(ImporterWorkItem importerWorkItem, NetworkLocationInfo networkLocationInfo) 
	throws MethodException, ConnectionException, IOException 
	{
		if(logger.isDebugEnabled()){logger.debug("Found a hung work item. Preprocessing it.");}

		ImporterWorkItemDetails workItemDetails = importerWorkItem.getWorkItemDetails();
		
		// Create an iterator over the Studies in this WorkItem
		Iterator<Study> studyIterator = workItemDetails.getStudies().iterator();
		while (studyIterator.hasNext())
		{
			Study study = studyIterator.next();
			
			// Create an iterator over the Series in this Study
			Iterator<Series> seriesIterator = study.getSeries().iterator();
			while (seriesIterator.hasNext())
			{
				Series series = seriesIterator.next();

				// Create an iterator over the SopInstances in this series
				Iterator<SopInstance> sopInstanceIterator = series.getSopInstances().iterator();
				while (sopInstanceIterator.hasNext())
				{
					SopInstance instance = sopInstanceIterator.next();
					
					// If the image doesn't exist on disk, remove the SopInstance reference from the 
					// Study list, as this image has already been dealt with
					String instancePath = getInstancePath(networkLocationInfo, workItemDetails.getMediaBundleStagingRootDirectory(), instance);
					SmbStorageUtility util = new SmbStorageUtility();
					if (!util.fileExists(instancePath, (StorageCredentials)networkLocationInfo))
					{
						sopInstanceIterator.remove();
					}
				}
				
				// If the series is now empty, remove it
				if(series.getSopInstances()==null || series.getSopInstances().size() == 0)
				{
					seriesIterator.remove();
				}

			}
			
			// If the study is now empty, remove it
			if(study.getSeries()==null || study.getSeries().size() == 0)
			{
				studyIterator.remove();
			}
		}
	}

	private void processImporterRequests() throws MethodException
	{
		logger.info("Checking for DICOM Importer work items to process.");
		ImporterWorkItem importerWorkItem = getNextImporterWorkItem();
		
		while(importerWorkItem != null)
		{
			if(logger.isDebugEnabled()){
                logger.debug("Processing work item with IEN {}", importerWorkItem.getId());}

			try
			{
				// We have a work item to process. Get the network location info so we can read the files
				String networkLocationIen = Integer.toString(importerWorkItem.getWorkItemDetails().getNetworkLocationIen());
				NetworkLocationInfo networkLocationInfo = storageRouter.getNetworkLocationDetails(networkLocationIen);
	
				// Process the current work item
				processWorkItem(importerWorkItem, networkLocationInfo);
			}
			catch (Exception e)
			{
				String message = "Error processing work item";
				
				if (importerWorkItem != null)
					message += " with id = " + importerWorkItem.getId();
				
				logger.error(message, e);
				
				// Rethrow the exception if it's fatal
				rethrowIfFatalException(e);
			}

			// Get the next work item, if any
			importerWorkItem = getNextImporterWorkItem();
		}

		// Done with Importer work items
		if(logger.isDebugEnabled()){logger.debug("Completed processing importer work items.");}

	}
	
	private void processPurgeRequests() throws MethodException
	{

		logger.info("Checking for DICOM Importer items to purge.");
		
		// Loop over each of the purgable statuses to see if there are work items ripe for purging
		for (PurgeParameters purgeParameters : PurgeParameters.getPurgeParametersList())
		{
			ImporterWorkItem importerWorkItem = getNextWorkItemToPurge(purgeParameters.getStatus(), 
																	   purgeParameters.getPurgeDelayDays());
	
			while(importerWorkItem != null)
			{
	
				try
				{
					
					// We have a work item to process. Get the network location info so we can delete the files
					String networkLocationIen = Integer.toString(importerWorkItem.getWorkItemDetailsReference().getNetworkLocationIen());
					NetworkLocationInfo networkLocationInfo = storageRouter.getNetworkLocationDetails(networkLocationIen);

                    logger.info("Purging Importer work item {} with a status of {} as it is more than {} days old", importerWorkItem.getId(), purgeParameters.getStatus(), purgeParameters.getPurgeDelayDays());

					// Purge the current work item
					purgeWorkItem(importerWorkItem, networkLocationInfo);
					
				}
				catch (Exception e)
				{
					String message = "Error purging work item. This work item will be hung in the Purging status. It must be manually cleaned up...";
					
					if (importerWorkItem != null)
						message += " with id = " + importerWorkItem.getId();
					
					logger.error(message, e);
					
					// Rethrow if this is a fatal exception
					rethrowIfFatalException(e);

				}
				
				// Get the next work item to purge, if any
				importerWorkItem = getNextWorkItemToPurge(purgeParameters.getStatus(), purgeParameters.getPurgeDelayDays());
	
			}
		}
			
		// Done with Importer work items
		if(logger.isDebugEnabled()){logger.debug("Completed purging all purgable importer work items.");}

	}
	
	private void processWorkItem(ImporterWorkItem importerWorkItem,
								  NetworkLocationInfo networkLocationInfo) 
	throws MethodException, ConnectionException, IOException 
	{

		logWorkItemDetails(importerWorkItem, networkLocationInfo);
		
		DicomImporterDataSourceSpi dicomImporterService = ((DicomCommandContext)getCommandContext()).getDicomImporterService();

		// Now that we're done with the study, send the report data and status the order
		String guid = (new GUID()).toShortString();
		
		int mediaBundleReportDataIen = dicomImporterService.postImporterMediaBundleReportData(importerWorkItem);

		// Extract the workItemDetails
		ImporterWorkItemDetails workItemDetails = importerWorkItem.getWorkItemDetails();

		for (Iterator<Study> studyIterator = workItemDetails.getStudies().iterator(); studyIterator.hasNext();)
		{
			Study study = studyIterator.next();
			Reconciliation reconciliation = study.getReconciliation();

			// Only process studies that have been been marked for deletion 
			// or that have been reconciled...
			if (study.isToBeDeletedOnly())
			{
				if(logger.isDebugEnabled()){logger.debug("Deleting study as requested...");}
				deleteImagesForStudy(workItemDetails, networkLocationInfo, study);
				studyIterator.remove();
			}
			else if (reconciliation != null)
			{
				if(logger.isDebugEnabled()){logger.debug("Study was reconciled, so performing import...");}
				processStudy(mediaBundleReportDataIen, networkLocationInfo, importerWorkItem, study);

				// If the study is now empty and has no errors, and there are non remaining non-DICOM
				// files in the reconciliation, remove the study from the workItem details
				List<NonDicomFile> nonDicomFiles = study.getReconciliation().getNonDicomFiles();
				int nonDicomFileCount = nonDicomFiles != null ? nonDicomFiles.size() : 0;

				if (study.getSeries().size() == 0 && nonDicomFileCount == 0 && !study.getFailedImport())
				{
					if(logger.isDebugEnabled()){logger.debug("Study is completely processed with no errors. Removing the reference from the work item details.");}
					studyIterator.remove();
				}
			}
			else
			{
				if(logger.isDebugEnabled()){logger.debug("Study was not to be deleted, and had no reconciliation, so no action will be taken...");}
			}
		}

		// Done with all the studies in the workItem. Complete it...
		completeWorkItem(networkLocationInfo, importerWorkItem);
		
	}
	

	private void logWorkItemDetails(ImporterWorkItem importerWorkItem, NetworkLocationInfo networkLocationInfo) 
	{
		try
		{
			String message = "Processing importer work item with ien of " + importerWorkItem.getId() + ".\n";
			message += "Work item subtype: " + importerWorkItem.getSubtype() + ".\n";
			message += "Submitted by: " + importerWorkItem.getUpdatingUserDisplayName() + ".\n";
			message += "Submitted at: " + importerWorkItem.getLastUpdateDate() + ".\n";
			message += "Server and share: " + networkLocationInfo.getPhysicalPath() + ".\n";
			message += "Media bundle root directory on share: " + importerWorkItem.getWorkItemDetailsReference().getMediaBundleStagingRootDirectory() + ".\n";
			
			if(logger.isDebugEnabled()){logger.debug(message);}
		}
		catch (Exception e)
		{
			logger.error("Failed to log work item details:", e);
		}
	}

	private int getImageCount(Study study) 
	{
		int imageCount = 0;
		
		if (study.getSeries() != null)
		{
			for (Series series : study.getSeries())
			{
				imageCount += series.getSopInstances().size();
			}
		}
		
		List<NonDicomFile> nonDicomFiles = study.getReconciliation().getNonDicomFiles();
		if (nonDicomFiles != null)
		{
			imageCount += nonDicomFiles.size();
		}
		
		return imageCount;
	}

	private HashMap<String, String> getModalityCounts(Study study) 
	{
		HashMap<String, Integer> countsByModality = new LinkedHashMap<String, Integer>();
		String modalityCounts = "";
		
		// Load up the data
		for (Series series : study.getSeries())
		{
			String key = series.getModality();
			if (countsByModality.containsKey(key))
			{
				int currentCount = countsByModality.get(key);
				countsByModality.put(key, currentCount + series.getSopInstances().size());
			}
			else
			{
				countsByModality.put(key, series.getSopInstances().size());
			}
		}
		
		// Build the output hashmap
		int counter = 1;
		HashMap<String, String> hm = new LinkedHashMap<String, String>();
		for (String key : countsByModality.keySet())
		{
			hm.put(Integer.toString(counter++), key + "|" + countsByModality.get(key));
		}
		
		return hm;
	}

	private void processStudy(int mediaBundleReportDataIen,
			NetworkLocationInfo networkLocationInfo,
			ImporterWorkItem importerWorkItem, 
			Study study)
	throws MethodException, ConnectionException 
	{
		
		DicomImporterDataSourceSpi dicomImporterService = ((DicomCommandContext)getCommandContext()).getDicomImporterService();
		ImporterWorkItemDetails workItemDetails = importerWorkItem.getWorkItemDetails();
		Reconciliation reconciliation = study.getReconciliation();

		logStudyDetails(study);
		
		try
		{
			Order order = reconciliation.getOrder();
			reconciliation.setStudy(study);
			Patient patient = reconciliation.getPatient();

			// Capture data for reports before it gets "eaten up" by successful imports
			Series firstSeries = (study.getSeries() != null && study.getSeries().size() > 0) ? study.getSeries().get(0) : null;
			String accessionNumber = order.getAccessionNumber();
			String patientDfn = reconciliation.getPatient().getDfn();
			String facility = firstSeries != null ? firstSeries.getFacility() : "";
			String specialty = order.getSpecialty();
			int numberOfSeries = (study.getSeries() != null && study.getSeries().size() > 0) ? study.getSeries().size() : 0;
			int totalImagesInStudy = getImageCount(study);
			HashMap<String, String> modalityCounts = getModalityCounts(study);
	
			// Create the order if necessary
			if (order.isIsToBeCreated())
			{
				if(logger.isDebugEnabled()){logger.debug("Order needs to be created. Creating order now...");}
				dicomImporterService.createRadiologyOrder(reconciliation);
			}
	
			// Register the order if necessary
			if(shouldRegisterOrder(reconciliation))
			{
				if(logger.isDebugEnabled()){logger.debug("Order needs to be registered. Registering order now...");}
				dicomImporterService.registerOrder(reconciliation, getHospitalLocation(reconciliation, dicomImporterService));
			}
			
			// Get the refreshed order, in case the VistA generated study UID has been created since
			// reconciliation was performed.
			refreshRadiologyOrder(reconciliation.getPatient(), reconciliation.getOrder());

			// Find or create the Study UID
			String resolvedStudyUid = findOrCreateStudyUid(importerWorkItem, study, order);

			// Process all the DICOM images in the study, if any
			if (study.getSeries() != null && study.getSeries().size() > 0)
			{
				for (Iterator<Series> seriesIterator = study.getSeries().iterator(); seriesIterator.hasNext();)
				{
					if(logger.isDebugEnabled()){logger.debug("Processing the DICOM objects in the study...");}
					Series series = seriesIterator.next();
					
					logSeriesDetails(series);
					
					int successfulInstanceCount = 0;
					
					for (Iterator<SopInstance> instanceIterator = series.getSopInstances().iterator(); instanceIterator.hasNext();)
					{
						SopInstance instance = instanceIterator.next();
						
						// Correct and process the file. This method throws no exceptions. They 
						// will all be trapped and logged/stored from within the method
						boolean performValidation = (successfulInstanceCount == 0);
						correctDicomObject(instance, patient, order, study, resolvedStudyUid, importerWorkItem, networkLocationInfo, performValidation);
						
						// if the instance was imported successfully, remove the instance
						// record from the series
						if (instance.isImportedSuccessfully())
						{
							if(logger.isDebugEnabled()){logger.debug("Instance successfully processed.");}
							instanceIterator.remove();
	
							// increment the instance count
							successfulInstanceCount++;
						}
					}
					
					// if the series is now empty, remove it from the study
					if (series.getSopInstances().size() == 0)
					{
						if(logger.isDebugEnabled()){logger.debug("The series is now empty. Removing it from the study.");}
						seriesIterator.remove();
					}
				}
			}
			
			// Process the non-DICOM files, if any
			InstrumentConfig instrument = createInstrumentConfig(importerWorkItem, getInstrumentNickName(workItemDetails, order.getSpecialty()), order.getSpecialty());
			router.processNonDicomFiles(resolvedStudyUid, importerWorkItem, reconciliation, instrument);
			
			
			// Only attempt to status a non-DICOM Correct radiology order
			if(logger.isDebugEnabled()){logger.debug("Checking to see if exam status should be udpated.");}
			// Get the current exam status
			
			if (isRadiologyOrder(reconciliation) && !importerWorkItem.getSubtype().equals(ImporterWorkItemSubtypes.DicomCorrect))
			{
				
				// Get the refreshed order, in case another process has updated the status since
				// this reconciliation was completed.
				refreshRadiologyOrder(reconciliation.getPatient(), reconciliation.getOrder());
				
				// Get the current exam status, and append an empty string in case it's null
				String currentStatus = reconciliation.getOrder().getExamStatus() + "";

				// Get the requested status (defaulting to the current status if a new status was not requested)
				String requestedStatus = getRequestedStatus(reconciliation);

				// Only attempt a status update if the current status is different from the requested status
				if (!requestedStatus.equals(currentStatus))
				{
					// Check for and process request for EXAMINED status
					if (requestedStatus.equalsIgnoreCase(EXAMINED) &&
						!currentStatus.equalsIgnoreCase(EXAMINED) && 
						!currentStatus.equalsIgnoreCase(COMPLETE))
					{
						if(logger.isDebugEnabled()){logger.debug("Setting status to EXAMINED.");}
						dicomImporterService.setOrderExamined(reconciliation, workItemDetails.getReconcilingTechnicianDuz(), getLocalSiteId());
					}

					// Check for and process request for COMPLETE status
					if (requestedStatus.equalsIgnoreCase(COMPLETE) &&
						!currentStatus.equalsIgnoreCase(COMPLETE))
					{
						if(logger.isDebugEnabled()){logger.debug("Setting status to COMPLETE.");}
						dicomImporterService.setOrderExamComplete(reconciliation, workItemDetails.getReconcilingTechnicianDuz(), getLocalSiteId());
					}
				}
			}
			
			// Now that we're done with the study, send the report data and status the order
			if(logger.isDebugEnabled()){logger.debug("Writing report data ...");}
			dicomImporterService.postImporterStudyReportData(
					mediaBundleReportDataIen, 
					importerWorkItem,
					accessionNumber,
					resolvedStudyUid,
					patientDfn,
					facility,
					specialty,
					numberOfSeries,
					totalImagesInStudy,
					getImageCount(study),
					modalityCounts);


		}
		catch (Exception e)
		{
            logger.error("Error processing study {} in workItem  {}: {}", study.getIdInMediaBundle(), importerWorkItem.getId(), e.getMessage(), e);
			
			String message = e.getMessage();
			study.setImportErrorMessage(ExceptionUtilities.convertExceptionToString(e));
			study.setFailedImport(true);
			
			// Rethrow if this is a fatal exception
			rethrowIfFatalException(e);
						
		}
	}
	
	/**
	 * @return
	 */
	private String findOrCreateStudyUid(ImporterWorkItem importerWorkItem, Study study, Order order) throws MethodException, ConnectionException 
	{
		String studyUid;
		String studyUidFromDicom = study.getUid();
		String studyUidFromVista = order.getVistaGeneratedStudyUid();
		
		if (studyUidFromVista != null && !studyUidFromVista.trim().equals(""))
		{
			// We have a VistA study Uid, so use it...
			studyUid = studyUidFromVista;
		}
		else if (studyUidFromDicom != null && !studyUidFromDicom.trim().equals(""))
		{
			// We don't have one from VistA, but we do have one from the Dicom files, so use
			// it
			studyUid = studyUidFromDicom;
		}
		else
		{
			// We don't have a study UID from either VistA or any DICOM files. 
			// Generate a new one...
			DicomUid dicomUid = router.getDicomUid(order.getAccessionNumber(), 
					DicomServerConfiguration.getConfiguration().getSiteId(), 
					IMPORTER_INSTRUMENT, 
					STUDY_UID_TYPE);
			
			studyUid = dicomUid.getValue();
		}
		
		return studyUid;
	}


	/**
	 * Gets the requested status. This method takes into account both P118 IsStudyToBeReadByVaRadiologist and P136
	 * methods for determining final status.
	 * 
	 * @param reconciliation
	 * @return
	 */
	private String getRequestedStatus(Reconciliation reconciliation) 
	{
		String requestedStatus;
		
		StatusChangeDetails details = reconciliation.getOrder().getStatusChangeDetails();
		
		if(details != null)
		{
			// This is a P136-style work item. Return the requested status from the status change details object
			requestedStatus = details.getRequestedStatus();
		}
		else
		{
			// This is a P118-style work item. Infer the requested status based on the
			// isStudyToBeReadByVaRadiologist flag.
			requestedStatus = reconciliation.isIsStudyToBeReadByVaRadiologist() ? EXAMINED : COMPLETE;
		}
		
		return requestedStatus;

	}

	private int getHospitalLocation(Reconciliation reconciliation, DicomImporterDataSourceSpi dicomImporterService) 
			throws MethodException, ConnectionException 
	{
		String procedureIen = Integer.toString(reconciliation.getOrder().getProcedure().getId());
		List<Procedure> procedures = dicomImporterService.getProcedureList(getLocalSiteId(), "", procedureIen);

		if (procedures != null && procedures.size() > 0)
		{
			return procedures.get(0).getHospitalLocationId();
		}
		else
		{
			return -1;
		}
	}

	private void logStudyDetails(Study study) 
	{
		try
		{
			Patient patient = study.getReconciliation().getPatient();
			Order order = study.getReconciliation().getOrder();
			
			String message = "Processing study with id in the media bundle of " + study.getIdInMediaBundle() + ".\n";
			message += "Reconciled patient name: " + patient.getPatientName() + ".\n";
			message += "Reconciled patient id: " + patient.getSsn() + ".\n";
			message += "Reconciled order accession number: " + order.getAccessionNumber() + ".\n";
			
			if(logger.isDebugEnabled()){logger.debug(message);}
		}
		catch (Exception e)
		{
			logger.error("Failed to log study details:", e);
		}
	}

	private void logSeriesDetails(Series series) 
	{
		try
		{
			String message = "Processing series number " + series.getSeriesNumber() + ".\n";
			message += "Series Description: " + series.getSeriesDescription() + ".\n";
			message += "Modality: " + series.getModality() + ".\n";
			message += "Facility: " + series.getFacility() + ".\n";
			
			if(logger.isDebugEnabled()){logger.debug(message);}
		}
		catch (Exception e)
		{
			logger.error("Failed to log series details:", e);
		}
	}

	private boolean shouldRegisterOrder(Reconciliation reconciliation) 
	{
		// Assume we're going to register it.
		boolean shouldRegisterOrder = true;
		
		// Only register radiology orders
		if (!reconciliation.getOrder().getSpecialty().equals("RAD"))
		{
			shouldRegisterOrder = false;
		}
		
		// Get the refreshed order, in case another process has already 
		// registered an unregistered order.
		refreshRadiologyOrder(reconciliation.getPatient(), reconciliation.getOrder());
		
		// Don't register if there's already an accession number
		String accessionNumber = reconciliation.getOrder().getAccessionNumber();
		if (accessionNumber != null && !accessionNumber.trim().equals(""))
		{
			shouldRegisterOrder = false;
		}
		
		return shouldRegisterOrder;
	}

	private boolean isRadiologyOrder(Reconciliation reconciliation) 
	{
		// Assume it's a radiology order
		boolean isRadiologyOrder = true;
		
		// get service type
		DicomUtils du = new DicomUtils();
		if (!du.getServiceFromAccessionNumber(reconciliation.getOrder().getAccessionNumber()).equalsIgnoreCase("RAD"))
		{
			isRadiologyOrder = false;
		}
		
		return isRadiologyOrder;
	}

	private void completeWorkItem(NetworkLocationInfo networkLocationInfo, ImporterWorkItem importerWorkItem) 
	throws MethodException, ConnectionException, IOException 
	{
		
		ImporterWorkItemDetails workItemDetails = importerWorkItem.getWorkItemDetails();
		
		// If there are no studies left (we deleted them all), then just delete the workitem. 
		// Otherwise, mark it as success or fail...
		if (workItemDetails.getStudies().size() == 0)
		{
            logger.info("ImporterWorkItem with IEN {} had all of its studies deleted. Deleting the work item as well", importerWorkItem.getId());
			
			WorkListContext.getInternalRouter().deleteWorkItem(importerWorkItem.getId());
			
			// Delete the media bundle root directory
			deleteMediaBundleRootDirectory(networkLocationInfo, importerWorkItem);
		}
		else if (!workItemDetails.hasImportErrors())
		{
            logger.info("ImporterWorkItem with IEN {} processed succesfully.", importerWorkItem.getId());
			
			// Write out the updated WorkItemDetails
			writeWorkItemDetailsToDisk(networkLocationInfo, importerWorkItem, workItemDetails.getMediaBundleStagingRootDirectory());

			// Update the current work item to complete
			WorkListContext.getInternalRouter().updateWorkItem(
					importerWorkItem.getId(), 
					ImporterWorkItemStatuses.Importing, 
					ImporterWorkItemStatuses.ImportComplete, 
					importerWorkItem.getRawWorkItem().getMessage(),
					"",
					getUpdatingSystem());
		}
		else
		{
			// Failures were detected processing the work item. Log a summary at the error level, 
			// and all the details at debug level
			logger.error(workItemDetails.getImportErrorSummary());
			if(logger.isDebugEnabled()){logger.debug(workItemDetails.getImportErrorDetails());}

			// Send an email with failure details
			sendFailureEmail(importerWorkItem);

			// Write out the updated WorkItemDetails
			writeWorkItemDetailsToDisk(networkLocationInfo, importerWorkItem, workItemDetails.getMediaBundleStagingRootDirectory());

			// Update the current work item to failed import
			WorkListContext.getInternalRouter().updateWorkItem(
					importerWorkItem.getId(), 
					ImporterWorkItemStatuses.Importing, 
					ImporterWorkItemStatuses.FailedImport, 
					importerWorkItem.getRawWorkItem().getMessage(),
					"",
					getUpdatingSystem());
		}
	}

	private void sendFailureEmail(ImporterWorkItem importerWorkItem) throws MethodException 
	{
        
		try 
		{
	        DicomServerConfiguration dicomServerConfig = DicomServerConfiguration.getConfiguration();
	        String emailRecepient = dicomServerConfig.getDgwEmailInfo().getEMailAddress();
	        String[] eMailTOs=new String[1];
	        eMailTOs[0] = emailRecepient;
	        String subject = "Importer Item Failed Processing";
	        String body = importerWorkItem.getWorkItemDetails().getImportErrorSummary();
	        EmailMessage email = new EmailMessage(eMailTOs, subject, body);
	        DicomContext.getRouter().postToEmailQueue(email,
	        		"Thread ID = " + Long.toString(Thread.currentThread().getId()));
		} 
		catch (MethodException e) 
		{
            logger.error("Exception sending failure email: {}", e.getMessage(), e);
			rethrowIfFatalException(e);
		} 
		catch (ConnectionException e) 
		{
            logger.error("Exception sending failure email: {}", e.getMessage(), e);
		}

	}

	private DicomCorrectEntry buildDicomCorrectEntry(ImporterWorkItemDetails workItemDetails, 
													  Patient patient,
													  Order order, 
													  SopInstance instance, 
													  String path) 
	{
		DicomCorrectEntry entry = new DicomCorrectEntry();
		entry.setFilePath(path);
		entry.setCorrectedCaseNumber(order.getAccessionNumber());
		entry.setCorrectedProcedureDescription(getProcedureName(order));
		entry.setCorrectedProcedureIEN(getProcedureId(order));
		entry.setCorrectedName(patient.getPatientName());
		entry.setCorrectedSSN(patient.getSsn());
		entry.setCorrectedDOB(patient.getDob().toString());
		entry.setCorrectedSex(patient.getPatientSex().toDicomString());
		entry.setCorrectedICN(patient.getPatientIcn());
		entry.setServiceType(order.getSpecialty()); // tells specialty
		entry.setInstrumentNickName(getInstrumentNickName(workItemDetails, order.getSpecialty()));
		entry.setTransferSyntaxUid(instance.getTransferSyntaxUid());
		
		return entry;
	}

	private String getInstrumentNickName(ImporterWorkItemDetails workItemDetails, String serviceType)
	{
		if(workItemDetails.getInstrumentNickName() != null && !workItemDetails.getInstrumentNickName().trim().equals(""))
		{
			return workItemDetails.getInstrumentNickName();
		}
		else
		{
			return getNickNameForServiceType(serviceType);
		}
	}
	
	private String getNickNameForServiceType(String serviceType) 
	{

		if (!config.getInstruments().isEmpty()) {
			for (Iterator<InstrumentConfig> instIterator = config.getInstruments().iterator(); instIterator.hasNext();) {
				InstrumentConfig ic = instIterator.next();
				if (ic.getService().equals(serviceType)) {
					return ic.getNickName();
				}
			}
		}
		
		// Couldn't find an instrument with the specified service. Return an empty string.
		return "";
	}

	
	private String getProcedureId(Order order) 
	{
		String procedureId = "";
		Procedure procedure = order.getProcedure();
		
		try
		{
			if (order.getSpecialty().equalsIgnoreCase("RAD"))
			{
				if (procedure != null)
				{
					procedureId = Integer.toString(procedure.getId());
				}
				else
				{
					procedureId = Integer.toString(order.getProcedureId());
				}
			}
		}
		catch (Exception e)
		{
            logger.error("Error retrieving procedure Id: {}", e.getMessage(), e);
		}
		
		return procedureId;
	}

	private String getProcedureName(Order order) 
	{
		String procedureName = "";
		Procedure procedure = order.getProcedure();
		
		try
		{
			if (procedure != null)
			{
				procedureName = procedure.getName();
			}
			else
			{
				procedureName = order.getProcedureName();
			}
		}
		catch (Exception e)
		{
            logger.error("Error retrieving procedure name: {}", e.getMessage(), e);
		}
		
		return procedureName;
		
	}

	private void correctDicomObject(SopInstance instance, 
								     Patient patient,
									 Order order,
									 Study study,
									 String resolvedStudyUid,
									 ImporterWorkItem workItem,
									 NetworkLocationInfo networkLocationInfo,
									 boolean performValidation) throws MethodException
	{
		

		ImporterWorkItemDetails workItemDetails = workItem.getWorkItemDetails();
		
		//Open DICOM File
		IDicomDataSet dds = null;
		DicomFileInput dicomFileHandle = null;
		DicomCorrectEntry entry = null;
		try {

			// Build the full file path and create the DicomCorrectEntry
			String path = getInstancePath(networkLocationInfo, workItemDetails.getMediaBundleStagingRootDirectory(), instance);
			entry = buildDicomCorrectEntry(workItemDetails, 
															 patient, 
															 order, 
															 instance, 
															 path);

			if(logger.isDebugEnabled()){logger.debug("Preparing to read DICOM file from disk, with retrys in case the file is temporarily locked.");}
			ReadPart10FileWorkUnit workUnit = new ReadPart10FileWorkUnit(networkLocationInfo, entry.getFilePath(), dicomFileHandle);
			RetryableWorkUnitCommand<IDicomDataSet> retryableCommand = new RetryableWorkUnitCommand<IDicomDataSet>(workUnit);
			dds = retryableCommand.executeWorkWithRetries();	
			
			if(logger.isDebugEnabled()){logger.debug("DICOM Dataset successfully read.");}
			
			String aet = dds.getSourceAET();
			DicomAE dicomAE = DicomContext.getRouter().getRemoteAE(DicomAE.searchMode.REMOTE_AE, aet, config.getSiteId());
        	
			// Perform IOD validation if this is staged media and it's the first instance in the series
			if (performValidation &&
				(workItem.getSubtype().equals(ImporterWorkItemSubtypes.StagedMedia) ||
				workItem.getSubtype().equals(ImporterWorkItemSubtypes.DirectImport)))
			{
				if(logger.isDebugEnabled()){logger.debug("Performing IOD validation...");}
				performIodValidation(dds);
			}
				
			if(logger.isDebugEnabled()){logger.debug("Updating DICOM header.");}
        	updateHeaderAndOriginalAttributesSequence(resolvedStudyUid, entry, dds);
        	
        	//Create fake InstrumentConfig object
        	if(logger.isDebugEnabled()){
                logger.debug("{}: Create fake instrument.", this.getClass().getName());}
        	InstrumentConfig instrument = createInstrumentConfig(workItem, entry.getInstrumentNickName(), entry.getServiceType());
        	
			//Pass to the PostDicomInstance command.
    		// Note: metaData is null, that tells the DataSet was read from a Part10 file, no need 
    		//       for metaheader change also iodValidationStatus is hardcoded 0 so the series 
    		//       level value won't get updated after DICOM correct (cpt 10/20/10)
    		//	     Also there is a bypass flag (true) to force an import item from outside location
    		//       to DICOM Correct regardless (05/27/11)
    		if(logger.isDebugEnabled()){logger.debug("Calling the PostDicomInstance Router command via DICOM Correct.");}
    		DicomStorageResults results = router.postDicomInstance(dds, dicomAE, instrument, 
    				null, 0, true, study.getOriginIndex());
    		
    		if (dicomFileHandle != null)
    		{
    			dicomFileHandle.close(true);
    		}
    		
    		if(logger.isDebugEnabled()){logger.debug("Check results from PostDicomInstance Router command.");}
            
    		if (results!=null) {
    			
            	UIDCheckResults uidCheckResults = results.getUidCheckResults();
            	if(uidCheckResults != null)
            	{
	            	if (uidCheckResults.isSOPInstanceResend()) 
	            	{
                        logger.info("Store Instance RESEND detected from DICOM Correct, {}. Received duplicate Object='{}'.", entry.getFilePath(), uidCheckResults.getSOPInstanceResult().getOriginalUID());
	            	}
	            	
					if (uidCheckResults.anyDuplicatesExist() || uidCheckResults.anyIllegalsExist()) 
					{
						// if any new UID had to be generated
						String type, level, badUID, newUID;
						if (uidCheckResults.isDuplicateStudyUID() || uidCheckResults.isIllegalStudyUID()) 
						{
							if (uidCheckResults.isIllegalStudyUID()) type="ILL ";
							else type = "DUP ";
							level = "Std";
							badUID=	uidCheckResults.getStudyResult().getOriginalUID();
							newUID=	uidCheckResults.getStudyResult().getCorrectedUID();
                            logger.warn("{}{}IUID '{}' replaced with '{}' {}", type, level, badUID, newUID, entry.getFilePath());
						} 
						
						if (uidCheckResults.isDuplicateSeriesUID() || uidCheckResults.isIllegalSeriesUID()) 
						{
							if (uidCheckResults.isIllegalSeriesUID()) type="ILL ";
							else type = "DUP ";
							level = "Ser";
							badUID=	uidCheckResults.getSeriesResult().getOriginalUID();
							newUID=	uidCheckResults.getSeriesResult().getCorrectedUID();
                            logger.warn("{}{}IUID '{}' replaced with '{}' {}", type, level, badUID, newUID, entry.getFilePath());
						}
						
						if (uidCheckResults.isDuplicateInstanceUID() || uidCheckResults.isIllegalInstanceUID()) 
						{
							if (uidCheckResults.isIllegalInstanceUID()) type="ILL ";
							else type = "DUP ";
							level = "SOP";
							badUID=	uidCheckResults.getSOPInstanceResult().getOriginalUID();
							newUID=	uidCheckResults.getSOPInstanceResult().getCorrectedUID();
                            logger.warn("{}{}IUID '{}' replaced with '{}' {}", type, level, badUID, newUID, entry.getFilePath());
						}
					}
            	}
            }
    		
    		// Successfully imported the item. Delete the file and set the status
			String instancePath = getInstancePath(networkLocationInfo, workItemDetails.getMediaBundleStagingRootDirectory(), instance);
			
			// Try to delete the image now to save space on the share. If it fails, it's no big deal, because
			// the whole media bundle will be deleted at purge time.
			try
			{
				deleteImage(networkLocationInfo, instancePath);
			}
			catch(Exception e)
			{
                logger.info("Unable to delete file. It will still be deleted later when the media bundle is remove: {}", instancePath);
			}
    		
    		instance.setImportedSuccessfully(true);
		} 
		catch (DicomException e) 
		{
			String errorMessage = "DicomException thrown while correcting DICOM File. " + e.getMessage();
			storeAndLogInstanceCorrectionException(instance, e, errorMessage);
			rethrowIfFatalException(e);
		} 
		catch (MethodException e) 
		{
			String errorMessage = "MethodException thrown while correcting DICOM File. " + e.getMessage();
			storeAndLogInstanceCorrectionException(instance, e, errorMessage);
			rethrowIfFatalException(e);
		} 
		catch (ConnectionException e) 
		{
			String errorMessage = "ConnectionException thrown while correcting DICOM File. " + e.getMessage();
			storeAndLogInstanceCorrectionException(instance, e, errorMessage);
		}
		catch (IODViolationException e) 
		{
			String errorMessage = "IODViolationException thrown while validating DICOM File. " + e.getMessage();
			storeAndLogInstanceCorrectionException(instance, e, errorMessage);
		} 
		catch (DicomStorageSCPException e) 
		{
			String errorMessage = "DicomStorageSCPException thrown while validating DICOM File. " + e.getMessage();
			storeAndLogInstanceCorrectionException(instance, e, errorMessage);
		} 
		catch (DCSException e) 
		{
			String errorMessage = "DicomStorageSCPException thrown while validating DICOM File. " + e.getMessage();
			storeAndLogInstanceCorrectionException(instance, e, errorMessage);
		}
		catch (Exception e) 
		{
			String errorMessage = "Exception thrown while correcting DICOM File. " + e.getMessage();
			storeAndLogInstanceCorrectionException(instance, e, errorMessage);
		}
		finally
		{
			if (dicomFileHandle != null)
			{
				try
				{
					dicomFileHandle.close(true);
				}
				catch(DCSException e)
				{
					if (entry != null)
					{
                        logger.error("Failed to close DICOM object file, {}", entry.getFilePath(), e);
					}
					else
					{
						logger.error("Failed to close DICOM object file", e);
					}
				}
			}
		}
	}
	/**
	 * @param workItem
	 * @param entry
	 * @return
	 */
	private InstrumentConfig createInstrumentConfig(ImporterWorkItem workItem, String instrumentNickName, String serviceType) 
	{
		InstrumentConfig instrument = new InstrumentConfig();
		instrument.setDescription("Fixed Object");
		instrument.setHostName(config.getHostName());
		instrument.setMachineId(config.getHostName());
		instrument.setNickName(instrumentNickName); 
		instrument.setPort(1);
		instrument.setService(serviceType);
		instrument.setSite(getLocalSiteId());
		String acqLocation = workItem.getWorkItemDetails().getInstrumentAcqLocation();
		if(acqLocation == null || acqLocation.equals(""))
		{
			instrument.setSiteId(config.getSiteId());
		}
		else
		{
			instrument.setSiteId(acqLocation);
		}
		return instrument;
	}

	private void storeAndLogInstanceCorrectionException(
			SopInstance instance,
			Exception e, 
			String errorMessage) 
	{
		String instanceErrorMessage = errorMessage + "\n" + ExceptionUtilities.convertExceptionToString(e); 
		instance.setImportErrorMessage(instanceErrorMessage);
		instance.setImportedSuccessfully(false);
		logger.error(errorMessage, e);
	}

	private void performIodValidation(IDicomDataSet dds) throws IODViolationException, DicomStorageSCPException, MethodException, ConnectionException 
	{
		// first look for the fake "IMPORTER" entry in AE Sec MX
        DicomAE dicomAE = DicomContext.getRouter().getRemoteAE(DicomAE.searchMode.REMOTE_AE, "IMPORTER", DicomServerConfiguration.getConfiguration().getSiteId());
        if (!dicomAE.isRemoteAEValid() || !dicomAE.isServiceAndRoleValid("C-STORE", "SCU")) 
        {
        	throw new DicomStorageSCPException("Configuration Error: IMPORTER AE is not in AE Security Matrix as a C-STORE SCU ");
        }
        
        DoIODValidationImpl validator = new DoIODValidationImpl();
   		validator.doIODValidation(dicomAE, dds);
	}

	public void updateHeaderAndOriginalAttributesSequence(String resolvedStudyUid,
			DicomCorrectEntry entry, IDicomDataSet dds) throws DicomException {

		// Update incorrect Patient/Study data and
		// Place changed attributes into an Original Attributes Sequence
		if(logger.isDebugEnabled()){
            logger.debug("{}: Update incorrect Patient/Study data in Dicom dataset.", this.getClass().getName());}
		dds.insertAndRecordNewValue ("0008,0050", null, entry.getCorrectedCaseNumber(), false);
		dds.insertAndRecordNewValue ("0008,1030", null, entry.getCorrectedProcedureDescription(), false);
		dds.insertAndRecordNewValue ("0010,0010", null, entry.getCorrectedName(), false);
		dds.insertAndRecordNewValue ("0010,0020", null, entry.getCorrectedSSN(), false);
		dds.insertAndRecordNewValue ("0010,0030", null, entry.getCorrectedDOB(), false);
		dds.insertAndRecordNewValue ("0010,0040", null, entry.getCorrectedSex(), false);
		dds.insertAndRecordNewValue ("0010,1000", null, entry.getCorrectedICN(), false);
		
		// Update the study UID if necessary
		if (!dds.getStudyInstanceUID().equals(resolvedStudyUid))
		{
			dds.insertAndRecordNewValue ("0020,0010", null, resolvedStudyUid, false);
		}
		
	    boolean isNew = dds.insertAndRecordNewValue ("0008,1032", "0008,0100", entry.getCorrectedProcedureIEN(), false);
	    dds.insertAndRecordNewValue ("0008,1032", "0008,0102", "C4", isNew);
	    dds.insertAndRecordNewValue ("0008,1032", "0008,0104", entry.getCorrectedProcedureDescription(), isNew);
	}

	private void purgeWorkItem(ImporterWorkItem importerWorkItem, 
			                    NetworkLocationInfo networkLocationInfo) 
	throws MethodException, ConnectionException 
	{
		try
		{

			// Delete the staging root directory and all of its contents
			deleteMediaBundleRootDirectory(networkLocationInfo, importerWorkItem);
	
			// Delete the work item
			WorkListContext.getInternalRouter().deleteWorkItem(importerWorkItem.getId());
			
		}
		catch (Exception e)
		{
			logger.error("Exception attempting to purge importer work item:\n", e);
			
			// Rethrow if this is a fatal exception
			rethrowIfFatalException(e);
		}
	}
	

	private void deleteAllImages(ImporterWorkItemDetails workItemDetails, 
			                      NetworkLocationInfo networkLocationInfo) 
	throws MethodException, ConnectionException, IOException 
	{
		for (Study study : workItemDetails.getStudies())
		{
			deleteImagesForStudy(workItemDetails, networkLocationInfo, study);
		}
	}

	private void deleteImagesForStudy(ImporterWorkItemDetails workItemDetails, 
            NetworkLocationInfo networkLocationInfo, 
            Study study) 
	throws MethodException, ConnectionException, IOException 
	{
		for (Series series : study.getSeries())
		{
			for (SopInstance instance : series.getSopInstances())
			{
				String instancePath = getInstancePath(networkLocationInfo, workItemDetails.getMediaBundleStagingRootDirectory(), instance);
				
				try
				{
					deleteImage(networkLocationInfo, instancePath);
				}
				catch (Exception e)
				{
                    logger.warn("Unable to delete image: {}", instancePath, e);
				}
			}
		}

	}

	private void deleteImage(NetworkLocationInfo networkLocationInfo, String instancePath) 
	throws MethodException, ConnectionException, IOException 
	{
		SmbStorageUtility util = new SmbStorageUtility();
		
		if (util.fileExists(instancePath, (StorageCredentials)networkLocationInfo))
		{
			util.deleteFile(instancePath, (StorageCredentials)networkLocationInfo);
		}
	}
	
	private void deleteMediaBundleRootDirectory(NetworkLocationInfo networkLocationInfo, 
			 ImporterWorkItem importerWorkItem) throws IOException, MethodException, ConnectionException 
	{	
		SmbStorageUtility util = new SmbStorageUtility();

		String fullPath = getMediaBundlePath(networkLocationInfo, importerWorkItem.getWorkItemDetailsReference().getMediaBundleStagingRootDirectory());
		StorageCredentials credentials = (StorageCredentials)networkLocationInfo;
		
		if (util.fileExists(fullPath, credentials))
		{
			util.deleteFile(fullPath, credentials);
		}
	}

	private ImporterWorkItem getHungImporterWorkItem() throws MethodException
	{
		try
		{
			// Get a list of all work items in process
			WorkItemFilter filter = new WorkItemFilter();
			filter.setType(WorkListTypes.DicomImporter);
			filter.setStatus(ImporterWorkItemStatuses.Importing);
			filter.setPlaceId(getLocalSiteId());
			
			List<WorkItem> inProcessWorkItems = WorkListContext.getInternalRouter().getWorkItemList(filter);

			// See if any of them were put inprocess by me... If so, consider it hung and return it after
			// building up the details.
			WorkItem hungWorkItem = getHungWorkItemFromInProcessList(inProcessWorkItems);

			if (hungWorkItem != null)
			{
				// Get the shallow work item
				ImporterWorkItem shallowWorkItem = ImporterWorkItem.buildShallowImporterWorkItem(hungWorkItem);

				// Get the network location info so we can load the workItemDetails
				String networkLocationIen = Integer.toString(shallowWorkItem.getWorkItemDetailsReference().getNetworkLocationIen());
				NetworkLocationInfo networkLocationInfo = storageRouter.getNetworkLocationDetails(networkLocationIen);
	
				// Load the work item details from the media bundle directory
				ImporterWorkItemDetails details = readWorkItemDetailsFromDisk(networkLocationInfo, shallowWorkItem, shallowWorkItem.getWorkItemDetailsReference().getMediaBundleStagingRootDirectory());

				// We have to call this again so that the factory method can build studies 
				// from dicom correct tags, etc.
				return ImporterWorkItem.buildFullImporterWorkItem(hungWorkItem, details);
			}
		}
		catch (Exception e)
		{
			logger.error("Error retrieving hung work items for import: ", e);
			
			// Rethrow if this is a fatal exception
			rethrowIfFatalException(e);
		}
		
		// Couldn't get a work item
		return null;
	}

	private WorkItem getHungWorkItemFromInProcessList(List<WorkItem> inProcessWorkItems) 
	{
		if (inProcessWorkItems != null && inProcessWorkItems.size() > 0)
		{
			for (WorkItem inProcessItem : inProcessWorkItems)
			{
				if (inProcessItem.getUpdatingApplication().equals(getUpdatingSystem()))
				{
					return inProcessItem;
				}
			}
		}
		
		return null;
	}

	private ImporterWorkItem getNextImporterWorkItem() throws MethodException
	{
		try
		{
			String workListType = WorkListTypes.DicomImporter;
			String expectedStatus = ImporterWorkItemStatuses.ReadyForImport;
			String newStatus = ImporterWorkItemStatuses.Importing;
			
			WorkItem workItem = WorkListContext.getInternalRouter().getAndTransitionNextWorkItem(
					workListType, 
					expectedStatus, 
					newStatus, 
					"",
					getUpdatingSystem());
			
			if (workItem != null)
			{

				// Get the shallow work item
				ImporterWorkItem shallowWorkItem = ImporterWorkItem.buildShallowImporterWorkItem(workItem);

				// Get the network location info so we can load the workItemDetails
				String networkLocationIen = Integer.toString(shallowWorkItem.getWorkItemDetailsReference().getNetworkLocationIen());
				NetworkLocationInfo networkLocationInfo = storageRouter.getNetworkLocationDetails(networkLocationIen);
	
				// Load the work item details from the media bundle directory
				ImporterWorkItemDetails details = readWorkItemDetailsFromDisk(networkLocationInfo, shallowWorkItem, shallowWorkItem.getWorkItemDetailsReference().getMediaBundleStagingRootDirectory());

				// We have to call this again so that the factory method can build studies 
				// from dicom correct tags, etc.
				return ImporterWorkItem.buildFullImporterWorkItem(workItem, details);
			}
		}
		catch (Exception e)
		{
			logger.error("Error retrieving work item for import: ", e);
			
			// Rethrow if this is a fatal exception
			rethrowIfFatalException(e);
		}
		
		// Couldn't get a work item
		return null;
	}

	private String getUpdatingSystem() {
		return "Importer:" + config.getHostName();
	}

	//FIXME According to the log, this method, directly or indirectly, is calling 
	//	ImporterWorkItem.buildFullImporterWorkItem() method.  But this should not be happening.
	private ImporterWorkItem getNextWorkItemToPurge(String purgableStatus, int purgeDelayDays) throws MethodException
	{
		try
		{
			String workListType = WorkListTypes.DicomImporter;
			String purgingStatus = ImporterWorkItemStatuses.Purging;
			
			// Get the oldest one but don't transition it yet, until we find out if it's due for purging...
			WorkItem workItem = WorkListContext.getInternalRouter().getAndTransitionNextWorkItem(
					workListType, 
					purgableStatus, 
					purgableStatus, 
					"",
					getUpdatingSystem());
			
			// If we have a work item, and it's due for purging, return it. Otherwise return null,
			// which will halt processing for this cycle.
			if (workItem != null && isDueForPurging(workItem, purgeDelayDays))
			{
				workItem = WorkListContext.getInternalRouter().getAndTransitionWorkItem(
						workItem.getId(), 
						purgableStatus, 
						purgingStatus, 
						"",
						getUpdatingSystem());
				
				// Get and return the shallow work item. No need for details when purging.
				return ImporterWorkItem.buildShallowImporterWorkItem(workItem);

			}
		}
		catch (Exception e)
		{
			logger.error("Error retrieving work item to purge: ", e);
			
			// Rethrow if this is a fatal exception
			rethrowIfFatalException(e);
		}
		
		return null;
	}
	
	private boolean isDueForPurging(WorkItem workItem, int purgeDelayDays) 
	{
		// If the purge delay days is less than 0, return false: never purge...
		if (purgeDelayDays < 0)
		{
			return false;
		}
		
		boolean isDueForPurging = false;

		try
		{
			// Get the last update date
			Calendar lastUpdateDate = getLastUpdateDate(workItem.getLastUpdateDate());

			// Create a calendar for today and wipe out the time part
			Calendar today = Calendar.getInstance();
			today.set(today.get(Calendar.YEAR), today.get(Calendar.MONTH), today.get(Calendar.DATE));

			// If the difference between the two is greater than the purge delay, set to true...
			if (daysBetween(lastUpdateDate.getTime(), today.getTime()) >= purgeDelayDays)
			{
				isDueForPurging = true;
			}
			
		}		
		catch (Exception e)
		{
			logger.error(e.getMessage(), e);
		}
		
		return isDueForPurging;
	}
	
	private Calendar getLastUpdateDate(String lastModifiedDate) 
	{
		if (lastModifiedDate.contains("@"))
		{
			// Split the time from the date
			String[] dateTimeParts = StringUtil.split(lastModifiedDate, "@");
			String date = dateTimeParts[0];
			
			// Now split the date into its parts
			String[] dateParts = StringUtil.split(date, "/");
			int year = Integer.parseInt(dateParts[2]);
			int month = Integer.parseInt(dateParts[0]) - 1;
			int day = Integer.parseInt(dateParts[1]);
			
			// Set a calendar with the date parts
			Calendar lastUpdateDate = Calendar.getInstance();
			lastUpdateDate.set(year, month, day);
			return lastUpdateDate;
		}
		else
		{
			// Split the time from the date
			String[] dateTimeParts = StringUtil.split(lastModifiedDate, ".");
			String date = dateTimeParts[0];
			
			// Now split the date into its parts
			String yearString = date.substring(0, 4);
			String monthString = date.substring(4, 6);
			String dayString = date.substring(6);

			int year = Integer.parseInt(yearString);
			int month = Integer.parseInt(monthString);
			int day = Integer.parseInt(dayString);
			
			// Set a calendar with the date parts
			Calendar lastUpdateDate = Calendar.getInstance();
			lastUpdateDate.set(year, month, day);
			return lastUpdateDate;
		}
	}

	public int daysBetween(Date d1, Date d2)
	{
		long d2Time = d2.getTime();
		long d1Time = d1.getTime();
		long timeBetween = d2Time - d1Time;
		int diffInDays = (int)( timeBetween / (1000 * 60 * 60 * 24));
		return diffInDays;
	}

	@Override
	public boolean equals(Object obj) {
		return false;
	}

	@Override
	protected String parameterToString() {
		return "";
	}

	@Override
	public Command<Boolean> getNewPeriodicInstance() throws MethodException {
		ProcessDicomCorrectCommandImpl command = new ProcessDicomCorrectCommandImpl();
		command.setPeriodic(true);
		command.setPeriodicExecutionDelay(this.getPeriodicExecutionDelay());
		command.setCommandContext(this.getCommandContext());
		
		return command;		
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj) {
		// TODO Auto-generated method stub
		return false;
	}
	
	static class PurgeParameters
	{
		private String status;
		private int purgeDelayDays;
		
		public PurgeParameters(String status, int purgeDelayDays) 
		{
			this.status = status;
			this.purgeDelayDays = purgeDelayDays;
		}
		public static List<PurgeParameters> getPurgeParametersList() 
		{
			ImporterPurgeDelays delays = DicomServerConfiguration.getConfiguration().getImporterPurgeDelays();
			if (delays == null)
			{
				delays = new ImporterPurgeDelays();
			}

			// Build the list of purge delays by status
			List<PurgeParameters> purgeParameters = new ArrayList<PurgeParameters>();
			purgeParameters.add(new PurgeParameters(ImporterWorkItemStatuses.Staging, delays.getStagingPurgeDelayInDays()));
			purgeParameters.add(new PurgeParameters(ImporterWorkItemStatuses.New, delays.getNewPurgeDelayInDays()));
			purgeParameters.add(new PurgeParameters(ImporterWorkItemStatuses.InReconciliation, delays.getInReconciliationPurgeDelayInDays()));
			purgeParameters.add(new PurgeParameters(ImporterWorkItemStatuses.ImportComplete, delays.getImportCompletePurgeDelayInDays()));
			purgeParameters.add(new PurgeParameters(ImporterWorkItemStatuses.FailedImport, delays.getFailedImportPurgeDelayInDays()));
			purgeParameters.add(new PurgeParameters(ImporterWorkItemStatuses.FailedStaging, delays.getFailedStagingPurgeDelayInDays()));
			purgeParameters.add(new PurgeParameters(ImporterWorkItemStatuses.FailedDirectImportStaging, delays.getFailedDirectImportStagingPurgeDelayInDays()));
			purgeParameters.add(new PurgeParameters(ImporterWorkItemStatuses.CancelledStaging, delays.getCancelledStagingPurgeDelayInDays()));
			purgeParameters.add(new PurgeParameters(ImporterWorkItemStatuses.CancelledDirectImportStaging, delays.getCancelledDirectImportStagingPurgeDelayInDays()));
			purgeParameters.add(new PurgeParameters(ImporterWorkItemStatuses.ReadyForImport, delays.getReadyForImportPurgeDelayInDays()));
			purgeParameters.add(new PurgeParameters(ImporterWorkItemStatuses.Importing, delays.getImportingPurgeDelayInDays()));
			
			return purgeParameters;
		}
		public void setStatus(String status) {
			this.status = status;
		}
		public String getStatus() {
			return status;
		}
		public void setPurgeDelayDays(int purgeDelayDays) {
			this.purgeDelayDays = purgeDelayDays;
		}
		public int getPurgeDelayDays() {
			return purgeDelayDays;
		}
		
	}
	
	private void updateDicomCorrectStatistics(){
		
        //Total DICOM Correct changed.  Check Count in VistA HIS.
		if(logger.isDebugEnabled()){
            logger.debug("{}:  Updating RAD/CON DICOM Correct Statistics.", this.getClass().getName());}
		try{
			DicomCorrectInfo info = new DicomCorrectInfo();
			DicomServiceStats dicomStats = DicomServiceStats.getInstance();
			
			info.setHostname(DicomServerConfiguration.getConfiguration().getHostName());
			info.setServiceType(InstrumentConfig.RadiologyServiceCode);
			int radObjectsToCorrect = router.getDicomCorrectCount(info);
			dicomStats.setTotalRADObjectsToCorrectForHDIG(radObjectsToCorrect);
			
			info.setServiceType(InstrumentConfig.ConsultServiceCode);
			int conObjectsToCorrect = router.getDicomCorrectCount(info);
			dicomStats.setTotalCONObjectsToCorrectForHDIG(conObjectsToCorrect);
			
			// Get the work item totals
			WorkItemCounts counts = this.getDicomImporterService().getWorkItemCounts();
			
			// Set the totals for various work item subtypes and statuses of interest
			dicomStats.setDicomCorrectWorkItemCount(
					counts.getCountForSubtypeAndStatus(
							ImporterWorkItemSubtypes.DicomCorrect, 
							ImporterWorkItemStatuses.New));

			dicomStats.setNetworkImportWorkItemCount(
					counts.getCountForSubtypeAndStatus(
							ImporterWorkItemSubtypes.NetworkImport, 
							ImporterWorkItemStatuses.New));
			
			dicomStats.setStagedMediaWorkItemCount(
					counts.getCountForSubtypeAndStatus(
							ImporterWorkItemSubtypes.StagedMedia, 
							ImporterWorkItemStatuses.New));
			
			List<String> allSubtypes = new ArrayList<String>();
			allSubtypes.add(ImporterWorkItemSubtypes.DicomCorrect);
			allSubtypes.add(ImporterWorkItemSubtypes.DirectImport);
			allSubtypes.add(ImporterWorkItemSubtypes.NetworkImport);
			allSubtypes.add(ImporterWorkItemSubtypes.StagedMedia);
			
			dicomStats.setFailedWorkItemCount(
					counts.getCountForSubtypesAndStatus(
							allSubtypes, 
							ImporterWorkItemStatuses.FailedImport));
			
		}
		catch(ConnectionException cX){
            logger.warn("{}: Failed to get number of Objects in DICOM Correct.  Will try again later.", this.getClass().getName());
		}
		catch(MethodException mX){
            logger.warn("{}: Failed to get number of Objects in DICOM Correct.  Will try again later.", this.getClass().getName());
		}
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
		String message = "The ProcessDicomCorrect periodic command has shut down due to invalid HDIG service account credentials.";
		NotificationFacade.sendNotification(NotificationTypes.InvalidServiceAccountCredentials, subject, message);
	}
	
	private void refreshRadiologyOrder(Patient reconciledPatient, Order reconciledOrder)
	{
		try
		{
			OrderFilter filter = new OrderFilter();
			filter.setDfn(reconciledPatient.getDfn());
			filter.setOrderType("RAD");
			List<Order> ordersForPatient = InternalDicomContext.getRouter().getOrderListForPatient(filter);
			
			for (Order refreshedOrder : ordersForPatient)
			{
				int reconciledOrderId = reconciledOrder.getId();
				int refreshedOrderId = refreshedOrder.getId();
				if (reconciledOrderId == refreshedOrderId)
				{
					reconciledOrder.setExamStatus(refreshedOrder.getExamStatus());
					reconciledOrder.setAccessionNumber(refreshedOrder.getAccessionNumber());
					reconciledOrder.setVistaGeneratedStudyUid(refreshedOrder.getVistaGeneratedStudyUid());
				}
			}
		}
		catch (Exception e)
		{
			logger.warn("Unable to get refreshed order for patient.", e);
		}
	}
}
