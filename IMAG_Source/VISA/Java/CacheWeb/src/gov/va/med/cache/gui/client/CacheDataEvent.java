package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.CacheItemPath;

/**
 * 
 * @author VHAISWBECKEC
 */
public class CacheDataEvent 
{
	public enum EVENT_TYPE {START, SUCCESS, FAILURE};
	
	private EVENT_TYPE eventType;
	private CacheItemPath cacheItemPath;
	private String message;
	private int expectedDuration;
	
	public static CacheDataEvent createStartEvent(String message) 
	{
		return new CacheDataEvent(EVENT_TYPE.START, null, message, 0);
	}

	public static CacheDataEvent createStartEvent(int expectedDuration) 
	{
		return new CacheDataEvent(EVENT_TYPE.START, null, null, expectedDuration);
	}

	public static CacheDataEvent createStartEvent(String message, int expectedDuration) 
	{
		return new CacheDataEvent(EVENT_TYPE.START, null, message, expectedDuration);
	}

	public static CacheDataEvent createSuccessEvent(CacheItemPath cacheItemPath) 
	{
		return new CacheDataEvent(EVENT_TYPE.SUCCESS, cacheItemPath, null, 0);
	}
	
	public static CacheDataEvent createFailureEvent(CacheItemPath cacheItemPath) 
	{
		return new CacheDataEvent(EVENT_TYPE.FAILURE, cacheItemPath, null, 0);
	}
	
	public static CacheDataEvent createFailureEvent(String message) 
	{
		return new CacheDataEvent(EVENT_TYPE.FAILURE, null, message, 0);
	}
	
	private CacheDataEvent(EVENT_TYPE eventType, CacheItemPath cacheItemPath, String message, int expectedDuration) 
	{
		this.eventType = eventType;
		this.cacheItemPath = cacheItemPath;
		this.message = message;
		this.expectedDuration = expectedDuration;
	}

	public EVENT_TYPE getEventType() {return eventType;}
	public String getMessage() {return message;}
	public int getExpectedDuration() {return expectedDuration;}
	public CacheItemPath getCacheItemPath(){return cacheItemPath;}
}
