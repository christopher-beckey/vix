/**
 * 
 */
package gov.va.med.imaging.datasource;

import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyStringSingleValueConverter;
import gov.va.med.logging.Logger;

import com.thoughtworks.xstream.XStream;

import gov.va.med.imaging.StringUtil;

/**
 * A class to manage configuration persistence in a standard fashion
 * that supports both XMLEncoder and XStream persistence.  This is largely
 * based upon but should replace the configuration management that is 
 * within the Provider class.
 * 
 * The mode property determines the persistence mechanism to use
 * XMLENCODER - uses the Java XMLEncoder
 * XSTREAM - uses the XStream encoding
 * HYBRID (default) - preferentially reads using XMLENCODER then tries XSTREAM,
 *          always writes using XSTREAM
 * 
 * The HYBRID mode is intended as a bridge until the configuration files are all
 * updated to use XStream persistence, after which usage of the freakish nightmare 
 * that is the XMLEncoder will be mercifully over. 
 * 
 * @author vhaiswbeckec
 *
 */
public class ProviderConfiguration<T>
{
	private final static Logger logger = Logger.getLogger(ProviderConfiguration.class);
	
	private final String providerName;
	private final double providerVersion;
	
	/**
	 * 
	 * @param providerName
	 * @param providerVersion
	 * @param mode
	 */
	public ProviderConfiguration(String providerName, double providerVersion)
	{
		super();
		this.providerName = providerName;
		this.providerVersion = providerVersion;
	}

	public String getProviderName()
	{
		return this.providerName;
	}

	public double getProviderVersion()
	{
		return this.providerVersion;
	}

	/**
	 * Get the configuration directory. Usually, derived classes do not need to
	 * access the directory and just rely on the storeConfiguration)( and
	 * loadConfiguration() methods. This method is provided for exceptional
	 * cases.
	 */
	public File getConfigurationDirectory()
	{
		String configurationDirectoryName = System.getenv("vixconfig");
		if (configurationDirectoryName == null)
			configurationDirectoryName = System.getProperty("user.home");
		if (configurationDirectoryName == null)
			configurationDirectoryName = "/";

		File configurationDirectory = new File(StringUtil.cleanString(configurationDirectoryName));
		if (!configurationDirectory.exists())
			configurationDirectory.mkdirs(); // make the directories if they
												// don't exist
		return configurationDirectory;
	}

	/**
	 * 
	 * @param providerName
	 * @param providerVersion
	 * @return
	 */
	public String getConfigurationFileName()
	{
		File configurationDirectory = getConfigurationDirectory();

		return configurationDirectory.getAbsolutePath() + "/" + getProviderName() + "-" + Double.toString(getProviderVersion()) + ".config";
	}

	/**
	 * 
	 * @param configurationFileName
	 * @return
	 * @throws IOException
	 */
	public File getConfigurationFile() 
	throws IOException
	{
		File configurationFile = new File(getConfigurationFileName());
		
		if (!configurationFile.exists())
			configurationFile.createNewFile();

		return configurationFile;
	}

	/**
	 * This method reads the first Object from the configuration file and
	 * returns it. This method does the class loader switching necessary.
	 * 
	 * @return
	 * @throws IOException 
	 */
	public T loadConfiguration() 
	throws IOException
	{
		ClassLoader loader = null;
		String componentIdentification = "<unknown>";

		try
		{
			try
			{
				// hold onto the previous loader
				loader = Thread.currentThread().getContextClassLoader();
				// set the current thread class loader to the class loader of the
				Thread.currentThread().setContextClassLoader(this.getClass().getClassLoader());
				componentIdentification = "<unknown, after class loader switch>";
			}
			catch (Throwable t)
			{
				// errors caught here indicate that we don't have the permission
				// needed
				// to change ClassLoader, check and fix the java policy file.
                logger.warn("ProviderConfiguration.loadConfiguration() --> Error loading configuration for [{}]: {}", componentIdentification, t.getMessage());
				return null;
			}
			try
			{
				return internalLoad();
			}
			catch(IOException ioX)
			{
                logger.error("ProviderConfiguration.loadConfiguration() --> Error loading configuration for [{}]: {}", componentIdentification, ioX.getMessage());
				throw ioX;
			}
			catch(com.thoughtworks.xstream.io.StreamException sX)
			{
                logger.error("ProviderConfiguration.loadConfiguration() --> Error parsing configuration in [{}]: {}", componentIdentification, sX.getMessage());
				throw new IOException(sX);
			}
		}
		finally
		{
			// set the current thread class loader back
			if (loader != null)
				Thread.currentThread().setContextClassLoader(loader);
		}
	}

