/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 19, 2013
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
package gov.va.med.imaging.roi.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement
public class ROIConfigurationType
{

	private boolean periodicROIProcessingEnabled;
	private int processingWorkItemWaitTime; // number of minutes to wait for a work item in process before restarting it
	private boolean processWorkItemImmediately; // if true a work item is started as soon as it is requested
	private int expireCompletedItemsAfterDays;
	private boolean expireCompletedItemsEnabled;
	
	public ROIConfigurationType()
	{
		super();
	}
	
	/**
	 * @param periodicROIProcessingEnabled
	 * @param processingWorkItemWaitTime
	 * @param processWorkItemImmediately
	 * @param expireCompletedItemsAfterDays
	 * @param expireCompletedItemsEnabled
	 */
	public ROIConfigurationType(boolean periodicROIProcessingEnabled,
			int processingWorkItemWaitTime, boolean processWorkItemImmediately,
			int expireCompletedItemsAfterDays,
			boolean expireCompletedItemsEnabled)
	{
		super();
		this.periodicROIProcessingEnabled = periodicROIProcessingEnabled;
		this.processingWorkItemWaitTime = processingWorkItemWaitTime;
		this.processWorkItemImmediately = processWorkItemImmediately;
		this.expireCompletedItemsAfterDays = expireCompletedItemsAfterDays;
		this.expireCompletedItemsEnabled = expireCompletedItemsEnabled;
	}

	public boolean isPeriodicROIProcessingEnabled()
	{
		return periodicROIProcessingEnabled;
	}

	public void setPeriodicROIProcessingEnabled(boolean periodicROIProcessingEnabled)
	{
		this.periodicROIProcessingEnabled = periodicROIProcessingEnabled;
	}

	public int getProcessingWorkItemWaitTime()
	{
		return processingWorkItemWaitTime;
	}

	public void setProcessingWorkItemWaitTime(int processingWorkItemWaitTime)
	{
		this.processingWorkItemWaitTime = processingWorkItemWaitTime;
	}

	public boolean isProcessWorkItemImmediately()
	{
		return processWorkItemImmediately;
	}

	public void setProcessWorkItemImmediately(boolean processWorkItemImmediately)
	{
		this.processWorkItemImmediately = processWorkItemImmediately;
	}

	public int getExpireCompletedItemsAfterDays()
	{
		return expireCompletedItemsAfterDays;
	}

	public void setExpireCompletedItemsAfterDays(int expireCompletedItemsAfterDays)
	{
		this.expireCompletedItemsAfterDays = expireCompletedItemsAfterDays;
	}

	public boolean isExpireCompletedItemsEnabled()
	{
		return expireCompletedItemsEnabled;
	}

	public void setExpireCompletedItemsEnabled(boolean expireCompletedItemsEnabled)
	{
		this.expireCompletedItemsEnabled = expireCompletedItemsEnabled;
	}
}
