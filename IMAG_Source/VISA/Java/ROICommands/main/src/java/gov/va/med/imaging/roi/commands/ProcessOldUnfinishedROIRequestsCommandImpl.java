/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 6, 2012
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

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.WorkItemTag;
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIWorkItemTag;
import gov.va.med.imaging.roi.commands.periodic.configuration.ROIPeriodicCommandConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ProcessOldUnfinishedROIRequestsCommandImpl
extends AbstractCommandImpl<java.lang.Void>
{
	private static final long serialVersionUID = 134928965666335433L;

	public ProcessOldUnfinishedROIRequestsCommandImpl()
	{
		super();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Void callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException
	{
		getLogger().info("Finding old unfinished ROI work items");
		findUnfinishedOldWorkItems();
		return null;
	}
	
	private void findUnfinishedOldWorkItems()
	throws InvalidUserCredentialsException
	{
		for(ROIStatus status : ROIStatus.getProcessingStatuses())
		{
			findUnfinishedOldWorkItems(status);
		}
	}
	
	private void findUnfinishedOldWorkItems(ROIStatus status)
	throws InvalidUserCredentialsException
	{		
		TransactionContextFactory.get().addDebugInformation("Finding unfinished work items with status '" + status + "'.");
		Calendar expiredTime = Calendar.getInstance();
		// if the item has been in the state for more than 2 hours, consider it old and needing to restart
		// set the expired time to the configured length * -1 so we subtract that value from the current time to get the last time it would be ok
		expiredTime.add(Calendar.MINUTE, ROIPeriodicCommandConfiguration.getROIPeriodicCommandConfiguration().getProcessingWorkItemWaitTime() * -1); 
		Date expiredDate = expiredTime.getTime();
		ROIWorkItemFilter filter = new ROIWorkItemFilter();
		filter.setSiteId(getCommandContext());
        getLogger().info("Searching for unfinished old work items with status '{}'.", status);
		filter.setStatus(status.getStatus());
		try
		{
			List<WorkItem> processingItems = WorkListContext.getInternalRouter().getWorkItemList(filter);
			for(WorkItem workItem : processingItems)
			{
				ROIWorkItem roiWorkItem = new ROIWorkItem(workItem);
				Date workItemDate = roiWorkItem.getLastUpdateDate();
				// if the expired date (x hours ago) is after the last time this was touched, then reset it
				if(workItemDate != null && expiredDate.after(workItemDate))
				{
					// reset it's status
					roiWorkItem.setRetryCount(roiWorkItem.getRetryCount() + 1);
					if(ROICommandCommon.updateWorkItemTagHandleException(roiWorkItem, 
							new WorkItemTag(ROIWorkItemTag.retryCount.getTagName(), roiWorkItem.getRetryCount() + "")))
					{
						ROICommandCommon.updateWorkItemHandleException(roiWorkItem, 
								status.getPreviousStatus());
					}
				}
			}
		} 
		catch(InvalidUserCredentialsException iucX)
		{
			throw iucX;
		}
		catch (MethodException e)
		{
            getLogger().error("MethodException retrieving unfinished old work items with status '{}', {}", status.name(), e.getMessage(), e);
		} 
		catch (ConnectionException e)
		{
            getLogger().error("ConnectionException retrieving unfinished old work items with status '{}', {}", status.name(), e.getMessage(), e);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		if(obj instanceof ProcessOldUnfinishedROIRequestsCommandImpl)
			return true;
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		return "";
	}

}
