/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 17, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswbuckd
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
 *
 */
package gov.va.med.imaging.javalogs;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;
import gov.va.med.logging.Logger;
import gov.va.med.imaging.DateUtil;
import gov.va.med.server.ServerAdapter;
import gov.va.med.server.ServerAdapterImpl;
import gov.va.med.server.ServerLifecycleEvent;
import gov.va.med.server.ServerLifecycleListener;

public class JavaLogFacade implements ServerLifecycleListener
{
	private static final Logger logger = Logger.getLogger(JavaLogFacade.class);
    private static JavaLogConfiguration config = JavaLogConfiguration.getConfiguration();

	private Timer purgeTimer;
	private PurgeJavaLogsTimerTask purgeTask;
	
	
	public JavaLogFacade()
	{
		ServerAdapterImpl.getSingleton().addServerLifecycleListener(this);
	}
	
	@Override
	public void serverLifecycleEvent(ServerLifecycleEvent event)
	{
		if (event.getEventType().equals(ServerLifecycleEvent.EventType.AFTER_START))
		{
			if (config.isPurgeAtStartup())
			{
				purgeJavaLogs();
			}
			// Send startup notification
			scheduleJavaLogPurge();
		}
	}

	/**
	 * Schedule the purging of the java log files.  By default, the java log file are purged
	 * once a day at 1 AM local time.
	 * If the refresh schedule is updated (i.e. refreshHour or refreshPeriod) are modified
	 * then this method must be called to reschedule the refresh.
	 * This method is synchronized to protect the refreshTimer and refreshTask locals
	 * from uncoordinated modification.
	 */
	public synchronized void scheduleJavaLogPurge()
	{
		// if the refresh task already exists, then we are re-scheduling ourselves
		if(purgeTask != null)
		{
			purgeTask.cancel();
			purgeTask = null;
		}
		
		// if the purgeTimer exists it can be re-used
		if(purgeTimer == null)
			purgeTimer = new Timer("JavaLogPurgeTimer", true);
		
		purgeTask = new PurgeJavaLogsTimerTask();
		
		// schedule ourselves to, by default, refresh every 24 hours,
		// starting at 1:00am, the first occurrence of which must be at least 1 hour from now
		purgeTimer.schedule(
			new PurgeJavaLogsTimerTask(), 
			DateUtil.nextOccurenceOfHour(config.getRefreshHour(), config.getRefreshMinimumDelay()), 
			config.getRefreshPeriod()
		);
        logger.info("Java Logs scheduled to be purged at [{}:00:00] and every [{}] days thereafter", config.getRefreshHour(), (float) config.getRefreshPeriod() / (float) DateUtil.MILLISECONDS_IN_DAY);
	}

	public void purgeJavaLogs()
	{
		try {
            logger.info("Purging Java Logs older than {} days.", config.getRetentionPeriodDays());
			purgeLogs(JavaLogReader.getLogsDir());
		} catch (IOException e) {
            logger.error("Generic IO exception while purging logs: {}", e.getMessage());
		}
	}

	private void purgeLogs(File directory) {
		if ((directory.exists() && (directory.isDirectory()))) {
			File[] files = directory.listFiles();
			if (files != null) {
				for (File file : files) {
					if (file.isFile()) {
						if (isLogFilePurgeRequired(file)) {
							try {
								if (file.delete()) {
                                    logger.info("Successfully purged java log {}", file.getAbsolutePath());
								} else {
                                    logger.error("Error purging java log {}", file.getAbsolutePath());
								}
							} catch (SecurityException ex) {
                                logger.error("Error purging java log {} : {}", file.getAbsolutePath(), ex.getMessage());
							}
						}
					} else {
						purgeLogs(file);
					}
				}
			}
		}
	}

	private boolean isLogFilePurgeRequired(File logFile)
	{
		Date now = new Date();
		long nowInMillseconds = now.getTime();
		long lastModifiedInMillseconds = logFile.lastModified();
		long timeIntervalInDays = (nowInMillseconds - lastModifiedInMillseconds)/DateUtil.MILLISECONDS_IN_DAY;
		return timeIntervalInDays > config.getRetentionPeriodDays() ? true : false;
	}
	
	
	/**
	 * @author vhaiswbuckd
	 *
	 */
	class PurgeJavaLogsTimerTask	extends TimerTask
	{
		@Override
        public void run()
        {
			try
            {
				purgeJavaLogs();
            } 
			catch (Exception e)
            {
				logger.error(e);
            } 
        }
		
	}
	
}
