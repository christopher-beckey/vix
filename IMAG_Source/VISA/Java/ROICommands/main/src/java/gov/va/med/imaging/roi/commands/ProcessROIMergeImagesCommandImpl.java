/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 27, 2012
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

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;

import gov.va.med.PatientIdentifier;
import gov.va.med.URNFactory;
import gov.va.med.imaging.GUID;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.WorkItemTag;
import gov.va.med.imaging.exchange.storage.DataSourceImageInputStream;
import gov.va.med.imaging.roi.ROIStudy;
import gov.va.med.imaging.roi.ROIStudyList;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIImage;
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.ROIWorkItemTag;
import gov.va.med.imaging.roi.cache.ROIAnnotationCache;
import gov.va.med.imaging.roi.cache.ROIDisclosureCache;
import gov.va.med.imaging.roi.cache.ROIMetadataCache;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;
import gov.va.med.imaging.roi.commands.mbean.ROICommandsStatistics;
import gov.va.med.imaging.router.commands.AbstractStudyCommandImpl;
import gov.va.med.imaging.router.commands.CommonImageCacheFunctions;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;

/**
 * Step 4: Merge the images into a PDF Disclosure
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ProcessROIMergeImagesCommandImpl
extends AbstractStudyCommandImpl<ROIWorkItem>
{
	private static final long serialVersionUID = -6906048872905653768L;
	
	private final ROIWorkItem workItem;
	
	public ProcessROIMergeImagesCommandImpl(ROIWorkItem workItem)
	{
		super();
		this.workItem = workItem;
	}

	public ROIWorkItem getWorkItem()
	{
		return workItem;
	}
	
	private void setOutputGuid(String guid)
	throws MethodException, ConnectionException
	{
		ROICommandCommon.updateWorkItemTag(getWorkItem(), 
				new WorkItemTag(ROIWorkItemTag.outputGuid.getTagName(), guid));
	}

	@Override
	public ROIWorkItem callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException
	{
		ROIStudyList roiStudyList = null;
		PatientIdentifier patientIdentifier = workItem.getPatientIdentifier();
		try
		{
			roiStudyList =
				ROIMetadataCache.getROIStudyList(getCommandContext(), patientIdentifier, 
						workItem.getGuid());
		}
		catch(CacheException cX)
		{
			// this occurs if there is a problem with the cache, not if the item is not in the cache. If this occurs it is not recoverable
            getLogger().warn("CacheException reading study list work item '{}' from cache,{}", workItem.getGuid(), cX);
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_MERGING_IMAGES, cX);
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
		
		String groupIdentifier = new GUID().toLongString();// workItem.getGuid(); // not sure if this should be the work item GUID or a new one - if the work item already tried to do the merge then this folder might already exist
		workItem.setOutputGuid(groupIdentifier);
		Patient patient = null;
		try
		{
			setOutputGuid(groupIdentifier);
			
			patient = ImagingContext.getRouter().getPatientInformation(getRoutingToken(), patientIdentifier);
		}
		catch(MethodException mX)
		{
            getLogger().error("MethodException loading patient information before doing disclosure merge, {}", mX.getMessage());
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_MERGING_IMAGES, mX);
			ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
			throw mX;
		}
		catch(ConnectionException cX)
		{
            getLogger().error("ConnectionException loading patient information before doing disclosure merge, {}", cX.getMessage());
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_MERGING_IMAGES, cX);
			ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
			throw cX;
		}
		catch(Exception ex)
		{
            getLogger().error("Exception loading study/patient information before doing disclosure merge, {}", ex.getMessage());
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_MERGING_IMAGES, ex);
			ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
			throw new MethodException(ex);
		}
		
		for(ROIStudy study : roiStudyList.getStudies())
		{
			if(!study.isError() && !study.isProcessedByDicomExport())
			{
				int imageNumber = 0;
				for(ROIImage image : study.getImages())
				{
					imageNumber++;
					if(image.isImageLoaded())
					{
						OutputStream outputStream = null;
						
						// Can't use try-with-resources
						try
						{
							ImageURN imageUrn = URNFactory.create(image.getImageUrn());
							
							//StudyURN studyUrn = URNFactory.create(workItem.getTags().getValue(RoiWorkItemTag.studyUrn.getTagName()));
							outputStream = ROICommandsContext.getRouter().getMergeImageOutputStream(groupIdentifier, 
															imageUrn.getImageId(), image.getCachedImageFormat(),
															getImageDescription(study, imageNumber));
							// image is loaded into cache, check to see if it was annotated
							try
							{
								if(image.isAnnotationsBurned())
								{
									// get from annotation burned location in cache
									ROIAnnotationCache cache = ROIAnnotationCache.getInstance(getCommandContext(), 
											imageUrn, image.getCachedImageQuality(), image.getCachedImageFormat());
									cache.streamItemFromCache(outputStream);			
								}
								else
								{
									// get the image from the "normal" cache
									ImageFormatQualityList requestAcceptList = 
										ImageFormatQualityList.createListFromFormatQuality(
												image.getCachedImageFormat(), 
												image.getCachedImageQuality());
									CommonImageCacheFunctions.streamImageFromCache(getCommandContext(), 
											imageUrn, requestAcceptList, outputStream, null);						
								}
							}
							catch(IOException ioX)
							{
                                getLogger().warn("IOException writing image from cache to writer output, {}", ioX.getMessage());
							}					
						}
						catch(URNFormatException urnfX)
						{
                            getLogger().warn("Error creating image URN from string '{}',{}", image.getImageUrn(), urnfX);
							image.setImageLoaded(false);
						}
						finally
						{
							try { if (outputStream != null) { outputStream.close(); } } catch (Exception e) { /* Ignore */ }
						}
					}
					else
					{
						// can't do anything with this image
                        getLogger().warn("Image '{}' was not loaded, cannot merge", image.getImageUrn());
					}			
				} // end of image for loop	
			}
			
		}// end of study for loop
		
		InputStream inStream = null; 
		
		// Can't use try-with-resources
		try
		{
			DataSourceImageInputStream dataSourceImageInputStream =
				ROICommandsContext.getRouter().getMergeObjectsResponse(groupIdentifier, patient);
			
			GUID guid = new GUID( getWorkItem().getGuid());
			
			ROIDisclosureCache disclosureCache = ROIDisclosureCache.getInstance(getCommandContext(), patientIdentifier, guid);
			inStream = dataSourceImageInputStream.getInputStream();
			disclosureCache.cacheItem(inStream);
			
			//ROICacheFunctions.cacheROIDisclosure(getCommandContext(), studyUrn, guid, dataSourceImageInputStream);
			
			if(ROICommandCommon.updateWorkItem(workItem, ROIStatus.ROI_COMPLETE))
			{
				// update the object to match the value in the database
				workItem.setStatus(ROIStatus.ROI_COMPLETE);
				workItem.setCompleted(true);
				ROICommandCommon.updateWorkItemTag(workItem, 
						new WorkItemTag(ROIWorkItemTag.completed.getTagName(), ROIWorkItem.workItemCompletedValue));
				ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosuresCompleted();
			}
		}
		catch(MethodException mX)
		{
            getLogger().error("MethodException merging/caching result for work item '{}', {}", getWorkItem().getGuid(), mX.getMessage());
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_MERGING_IMAGES, mX);
			ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
			throw mX;
		}
		catch(ConnectionException cX)
		{
            getLogger().error("ConnectionException merging/caching result for work item '{}', {}", getWorkItem().getGuid(), cX.getMessage());
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_MERGING_IMAGES, cX);
			ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
			throw cX;
		}
		catch(Exception ex)
		{
            getLogger().error("Exception merging/caching result for work item '{}', {}", getWorkItem().getGuid(), ex.getMessage());
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_MERGING_IMAGES, ex);
			ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
			throw new MethodException(ex);			
		}
		finally 
		{
			try { if (inStream != null) { inStream.close(); } } catch (Exception e) { /* Ignore */ }
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
		return getWorkItem().getGuid();
	}
	
	private String getImageDescription(ROIStudy study, int imageNumber)
	{
		SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
		return study.getProcedure() + " - " + study.getDescription() + " [" + format.format(study.getProcedureDate()) + "] - " + imageNumber;
	}

}
