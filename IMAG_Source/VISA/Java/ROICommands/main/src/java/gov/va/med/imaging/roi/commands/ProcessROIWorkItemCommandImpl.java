/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 12, 2012
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

import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * This command processes all steps of a specific work item
 * @author VHAISWWERFEJ
 *
 */
@RouterCommandExecution(asynchronous=true, distributable=true)
public class ProcessROIWorkItemCommandImpl
extends AbstractCommandImpl<java.lang.Void>
{
	private static final long serialVersionUID = 8211340768135266882L;
	
	private final String guid;
	
	public ProcessROIWorkItemCommandImpl(String guid)
	{
		this.guid = guid;
	}
	
	public String getGuid()
	{
		return guid;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Void callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException
	{
        getLogger().info("Processing ROI work item '{}'.", getGuid());
		ROIWorkItem workItem = ROICommandsContext.getRouter().getROIWorkItem(getGuid());
		while(workItem != null && workItem.getStatus().isWaiting())
		{
			workItem = processWorkItemNextStep(workItem);
		}
		if(workItem != null)
            getLogger().info("ROI Work item '{}' no longer in status to process, may be complete - stopping processing of work item.", getGuid());
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		if(obj instanceof ProcessROIWorkItemCommandImpl)
		{
			ProcessROIWorkItemCommandImpl other = (ProcessROIWorkItemCommandImpl)obj;
			return this.getGuid().equals(other.getGuid());
		}
		return false;
	}
	
	private ROIWorkItem processWorkItemNextStep(ROIWorkItem workItem) 
	throws MethodException, ConnectionException
	{
        getLogger().info("ROI Work item has status '{}, will attempt to move to next status and process", workItem.getStatus());
		ROIWorkItem updatedWorkItem = null;
		switch(workItem.getStatus())
		{
			case NEW:
				updatedWorkItem = transitionWorkItemToNewStatus(workItem, ROIStatus.LOADING_STUDY);
				return ROICommandsContext.getRouter().processROIGetStudyImages(updatedWorkItem);
			case STUDY_LOADED:
				updatedWorkItem = transitionWorkItemToNewStatus(workItem, ROIStatus.CACHING_IMAGES);
				return ROICommandsContext.getRouter().processROICacheStudyImages(updatedWorkItem);
			case IMAGES_CACHED:
				updatedWorkItem = transitionWorkItemToNewStatus(workItem, ROIStatus.BURNING_ANNOTATIONS);
				return ROICommandsContext.getRouter().processROIAnnotateStudyImages(updatedWorkItem);
			case ANNOTATIONS_BURNED:
				updatedWorkItem = transitionWorkItemToNewStatus(workItem, ROIStatus.MERGING_IMAGES);
				return ROICommandsContext.getRouter().processROIMergeImages(updatedWorkItem);	
			default:
                getLogger().info("ROI Work Item '{}' is in non-processable status (may indicate it is complete), stopping processing.", getGuid());
				return null;
		}
	}
	
	private ROIWorkItem transitionWorkItemToNewStatus(ROIWorkItem workItem, ROIStatus newStatus) 
	throws MethodException, ConnectionException
	{
		WorkItem item = WorkListContext.getInternalRouter().getAndTransitionWorkItem(workItem.getWorkItem().getId(), 
				workItem.getStatus().getStatus(), newStatus.getStatus(), getUserDuz(), getUpdatingApplication());
		return new ROIWorkItem(item);
	}
	
	protected String getUserDuz()
	{
		return TransactionContextFactory.get().getDuz();
	}
	
	protected String getUpdatingApplication()
	{
		return "ROIWebApp";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		return getGuid();
	}
}