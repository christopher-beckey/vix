/**
 * 
 */
package gov.va.med.cache.gui.server;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;
import gov.va.med.cache.gui.client.CacheDataProvider;
import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.CACHE_POPULATION_DEPTH;
import gov.va.med.cache.gui.shared.CacheItemPath;
import gov.va.med.cache.gui.shared.CacheManagerVO;
import gov.va.med.cache.gui.shared.CacheVO;
import gov.va.med.cache.gui.shared.GroupVO;
import gov.va.med.cache.gui.shared.MergeException;
import gov.va.med.cache.gui.shared.RegionVO;
import gov.va.med.imaging.storage.cache.impl.CacheManagerImpl;

import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Before;
import org.junit.Test;

/**
 * @author VHAISWBECKEC
 *
 */
public class ImagingCacheManagementServiceImplTest
{
	private ImagingCacheManagementServiceImpl serviceImpl;
	protected Logger logger = LogManager.getLogger(this.getClass());
	/**
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp()
	{
		CacheManagerImpl cacheManager = null;
		try
		{
			cacheManager = CacheManagerImpl.getSingleton();
		}
		catch (Exception e1)
		{
			e1.printStackTrace();
		}
		
//		InitialContext initialCtx = null;
//		
//		logger.info("Obtaining InitialContext");
//		try
//		{
//			initialCtx = new InitialContext();
//		}
//		catch (NamingException e)
//		{
//			e.printStackTrace();
//			fail();
//		}
//		
//		logger.info("InitialContext is " + (initialCtx != null ? "NOT NULL" : "NULL") + ", looking up " + ImagingCacheManagementServiceImpl.JNDI_CONTEXT + "/" + ImagingCacheManagementServiceImpl.JNDI_CACHE_MANAGER_NAME);
//		//Context envCtx = (Context) initialCtx.lookup(ImagingCacheManagementServiceImpl.CONTEXT);
//		try
//		{
//			initialCtx.lookup(ImagingCacheManagementServiceImpl.JNDI_CONTEXT + "/" + ImagingCacheManagementServiceImpl.JNDI_CACHE_MANAGER_NAME);
//			logger.info(ImagingCacheManagementServiceImpl.JNDI_CONTEXT + "/" + ImagingCacheManagementServiceImpl.JNDI_CACHE_MANAGER_NAME + " exists, not binding.");
//			initialCtx.rebind(
//				ImagingCacheManagementServiceImpl.JNDI_CONTEXT + "/" + ImagingCacheManagementServiceImpl.JNDI_CACHE_MANAGER_NAME,
//				cacheManager
//			);
//			logger.info( cacheManager.toString() + " rebound to " + ImagingCacheManagementServiceImpl.JNDI_CONTEXT + "/" + ImagingCacheManagementServiceImpl.JNDI_CACHE_MANAGER_NAME);
//		}
//		catch(NamingException nX)
//		{
//			logger.info(ImagingCacheManagementServiceImpl.JNDI_CONTEXT + "/" + ImagingCacheManagementServiceImpl.JNDI_CACHE_MANAGER_NAME + " does not exist, binding.");
//			
//			try
//			{
//				initialCtx.bind(
//					ImagingCacheManagementServiceImpl.JNDI_CONTEXT + "/" + ImagingCacheManagementServiceImpl.JNDI_CACHE_MANAGER_NAME,
//					cacheManager
//				);
//				logger.info( CacheManagerImpl.getSingleton().toString() + " bound to " + ImagingCacheManagementServiceImpl.JNDI_CONTEXT + "/" + ImagingCacheManagementServiceImpl.JNDI_CACHE_MANAGER_NAME);
//			}
//			catch (Exception e)
//			{
//				e.printStackTrace();
//				fail();
//			}
//		}
		
		serviceImpl = new ImagingCacheManagementServiceImpl();
	}

	/**
	 * Test method for {@link gov.va.med.cache.gui.server.ImagingCacheManagementServiceImpl#getCacheManagerVO()}.
	 */
	@Test
	public void testGetCacheManagerVO()
	{
		assertNotNull( this.serviceImpl.getCacheManagerVO() );
	}

	/**
	 * Test method for {@link gov.va.med.cache.gui.server.ImagingCacheManagementServiceImpl#getCacheItems(gov.va.med.cache.gui.shared.CacheItemPath, gov.va.med.cache.gui.shared.CACHE_POPULATION_DEPTH)}.
	 */
	@Test
	public void testGetCacheOnly()
	{
		CacheVO result;
		
		result = this.serviceImpl.getCacheItems(new CacheItemPath("ImagingExchangeCache"), CACHE_POPULATION_DEPTH.CACHE, CACHE_POPULATION_DEPTH.CACHE);
		assertNotNull( result );
		assertEquals(0, result.getRegionCount());
	}

