/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 4, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.url.vista.configuration;

import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.*;

import gov.va.med.logging.Logger;

import freemarker.template.utility.StringUtil;
import gov.va.med.imaging.url.vista.StringUtils;
import org.w3c.dom.Element;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathFactory;


/**
 * This contains a copy of code from AbstractBaseFacadeConfiguration. It needed to be copied to not
 * create a circular dependency.
 * 
 * @author vhaiswwerfej
 *
 */
public class VistaConnectionConfiguration 
{
	private Logger logger = Logger.getLogger(VistaConnectionConfiguration.class);
	
	private Boolean oldStyleLoginEnabled = null;
	private Boolean newStyleLoginEnabled = null;
	private Long disconnectReadTimeout = null;
	private Long callReadTimeout = null;
	private Long connectReadTimeout = null;
	private Long readPollingInterval = null;
	
	private final static long defaultCallReadTimeout = 240000L;
	private final static long defaultConnectionReadTimeout = 60000L;
	private final static long defaultDisconnectReadTimeout = 60000L;
	private final static long defaultReadPollingInterval = 10L;
	
	public VistaConnectionConfiguration()
	{
		super();
	}
	
	private static VistaConnectionConfiguration configuration = null;
	public synchronized static VistaConnectionConfiguration getVistaConnectionConfiguration()
	{
		if(configuration == null)
		{
			VistaConnectionConfiguration config = new VistaConnectionConfiguration();
			configuration = config.loadConfiguration();			
		}
		return configuration;
	}
	
	/**
	 * @return the oldStyleLoginEnabled
	 */
	public Boolean getOldStyleLoginEnabled() {
		return oldStyleLoginEnabled;
	}

	/**
	 * @param oldStyleLoginEnabled the oldStyleLoginEnabled to set
	 */
	public void setOldStyleLoginEnabled(Boolean oldStyleLoginEnabled) {
		this.oldStyleLoginEnabled = oldStyleLoginEnabled;
	}

	/**
	 * @return the newStyleLoginEnabled
	 */
	public Boolean getNewStyleLoginEnabled() {
		return newStyleLoginEnabled;
	}

	/**
	 * @param newStyleLoginEnabled the newStyleLoginEnabled to set
	 */
	public void setNewStyleLoginEnabled(Boolean newStyleLoginEnabled) {
		this.newStyleLoginEnabled = newStyleLoginEnabled;
	}

	/**
	 * @return the disconnectReadTimeout
	 */
	public Long getDisconnectReadTimeout()
	{
		return disconnectReadTimeout;
	}

	/**
	 * @param disconnectReadTimeout the disconnectReadTimeout to set
	 */
	public void setDisconnectReadTimeout(Long disconnectReadTimeout)
	{
		this.disconnectReadTimeout = disconnectReadTimeout;
	}

	/**
	 * @return the callReadTimeout
	 */
	public Long getCallReadTimeout()
	{
		return callReadTimeout;
	}

	/**
	 * @param callReadTimeout the callReadTimeout to set
	 */
	public void setCallReadTimeout(Long callReadTimeout)
	{
		this.callReadTimeout = callReadTimeout;
	}

	/**
	 * @return the connectReadTimeout
	 */
	public Long getConnectReadTimeout()
	{
		return connectReadTimeout;
	}

	/**
	 * @param connectReadTimeout the connectReadTimeout to set
	 */
	public void setConnectReadTimeout(Long connectReadTimeout)
	{
		this.connectReadTimeout = connectReadTimeout;
	}

	/**
	 * @return the readPollingInterval
	 */
	public Long getReadPollingInterval()
	{
		return readPollingInterval;
	}

	/**
	 * @param readPollingInterval the readPollingInterval to set
	 */
	public void setReadPollingInterval(Long readPollingInterval)
	{
		this.readPollingInterval = readPollingInterval;
	}

	public VistaConnectionConfiguration loadConfiguration()
	{
		VistaConnectionConfiguration config = loadConfigurationFromFile();
		if(config == null)
		{
			config = loadDefaultConfiguration();
			config.storeConfiguration();
		}
		return config;
	}		
	
