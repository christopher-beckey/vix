/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 8, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.exchangedatasource;

import gov.va.med.imaging.datasource.*;
import gov.va.med.imaging.url.exchange.configuration.ExchangeConfiguration;
import gov.va.med.imaging.url.exchange.configuration.ExchangeSiteConfiguration;
import gov.va.med.imaging.url.exchange.exceptions.ExchangeConfigurationException;
import java.util.*;
import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 * 
 * A note about the configuration file:
 * The configuration file loading is rather odd as it depends on an
 * instance of this class to load the file and make the configuration
 * available in a static reference.
 * The reason for this is that the SPI's do not have a reference to their
 * Provider (this) and this does not instantiate the SPI's.
 * The configuration is an instance reference and must stay that way because it
 * uses the name and version to build the file name.
 * Nonetheless, this will be loaded by the ServiceLoader before an SPI can
 * be created, so there is not a danger of an SPI being created without
 * the configuration being initialized.  Nonetheless there is an error log
 * if the configuration is null when it is asked for.
 */
public class ExchangeDataSourceProvider 
extends Provider 
{
	private static final Logger LOGGER = Logger.getLogger(ExchangeDataSourceProvider.class);
	
	private static final String PROVIDER_NAME = "ExchangeDataSource";
    private static final double PROVIDER_VERSION = 1.0d;
    private static final String PROVIDER_INFO = 
    	"Implements: \nStudyGraphDataSource \nImageDataSource SPI \n" + 
    	"backed by an Exchange data store.";
    private static ExchangeConfiguration exchangeConfiguration = null;
    
    
    private static final long serialVersionUID = 1L;
    private final SortedSet<ProviderService> services;
	
	public ExchangeDataSourceProvider() 
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}
	
	/**
	 * A special constructor that is only used for creating a configuration
	 * file.
	 * 
	 * @param exchangeConfiguration
	 */
	private ExchangeDataSourceProvider(ExchangeConfiguration exchangeConfiguration) 
	{
		this();
		ExchangeDataSourceProvider.exchangeConfiguration = exchangeConfiguration;
	}
	
	public ExchangeDataSourceProvider(String name, double version, String info) 
	{
		super(name, version, info);
		services = new TreeSet<ProviderService>();
		services.add(
			new ProviderService(
				this, 
				StudyGraphDataSourceSpi.class,
				ExchangeStudyGraphDataSourceService.SUPPORTED_PROTOCOL,
				1.0F,
				ExchangeStudyGraphDataSourceService.class)
		);
		services.add(
			new ProviderService(
				this, 
				ImageDataSourceSpi.class,
				ExchangeImageDataSourceService.SUPPORTED_PROTOCOL,
				1.0F,
				ExchangeImageDataSourceService.class)
		);
		services.add(
			new ProviderService(
				this, 
				VistaRadDataSourceSpi.class,
				ExchangeVistaRadDataSourceService.SUPPORTED_PROTOCOL,
				1.0F,
				ExchangeVistaRadDataSourceService.class)
		);
		services.add(
			new ProviderService(
				this, 
				VistaRadImageDataSourceSpi.class,
				ExchangeVistaRadImageDataSourceService.SUPPORTED_PROTOCOL,
				1.0F,
				ExchangeVistaRadImageDataSourceService.class)
		);
		services.add(
			new ProviderService(
				this, 
				StudyGraphDataSourceSpi.class,
				ExchangeStudyGraphDataSourceServiceV2.SUPPORTED_PROTOCOL,
				2.0F,
				ExchangeStudyGraphDataSourceServiceV2.class)
		);
		services.add(
			new ProviderService(
				this, 
				ImageDataSourceSpi.class,
				ExchangeImageDataSourceServiceV2.SUPPORTED_PROTOCOL,
				2.0F,
				ExchangeImageDataSourceServiceV2.class)
		);
		services.add(
			new ProviderService(
				this, 
				VistaRadDataSourceSpi.class,
				ExchangeVistaRadDataSourceServiceV2.SUPPORTED_PROTOCOL,
				2.0F,
				ExchangeVistaRadDataSourceServiceV2.class)
		);
		services.add(
			new ProviderService(
				this, 
				VistaRadImageDataSourceSpi.class,
				ExchangeVistaRadImageDataSourceServiceV2.SUPPORTED_PROTOCOL,
				2.0F,
				ExchangeVistaRadImageDataSourceServiceV2.class)
		);
		
		// load the ExchangeConfiguration if it exists
		synchronized(ExchangeDataSourceProvider.class)
	    {
			try
			{
				if(exchangeConfiguration == null)
					exchangeConfiguration = (ExchangeConfiguration)loadConfiguration();
				if(exchangeConfiguration != null && exchangeConfiguration.hasValueChangesToPersist(false))
					storeConfiguration();
			}
			catch(ClassCastException ccX)
			{
                LOGGER.warn("ExchangeDataSourceProvider() --> Unable to load configuration because the configuration file is invalid: {}", ccX.getMessage());
			}
	    }
	}
	
	/**
	 * 
	 */
	@Override
	public void storeConfiguration()
    {
	    storeConfiguration(getExchangeConfiguration());
    }
	
	/**
	 * A package level method for SPI implementation to get the
	 * Configuration.
	 * 
	 * @return
	 */
	static ExchangeConfiguration getExchangeConfiguration()
	{
		if(exchangeConfiguration == null)
			LOGGER.error("ExchangeDataSourceProvider.getExchangeConfiguration() --> ExchangeConfiguration is null, possibly called before ExchangeDataSourceProvider was instantiated.");
		
		return exchangeConfiguration;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.Provider#getServices()
	 */
	@Override
	public SortedSet<ProviderService> getServices() {
		return Collections.unmodifiableSortedSet(services);
	}

	/**
	 * This creates by default a exchange data source configuration file for one DOD site.
	 * To specify the username and password for communicating with the DOD use 
	 * the -biaPassword <Password> and -biaUsername <username> parameters.
	 * You can also specify VA site numbers to be created with default values separated 
	 * by a space. This will create
	 * template output for VA sites - you will have to fill in the correct username/password and
	 * change any other fields if necessary.
	 * 
	 * You can also specify alien sites with the -alienSite paramter followed by the following arguments:
	 * <Alien Site number> <host> <port> <username> <password>
	 * 
	 * @param args VA site numbers separated by a space
	 */
	public static void main(String[] argv)
	{
		try
		{
			System.out.println("Creating exchange datasource configuration file");			
			String biaUsername = null;
			String biaPassword = null;		
			
			String[] vaSites = new String[argv.length];
			List<ExchangeSiteConfiguration> alienSites = new ArrayList<ExchangeSiteConfiguration>(); 
			List<String> emptyStudyModalities = new ArrayList<String>();
			int vaSiteIndex = 0;
			
			for(int i = 0; i < argv.length; i++)
			{
				if("-biaUsername".equals(argv[i]))
				{
					biaUsername = argv[++i];
				}
				else if("-biaPassword".equals(argv[i]))
				{
					biaPassword = argv[++i];
				}
				else if("-alienSite".equals(argv[i]))
				{
					String siteNumber = argv[++i];
					String host = argv[++i];
					int port = Integer.parseInt(argv[++i]);
					String username = argv[++i];
					String password = argv[++i];					
					alienSites.add(new ExchangeSiteConfiguration(siteNumber, username, password, "", "", "", 
							false, host, port));
				}
				else if("-emptyModality".equals(argv[i]))
				{
					String emptyStudyModality = argv[++i];
					emptyStudyModalities.add(emptyStudyModality);
				}
				else
				{
					try
					{
						Integer.parseInt(argv[i]);
						vaSites[vaSiteIndex++] = argv[i];
					}
					catch(NumberFormatException nfX)
					{
						System.out.println("Error converting " + argv[i] + " to numeric site number, ignoring ...");
					}
				}
			}
			// null the remainder of the array positions
			for(; vaSiteIndex < vaSites.length; ++vaSiteIndex)
				vaSites[vaSiteIndex] = null;
			
			ExchangeConfiguration xchangeConfiguration = 
				ExchangeConfiguration.createDefaultExchangeConfiguration(vaSites, biaUsername, biaPassword, 
						alienSites, emptyStudyModalities, ExchangeConfiguration.defaultMetadataTimeout);


			ExchangeDataSourceProvider provider = new ExchangeDataSourceProvider(xchangeConfiguration);
			provider.storeConfiguration();
			System.out.println("Configuration file saved to '" + provider.getConfigurationFileName() + "'.");
		}
		catch(ExchangeConfigurationException ecX)
		{
			ecX.printStackTrace();
		}
	}
}
