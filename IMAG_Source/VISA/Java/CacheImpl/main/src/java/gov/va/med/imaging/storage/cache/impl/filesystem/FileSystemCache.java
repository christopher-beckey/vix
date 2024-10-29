package gov.va.med.imaging.storage.cache.impl.filesystem;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.storage.cache.EvictionStrategy;
import gov.va.med.imaging.storage.cache.EvictionTimer;
import gov.va.med.imaging.storage.cache.InstanceByteChannelFactory;
import gov.va.med.imaging.storage.cache.Region;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
import gov.va.med.imaging.storage.cache.exceptions.CacheInitializationException;
import gov.va.med.imaging.storage.cache.exceptions.CacheStateException;
import gov.va.med.imaging.storage.cache.exceptions.IncompatibleRegionException;
import gov.va.med.imaging.storage.cache.exceptions.InitializationException;
import gov.va.med.imaging.storage.cache.exceptions.RegionInitializationException;
import gov.va.med.imaging.storage.cache.impl.AbstractCacheImpl;
import gov.va.med.imaging.storage.cache.impl.eviction.EvictionStrategyFactory;
import gov.va.med.imaging.storage.cache.impl.filesystem.memento.FileSystemCacheMemento;
import gov.va.med.imaging.storage.cache.impl.memento.PersistentRegionMemento;
import gov.va.med.imaging.storage.cache.memento.CacheMemento;
import gov.va.med.imaging.storage.cache.memento.EvictionStrategyMemento;
import gov.va.med.imaging.storage.cache.memento.RegionMemento;

import java.io.File;
import java.io.FilenameFilter;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.apache.commons.io.FilenameUtils;
import gov.va.med.logging.Logger;


/**
 * The cache in the FileSystemCache is completely file system based. Groups and
 * Regions are implemented as directories, Instances are files. Region, Groups
 * and Instance instances in memory are transient reflections of the file system
 * state. In all cases the file system is the final arbiter of the state of the
 * cache.
 * 
 * Last access time is not universally supported by filesystems, and the Java IO
 * package does not make the access time available. This Cache uses the modified
 * date as the last access date. In general, external calls to the cache will
 * update the modified time while internal calls, used by eviction threads, do
 * not.
 */
