/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 7, 2012
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

import java.util.List;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;

/**
 * @author VHAISWWERFEJ
 *
 */
public class DeleteROIWorkItemsByUserCommandImpl
extends AbstractCommandImpl<Boolean>
{
	private static final long serialVersionUID = 6028806698753269823L;

	public DeleteROIWorkItemsByUserCommandImpl()
	{
		super();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Boolean callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
		getLogger().info("Deleting all work items for user");
		List<WorkItem> workItems = ROICommandsContext.getRouter().getROIWorkItemsByUser();
		for(WorkItem workItem : workItems)
		{
			WorkListContext.getInternalRouter().deleteWorkItem(workItem.getId());
		}
		getLogger().info("Deleted all work items for user.");
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
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
