package gov.va.med.imaging.storage.cache.impl;

import gov.va.med.imaging.storage.cache.Cache;
import gov.va.med.imaging.storage.cache.CacheLifecycleEvent;
import gov.va.med.imaging.storage.cache.CacheManager;
import gov.va.med.imaging.storage.cache.CacheStructureChangeListener;
import gov.va.med.imaging.storage.cache.EvictionStrategy;
import gov.va.med.imaging.storage.cache.EvictionTimer;
import gov.va.med.imaging.storage.cache.Region;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
import gov.va.med.imaging.storage.cache.exceptions.CacheInitializationException;
import gov.va.med.imaging.storage.cache.exceptions.CacheStateException;
import gov.va.med.imaging.storage.cache.exceptions.InitializationException;
import gov.va.med.imaging.storage.cache.impl.eviction.EvictionStrategyFactory;
import gov.va.med.imaging.storage.cache.impl.filesystem.FileSystemCache;
import gov.va.med.imaging.storage.cache.impl.jmx.AbstractCacheMBean;
import gov.va.med.imaging.storage.cache.memento.EvictionStrategyMemento;
import gov.va.med.imaging.utils.FileUtilities;
import gov.va.med.server.CacheResourceReferenceFactory;
import gov.va.med.server.ServerLifecycleEvent;
import gov.va.med.server.ServerLifecycleListener;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.lang.management.ManagementFactory;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

import javax.management.Attribute;
import javax.management.AttributeNotFoundException;
import javax.management.DynamicMBean;
import javax.management.InstanceAlreadyExistsException;
import javax.management.InstanceNotFoundException;
import javax.management.InvalidAttributeValueException;
import javax.management.MBeanException;
import javax.management.MBeanInfo;
import javax.management.MBeanNotificationInfo;
import javax.management.MBeanOperationInfo;
import javax.management.MBeanRegistrationException;
import javax.management.MBeanServer;
import javax.management.MalformedObjectNameException;
import javax.management.NotCompliantMBeanException;
import javax.management.ObjectName;
import javax.management.ReflectionException;
import javax.management.openmbean.OpenDataException;
import javax.management.openmbean.OpenMBeanAttributeInfo;
import javax.management.openmbean.OpenMBeanAttributeInfoSupport;
import javax.management.openmbean.OpenMBeanConstructorInfo;
import javax.management.openmbean.OpenMBeanConstructorInfoSupport;
import javax.management.openmbean.OpenMBeanInfoSupport;
import javax.management.openmbean.OpenMBeanOperationInfo;
import javax.management.openmbean.OpenMBeanOperationInfoSupport;
import javax.management.openmbean.OpenMBeanParameterInfo;
import javax.management.openmbean.OpenMBeanParameterInfoSupport;
import javax.management.openmbean.SimpleType;
import javax.naming.NamingException;
import javax.naming.Reference;

import gov.va.med.logging.Logger;

/**
 * Cache instances must be created through this class, not directly.  
 * This class is the interface for the cache lifecycle and also for the management and monitoring of the 
 * lifecycle and parameter persistence methods of a Cache instance.
 * 
 * This class also is responsible for storing and loading the FileSystemCache state and for
 * restoring the state of the cache when it is recreated.
 * 
 * The CacheManagerImpl singleton may manage a number of cache instances, each identified
 * by name.  This class (CacheFactory) uses the name as identified in the resource
 * declaration as the cache name it needs from CacheManagerImpl.
 * 
 * The CacheManagerImpl manages the lifecycle and the configuration of the Cache
 * regardless of whether an MBeanServer is available.  The CacheManagerImpl must be
 * instantiated and it must be used for Cache configuration, not direct
 * Cache access.
 * 
 * @author VHAISWBECKEC
 *
 */
