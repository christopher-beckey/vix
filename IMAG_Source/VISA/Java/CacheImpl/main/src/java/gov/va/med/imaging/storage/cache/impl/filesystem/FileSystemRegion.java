package gov.va.med.imaging.storage.cache.impl.filesystem;

import gov.va.med.imaging.storage.cache.Group;
import gov.va.med.imaging.storage.cache.exceptions.*;
import gov.va.med.imaging.storage.cache.impl.PersistentGroupSet;
import gov.va.med.imaging.storage.cache.impl.PersistentRegion;
import gov.va.med.imaging.storage.cache.impl.memento.PersistentRegionMemento;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Iterator;

import gov.va.med.logging.Logger;

/**
 * The File System based implementation of a cache region.
 * 
 */
public class FileSystemRegion
extends PersistentRegion
implements FileSystemRegionMBean
{
	private static final Logger LOGGER = Logger.getLogger(FileSystemRegion.class);
	
	private File regionDirectory;
	private FileSystemGroupSet childGroups;

	// ======================================================================================================
	// Factory Methods
	// ======================================================================================================
	
	/**
	 * Create a FileSystemCacheRegion, restoring the state from a memento (as much as possible)
	 * 
	 * @param memento
	 * @param instanceFactoryChannel
	 * @param evictionStrategy
	 * @return
	 * @throws CacheInitializationException 
	 */
	public static FileSystemRegion create(
		FileSystemCache parentCache,
		PersistentRegionMemento memento) 
	throws RegionInitializationException
	{
		return create(
			parentCache, 
			memento.getName(),
			memento.getEvictionStrategyNames(),
			memento.getSecondsReadWaitsForWriteCompletion(), 
			memento.isSetModificationTimeOnRead());
	}
	
	/**
	 * Create a FileSysytemRegion instance
	 * 
	 * @param cacheRootDirectory
	 * @param name
	 * @param instanceFactoryChannel
	 * @param evictionStrategy
	 * @param secondsReadWaitsForWriteCompletion
	 * @param setModificationTimeOnRead
	 * @return
	 */
	public static FileSystemRegion create(
		FileSystemCache parentCache,
		String name,
		String[] evictionStrategyNames, 
		int secondsReadWaitsForWriteCompletion, 
		boolean setModificationTimeOnRead )
	throws RegionInitializationException
	{
		try
		{
			return new FileSystemRegion(
					parentCache, 
					name, 
					evictionStrategyNames, 
					secondsReadWaitsForWriteCompletion, 
					setModificationTimeOnRead);
		} 
		catch (CacheException x)
		{
			Logger.getLogger(FileSystemRegion.class).error(x);
			throw new RegionInitializationException(x);
		}
	}

	// ======================================================================================================
	// Constructors
	// ======================================================================================================
	
	/**
	 * 
	 * @param cacheRootDirectory
	 * @param name
	 * @param instanceFactoryChannel
	 * @param evictionStrategy
	 * @param secondsReadWaitsForWriteCompletion
	 * @param setModificationTimeOnRead
	 * @throws CacheException
	 */
	private FileSystemRegion(
			FileSystemCache parentCache,
			String name, 
			String[] evictionStrategyNames, 
			int secondsReadWaitsForWriteCompletion, 
			boolean setModificationTimeOnRead) 
	throws CacheException
	{
		super(parentCache, name, evictionStrategyNames, secondsReadWaitsForWriteCompletion, setModificationTimeOnRead);
	}
	
	/**
	 * A type-converted accessor of the parent cache
	 * @return
	 */
	private FileSystemCache getParentFileSystemCache()
	{
		return (FileSystemCache)getParentCache();
	}

	// ======================================================================================================
	// Core Accessors
	// ======================================================================================================
	
	/**
	 * The cacheRootDirectory must be set before
	 * the Region is initialized, else an exception will be thrown
	 * @throws CacheStateException 
	 */
	public File getCacheRootDirectory() 
	throws CacheStateException
	{
		return getParentFileSystemCache().getRoDir();
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.filesystem.FileSystemRegionMBean#getRegionDirectory()
	 */
	@Override
	public File getRegionDirectory()
	throws RegionNotInitializedException
	{
		if(! isInitialized())
			throw new RegionNotInitializedException("FileSystemRegion.getRegionDirectory --> Region directory is not set until initialization is complete");
		return regionDirectory;
	}
	
	/**
	 * @see gov.va.med.imaging.storage.cache.impl.filesystem.FileSystemRegionMBean#getFreeSpace()
	 */
	@Override
	public long getFreeSpace()
	{
		return getDiskStatistic("getFreeSpace");
	}
	
	/**
	 * @see gov.va.med.imaging.storage.cache.Region#getTotalSpace()
	 */
	@Override
	public long getTotalSpace()
	{
		return getDiskStatistic("getTotalSpace");
	}
	
	private long getDiskStatistic(String methodName)
	{
		try
		{
			File regionDirectory = getRegionDirectory();

			// Do the method call using reflection so that this will still compile under
			// JDK 1.5.
			//return regionDirectory.getFreeSpace();
			Method freeSpaceGetter = regionDirectory.getClass().getMethod(methodName, (Class[])null);
			Long freeSpace = (Long)freeSpaceGetter.invoke(regionDirectory, (Object[])null);
			return freeSpace.longValue();
		} 
		catch (RegionNotInitializedException x)
		{
            LOGGER.warn("FileSystemRegion.getDiskStatistic() -->  Attempt to call [{}] before region has been initialized: {}", methodName, x.getMessage());
		} 
		catch (SecurityException x)
		{
            LOGGER.warn("FileSystemRegion.getDiskStatistic() -->  Encountered security exception while attempting to call [{}]", methodName);
		} 
		catch (NoSuchMethodException x)
		{
            LOGGER.warn("FileSystemRegion.getDiskStatistic() -->  Encountered no such method exception while attempting to call [{}]", methodName);
		} 
		catch (IllegalArgumentException x)
		{
            LOGGER.warn("FileSystemRegion.getDiskStatistic() -->  Encountered illegal argument exception while attempting to call [{}]", methodName);
		} 
		catch (IllegalAccessException x)
		{
            LOGGER.warn("FileSystemRegion.getDiskStatistic() -->  Encountered illegal access exception while attempting to call [{}]", methodName);
		} 
		catch (InvocationTargetException x)
		{
            LOGGER.warn("FileSystemRegion.getDiskStatistic() -->  Encountered invocation target exception while attempting to call [{}]", methodName);
		}
		
		return -1L;
	}

	@Override
	protected PersistentGroupSet getPersistentGroupSet() 
	throws RegionNotInitializedException
	{
		if(! isInitialized().booleanValue())
			throw new RegionNotInitializedException("FileSystemRegion.getPersistentGroupSet() -->  Region Directory is not set until initialization is complete");
		return childGroups;
	}
	
	/**
	 * Regions cannot be removed, so throw an error if someone tries.
	 */
	@Override
	public void delete(boolean forceDelete) 
	throws CacheException
	{
		throw new CacheInternalException("FileSystemRegion.getPersistentGroupSet() -->  Illegal attempt to remove a Region.");
	}

	/**
	 * 
	 */
	@Override
	public void initialize() 
	throws RegionInitializationException
	{
        LOGGER.debug("FileSystemRegion.initialize() -->  [{}] initializing...", this.getName());
		
		try
		{
			File cacheRoot = getParentFileSystemCache().getRoDir();
			
			if(cacheRoot == null)
				throw new RegionInitializationException("FileSystemRegion.initialize() -->  Cache root directory must be set before initializing FileSystemCacheRegion instance.");
			
			this.regionDirectory = new File(cacheRoot, this.getName());
			
			if(! regionDirectory.exists())
			{
                LOGGER.debug("FileSystemRegion.initialize() -->  [{}] does not exist.  Creating....", this.getName());
				try
				{
					regionDirectory.mkdirs();
				} 
				catch (RuntimeException rX)
				{
					String msg = "FileSystemRegion.initialize() -->  Group directory [" + regionDirectory.getAbsolutePath() + "] did not exist and could not be created.";
					LOGGER.error(msg);
					throw new RegionInitializationException(msg);
				}
			}
			
			this.childGroups = new FileSystemGroupSet(regionDirectory, getInstanceFactoryChannel(), getSecondsReadWaitsForWriteCompletion(), isSetModificationTimeOnRead());
		} 
		catch (CacheStateException x)
		{
			String msg = "FileSystemRegion.initialize() -->  Could not initialize region [" + getName() + "]: " + x.getMessage();
			LOGGER.error(msg);
			throw new RegionInitializationException(msg);
		}
		
	}

	// ======================================================================================================
	// Child Group Management
	// ======================================================================================================
	/**
	 * 
	 */
	@Override
	public Group getChildGroup(String groupName) 
	throws CacheException
	{
		return childGroups.getChild(groupName, false);
	}

	/**
	 * 
	 */
	@Override
	public Group getOrCreateChildGroup(String groupName) 
	throws CacheException
	{
		return childGroups.getChild(groupName, true);
	}

	/**
	 * Remove a child group.
	 * @throws CacheException 
	 */
	@Override
	public void deleteChildGroup(Group childGroup, boolean forceDelete) 
	throws CacheException
	{
		childGroups.deleteChild(childGroup, forceDelete);
	}


	@Override
	public void deleteAllChildGroups(boolean forceDelete) 
	throws CacheException
	{
		childGroups.deleteAll(forceDelete);
	}

	/**
	 * All subdirectories of ourselves are child groups.
	 * @throws CacheException 
	 */
	@Override
	public Iterator<? extends Group> getGroups() 
	throws CacheException
	{
		return childGroups.hardReferenceIterator();
	}
}
