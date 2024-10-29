package gov.va.med.imaging.cache;

import gov.va.med.imaging.cache.CacheManagementService;
import gov.va.med.imaging.cache.ImagingCacheManagementService;
import gov.va.med.imaging.cache.CACHE_POPULATION_DEPTH;
import gov.va.med.imaging.cache.CacheGroupMetadata;
import gov.va.med.imaging.cache.CacheInstanceMetadata;
import gov.va.med.imaging.cache.CacheItemPath;
import gov.va.med.imaging.cache.CacheManagerVO;
import gov.va.med.imaging.cache.CacheMetadata;
import gov.va.med.imaging.cache.CacheRegionMetadata;
import gov.va.med.imaging.cache.CacheVO;
import gov.va.med.imaging.cache.FieldVerifier;
import gov.va.med.imaging.cache.GroupVO;
import gov.va.med.imaging.cache.InstanceVO;
import gov.va.med.imaging.cache.RegionVO;
import gov.va.med.imaging.storage.cache.Cache;
import gov.va.med.imaging.storage.cache.Group;
import gov.va.med.imaging.storage.cache.Region;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;

import java.util.List;

import javax.management.MBeanException;

import gov.va.med.logging.Logger;

/**
 * The server side implementation of the cache management RPC service.
 * 
 * NOTES:
 * 1.) This servlet needs the servlet context so that it can get the Spring application context,
 * so that it can get the cache manager.  Overriding ServletContextAware, specifically setServletContext(),
 * breaks something in GWT.  Doing so results in a NullPointerException deep in GWT with little indication
 * of its source.
 * 2.) The CacheAPI and CacheImpl jars MUST be loaded from the Tomcat common class loader.  If those jars
 * are loaded from this web application then multiple copies of the cache manager and caches will be created
 * and that will break things seriously. 
 * 
 * @author VHAISWBECKEC
 * 
 */