	public VistaConnectionConfiguration loadDefaultConfiguration()
	{
		// VAI 618 rollback new style to old broker
		// this.newStyleLoginEnabled = true;
		// this.oldStyleLoginEnabled = false;
		this.newStyleLoginEnabled = true;
		this.oldStyleLoginEnabled = false;
		this.callReadTimeout = defaultCallReadTimeout;
		this.disconnectReadTimeout = defaultDisconnectReadTimeout;
		this.connectReadTimeout = defaultConnectionReadTimeout;
		this.readPollingInterval = defaultReadPollingInterval;
		return this;
	}
	
	private VistaConnectionConfiguration loadConfigurationFromFile()
	{
		// Fortify change: reworked and used try-with-resources
		File file = new File(getConfigurationFileName());
		
		if(file.exists())
		{				
			try (FileInputStream inStream = new FileInputStream(file.getAbsolutePath())) {
				VistaConnectionConfiguration configuration = deserializeFromXml(inStream);
                logger.info("Loaded configuration file [{}]", file.getAbsolutePath());
				return configuration;
			} catch(Exception fnfX) {
                logger.error("Error reading configuration: {}", fnfX.getMessage(), fnfX);
			}
		}
		else
		{
            logger.info("File [{}] does not exist", file.getAbsolutePath());
		}
		
		return null;
	}

	private VistaConnectionConfiguration deserializeFromXml(InputStream inputStream) throws Exception {
		// Convert to XML
		Element rootElement;
		try {
			DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
			documentBuilderFactory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
			documentBuilderFactory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
			documentBuilderFactory.setFeature("http://xml.org/sax/features/external-general-entities", false);
			documentBuilderFactory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
			documentBuilderFactory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
			documentBuilderFactory.setXIncludeAware(false);
			documentBuilderFactory.setExpandEntityReferences(false);

			rootElement = documentBuilderFactory.newDocumentBuilder().parse(inputStream).getDocumentElement();
		} catch (Exception e) {
			throw new IOException("Error parsing xml", e);
		}

		// Get a xpath evaluator
		XPath xPath = XPathFactory.newInstance().newXPath();

		// Construct a new VistaConnectionConfiguration
		VistaConnectionConfiguration vistaConnectionConfiguration = new VistaConnectionConfiguration();

		// Grab and set values
		String oldStyleLoginEnabled = xPath.evaluate("/java/object[@class = 'gov.va.med.imaging.url.vista.configuration.VistaConnectionConfiguration']/void[@property = 'oldStyleLoginEnabled']/boolean", rootElement);
		if (oldStyleLoginEnabled != null) {
			vistaConnectionConfiguration.oldStyleLoginEnabled = Boolean.parseBoolean(oldStyleLoginEnabled);
		}

		String newStyleLoginEnabled = xPath.evaluate("/java/object[@class = 'gov.va.med.imaging.url.vista.configuration.VistaConnectionConfiguration']/void[@property = 'newStyleLoginEnabled']/boolean", rootElement);
		if (newStyleLoginEnabled != null) {
			vistaConnectionConfiguration.newStyleLoginEnabled = Boolean.parseBoolean(newStyleLoginEnabled);
		}

		String disconnectReadTimeout = xPath.evaluate("/java/object[@class = 'gov.va.med.imaging.url.vista.configuration.VistaConnectionConfiguration']/void[@property = 'disconnectReadTimeout']/long", rootElement);
		if (disconnectReadTimeout != null) {
			vistaConnectionConfiguration.disconnectReadTimeout = Long.parseLong(disconnectReadTimeout);
		}

		String callReadTimeout = xPath.evaluate("/java/object[@class = 'gov.va.med.imaging.url.vista.configuration.VistaConnectionConfiguration']/void[@property = 'callReadTimeout']/long", rootElement);
		if (callReadTimeout != null) {
			vistaConnectionConfiguration.callReadTimeout = Long.parseLong(callReadTimeout);
		}

		String connectReadTimeout = xPath.evaluate("/java/object[@class = 'gov.va.med.imaging.url.vista.configuration.VistaConnectionConfiguration']/void[@property = 'connectReadTimeout']/long", rootElement);
		if (connectReadTimeout != null) {
			vistaConnectionConfiguration.connectReadTimeout = Long.parseLong(connectReadTimeout);
		}

		String readPollingInterval = xPath.evaluate("/java/object[@class = 'gov.va.med.imaging.url.vista.configuration.VistaConnectionConfiguration']/void[@property = 'readPollingInterval']/long", rootElement);
		if (readPollingInterval != null) {
			vistaConnectionConfiguration.readPollingInterval = Long.parseLong(readPollingInterval);
		}

		return vistaConnectionConfiguration;
	}

