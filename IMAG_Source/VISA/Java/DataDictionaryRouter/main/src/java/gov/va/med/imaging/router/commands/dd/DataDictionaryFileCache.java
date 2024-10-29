/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 6, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswgraver
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
package gov.va.med.imaging.router.commands.dd;

import gov.va.med.imaging.exchange.BaseTimedCache;
import gov.va.med.imaging.exchange.BaseTimedCacheValueItem;
import gov.va.med.imaging.exchange.TaskScheduler;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryFile;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswgraver
 *
 */
public class DataDictionaryFileCache
{
	private final static Logger logger = Logger.getLogger(DataDictionaryFileCache.class);
	
	private final static DataDictionaryFileCache singleton = new DataDictionaryFileCache();
	private final static long DD_FILE_CACHE_TIMER_REFRESH = 1000 * 60 * 10; // check for expired items in cache every 10 minutes
	private final static long DD_FILE_CACHE_RETENTION_PERIOD = 1000 * 60 * 60; // items last in cache for 1 hour
	private final BaseTimedCache<String, DDFileCacheValueItem> ddFileCache;
	
	
	private DataDictionaryFileCache()
	{
		super();
		
		ddFileCache = new BaseTimedCache<String, DDFileCacheValueItem>(DataDictionaryFileCache.class.toString());
		
		ddFileCache.setRetentionPeriod(DD_FILE_CACHE_RETENTION_PERIOD);
		
		TaskScheduler.getTaskScheduler().schedule(ddFileCache, DD_FILE_CACHE_TIMER_REFRESH, DD_FILE_CACHE_TIMER_REFRESH);
	}
	
	private static DataDictionaryFileCache getSingleton()
	{
		return singleton;
	}
	
	public static void cacheFile(DataDictionaryFile file)
	{
		try
		{
			if(file != null)
			{
				DataDictionaryFileCache cache = getSingleton();
				DDFileCacheValueItem cacheItem = new DDFileCacheValueItem(file);
				
				synchronized(cache.ddFileCache)
				{
					cache.ddFileCache.updateItem(cacheItem);
				}
			}
		}
		catch(Exception ex)
		{
            logger.warn("DataDictionaryFileCache.cacheFile() --> Error caching data dictionary file [{}]: {}", file.getNumber(), ex.getMessage());
		}
	}
	
	public static DataDictionaryFile getCachedFile(String fileNumber)
	{
		DataDictionaryFileCache cache = getSingleton();
		
		synchronized(cache.ddFileCache)
		{
			DDFileCacheValueItem cacheItem = (DDFileCacheValueItem) cache.ddFileCache.getItem(fileNumber);
			
			return (cacheItem != null ? cacheItem.getFile() : null);
		}
	}

	static class DDFileCacheValueItem
	extends BaseTimedCacheValueItem
	{
		private final DataDictionaryFile file;
		
		/**
		 * @param fileNumber
		 * @param file
		 */
		public DDFileCacheValueItem(DataDictionaryFile file)
		{
			super();
			this.file = file;			
		}
		
		/**
		 * @return the data dictionary file
		 */
		public DataDictionaryFile getFile()
		{
			return file;
		}
		
		/* (non-Javadoc)
		 * @see gov.va.med.imaging.exchange.BaseTimedCacheValueItem#getKey()
		 */
		@Override
		public Object getKey()
		{
			return getFile().getNumber();
		}
	}
}
