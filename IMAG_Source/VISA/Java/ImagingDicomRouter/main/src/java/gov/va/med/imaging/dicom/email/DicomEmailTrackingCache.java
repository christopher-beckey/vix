package gov.va.med.imaging.dicom.email;

import gov.va.med.imaging.exchange.TimedCache;
import gov.va.med.imaging.exchange.TimedCacheFactory;

public class DicomEmailTrackingCache 
{
	private static TimedCache<DicomEmailTrackingCacheItem> dicomEmailTrackingCache = TimedCacheFactory.<DicomEmailTrackingCacheItem>getTimedCache("DicomEmailTracking");

	public static boolean hasEmailBeenSent(DicomEmailInfo dicomEmailInfo)
	{
		Object key = DicomEmailTrackingCacheItem.getCacheKey(dicomEmailInfo);
		DicomEmailTrackingCacheItem cacheItem = dicomEmailTrackingCache.getItem(key);
		if (cacheItem == null)
		{
			// Item is not in the cache already. Add it and return false so the caller
			// knows the email still needs to be sent
			cacheItem = new DicomEmailTrackingCacheItem(dicomEmailInfo);
			dicomEmailTrackingCache.updateItem(cacheItem);
			return false;
		}
		else
		{
			// This item is already in the cache. Return true to let the caller know
			// the email does not need to be sent again.
			return true;
		}
	}
}
