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
package gov.va.med.imaging.roi.commands;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.URNFactory;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.enums.VistaImageType;
import gov.va.med.imaging.roi.ROIStudy;
import gov.va.med.imaging.roi.ROIStudyList;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIImage;
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.cache.ROIMetadataCache;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;
import gov.va.med.imaging.roi.commands.mbean.ROICommandsStatistics;
import gov.va.med.imaging.roi.commands.periodic.configuration.ROIPeriodicCommandConfiguration;
import gov.va.med.imaging.roi.queue.AbstractExportQueueURN;
import gov.va.med.imaging.router.commands.AbstractStudyCommandImpl;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * Step 1: Get the list of images for each study specified in the ROI request and put the metadata into the cache
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ProcessROIGetStudyImagesCommandImpl
extends AbstractStudyCommandImpl<ROIWorkItem>
{
	private static final long serialVersionUID = -4286520137341939873L;
	private final ROIWorkItem workItem;
	
	public ProcessROIGetStudyImagesCommandImpl(ROIWorkItem workItem)
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
		// Get the export priority
		int exportPriority = 500;
		ROIPeriodicCommandConfiguration roiPeriodicCommandConfiguration = ROIPeriodicCommandConfiguration.getROIPeriodicCommandConfiguration();
		if (roiPeriodicCommandConfiguration != null) {
			exportPriority = roiPeriodicCommandConfiguration.getExportQueueRequestExportPriority();
		}

		// loop through each study in the request, get the images in the study and put that information into the cache

		String [] studyUrns = workItem.getWorkItemMessage().getStudyUrns();
		ROIStudyList cachedStudyList = new ROIStudyList(workItem.getGuid());
		boolean atLeastOneStudyToProcess = false;
				
		for(String roiRequestStudyUrn : studyUrns)
		{
			ROIStudy roiStudy = new ROIStudy(roiRequestStudyUrn);
			cachedStudyList.addStudy(roiStudy);
			StudyURN studyUrn = null;
			try
			{
				studyUrn = URNFactory.create(roiRequestStudyUrn);
			}
			catch(URNFormatException urnfX)
			{
				// this is fatal for the study but not the request
				roiStudy.setError(urnfX, workItem.getStatus());
			}
			
			if(!roiStudy.isError())
			{
				boolean fatalException = false;
				//boolean processedByDicomExport = false;
				try
				{
					// make sure not getting the study from the cache, always want the latest and greatest
					Study study = getPatientStudy(studyUrn, false, false);					
					
					roiStudy.setProcedure(study.getProcedure());
					roiStudy.setProcedureDate(study.getProcedureDate());
					roiStudy.setDescription(study.getDescription());
					if(study.getFirstImage() != null)
					{
						int imgType = study.getFirstImageType();
						roiStudy.setVistaImageType(imgType);
						if(imgType == VistaImageType.DICOM.getImageType() || imgType == VistaImageType.XRAY.getImageType())
						{
							if(getWorkItem().isExportQueueUrnSpecified())
							{
								try
								{
									AbstractExportQueueURN exportQueueUrn = URNFactory.create(workItem.getExportQueueUrn());	
									// hand off to DICOM Gateway, done!
                                    getLogger().info("Study has img type' {}', handing off to DICOM Gateway for export with priority {}", imgType, exportPriority);
									TransactionContextFactory.get().addDebugInformation("Study has img type' " + imgType + "', handing off to DICOM Gateway for export.");
									roiStudy.setProcessedByDicomExport(true);
									ROICommandsContext.getRouter().postExportQueueRequest(exportQueueUrn, studyUrn, exportPriority);
									//processedByDicomExport = true;
									ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiStudiesSentToExportQueue();
								}
								catch(URNFormatException urnfX)
								{
									fatalException = true;
									throw new MethodException(urnfX);
								}
							}
							else
							{
								fatalException = true;
								throw new MethodException("Study '" + roiRequestStudyUrn + "' is a DICOM study but an export queue was not specified, cannot disclose");
							}					
						}
						else
						{
							atLeastOneStudyToProcess = true;
						}
					}
					
					// this probably isn't necessary if processing by DICOM export but I guess it won't hurt
					List<ROIImage> images = getImageList(study);
					roiStudy.setImages(images);
				}
				catch(MethodException mX)
				{
					if(!fatalException)
					{
						// this is fatal for the study but not the request
						roiStudy.setError(mX, workItem.getStatus());
					}
					else
					{
						// fatal exception that should cause the entire ROI request to fail
						ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_LOADING_STUDY, mX);
						ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
						throw mX;
					}
				}
			}
		}
		try
		{
			ROIMetadataCache.cacheROIRequest(getCommandContext(), workItem.getPatientIdentifier(), 
					workItem.getGuid(), cachedStudyList);
		} 
		catch (CacheException cX)
		{
            getLogger().error("CacheException caching work item '{}' study list, {}", workItem.getGuid(), cX.getMessage());
			ROICommandCommon.updateWorkItemError(workItem, ROIStatus.FAILED_LOADING_STUDY, cX);	
			ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosureProcessingErrors();
			// this one is fatal
			throw new MethodException(cX);
		}
		
		ROIStatus nextStatus = ROIStatus.STUDY_LOADED;
		if(!atLeastOneStudyToProcess)
		{
			nextStatus = ROIStatus.EXPORT_QUEUE;
		}
		
		if(ROICommandCommon.updateWorkItem(workItem, nextStatus))
		{
			// update the object to match the value in the database
			workItem.setStatus(nextStatus);
		}
		return workItem;
	}
	
	private List<ROIImage> getImageList(Study study)
	{
		List<ROIImage> images = new ArrayList<ROIImage>();
		for(Series series : study)
		{
			for(Image image : series)
			{
				if(!image.isDeleted())
				{
					images.add(new ROIImage(image.getImageUrn().toStringCDTP(), 
						image.isImageHasAnnotations()));
				}
			}
		}
		return images;
	}

	@Override
	public boolean equals(Object obj)
	{
		if(obj instanceof ProcessROIGetStudyImagesCommandImpl)
		{
			ProcessROIGetStudyImagesCommandImpl that = (ProcessROIGetStudyImagesCommandImpl)obj;
			return this.getWorkItem().getGuid().equals(that.getWorkItem().getGuid());
		}
		return false;
	}

	@Override
	protected String parameterToString()
	{
		return this.getWorkItem().getGuid();
	}

}
