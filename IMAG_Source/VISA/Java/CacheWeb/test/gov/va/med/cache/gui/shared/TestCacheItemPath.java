/**
 * 
 */
package gov.va.med.cache.gui.shared;

import static org.junit.Assert.*;

import org.junit.Test;


/**
 * @author VHAISWBECKEC
 *
 */
public class TestCacheItemPath
{
	protected CacheItemPath[] testPoints = new CacheItemPath[]
	{
		new CacheItemPath(),
		new CacheItemPath("CacheName"),
		new CacheItemPath("CacheName", "RegionName"),
		new CacheItemPath("CacheName", "RegionName", "Group1Name", "Group2Name"),
		new CacheItemPath("CacheName", "RegionName", new String[]{"Group1Name"}, "InstanceName"),
	};
	
	
	@Test
	public void testEndpointDepth()
	{
		assertEquals(CACHE_POPULATION_DEPTH.CACHE_MANAGER, testPoints[0].getEndpointDepth());
		assertEquals(CACHE_POPULATION_DEPTH.CACHE, testPoints[1].getEndpointDepth());
		assertEquals(CACHE_POPULATION_DEPTH.REGION, testPoints[2].getEndpointDepth());
		assertEquals(CACHE_POPULATION_DEPTH.GROUP1, testPoints[3].getEndpointDepth());
		assertEquals(CACHE_POPULATION_DEPTH.INSTANCE, testPoints[4].getEndpointDepth());
	}
}
