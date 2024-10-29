/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 20, 2009
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
package gov.va.med.imaging.vistadatasource.session.configuration;

import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;

/**
 * Configuration for VistaSession objects.  Determines what type of connection should be made
 * and how long a session should stay alive after being idle.
 * 
 * @author vhaiswwerfej
 *
 */
public class VistaSessionConfiguration 
extends AbstractBaseFacadeConfiguration
{
	private long sessionMaxIdleTime;
	private boolean capriRemoteLoginEnabled;
	private boolean bseRemoteLoginEnabled;
	private boolean brokerKeepAliveEnabled;
	private long bseCacheRefreshTime;
	private long bseCacheRetentionTime;
	
	private static final long DEFAULT_MAXIMUM_IDLE_TIME = 30000;
	
	public VistaSessionConfiguration()
	{
		sessionMaxIdleTime = DEFAULT_MAXIMUM_IDLE_TIME; // 30 seconds
		capriRemoteLoginEnabled = true;
		bseRemoteLoginEnabled = true;
		brokerKeepAliveEnabled = false;
		bseCacheRefreshTime = 0; // Used to be 5 minutes
		bseCacheRetentionTime = 0; // Used to be 10 minutes
	}

	/**
	 * @return the sessionMaxIdleTime
	 */
	public long getSessionMaxIdleTime() {
		return sessionMaxIdleTime;
	}

	/**
	 * @param sessionMaxIdleTime the sessionMaxIdleTime to set
	 */
	public void setSessionMaxIdleTime(long sessionMaxIdleTime) {
		this.sessionMaxIdleTime = sessionMaxIdleTime;
	}

	/**
	 * @return the capriRemoteLoginEnabled
	 */
	public boolean isCapriRemoteLoginEnabled() {
		return capriRemoteLoginEnabled;
	}

	/**
	 * @param capriRemoteLoginEnabled the capriRemoteLoginEnabled to set
	 */
	public void setCapriRemoteLoginEnabled(boolean capriRemoteLoginEnabled) {
		this.capriRemoteLoginEnabled = capriRemoteLoginEnabled;
	}

	/**
	 * @return the bseRemoteLoginEnabled
	 */
	public boolean isBseRemoteLoginEnabled() {
		return bseRemoteLoginEnabled;
	}

	/**
	 * @param bseRemoteLoginEnabled the bseRemoteLoginEnabled to set
	 */
	public void setBseRemoteLoginEnabled(boolean bseRemoteLoginEnabled) {
		this.bseRemoteLoginEnabled = bseRemoteLoginEnabled;
	}

	/**
	 * @return the brokerKeepAliveEnabled
	 */
	public boolean isBrokerKeepAliveEnabled()
	{
		return brokerKeepAliveEnabled;
	}

	/**
	 * @param brokerKeepAliveEnabled the brokerKeepAliveEnabled to set
	 */
	public void setBrokerKeepAliveEnabled(boolean brokerKeepAliveEnabled)
	{
		this.brokerKeepAliveEnabled = brokerKeepAliveEnabled;
	}

	public long getBseCacheRefreshTime() {
		return bseCacheRefreshTime;
	}

	public void setBseCacheRefreshTime(long bseCacheRefreshTime) {
		this.bseCacheRefreshTime = bseCacheRefreshTime;
	}

	public long getBseCacheRetentionTime() {
		return bseCacheRetentionTime;
	}

	public void setBseCacheRetentionTime(long bseCacheRetentionTime) {
		this.bseCacheRetentionTime = bseCacheRetentionTime;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration#loadDefaultConfiguration()
	 */
	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration() 
	{
		this.sessionMaxIdleTime = DEFAULT_MAXIMUM_IDLE_TIME; // 30 seconds
		this.capriRemoteLoginEnabled = true;
		this.bseRemoteLoginEnabled = true;
		this.bseCacheRefreshTime = 1000 * 60 * 5; // 5 minutes
		this.bseCacheRetentionTime = 0;
		return this;
	}
	
	public synchronized static VistaSessionConfiguration getConfiguration()
	{
		try
		{
			return FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(
					VistaSessionConfiguration.class);
		}
		catch(CannotLoadConfigurationException clcX)
		{
			return null;
		}
	}
	
	public static void main(String [] args)
	{
		VistaSessionConfiguration config = getConfiguration();
		
		if((args == null) || (args.length == 0))
		{
			System.out.println("No arguments provided, using default values.");
			//System.out.println(getArgumentsMessage());
		}
		else if(args.length == 4)
		{
			boolean capri = Boolean.parseBoolean(args[0]);
			boolean bse = Boolean.parseBoolean(args[1]);
			long timeout = Long.parseLong(args[2]);
			boolean keepAlive = Boolean.parseBoolean(args[3]);
			config.setBseRemoteLoginEnabled(bse);
			config.setCapriRemoteLoginEnabled(capri);
			config.setSessionMaxIdleTime(timeout);
			config.setBrokerKeepAliveEnabled(keepAlive);
		}
		else if(args.length == 6)
		{
			config.setBseRemoteLoginEnabled(Boolean.parseBoolean(args[1]));
			config.setCapriRemoteLoginEnabled(Boolean.parseBoolean(args[0]));
			config.setSessionMaxIdleTime(Long.parseLong(args[2]));
			config.setBrokerKeepAliveEnabled(Boolean.parseBoolean(args[3]));
			config.setBseCacheRefreshTime(Long.parseLong(args[4]));
			config.setBseCacheRetentionTime(Long.parseLong(args[5]));
		}
		else
		{
			System.out.println("Invalid number of arguments provided, must either be 0 or 4");
			System.out.println(getArgumentsMessage());
		}
		
		config.storeConfiguration();
	}
	
	private static String getArgumentsMessage()
	{
		StringBuilder sb = new StringBuilder();
		
		
		sb.append("Arguments are the following:");
		sb.append("\n");
		sb.append("<true/false for CAPRI login enabled> ");
		sb.append("<true/false for BSE login enabled> ");
		sb.append("<time in ms for how long a session should last>");
		sb.append("<true/false for broker keep alive enabled>");
		sb.append("<time in ms for how often the cache is checked>");
		sb.append("<time in ms for how long things can live in the cache>");
		
		return sb.toString();
	}
}
