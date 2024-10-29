package gov.va.med.imaging.musedatasource.cache;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class MuseOpenSessionResultsCache {

	private static Map<String,MuseOpenSession> museOpenSessionResultsCache = new ConcurrentHashMap<String, MuseOpenSession>();
	
	public static MuseOpenSession get(String key) {
		return museOpenSessionResultsCache.get(key);
	}
	
	public static void put(String key, MuseOpenSession session) {
		museOpenSessionResultsCache.put(key, session);
	}
	
	public static void remove(String key) {
		museOpenSessionResultsCache.remove(key);
	}
	
}

