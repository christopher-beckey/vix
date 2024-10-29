/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 30, 2012
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

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.exchange.business.WorkItemTag;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.ROIWorkItemTag;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROICommandCommon
{
	private final static Logger logger = Logger.getLogger(ROICommandCommon.class);
	
	public static Boolean updateWorkItemTagHandleException(ROIWorkItem workItem, WorkItemTag newTag)
	{
		List<WorkItemTag> newTags = new ArrayList<WorkItemTag>();
		newTags.add(newTag);
		return updateWorkItemTagsHandleException(workItem, newTags);
	}
	
	public static Boolean updateWorkItemTagsHandleException(ROIWorkItem workItem, List<WorkItemTag> newTags)
	{
		try
		{
			return updateWorkItemTags(workItem, newTags);
		} 
		catch (MethodException e)
		{
			updateWorkItemErrorHandleException(workItem, workItem.getStatus().getFailedStatus(), e);
			return false;
		} 
		catch (ConnectionException e)
		{
			updateWorkItemErrorHandleException(workItem, workItem.getStatus().getFailedStatus(), e);
			return false;
		}
	}
	
	public static Boolean updateWorkItemTag(ROIWorkItem workItem, WorkItemTag newTag)
	throws MethodException, ConnectionException
	{
		List<WorkItemTag> newTags = new ArrayList<WorkItemTag>();
		newTags.add(newTag);
		return updateWorkItemTags(workItem, newTags);
	}
	
	public static Boolean updateWorkItemTags(ROIWorkItem workItem, List<WorkItemTag> newTags)
	throws MethodException, ConnectionException
	{
		List<String> allowedStatuses = new ArrayList<String>();
		allowedStatuses.add(workItem.getStatus().getStatus());
		return WorkListContext.getInternalRouter().postWorkItemTags(workItem.getWorkItem().getId(), 
				allowedStatuses, newTags, TransactionContextFactory.get().getDuz(), "ROIWebApp");
	}
	
	public static Boolean updateWorkItem(ROIWorkItem workItem, ROIStatus newStatus) 
	throws MethodException, ConnectionException
	{
		return WorkListContext.getInternalRouter().updateWorkItem(workItem.getWorkItem().getId(), 
				workItem.getStatus().getStatus(), newStatus.getStatus(),
				workItem.getWorkItemMessageXml(), TransactionContextFactory.get().getDuz(), "ROIWebApp");
	}
	
	public static Boolean updateWorkItemHandleException(ROIWorkItem workItem, ROIStatus newStatus) 
	{
		try
		{
			return updateWorkItem(workItem, newStatus);
		} 
		catch (MethodException e)
		{
			updateWorkItemErrorHandleException(workItem, newStatus.getFailedStatus(), e);
			return false;
		} 
		catch (ConnectionException e)
		{
			updateWorkItemErrorHandleException(workItem, newStatus.getFailedStatus(), e);
			return false;
		}
	}
	
	public static Boolean updateWorkItemError(ROIWorkItem workItem, ROIStatus failedStatus, Throwable t)
	throws MethodException, ConnectionException
	{
		workItem.getWorkItemMessage().setErrorMessage(t.getMessage());
		if( WorkListContext.getInternalRouter().updateWorkItem(workItem.getWorkItem().getId(), 
				workItem.getStatus().getStatus(), failedStatus.getStatus(),
				workItem.getWorkItemMessageXml(), TransactionContextFactory.get().getDuz(), "ROIWebApp"))
		{
			// failed status should be an error, but just in case
			if(failedStatus.isError() || failedStatus.isComplete())
			{
				updateWorkItemTag(workItem, new WorkItemTag(ROIWorkItemTag.completed.getTagName(), ROIWorkItem.workItemCompletedValue));
			}
			
			return true;
		}
		return false;
	}
	
	private static Boolean updateWorkItemErrorHandleException(ROIWorkItem workItem, ROIStatus failedStatus, Throwable t)
	{
		try
		{
			return updateWorkItemError(workItem, failedStatus, t);
		} 
		catch (MethodException e)
		{
			// if this throws an exception, we're pretty screwed
            logger.error("MethodException updating a work item with a failed status, {}", e.getMessage(), e);
			return false;
		} 
		catch (ConnectionException e)
		{
            logger.error("ConnectionException updating a work item with a failed status, {}", e.getMessage(), e);
			return false;
		}		
	}

}
