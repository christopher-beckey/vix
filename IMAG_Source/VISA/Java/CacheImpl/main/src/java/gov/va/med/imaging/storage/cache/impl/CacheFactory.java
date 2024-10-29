/**
 * 
 */
package gov.va.med.imaging.storage.cache.impl;

import gov.va.med.imaging.storage.cache.Cache;
import gov.va.med.imaging.storage.cache.EvictionStrategy;
import gov.va.med.imaging.storage.cache.EvictionTimer;
import gov.va.med.imaging.storage.cache.Region;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
import gov.va.med.imaging.storage.cache.exceptions.CacheInitializationException;
import gov.va.med.imaging.storage.cache.exceptions.InitializationException;
import gov.va.med.imaging.storage.cache.exceptions.InvalidSweepSpecification;
import gov.va.med.imaging.storage.cache.impl.eviction.EvictionStrategyFactory;
import gov.va.med.imaging.storage.cache.memento.*;
import gov.va.med.imaging.storage.cache.timer.EvictionTimerImpl;

import java.beans.XMLDecoder;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URI;
import java.util.List;

import javax.management.MBeanException;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWBECKEC
 * 
 * A factory that create Cache instances, the type of which is based on one of:
 * 1.) a memento type
 * 2.) a location URL
 * 
 */
public class CacheFactory
{
	// the create mode is passed in when creating a new cache from scratch (i.e. not from a memento)
	// the CreateMode is passed as a String (i.e. CREATE.toString()) rather than the enum value
	// so that application specific configurators may be specified 
	public enum CreateMode
	{
		CREATE,							// configure with no eviction strategies and no regions
		CREATE_TEST, 					// configure with test regions and short term evictions
		CREATE_TEST_NO_EVICTION 		// configure with test regions and no eviction
	};
	
	private static CacheFactory singleton;
	// a map from the persistence protocol to the cache and cache configurator that supports the protocol
	private static ProtocolCacheImplementationMap protocolCacheImplementationMap;
	private final Logger logger = Logger.getLogger(CacheFactory.class);  // Can't uppercase for some reason
	
	static
	{
		// a map from the persistence protocol to the cache and cache configurator that supports the protocol
		protocolCacheImplementationMap = new ProtocolCacheImplementationMap();
		
		protocolCacheImplementationMap.put(
				gov.va.med.imaging.storage.cache.impl.filesystem.FileSystemCache.protocol, 
				gov.va.med.imaging.storage.cache.impl.filesystem.FileSystemCache.class, 
				gov.va.med.imaging.storage.cache.impl.filesystem.FileSystemCacheConfigurator.class,
				gov.va.med.imaging.storage.cache.impl.filesystem.memento.FileSystemCacheMemento.class);
		
//		protocolCacheImplementationMap.put(
//				gov.va.med.imaging.storage.cache.impl.jcifs.JcifsCache.protocol, 
//				gov.va.med.imaging.storage.cache.impl.jcifs.JcifsCache.class, 
//				gov.va.med.imaging.storage.cache.impl.jcifs.JcifsCacheConfigurator.class,
//				gov.va.med.imaging.storage.cache.impl.jcifs.memento.JcifsCacheMemento.class);
//		
//		protocolCacheImplementationMap.put(
//				gov.va.med.imaging.storage.cache.impl.memory.MemoryCache.protocol, 
//				gov.va.med.imaging.storage.cache.impl.memory.MemoryCache.class, 
//				gov.va.med.imaging.storage.cache.impl.memory.MemoryCacheConfigurator.class,
//				gov.va.med.imaging.storage.cache.impl.memory.memento.MemoryCacheMemento.class);
	};
	
	public static synchronized CacheFactory getSingleton()
	{
		return (singleton = singleton != null ? singleton : new CacheFactory());
	}
	
	/**
	 * 
	 */
	private CacheFactory() {}

	/**
	 * Use this method to create a cache instance from a cache memento instance.
	 * 
	 * @param memento
	 * @return
	 * @throws CacheInitializationException
	 */
	public Cache createCache(CacheMemento memento) 
	throws CacheInitializationException
	{	
		return createCacheInstance(memento, protocolCacheImplementationMap.getCacheClass(memento));
	}
	
