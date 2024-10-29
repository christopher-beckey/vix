/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 23, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.roi.rest.translator;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.roi.ROIExtendedWorkItem;
import gov.va.med.imaging.roi.ROIImage;
import gov.va.med.imaging.roi.ROIStudy;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.commands.periodic.configuration.ROIPeriodicCommandConfiguration;
import gov.va.med.imaging.roi.queue.DicomExportQueue;
import gov.va.med.imaging.roi.queue.NonDicomExportQueue;
import gov.va.med.imaging.roi.rest.types.ROIConfigurationType;
import gov.va.med.imaging.roi.rest.types.ROIDicomExportQueueType;
import gov.va.med.imaging.roi.rest.types.ROIExtendedRequestType;
import gov.va.med.imaging.roi.rest.types.ROIImageType;
import gov.va.med.imaging.roi.rest.types.ROINonDicomExportQueueType;
import gov.va.med.imaging.roi.rest.types.ROIRequestType;
import gov.va.med.imaging.roi.rest.types.ROIStudyType;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIRestTranslator
{
	public static ROIRequestType translate(WorkItem workItem)
	{
		return translate(new ROIWorkItem(workItem));
	}
	
	public static ROIRequestType translate(ROIWorkItem workItem)
	{
		if(workItem == null)
			return null;
		
		ROIRequestType result = null;
		ROIExtendedWorkItem extendedWorkItem = null;
		if(workItem instanceof ROIExtendedWorkItem)
		{
			extendedWorkItem = (ROIExtendedWorkItem)workItem;
		}
		if(extendedWorkItem != null)
			result = new ROIExtendedRequestType();
		else
			result = new ROIRequestType();
		// make error message always appear (Jerry wanted it this way)
		String errorMessage = workItem.getWorkItemMessage().getErrorMessage();		
		result.setErrorMessage(errorMessage == null ? "" : "" + errorMessage);
		result.setGuid(workItem.getGuid());
		result.setStatus(workItem.getStatus().name());
		
		result.setStudyIds(workItem.getWorkItemMessage().getStudyUrns());
		result.setPatientId(workItem.getPatientIdentifier().toString());
		result.setPatientName(workItem.getPatientName());
		result.setPatientSsn(workItem.getPatientSsn());
		
		if(workItem.getStatus() == ROIStatus.ROI_COMPLETE)
		{
			result.setResultUri("?patientId=" + result.getPatientId() + "&guid=" + result.getGuid());
		}
		else
		{
			result.setResultUri("");
		}
		
		String dateFormat = "MM/dd/yyyy@kk:mm:ss";
		Date lastUpdateDate = workItem.getLastUpdateDate();
		if(lastUpdateDate != null)
		{
			// Jerry wanted the date with leading 0's for the month and day
			SimpleDateFormat lastUpdateDateFormat = new SimpleDateFormat(dateFormat);
			result.setLastUpdateDate(lastUpdateDateFormat.format(lastUpdateDate));
		}
		else
		{
			result.setLastUpdateDate(null);
		}
		
		Date createdDate = workItem.getCreatedDate();
		if(createdDate != null)
		{
			// Jerry wanted the date with leading 0's for the month and day
			SimpleDateFormat lastUpdateDateFormat = new SimpleDateFormat(dateFormat);
			result.setCreatedDate(lastUpdateDateFormat.format(createdDate));
		}
		else
		{
			result.setCreatedDate(null);
		}
		
		// ensure the exportQueueUrn always appears even if null
		String exportQueueUrn = workItem.getExportQueueUrn();
		result.setExportQueue(exportQueueUrn == null ? "" : "" + exportQueueUrn);
		
		if(extendedWorkItem != null)
		{
			
			ROIExtendedRequestType extendedResult = (ROIExtendedRequestType)result;
			extendedResult.setRetryCount(workItem.getRetryCount());
			extendedResult.setOutputGuid(workItem.getOutputGuid());
			// it can be null depending on the status of the work item
			if(extendedWorkItem.getRoiStudyList() != null)
			{
				List<ROIStudy> studies = extendedWorkItem.getRoiStudyList().getStudies();
				ROIStudyType []studyTypes = new ROIStudyType[studies.size()];
				for(int i = 0; i < studies.size(); i++ )
				{
					ROIStudy study = studies.get(i);
					studyTypes[i] = translate(study);
				}
				extendedResult.setStudies(studyTypes);
			}
		}
		
		return result;
	}
	
	private static ROIStudyType translate(ROIStudy study)
	{
		ROIStudyType result = new ROIStudyType();
		result.setErrorMessage(study.getErrorMessage());
		result.setFailedStatus(study.getFailedStatus() == null ? null : study.getFailedStatus().name());
		result.setProcessedByDicomExport(study.isProcessedByDicomExport());
		result.setStudyId(study.getStudyUrn());
		if(study.getImages() != null)
			result.setImages(translateROIImages(study.getImages()));
		
		return result;
	}
	
	private static ROIImageType [] translateROIImages(List<ROIImage> images)
	{
		ROIImageType [] result = new ROIImageType[images.size()];
		for(int i = 0; i < images.size(); i++)
		{
			result[i] = translate(images.get(i));
		}
		return result;
	}
	
	private static ROIImageType translate(ROIImage image)
	{
		ROIImageType result = new ROIImageType();
		
		result.setAnnotationsBurned(image.isAnnotationsBurned());
		result.setCachedImageFormat(image.getCachedImageFormat() == null ? "" : "" + image.getCachedImageFormat().name());
		result.setCachedImageQuality(image.getCachedImageQuality() == null ? "" : "" + image.getCachedImageQuality().name());
		result.setHasAnnotations(image.isHasAnnotations());
		result.setImageId(image.getImageUrn());
		result.setImageLoaded(image.isImageLoaded());
		result.setImageError(image.getImageError());
		
		return result;
	}
	
	public static ROIRequestType [] translate(List<WorkItem> workItems)
	{
		if(workItems == null)
			return null;
		ROIRequestType [] result = new ROIRequestType[workItems.size()];
		for(int i = 0; i < workItems.size(); i++)
		{
			ROIWorkItem roiWorkItem = new ROIWorkItem(workItems.get(i));
			result[i] = translate(roiWorkItem);
		}
		return result;
	}

	public static ROIDicomExportQueueType [] translateDicomExportQueues(List<DicomExportQueue> dicomQueues)
	{
		ROIDicomExportQueueType [] result = new ROIDicomExportQueueType [dicomQueues.size()];
		for(int i = 0; i < dicomQueues.size(); i++)
		{
			result[i] = translate(dicomQueues.get(i));
		}
		return result;
	}
	
	private static ROIDicomExportQueueType translate(DicomExportQueue dicomQueue)
	{
		ROIDicomExportQueueType result = new ROIDicomExportQueueType();
		result.setLocation(dicomQueue.getLocation());
		result.setName(dicomQueue.getName());
		result.setQueueId(dicomQueue.getQueueUrn().toString());
		return result;
	}
	
	public static ROINonDicomExportQueueType [] translateNonDicomExportQueues(List<NonDicomExportQueue> dicomQueues)
	{
		ROINonDicomExportQueueType [] result = new ROINonDicomExportQueueType [dicomQueues.size()];
		for(int i = 0; i < dicomQueues.size(); i++)
		{
			result[i] = translate(dicomQueues.get(i));
		}
		return result;
	}
	
	private static ROINonDicomExportQueueType translate(NonDicomExportQueue dicomQueue)
	{
		ROINonDicomExportQueueType result = new ROINonDicomExportQueueType();
		result.setLocation(dicomQueue.getLocation());
		result.setName(dicomQueue.getName());
		result.setQueueId(dicomQueue.getQueueUrn().toString());
		return result;
	}
	
	public static ROIConfigurationType translate(ROIPeriodicCommandConfiguration configuration)
	{
		return new ROIConfigurationType(configuration.isPeriodicROIProcessingEnabled(), 
				configuration.getProcessingWorkItemWaitTime(), configuration.isProcessWorkItemImmediately(),
				configuration.getExpireCompletedItemsAfterDays(), configuration.isExpireCompletedItemsEnabled());
	}
}
