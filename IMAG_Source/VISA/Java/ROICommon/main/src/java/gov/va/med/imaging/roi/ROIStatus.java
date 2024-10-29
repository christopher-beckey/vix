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
package gov.va.med.imaging.roi;

import java.util.ArrayList;
import java.util.List;

/**
 * @author VHAISWWERFEJ
 *
 */
public enum ROIStatus
{
	
	NEW("New", false),
	LOADING_STUDY("LoadingStudy", true),
	STUDY_LOADED("StudyLoaded", false),
	CACHING_IMAGES("CachingImages", true),
	IMAGES_CACHED("ImagesCached", false),
	BURNING_ANNOTATIONS("BurningAnnotations", true),
	ANNOTATIONS_BURNED("AnnotationsBurned", false),
	MERGING_IMAGES("MergingImages", true),
	ROI_COMPLETE("RoiComplete", false),
	FAILED_LOADING_STUDY("FailedLoadingStudy", false, true),
	FAILED_CACHING_IMAGES("FailedCachingImages", false, true),
	FAILED_BURNING_ANNOTATIONS("FailedBurningAnnotations", false, true),
	FAILED_MERGING_IMAGES("FailedMergingImages", false, true),
	CANCELLED("CancelledROI", false, false),
	EXPORT_QUEUE("ExportQueue", false, false); // this happens when all the studies in the request are processed by export queue and nothing else should be done
	
	final String status;
	final boolean processing; // indicates the item is in process (doing work) and not waiting for another step
	final boolean error;	
	
	ROIStatus(String status, boolean processing, boolean error)
	{
		this.status = status;
		this.error = error;
		this.processing = processing;
	}
	
	ROIStatus(String status, boolean processing)
	{
		this(status, processing, false);
	}
	
	public ROIStatus getNextStatus()
	{
		switch(this)
		{
			case NEW:
				return LOADING_STUDY;
			case LOADING_STUDY:
				return STUDY_LOADED;
			case STUDY_LOADED:
				return CACHING_IMAGES;
			case CACHING_IMAGES:
				return IMAGES_CACHED;
			case IMAGES_CACHED:
				return BURNING_ANNOTATIONS;
			case BURNING_ANNOTATIONS:
				return ANNOTATIONS_BURNED;
			case MERGING_IMAGES:
				return ROI_COMPLETE;					
		}
		return null;
	}
	
	public ROIStatus getPreviousStatus()
	{
		switch(this)
		{
			case MERGING_IMAGES:
				return ANNOTATIONS_BURNED;
			case ANNOTATIONS_BURNED: 
				return BURNING_ANNOTATIONS;
			case BURNING_ANNOTATIONS:
				return IMAGES_CACHED;
			case IMAGES_CACHED:
				return CACHING_IMAGES;
			case CACHING_IMAGES:
				return STUDY_LOADED;
			case STUDY_LOADED:
				return LOADING_STUDY;
			case LOADING_STUDY:
				return NEW;
			case FAILED_BURNING_ANNOTATIONS:
				return IMAGES_CACHED;
			case FAILED_CACHING_IMAGES:
				return STUDY_LOADED;
			case FAILED_LOADING_STUDY:
				return NEW;
			case FAILED_MERGING_IMAGES:
				return ANNOTATIONS_BURNED;				
		}
		return null;
	}
	
	public ROIStatus getFailedStatus()
	{
		switch(this)
		{
			case LOADING_STUDY:
				return FAILED_LOADING_STUDY;
			case CACHING_IMAGES:
				return FAILED_CACHING_IMAGES;
			case BURNING_ANNOTATIONS:
				return FAILED_BURNING_ANNOTATIONS;
			case MERGING_IMAGES:
				return FAILED_MERGING_IMAGES;			
		}
		return null;
	}

	public String getStatus()
	{
		return status;
	}

	@Override
	public String toString()
	{
		return status;
	}

	public boolean isError()
	{
		return error;
	}

	public boolean isProcessing()
	{
		return processing;
	}
	
	/**
	 * Returns true if this status is not processing, in error or complete
	 * @return
	 */
	public boolean isWaiting()
	{
		if(processing)
			return false;
		if(error)
			return false;
		if(isComplete())
			return false;
		return true;
	}
	
	/**
	 * Done processing without an error
	 * @return
	 */
	public boolean isComplete()
	{
		return ((this == ROI_COMPLETE) || (this == CANCELLED) || (this == EXPORT_QUEUE));
	}

	public static ROIStatus valueOfStatus(String status)
	{
		for(ROIStatus s : values())
		{
			if(s.getStatus().equals(status))
				return s;
		}
		return null;
	}
	
	public static List<ROIStatus> getProcessingStatuses()
	{
		List<ROIStatus> result = new ArrayList<ROIStatus>();
		for(ROIStatus s : values())
		{
			if(s.isProcessing())
				result.add(s);
		}
		return result;
	}
	
	
}
