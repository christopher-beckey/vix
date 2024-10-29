package gov.va.med.cache;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import gov.va.med.cache.gui.server.CacheSemantics;
import gov.va.med.cache.gui.shared.AbstractGroupParent;
import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.CACHE_POPULATION_DEPTH;
import gov.va.med.cache.gui.shared.CacheGroupMetadata;
import gov.va.med.cache.gui.shared.CacheInstanceMetadata;
import gov.va.med.cache.gui.shared.CacheItemPath;
import gov.va.med.cache.gui.shared.CacheMetadata;
import gov.va.med.cache.gui.shared.CacheRegionMetadata;
import gov.va.med.cache.gui.shared.CacheVO;
import gov.va.med.cache.gui.shared.GroupVO;
import gov.va.med.cache.gui.shared.InstanceVO;
import gov.va.med.cache.gui.shared.RegionVO;
import gov.va.med.imaging.storage.cache.Cache;
import gov.va.med.imaging.storage.cache.CacheManager;
import gov.va.med.imaging.storage.cache.Group;
import gov.va.med.imaging.storage.cache.Instance;
import gov.va.med.imaging.storage.cache.Region;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
import gov.va.med.imaging.storage.cache.impl.CacheManagerImpl;

import javax.management.MBeanException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class CacheManagementService 
{
	private static final Logger logger = LogManager.getLogger(CacheManagementService.class);
	private static CacheManager cacheManager;
	
	/**
	 * 
	 */
	static
	{
		try 
		{
			cacheManager = CacheManagerImpl.getSingleton();
		} 
		catch (MBeanException e) 
		{
			e.printStackTrace();
		} 
		catch (CacheException e) 
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * Get the CacheManager implementation.  Log the hashCode of the cache manager so that we can assure that the
	 * instance used by this web app is the same instance as used by the applications.
	 * 
	 * @return
	 * @throws CacheException 
	 * @throws MBeanException 
	 */
	public static CacheManager getCacheManager() 
	throws MBeanException, CacheException
	{
		logger.debug("ENTERING getCacheManager(), CacheManager instance is "
			+ (cacheManager == null ? "<null>" : cacheManager.toString()) 
		);
		
		return cacheManager;
	}

	/**
	 * 
	 * @param cachePath
	 * @return
	 * @throws IllegalArgumentException
	 */
	public static CacheMetadata getCacheMetadata(CacheItemPath cachePath)
	throws IllegalArgumentException 
	{
		logger.debug("getCacheRegionMetadata(" + cachePath.toString() + ")");
		assert( cachePath.getCacheName() != null );
		logger.debug("getCacheRegionMetadata(" + cachePath.toString() + "), parameters validated");
		
		try 
		{
			Cache cache = getCacheManager().getCache(cachePath.getCacheName());
			return new CacheMetadata(cachePath, cache.getLocationUri().toString(), cache.getLocationPath(), cache.getLocationProtocol());
		}
		catch (Exception x) 
		{
			x.printStackTrace();
			return null;
		}
	}

	/**
	 * 
	 * @param regionPath
	 * @return
	 * @throws IllegalArgumentException
	 */
	public static CacheRegionMetadata getCacheRegionMetadata(CacheItemPath regionPath)
	throws IllegalArgumentException 
	{
		logger.debug("ENTERING getCacheRegionMetadata(" + regionPath.toString() + ")");
		assert( regionPath.getCacheName() != null );
		assert( regionPath.getRegionName() != null );
		logger.debug("getCacheRegionMetadata(" + regionPath.toString() + "), parameters validated");
		
		try 
		{
			Cache cache = getCacheManager().getCache(regionPath.getCacheName());
			Region region = cache.getRegion(regionPath.getRegionName());
			CacheRegionMetadata result = 
				new CacheRegionMetadata(regionPath, region.getEvictionStrategyNames(), region.getTotalSpace(), region.getUsedSpace());
			logger.debug("EXITING getCacheRegionMetadata(" + regionPath.toString() + ") SUCCESS -> " + result.toString());
			return result;
		} 
		catch (Exception x) 
		{
			x.printStackTrace();
			logger.debug("EXITING getCacheRegionMetadata(" + regionPath.toString() + ") EXCEPTION " + x.toString());
			return null;
		}
	}

	/**
	 * 
	 * @param groupPath
	 * @return
	 * @throws IllegalArgumentException
	 */
	public static CacheGroupMetadata getCacheGroupMetadata(CacheItemPath groupPath)
	throws IllegalArgumentException 
	{
		logger.debug("getCacheInstanceMetadata(" + groupPath.toString() + ")");
		assert( groupPath.getCacheName() != null );
		assert( groupPath.getRegionName() != null );
		assert( groupPath.getGroupNames() != null && groupPath.getGroupNames().length > 0);
		logger.debug("getCacheInstanceMetadata(" + groupPath.toString() + "), parameters validated");
		
		try 
		{
			Cache cache = getCacheManager().getCache(groupPath.getCacheName());
			Region region = cache.getRegion(groupPath.getRegionName());
			Group group = region.getGroup(groupPath.getGroupNames());
			
			return new CacheGroupMetadata(groupPath, group.getSize(), null, group.getLastAccessed());
		} 
		catch (Exception x) 
		{
			x.printStackTrace();
			return null;
		}
	}

	/**
	 * 
	 * @param itemPath
	 * @return
	 * @throws IllegalArgumentException
	 */
	public static CacheInstanceMetadata getCacheInstanceMetadata(CacheItemPath itemPath)
	throws IllegalArgumentException 
	{
		logger.debug("getCacheInstanceMetadata(" + itemPath.toString() + ")");
		assert( itemPath.getCacheName() != null );
		assert( itemPath.getRegionName() != null );
		assert( itemPath.getGroupNames() != null && itemPath.getGroupNames().length > 0);
		assert( itemPath.getInstanceName() != null );
		logger.debug("getCacheInstanceMetadata(" + itemPath.toString() + "), parameters validated");
		
		try 
		{
			Cache cache = getCacheManager().getCache(itemPath.getCacheName());
			cache.getLocationUri();
			Region region = cache.getRegion(itemPath.getRegionName());
			Instance instance = region.getInstance(itemPath.getGroupNames(), itemPath.getInstanceName());
			
			return new CacheInstanceMetadata(itemPath, instance.getSize(), instance.getLastAccessed(), instance.getChecksumValue());
		} 
		catch (Exception x) 
		{
			x.printStackTrace();
			return null;
		}
	}

	// ====================================================================================================
	// Private, helper, methods that do the majority of the work.
	// ====================================================================================================
	
	/**
	 * @param caches
	 * @throws CacheException 
	 * @throws MBeanException 
	 */
	public static List<Cache> getKnownCaches() 
	throws MBeanException, CacheException
	{
		Iterable<Cache> caches = getCacheManager().getKnownCaches();
		
		List<Cache> cacheList = new ArrayList<Cache>();
		for(Iterator<Cache> cacheIter = caches.iterator(); cacheIter.hasNext(); )
		{
			Cache cache = cacheIter.next();
			
			cacheList.add(cache);
			logger.debug(cache.getName() + "-" + cache.getLocationProtocol() + ":" + cache.getLocationPath());
		}
		return cacheList;
	}
	
	public static List<CacheVO> getCacheManagerCaches(CACHE_POPULATION_DEPTH depth, CACHE_POPULATION_DEPTH metadataPopulationDepth) 
	throws MBeanException, CacheException
	{
		List<CacheVO> caches = new ArrayList<CacheVO>();
		
		for(Cache cache : getKnownCaches())
		{
			logger.info(cache.getName() + "-" + cache.getLocationProtocol() + ":" + cache.getLocationPath());
			CacheItemPath cacheItemPath = new CacheItemPath(cache.getName());
			CacheVO cacheVO = new CacheVO(
				cache.getName(), 
				new CacheMetadata(cacheItemPath, cache.getLocationUri().toString(), cache.getLocationPath(), cache.getLocationProtocol())
			);
			if(depth.ordinal() >= CACHE_POPULATION_DEPTH.REGION.ordinal())
				cacheVO.addAll(getCacheRegions(cache, depth, metadataPopulationDepth));
			caches.add(cacheVO);
		}
		
		return caches;
	}

	public static Cache getCache(String cacheName) 
	throws MBeanException, CacheException
	{
		for(Cache cache : getKnownCaches())
			if(cacheName.equals(cache.getName()))
				return cache;
		
		return null;
	}
	/**
	 * @param regions
	 * @param cache
	 * @throws CacheException 
	 */
	public static List<RegionVO> getCacheRegions(Cache cache, CACHE_POPULATION_DEPTH depth, CACHE_POPULATION_DEPTH metadataPopulationDepth) 
	throws CacheException
	{
		List<RegionVO> regions = new ArrayList<RegionVO>();
		if(depth.ordinal() >= CACHE_POPULATION_DEPTH.REGION.ordinal())
		{
			for( Iterator<? extends Region> regionIterator = cache.getRegions().iterator();
				regionIterator.hasNext(); )
			{
				Region region = regionIterator.next();
				logger.debug(region.getName());
				
				CacheItemPath regionPath = new CacheItemPath(cache.getName(), region.getName());
				
				// getting region metadata is a very expensive operation, do so only if asked.
				CacheRegionMetadata metadata = metadataPopulationDepth.compareTo(CACHE_POPULATION_DEPTH.REGION) >= 0 ?
					new CacheRegionMetadata(regionPath, region.getEvictionStrategyNames(), region.getTotalSpace(), region.getFreeSpace()) :
					null;

				RegionVO vo = new RegionVO(region.getName(), metadata, regionPath);
				if(depth.ordinal() >= CACHE_POPULATION_DEPTH.GROUP0.ordinal())
					vo.addAll(getRegionGroups(cache, region, depth, metadataPopulationDepth));
				regions.add(vo);
			}
			Collections.sort(regions);
		}
		
		return regions;
	}
	
	/**
	 * 
	 * @param cache
	 * @param region
	 * @param depth
	 * @param metadataPopulationDepth
	 * @return
	 * @throws CacheException
	 */
	public static Collection<GroupVO> getRegionGroups(Cache cache, Region region, CACHE_POPULATION_DEPTH depth, CACHE_POPULATION_DEPTH metadataPopulationDepth) 
	throws CacheException
	{
		List<GroupVO> groups = new ArrayList<GroupVO>();
		if(depth.ordinal() >= CACHE_POPULATION_DEPTH.GROUP0.ordinal())
		{
			for( Iterator<? extends Group> groupIterator = region.getGroups();
				groupIterator.hasNext(); )
			{
				Group group = groupIterator.next();
				if(group == null)
				{
					logger.warn("NULL group reference from region.getGroups() is being ignored");
					continue;
				}

				logger.debug(group.getName());
				CacheItemPath groupPath = new CacheItemPath(cache.getName(), region.getName(), group.getName());
				
				// getting region metadata is a very expensive operation, do so only if asked.
				CacheGroupMetadata metadata = metadataPopulationDepth.compareTo(CACHE_POPULATION_DEPTH.GROUP0) >= 0 ?
					new CacheGroupMetadata(groupPath, group.getSize(), group.getLastAccessed()) :
					null;

				GroupVO vo = new GroupVO(
					group.getName(),
					metadata, 
					CACHE_POPULATION_DEPTH.GROUP0,
					CacheSemantics.getGroupSemanticType(cache.getName(), region.getName(), CACHE_POPULATION_DEPTH.GROUP0.getGroupIndex()),
					groupPath
				);

				if(depth.ordinal() > CACHE_POPULATION_DEPTH.GROUP0.ordinal())
					vo.addAll( getGroupGroups(groupPath, group, depth, CACHE_POPULATION_DEPTH.GROUP0, metadataPopulationDepth));
				if(depth.ordinal() >= CACHE_POPULATION_DEPTH.INSTANCE.ordinal())
					vo.addAllInstance(getGroupInstances(groupPath, group, metadataPopulationDepth));
				groups.add(vo);
			}
			Collections.sort(groups);
		}		
		return groups;
	}

	/**
	 * 
	 * @param groupPath
	 * @param group
	 * @param currentDepth
	 * @param targetDepth
	 * @param metadataPopulationDepth
	 * @return
	 * @throws CacheException
	 */
	public static Collection<GroupVO> getGroupGroups(
		CacheItemPath groupPath, 				// the path to the current group
		Group group, 
		CACHE_POPULATION_DEPTH currentDepth, 
		CACHE_POPULATION_DEPTH targetDepth, 
		CACHE_POPULATION_DEPTH metadataPopulationDepth 
		) 
	throws CacheException
	{
		List<GroupVO> groups = new ArrayList<GroupVO>();
		CACHE_POPULATION_DEPTH childrenDepth = CACHE_POPULATION_DEPTH.next(currentDepth);
		
		for( Iterator<? extends Group> groupIterator = group.getGroups();
			groupIterator.hasNext(); )
		{
			Group childGroup = groupIterator.next();
			if(childGroup == null)
			{
				logger.warn("Ignoring NULL in group '" + group.getName() + "' children.");
				continue;
			}
			logger.debug(childGroup.getName() + ", depth is " + (childrenDepth == null ? "null" : childrenDepth.toString()) );
			CacheItemPath childGroupPath = groupPath.createChildPath(childGroup.getName(), false);
			
			// getting region metadata is a very expensive operation, do so only if asked.
			CacheGroupMetadata metadata = metadataPopulationDepth.compareTo(CACHE_POPULATION_DEPTH.GROUP0) >= 0 ?
				new CacheGroupMetadata(childGroupPath, group.getSize(), group.getLastAccessed()) :
				null;
			
			GroupVO vo = new GroupVO(
				childGroup.getName(), 
				metadata, 
				childrenDepth,
				childrenDepth == null ? null : 
				CacheSemantics.getGroupSemanticType(
					childGroupPath.getCacheName(), 
					childGroupPath.getRegionName(), 
					childrenDepth.getGroupIndex()),
					childGroupPath
			);
			if(targetDepth.ordinal() >= CACHE_POPULATION_DEPTH.GROUP0.ordinal())
				vo.addAll(getGroupGroups(childGroupPath, childGroup, childrenDepth, targetDepth, metadataPopulationDepth));
			
			//if(depth.ordinal() >= CACHE_POPULATION_DEPTH.INSTANCE.ordinal())
			//	vo.addAll(getGroupInstances(childGroup, depth));
			groups.add(vo);
		}
		Collections.sort(groups);
		return groups;
	}

	/**
	 * 
	 * @param groupPath
	 * @param group
	 * @param metadataPopulationDepth
	 * @return
	 * @throws CacheException
	 */
	public static Collection<InstanceVO> getGroupInstances(
		CacheItemPath groupPath, 				// the path to the current group
		Group group,
		CACHE_POPULATION_DEPTH metadataPopulationDepth)
	throws CacheException
	{
		List<InstanceVO> instances = new ArrayList<InstanceVO>();
		for( Iterator<? extends Instance> instanceIterator = group.getInstances();
			instanceIterator.hasNext(); )
		{
			Instance instance = instanceIterator.next();

			CacheItemPath instancePath = groupPath.createChildInstancePath(instance.getName());
			
			// getting region metadata is a very expensive operation, do so only if asked.
			CacheInstanceMetadata metadata = metadataPopulationDepth.compareTo(CACHE_POPULATION_DEPTH.INSTANCE) >= 0 ?
				new CacheInstanceMetadata(instancePath, instance.getSize(), instance.getLastAccessed(), instance.getChecksumValue()) :
				null;
			
			InstanceVO instanceVO = new InstanceVO( 
				instance.getName(), 
				metadata, 
				CacheSemantics.getInstanceSemanticType(groupPath.getCacheName(), groupPath.getRegionName()),
				instancePath
			);
			instances.add(instanceVO);
		}
		Collections.sort(instances);
		return instances;
	}

	public static String makeTextSummary(CacheVO cacheVo)
	{
		return makeTextSummary(cacheVo, "", "\t", "\r\n");
	}
	
	/**
	 * 
	 * @param cacheVo
	 * @return
	 */
	public static String makeTextSummary(CacheVO cacheVo, String prefix, String indent, String suffix)
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(prefix);
		sb.append(cacheVo.getName());
		sb.append(suffix);
		
		if(cacheVo.getRegionCount() > 0)
			for( RegionVO region : cacheVo.getRegions() )
			{
				sb.append(prefix);
				sb.append(indent);
				sb.append(region.getName());
				sb.append(suffix);
				if(region.getGroupCount() > 0)
					for(GroupVO group : region.getGroups())
						sb.append(makeTextSummary(group, prefix, indent + indent, suffix));
			}
		
		return sb.toString();
	}

	public static String makeTextSummary(GroupVO group, String prefix, String indent, String suffix) 
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(prefix);
		sb.append(indent);
		sb.append(group.getName());
		sb.append("[" + group.getSemanticTypeName() + "]");
		sb.append(suffix);
		
		if(group.getInstanceCount() > 0)
			for(InstanceVO childInstance : group.getInstances())
				sb.append(makeTextSummary(childInstance, prefix, indent + indent, suffix));
		
		if(group.getGroupCount() > 0)
			for(GroupVO childGroup : group.getGroups())
				sb.append(makeTextSummary(childGroup, prefix, indent + indent, suffix));
		
		return sb.toString();
	}

	private static String makeTextSummary(InstanceVO childInstance, String prefix, String indent, String suffix) 
	{
		StringBuilder sb = new StringBuilder();

		sb.append(prefix);
		sb.append(indent);
		sb.append(childInstance.getName());
		sb.append("[" + childInstance.getSemanticTypeName() + "]");
		sb.append(suffix);
		
		return sb.toString();
	}
	
	public static List<AbstractNamedVO> resolveChildren(CacheItemPath itemPath)
			throws CacheException, MBeanException {
		List<AbstractNamedVO> children = new ArrayList<AbstractNamedVO>();
		String type = itemPath.getItemType();
		if (type == null)
			children.addAll(getCacheManagerCaches(CACHE_POPULATION_DEPTH.CACHE,
					CACHE_POPULATION_DEPTH.CACHE));
		else {
			gov.va.med.imaging.storage.cache.Cache cache = getCache(itemPath
					.getCacheName());
			if (type.equals("cache"))
				children.addAll(getCacheRegions(cache,
						CACHE_POPULATION_DEPTH.REGION,
						CACHE_POPULATION_DEPTH.CACHE));
			else if (type.equals("region")) {
				children.addAll(getRegionGroups(cache,
						cache.getRegion(itemPath.getRegionName()),
						CACHE_POPULATION_DEPTH.GROUP0,
						CACHE_POPULATION_DEPTH.REGION));
			} else if (type.equals("group")) {
				gov.va.med.imaging.storage.cache.Group group = cache.getGroup(
						itemPath.getRegionName(), itemPath.getGroupNames());
				children.addAll(getGroupGroups(itemPath, group,
						CACHE_POPULATION_DEPTH.GROUP0,
						CACHE_POPULATION_DEPTH.REGION,
						CACHE_POPULATION_DEPTH.REGION));
				children.addAll(getGroupInstances(itemPath, group,
						CACHE_POPULATION_DEPTH.GROUP0));
			}
		}
		return children;
	}
	
	public static Object resolveMetadata(CacheItemPath itemPath)
			throws CacheException, MBeanException {
		String type = itemPath.getItemType();
		if (type == null)
			return null;
		if (type.equals("cache"))
			return getCacheMetadata(itemPath);
		if (type.equals("region")) 
			return getCacheRegionMetadata(itemPath);
		if (type.equals("group"))
			return getCacheGroupMetadata(itemPath);
		if (type.equals("instance"))
			return getCacheInstanceMetadata(itemPath);
		return null;
	}
	
	public static String buildQueryString(CacheItemPath itemPath)
			throws UnsupportedEncodingException {
		StringBuilder qsb = new StringBuilder();
		if (itemPath.getCacheName() != null
				&& itemPath.getCacheName().length() > 0) {
			qsb.append("cache=");
			qsb.append(URLEncoder.encode(itemPath.getCacheName(), "UTF8"));
			if (itemPath.getRegionName() != null
					&& itemPath.getRegionName().length() > 0) {
				qsb.append("&region=");
				qsb.append(URLEncoder.encode(itemPath.getRegionName(), "UTF8"));
				if (itemPath.getGroupNames() != null
						&& itemPath.getGroupNames().length > 0) {
					for (int i = 0; i < itemPath.getGroupNames().length; i++) {
						qsb.append("&group=");
						qsb.append(URLEncoder.encode(
								itemPath.getGroupNames()[i], "UTF8"));
					}
				}
				if (itemPath.getInstanceName() != null
						&& itemPath.getInstanceName().length() > 0) {
					qsb.append("&instance=");
					qsb.append(URLEncoder.encode(itemPath.getInstanceName(),
							"UTF8"));
				}
			}
		}

		return qsb.toString();
	}
	
	/**
	 * 
	 * @param region
	 * @return
	 */
	public static GroupSummary totalCount(AbstractGroupParent region)
	{
		GroupSummary totals = new GroupSummary();
		if(region.getGroupCount() > 0)
		{
			totals.groupCount = region.getGroupCount(); 
			totals.instanceCount = region instanceof GroupVO ? ((GroupVO)region).getInstanceCount() : 0; 
			for(GroupVO group:region.getGroups())
			{
				GroupSummary childTotals = totalCount(group);
				totals.groupCount += childTotals.groupCount;
				totals.instanceCount += childTotals.instanceCount;
			}
		}
		
		return totals;
	}
	
	static class GroupSummary
	{
		int groupCount = 0;
		int instanceCount = 0;
	}
}