	/**
	 * Use this factory method to create a new uninitialized Cache.
	 * 
	 * @param protocol
	 * @param name
	 * @return
	 * @throws MBeanException
	 * @throws CacheException
	 */
	public Cache createCache(String cacheName, URI locationUri, String prototypeName) 
	throws CacheException
	{
		// Fortify coding to avoid NPE
		if(locationUri == null)
		{
			String msg = "CacheFactory.createCache(1) --> Given location URI is null.  Can't proceed."; 
			logger.error(msg);
			throw new IllegalArgumentException(msg);
			
			// CacheException is declared as "abstract".  Can't instantiate.  Hummm...
			//throw new CacheException("CacheFactory.createCache() --> Given location URI is null.  Can't proceed.");
		}
		
		String protocol = locationUri.getScheme();
		String location = locationUri.getPath();

        logger.info("{}.createCache ('{})", getClass().getSimpleName(), locationUri.toString());
        logger.info("{}.createCache protocol ='{}', location='{}'.", getClass().getSimpleName(), protocol, location);
		
		Class<? extends Cache> cacheClass = getImplementingCacheClass(locationUri);
		Class<? extends CacheConfigurator> cacheConfiguratorClass = getImplementingCacheConfiguratorClass(locationUri);

        logger.info("{}.createCache cacheClass='{}'", getClass().getSimpleName(), cacheClass.getName());

		Cache cache = createCacheInstance(cacheName, cacheClass, cacheConfiguratorClass, locationUri, null);
		
		if(prototypeName != null)
			configureCache(cache, prototypeName);
		
		return cache;
	}

	/**
	 * Create a cache, given a prototype in the given input stream.
	 * 
	 * @param cacheName
	 * @param locationUri
	 * @param prototype
	 * @return
	 * @throws CacheException
	 */
	public Cache createCache(String cacheName, URI locationUri, InputStream prototype) 
	throws CacheException
	{
		// Fortify coding to avoid NPE
		if(locationUri == null)
		{
			String msg = "CacheFactory.createCache(2) --> Given location URI is null.  Can't proceed.";
			logger.error(msg);
			throw new IllegalArgumentException(msg);
			
			// CacheException is declared as "abstract".  Can't instantiate.  Hummm...
			//throw new CacheException("CacheFactory.createCache() --> Given location URI is null.  Can't proceed.");
		}

		String protocol = locationUri.getScheme();
		String location = locationUri.getPath();

        logger.info("{}.createCache ('{})", getClass().getSimpleName(), locationUri.toString());
        logger.info("{}.createCache protocol ='{}', location='{}'.", getClass().getSimpleName(), protocol, location);
		
		Class<? extends Cache> cacheClass = getImplementingCacheClass(locationUri);
		Class<? extends CacheConfigurator> cacheConfiguratorClass = getImplementingCacheConfiguratorClass(locationUri);

        logger.info("{}.createCache cacheClass='{}'", getClass().getSimpleName(), cacheClass.getName());

		Cache cache = createCacheInstance(cacheName, cacheClass, cacheConfiguratorClass, locationUri, null);
		
		if(prototype != null)
			configureCache(cache, prototype);
		
		return cache;
	}
	
	/**
	 * This method takes an unconfigured cache and runs the given configuration 
	 * strategy on it.  The configuration strategy name is a resource name of an XMLEncoded 
	 * CacheConfigurationStrategyMemento instance.
	 * 
	 * @param cache
	 * @param prototypeName
	 * @throws CacheInitializationException 
	 */
	private void configureCache(Cache cache, String prototypeName) 
	throws CacheException
	{
		// Fortify coding to avoid NPE
		if(cache == null)
		{
			String msg = "CacheFactory.configureCache(1) --> Given cache is null.  Can't proceed.";
			logger.error(msg);
			throw new IllegalArgumentException(msg);
			
			// CacheException is declared as "abstract".  Can't instantiate.  Hummm...
			//throw new CacheException("CacheFactory.createCache() --> Given location URI is null.  Can't proceed.");
		}

        logger.info("CacheFactory.configureCache() --> Configuring cache [{}] as [{}]", cache.getName(), prototypeName);
		
		// look for the prototype first from the root and then in the prototype dir
		InputStream inStream = getClass().getClassLoader().getResourceAsStream(prototypeName);
		if(inStream == null)
		{
			String standardizedName = "prototype/" + prototypeName + ".xml";
			inStream = getClass().getClassLoader().getResourceAsStream(standardizedName);
			
			if(inStream == null) 
			{
				String msg = "CacheFactory.configureCache() --> Unable to access resource [" + prototypeName + "].  Also looked into [" + standardizedName + "]";
				logger.error(msg);
				throw new CacheInitializationException(msg);
			}
		}
		
		// Fortify change: added codes to close the stream in the next method when it's no longer in use.
		configureCache(cache, inStream);
	}
	
