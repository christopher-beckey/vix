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
package gov.va.med.imaging.roi.commands.periodic.configuration;

import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.configuration.DetectConfigNonTransientValueChanges;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIPeriodicCommandConfiguration
extends AbstractBaseFacadeConfiguration
implements DetectConfigNonTransientValueChanges
{
	private EncryptedConfigurationPropertyString accessCode;
	private EncryptedConfigurationPropertyString verifyCode;
	private boolean periodicROIProcessingEnabled;
	private int processingWorkItemWaitTime; // number of minutes to wait for a work item in process before restarting it
	private boolean processWorkItemImmediately; // if true a work item is started as soon as it is requested
	private int expireCompletedItemsAfterDays;
	private boolean expireCompletedItemsEnabled;
	private int exportQueueRequestExportPriority = 500; // Used to specify export priority; default provided by client / requestor.
	
	public ROIPeriodicCommandConfiguration()
	{
		super();
	}

	public EncryptedConfigurationPropertyString getAccessCode()
	{
		return accessCode;
	}

	public void setAccessCode(EncryptedConfigurationPropertyString accessCode)
	{
		this.accessCode = accessCode;
	}

	public EncryptedConfigurationPropertyString getVerifyCode()
	{
		return verifyCode;
	}

	public void setVerifyCode(EncryptedConfigurationPropertyString verifyCode)
	{
		this.verifyCode = verifyCode;
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

	public int getExportQueueRequestExportPriority() {
		return exportQueueRequestExportPriority;
	}

	public void setExportQueueRequestExportPriority(int exportQueueRequestExportPriority) {
		this.exportQueueRequestExportPriority = exportQueueRequestExportPriority;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration#loadDefaultConfiguration()
	 */
	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration()
	{
		this.accessCode = new EncryptedConfigurationPropertyString("");
		this.verifyCode = new EncryptedConfigurationPropertyString("");
		this.periodicROIProcessingEnabled = true;
		this.processingWorkItemWaitTime = 120;
		this.processWorkItemImmediately = true;
		this.expireCompletedItemsAfterDays = 45;
		this.expireCompletedItemsEnabled = true;
		this.exportQueueRequestExportPriority = 500;
		return this;
	}
	
	public synchronized static ROIPeriodicCommandConfiguration getROIPeriodicCommandConfiguration()
	{
		try
		{
			ROIPeriodicCommandConfiguration configuration = FacadeConfigurationFactory.getConfigurationFactory()
					.getConfiguration(ROIPeriodicCommandConfiguration.class);
			configuration.hasValueChangesToPersist(true);
			return configuration;
		}
		catch(CannotLoadConfigurationException clcX)
		{
			// no need to log, already logged
			return null;
		}
	}
	
	public static void main(String [] args)
	{
		
		if(args.length == 2)
		{
			ROIPeriodicCommandConfiguration configuration = getROIPeriodicCommandConfiguration();
			configuration.setAccessCode(new EncryptedConfigurationPropertyString(args[0]));
			configuration.setVerifyCode(new EncryptedConfigurationPropertyString(args[1]));
			configuration.storeConfiguration();	
		}
		else
		{
			System.out.println("Incorrect number of parameters, two parameters <accessCode> <verifyCode> must be specified.");
		}
		
	}

	@Override
	public boolean hasValueChangesToPersist(boolean autoStoreChanges) {
		boolean retVal = false;
		if(this.accessCode != null) retVal = this.accessCode.isUnencryptedAtRest();
		if(this.verifyCode != null) retVal = retVal || this.verifyCode.isUnencryptedAtRest();
		if(autoStoreChanges && retVal){
			this.storeConfiguration();
			this.accessCode.setUnencryptedAtRest(false);
			this.verifyCode.setUnencryptedAtRest(false);
		}
		return retVal;
	}

}
