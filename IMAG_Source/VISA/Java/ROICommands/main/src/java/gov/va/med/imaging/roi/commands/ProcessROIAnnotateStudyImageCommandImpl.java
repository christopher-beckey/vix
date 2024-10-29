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

import java.io.InputStream;
import java.nio.channels.Channels;

import gov.va.med.URNFactory;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationDetails;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.exchange.storage.cache.ImmutableInstance;
import gov.va.med.imaging.roi.ROIStudy;
import gov.va.med.imaging.roi.ROIStudyList;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIImage;
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.cache.ROIAnnotationCache;
import gov.va.med.imaging.roi.cache.ROIMetadataCache;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;
import gov.va.med.imaging.roi.commands.mbean.ROICommandsStatistics;
import gov.va.med.imaging.router.commands.AbstractImagingCommandImpl;
import gov.va.med.imaging.router.commands.CommonImageCacheFunctions;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.storage.cache.InstanceReadableByteChannel;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;

/**
 * Step 3: For each image in the study that has annotations, burn the annotations into the image
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ProcessROIAnnotateStudyImageCommandImpl
extends AbstractImagingCommandImpl<ROIWorkItem>
{
	private static final long serialVersionUID = 3076755600511810609L;
	
	private final ROIWorkItem workItem;
	
	public ProcessROIAnnotateStudyImageCommandImpl(ROIWorkItem workItem)
	{
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
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_BURNING_ANNOTATIONS, cX);
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
		
		for(ROIStudy study : roiStudyList.getStudies())
		{
			if(!study.isError() && !study.isProcessedByDicomExport())
			{
				for(ROIImage image : study.getImages())
				{
					if(image.isHasAnnotations() && image.isImageLoaded())
					{
						try
						{
							ImageURN imageUrn = URNFactory.create(image.getImageUrn());
							ImageAnnotationDetails imageAnnotationDetails =
								ImagingContext.getRouter().getMostRecentImageAnnotationDetails(imageUrn);				
							// get image from "normal" cache (not annotated
							ImmutableInstance immutableInstance =
								CommonImageCacheFunctions.getImmutableInstance(getCommandContext(), imageUrn, 
										image.getCachedImageQuality(), 
										image.getCachedImageFormat().getMimeWithEnclosedMime());
							try
							{
								InstanceReadableByteChannel cacheReadChannel = (immutableInstance == null ? null : immutableInstance.getReadableChannel());
								if(immutableInstance != null && cacheReadChannel != null)
								{							
									// image is in the cache and we have a usable ReadableByteChannel, stream the image
									InputStream cacheInStream = Channels.newInputStream(cacheReadChannel);
									try
									{
										DataSourceInputStream dataSourceInputStream = 
											ROICommandsContext.getRouter().burnImageAnnotationDetails(cacheInStream, image.getCachedImageFormat(),
													imageAnnotationDetails);
										
										// put the image into the annotated cache
										ROIAnnotationCache cache = ROIAnnotationCache.getInstance(getCommandContext(), imageUrn, 
												image.getCachedImageQuality(), image.getCachedImageFormat());
										// Must be like this for Fortify
										cacheInStream = dataSourceInputStream.getInputStream();
										cache.cacheItem(cacheInStream);
										image.setAnnotationsBurned(true);
									}
									catch(MethodException mX)
									{
                                        getLogger().warn("Error burning annotations for image '{}', {}", image.getImageUrn(), mX.getMessage());
									}
									catch(ConnectionException cX)
									{
                                        getLogger().warn("Error burning annotations for image '{}', {}", image.getImageUrn(), cX.getMessage());
									}
									finally
									{
										try { if (cacheInStream != null) { cacheInStream.close(); } } catch (Exception e) { /* Ignore */ }
									}
								}
							}
							catch(CacheException cX)
							{
                                getLogger().error("Error reading image '{}' from cache.", image.getImageUrn());
							}
						} 
						catch (URNFormatException urnfX)
						{
                            getLogger().warn("Error creating image URN from string '{}',{}", image.getImageUrn(), urnfX);
							image.setImageLoaded(false);
						}
					}
				} // end of for loop
			}
		}
		try
		{
			ROIMetadataCache.cacheROIRequest(getCommandContext(), workItem.getPatientIdentifier(), 
					workItem.getGuid(), roiStudyList);
		}
		catch (CacheException cX)
		{
			// this one is fatal
            getLogger().error("CacheException caching work item '{}' study list, {}", workItem.getGuid(), cX.getMessage());
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_BURNING_ANNOTATIONS, cX);	
			ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
			throw new MethodException(cX);
		}		
		
		if(ROICommandCommon.updateWorkItem(workItem, ROIStatus.ANNOTATIONS_BURNED))
		{
			// update the object to match the value in the database
			workItem.setStatus(ROIStatus.ANNOTATIONS_BURNED);
		}
		return workItem;
	}

	@Override
	public boolean equals(Object obj)
	{
		// TODO Auto-generated method stub
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return null;
	}

}
