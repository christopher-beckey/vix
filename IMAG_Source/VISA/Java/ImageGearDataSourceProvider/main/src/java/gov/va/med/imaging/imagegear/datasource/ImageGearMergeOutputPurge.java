/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 6, 2012
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
package gov.va.med.imaging.imagegear.datasource;

import gov.va.med.imaging.DateUtil;
import gov.va.med.imaging.exchange.TaskScheduler;
import gov.va.med.imaging.imagegear.datasource.configuration.ImageGearConfiguration;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.TimerTask;

import gov.va.med.imaging.utils.FileUtilities;
import org.apache.commons.io.FileUtils;
import gov.va.med.logging.Logger;

/**
 * This periodically runs and purges old merge directories from the disk
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ImageGearMergeOutputPurge
extends TimerTask
{
	private final static Logger LOGGER = Logger.getLogger(ImageGearMergeOutputPurge.class);
	
	private final static long PURGE_DELAY = 1000 * 120; // purge after two minutes
	private final static long PURGE_REFRESH = 1000 * 60 * 60 * 6; // every 6 hours run the purge
	private static ImageGearMergeOutputPurge purgeProcess;
	
	public synchronized static void scheduleMergeOutputPurge()
	{
		// only schedule once - the first time
		if(purgeProcess == null)
		{
			LOGGER.info("ImageGearMergeOutputPurge.scheduleMergeOutputPurge() --> Scheduling the merge output purge to run in [" + PURGE_DELAY + " ms], then periodically every [" + PURGE_REFRESH + " ms]");
			purgeProcess = new ImageGearMergeOutputPurge();
			TaskScheduler.getTaskScheduler().schedule(purgeProcess, PURGE_DELAY, PURGE_REFRESH);
		}
	}
	
	private ImageGearMergeOutputPurge()
	{
		super();
	}

	/* (non-Javadoc)
	 * @see java.util.TimerTask#run()
	 */
	@Override
	public void run()
	{
		runPurge();		
	}
	
	private void runPurge()
	{
		try 
		{
			String directoryPath = getImageGearConfiguration().getGroupOutputDirectory();
            LOGGER.info("ImageGearMergeOutputPurge.runPurge() --> Running purge to remove old merge output directories from [{}]", directoryPath);
			File outputDirectory = FileUtilities.getFile(directoryPath);
			
			if (!outputDirectory.exists()) 
			{
                LOGGER.warn("ImageGearMergeOutputPurge.runPurge() --> Output directory [{}] does not exist, nothing to purge!", outputDirectory.getAbsolutePath());
			} 
			else 
			{
				File [] directories = outputDirectory.listFiles();
				for (File directory : directories) 
				{
					// just to be sure
					if (directory.isDirectory()) 
					{
						examineAndPurgeDirectory(directory);
					}
				}
			}
		} 
		catch (Exception e) 
		{
            LOGGER.warn("ImageGearMergeOutputPurge.runPurge() --> Encountered exception [{}] while running purge: {}", e.getClass().getSimpleName(), e.getMessage());
		}
	}
	
	private ImageGearConfiguration getImageGearConfiguration()
	{
		return ImageGearDataSourceProvider.getImageGearConfiguration();
	}
	
	private void examineAndPurgeDirectory(File directory)
	{
		
		Date now = new Date();
		long nowInMillseconds = now.getTime();
		long lastModifiedInMillseconds = directory.lastModified();
		long timeIntervalInDays = (nowInMillseconds - lastModifiedInMillseconds)/DateUtil.MILLISECONDS_IN_DAY;
		int retentionDays = getImageGearConfiguration().getMergeOutputDirectoryRetensionDays();
		
		if(timeIntervalInDays > retentionDays)
		{
			try
			{
                LOGGER.info("ImageGearMergeOutputPurge.examineAndPurgeDirectory() --> Directory [{}] is older than [{}] days. Will be purged.", directory.getName(), retentionDays);
				FileUtils.deleteDirectory(directory);
			} 
			catch(Exception ex)
			{
                LOGGER.warn("ImageGearMergeOutputPurge.examineAndPurgeDirectory() --> Encountered exception [{}] while purging directory [{}]: {}", ex.getClass().getSimpleName(), directory.getName(), ex.getMessage());
			}
		}
	}
}
