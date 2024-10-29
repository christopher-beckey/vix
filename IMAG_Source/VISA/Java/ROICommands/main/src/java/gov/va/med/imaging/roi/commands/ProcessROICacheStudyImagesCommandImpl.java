/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 26, 2012
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
package gov.va.med.imaging.roi.commands;

import gov.va.med.URNFactory;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.roi.ROIStudy;
import gov.va.med.imaging.roi.ROIStudyList;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIImage;
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.cache.ROIMetadataCache;
import gov.va.med.imaging.roi.commands.mbean.ROICommandsStatistics;
import gov.va.med.imaging.router.commands.AbstractImageCommandImpl;
import gov.va.med.imaging.router.commands.CommonImageCacheFunctions;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;

/**
 * Step 2: For each image in each study in the ROI request cache the image locally
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ProcessROICacheStudyImagesCommandImpl
extends AbstractImageCommandImpl<ROIWorkItem>
{
	private static final long serialVersionUID = 1599201085492877475L;
	
	private final ROIWorkItem workItem;
	
	public ProcessROICacheStudyImagesCommandImpl(ROIWorkItem workItem)
	{
		super();
		this.workItem = workItem;
	}

	public ROIWorkItem getWorkItem()
	{
		return workItem;
	}

	@Override
	public ROIWorkItem callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException
	{
		ImageFormatQualityList imageFormatQualityList = 
			ImageFormatQualityList.createListFromFormatQuality(ImageFormat.ORIGINAL, ImageQuality.DIAGNOSTICUNCOMPRESSED);
		
		
		ROIStudyList roiStudyList = null;
		
		try
		{
			roiStudyList =
				ROIMetadataCache.getROIStudyList(getCommandContext(), workItem.getPatientIdentifier(), 
						workItem.getGuid());
		}
		catch(CacheException cX)
		{
			// this occurs if there is a problem with the cache, not if the item is not in the cache. If this occurs it is not recoverable
            getLogger().warn("CacheException reading study list work item '{}' from cache,{}", workItem.getGuid(), cX);
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_CACHING_IMAGES, cX);
			ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
			throw new MethodException(cX);
		}
		
		if(roiStudyList == null)
		{
			// did not get it from the cache, need to re-load it
            getLogger().info("Work item '{}' is not in the cache, resetting to status '{}' to start over.", workItem.getGuid(), ROIStatus.NEW);
			ROICommandCommon.updateWorkItem(workItem, ROIStatus.NEW);
			return null;
		}
		// make sure that at least one image in the request was cached - otherwise fail the request
		boolean atLeastOneImageSuccessful = false;
		
		for(ROIStudy study : roiStudyList.getStudies())
		{
			if(!study.isError() && !study.isProcessedByDicomExport())
			{
				for(final ROIImage image : study.getImages())
				{
					ImageURN imageUrn = null;
					try
					{
						imageUrn = URNFactory.create(image.getImageUrn());
						if(!CommonImageCacheFunctions.isImageCached(getCommandContext(), imageUrn, imageFormatQualityList))
						{
							try
							{
								ImagingContext.getRouter().prefetchInstanceByImageUrnSync(imageUrn, 
									imageFormatQualityList, new ImageMetadataNotification()
									{
										
										@Override
										public void imageMetadata(String checksumValue, ImageFormat imageFormat,
												int fileSize, ImageQuality imageQuality)
										{
											image.setCachedImageFormat(imageFormat);
											image.setCachedImageQuality(imageQuality);
										}
									});	
								image.setImageLoaded(true);
								atLeastOneImageSuccessful = true;
							}
							catch(MethodException mX)
							{
                                getLogger().error("Error caching image '{}', {}", image.getImageUrn(), mX.getMessage());
								image.setImageError(mX.getMessage());
								image.setImageLoaded(false);
							}
							catch(ConnectionException cX)
							{
                                getLogger().error("Error caching image '{}', {}", image.getImageUrn(), cX.getMessage());
								image.setImageError(cX.getMessage());
								image.setImageLoaded(false);
							}
						}
					} 
					catch (URNFormatException urnfX)
					{
						// no longer a fatal error for the request
                        getLogger().warn("Error creating image URN from string '{}',{}", image.getImageUrn(), urnfX);
						image.setImageLoaded(false);
					}
				} // image
			} // study
		}
		try
		{
			ROIMetadataCache.cacheROIRequest(getCommandContext(), workItem.getPatientIdentifier(), 
					workItem.getGuid(), roiStudyList);
		}
		catch (CacheException cX)
		{
            getLogger().error("CacheException caching work item '{}' study list, {}", workItem.getGuid(), cX.getMessage());
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_CACHING_IMAGES, cX);
			ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
			// this one is fatal
			throw new MethodException(cX);
		}
		
		if(!atLeastOneImageSuccessful)
		{
			MethodException mx = new MethodException("None of the images in ROI request '" + workItem.getGuid() + "' were able to be loaded, stopping processsing.");
			getLogger().error(mx.getMessage());
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_CACHING_IMAGES, mx);
			ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
			throw mx;
		}
		
		if(ROICommandCommon.updateWorkItem(workItem, ROIStatus.IMAGES_CACHED))
		{
			// update the object to match the value in the database
			workItem.setStatus(ROIStatus.IMAGES_CACHED);
		}
				
		return workItem;
	}

	@Override
	public boolean equals(Object obj)
	{
		return false;
	}

	@Override
	protected String parameterToString()
	{
		return null;
	}

}