	/**
	 * Takes an unconfigured cache and applies the configuration from the input stream.
	 * 
	 * @param cache
	 * @param prototype
	 * @throws CacheException
	 */
	private void configureCache(Cache cache, InputStream prototype) 
	throws CacheException
	{
		// Fortify coding to avoid NPE
		if(cache == null || prototype == null)
		{
			String msg = "CacheFactory.configureCache(2) --> Either given cache or input stream is null.  Can't proceed.";
			logger.error(msg);
			throw new IllegalArgumentException(msg);
			
			// CacheException is declared as "abstract".  Can't instantiate.  Hummm...
			//throw new CacheException("CacheFactory.createCache() --> Given location URI is null.  Can't proceed.");
		}

        logger.info("CacheFactory.configureCache(2) --> Configuring cache [{}] from prototype input stream.", cache.getName());
		
		CacheConfigurationMemento memento = null;
		
		// Fortify change: reworked method to close stream
		try ( XMLDecoder decoder = new XMLDecoder(prototype) )
		{
			memento = (CacheConfigurationMemento)decoder.readObject();
		} finally {
			try { if(prototype != null) { prototype.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}			
		}
		
		configureCache(cache, memento);
	}
	
	/**
	 * 
	 * @param cache
	 * @param memento
	 * @throws CacheException 
	 */
	private void configureCache(Cache cache, CacheConfigurationMemento memento) 
	throws CacheException
	{
		// Fortify coding to avoid NPE
		if(cache == null || memento == null)
		{
			String msg = "CacheFactory.configureCache(3) --> Either given cache or CacheConfigurationMemento object is null.  Can't proceed.";
			logger.error(msg);
			throw new IllegalArgumentException(msg);
			
			// CacheException is declared as "abstract".  Can't instantiate.  Hummm...
			//throw new CacheException("CacheFactory.createCache() --> Given location URI is null.  Can't proceed.");
		}
		
		// Fortify coding
		List<? extends EvictionStrategyMemento> evictionStrategyMementoes = memento.getEvictionStrategyMementoes();

		if(evictionStrategyMementoes != null)
		{
			EvictionStrategyFactory evictionStrategyFactory = EvictionStrategyFactory.getSingleton();
			
			for(EvictionStrategyMemento evictionStrategyMemento : evictionStrategyMementoes)
			{
				EvictionStrategy evictionStrategy = evictionStrategyFactory.createEvictionStrategy(evictionStrategyMemento, cache.getEvictionTimer()); 
				cache.addEvictionStrategy(evictionStrategy);
				
				if(logger.isDebugEnabled() && evictionStrategyMemento != null)
                    logger.debug("CacheFactory.configureCache(3) --> Eviction strategy [{}] added to cache [{}]", evictionStrategyMemento.getName(), cache.getName());
			}
		}
		
		// Fortify coding
		List<? extends RegionMemento> regionMementoes = memento.getRegionMementoes();
		
		if(regionMementoes != null)
		{
			for(RegionMemento regionMemento : regionMementoes)
			{
				cache.addRegion(cache.createRegion(regionMemento));
				
				if(logger.isDebugEnabled() && regionMemento != null)
                    logger.debug("CacheFactory.configureCache(3) --> Region [{}] added to cache [{}]", regionMemento.getName(), cache.getName());
			}
		}
	}

	private Class<? extends Cache> getImplementingCacheClass(URI locationUri) 
	throws CacheInitializationException
	{
		// Fortify coding to avoid NPE
		if(locationUri == null)
		{
			String msg = "CacheFactory.getImplementingCacheClass() --> Given location URI is null.  Can't proceed."; 
			logger.error(msg);
			throw new CacheInitializationException(msg);
		}
		
		String protocol = locationUri.getScheme();
		
		Class<? extends Cache> cacheClass = protocolCacheImplementationMap.getCacheClass(protocol);

		if(cacheClass == null)
		{
			String msg = "CacheFactory.getImplementingCacheClass() --> Unable to find a Cache implementation that supports the [" + protocol + "] protocol.";
			logger.error(msg);
			throw new CacheInitializationException(msg);
		}
		
		return cacheClass;
	}

	private Class<? extends CacheConfigurator> getImplementingCacheConfiguratorClass(URI locationUri) 
	throws CacheInitializationException
	{
		// Fortify coding to avoid NPE
		if(locationUri == null)
		{
			String msg = "CacheFactory.getImplementingCacheConfiguratorClass() --> Given location URI is null.  Can't proceed.";
			logger.error(msg);
			throw new CacheInitializationException(msg);
		}

		String protocol = locationUri.getScheme();
		
		Class<? extends CacheConfigurator> configuratorClass = protocolCacheImplementationMap.getConfiguratorClass(protocol);

		if(configuratorClass == null)
		{
			String msg = "CacheFactory.getImplementingCacheConfiguratorClass() --> Unable to find a Cache configurator that supports the [" + protocol + "] protocol.";
			logger.error(msg);
			throw new CacheInitializationException(msg);
		}
		
		return configuratorClass;
	}
	
	/**
	 * @param protocol
	 * @param cacheName
	 * @param cacheClass
	 * @param evictionTimer
	 * @throws CacheInitializationException
	 */
	private Cache createCacheInstance(
			String cacheName,
			Class<? extends Cache> cacheClass,
			Class<? extends CacheConfigurator> cacheConfiguratorClass,
			URI locationUri,
			EvictionTimer evictionTimer) 
	throws CacheInitializationException
	{
		// Fortify coding to avoid NPE
		if(cacheClass == null)
		{
			String msg = "CacheFactory.createCacheInstance(1) --> Given cache class is null.  Can't proceed.";
			logger.error(msg);
			throw new CacheInitializationException(msg);
		}

		try
		{
			if(evictionTimer == null && cacheConfiguratorClass != null)
				evictionTimer = createDefaultEvictionTimerImpl(cacheConfiguratorClass);
			
			Method factoryMethod = cacheClass.getMethod("create", new Class[]{String.class, URI.class, EvictionTimer.class});
			// assure that the factory method actually returns an instance of the cache class
			if( ! cacheClass.isAssignableFrom(factoryMethod.getReturnType()) )
				throw new CacheInitializationException(
						"CacheFactory.createCacheInstance(1) --> Error creating the cache realization for [" + cacheClass.getName() + "]." + 
						"Assure that the factory method 'create(String, URI, EvictionTimer)' exists, is accessible and returns an instance of [" + cacheClass.getName() + "]");
			
			return (Cache)factoryMethod.invoke(null, new Object[]{cacheName, locationUri, evictionTimer});
		} 
		catch (Exception e)
		{
			String msg ="CacheFactory.createCacheInstance(1) --> Encountered an exception while creating the cache realization [" + cacheClass.getName() + "].\nAssure that the factory method 'create(String, URI, EvictionTimer)' exists and is accessible."; 
			logger.error(msg);
			throw new CacheInitializationException(msg, e);
		} 
	}
	
	/**
	 * @param protocol
	 * @param cacheName
	 * @param cacheClass
	 * @param evictionTimer
	 * @throws CacheInitializationException
	 */
	private Cache createCacheInstance(
			CacheMemento cacheMemento,
			Class<? extends Cache> cacheClass) 
	throws CacheInitializationException
	{
		// Fortify coding to avoid NPE
		if(cacheMemento == null || cacheMemento == null)
		{
			String msg = "CacheFactory.createCacheInstance(2) --> Either given cache class or memento object is null.  Can't proceed.";
			logger.error(msg);
			throw new CacheInitializationException(msg);
		}

        logger.info("CacheFactory.createCacheInstance(2) --> Creating cache [{}] from memento as type [{}]", cacheMemento.getName(), cacheClass.getName());

		try
		{
			Method factoryMethod = cacheClass.getMethod("create", new Class[]{CacheMemento.class});
			// assure that the factory method actual returns an instance of the cache class
			if( ! cacheClass.isAssignableFrom(factoryMethod.getReturnType()) )
				throw new CacheInitializationException(
						"CacheFactory.createCacheInstance(2) --> Error creating the cache realization for [" + cacheClass.getName() + "]." + 
						"Assure that the factory method 'create(CacheMemento)' exists, is accessible and returns an instance of [" + cacheClass.getName() + "]");
			
			return (Cache)factoryMethod.invoke(null, new Object[]{cacheMemento});
		}
		catch (Exception e)
		{
			String msg ="CacheFactory.createCacheInstance(2) --> Encountered an exception while creating the cache realization [" + cacheClass.getName() + "].\nAssure that the factory method 'create(CacheMemento)' exists and is accessible."; 
			logger.error(msg);
			throw new CacheInitializationException(msg, e);
		} 
	}
	
	// ===========================================================================================================================
	// Eviction Timer
	// ===========================================================================================================================

	/**
	 * 
	 * @return
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public EvictionTimerImpl createDefaultEvictionTimerImpl(Class<? extends CacheConfigurator> configuratorClass) 
	throws InstantiationException, IllegalAccessException
	{
		CacheConfigurator configurator = configuratorClass.newInstance();
		try
		{
			return EvictionTimerImpl.create(configurator.getEvictionTimerSweepIntervalMap());
		} 
		catch (Exception e)
		{
            logger.error("CacheFactory.createDefaultEvictionTimerImpl() --> Encountered an exception: {}", e.getMessage());
			return null;
		} 
	}

	public EvictionTimerImpl createEvictionTimerImpl(EvictionTimerImplMemento memento)
	{
		try
		{
			return EvictionTimerImpl.create( memento.getSweepIntervalMap() );
		} 
		catch (Exception e)
		{
            logger.error("CacheFactory.createEvictionTimerImpl() --> Encountered an exception: {}", e.getMessage());
			return null;
		} 
	}
}
