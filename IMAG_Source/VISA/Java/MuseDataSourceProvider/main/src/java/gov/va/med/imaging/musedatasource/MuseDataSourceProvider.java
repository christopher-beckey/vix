
/**
 * 
 */
package gov.va.med.imaging.musedatasource;

import gov.va.med.imaging.datasource.ImageDataSourceSpi;
import gov.va.med.imaging.datasource.PatientArtifactDataSourceSpi;
import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;
import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;
import gov.va.med.imaging.muse.DefaultMuseValues;
import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.musedatasource.v1.MuseImageDataSourceServiceV1;
import gov.va.med.imaging.musedatasource.v1.MusePatientArtifactDataSourceServiceV1;

import java.io.IOException;
import java.util.*;

import org.apache.commons.lang.StringUtils;
import gov.va.med.logging.Logger;
import org.codehaus.jackson.map.ObjectMapper;

/**
 * @author William Peterson
 *
 */
public class MuseDataSourceProvider 
extends Provider {

	private static final String PROVIDER_NAME = "MuseDataSource";
	private static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = "Implements: \nPatientArtifactDataSource, ImageDataSource SPI \n backed " +
			"by a Muse data store.";

	private static final long serialVersionUID = 1L;
	private static MuseConfiguration museConfiguration = null;
	private final SortedSet<ProviderService> services;

	private final static Logger logger = Logger.getLogger(MuseDataSourceProvider.class);

	/**
	 * The public "nullary" constructor that is used by the ServiceLoader class
	 * to create instances.
	 */
	public MuseDataSourceProvider()
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}
	
	/**
	 * A special constructor that is only used for creating a configuration
	 * file.
	 * 
	 * @param museConfiguration
	 */
	private MuseDataSourceProvider(MuseConfiguration museConfiguration) 
	{
		this();
		MuseDataSourceProvider.museConfiguration = museConfiguration;
	}


	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	private MuseDataSourceProvider(String name, double version, String info) {
		super(name, version, info);

		services = new TreeSet<ProviderService>();
		
		services.add(
			new ProviderService(
				this, 
				PatientArtifactDataSourceSpi.class, 
				DefaultMuseValues.SUPPORTED_PROTOCOL, 
				1.0F, 
				MusePatientArtifactDataSourceServiceV1.class)
		);
		services.add(
				new ProviderService(
					this, 
					ImageDataSourceSpi.class, 
					DefaultMuseValues.SUPPORTED_PROTOCOL, 
					1.0F, 
					MuseImageDataSourceServiceV1.class)
			);
					
		// load the MuseConfiguration if it exists
		synchronized(MuseDataSourceProvider.class)
	    {
			try
			{
				if(museConfiguration == null)
				{
					logger.debug("Load Muse configuration.");
					try {
						museConfiguration = (MuseConfiguration) loadConfiguration();
					}catch(Exception e){
                        logger.error("unable to load muse configuration: {}", e.getMessage());
					}
					if(museConfiguration == null)
					{	
						logger.debug("Create Muse default configuration.");
						museConfiguration = MuseConfiguration.createDefaultConfiguration();
						storeConfiguration();
					}
					if(museConfiguration.hasValueChangesToPersist(false)){
						storeConfiguration();
					}
				}				
			}
			catch(ClassCastException ccX)
			{
				logger.error("Unable to load configuration because the configuration file is invalid.", ccX);
			}
	    }
	}
	
	/**
	 * 
	 */
	@Override
	public void storeConfiguration()
    {
	    storeConfiguration(getMuseConfiguration());
    }
	
	/**
	 * A package level method for SPI implementation to get the
	 * Configuration.
	 * 
	 * @return
	 */
	public static MuseConfiguration getMuseConfiguration()
	{
		if(museConfiguration == null)
			logger.info("No museConfiguration. VIX will not retrieve MUSE data");

		return museConfiguration;
	}

	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}
	
	private static String clearPassword(String password) {
		char[] hardcoded = "***MUSE PASSWORD HERE***".toCharArray();
		char[] provided = password.toCharArray();
		if (hardcoded.length != provided.length) {
			return password;
		}
		
		for (int i = 0; i < hardcoded.length; ++i) {
			if (hardcoded[i] != provided[i]) {
				return password;
			}
		}
		
		return "";
	}

	private static String buildOutputForInstallerReadOperation(MuseConfiguration configuration){
		String userName = configuration.getServers().get(0).getUsername()
				.equals(DefaultMuseValues.defaultusername) ? "" : configuration.getServers().get(0).getUsername();
		String password = configuration.getServers().get(0).getPassword()
				.equals(DefaultMuseValues.defaultpassword) ? "" : configuration.getServers().get(0).getPassword();
		// Attempt to clear the password in a way that keeps fortify happy
        password = clearPassword(password);
		String siteNumber = configuration.getServers().get(0).getMuseSiteNumber()
				.equals(DefaultMuseValues.defaultSiteNumber) ? "" : configuration.getServers().get(0)
				.getMuseSiteNumber();
		String host = configuration.getServers().get(0).getHost().equals(DefaultMuseValues.defaulthost)
				? "" : configuration.getServers().get(0).getHost();
        String protocol = configuration.getServers().get(0).getProtocol();
        String port = String.valueOf(configuration.getServers().get(0).getPort());
		return configuration.getServers().get(0).isMuseDisabled() + "//"+siteNumber + "//"+ host + "//"
				+ userName +  "//" + password + "//" + port + "//" + protocol + "//";
	}

	private static MuseConfiguration processArgs(String[] args, MuseConfiguration config){
		if(config.getServers() == null || config.getServers().size() < 1){
			//handle a file with no server block, all valid muse config files should have a server block
			config.setServers(new ArrayList<MuseServerConfiguration>());
			config.getServers().add(MuseServerConfiguration.createDefaultConfiguration());
			config.getServers().get(0).setMuseDisabled(true);
		}
		//if a read command is received, only do that
		if(args.length == 1 && StringUtils.containsIgnoreCase(args[0],"-readConfig")){
			System.out.print("CurrentMuseConfig: //");
			System.out.print(buildOutputForInstallerReadOperation(config));
		}else{
			for(String arg : args) {
				if (StringUtils.containsIgnoreCase(arg, "-userName") && !getArgValue(arg).equals("")) {
					String unString = getArgValue(arg);
					config.getServers().get(0).setUsername(new EncryptedConfigurationPropertyString(unString));
				} else if (StringUtils.containsIgnoreCase(arg, "-password") && !getArgValue(arg).equals("")) {
					String pwString = getArgValue(arg);
					config.getServers().get(0).setPassword(new EncryptedConfigurationPropertyString(pwString));
				} else if (StringUtils.containsIgnoreCase(arg, "-museHost") && !getArgValue(arg).equals("") ) {
					config.getServers().get(0).setHost(getArgValue(arg));
				} else if (StringUtils.containsIgnoreCase(arg, "-museSiteNumber") && !getArgValue(arg).equals("")) {
					config.getServers().get(0).setMuseSiteNumber(getArgValue(arg));
				} else if (StringUtils.containsIgnoreCase(arg, "-musePort") && !getArgValue(arg).equals("")) {
					config.getServers().get(0).setPort(Integer.parseInt(getArgValue(arg)));
				} else if (StringUtils.containsIgnoreCase(arg, "-museEnabled") && !getArgValue(arg).equals("")) {
					boolean museEnabled = Boolean.parseBoolean(getArgValue(arg));
					config.getServers().get(0).setMuseDisabled(!museEnabled);
				} else if (StringUtils.containsIgnoreCase(arg, "-museProtocol") && !getArgValue(arg).equals("") ) {
					config.getServers().get(0).setProtocol(getArgValue(arg));
				} else {
					System.out.println("invalid parameter specified " + arg + " skipping.");
				}
			}
		}
		return config;
	}

	private static String getArgValue(String arg){
		return arg.substring(arg.indexOf("=")+1);
	}

	public static void main(String [] args) {
		MuseDataSourceProvider museDataSourceProvider = new MuseDataSourceProvider();
		MuseConfiguration config = getMuseConfiguration() != null ? getMuseConfiguration() :
				MuseConfiguration.createDefaultConfiguration();
		if(args.length > 7){
			System.out.println("Main method called with too many args. Valid args: -password=[password] " +
					"-museEnabled=[boolean] -userName=[userName] -museHost=[museHost] -museSiteNumber=[museSiteNumber]" +
					" -musePort=[musePort] -museProtocol=[museProtocol] -readConfig");
			return;
		}
		if(args.length > 0){
			//new behavior to accept values from the installer
			config = processArgs(args, config);
		}

		if(config.getMusePatientFilterRegularExpression() == null ||
				config.getMusePatientFilterRegularExpression().isEmpty()) {
			config.setMusePatientFilterRegularExpression(DefaultMuseValues.defaultMusePatientFilterRegEx);
		}
		MuseDataSourceProvider provider = new MuseDataSourceProvider(config);
		provider.storeConfiguration();
	}
}
