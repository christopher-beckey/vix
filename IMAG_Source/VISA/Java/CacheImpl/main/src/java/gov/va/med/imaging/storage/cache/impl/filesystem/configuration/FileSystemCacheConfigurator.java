package gov.va.med.imaging.storage.cache.impl.filesystem.configuration;

import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.configuration.EncryptedString;
import gov.va.med.imaging.configuration.EncryptedStringSingleValueConverter;
import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;
import gov.va.med.imaging.storage.cache.impl.filesystem.memento.FileSystemCacheMemento;
import gov.va.med.log4j.encryption.AESConstants;

/**
 * 
 * @author vhaisltjahjb
 *
 */
public class FileSystemCacheConfigurator 
{
	private static final Logger logger = Logger.getLogger(FileSystemCacheConfigurator.class); // Can't uppercase.  Child class?
	
	private static final String CACHE_MEMENTO_CONFIG = "ImagingExchangeCache-cache.xml";
	private static final String defaultNetworkDomain = null;
	private static final String defaultNetworkUserLogin = "admin";
	private static String defaultNetworkUserPassword;
	
	public FileSystemCacheConfigurator()
	{
		super();
		try {
			defaultNetworkUserPassword = AESConstants.getPassword().getShareUserPassword();
		}catch (Exception e) {
			logger.warn("FileSystemCacheConfigurator() --> Could not get default credentials.  Set to null.");
			defaultNetworkUserPassword = null;
		}
	}
	
	private static FileSystemCacheConfigurator configuration = null;
	public synchronized static FileSystemCacheMemento getFileSystemCacheMemento()
	{
		FileSystemCacheMemento memento = null;
		
		if(configuration == null)
		{
			configuration = new FileSystemCacheConfigurator();
			memento = configuration.loadConfiguration();			
		}
		
		return memento;
	}

	public FileSystemCacheMemento loadConfiguration()
	{
		return loadConfigurationFromFile();
	}		
	
	private FileSystemCacheMemento loadConfigurationFromFile()
	{
		File file = new File(getConfigurationFileName());
			
		if(file.exists())
		{
			// Fortify change: added try-with-resources and moved here for more correct logic; added clean string
			try ( FileInputStream in = new FileInputStream(StringUtil.cleanString(file.getAbsolutePath()));
				  XMLDecoder decoder = new XMLDecoder(in) )
			{
				FileSystemCacheMemento configuration = (FileSystemCacheMemento) decoder.readObject();
                logger.info("FileSystemCacheConfigurator.loadConfigurationFromFile() --> Loaded configuration file [{}]", file.getAbsolutePath());
				return configuration;	
			}
			catch(Exception e)
			{
                logger.warn("FileSystemCacheConfigurator.loadConfigurationFromFile() --> Unable to load configuration file [{}]: {}", file.getAbsolutePath(), e.getMessage());
				return null;
			}
		}
		else
		{
            logger.info("FileSystemCacheConfigurator.loadConfigurationFromFile() --> Given configuration file [{}] does not exist.", file.getAbsolutePath());
			return null;
		}
	}

	public synchronized void storeConfiguration(FileSystemCacheMemento fileSystemCacheMemento)
	{
		// Fortify change: moved here to enable try-with-resources
		String filename = getConfigurationFileName();
		
		// Fortify change: added try-with-resources and moved here for more correct logic; added clean string
		try ( FileOutputStream out = new FileOutputStream(StringUtil.cleanString(filename)); 
			  XMLEncoder encoder = new XMLEncoder(out) )
		{
			encoder.writeObject(fileSystemCacheMemento);
            logger.info("FileSystemCacheConfigurator.loadConfigurationFromFile() --> Stored configuration file [{}]", filename);
		}
		catch(IOException ioX)
		{
            logger.warn("FileSystemCacheConfigurator.loadConfigurationFromFile() --> Error storing configuration file [{}]: {}", filename, ioX.getMessage());
		}
	}
	
	/**
	 * Get the configuration directory.
	 * Usually, derived classes do not need to access the directory
	 * and just rely on the storeConfiguration)( and loadConfiguration()
	 * methods.  This method is provided for exceptional cases.
	 */
	private File getConfigurationDirectory()
	{
		String configurationDirectoryName = System.getenv("vixconfig");
		if(configurationDirectoryName == null)
			configurationDirectoryName = System.getProperty("user.home");
		if(configurationDirectoryName == null)
			configurationDirectoryName = "/";
		
		File configurationDirectory = new File(StringUtil.cleanString(configurationDirectoryName));
		if(! configurationDirectory.exists())
			configurationDirectory.mkdirs();		// make the directories if they don't exist
		
		return configurationDirectory;
	}
	
	private String getConfigurationFileName()
	{
		File configurationDirectory = getConfigurationDirectory();	
		return configurationDirectory.getAbsolutePath() + "/cache-config/" + CACHE_MEMENTO_CONFIG;
	}
	
	public static void main(String [] args)
	{
		Logger logger = Logger.getLogger(FileSystemCacheConfigurator.class);

		FileSystemCacheMemento fileSystemCacheMemento = getFileSystemCacheMemento();
		if (fileSystemCacheMemento == null)
		{
			logger.error(CACHE_MEMENTO_CONFIG + " couldn't be decode");
			return;
		}
		
		if((args != null) && (args.length > 0))
		{
			String networkStorageDomain = defaultNetworkDomain;
			String networkStorageUserLogin = defaultNetworkUserLogin;
			String networkStorageUserPassword = defaultNetworkUserPassword;
			
			for(int i = 0; i < args.length; i++)
			{
                logger.debug("{} {}", args[i], args[i + 1]);
				
				if("-netDomain".equals(args[i]))
				{
					++i;
					networkStorageDomain = (args[i].equals("null") ? "" : args[i]);
				}
				else if("-netLogin".equals(args[i]))
				{
					networkStorageUserLogin = args[++i];
				}
				else if("-netPwd".equals(args[i]))
				{
					networkStorageUserPassword = args[++i];
				}
			}
			
			EncryptedStringSingleValueConverter conv = new EncryptedStringSingleValueConverter();
			networkStorageUserPassword = conv.toString(new EncryptedString(networkStorageUserPassword));

			fileSystemCacheMemento.setNetworkStorageDomain(networkStorageDomain);
			fileSystemCacheMemento.setNetworkStorageUserLogin(networkStorageUserLogin);
			fileSystemCacheMemento.setNetworkStorageUserPassword(new EncryptedConfigurationPropertyString(networkStorageUserPassword));
		}
		storeFileSystemCacheMemento(fileSystemCacheMemento);		
	}

	private static void storeFileSystemCacheMemento(FileSystemCacheMemento fileSystemCacheMemento) {
		configuration.storeConfiguration(fileSystemCacheMemento);
	}
}