@SuppressWarnings("serial")
public class ImagingCacheManagementServiceImpl 
implements ImagingCacheManagementService
{
	private final Logger logger = Logger.getLogger(this.getClass());
	
	// default the initial population depth to REGION
	// this seems to make everything work and won't be too slow
	private static final CACHE_POPULATION_DEPTH INITIAL_DEPTH = CACHE_POPULATION_DEPTH.REGION;
	// how much metadata is populated on the initial population
	// anything below CACHE level will cause a significant performance hit
	private static final CACHE_POPULATION_DEPTH INITIAL_METADATA_DEPTH = CACHE_POPULATION_DEPTH.CACHE;
	
	public ImagingCacheManagementServiceImpl()
	{
		super();
	}

	/*public ImagingCacheManagementServiceImpl(Object delegate)
	{
		super(delegate);
	}*/

	/**
	 * The depth of the result when getCacheManagerVO() is called, has no
	 * meaning after that.
	 * 
	 * @return
	 */
	public CACHE_POPULATION_DEPTH getInitialDepth()
	{
		return INITIAL_DEPTH;
	}

	public CACHE_POPULATION_DEPTH getInitialMetadataDepth() 
	{
		return INITIAL_METADATA_DEPTH;
	}

	/**
	 * 
	 * @return
	 */
	@Override
	public CacheManagerVO getCacheManagerVO()
	{
		logger.info("ENTER getCacheManagerVO()");
		CacheManagerVO cacheManagerVo = new CacheManagerVO();
		try
		{
			cacheManagerVo.addAll(CacheManagementService.getCacheManagerCaches(getInitialDepth(), getInitialMetadataDepth()));
		}
		catch (CacheException e)
		{
			e.printStackTrace();
		} 
		catch (MBeanException e) 
		{
			e.printStackTrace();
		}

        logger.info("Returning CacheManagerVO with {}.", getInitialDepth().toString());
		
		return cacheManagerVo;
	}

	@Override
	public List<CacheVO> getCacheList(CACHE_POPULATION_DEPTH depth, CACHE_POPULATION_DEPTH metadataPopulationDepth) 
	throws IllegalArgumentException
	{
		List<CacheVO> caches = null;
		try
		{
			caches = CacheManagementService.getCacheManagerCaches(depth, metadataPopulationDepth);
		}
		catch (CacheException e)
		{
			e.printStackTrace();
		}
		catch (MBeanException e) 
		{
			e.printStackTrace();
		}
		return caches;
	}

	/**
	 * Populate a CacheVO to an arbitrary level, starting at an arbitrary item
	 * determined by the given path. Gets cache items from the path down to the requested depth,
	 * returning the results as a populated CacheVO.
	 * 
	 * @param path - NULL means to start at the top, the CacheManager
	 * @param targetDepth - the maximum depth
	 * @param metadaPopulationDepth - to what depth to include metadata in the result
	 */
	@Override
	public CacheVO getCacheItems(CacheItemPath path, CACHE_POPULATION_DEPTH targetDepth, CACHE_POPULATION_DEPTH metadataPopulationDepth) 
	throws IllegalArgumentException
	{
		CacheVO result = null;
		Cache cache;

		if(targetDepth == null)
			targetDepth = path == null ? CACHE_POPULATION_DEPTH.CACHE : CACHE_POPULATION_DEPTH.next(path.getEndpointDepth()); 
		if(metadataPopulationDepth == null)
			metadataPopulationDepth = CACHE_POPULATION_DEPTH.CACHE;

        logger.debug("getCacheItems({}, {}, {})", path == null ? "null" : "" + path.toString(), targetDepth.toString(), metadataPopulationDepth.toString());
		
		CacheItemPath currentPath;
		
		try
		{
			cache = CacheManagementService.getCache(path.getCacheName());
			if(cache == null)
				throw new IllegalArgumentException("The cache named '" + path.getCacheName() + "' does not exist.");
			
			// all of the CacheMetadata properties are quickly accessible so populate the
			// metadata all of the time
			result = new CacheVO(
				cache.getName(), 
				new CacheMetadata(
					new CacheItemPath(path.getCacheName()), 
					cache.getLocationUri().toString(), 
					cache.getLocationPath(), 
					cache.getLocationProtocol() )
			);
			currentPath = new CacheItemPath(cache.getName());
			
			// if the region name is null, then populate the result from the cache level
			if(path.getRegionName() == null)
			{
				result.addAll( CacheManagementService.getCacheRegions(cache, targetDepth, metadataPopulationDepth) );
			}
			// else, the region is part of the path, populate the results from some lower level
			else
			{
				Region region = cache.getRegion(path.getRegionName());
				RegionVO regionVO = new RegionVO(region.getName(), null);
				result.add(regionVO);		// add the region to the result, to set the context of the result
				currentPath = currentPath.createChildPath(region.getName(), false);
				
				// if no group names are provided then populate the result with all of the groups
				// within the region
				if(path.getGroupNames() == null || path.getGroupNames().length < 1)
				{
					regionVO.addAll( CacheManagementService.getRegionGroups(cache, region, targetDepth, metadataPopulationDepth) );
				}
				
				// else, at least one group level is provided, so populate from a 
				// lower group level 
				else
				{
					// get the first group and build the currentPath
					CACHE_POPULATION_DEPTH currentGroupDepth = CACHE_POPULATION_DEPTH.GROUP0;
					Group currentGroup = region.getChildGroup(path.getGroupNames()[0]);
					String groupSemanticName = CacheSemantics.getGroupSemanticType(
						cache.getName(), 
						region.getName(), 
						currentGroupDepth.getGroupIndex()
					);
					
					GroupVO currentGroupVO = new GroupVO(
						currentGroup.getName(),
						null, 
						currentGroupDepth, 
						groupSemanticName
					);
					regionVO.add(currentGroupVO);	// add the current group, to set the context of the result
					currentPath = currentPath.createChildPath(currentGroup.getName(), false);
					
					
					//
					// iterate through the groups until the path ends
					for(int index=1; index < path.getGroupNames().length; ++index)
					{
						Group childGroup = currentGroup.getChildGroup(path.getGroupNames()[index]);
						currentGroupDepth = CACHE_POPULATION_DEPTH.next(currentGroupDepth);
						
						groupSemanticName = CacheSemantics.getGroupSemanticType(
							cache.getName(), 
							region.getName(), 
							currentGroupDepth.getGroupIndex()
						);
						
						GroupVO childGroupVO = new GroupVO(
							childGroup.getName(),
							null, 
							currentGroupDepth, 
							groupSemanticName
						);
						currentPath = currentPath.createChildPath(childGroup.getName(), false);
						
						currentGroupVO.add(childGroupVO);
						currentGroup = childGroup;
						currentGroupVO = childGroupVO;
					}
					
					if(path.getInstanceName() == null)
					{
						currentGroupVO.addAll( 
							CacheManagementService.getGroupGroups(currentPath, currentGroup, currentGroupDepth, targetDepth, metadataPopulationDepth) 
						);
						currentGroupVO.addAllInstance( 
							CacheManagementService.getGroupInstances(currentPath, currentGroup, metadataPopulationDepth) );
					}
					else
					{
						// this is kinda' silly 'cause it just recreates the original path as a
						// link of value objects, but it is logically correct so ...
						currentGroupVO.addInstance( new InstanceVO(
							path.getInstanceName(), 
							null, 
							CacheSemantics.getInstanceSemanticType(cache.getName(), region.getName()))
						);
					}
				}
			}
		}
		catch (CacheException e)
		{
			e.printStackTrace();
		}
		catch (MBeanException e) 
		{
			e.printStackTrace();
		}

        logger.debug("getCacheItems({},{}) result is: \r\n{}", path.toString(), targetDepth.toString(), CacheManagementService.makeTextSummary(result));
		return result;
	}

	/**
	 * 
	 * @param cachename
	 */
	public CacheItemPath clearCache(CacheItemPath path) 
	throws IllegalArgumentException
	{
		try 
		{
			Cache cache = CacheManagementService.getCache(path.getCacheName());
			cache.clear();
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			throw new IllegalArgumentException("I'm sorry Keith, I can't do that...", e);
		}

		return path;
	}

	@Override
	public CacheItemPath deleteGroup(CacheItemPath groupPath) 
	throws IllegalArgumentException
	{
        logger.debug("deleteGroup({})", groupPath.toString());
		assert( groupPath.getCacheName() != null );
		assert( groupPath.getRegionName() != null );
		assert( groupPath.getGroupNames() != null );
		assert( groupPath.getGroupNames().length > 0 );
		assert( groupPath.getGroupNames()[0] != null );
        logger.debug("deleteGroup({}), parameters validated", groupPath.toString());
		
		try
		{
			Cache cache = CacheManagementService.getCache( groupPath.getCacheName() );
            logger.debug("deleteGroup({}) cache '{}' found.", groupPath.toString(), cache.getName());
			cache.deleteGroup(groupPath.getRegionName(), groupPath.getGroupNames(), true);
            logger.debug("deleteGroup({}) group deleted.", groupPath.toString());
			
			return groupPath;
		}
		catch (CacheException e)
		{
			e.printStackTrace();
			throw new IllegalArgumentException("Unable to delete group, exception occured '" + e.getMessage() + "'.");
		}
		catch (MBeanException e) 
		{
			e.printStackTrace();
			throw new IllegalArgumentException("Unable to delete group, exception occured '" + e.getMessage() + "'.");
		}
	}
	
	/**
	 * 
	 */
	@Override
	public CacheItemPath deleteInstance(CacheItemPath instancePath) 
	throws IllegalArgumentException
	{
		if(instancePath == null)
			throw new IllegalArgumentException("deleteInstance(), NULL instancePath parameter.");

        logger.debug("deleteInstance({})", instancePath.toString());
		assert( instancePath.getCacheName() != null );
		assert( instancePath.getRegionName() != null );
		assert( instancePath.getGroupNames() != null );
		assert( instancePath.getInstanceName() != null );
		assert( instancePath.getGroupNames().length > 0 );
		assert( instancePath.getGroupNames()[0] != null );
        logger.debug("deleteInstance({}), parameters validated", instancePath.toString());
		
		try
		{
			Cache cache = CacheManagementService.getCache( instancePath.getCacheName() );
            logger.debug("deleteInstance({}) cache '{}' found.", instancePath.toString(), cache.getName());
			cache.deleteInstance(instancePath.getRegionName(), instancePath.getGroupNames(), instancePath.getInstanceName(), true);
            logger.debug("deleteInstance({}) instance deleted.", instancePath.toString());
			
			return instancePath;
		}
		catch (CacheException cX)
		{
			cX.printStackTrace();
			throw new IllegalArgumentException("Unable to delete instance, exception occured '" + cX.getMessage() + "'.");
		} 
		catch (MBeanException mbX) 
		{
			mbX.printStackTrace();
			throw new IllegalArgumentException("Unable to delete instance, exception occured '" + mbX.getMessage() + "'.");
		}
	}

	@Override
	public CacheMetadata getCacheMetadata(CacheItemPath cachePath)
	throws IllegalArgumentException 
	{
        logger.debug("getCacheRegionMetadata({})", cachePath.toString());
		assert( cachePath.getCacheName() != null );
        logger.debug("getCacheRegionMetadata({}), parameters validated", cachePath.toString());
	
		return CacheManagementService.getCacheMetadata(cachePath);
	}

	@Override
	public CacheRegionMetadata getCacheRegionMetadata(CacheItemPath regionPath)
	throws IllegalArgumentException 
	{
        logger.debug("getCacheRegionMetadata({})", regionPath.toString());
		assert( regionPath.getCacheName() != null );
		assert( regionPath.getRegionName() != null );
        logger.debug("getCacheRegionMetadata({}), parameters validated", regionPath.toString());
		
		return CacheManagementService.getCacheRegionMetadata(regionPath);
	}

	@Override
	public CacheGroupMetadata getCacheGroupMetadata(CacheItemPath groupPath)
	throws IllegalArgumentException 
	{
        logger.debug("getCacheInstanceMetadata({})", groupPath.toString());
		assert( groupPath.getCacheName() != null );
		assert( groupPath.getRegionName() != null );
		assert( groupPath.getGroupNames() != null && groupPath.getGroupNames().length > 0);
        logger.debug("getCacheInstanceMetadata({}), parameters validated", groupPath.toString());
		
		return CacheManagementService.getCacheGroupMetadata(groupPath);
	}

	@Override
	public CacheInstanceMetadata getCacheInstanceMetadata(CacheItemPath itemPath)
	throws IllegalArgumentException 
	{
        logger.debug("getCacheInstanceMetadata({})", itemPath.toString());
		assert( itemPath.getCacheName() != null );
		assert( itemPath.getRegionName() != null );
		assert( itemPath.getGroupNames() != null && itemPath.getGroupNames().length > 0);
		assert( itemPath.getInstanceName() != null );
        logger.debug("getCacheInstanceMetadata({}), parameters validated", itemPath.toString());
		
		return CacheManagementService.getCacheInstanceMetadata(itemPath);
	}
	
	/**
	 * Escape an html string. Escaping data received from the client helps to
	 * prevent cross-site script vulnerabilities.
	 * 
	 * @param html the html string to escape
	 * @return the escaped string
	 */
	private static String escapeHtml(String html)
	{
		if (html == null) { return null; }
		return html.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	}
	

//	private void evaluateNameInContext(Context ctx, String[] names)
//	{
//		for(String name : names)
//		{
//			try
//			{
//				Object obj = ctx.lookup(name);
//				logger.info("'" + name + "' is bound to an object of type '" + obj.getClass().getName() + "'.");
//			}
//			catch(NamingException nX)
//			{
//				logger.info("'" + name + "' is NOT bound in this context");
//			}
//		}
//	}

	// Names used when the CacheManager is made available through JNDI
//	public static final String JNDI_CACHE_MANAGER_FQN = "java:comp/env/cacheManager";
//	public final static String JNDI_CONTEXT = "java:comp/env";
//	public final static String JNDI_CACHE_MANAGER_NAME = "cacheManager";
	
//	private void initializeThroughJNDI()
//	{
//		try
//		{
//			InitialContext initialCtx = new InitialContext();
//			logger.info(initialCtx.getClass().getName());
//			logger.info(initialCtx.composeName(JNDI_CACHE_MANAGER_NAME, ""));
//			//evaluateNameInContext(initialCtx, 
//			//	new String[]{"java:", "java:comp", "java:comp/env", "cacheManager", "java:cacheManager", "java:comp/cacheManager", "java:comp/env/cacheManager"}
//			//);
//			Context envCtx = (Context) initialCtx.lookup(JNDI_CONTEXT);
//			
//			logger.info("Initial Context " 
//				+ (initialCtx instanceof DirContext ? "IS" : "IS NOT")
//				+ " a DirContext.");
//			logger.info("Environment Context " 
//				+ (envCtx instanceof DirContext ? "IS" : "IS NOT")
//				+ " a DirContext.");
//			
//			//evaluateNameInContext(envCtx, 
//			//	new String[]{"java:", "java:comp", "java:comp/env", "cacheManager", "java:cacheManager", "java:comp/cacheManager", "java:comp/env/cacheManager"}
//			//);
//			Object uncastCacheManager = null;
//			try
//			{
//				try
//				{
//					// Running in Tomcat and running with SimpleJNDI in JUnit tests
//					// put the cache manager under different contexts.
//					// This try/catch is a cheesy way to hack around it rather than
//					// really fixing it.
//					if(envCtx == null)		// this just jumps us to the catch block
//						throw new NamingException();
//					
//					uncastCacheManager = envCtx.lookup(JNDI_CACHE_MANAGER_FQN);
//				}
//				catch (NamingException nX)
//				{
//					uncastCacheManager = initialCtx.lookup(JNDI_CACHE_MANAGER_FQN);
//				}
//				
//				this.cacheManager = (CacheManager)uncastCacheManager;
//			}
//			catch (ClassCastException ccX)
//			{
//				logger.error(
//					"A reference to '" + uncastCacheManager.getClass().getName() 
//					+ "{" + uncastCacheManager.getClass().getClassLoader().toString() + "}"  
//					+ "' was obtained from '" + JNDI_CACHE_MANAGER_FQN + 
//					"' but casting to '"
//					+ CacheManager.class.getName()
//					+ "{" + CacheManager.class.getClassLoader().toString() + "}"  
//					+ " failed.  "
//					+ "If the Class Loaders differ this may indicate that an extra copy of either CacheManager or CacheManagerImpl is referenced from the web app class loader."
//				);
//				this.cacheManager = null;
//			}
//				
//			logger.info("Cache manager reference " + (this.cacheManager == null ? "IS NULL" : "IS NOT NULL") + ".");
//			if(this.cacheManager == null)
//				throw new AssertionError("Cache manager reference IS NULL.");
//		}
//		catch (NamingException e)
//		{
//			e.printStackTrace();
//			logger.error(e);
//			throw new AssertionError(e.getMessage());
//		}
//	}
}
