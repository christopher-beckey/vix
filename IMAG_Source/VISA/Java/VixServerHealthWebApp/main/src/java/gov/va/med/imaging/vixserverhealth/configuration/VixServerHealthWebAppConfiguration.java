/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 19, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.vixserverhealth.configuration;

import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;

/**
 * @author vhaiswwerfej
 *
 */
public class VixServerHealthWebAppConfiguration 
extends AbstractBaseFacadeConfiguration 
{
	private Integer threadPoolThreshold = null;
	private Double driveCapacityCriticalLimit = null;
	private Integer threadProcessingTimeCriticalLimit = null;
	private Integer reloadPageIntervalSeconds = null;
	private Double driveFreeSpaceCriticalLimit = null; // the minimum safe amount of free space on the drive for the cache (in GB)
	private Integer maximum8080ActiveRequests = null;
	private Integer maximum8442ActiveRequests = null;
	private Integer maximum8443ActiveRequests = null;
	private Integer active8080RequestsThreshold = null;
	private Integer active8442RequestsThreshold = null;
	private Integer active8443RequestsThreshold = null;
	
	public VixServerHealthWebAppConfiguration()
	{
		super();
	}
	
	/**
	 * @return the threadPoolThreshold
	 */
	public Integer getThreadPoolThreshold() {
		return threadPoolThreshold;
	}

	/**
	 * @param threadPoolThreshold the threadPoolThreshold to set
	 */
	public void setThreadPoolThreshold(Integer threadPoolThreshold) {
		this.threadPoolThreshold = threadPoolThreshold;
	}

	/**
	 * @return the driveCapacityCriticalLimit
	 */
	public Double getDriveCapacityCriticalLimit() {
		return driveCapacityCriticalLimit;
	}

	/**
	 * @param driveCapacityCriticalLimit the driveCapacityCriticalLimit to set
	 */
	public void setDriveCapacityCriticalLimit(Double driveCapacityCriticalLimit) {
		this.driveCapacityCriticalLimit = driveCapacityCriticalLimit;
	}

	/**
	 * @return the threadProcessingTimeCriticalLimit
	 */
	public Integer getThreadProcessingTimeCriticalLimit() {
		return threadProcessingTimeCriticalLimit;
	}

	/**
	 * @param threadProcessingTimeCriticalLimit the threadProcessingTimeCriticalLimit to set
	 */
	public void setThreadProcessingTimeCriticalLimit(
			Integer threadProcessingTimeCriticalLimit) {
		this.threadProcessingTimeCriticalLimit = threadProcessingTimeCriticalLimit;
	}
	
	/**
	 * @return the reloadPageIntervalSeconds
	 */
	public Integer getReloadPageIntervalSeconds() {
		return reloadPageIntervalSeconds;
	}

	public Double getDriveFreeSpaceCriticalLimit()
	{
		return driveFreeSpaceCriticalLimit;
	}

	public void setDriveFreeSpaceCriticalLimit(Double driveFreeSpaceCriticalLimit)
	{
		this.driveFreeSpaceCriticalLimit = driveFreeSpaceCriticalLimit;
	}

	/**
	 * @param reloadPageIntervalSeconds the reloadPageIntervalSeconds to set
	 */
	public void setReloadPageIntervalSeconds(Integer reloadPageIntervalSeconds) {
		this.reloadPageIntervalSeconds = reloadPageIntervalSeconds;
	}
	
	public Integer getMaximum8080ActiveRequests()
	{
		return maximum8080ActiveRequests;
	}

	public void setMaximum8080ActiveRequests(Integer maximum8080ActiveRequests)
	{
		this.maximum8080ActiveRequests = maximum8080ActiveRequests;
	}

	public Integer getMaximum8442ActiveRequests()
	{
		return maximum8442ActiveRequests;
	}

	public void setMaximum8442ActiveRequests(Integer maximum8442ActiveRequests)
	{
		this.maximum8442ActiveRequests = maximum8442ActiveRequests;
	}

	public Integer getMaximum8443ActiveRequests()
	{
		return maximum8443ActiveRequests;
	}

	public void setMaximum8443ActiveRequests(Integer maximum8443ActiveRequests)
	{
		this.maximum8443ActiveRequests = maximum8443ActiveRequests;
	}

	public Integer getActive8080RequestsThreshold()
	{
		return active8080RequestsThreshold;
	}

	public void setActive8080RequestsThreshold(Integer active8080RequestsThreshold)
	{
		this.active8080RequestsThreshold = active8080RequestsThreshold;
	}

	public Integer getActive8442RequestsThreshold()
	{
		return active8442RequestsThreshold;
	}

	public void setActive8442RequestsThreshold(Integer active8442RequestsThreshold)
	{
		this.active8442RequestsThreshold = active8442RequestsThreshold;
	}

	public Integer getActive8443RequestsThreshold()
	{
		return active8443RequestsThreshold;
	}

	public void setActive8443RequestsThreshold(Integer active8443RequestsThreshold)
	{
		this.active8443RequestsThreshold = active8443RequestsThreshold;
	}

	public static synchronized VixServerHealthWebAppConfiguration getVixServerHealthWebAppConfiguration()
	{
		try
		{
			return FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(
					VixServerHealthWebAppConfiguration.class);
		}
		catch(CannotLoadConfigurationException clcX)
		{
			return null;
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration#loadDefaultConfiguration()
	 */
	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration() 
	{
		this.threadPoolThreshold = 100;
		this.driveCapacityCriticalLimit = 85.0d;
		this.threadProcessingTimeCriticalLimit = 3600000; // 1 hour
		this.reloadPageIntervalSeconds = 1200; // 20 minutes
		this.driveFreeSpaceCriticalLimit = 20.0d; // must have at least 20 GB free space		
		this.active8080RequestsThreshold = 140;
		this.active8442RequestsThreshold = 140;
		this.active8443RequestsThreshold = 140;
		this.maximum8080ActiveRequests = 150;
		this.maximum8442ActiveRequests = 150;
		this.maximum8443ActiveRequests = 150;
		return this;
	}

	public static void main(String [] args)
	{
		VixServerHealthWebAppConfiguration config = VixServerHealthWebAppConfiguration.getVixServerHealthWebAppConfiguration();
		config.loadDefaultConfiguration();
		config.storeConfiguration();
	}

}
