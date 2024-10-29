/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 15, 2010
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
package gov.va.med.imaging.vixserverhealth.web;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.health.VixServerHealth;
import gov.va.med.imaging.health.VixServerHealthProperties;
import gov.va.med.imaging.health.VixSiteServerHealth;
import gov.va.med.imaging.vixserverhealth.configuration.VixServerHealthWebAppConfiguration;

/**
 * @author vhaiswwerfej
 *
 */
public class VixServerHealthView 
implements Comparable<VixServerHealthView>
{
	private final static Logger logger = Logger.getLogger(VixServerHealthView.class);
	
	private final Site site;
	private final VixServerHealth vixHealth;
	private final String serverName;
	private final String jvmUptime;
	private final String jvmStartTime;	
	private final Calendar dateHealthUpdated;
	private final String vixVersion;
	private final String errorMessage;
	private final boolean healthError;
	
	
	private final String vixTomcatLogsDir;
	private final String vixTomcatLogsDirSize;
	
	private final String vixCacheDir;
	private final String vixCacheDirSize;
	private final String vixCacheDirCapacity;
	private final String vixCacheDirAvailable;
	private final String vixCacheOperationsInitiated;
	private final String vixCacheOperationsSuccessful;
	private final String vixCacheOperationsError;
	private final String vixCacheOperationsNotFound;
	
	private final String realmVistaServer;
	private final String realmVistaPort;
	
	private final String http8080ThreadPoolSize;
	private final String http8080ThreadsBusy;
	
	private final String http8442ThreadPoolSize;
	private final String http8442ThreadsBusy;
	
	private final String http8443ThreadPoolSize;
	private final String http8443ThreadsBusy;

	private final String transactionLogStatsTransactionsWritten;
	private final String transactionLogStatsTransactionsQueried;
	private final String transactionLogStatsTransactionsPurged;
	private final String transactionLogStatsTransactionsPerMinute;
	private final String transactionLogStatsTransactionWriteErrors;
	private final String transactionLogStatsTransactionReadErrors;
	
	private final String transactionLogDirectory;
	private final String transactionLogDirectorySize;
	
	private final String siteServiceUrl;
	private final String siteServiceUpdatedDate;
	
	private final boolean roiPeriodicProcessingEnabled;
	private final boolean roiImmediateProcessingEnabled;
	
	private final List<VixDicomSendFailures> dicomServiceStats;
	private final static String DicomServicesStats = "_VixDicomServicesActivity_VixDicomServicesStats";
	private final static String SendFailures_DicomServiceStats = "_VixSendToAEFailures_VixDicomServicesStats_";


	
	public VixServerHealthView(VixSiteServerHealth vixHealth)
	{
		super();
		this.vixHealth = vixHealth.getVixServerHealth();
		this.errorMessage = vixHealth.getErrorMessage();
		this.dateHealthUpdated = vixHealth.getLastRefreshed();		
		this.site = vixHealth.getSite();
		this.healthError = vixHealth.isError();
	
		Map<String, String> properties = this.healthError ? null : vixHealth.getVixServerHealth().getVixServerHealthProperties();
		
		this.serverName = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_HOSTNAME));
		String jvmStartTimeRaw = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_JVM_STARTTIME));
		String jvmUptimeRaw = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_JVM_UPTIME));
		
		jvmStartTime = convertMSToTimeString(jvmStartTimeRaw);
		jvmUptime = convertRawUptimeToTimeString(jvmUptimeRaw);
		
		vixVersion = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_VERSION));
		vixTomcatLogsDir = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_TOMCAT_LOGS_DIR));
		
		vixTomcatLogsDirSize = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_TOMCAT_LOGS_DIR_SIZE));
		
		vixCacheDir = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_CACHE_DIR_KEY));
		vixCacheDirSize = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_CACHE_DIR_SIZE));		
		vixCacheDirCapacity = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_CACHE_DIR_ROOT_DRIVE_TOTAL));		
		vixCacheDirAvailable = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_CACHE_DIR_ROOT_DRIVE_AVAILABLE));		
		
		vixCacheOperationsInitiated = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_JMX_CACHE_OPERATIONS_INITIATED));
		vixCacheOperationsSuccessful = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_JMX_CACHE_OPERATIONS_SUCCESSFUL));
		vixCacheOperationsError = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_JMX_CACHE_OPERATIONS_ERROR));
		vixCacheOperationsNotFound = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_JMX_CACHE_OPERATIONS_INSTANCE_NOT_FOUND));
		
		realmVistaServer = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_REALM_JMX_VISTA_SERVER));
		realmVistaPort = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_REALM_JMX_VISTA_PORT));
		
		http8080ThreadPoolSize = (properties == null ? null : properties.get("CatalinaThreadPoolThreadCount_\"http-nio-8080\"_ThreadPool"));
		http8080ThreadsBusy = (properties == null ? null : properties.get("CatalinaThreadPoolThreadsBusy_\"http-nio-8080\"_ThreadPool"));
		http8442ThreadPoolSize = (properties == null ? null : properties.get("CatalinaThreadPoolThreadCount_\"https-jsse-nio-8442\"_ThreadPool"));
		http8442ThreadsBusy = (properties == null ? null : properties.get("CatalinaThreadPoolThreadsBusy_\"https-jsse-nio-8442\"_ThreadPool"));
		http8443ThreadPoolSize = (properties == null ? null : properties.get("CatalinaThreadPoolThreadCount_\"https-jsse-nio-8443\"_ThreadPool"));
		http8443ThreadsBusy = (properties == null ? null : properties.get("CatalinaThreadPoolThreadsBusy_\"https-jsse-nio-8443\"_ThreadPool"));
		
		transactionLogStatsTransactionsWritten = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_TRANSACTION_LOG_STATISTICS_TRANSACTIONS_WRITTEN));
		transactionLogStatsTransactionsPurged = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_TRANSACTION_LOG_STATISTICS_TRANSACTIONS_PURGED));
		transactionLogStatsTransactionsQueried = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_TRANSACTION_LOG_STATISTICS_TRANSACTIONS_QUERIED));
		transactionLogStatsTransactionReadErrors  = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_TRANSACTION_LOG_STATISTICS_TRANSACTION_READ_ERRORS));
		transactionLogStatsTransactionWriteErrors  = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_TRANSACTION_LOG_STATISTICS_TRANSACTION_WRITE_ERRORS));
		
		transactionLogStatsTransactionsPerMinute = calculateTransactionsPerMinute(jvmUptimeRaw, 
				transactionLogStatsTransactionsWritten);
		
		
		transactionLogDirectory = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_TRANSACTIONLOGS_DIR));
		transactionLogDirectorySize = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_TRANSACTIONLOGS_DIR_SIZE));	
	
		siteServiceUrl = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SITE_SERVICE_URL));
		siteServiceUpdatedDate = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SITE_SERVICE_LAST_UPDATED));
		
		String roiProcessWorkItemsImmediately = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_ROI_PROCESS_WORK_ITEMS_IMMEDIATELY));
		if(roiProcessWorkItemsImmediately == null || roiProcessWorkItemsImmediately.length() <= 0)
			roiImmediateProcessingEnabled = false;
		else
			roiImmediateProcessingEnabled = Boolean.parseBoolean(roiProcessWorkItemsImmediately);
		
		String ROIPeriodicProcessingEnabled = (properties == null ? null : properties.get(VixServerHealthProperties.VIX_SERVER_HEALTH_ROI_PERIODIC_PROCESSING_ENABLED));
		if(ROIPeriodicProcessingEnabled == null || ROIPeriodicProcessingEnabled.length() <= 0)
			roiPeriodicProcessingEnabled = false;
		else
			roiPeriodicProcessingEnabled = Boolean.parseBoolean(ROIPeriodicProcessingEnabled);
		
		dicomServiceStats = new ArrayList<VixDicomSendFailures>();
		fillDicomSendFailures(properties);


	}
	
	protected final static String passedImage = "../images/passed.gif";
	protected final static String failedImage = "../images/failed.gif";
	
	public String getVIXStatusIcon()
	{
		if(this.isHealthError())
		{
			return "<img src=\"" + passedImage + "\" alt=\"Passed\" title=\"Passed\" />";
		}
		else
		{
			return "<img src=\"" + failedImage + "\" alt=\"Failed\" title=\"Failed\" />" + getErrorMessage();
		}
	}
	
	private String calculateTransactionsPerMinute(String uptimeString,
			String transactionsWritten)
	{
		if(uptimeString == null)
			return null;
		long ms = Long.parseLong(uptimeString);
		if(ms < 1000)
			return null;
		
		long sec = (long)(ms / 1000);
		if(sec < 60)
			return null;
		long minutes = (long)(sec / 60);
		
		if(transactionsWritten == null || transactionsWritten.length() <= 0)
			return null;
		long transactions = Long.parseLong(transactionsWritten);
		
		double transPerMinute = ((double)transactions)/((double)minutes);
		DecimalFormat df = new DecimalFormat("###,###.##");
		return df.format(transPerMinute);
	}
	
	public Map<String, String> getRawHealthAttributes()
	{
		if(this.vixHealth != null)
			return this.vixHealth.getVixServerHealthProperties();
		return null;
	}
	
	private VixServerHealthWebAppConfiguration getConfiguration()
	{
		return VixServerHealthWebAppConfiguration.getVixServerHealthWebAppConfiguration();
	}
	
	public boolean isHealthy()
	{
		if(isHealthError())
			return false;
		//if(!isHttp8080ThreadPoolBelowThreshold())
		//	return false;
		//if(!isHttp8443ThreadPoolBelowThreshold())
		//	return false;
		//if(!isVixCacheBelowCriticalLimit())
		//	return false;
		//if(!isNoVixCacheErrors())
		//	return false;
		if(getThreadsProcessingAboveCriticalLimit() > 0)
			return false;
		if(!isVixRealmVistaServerConfiguredProperly())
			return false;
		if(!isVixRealmVistaPortConfiguredProperly())
			return false;
		if(!isSiteServiceDateUpdatedOk())
			return false;
		if(!isSiteServiceUrlConfiguredProperly())
			return false;
		if(!is8442RequestsOk())
			return false;
		if(!is8443RequestsOk())
			return false;
		if(!is8080RequestsOk())
			return false;
		if(!isROIProcessingEnabled())
			return false;
		return true;
	}
	
	public boolean isVixRealmVistaServerConfiguredProperly()
	{
		if((realmVistaServer != null) && (realmVistaServer.length() > 0))
		{
			String server = realmVistaServer;
			return server.equalsIgnoreCase(site.getVistaServer());
		}
		return true;	
	}
	
	public boolean isVixRealmVistaPortConfiguredProperly()
	{
		if((realmVistaPort != null) && (realmVistaPort.length() > 0))
		{
			int port = Integer.parseInt(realmVistaPort);
			return (port == site.getVistaPort());
		}
		return true;	
	}
	
	public int getThreadsProcessingAboveCriticalLimit()
	{
		if(getConfiguration().getThreadProcessingTimeCriticalLimit() == null)
			return 0;
		if(vixHealth == null)
			return -1;
		Map<String, String> properties = vixHealth.getVixServerHealthProperties();
		int count = 0;
		for(String key : properties.keySet())
		{
			if(key.startsWith("CatalinaRequestProcessingTime"))
			{
                long timeRunning = Long.parseLong(properties.get(key));
                if (timeRunning > getThreadProcessingTimeCriticalLimit())
                {
                    count++;
                }
			}
		}
		return count;
	}
	
	public int getThreadProcessingTimeCriticalLimit()
	{
		return getConfiguration().getThreadProcessingTimeCriticalLimit();
	}
	
	public boolean isNoVixCacheErrors()
	{
		if((vixCacheOperationsError != null) && (vixCacheOperationsError.length() > 0))
		{
			int vixCacheErrors = Integer.parseInt(vixCacheOperationsError);
			if(vixCacheErrors > 0)
				return false;
		}
		return true;
	}
	
	public String getVixCacheDirPercentUsedString()
	{
		double percentUsed = getVixCacheDirPercentUsed();
		if(percentUsed >= 0)
		{
			percentUsed *= 100;
			DecimalFormat df = new DecimalFormat("##0.00");
			return df.format(percentUsed);
		}
		return "";		
	}
	
	public double getVixCacheDirPercentUsed()
	{
		if((vixCacheDirCapacity != null) && (vixCacheDirCapacity.length() > 0)
				&& (vixCacheDirAvailable != null) && (vixCacheDirAvailable.length() > 0))
			{
				if(getConfiguration().getDriveCapacityCriticalLimit() != null)
				{
					long capacity = Long.parseLong(vixCacheDirCapacity);
					long available = Long.parseLong(vixCacheDirAvailable);
					long used = capacity - available;
					double percentUsed = (double)used/capacity;
					return percentUsed;
				}
			}
			return -1d;
	}
	
	private long getCacheDriveAvailable()
	{
		if((vixCacheDirAvailable != null) && (vixCacheDirAvailable.length() > 0))
		{
			long available = Long.parseLong(vixCacheDirAvailable);
			return available;
		}
		return -1l;
	}
	
	public boolean isVixCacheBelowCriticalLimit()
	{
		
		double percentUsed = getVixCacheDirPercentUsed();
		if(percentUsed >= 0)
		{
			if(percentUsed > getConfiguration().getDriveCapacityCriticalLimit())
			{
				long cacheDriveAvailable = getCacheDriveAvailable();
				if(cacheDriveAvailable > 0)
				{
					double gbAvailable = convertBytesToGB(cacheDriveAvailable);
					if(gbAvailable < getConfiguration().getDriveFreeSpaceCriticalLimit())
						return false;
				}
			}
		}
		return true;
	}
	
	public boolean isHttp8080ThreadPoolBelowThreshold()
	{
		if((http8080ThreadPoolSize != null) && (http8080ThreadPoolSize.length() > 0))
		{
			int threadPoolSize = Integer.parseInt(http8080ThreadPoolSize);
			if(getConfiguration().getThreadPoolThreshold() != null)
			{
				if(threadPoolSize > getConfiguration().getThreadPoolThreshold())
					return false;
			}
		}
		return true;
	}
	
	public boolean isHttp8443ThreadPoolBelowThreshold()
	{
		if((http8443ThreadPoolSize != null) && (http8443ThreadPoolSize.length() > 0))
		{
			int threadPoolSize = Integer.parseInt(http8443ThreadPoolSize);
			if(getConfiguration().getThreadPoolThreshold() != null)
			{
				if(threadPoolSize > getConfiguration().getThreadPoolThreshold())
					return false;
			}
		}
		return true;
	}
	
	public boolean isHttp8442ThreadPoolBelowThreshold()
	{
		if((http8442ThreadPoolSize != null) && (http8442ThreadPoolSize.length() > 0))
		{
			int threadPoolSize = Integer.parseInt(http8442ThreadPoolSize);
			if(getConfiguration().getThreadPoolThreshold() != null)
			{
				if(threadPoolSize > getConfiguration().getThreadPoolThreshold())
					return false;
			}
		}
		return true;
	}

	private double convertBytesToGB(long bytes)
	{
		double kb = (double)bytes / 1024.0f;
        double mb = kb / 1024.0f;
        double gb = mb / 1024.0f;
        return gb;
	}
	
	private String convertRawBytesToString(String rawBytes)
	{
		if((rawBytes == null) || (rawBytes.length() <= 0))
			return "";
		long bytes = Long.parseLong(rawBytes);
		if (bytes < 1024)
        {
            return bytes + " bytes";
        }
        double kb = (double)bytes / 1024.0f;
        double mb = kb / 1024.0f;
        double gb = mb / 1024.0f;
        double tb = gb / 1024.0f;
        DecimalFormat df = new DecimalFormat("#,###.00");
        if (tb > 1.0)
        {
            return df.format(tb) + " TB";
        }
        else if (gb > 1.0)
        {
            return df.format(gb) + " GB";
        }
        else if (mb > 1.0)
        {
            return df.format(mb) + " MB";
        }
        else
        {
            return df.format(kb) + " KB";
        }
	}
	
	private String convertRawUptimeToTimeString(String uptimeString)
	{
		if(uptimeString == null)
			return null;
		long ms = Long.parseLong(uptimeString);
		
		StringBuilder sb = new StringBuilder();
		String prefix = "";
		int sec = 1000;
		int min = sec * 60;
		int hour = min * 60;
		int days = hour * 24;
		
		if(ms > days)
		{
			long d = (long)(ms / days);
			ms -= d * days;
			sb.append(prefix);
			sb.append(d + " days");
			prefix = ", ";
		}
		if(ms > hour)
		{
			long d = (long)(ms / hour);
			ms -= d * hour;
			sb.append(prefix);
			sb.append(d + " hours");
			prefix = ", ";
		}
		if(ms > min)
		{
			long d = (long)(ms / min);
			ms -= d * min;
			sb.append(prefix);
			sb.append(d + " minutes");
			prefix = ", ";
		}
		if(ms > sec)
		{
			long d = (long)(ms / sec);
			ms -= d * sec;
			sb.append(prefix);
			sb.append(d + " seconds");
			prefix = ", ";
		}
		if(ms > 0)
		{	
			sb.append(prefix);
			sb.append(ms + " ms");
			prefix = ", ";
		}
		return sb.toString();
	}
	
	private String convertMSToTimeString(String time)
	{
		if(time == null)
			return null;
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(Long.parseLong(time));
		
		SimpleDateFormat formatter = getDateFormat();
		return formatter.format(c.getTime());
	}
	
	private SimpleDateFormat getDateFormat()
	{
		return new SimpleDateFormat("MMM d, yyyy h:mm:ss aa");
	}

	/**
	 * @return the site
	 */
	public Site getSite() {
		return site;
	}

	/**
	 * @return the serverName
	 */
	public String getServerName() {
		return serverName;
	}

	/**
	 * @return the jvmUptime
	 */
	public String getJvmUptime() {
		return jvmUptime;
	}

	/**
	 * @return the jvmStartTime
	 */
	public String getJvmStartTime() {
		return jvmStartTime;
	}

	/**
	 * @return the dateHealthUpdated
	 */
	public String getDateHealthUpdated() 
	{
		return getDateFormat().format(dateHealthUpdated.getTime());
	}

	/**
	 * @return the vixVersion
	 */
	public String getVixVersion() {
		return vixVersion;
	}

	/**
	 * @return the vixTomcatLogsDir
	 */
	public String getVixTomcatLogsDir() {
		return vixTomcatLogsDir;
	}

	/**
	 * @return the vixTomcatLogsDirSize
	 */
	public String getVixTomcatLogsDirSize() {
		return convertRawBytesToString(vixTomcatLogsDirSize);
	}

	/**
	 * @return the vixCacheDir
	 */
	public String getVixCacheDir() {
		return vixCacheDir;
	}

	/**
	 * @return the vixCacheDirSize
	 */
	public String getVixCacheDirSize() {
		return convertRawBytesToString(vixCacheDirSize);
	}

	/**
	 * @return the vixCacheDirCapacity
	 */
	public String getVixCacheDirCapacity() {
		return convertRawBytesToString(vixCacheDirCapacity);
	}

	/**
	 * @return the vixCacheDirAvailable
	 */
	public String getVixCacheDirAvailable() {
		return convertRawBytesToString(vixCacheDirAvailable);
	}

	/**
	 * @return the vixCacheOperationsInitiated
	 */
	public String getVixCacheOperationsInitiated() {
		return vixCacheOperationsInitiated;
	}

	/**
	 * @return the vixCacheOperationsSuccessful
	 */
	public String getVixCacheOperationsSuccessful() {
		return vixCacheOperationsSuccessful;
	}

	/**
	 * @return the vixCacheOperationsError
	 */
	public String getVixCacheOperationsError() {
		return vixCacheOperationsError;
	}

	/**
	 * @return the vixCacheOperationsNotFound
	 */
	public String getVixCacheOperationsNotFound() {
		return vixCacheOperationsNotFound;
	}

	/**
	 * @return the realmVistaServer
	 */
	public String getRealmVistaServer() {
		return realmVistaServer;
	}

	/**
	 * @return the realmVistaPort
	 */
	public String getRealmVistaPort() {
		return realmVistaPort;
	}

	/**
	 * @return the http8080ThreadPoolSize
	 */
	public String getHttp8080ThreadPoolSize() {
		return http8080ThreadPoolSize;
	}

	/**
	 * @return the http8080ThreadsBusy
	 */
	public String getHttp8080ThreadsBusy() {
		return http8080ThreadsBusy;
	}

	/**
	 * @return the http8442ThreadPoolSize
	 */
	public String getHttp8442ThreadPoolSize() {
		return http8442ThreadPoolSize;
	}

	/**
	 * @return the http8442ThreadsBusy
	 */
	public String getHttp8442ThreadsBusy() {
		return http8442ThreadsBusy;
	}

	/**
	 * @return the http8443ThreadPoolSize
	 */
	public String getHttp8443ThreadPoolSize() {
		return http8443ThreadPoolSize;
	}

	/**
	 * @return the http8443ThreadsBusy
	 */
	public String getHttp8443ThreadsBusy() {
		return http8443ThreadsBusy;
	}

	public String getTransactionLogStatisticsTransactionsWritten()
	{
		if(transactionLogStatsTransactionsWritten != null)
			return transactionLogStatsTransactionsWritten;
		return "?";
	}
	
	public String getTransactionLogStatisticsTransactionsQueried()
	{
		if(transactionLogStatsTransactionsQueried != null)
			return transactionLogStatsTransactionsQueried;
		return "?";
	}
	
	public String getTransactionLogStatsTransactionsPerMinute()
	{
		if(transactionLogStatsTransactionsPerMinute != null)
			return transactionLogStatsTransactionsPerMinute;
		return "?";
	}

	public String getTransactionLogStatsTransactionWriteErrors()
	{
		if(transactionLogStatsTransactionWriteErrors != null)
			return transactionLogStatsTransactionWriteErrors;
		return "?";
	}

	public String getTransactionLogStatsTransactionReadErrors()
	{
		if(transactionLogStatsTransactionReadErrors != null)
			return transactionLogStatsTransactionReadErrors;
		return "?";
	}

	public String getTransactionLogStatisticsTransactionsPurged()
	{
		if(transactionLogStatsTransactionsPurged != null)
			return transactionLogStatsTransactionsPurged;
		return "?";
	}
	
	public String getTransactionLogDirectory()
	{
		return transactionLogDirectory;
	}
	
	public String getTransactionLogDirectorySize() {
		return convertRawBytesToString(transactionLogDirectorySize);
	}

	public String getErrorMessage()
	{
		return errorMessage;
	}

	public boolean isHealthError()
	{
		return healthError;
	}

	public String getSiteServiceUrl()
	{
		return siteServiceUrl;
	}

	public String getSiteServiceUpdatedDate()
	{
		return siteServiceUpdatedDate;
	}
	
	public boolean isSiteServiceUrlConfiguredProperly()
	{
		return (siteServiceUrl != null) && (siteServiceUrl.length() > 0);
	}
	
	public boolean isSiteServiceDateUpdatedOk()
	{
		if(siteServiceUpdatedDate == null || siteServiceUpdatedDate.length() <= 0)
			return false;
		
		String format = "MM/dd/yyyy HH:mm:ss.SSS";
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
		try
		{
			Date date = dateFormat.parse(siteServiceUpdatedDate);
			Calendar now = Calendar.getInstance();
			now.add(Calendar.DAY_OF_YEAR, -2);
			
			Date twoDaysAgo = now.getTime();
			if(date.before(twoDaysAgo))
				return false;
			return true;
			
		} 
		catch (ParseException e)
		{
            logger.error("Error parsing site service updated date, {}", e.getMessage(), e);
			return false;
		}
	}
	
	public boolean is8080RequestsOk()
	{
		int threshold = getConfiguration().getActive8080RequestsThreshold();
		int busyThreads = 0;
		if (getHttp8080ThreadsBusy() != null)
			busyThreads = Integer.parseInt(getHttp8080ThreadsBusy());
		
		if(busyThreads >= threshold)
			return false;
		return true;
	}
	
	public boolean is8443RequestsOk()
	{
		int threshold = getConfiguration().getActive8443RequestsThreshold();
		int busyThreads = 0;
		if (getHttp8443ThreadsBusy() != null)
			busyThreads = Integer.parseInt(getHttp8443ThreadsBusy());
		if(busyThreads >= threshold)
			return false;
		return true;
	}
	
	public boolean is8442RequestsOk()
	{
		int threshold = getConfiguration().getActive8442RequestsThreshold();
		int busyThreads = 0;
		if (getHttp8442ThreadsBusy() != null)
			busyThreads = Integer.parseInt(getHttp8442ThreadsBusy());
		if(busyThreads >= threshold)
			return false;
		return true;
	}

	public int getMaximum8080Requests()
	{
		return getConfiguration().getMaximum8080ActiveRequests();
	}
	
	public int getMaximum8442Requests()
	{
		return getConfiguration().getMaximum8442ActiveRequests();
	}

	public int getMaximum8443Requests()
	{
		return getConfiguration().getMaximum8443ActiveRequests();
	}

	public boolean isRoiPeriodicProcessingEnabled()
	{
		return roiPeriodicProcessingEnabled;
	}

	public boolean isRoiImmediateProcessingEnabled()
	{
		return roiImmediateProcessingEnabled;
	}
	
	public boolean isROIProcessingEnabled()
	{
		return isRoiImmediateProcessingEnabled() || isRoiPeriodicProcessingEnabled();
	}

	@Override
	public int compareTo(VixServerHealthView o)
	{
		return this.site.getSiteName().compareToIgnoreCase(o.getSite().getSiteName());
	}
	
	private void fillDicomSendFailures(Map<String, String> properties) {
		int index = 0;

		while (properties
				.get(VixServerHealthProperties.VIX_DICOM_SERVICES_STORE_SCU_AETITLE
						+ SendFailures_DicomServiceStats + index) != null) {
			VixDicomSendFailures failure = new VixDicomSendFailures();
			failure
					.setAeTitle(properties
							.get(VixServerHealthProperties.VIX_DICOM_SERVICES_STORE_SCU_AETITLE
									+ SendFailures_DicomServiceStats
									+ index));
			failure
					.setSopClass(properties
							.get(VixServerHealthProperties.VIX_DICOM_SERVICES_STORE_SCU_SOPCLASS
									+ SendFailures_DicomServiceStats
									+ index));
			failure
					.setTotalVixSendToAEFailures(properties
							.get(VixServerHealthProperties.VIX_DICOM_SERVICES_STORE_SCU_TOTAL_VIX_SEND_TO_AE_FAILURES
									+ SendFailures_DicomServiceStats
									+ index));
			dicomServiceStats.add(failure);
			index++;
		}
	}

	public List<VixDicomSendFailures> getDicomServiceStats() {
		return dicomServiceStats;
	}
	
	

}
