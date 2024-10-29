package gov.va.med.imaging.cache;

import gov.va.med.imaging.cache.CACHE_POPULATION_DEPTH;
import gov.va.med.imaging.cache.CacheGroupMetadata;
import gov.va.med.imaging.cache.CacheInstanceMetadata;
import gov.va.med.imaging.cache.CacheItemPath;
import gov.va.med.imaging.cache.CacheManagerVO;
import gov.va.med.imaging.cache.CacheMetadata;
import gov.va.med.imaging.cache.CacheRegionMetadata;
import gov.va.med.imaging.cache.CacheVO;

import java.util.List;

/**
 * The client side stub for the RPC service.
 */
public interface ImagingCacheManagementService 
{
	/**
	 * 
	 * @return
	 * @throws IllegalArgumentException
	 */
	CacheManagerVO getCacheManagerVO() 
	throws IllegalArgumentException;
	
	/**
	 * 
	 * @param depth
	 * @return
	 * @throws IllegalArgumentException
	 */
	List<CacheVO> getCacheList(CACHE_POPULATION_DEPTH depth, CACHE_POPULATION_DEPTH populateMetadataDepth) 
	throws IllegalArgumentException;

	/**
	 * 
	 * @param cachename
	 * @throws IllegalArgumentException
	 */
	public CacheItemPath clearCache(CacheItemPath path) 
	throws IllegalArgumentException;

	/**
	 * Given a path into an item in the cache, populates a CacheVO
	 * instance with the descendants along that path and further, 
	 * to the depth requested.
	 *  
	 * @param path
	 * @param callback
	 * @throws IllegalArgumentException
	 */
	CacheVO getCacheItems(CacheItemPath path, CACHE_POPULATION_DEPTH depth, CACHE_POPULATION_DEPTH populateMetadataDepth) 
	throws IllegalArgumentException;
	
	/**
	 * 
	 * @param groupPath
	 * @return
	 * @throws IllegalArgumentException
	 */
	CacheItemPath deleteGroup(CacheItemPath groupPath)
	throws IllegalArgumentException;
	
	/**
	 * 
	 * @param groupPath
	 * @return
	 * @throws IllegalArgumentException
	 */
	CacheItemPath deleteInstance(CacheItemPath groupPath)
	throws IllegalArgumentException;

	/**
	 * Given a path to a cache, return a value object with cache metadata
	 * 
	 * @param groupPath
	 * @return
	 * @throws IllegalArgumentException
	 */
	CacheMetadata getCacheMetadata(CacheItemPath groupPath)
	throws IllegalArgumentException;
	
	/**
	 * Given a path to a cache region, return a value object with region metadata
	 * 
	 * @param groupPath
	 * @return
	 * @throws IllegalArgumentException
	 */
	CacheRegionMetadata getCacheRegionMetadata(CacheItemPath groupPath)
	throws IllegalArgumentException;
	
	/**
	 * Given a path to a cache group, return a value object with instance metadata
	 * 
	 * @param groupPath
	 * @return
	 * @throws IllegalArgumentException
	 */
	CacheGroupMetadata getCacheGroupMetadata(CacheItemPath groupPath)
	throws IllegalArgumentException;
	
	/**
	 * Given a path to a cache instance, return a value object with instance metadata
	 * 
	 * @param groupPath
	 * @return
	 * @throws IllegalArgumentException
	 */
	CacheInstanceMetadata getCacheInstanceMetadata(CacheItemPath groupPath)
	throws IllegalArgumentException;

}
