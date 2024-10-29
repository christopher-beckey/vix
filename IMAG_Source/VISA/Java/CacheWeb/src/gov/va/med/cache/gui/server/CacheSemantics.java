package gov.va.med.cache.gui.server;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class CacheSemantics 
{
	private static final String INSTANCE = "instance";
	private static final String GROUPS = "groups";
	private static final String DEFAULT_CACHE_NAME = "default";
	private static final String DEFAULT_REGION_NAME = "default";
	
	private static ResourceBundle rbSemantics;
	private static Map<CacheSemantics.GroupSemanticKey, String> groupSemantics = 
		new HashMap<CacheSemantics.GroupSemanticKey, String>();
	private static Map<CacheSemantics.InstanceSemanticKey, String> instanceSemantics = 
		new HashMap<CacheSemantics.InstanceSemanticKey, String>();
	private static Logger logger = LogManager.getLogger(CacheSemantics.class);
	
	static
	{
		rbSemantics = ResourceBundle.getBundle("gov.va.med.cache.gui.server.CacheSemantics");
		
		// the keys MUST be in the form 
		// <cache name>.<region name>.groups
		// - or -
		// <cache name>.<region name>.instance
		for(Enumeration<String> keyEnum = rbSemantics.getKeys(); keyEnum.hasMoreElements(); )
		{
			String key = keyEnum.nextElement();
			String[] keyElements = key.split("\\x2e");		// split on period '.'
			if(keyElements.length != 3)
			{
				logger.error(
					"The CacheSemantics properties file contains an invalid key '" 
					+ key 
					+ "'.  Keys MUST be in the form <cache name>.<region name>.groups -or- <cache name>.<region name>.instance .");
				continue;
			}
			
			String cacheName = keyElements[0];
			String regionName = keyElements[1];
			boolean isGroups = GROUPS.equalsIgnoreCase( keyElements[2] );
			boolean isInstance = INSTANCE.equalsIgnoreCase( keyElements[2] );
			String value = rbSemantics.getString(key);
			
			if(isGroups && value != null)
			{
				String[] groupNames = rbSemantics.getString(key).split(",");
				for(int groupIndex=0; groupIndex < groupNames.length; ++groupIndex)
					groupSemantics.put(new GroupSemanticKey(cacheName, regionName, groupIndex), groupNames[groupIndex].trim());
			}
			else if(isInstance && value != null)
			{
				instanceSemantics.put(new InstanceSemanticKey(cacheName, regionName), value);
			}
			else
				logger.error(
					"The CacheSemantics properties file contains an invalid key '" 
					+ key 
					+ "'.  Keys MUST be in the form <cache name>.<region name>.groups -or- <cache name>.<region name>.instance .");
				
		}
	}

	/**
	 * 
	 * @param cacheName
	 * @param regionName
	 * @param groupLevel
	 * @return
	 */
	public static String getGroupSemanticType(String cacheName, String regionName, int groupLevel)
	{
		GroupSemanticKey key = new GroupSemanticKey(cacheName, regionName, groupLevel);
		String semanticType = groupSemantics.get(key);
		logger.debug(key.toString() + "=>" + semanticType);
		return semanticType == null ? 
			groupSemantics.get(new GroupSemanticKey(DEFAULT_CACHE_NAME, DEFAULT_REGION_NAME, groupLevel)) : 
			semanticType;
	}
	
	/**
	 * 
	 * @param cacheName
	 * @param regionName
	 * @return
	 */
	public static String getInstanceSemanticType(String cacheName, String regionName)
	{
		InstanceSemanticKey key = new InstanceSemanticKey(cacheName, regionName);
		String semanticType = instanceSemantics.get(key);
		logger.debug(key.toString() + "=>" + semanticType);
		return semanticType == null ? 
			instanceSemantics.get(new InstanceSemanticKey(DEFAULT_CACHE_NAME, DEFAULT_REGION_NAME)) : 
			semanticType;
	}

	private static class GroupSemanticKey
	{
		private final String cacheName;
		private final String regionName;
		private final int groupLevel;
		
		public GroupSemanticKey(String cacheName, String regionName,
				int groupLevel) {
			super();
			this.cacheName = cacheName;
			this.regionName = regionName;
			this.groupLevel = groupLevel;
		}
		
		@Override
		public int hashCode() {
			final int prime = 31;
			int result = 1;
			result = prime * result
					+ ((cacheName == null) ? 0 : cacheName.hashCode());
			result = prime * result + groupLevel;
			result = prime * result
					+ ((regionName == null) ? 0 : regionName.hashCode());
			return result;
		}
		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			GroupSemanticKey other = (GroupSemanticKey) obj;
			if (cacheName == null) {
				if (other.cacheName != null)
					return false;
			} else if (!cacheName.equalsIgnoreCase(other.cacheName))
				return false;
			if (groupLevel != other.groupLevel)
				return false;
			if (regionName == null) {
				if (other.regionName != null)
					return false;
			} else if (!regionName.equalsIgnoreCase(other.regionName))
				return false;
			return true;
		}
		

		@Override
		public String toString() 
		{
			return this.getClass().getSimpleName() + "." + cacheName + "." + regionName + "." + Integer.toString(groupLevel);
		}
	}
	
	private static class InstanceSemanticKey
	{
		private final String cacheName;
		private final String regionName;
		
		public InstanceSemanticKey(String cacheName, String regionName) {
			super();
			this.cacheName = cacheName;
			this.regionName = regionName;
		}
		
		@Override
		public int hashCode() {
			final int prime = 31;
			int result = 1;
			result = prime * result
					+ ((cacheName == null) ? 0 : cacheName.hashCode());
			result = prime * result
					+ ((regionName == null) ? 0 : regionName.hashCode());
			return result;
		}
		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			InstanceSemanticKey other = (InstanceSemanticKey) obj;
			if (cacheName == null) {
				if (other.cacheName != null)
					return false;
			} else if (!cacheName.equalsIgnoreCase(other.cacheName))
				return false;
			if (regionName == null) {
				if (other.regionName != null)
					return false;
			} else if (!regionName.equalsIgnoreCase(other.regionName))
				return false;
			return true;
		}

		@Override
		public String toString() 
		{
			return this.getClass().getSimpleName() + "." + cacheName + "." + regionName;
		}
	}
}