	@Test
	public void testGetCacheAndRegions()
	{
		CacheVO result;
		
		result = this.serviceImpl.getCacheItems(new CacheItemPath("ImagingExchangeCache"), CACHE_POPULATION_DEPTH.REGION, CACHE_POPULATION_DEPTH.CACHE);
		assertNotNull( result );
		assertEquals(4, result.getRegionCount());

		for(RegionVO region : result.getRegions())
		{
			assertNotNull(region);
			assertNotNull(region.getName());
			System.out.println(region.getName());
		}
		
	}
	
	@Test
	public void testGetCacheRegionsGroups1()
	{
		CacheVO result;
		
		result = this.serviceImpl.getCacheItems(new CacheItemPath("ImagingExchangeCache"), CACHE_POPULATION_DEPTH.GROUP0, CACHE_POPULATION_DEPTH.CACHE);
		assertNotNull( result );

		boolean groupFound = false;
		for(RegionVO region : result.getRegions())
		{
			assertNotNull(region);
			assertNotNull(region.getName());
			assertNotNull(region.getGroups());
			
			for(GroupVO group : region.getGroups())
				groupFound = true;
		}
		
		assertTrue(groupFound);
	}
	
	@Test
	public void testMergeRegions() 
	throws MergeException
	{
		CacheVO clientCache;
		CacheVO clientCacheUpdate;
		
		clientCache = this.serviceImpl.getCacheItems(new CacheItemPath("ImagingExchangeCache"), CACHE_POPULATION_DEPTH.CACHE, CACHE_POPULATION_DEPTH.CACHE);
		assertNotNull( clientCache );

		clientCacheUpdate = this.serviceImpl.getCacheItems(new CacheItemPath("ImagingExchangeCache"), CACHE_POPULATION_DEPTH.REGION, CACHE_POPULATION_DEPTH.CACHE);
		assertNotNull( clientCacheUpdate );
		
		clientCache.merge(clientCacheUpdate);
		assertTrue(clientCache.getRegionCount() == 4);
		
		clientCacheUpdate = this.serviceImpl.getCacheItems(new CacheItemPath("ImagingExchangeCache"), CACHE_POPULATION_DEPTH.GROUP0, CACHE_POPULATION_DEPTH.CACHE);
		assertNotNull( clientCacheUpdate );
	}

	@Test
	public void testMergeCacheManager() 
	throws MergeException
	{
		CacheManagerVO cacheManagerVO = new CacheManagerVO();

		CacheVO clientCache = this.serviceImpl.getCacheItems(new CacheItemPath("ImagingExchangeCache"), CACHE_POPULATION_DEPTH.CACHE, CACHE_POPULATION_DEPTH.CACHE);
		assertNotNull( clientCache );
		cacheManagerVO.add(clientCache);
		
		CacheManagerVO clientCacheManagerUpdateVO = new CacheManagerVO();
		CacheVO clientCacheUpdate = this.serviceImpl.getCacheItems(new CacheItemPath("ImagingExchangeCache"), CACHE_POPULATION_DEPTH.REGION, CACHE_POPULATION_DEPTH.CACHE);
		assertNotNull( clientCacheUpdate );
		clientCacheManagerUpdateVO.add(clientCacheUpdate);

		cacheManagerVO.merge(clientCacheManagerUpdateVO);
		AbstractNamedVO namedVo = CacheDataProvider.followPath(clientCache, new CacheItemPath("ImagingExchangeCache", "va-image-region"));
		assertEquals("va-image-region", namedVo.getName());
	}
	
	@Test
	public void testFollowPath()
	{
		CacheVO clientCache;
		
		clientCache = this.serviceImpl.getCacheItems(new CacheItemPath("ImagingExchangeCache"), CACHE_POPULATION_DEPTH.GROUP0, CACHE_POPULATION_DEPTH.CACHE);
		assertNotNull( clientCache );

		AbstractNamedVO namedVo = CacheDataProvider.followPath(clientCache, new CacheItemPath("ImagingExchangeCache", "dod-metadata-region"));
		assertNotNull(namedVo);
		assertEquals("dod-metadata-region", namedVo.getName());
		
		namedVo = CacheDataProvider.followPath(clientCache, new CacheItemPath("ImagingExchangeCache", "va-image-region"));
		assertNotNull(namedVo);
		assertEquals("va-image-region", namedVo.getName());
		
//		namedVo = CacheDataProvider.followPath(clientCache, new CacheItemPath("ImagingExchangeCache", "va-image-region", "678"));
//		assertNotNull(namedVo);
//		assertEquals("678", namedVo.getName());
	}
}
