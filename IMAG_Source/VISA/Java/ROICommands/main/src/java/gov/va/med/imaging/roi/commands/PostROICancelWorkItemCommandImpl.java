/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 18, 2012
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
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;
import gov.va.med.imaging.roi.commands.mbean.ROICommandsStatistics;

/**
 * @author VHAISWWERFEJ
 *
 */
public class PostROICancelWorkItemCommandImpl
extends AbstractCommandImpl<Boolean>
{
	private static final long serialVersionUID = -8635423323128711110L;
	private final String guid;
	
	public PostROICancelWorkItemCommandImpl(String guid)
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
	public Boolean callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
		ROIWorkItem workItem = ROICommandsContext.getRouter().getROIWorkItem(getGuid());
		ROIStatus currentStatus = workItem.getStatus();
		if(currentStatus.isComplete())
		{
            getLogger().info("ROI Work item '{}' is already complete, cannot cancel.", getGuid());
			return false;
		}
		else if(currentStatus.isError())
		{
            getLogger().info("ROI Work item '{}' is in error state '{}', cannot cancel.", getGuid(), currentStatus);
			return false;
		}
        getLogger().info("ROI Work item '{}' is in status '{}', setting status to cancelled", getGuid(), currentStatus);
		ROICommandCommon.updateWorkItem(workItem, ROIStatus.CANCELLED);
		ROICommandsStatistics.getRoiCommandsStatistics().incrementRoiDisclosuresCancelled();
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		if(obj instanceof PostROICancelWorkItemCommandImpl)
		{
			PostROICancelWorkItemCommandImpl that = (PostROICancelWorkItemCommandImpl)obj;
			return this.getGuid().equals(that.getGuid());
		}
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
