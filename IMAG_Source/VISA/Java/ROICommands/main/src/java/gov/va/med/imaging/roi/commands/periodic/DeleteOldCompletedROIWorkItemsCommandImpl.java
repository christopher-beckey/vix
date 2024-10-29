/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 27, 2012
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
package gov.va.med.imaging.roi.commands.periodic;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import gov.va.med.imaging.GUID;
import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.Command;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.WorkItemTags;
import gov.va.med.imaging.notifications.NotificationFacade;
import gov.va.med.imaging.notifications.NotificationTypes;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIWorkItemTag;
import gov.va.med.imaging.roi.commands.ROIWorkItemFilter;
import gov.va.med.imaging.roi.commands.mbean.ROICommandsStatistics;
import gov.va.med.imaging.roi.commands.periodic.configuration.ROIPeriodicCommandConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * This command finds old completed work items and deletes them
 * 
 * @author VHAISWWERFEJ
 *
 */
@RouterCommandExecution(asynchronous=true, distributable=true)
public class DeleteOldCompletedROIWorkItemsCommandImpl
extends AbstractCommandImpl<java.lang.Void>
{
	private static final long serialVersionUID = 5793687178362947152L;
	
	public DeleteOldCompletedROIWorkItemsCommandImpl()
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
		if(isPeriodic())
		{
			TransactionContext transactionContext = TransactionContextFactory.get(); 
			transactionContext.setTransactionId( (new GUID()).toLongString() );
			transactionContext.setRequestType("ROI Purge Completed Work Items");
		}
		ROIWorkItemFilter filter = new ROIWorkItemFilter();
		filter.setSiteId(getCommandContext());
		// JMW - search based on the completed tag for any status
		WorkItemTags tags = new WorkItemTags();
		tags.addTag(ROIWorkItemTag.completed.getTagName(), ROIWorkItem.workItemCompletedValue);
		filter.setTags(tags);
		
		int expireDays = ROIPeriodicCommandConfiguration.getROIPeriodicCommandConfiguration().getExpireCompletedItemsAfterDays();
		if(expireDays <= 0)
		{
			getLogger().info("Completed ROI work items will not be purged");
			return null;
		}
		
		Calendar expiredTime = Calendar.getInstance();
		expiredTime.add(Calendar.DAY_OF_YEAR, expireDays * -1); 
		Date expiredDate = expiredTime.getTime();

        getLogger().info("Searching for ROI work items with tag of '{}'.", ROIWorkItemTag.completed.getTagName());
		
		List<WorkItem> completedWorkItems =
			WorkListContext.getInternalRouter().getWorkItemList(filter);
        getLogger().info("Found '{}' completed work items, purging those that are more than '{}' days old.", completedWorkItems.size(), expireDays);
		for(WorkItem workItem : completedWorkItems)
		{
			ROIWorkItem roiWorkItem = new ROIWorkItem(workItem);
			Date workItemDate = roiWorkItem.getLastUpdateDate();
			// if the expired date (x days ago) is after the last time this was touched, then delete it
			if(workItemDate != null && expiredDate.after(workItemDate))
			{
				deleteWorkItem(roiWorkItem);
			}
		}
		return null;
	}
	
	private void deleteWorkItem(ROIWorkItem workItem)
	throws InvalidUserCredentialsException
	{
        getLogger().info("Deleting work item '{}'.", workItem.getGuid());
		try
		{
			WorkListContext.getInternalRouter().deleteWorkItem(workItem.getWorkItem().getId());
		} 
		catch(InvalidUserCredentialsException iucX)
		{
			// fatal, throw this one
			throw iucX;
		}
		catch (MethodException mX)
		{
			// not fatal, allowed to continue
            getLogger().error("MethodException deleting ROI work item '{}', {}", workItem.getGuid(), mX.getMessage(), mX);
		} 
		catch (ConnectionException cX)
		{
			// not fatal, allowed to continue
            getLogger().error("ConnectionException deleting ROI work item '{}', {}", workItem.getGuid(), cX.getMessage(), cX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		return "";
	}
	
	@Override
	public List<Class<? extends MethodException>> getFatalPeriodicExceptionClasses()
	{
		List<Class<? extends MethodException>> fatalExceptions = new ArrayList<Class<? extends MethodException>>();
		fatalExceptions.add(InvalidUserCredentialsException.class);
		return fatalExceptions;
	}

	@Override
	public void handleFatalPeriodicException(Throwable t)
	{
        getLogger().error("ROI Delete Completed ROI Work Items had a fatal exception ({}) and is shutting down.", t.getClass().getName());
		ROICommandsStatistics stats = ROICommandsStatistics.getRoiCommandsStatistics();
		stats.setRoiCompletedItemsPurgeProcessing(false);
		
		String subject = "Invalid VIX ROI service account credentials";
		String message = "The DeleteOldCompletedROIWorkItems periodic command has shut down due to invalid VIX ROI service account credentials.";
		NotificationFacade.sendNotification(NotificationTypes.InvalidServiceAccountCredentials, subject, message);
	}

	@Override
	public Command<Void> getNewPeriodicInstance() 
	throws MethodException
	{
		DeleteOldCompletedROIWorkItemsCommandImpl command = new DeleteOldCompletedROIWorkItemsCommandImpl();
		command.setPeriodic(true);
		command.setPeriodicExecutionDelay(this.getPeriodicExecutionDelay());
		command.setPriority(this.getPriority().ordinal());
		command.setChildCommand(this.isChildCommand());
		command.setCommandContext(getCommandContext());
		return command;
	}
}