	public synchronized void storeConfiguration()
	{
		String filename = getConfigurationFileName();
		// Fortify change: used try-with-resources
		try ( FileOutputStream outStream = new FileOutputStream(filename); 
			  XMLEncoder encoder = new XMLEncoder(outStream) )
		{			
			encoder.writeObject(this);
            logger.info("Stored configuration file [{}]", filename);
		}
		catch(IOException ioX)
		{
            logger.error("Error storing configuration: {}", ioX.getMessage(), ioX);
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
		
		File configurationDirectory = new File(StringUtils.cleanString(configurationDirectoryName));
		if(! configurationDirectory.exists())
			configurationDirectory.mkdirs();		// make the directories if they don't exist
		
		return configurationDirectory;
	}
	
	/**
	 * Build a filename in the standardized format from the
	 * provider name and version.  A Provider that does not
	 * have any persistent configuration must override this 
	 * method to return null.
	 * This method will assure that the parent directory exists
	 * before returning.  It will NOT create the configuration
	 * file if it does not exist.
	 * 
	 * The preferred store locations are (in order):
	 * 1.) The directory of the VIX configuration
	 * 2.) The user home directory
	 * 3.) The root directory
	 * 
	 * @return
	 */
	private String getConfigurationFileName()
	{
		File configurationDirectory = getConfigurationDirectory();	
		return configurationDirectory.getAbsolutePath() + "/" + this.getClass().getSimpleName() + ".config"; 
	}
	
	public static void main(String [] args)
	{
		VistaConnectionConfiguration configuration = new VistaConnectionConfiguration();
		configuration.loadDefaultConfiguration();
		
		if((args != null) && (args.length > 0))
		{
			// VAI 618 rollback new style to old broker
			// boolean newStyle = true;
			// boolean oldStyle = false;
			boolean newStyle = true;
			boolean oldStyle = false;
			long callReadTimeout = defaultCallReadTimeout;
			long connectionReadTimeout = defaultConnectionReadTimeout;
			long disconnectReadTimeout = defaultDisconnectReadTimeout;
			long readPollingInterval = defaultReadPollingInterval;
			for(int i = 0; i < args.length; i++)
			{
				if("-new".equals(args[i]))
				{
					newStyle = Boolean.parseBoolean(args[++i]);
				}
				else if("-old".equals(args[i]))
				{
					oldStyle = Boolean.parseBoolean(args[++i]);
				}
				else if("-call".equals(args[i]))
				{
					callReadTimeout = Long.parseLong(args[++i]);
				}
				else if("-connect".equals(args[i]))
				{
					connectionReadTimeout = Long.parseLong(args[++i]);
				}
				else if("-disconnect".equals(args[i]))
				{
					disconnectReadTimeout = Long.parseLong(args[++i]);
				}
				else if("-read".equals(args[i]))
				{
					readPollingInterval = Long.parseLong(args[++i]);
				}
			}
			configuration.setNewStyleLoginEnabled(newStyle);
			configuration.setOldStyleLoginEnabled(oldStyle);
			configuration.setCallReadTimeout(callReadTimeout);
			configuration.setConnectReadTimeout(connectionReadTimeout);
			configuration.setDisconnectReadTimeout(disconnectReadTimeout);
			configuration.setReadPollingInterval(readPollingInterval);
		}
		configuration.storeConfiguration();		
	}
}