public class FileSystemCache 
extends AbstractCacheImpl
{
	private  final static Logger LOGGER = Logger.getLogger(FileSystemCache.class);
	
	public final static String protocol = "file";
	private File roDir;

	/**
	 * 
	 * @param String 				file name to create cache with
	 * @param URI					location URI
	 * @param EvictionTimer			eviction timer
	 * @return FileSystemCache		result
	 * @throws CacheException		required exception
	 * 
	 */
	public static FileSystemCache create(String name, URI locationUri, EvictionTimer evictionTimer)
	throws CacheException
	{	
		return new FileSystemCache(name, locationUri, evictionTimer, FileSystemByteChannelFactory.create());
	}

	/**
	 * Create a cache instance from a Memento, which contains all of its state information.
	 * 
	 * @param CacheMemento			memento to create cache with 
	 * @return FileSystemCache		result
	 * @throws CacheException		required exception
	 * 
	 */
	public static FileSystemCache create(CacheMemento memento) 
	throws CacheException
	{
		return new FileSystemCache(memento);
	}
	
	/**
	 * 
	 * @param CacheMemento			memento to create cache with
	 * @throws CacheException		required exception 
	 */
	public FileSystemCache(CacheMemento memento) 
	throws CacheException
	{
		super(memento);

        LOGGER.debug("FileSystemCache() --> Memento [{}]", memento.toString());
			
		if(memento instanceof FileSystemCacheMemento)
			restoreFromMemento((FileSystemCacheMemento)memento);
	}

	/**
	 * The FileSystemCache will be started in a disabled mode when using this constructor.
	 * The MBean that manages this class may configure an instance of this class after it
	 * has been created.
	 * 
	 * @param String 						file name to create cache with
	 * @param URI							location URI
	 * @param EvictionTimer					default eviction timer
	 * @param InstanceByteChannelFactory	channel factory
	 * @throws CacheInitializationException required exception
	 * 
	 */
	public FileSystemCache(String name, URI locationUri, EvictionTimer defaultTimer, InstanceByteChannelFactory<?> byteChannelFactory) 
	throws CacheInitializationException
	{
		super(name, locationUri, defaultTimer, byteChannelFactory);
	}

	/**
	 * 
	 *  @param URI		location URI
	 *  
	 */
	@Override
	protected String extractPath(URI locationUri)
	{
		// a kludge cause windows uses the colon as the drive letter delimiter
		// which gets interpreted as the authority in URI form.
		//Fortify coding
		if(locationUri == null)
		{
			LOGGER.warn("FileSystemCache.extractpath() --> Given location URI is null. Return null.");
			return null;
		}

		return locationUri.getAuthority() != null ? locationUri.getAuthority() + "/" + locationUri.getPath() : locationUri.getPath();
	}

	/**
	 * Between the time the cache is created and initialized, this contains the root directory name
	 * after initialization, the name should be derived from the rootDirectory.
	 * NOTE: the values may not be .equals() because of the differences in abstract versus
	 * concrete pathnames. 
	 */
	public String getPersistenceRoot()
	{
		if(isInitialized())
			try 
			{
				// Fortify coding
				File localRoDir = getRoDir();
				if(localRoDir == null) {
					LOGGER.error("FileSystemCache.getPersistenceRoot() --> File object is never set.  Return null.");
					return null;
				}

                LOGGER.debug("FileSystemCache.getPersistenceRoot() --> Presistent root [{}]", localRoDir.getAbsolutePath());
				return localRoDir.getAbsolutePath(); 
			} 
			catch (CacheStateException x) { LOGGER.error(x); return null; }		// should never happen
		else
            LOGGER.debug("FileSystemCache.getPersistenceRoot() --> Presistent root [{}]", getLocationPath());
			return getLocationPath();
	}
	
	/**
	 * 
	 * @return File					File object that was set/created
	 * @throws CacheStateException 	required exception
	 * 
	 */
	public File getRoDir() 
	throws CacheStateException
	{
		// Check whether the rootDirectory has been set rather than whether the cache has been initialized
		// because, internally, this method must return the root directory before initialization is complete.
		// Externally, isInitialized() and the existence of a non-null root directory are nearly synonomous.
		if( this.roDir == null )
			throw new CacheStateException("FileSystemCache.getRoDir() --> File system cache must be initialized before the root directory is available.");

		return this.roDir;
	}

	private void setRoDir(File roDir)
	{
		this.roDir = roDir;
	}
	
	
	// ===============================================================================================================
	// Lifecycle and operation management (initialization and enablement) 
	// ===============================================================================================================

	
	/**
	 * 
	 * @throws InitializationException, CacheStateException required exception
	 * 
	 */
	@Override
	protected void internalInitialize() 
	throws InitializationException, CacheStateException
	{
		String rootDirName = getLocationPath();
		
		if (rootDirName == null || rootDirName.length() == 0)
		{
			String msg = "FileSystemCache.internalInitialize() --> Root directory is not set/created.";
			LOGGER.error(msg);
			throw new InitializationException(msg);
		}

        LOGGER.info("FileSystemCache.internalInitialize() --> Location [{}]", rootDirName);
		
		setRoDir(new File(rootDirName));
		
		if (!this.roDir.exists())
		{
            LOGGER.info("FileSystemCache.internalInitialize() --> Root directory [{}] does not exist, creating ...", rootDirName);
			this.roDir.mkdirs();
		}
	}
	
	// ===========================================================================================================
	// Region Management Methods
	// ===========================================================================================================
	
	/**
	 * @param Region						a Region to validate
	 * @throws IncompatibleRegionException 	required exception
	 * 
	 */
	protected void validateRegionType(Region region)
	throws IncompatibleRegionException
	{
		// Fortify coding and for the next "if"
		if(region == null)
		{
			String msg = "FileSystemCache.validateRegionType() --> Given Region object is null.  Can't validate.";
			LOGGER.error(msg);
			throw new IncompatibleRegionException(msg);
		}
		
		if(! (region instanceof FileSystemRegion) )
		{
			String msg = "FileSystemCache.validateRegionType() --> Region [" + region.getName() + "] is an instance of [" + region.getClass().getName() + "] so it is incompatible with FileSystemCache.";
			LOGGER.error(msg);
			throw new IncompatibleRegionException(msg);
		}
	}
	
	/**
	 * Create a Region instance that is compatible with this Cache instance.
	 * Default everything but the region name.
	 * NOTE: this method does not associate the Region instance created to the Cache,
	 * it simply creates the Region
	 * 
	 * @param String 							name to create Region with
	 * @param String [] 						eviction strategy name
	 * @throws RegionInitializationException	required exception
	 * 	
	 */
	@Override
	public FileSystemRegion createRegion(String name, String[] evictionStrategyNames)
	throws RegionInitializationException
	{
		return FileSystemRegion.create(
			this, 
			name, 
			evictionStrategyNames, 
			defaultSecondsReadWaitsForWriteCompletion, 
			defaultSetModificationTimeOnRead
		);
	}

	/**
	 * @param RegionMemento		Region memento
	 * 
	 */
	@Override
	public FileSystemRegion createRegion(RegionMemento regionMemento)
	throws RegionInitializationException
	{
		if(regionMemento instanceof PersistentRegionMemento)
			return FileSystemRegion.create(
				this,
				(PersistentRegionMemento)regionMemento
			);
		
		throw new RegionInitializationException(PersistentRegionMemento.class,  regionMemento.getClass());
	}
	
	// ===========================================================================================
	// Memento (state persistence and loading) Related methods
	// ===========================================================================================
	@Override
	public FileSystemCacheMemento createMemento()
	{
		FileSystemCacheMemento memento = new FileSystemCacheMemento();
		
		memento.setEvictionTimerMemento(defaultEvictionTimer.createMemento());
		
		memento.setName(getName());
		memento.setLocationUri(getLocationUri().toString());
		memento.setEnabled(isEnabled());
		memento.setInitialized(isInitialized());
		
		if(getInstanceByteChannelFactory() instanceof FileSystemByteChannelFactory)
			memento.setByteChannelFactoryMemento(  ((FileSystemByteChannelFactory)getInstanceByteChannelFactory()).createMemento() );
		memento.setEvictionStrategyMementos(createEvictionStrategyMementos());
		memento.setRegionMementos(createRegionMementos());
		
		return memento;
	}
	
	protected List<? extends EvictionStrategyMemento> createEvictionStrategyMementos()
	{
		List<EvictionStrategyMemento> evictionStrategyMementos = new ArrayList<EvictionStrategyMemento>();
		for(EvictionStrategy evictionStrategy:getEvictionStrategies())
			evictionStrategyMementos.add( evictionStrategy.createMemento() );
		
		return evictionStrategyMementos;
	}
	
	protected List<PersistentRegionMemento> createRegionMementos()
	{
		List<PersistentRegionMemento> regionMementos = new ArrayList<PersistentRegionMemento>();
		for(Region region:getRegions())
			regionMementos.add( ((FileSystemRegion)region).createMemento() );
		
		return regionMementos;
	}
	
	/**
	 * The cache must be restored from a memento in the following order:
	 * 0.) the default eviction timer
	 * 1.) root directory name
	 * 2.) instance byte channel
	 * 3.) eviction strategies
	 * 4.) regions (needs instance byte channel and eviction strategies)
	 * 5.) initialized flag
	 * 6.) enabled flag
	 * 7.) the START signal may be acted upon, sending the START is the responsibility of
	 *     the FileSystemCacheManager
	 * 
	 * @param memento
	 * @throws CacheException 
	 */
	private void restoreFromMemento(FileSystemCacheMemento memento) 
	throws CacheException
	{
		// restore the byte channel factory
		setInstanceByteChannelFactory( FileSystemByteChannelFactory.create(memento.getByteChannelFactoryMemento()) );
		
		for( EvictionStrategyMemento evictionStrategyMemento : memento.getEvictionStrategyMementos() )
		{
			EvictionStrategy evictionStrategy = 
				EvictionStrategyFactory.getSingleton().createEvictionStrategy(evictionStrategyMemento, defaultEvictionTimer);
			addEvictionStrategy(evictionStrategy);
		}
		
		for(RegionMemento regionMemento:memento.getRegionMementos())
		{
			if(regionMemento instanceof PersistentRegionMemento)
			{ 
				addRegion(FileSystemRegion.create(this,	(PersistentRegionMemento)regionMemento));
			}
		}
		
		// note that set initialized to true is much more than a simple bit flip
		if(memento.isInitialized())
			setInitialized(true);
		// setting enabled to true is pretty much a simple bit flip
		if(memento.isEnabled())
			setEnabled(true);
	}
	
	/**
	 * @see gov.va.med.imaging.storage.cache.impl.AbstractCacheImpl#isStudyLocationExist()
	 * 
	 * @param String					study Id
	 * @param String					image Id
	 * @param String					patient Id
	 * @param String					study Id
	 * @param String					region name
	 * 
	 */
	@Override
	public Boolean isImageFilesCached(String studyid, String imageid, String siteid, 
						String patientIdentifier, String regionName)
	{

		boolean isImageFilesExist = false;
		String studyId = studyid;
		String locationPath;
		StringBuffer buffer = new StringBuffer();
		
		try 
		{
			// Fortify coding
			File localRoDir = getRoDir();
			if(localRoDir == null)
			{
				LOGGER.warn("FileSystemCache.isImageFilesCached() --> Root directory is null.  Can't check. Return false.");
				return false;
			}
			
			locationPath = getRoDir().getAbsolutePath();
			
		} catch (CacheStateException e) {
            LOGGER.error("FileSystemCache.isImageFilesCached() --> Could not check is Study Location exist. Return false. Cache error: {}", e.getMessage());
			return false;
		}
		
		buffer.append(locationPath);
		buffer.append("\\");
		//buffer.append(getName());
		buffer.append(regionName);
		buffer.append("\\");
		buffer.append(siteid);
		buffer.append("\\");
		buffer.append("icn(");
		buffer.append(patientIdentifier);
		buffer.append(")\\");
		buffer.append(studyId);
		buffer.append("\\");
		
		try{
			// Fortify change: clean and fix path if nec.
			// OLD: folder = new File(buffer.toString());
			File folder = new File(FilenameUtils.normalize(buffer.toString()));
			
		    if(!folder.exists()){
                LOGGER.warn("FileSystemCache.isImageFilesCached() --> Cache Folder [{}] does not exist. Return false.", folder.getAbsolutePath());
		    	return false;
		    };
		    File[] listFiles = folder.listFiles(new MyFileNameFilter(imageid));
		    if(listFiles.length == 0){
		        isImageFilesExist = false;
		    }
		    else{
		    	isImageFilesExist = true;
		    }
		}
		catch(Exception e){
            LOGGER.warn("FileSystemCache.isImageFilesCached() --> Failed to check folder [{}]. Return false.", buffer.toString());
			return false;
		}

        LOGGER.debug("FileSystemCache.isImageFilesCached() --> Cache folder [{}] exists [{}]", buffer.toString(), isImageFilesExist);
		return isImageFilesExist;
	}
	

	private static class MyFileNameFilter implements FilenameFilter
	{
	     
	    private String filename = null;
	     
	    public MyFileNameFilter(String filename)
	    {
	        this.filename = filename.toLowerCase();
	    }
	    
	    @Override
	    public boolean accept(File folder, String name) {
	        return name.toLowerCase(Locale.ENGLISH).startsWith(filename);
	    }
	}

}
