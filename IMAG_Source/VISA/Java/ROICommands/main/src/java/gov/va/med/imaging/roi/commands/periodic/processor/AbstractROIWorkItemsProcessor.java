/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 29, 2012
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
package gov.va.med.imaging.roi.commands.periodic.processor;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIValues;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author VHAISWWERFEJ
 *
 */
public abstract class AbstractROIWorkItemsProcessor
{
	private final String expectedStatus;
	private final String newStatus;
	
	private final static Logger logger = Logger.getLogger(AbstractROIWorkItemsProcessor.class);
	protected Logger getLogger()
	{
		return logger;
	}
	
	public AbstractROIWorkItemsProcessor(String expectedStatus, String newStatus)
	{
		super();
		this.expectedStatus = expectedStatus;
		this.newStatus = newStatus;
	}

	public String getExpectedStatus()
	{
		return expectedStatus;
	}

	public String getNewStatus()
	{
		return newStatus;
	}

	public void processWorkItems()
	throws InvalidUserCredentialsException
	{
        getLogger().info("Processing ROI work items with status '{}'.", getExpectedStatus());
		ROIWorkItem workItem = getAndTransitionNextWorkItem(
				getExpectedStatus(),
				getNewStatus());
		while(workItem != null)
		{
			try
			{
				// set the URN to the GUID of the work item being processed
				TransactionContextFactory.get().setUrn(workItem.getGuid());
				processWorkItem(workItem);
			} 
			catch (ConnectionException cX)
			{
				// catch exceptions to ensure processing of next work item
                getLogger().error("ConnectionException processing work item with guid '{}', {}", workItem.getGuid(), cX.getMessage());
			} 
			catch(InvalidUserCredentialsException iucX)
			{
                getLogger().error("InvalidUserCredentialsException processing work item with guid '{}', {}", workItem.getGuid(), iucX.getMessage());
				throw iucX;
			}
			catch (MethodException mX)
			{
				// catch exceptions to ensure processing of next work item
                getLogger().error("MethodException processing work item with guid '{}', {}", workItem.getGuid(), mX.getMessage());
			}
			catch(Exception ex)
			{
				// generic exception handler to ensure can process next work item
			}
			workItem = getAndTransitionNextWorkItem(
					getExpectedStatus(),
					getNewStatus());
		}
        getLogger().info("Done processing ROI work items with status '{}'.", getExpectedStatus());
	}
	
	/**
	 * This method calls the command to process the specified work item. This method may throw exceptions but they will be caught
	 * @param workItem
	 * @throws ConnectionException
	 * @throws MethodException
	 */
	protected abstract void processWorkItem(ROIWorkItem workItem)
	throws ConnectionException, MethodException;
	
	protected ROIWorkItem getAndTransitionNextWorkItem(String expectedStatus, 
			String newStatus)
	throws InvalidUserCredentialsException
	{
		try
		{
			// JMW 9/14/2012 P130 calling this method automatically only finds work items
			// for the local VIX site, not other VIX sites
			WorkItem workItem = WorkListContext.getInternalRouter().getAndTransitionNextWorkItem(
					ROIValues.ROI_WORKITEM_TYPE,
					expectedStatus, newStatus,
					getUserDuz(), getUpdatingApplication());
			if(workItem == null)
				return null;
			return new ROIWorkItem(workItem);
		} 
		catch(InvalidUserCredentialsException iucX)
		{
			throw iucX;
		}
		catch (MethodException mX)
		{
            getLogger().error("Error transitioning work item, {}", mX.getMessage());
			return null;
		} 
		catch (ConnectionException cX)
		{
            getLogger().error("Error transitioning work item, {}", cX.getMessage());
			return null;
		}
	}
	
	protected String getUserDuz()
	{
		return TransactionContextFactory.get().getDuz();
	}
	
	protected String getUpdatingApplication()
	{
		return "ROIWebApp";
	}

}