	/**
	 * 
	 * @param configFile
	 * @return
	 */
	private T internalLoad()
	throws IOException
	{
		File configFile = getConfigurationFile();

        logger.info("ProviderConfiguration.internalLoad() --> Loading configuration from file [{}]", configFile.getAbsolutePath());

		try (InputStream inStream = new FileInputStream(configFile);)
		{			
			// switched the order to XStream first and then XMLDecoder, because the
			// config files are all being switched to XStream
			try
			{
				return loadUsingXStream(inStream);
			}
			catch(com.thoughtworks.xstream.converters.ConversionException cX)
			{
                logger.warn("ProviderConfiguration.internalLoad() --> Couldn't load configuration from file [{}] using XStream. Will try XMLEncoder next.", configFile.getAbsolutePath());
				
				/* close and re-open config file. WHY?
				try{inStream.close();}
				catch(Throwable t){}
				inStream = new FileInputStream(getConfigurationFile());
				 */
				return loadUsingXMLEncoder(inStream);
			}
		}
	}

	/**
	 * Store the configuration object to the configuration file. What the
	 * configuration object is, is up to the implementation classes.
	 * 
	 * @param configuration
	 */
	public void store(T configuration)
	throws IOException
	{
		try (FileOutputStream outStream = new FileOutputStream(getConfigurationFile());)
		{
			// always store in XStream now
			storeUsingXStream(outStream, configuration);
		}
	}
	
	private void storeUsingXStream(OutputStream outStream, T configuration) 
	throws IOException
	{
        logger.debug("ProviderConfiguration.storeUsingXStream() --> Saving configuration [{}] using XStream.", configuration.toString());
		
		getXStream().toXML(configuration, outStream);

        logger.debug("ProviderConfiguration.storeUsingXStream() --> Configuration [{}] saved using XStream.", configuration.toString());
	}
	
	@SuppressWarnings("unchecked")
	private T loadUsingXStream(InputStream inStream)
	{
		logger.debug("ProviderConfiguration.loadUsingXStream() --> Loading configuration using XStream");
		
		return ((T) getXStream().fromXML(inStream));
	}

	private static XStream getXStream(){
		XStream xStream = new XStream();
		xStream.registerConverter(new EncryptedConfigurationPropertyStringSingleValueConverter());
		return xStream;
	}
	
	private void storeUsingXMLEncoder(OutputStream outStream, T configuration) 
	throws IOException
	{
        logger.debug("ProviderConfiguration.storeUsingXMLEncoder() --> Saving configuration [{}] using XMLEncoder.", configuration.toString());

		XMLEncoder xmlEncoder = new XMLEncoder(outStream);
		xmlEncoder.writeObject(configuration);
		xmlEncoder.close();
	}
	
	@SuppressWarnings("unchecked")
	private T loadUsingXMLEncoder(InputStream inStream) 
	throws IOException
	{
		logger.debug("ProviderConfiguration.loadUsingXMLEncoder() --> Loading configuration using XMLDecoder");

		XMLDecoder xmlDecoder = new XMLDecoder(inStream);
		T config = (T)xmlDecoder.readObject();
        logger.info("Configuration loaded using XMLDecoder and is {}", config == null ? "NULL" : "NOT NULL");
		xmlDecoder.close();
		return config;
	}
	
	@SuppressWarnings("unchecked")
	public static <T extends Object> T serializeAndDeserializeByXStreamTest(T src)
	{
		ByteArrayOutputStream outStream = new ByteArrayOutputStream(4096);
		XStream xstreamOut = getXStream();
		xstreamOut.toXML(src, outStream);

		ByteArrayInputStream inStream = new ByteArrayInputStream( outStream.toByteArray() );
		XStream xstreamIn = getXStream();
		T result = (T)xstreamIn.fromXML(inStream);
		return result;
	}
}
