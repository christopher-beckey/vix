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
package gov.va.med.imaging.roi.commands.periodic;

import gov.va.med.imaging.roi.ROIStatus;

import java.util.ArrayList;
import java.util.List;

/**
 * @deprecated
 * @author VHAISWWERFEJ
 *
 */
public class PeriodicROICommandRunStatus
{
	//private boolean periodicROIProcessingEnabled;
	private List<ROIStatus> enabledStatuses = new ArrayList<ROIStatus>();
	
	public PeriodicROICommandRunStatus()
	{
		super();
	}

	/*
	public boolean isPeriodicROIProcessingEnabled()
	{
		return periodicROIProcessingEnabled;
	}

	public void setPeriodicROIProcessingEnabled(boolean periodicROIProcessingEnabled)
	{
		this.periodicROIProcessingEnabled = periodicROIProcessingEnabled;
	}*/

	public List<ROIStatus> getEnabledStatuses()
	{
		return enabledStatuses;
	}

	public void setEnabledStatuses(List<ROIStatus> enabledStatuses)
	{
		this.enabledStatuses = enabledStatuses;
	}
	
	private static PeriodicROICommandRunStatus periodicROICommandRunStatus = null;
	
	public synchronized static PeriodicROICommandRunStatus getPeriodicCommandRunStatus()
	{
		if(periodicROICommandRunStatus == null)
		{
			periodicROICommandRunStatus = new PeriodicROICommandRunStatus();
			periodicROICommandRunStatus.getEnabledStatuses().add(ROIStatus.BURNING_ANNOTATIONS);
			periodicROICommandRunStatus.getEnabledStatuses().add(ROIStatus.LOADING_STUDY);
			periodicROICommandRunStatus.getEnabledStatuses().add(ROIStatus.CACHING_IMAGES);
			periodicROICommandRunStatus.getEnabledStatuses().add(ROIStatus.MERGING_IMAGES);
			//periodicROICommandRunStatus.setPeriodicROIProcessingEnabled(true);
		}
		return periodicROICommandRunStatus;
	}

}