public class CacheManagerImpl
extends AbstractCacheMBean
implements ServerLifecycleListener, CacheStructureChangeListener, CacheManager
{
	private static CacheManagerImpl singleton;		// the single instance of this class
	
	private final static Logger LOGGER = Logger.getLogger(CacheManagerImpl.class);
	
	ServerRunningStatus serverRunningStatus = new ServerRunningStatus();// we may delay starting the managed caches so we set this when we get the start
	private KnownCacheList knownCaches;					// A list of all the caches that this manager knows about, this class keeps the
														// configurations in the config directory consistent with the transient
														// list of caches.
	
	public static final String defaultConfigurationDirectoryName = "/vix";
	public static final String cacheConfigurationSubdirectoryName = "cache-config";
	
	private Cache activeCache;		// used in interactive management, not used in normal operation
	
	/**
	 * This class is a singleton because the cache instances may be shared across multiple web apps 
	 * but each cache must behave with synchronicity with respect to its name as the primary key.
	 *   
	 * @return
	 * @throws MBeanException
	 * @throws CacheException 
	 */
	public static synchronized CacheManagerImpl getSingleton() 
	throws MBeanException, CacheException
	{
		return (singleton = singleton != null ? singleton : new CacheManagerImpl());
	}

	/**
	 * @throws MBeanException 
	 * @throws CacheInitializationException 
	 * 
	 *
	 */
	private CacheManagerImpl() 
	throws CacheException, MBeanException 
	{
		knownCaches = new KnownCacheList(getConfigurationDirectory());
		
		// register ourselves as an MBean
		registerCacheManagerMBean();
		
		// register the known caches so that they are manageable
		for(Cache cache : knownCaches)
			registerCacheMBeans(cache);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.ICacheManager#getKnownCaches()
	 */
	@Override
	public KnownCacheList getKnownCaches()
	{
		return this.knownCaches;
	}
	
	public Cache getActiveCache()
	{
		return this.activeCache;
	}
	
	public void setActiveCache(Cache activeCache)
	{
		this.activeCache = activeCache;
	}

	/**
	 * Returns true if this instance has received a server start event and has not 
	 * received a server stop event.
	 * @return
	 */
	@Override
	public boolean isServerRunning()
	{
		return serverRunningStatus.isServerRunning();
	}

	public Cache createCache(String name, URI locationUri) 
	throws MBeanException, CacheException, URISyntaxException, IOException
	{
		return createCache(name, locationUri, (String)null);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.ICacheManager#createCache(java.lang.String, java.net.URI, java.lang.String)
	 */
	@Override
	public Cache createCache(String name, URI locationUri, String prototypeName) 
	throws MBeanException, CacheException, URISyntaxException, IOException
	{
		Cache cache = getKnownCaches().create(name, locationUri, prototypeName);
		
		// register the newly created cache so that it is manageable
		registerCacheMBeans(cache);
		
		return cache;
	}

	public Cache createCache(String name, URI locationUri, InputStream prototype) 
	throws MBeanException, CacheException, URISyntaxException, IOException
	{
		Cache cache = getKnownCaches().create(name, locationUri, prototype);
		
		// register the newly created cache so that it is manageable
		registerCacheMBeans(cache);
		
		return cache;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.ICacheManager#getCache(java.lang.String)
	 */
	@Override
	public Cache getCache(String cacheName) 
	throws FileNotFoundException, IOException, MBeanException, CacheException
	{
		return knownCaches.get(cacheName);
	}
	
	// ============================================================================================	
	// Basic Cache management methods made available here so that tests can get a running cache
	// ============================================================================================
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.filesystem.CacheManager#initialize()
	 */
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.ICacheManager#initialize(gov.va.med.imaging.storage.cache.Cache)
	 */
	@Override
	public String initialize(Cache cache)
	{
		try
		{
			if(! cache.isInitialized())
			{
				cache.setInitialized(Boolean.TRUE);
				if(serverRunningStatus.isServerRunning())
					cache.cacheLifecycleEvent(CacheLifecycleEvent.START);
			}
			else
				return "Cache was already initialized";
		} 
		catch (CacheException cX)
		{
            LOGGER.warn("CacheManagerImpl.initialize() --> Could NOT initialize cache [{}]: {}", cache.getName(), cX.getMessage());
			return cX.getMessage();
		}
		return "Cache Initialized";
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.filesystem.CacheManager#enable()
	 */
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.ICacheManager#enable(gov.va.med.imaging.storage.cache.Cache)
	 */
	@Override
	public String enable(Cache cache)
	{
		try
		{
			cache.setEnabled(Boolean.TRUE);
		} 
		catch (CacheException cX)
		{
            LOGGER.warn("CacheManagerImpl.enable() --> Could NOT enable cache [{}]: {}", cache.getName(), cX.getMessage());
			return cX.getMessage();
		}
		return "Cache enabled";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.filesystem.CacheManager#disable()
	 */
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.ICacheManager#disable(gov.va.med.imaging.storage.cache.Cache)
	 */
	@Override
	public String disable(Cache cache)
	{
		try
		{
			cache.setEnabled(Boolean.FALSE);
		} 
		catch (CacheException cX)
		{
            LOGGER.warn("CacheManagerImpl.disable() --> Could NOT disable cache [{}]: {}", cache.getName(), cX.getMessage());
			return cX.getMessage();
		}
		return "Cache disabled";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.ICacheManager#store(gov.va.med.imaging.storage.cache.Cache)
	 */
	@Override
	public void store(Cache cache) 
	throws IOException
	{
		try
		{
			getKnownCaches().store(cache);
		}
		catch(IOException iox)
		{
            LOGGER.warn("CacheManagerImpl.store() --> Could NOT store cache [{}]: {}", cache.getName(), iox.getMessage());
			throw iox;
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.ICacheManager#storeAll()
	 */
	@Override
	public void storeAll() 
	throws IOException
	{
		try
		{
			getKnownCaches().storeAll();
		}
		catch(IOException iox)
		{
            LOGGER.warn("CacheManagerImpl.storeAll() --> Could NOT store all caches: {}", iox.getMessage());
			throw iox;
		}
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.ICacheManager#delete(gov.va.med.imaging.storage.cache.Cache)
	 */
	@Override
	public void delete(Cache cache)
	{
		// disable the cache to stop new requests
		disable(cache);
		unregisterCacheMBeans(cache);
		
		String cacheName = cache.getName();
		cache = null;		// drop the reference
		getKnownCaches().remove(cacheName);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.ICacheManager#createEvictionStrategy(gov.va.med.imaging.storage.cache.Cache, gov.va.med.imaging.storage.cache.memento.EvictionStrategyMemento)
	 */
	@Override
	public EvictionStrategy createEvictionStrategy(Cache cache, EvictionStrategyMemento memento)
	throws CacheException
	{
		if( getKnownCaches().isKnownCache(cache) )
		{
			EvictionStrategyFactory factory = EvictionStrategyFactory.getSingleton();
			EvictionTimer timer = cache.getEvictionTimer();
			EvictionStrategy strategy = factory.createEvictionStrategy(memento, timer);
			
			if(strategy != null)
				cache.addEvictionStrategy(strategy);
			
			try
			{
				registerEvictionStrategyMBean(cache, strategy);
			} 
			catch (Exception e)
			{
                LOGGER.warn("CacheManagerImpl.createEvictionStrategy() --> Could NOT create an eviction strategy for cache [{}]: {}", cache.getName(), e.getMessage());
			}
			
			return strategy;
		}
		
		return null;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.ICacheManager#createRegion(gov.va.med.imaging.storage.cache.Cache, java.lang.String, java.lang.String[])
	 */
	@Override
	public Region createRegion(Cache cache, String regionName, String[] evictionStrategyNames)
	throws CacheException
	{
		if(getKnownCaches().isKnownCache(cache) )
		{
			Region region = cache.createRegion(regionName, evictionStrategyNames);
			
			cache.addRegion(region);
			
			try
			{
				registerRegionMBean(cache, region);
			} 
			catch (Exception e)
			{
                LOGGER.warn("CacheManagerImpl.createRegion() --> Could NOT create a region for name [{}]: {}", regionName, e.getMessage());
			}
			
			return region;
		}
		
		return null;
	}
	
	// ========================================================================================================================
	// 
	// ========================================================================================================================
	
	private final static String cacheManagerMBeanObjectName = "VistaImaging.ViX:type=CacheManagerImpl,name=CacheManagerImpl";
	private final static String cacheMBeanObjectNamePrefix = "VistaImaging.ViX:type=Cache,name=";
	private final static String byteChannelMBeanObjectNamePrefix = "VistaImaging.ViX:type=CacheByteChannelFactory,name=";
	private final static String evictionStrategyMBeanObjectNamePrefix = "VistaImaging.ViX:type=CacheEvictionStrategy,name=";
	private final static String regionMBeanObjectNamePrefix = "VistaImaging.ViX:type=CacheRegion,name=";
	
	private String createCacheMBeanObjectName(Cache cache)
	{return cacheMBeanObjectNamePrefix + cache.getName(); }
	
	private String createByteChannelMBeanObjectName(Cache cache)
	{return byteChannelMBeanObjectNamePrefix + cache.getName(); }
	
	private String createRegionMBeanObjectName(Cache cache, Region region)
	{return regionMBeanObjectNamePrefix + cache.getName() + "." + region.getName(); }
	
	private String createEvictionStrategyMBeanObjectName(Cache cache, EvictionStrategy evictionStrategy)
	{return evictionStrategyMBeanObjectNamePrefix + cache.getName() + "." + evictionStrategy.getName(); }
	
	/**
	 * Register the cache manager
	 * 
	 * @param cacheName
	 */
	public void registerCacheManagerMBean()
	{
		MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();
		if(mbs != null)
		{
			try
			{
				mbs.registerMBean(this, new ObjectName(cacheManagerMBeanObjectName));
			} 
			catch (InstanceAlreadyExistsException iaeX)
			{
				LOGGER.warn("CacheManagerImpl.registerCacheManagerMBean() --> MBean instance [" + cacheManagerMBeanObjectName + "] already existed/registered.  Ignored.");
			}
			catch (Exception e)
			{
                LOGGER.warn("CacheManagerImpl.registerCacheManagerMBean() --> Unable to register Cache with JMX: {}", e.getMessage());
			}
		}
	}
	
	private void registerCacheMBeans(Cache cache)
	{
		MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();
		
		if(mbs != null)
		{
			try
			{
				if( cache instanceof DynamicMBean)
				{
					String cacheMBeanName = createCacheMBeanObjectName(cache);
					
					try
					{
						mbs.registerMBean(cache, new ObjectName(cacheMBeanName));
					}
					catch(InstanceAlreadyExistsException iaeX)
					{
                        LOGGER.warn("CacheManagerImpl.registerCacheMBeans() --> MBean instance [{}] already existed/registered.  Ignored.", cacheMBeanName);
					}
				}

                LOGGER.debug("Registering {} eviction strategies for cache '{}'.", cache.getEvictionStrategies().size(), cache.getName());
				for(EvictionStrategy evictionStrategy: cache.getEvictionStrategies())
					registerEvictionStrategyMBean(cache, evictionStrategy);


                LOGGER.debug("Registering {} regions for cache '{}'.", cache.getRegions().size(), cache.getName());
				for(Region region : cache.getRegions())
					registerRegionMBean(cache, region);
		
				if( cache.getInstanceByteChannelFactory() instanceof DynamicMBean)
				{
					String byteChannelMBeanName = createByteChannelMBeanObjectName(cache);
					
					try
					{
						mbs.registerMBean(cache.getInstanceByteChannelFactory(), new ObjectName(byteChannelMBeanName));
					} 
					catch (InstanceAlreadyExistsException iaeX)
					{
                        LOGGER.warn("CacheManagerImpl.registerCacheMBeans() --> MBean instance [{}] already existed/registered.  Ignored.", byteChannelMBeanName);
					}
						
				}
			}
			catch (Exception e)
			{
                LOGGER.warn("CacheManagerImpl.registerCacheMBeans() --> Unable to register Cache with JMX: {}", e.getMessage());
			}
		}
	}
	
	private void registerEvictionStrategyMBean(Cache cache, EvictionStrategy evictionStrategy) 
	throws InstanceAlreadyExistsException, MBeanRegistrationException, NotCompliantMBeanException, MalformedObjectNameException, NullPointerException
	{
		MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();
		
		if(mbs != null)
		{
			
			String evictionStrategyObjectName = createEvictionStrategyMBeanObjectName(cache, evictionStrategy);
			try
			{
				mbs.registerMBean( evictionStrategy, new ObjectName(evictionStrategyObjectName) );
			} 
			catch (InstanceAlreadyExistsException iaeX)
			{
                LOGGER.warn("CacheManagerImpl.registerEvictionStrategyMBean() --> MBean instance [{}] already existed/registered.  Ignored.", evictionStrategyObjectName);
			}
		}
	}
	
	private void registerRegionMBean(Cache cache, Region region) 
	throws InstanceAlreadyExistsException, MBeanRegistrationException, NotCompliantMBeanException, MalformedObjectNameException, NullPointerException
	{
		MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();
		
		if( mbs != null )
		{
			String regionObjectName = createRegionMBeanObjectName(cache, region);
			
			try
			{
				mbs.registerMBean( region, new ObjectName(regionObjectName) );
			} 
			catch (InstanceAlreadyExistsException iaeX)
			{
                LOGGER.warn("CacheManagerImpl.registerEvictionStrategyMBean() --> MBean instance [{}] already existed/registered.  Ignored.", regionObjectName);
			}
		}
	}
	
	private void unregisterCacheMBeans(Cache cache)
	{
		MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();
		
		if(mbs != null)
		{
			try
			{
				if( cache instanceof DynamicMBean)
				{
					String cacheMBeanName = createCacheMBeanObjectName(cache);
					
					try 
					{
						mbs.unregisterMBean(new ObjectName(cacheMBeanName));
					}
					catch(InstanceNotFoundException infX)
					{
						// if the MBean is not registered then don't worry 'bout it
                        LOGGER.warn("CacheManagerImpl.unregisterCacheMBeans() --> MBean instance [{}] was not found. Ignored.", cacheMBeanName);
					}		
				}
				
				for(EvictionStrategy evictionStrategy : cache.getEvictionStrategies())
					try
					{
						unregisterEvictionStrategyMBean(cache, evictionStrategy);
					}
					catch(InstanceNotFoundException infX)
					{
						// if the MBean is not registered then don't worry 'bout it
                        LOGGER.warn("CacheManagerImpl.unregisterCacheMBeans() --> MBean instance [{}] was not found. Ignored.", evictionStrategy.getName());
					}		
		
				for(Region region : cache.getRegions())
					try
					{
						unregisterRegionMBean(cache, region);
					}
					catch(InstanceNotFoundException infX)
					{
						// if the MBean is not registered then don't worry 'bout it
                        LOGGER.warn("CacheManagerImpl.unregisterCacheMBeans() --> MBean instance [{}] was not found. Ignored.", region.getName());
					}
		
				if( cache.getInstanceByteChannelFactory() instanceof DynamicMBean)
				{
					String byteChannelObjectName = createByteChannelMBeanObjectName(cache);
					
					try
					{
						mbs.unregisterMBean(new ObjectName(byteChannelObjectName));
					}
					catch(InstanceNotFoundException infX)
					{
						// if the MBean is not registered then don't worry 'bout it
                        LOGGER.warn("CacheManagerImpl.unregisterCacheMBeans() --> MBean instance [{}] was not found. Ignored.", byteChannelObjectName);
					}
				}
			}
			catch (Exception x)
			{
				LOGGER.warn("CacheManagerImpl.unregisterCacheMBeans() --> Unable to unregister Cache with JMX, management and monitoring for new instances may not be available", x);
			}
		}
	}
	
	private void unregisterEvictionStrategyMBean(Cache cache, EvictionStrategy evictionStrategy) 
	throws InstanceAlreadyExistsException, MBeanRegistrationException, NotCompliantMBeanException, MalformedObjectNameException, NullPointerException, InstanceNotFoundException
	{
		MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();
		
		if(mbs != null && evictionStrategy instanceof DynamicMBean)
		{
			String evictionStrategyObjectName = createEvictionStrategyMBeanObjectName(cache, evictionStrategy);
            LOGGER.debug("CacheManagerImpl.unregisterEvictionStrategyMBean() --> Unregistering eviction strategy [{}]", evictionStrategyObjectName);
			
			mbs.unregisterMBean( new ObjectName(evictionStrategyObjectName) );
		}
	}
	
	private void unregisterRegionMBean(Cache cache, Region region) 
	throws InstanceAlreadyExistsException, MBeanRegistrationException, NotCompliantMBeanException, MalformedObjectNameException, NullPointerException, InstanceNotFoundException
	{
		MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();
		
		if( mbs != null && region instanceof DynamicMBean)
		{
			String regionObjectName = createRegionMBeanObjectName(cache, region);
            LOGGER.debug("CacheManagerImpl.unregisterRegionMBean() --> Unregistering region [{}]", regionObjectName);
			
			mbs.unregisterMBean( new ObjectName(regionObjectName) );
		}
	}
	
	// ============================================================================================	
	// CacheLifecycleListener Implementation
	// These are messages from the app server, abstracted by a platform specific class
	// to our semantics
	// ============================================================================================
	
	
	/**
     * @see gov.va.med.server.ServerLifecycleListener#serverLifecycleEvent(gov.va.med.server.ServerLifecycleEvent)
     * Translate the server lifecycle messages to the cache lifecycle messages, removing the dependency
     * that the cache even be in a server environment.
     * This replaces the CacheLifecycleEvent handling in V-One.
     */
    @Override
    public void serverLifecycleEvent(ServerLifecycleEvent event)
    {
		boolean previousServerRunning = serverRunningStatus.isServerRunning();
		
		CacheLifecycleEvent cacheLifecycleEvent = null;
		
		if(event.getEventType().equals(ServerLifecycleEvent.EventType.START))
		{
			serverRunningStatus.setServerRunning(true);
			cacheLifecycleEvent = CacheLifecycleEvent.START;
		}
		if(event.getEventType().equals(ServerLifecycleEvent.EventType.STOP))
		{
			serverRunningStatus.setServerRunning(false);
			cacheLifecycleEvent = CacheLifecycleEvent.STOP;
		}
		
		// if this represents an actual server running state change then pass
		// it on to the cache instances
		if(previousServerRunning != serverRunningStatus.isServerRunning())
		{
			for( Cache cache : getKnownCaches() )
				// if the cache is initialized, pass this on to the cache
				if(cache.isInitialized())
				{
					try
					{
						cache.cacheLifecycleEvent(cacheLifecycleEvent);
					} 
					catch (CacheStateException x)
					{
                        LOGGER.warn("CacheManagerImpl.serverLifecycleEvent() --> Encountered problem(s) for cache name [{}]: {}", cache.getName(), x.getMessage());
					}
				}
		}
    }

	// ============================================================================================	
	// DynamicMBean Implementation
	// ============================================================================================
	@Override
	public MBeanInfo getMBeanInfo() 
	{
		try
		{
			// the MBeanInfo must be regenerated because the state of some operations may change
			return createMBeanInfo();
		} 
		catch (OpenDataException x)
		{
            LOGGER.warn("CacheManagerImpl.getMBeanInfo() --> Encountered problem while trying to create bean info: {}", x.getMessage());
			return null;
		}
	}
	
	private OpenMBeanInfoSupport createMBeanInfo() 
	throws OpenDataException
	{
     	return new OpenMBeanInfoSupport(
     			FileSystemCache.class.getName(), 
     			"Cache Management (initializing, enabling, storing)", 
     			createMBeanAttributeInfo(), 
     			createMBeanConstructorInfo(), 
	 			createMBeanOperationInfo(), 
	 			createMBeanNotificationInfo()
	 		);
	}

	/**
	 * 
	 * @param cache
	 * @throws OpenDataException 
	 */
	private OpenMBeanAttributeInfo[] createMBeanAttributeInfo() 
	throws OpenDataException
	{
		List<OpenMBeanAttributeInfo> attributes = new ArrayList<OpenMBeanAttributeInfo>();

		attributes.add(
			new OpenMBeanAttributeInfoSupport("knownCacheNames", "A comma seperated list of known cache names", SimpleType.STRING, true, false, false)
		);
		
		return attributes.toArray(new OpenMBeanAttributeInfo[attributes.size()]);
	}

	private OpenMBeanConstructorInfo[] createMBeanConstructorInfo()
	{
     	return new OpenMBeanConstructorInfoSupport[]
     	{
     			
     	};
	}
	
	private MBeanNotificationInfo[] createMBeanNotificationInfo()
	{
		return new MBeanNotificationInfo[]
		{
				
		};
	}

	private final static String initializePrefix = "initialize-";
	private final static String enablePrefix = "enable-";
	private final static String disablePrefix = "disable-";
	private final static String storeOperation = "store";
	private final static String storeAllOperation = "storeAll";
	private final static String createOperation = "createCache";
	
	/**
	 * The operations are pulled from the core cache and the member regions.
	 * @param cache 
	 *
	 */
	private OpenMBeanOperationInfo[] createMBeanOperationInfo()
	{
		List<OpenMBeanOperationInfo> operations = new ArrayList<OpenMBeanOperationInfo>();
		
		for(Cache cache : getKnownCaches())
		{
			if(cache != null && !cache.isInitialized())
				operations.add(
		     		new OpenMBeanOperationInfoSupport(initializePrefix + cache.getName(), 
		     				"Initialize the cache (root directory must be set first) \n" +
		     				"This action is ignored if the cache is initialized.\n" + 
		     				"If the cache has been started with a valid configuration state available \n" +
		     				"it will start in an initialized state.  Changes to configuration will then require a restart of the server.", 
		     				new OpenMBeanParameterInfo[]{}, 
		     				SimpleType.VOID, MBeanOperationInfo.ACTION)
		     	);
	
			if(cache != null && cache.isInitialized() && !cache.isEnabled() )
				operations.add(
		     		new OpenMBeanOperationInfoSupport(enablePrefix + cache.getName(), 
		     				"Enable the cache (cache must be initialized)", 
		     				new OpenMBeanParameterInfo[]{}, 
		     				SimpleType.VOID, MBeanOperationInfo.ACTION)
		     	);
			
			else if(cache != null && cache.isEnabled())
				operations.add(
		     		new OpenMBeanOperationInfoSupport(disablePrefix + cache.getName(), 
		     				"Disable the cache (cache must be initialized and enabled)", 
		     				new OpenMBeanParameterInfo[]{}, 
		     				SimpleType.VOID, MBeanOperationInfo.ACTION)
		     	);
		}
		
		operations.add(
	     		new OpenMBeanOperationInfoSupport(storeOperation, 
	     				"Store the named cache configuration to persistent storage", 
	     				new OpenMBeanParameterInfo[]{new OpenMBeanParameterInfoSupport("name", "the bname of the cache to save configuration of", SimpleType.STRING)}, 
	     				SimpleType.VOID, MBeanOperationInfo.ACTION)
	     	);
		
		operations.add(
	     		new OpenMBeanOperationInfoSupport(storeAllOperation, 
	     				"Store all current cache configuration to persistent storage", 
	     				new OpenMBeanParameterInfo[]{}, 
	     				SimpleType.VOID, MBeanOperationInfo.ACTION)
	     	);
		
		operations.add(
     		new OpenMBeanOperationInfoSupport(createOperation, 
     				"Create a new cache at the specified location.", 
 				new OpenMBeanParameterInfo[]
 				{
 					new OpenMBeanParameterInfoSupport("cacheName", "The name of the cache (and the root of the configuration file name)", SimpleType.STRING),
 					new OpenMBeanParameterInfoSupport("cacheLocation", "The URI of the cache location (e.g. 'file:///vix/cache' or 'smb://server/cacheroot')", SimpleType.STRING),
 					new OpenMBeanParameterInfoSupport("prototypeName", "The name of the prototype or blank(e.g. 'VixPrototype', 'TestWithEvictionPrototype')", SimpleType.STRING)
 				}, 
 				SimpleType.STRING, 
 				MBeanOperationInfo.ACTION)
     	);
		
		return operations.toArray(new OpenMBeanOperationInfoSupport[operations.size()]);
	}

	@Override
	public Object getAttribute(String attribute) 
	throws AttributeNotFoundException, MBeanException, ReflectionException
	{
		if("knownCacheNames".equals(attribute))
		{
			StringBuilder sb = new StringBuilder();
			for(Cache cache : getKnownCaches())
			{
				if(sb.length() > 0)
					sb.append(",");
				sb.append(cache.getName());
			}
			
			return sb.toString();
		}
		else
			return super.getAttribute(attribute);
	}

	@Override
	public void setAttribute(Attribute attribute) 
	throws AttributeNotFoundException, InvalidAttributeValueException, MBeanException, ReflectionException
	{
		super.setAttribute(attribute);
	}

	@Override
	public Object invoke(String actionName, Object[] params, String[] signature) 
	throws MBeanException, ReflectionException
	{
		
		if(actionName.startsWith(initializePrefix))
		{
			String cacheName = actionName.substring(initializePrefix.length());
            LOGGER.info("CacheManagerImpl.invoke() --> Processing request to initialize cache [{}]", cacheName);
			return initialize(getKnownCaches().get(cacheName));
		}
		else if(actionName.startsWith(enablePrefix))
		{
			String cacheName = actionName.substring(initializePrefix.length());
            LOGGER.info("CacheManagerImpl.invoke() --> Processing request to to enable cache [{}]", cacheName);
			return enable(getKnownCaches().get(cacheName));
		}
		else if(actionName.startsWith(disablePrefix))
		{
			String cacheName = actionName.substring(initializePrefix.length());
            LOGGER.info("CacheManagerImpl.invoke() --> Processing request to disable cache [{}]", cacheName);
			return disable(getKnownCaches().get(cacheName));
		}
		else if(storeOperation.equals(actionName))
		{
			String cacheName = (String) params[0];
			try
			{
				Cache cache = getCache(cacheName);
                LOGGER.info("CacheManagerImpl.invoke() --> Processing request to store configuration of [{}]", cacheName);
				store(cache);
			}
			catch (Exception e)
			{
                LOGGER.error("CacheManagerImpl.invoke() --> Error storing configuration of [{}]: {}", cacheName, e.getMessage());
				throw new MBeanException(e);
			}
			return "Cache configuration stored.";
		}
		else if(storeAllOperation.equals(actionName))
		{
			try
			{
				LOGGER.info("CacheManagerImpl.invoke() --> Processing request to to store configuration of all known caches");
				storeAll();
			}
			catch (Exception e)
			{
                LOGGER.error("CacheManagerImpl.invoke() -->  Error storing all configurations to persistent storage: {}", e.getMessage());
				throw new MBeanException(e);
			}
			return "All cache configurations stored.";
		}
		else if(createOperation.equals(actionName) && 
				signature.length == 3 && 
				params[0] instanceof String && 
				params[1] instanceof String && 
				params[2] instanceof String )
		{
			String cacheName = (String) params[0];
			String cacheLocation = (String) params[1];
			String prototypeName = (String) params[2];
			
			String msgSuffix = " [" + cacheName + "] at [" + cacheLocation + "] as [" + prototypeName + "]" ;
			try
			{
                LOGGER.info("CacheManagerImpl.invoke() --> Processing request to create cache{}", msgSuffix);
				getKnownCaches().create(cacheName, new URI(cacheLocation), prototypeName);
			} 
			catch (Exception x)
			{
                LOGGER.error("CacheManagerImpl.invoke() --> Could not create cache{}", msgSuffix);
				throw new MBeanException(x);
			}
			return "Cache created" + msgSuffix;
		}
		
		return super.invoke(actionName, params, signature);
	}

	// ==================================================================================================================================
	
	/**
	 * Return a reference to the configuration directory, creating
	 * directories as necessary to assure it exists before returning.
	 */
	private File getConfigurationDirectory() throws CacheException
	{
		String rootConfigDirName = System.getenv("vixconfig");
		if(rootConfigDirName == null)
			rootConfigDirName = defaultConfigurationDirectoryName;

		try {
			File rootConfigDir = FileUtilities.getFile(rootConfigDirName);

			if (!rootConfigDir.exists())
				rootConfigDir.mkdirs();

			// the cache configuration is in a subdirectory of the configuration directory
			File cacheConfigDir = FileUtilities.getFile(rootConfigDir, cacheConfigurationSubdirectoryName);
			if (!cacheConfigDir.exists())
				cacheConfigDir.mkdirs();

			return cacheConfigDir;
		} catch (IOException e) {
            LOGGER.error("CacheManagerImpl.getConfigurationDirectory() --> Could not get files for cache configuration directory: {}", e.getMessage());
			throw new InitializationException("CacheManagerImpl.getConfigurationDirectory() --> Could not get files for cache configuration directory", e);
		}
		

	}

	// ===================================================================================================
	// interface CacheStructureChangeListener realization
	// ===================================================================================================
	@Override
	public void cacheStructureChanged(Cache cache)
	{
		unregisterCacheMBeans(cache);
		registerCacheMBeans(cache);
	}
	
	@Override
	public void evictionStrategyAdded(Cache cache, EvictionStrategy newEvictionStrategy)
	{
		try
		{
			registerEvictionStrategyMBean(cache, newEvictionStrategy);
		} 
		catch (Exception e)
		{
            LOGGER.warn("CacheManagerImpl.evictionStrategyAdded() --> Unable to register/add cache [{}]: {}", cache.getName(), e.getMessage());
		}
	}

	@Override
	public void evictionStrategyRemoved(Cache cache, EvictionStrategy oldEvictionStrategy)
	{
		try
		{
			unregisterEvictionStrategyMBean(cache, oldEvictionStrategy);
		} 
		catch (Exception e)
		{
            LOGGER.warn("CacheManagerImpl.evictionStrategyRemoved() --> Unable to remove cache [{}]: {}", cache.getName(), e.getMessage());
		}
	}

	@Override
	public void regionAdded(Cache cache, Region newRegion)
	{
		try
		{
			registerRegionMBean(cache, newRegion);
		} 
		catch (Exception e)
		{
            LOGGER.warn("CacheManagerImpl.regionAdded() --> Unable to register/add region [{}]: {}", newRegion.getName(), e.getMessage());
		}
	}

	@Override
	public void regionRemoved(Cache cache, Region oldRegion)
	{
		try
		{
			unregisterRegionMBean(cache, oldRegion);
		} 
		catch (Exception e)
		{
            LOGGER.warn("CacheManagerImpl.regionRemoved() --> Unable to remove region [{}]: {}", oldRegion.getName(), e.getMessage());
		}
	}

	@Override
	public Reference getReference() 
	throws NamingException
	{
		return new Reference(this.getClass().getName(), CacheResourceReferenceFactory.class.getName(), null);
	}
}
