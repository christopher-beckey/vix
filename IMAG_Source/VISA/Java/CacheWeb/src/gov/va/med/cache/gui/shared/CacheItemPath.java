/**
 * 
 */
package gov.va.med.cache.gui.shared;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.google.gwt.user.client.rpc.IsSerializable;

/**
 * @author VHAISWBECKEC
 *
 */
public class CacheItemPath
implements Serializable, IsSerializable
{
	private static final long	serialVersionUID	= 1L;
	private String cacheName;
	private String regionName;
	private String[] groupNames;
	private String instanceName;
	
	/**
	 * Default no-arg constructor required for GWT serialization
	 */
	public CacheItemPath()
	{
		this(null, null, (String[])null, null);
	}

	public CacheItemPath(String cacheName)
	{
		this(cacheName, null, (String[])null, null);
	}
	
	public CacheItemPath(String cacheName, String regionName)
	{
		this(cacheName, regionName, (String[])null, null);
	}
	
	public CacheItemPath(String cacheName, String regionName, String groupName)
	{
		this(cacheName, regionName, new String[]{groupName}, null);
	}
	
	public CacheItemPath(String cacheName, String regionName, String parentGroupName, String childGroupName)
	{
		this(cacheName, regionName, new String[]{parentGroupName, childGroupName}, null);
	}
	
	public CacheItemPath(String cacheName, String regionName, String[] groupsName) 
	{
		this.cacheName = cacheName;
		this.regionName = regionName;
		this.groupNames = groupsName;
		this.instanceName = null;
	}

	public CacheItemPath(String cacheName, String regionName, String[] groupNames, String instanceName)
	{
		this.cacheName = cacheName;
		this.regionName = regionName;
		this.groupNames = groupNames;
		this.instanceName = instanceName;
	}
	
	// ========================================================================================================
	public static final int CACHE_INDEX = 0;
	public static final int REGION_INDEX = 1;
	public static final char INSTANCE_INDICATOR = '.';		// preceeds the instance name, to indicate it as instance, not a group
	// ========================================================================================================
	

	public String getName(){
		if (instanceName != null && instanceName.length() > 0)
			return instanceName;
		if (groupNames != null && groupNames.length > 0)
			return groupNames[groupNames.length - 1];
		if (regionName != null && regionName.length() > 0)
			return regionName;
		if (cacheName != null && cacheName.length() > 0)
			return cacheName;
		return null;
	}
	
	public String getCacheName()
	{
		return cacheName;
	}

	public String getRegionName()
	{
		return regionName;
	}

	public String[] getGroupNames()
	{
		return groupNames;
	}

	public String getLastGroupName()
	{
		return groupNames != null && groupNames.length > 0 ?
			groupNames[groupNames.length-1] : null;
	}
	
	public CACHE_POPULATION_DEPTH getLastGroupDepth()
	{
		if( groupNames != null && groupNames.length > 0)
		{
			return 
				groupNames.length == 1 ? CACHE_POPULATION_DEPTH.GROUP0 :
				groupNames.length == 2 ? CACHE_POPULATION_DEPTH.GROUP1 :
				groupNames.length == 3 ? CACHE_POPULATION_DEPTH.GROUP2 :
				groupNames.length == 4 ? CACHE_POPULATION_DEPTH.GROUP3 :
				groupNames.length == 5 ? CACHE_POPULATION_DEPTH.GROUP4 :
				groupNames.length == 6 ? CACHE_POPULATION_DEPTH.GROUP5 :
				groupNames.length == 7 ? CACHE_POPULATION_DEPTH.GROUP6 :
				groupNames.length == 8 ? CACHE_POPULATION_DEPTH.GROUP7 :
				groupNames.length == 9 ? CACHE_POPULATION_DEPTH.GROUP8 :
				CACHE_POPULATION_DEPTH.GROUPX;
		}
		else
			return CACHE_POPULATION_DEPTH.REGION;
	}
	
	public String getInstanceName()
	{
		return instanceName;
	}
	
	public String getItemType(){
		if (instanceName != null && instanceName.length() > 0)
			return "instance";
		if (groupNames != null && groupNames.length > 0)
			return "group";
		if (regionName != null && regionName.length() > 0)
			return "region";
		if (cacheName != null && cacheName.length() > 0)
			return "cache";
		return null;
	}
	
	public List<CacheItemPath> getAncestors()
	{
		List<CacheItemPath> ancestors = new ArrayList<CacheItemPath>();
		CacheItemPath parent = this.createParentPath();
		if (parent != null & parent.cacheName != null && parent.cacheName.length() > 0) {
			ancestors.addAll(parent.getAncestors());
			ancestors.add(parent);
		}
		return ancestors;
	}

	/**
	 * 
	 * @return - the path to this instances parent node
	 */
	public CacheItemPath createParentPath()
	{
		if(getInstanceName() != null)
			return new CacheItemPath(getCacheName(), getRegionName(), getGroupNames(), null);
		
		if(getGroupNames() != null)
		{
			CACHE_POPULATION_DEPTH groupDepth = getLastGroupDepth();
			int parentGroupCount = (groupDepth.ordinal() - CACHE_POPULATION_DEPTH.GROUP0.ordinal());
			if(parentGroupCount == 0)
				return new CacheItemPath(getCacheName(), getRegionName(), (String[])null, null);
			
			String[] childGroups = new String[parentGroupCount];
			System.arraycopy(getGroupNames(), 0, childGroups, 0, childGroups.length);
			
			return new CacheItemPath(getCacheName(), getRegionName(), childGroups, null);
		}
		
		if(getRegionName() != null)
			return new CacheItemPath(getCacheName());
		
		return new CacheItemPath();
	}
	
	public CacheItemPath createChildPath(String childName, boolean childIsInstance)
	{
		if(regionName == null)
			return new CacheItemPath(this.getCacheName(), childName);
		if(groupNames == null)
			return new CacheItemPath(this.getCacheName(), this.getRegionName(), childName);
		if(groupNames != null && instanceName == null && !childIsInstance)
		{
			String[] childGroupNames = new String[getGroupNames().length + 1];
			System.arraycopy(getGroupNames(), 0, childGroupNames, 0, getGroupNames().length);
			childGroupNames[childGroupNames.length - 1] = childName;
			return new CacheItemPath(this.getCacheName(), this.getRegionName(), childGroupNames, null);
		}
		else if(groupNames != null && instanceName == null && childIsInstance)
		{
			return new CacheItemPath(this.getCacheName(), this.getRegionName(), this.getGroupNames(), childName);
		}
		else
			return null;
	}
	
	public CacheItemPath createChildInstancePath(String childName)
	{
		if(groupNames != null && instanceName == null)
			return new CacheItemPath(getCacheName(), getRegionName(), getGroupNames(), childName);
		
		return null;
	}
	
	@Override
	public String toString()
	{
		String result = cacheName == null ? "<CacheItemPath is empty>" : cacheName;
		
		if(regionName != null)
		{
			result += "." + regionName;
			if(groupNames != null)
			{
				for(String groupName : groupNames)
					result += "." + groupName;
				
				if(instanceName != null)
					result += "[" + instanceName + "]";
			}
		}
		
		return result;
	}

	/**
	 * Return the name of the cache item at the specified depth.
	 * 
	 * @param currentDepth
	 * @return
	 */
	public String getNameAt(CACHE_POPULATION_DEPTH currentDepth)
	{
		if(currentDepth == null)
			throw new AssertionError("getNameAt(null), currentDepth parameter is null and must not be...");
		
		switch( currentDepth )
		{
			case CACHE: return getCacheName();
			case REGION: return getRegionName();
			case GROUP0: return getGroupNames() == null || this.getGroupNames().length < 1 ? null : this.getGroupNames()[0]; 
			case GROUP1: return getGroupNames() == null || this.getGroupNames().length < 2 ? null : this.getGroupNames()[1]; 
			case GROUP2: return getGroupNames() == null || this.getGroupNames().length < 3 ? null : this.getGroupNames()[2]; 
			case GROUP3: return getGroupNames() == null || this.getGroupNames().length < 4 ? null : this.getGroupNames()[3]; 
			case GROUP4: return getGroupNames() == null || this.getGroupNames().length < 5 ? null : this.getGroupNames()[4]; 
			case GROUP5: return getGroupNames() == null || this.getGroupNames().length < 6 ? null : this.getGroupNames()[5]; 
			case GROUP6: return getGroupNames() == null || this.getGroupNames().length < 7 ? null : this.getGroupNames()[6]; 
			case GROUP7: return getGroupNames() == null || this.getGroupNames().length < 8 ? null : this.getGroupNames()[7]; 
			case GROUP8: return getGroupNames() == null || this.getGroupNames().length < 9 ? null : this.getGroupNames()[8]; 
			case INSTANCE: return this.getInstanceName();
		}
		return null;
	}

	/**
	 * Gets the deepest populated element of the path.
	 * @return
	 */
	public CACHE_POPULATION_DEPTH getEndpointDepth()
	{
		CACHE_POPULATION_DEPTH previousDepth = null;
		for( CACHE_POPULATION_DEPTH currentDepth = CACHE_POPULATION_DEPTH.CACHE_MANAGER;
			currentDepth != null;
			currentDepth = nextDepth(currentDepth) )
				previousDepth = currentDepth;
		
		return previousDepth;
	}
	

	/**
	 * Gets the next populated element of the path or null if the endpoint has been reached.
	 * 
	 * @param currentDepth
	 * @return
	 */
	public CACHE_POPULATION_DEPTH nextDepth(CACHE_POPULATION_DEPTH currentDepth)
	{
		switch( currentDepth )
		{
			case CACHE_MANAGER:
				if(getCacheName() != null)
					return CACHE_POPULATION_DEPTH.CACHE;
				else 
					return null;
				
			case CACHE:
				if(getRegionName() != null)
					return CACHE_POPULATION_DEPTH.REGION;
				else
					return null;
				
			case REGION: 
				return getDepthAtGroupLevel(CACHE_POPULATION_DEPTH.GROUP0.getGroupIndex());
				
			case GROUP0: 
				return getDepthAtGroupLevel(CACHE_POPULATION_DEPTH.GROUP1.getGroupIndex());
				
			case GROUP1: 
				return getDepthAtGroupLevel(CACHE_POPULATION_DEPTH.GROUP2.getGroupIndex());
				
			case GROUP2: 
				return getDepthAtGroupLevel(CACHE_POPULATION_DEPTH.GROUP3.getGroupIndex());
				
			case GROUP3: 
				return getDepthAtGroupLevel(CACHE_POPULATION_DEPTH.GROUP4.getGroupIndex());
				
			case GROUP4: 
				return getDepthAtGroupLevel(CACHE_POPULATION_DEPTH.GROUP5.getGroupIndex());
				
			case GROUP5: 
				return getDepthAtGroupLevel(CACHE_POPULATION_DEPTH.GROUP6.getGroupIndex());
				
			case GROUP6: 
				return getDepthAtGroupLevel(CACHE_POPULATION_DEPTH.GROUP7.getGroupIndex());
				
			case GROUP7: 
				return getDepthAtGroupLevel(CACHE_POPULATION_DEPTH.GROUP8.getGroupIndex());
				
			case GROUP8: 
				return getDepthAtGroupLevel(CACHE_POPULATION_DEPTH.GROUP9.getGroupIndex());
				
			case GROUP9: 
				return CACHE_POPULATION_DEPTH.INSTANCE;
				
			case INSTANCE: 
				return null;
		}
		
		return null;
	}

	/**
	 * 
	 * @param groupIndex
	 * @return
	 */
	private CACHE_POPULATION_DEPTH getDepthAtGroupLevel(int groupIndex) 
	{
		if( getGroupNames() != null && this.getGroupNames().length >= (groupIndex+1) ) 
		{
			if(getGroupNames()[groupIndex] != null)
				return CACHE_POPULATION_DEPTH.getGroupFromIndex(groupIndex); 
			else
				return null;
		}
		else
		{
			if(getInstanceName() != null)
				return CACHE_POPULATION_DEPTH.INSTANCE; 
			else
				return null;
		}
	}
	
	public void setGroupNames(String[] groupNames) {
		this.groupNames = groupNames;
	}

	public void setCacheName(String cacheName) {
		this.cacheName = cacheName;
	}

	public void setRegionName(String regionName) {
		this.regionName = regionName;
	}

	public void setInstanceName(String instanceName) {
		this.instanceName = instanceName;
	}
}
