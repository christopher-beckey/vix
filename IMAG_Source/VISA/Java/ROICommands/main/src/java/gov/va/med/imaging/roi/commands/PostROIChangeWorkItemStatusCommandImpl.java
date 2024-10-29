/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 2, 2012
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

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.exchange.business.WorkItemTag;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.ROIWorkItemTag;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;

/**
 * @author VHAISWWERFEJ
 *
 */
public class PostROIChangeWorkItemStatusCommandImpl
extends AbstractCommandImpl<Boolean>
{
	private static final long serialVersionUID = -2600660607872799664L;
	
	private final String guid;
	private final ROIStatus newStatus;
	
	public PostROIChangeWorkItemStatusCommandImpl(String guid, ROIStatus newStatus)
	{
		this.guid = guid;
		this.newStatus = newStatus;
	}

	public String getGuid()
	{
		return guid;
	}

	public ROIStatus getNewStatus()
	{
		return newStatus;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Boolean callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
        getLogger().info("Updating status of ROI request '{}' to '{}'.", getGuid(), getNewStatus().name());
		ROIWorkItem workItem = ROICommandsContext.getRouter().getROIWorkItem(getGuid());
		workItem.getWorkItemMessage().setErrorMessage(""); // clear the error message
		workItem.setExportQueueUrn(null); // clear this value so it can be procesed again
		
		if( ROICommandCommon.updateWorkItem(workItem, getNewStatus()))
		{
			workItem.setStatus(getNewStatus());
			boolean done = (getNewStatus().isComplete() || getNewStatus().isError());
			ROICommandCommon.updateWorkItemTag(workItem, 
					new WorkItemTag(ROIWorkItemTag.completed.getTagName(), 
							(done == true ? ROIWorkItem.workItemCompletedValue : ROIWorkItem.workItemNotCompletedValue)));
			return true;
		}
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		return false;
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
