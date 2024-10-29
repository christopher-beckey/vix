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
package gov.va.med.imaging.roi.web;

import gov.va.med.imaging.roi.commands.periodic.PeriodicROICommandStarter;
import gov.va.med.imaging.roi.commands.periodic.ROIPeriodicCommandsCredentialsState;
import gov.va.med.imaging.roi.commands.periodic.configuration.ROIPeriodicCommandConfiguration;

/**
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ROIConfigurationView 
{

	private final String accessCode;
	private final String verifyCode;
	private final boolean periodicProcessingEnabled;
	private final boolean completedItemPurgeProcessingEnabled;
	private final boolean processWorkItemImmediately;
	
	private final int expireCompletedItemsAfterDays;
	private final int processingWorkItemWaitTime;
	
	public static ROIConfigurationView get()
	{
		ROIPeriodicCommandConfiguration config = ROIPeriodicCommandConfiguration.getROIPeriodicCommandConfiguration();
		String accessCode = config.getAccessCode().getValue();
		String verifyCode = config.getVerifyCode().getValue();
		
		return new ROIConfigurationView(accessCode, verifyCode, 
				config.isPeriodicROIProcessingEnabled(), 
				config.isExpireCompletedItemsEnabled(), config.isProcessWorkItemImmediately(), 
				config.getExpireCompletedItemsAfterDays(), config.getProcessingWorkItemWaitTime());
	}
	
	private ROIConfigurationView(String accessCode, String verifyCode,
			boolean periodicProcessingEnabled, boolean completedItemPurgeProcessingEnabled,
			boolean processWorkItemImmediately, int expireCompletedItemsAfterDays,
			int processingWorkItemWaitTime)
	{
		super();
		this.accessCode = accessCode;
		this.verifyCode = verifyCode;
		this.periodicProcessingEnabled = periodicProcessingEnabled;
		this.completedItemPurgeProcessingEnabled = completedItemPurgeProcessingEnabled;
		this.processWorkItemImmediately = processWorkItemImmediately;
		this.expireCompletedItemsAfterDays = expireCompletedItemsAfterDays;
		this.processingWorkItemWaitTime = processingWorkItemWaitTime;
	}

	public String getAccessCode()
	{
		return accessCode;
	}

	public String getVerifyCode()
	{
		return verifyCode;
	}

	/**
	 * Indicates if periodic processing is desired, does not indicate if it actually is working
	 * @return
	 */
	public boolean isPeriodicProcessingEnabled()
	{
		return periodicProcessingEnabled;
	}

	public boolean isCompletedItemPurgeProcessingEnabled()
	{
		return completedItemPurgeProcessingEnabled;
	}

	public boolean isProcessWorkItemImmediately()
	{
		return processWorkItemImmediately;
	}

	public int getExpireCompletedItemsAfterDays()
	{
		return expireCompletedItemsAfterDays;
	}

	public int getProcessingWorkItemWaitTime()
	{
		return processingWorkItemWaitTime;
	}
	
	/**
	 * Returns true if disclosures can be processed. False if everything is disabled
	 * @return
	 */
	public boolean isFunctionalState()
	{
		return processWorkItemImmediately || periodicProcessingEnabled;
	}
	
	/**
	 * Returns true if the credentials have been tried and they did not authenticate properly. 
	 * If the credentials are valid or have not been tried (because nothing that uses them is enabled) then this returns false
	 * @return
	 */
	public boolean isRoiCredentialsInvalid()
	{
		return PeriodicROICommandStarter.currentCredentialsState == ROIPeriodicCommandsCredentialsState.invalid;
	}
}
