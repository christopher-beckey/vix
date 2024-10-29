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
package gov.va.med.imaging.mixdatasource;

import gov.va.med.imaging.datasource.*;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;
import gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration;
import gov.va.med.imaging.url.mix.exceptions.MIXConfigurationException;
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
public class MixDataSourceProvider 
extends Provider 
{
	private static final String PROVIDER_NAME = "MIXDataSource";
    private static final double PROVIDER_VERSION = 1.0d;
    private static final String PROVIDER_INFO = 
       	"Implements: \nStudyGraphDataSource \nImageDataSource SPI \n" + 
    	"backed by a MIX data store.";
    private static MIXConfiguration mixConfiguration = null;
    private static Logger logger = Logger.getLogger(MixDataSourceProvider.class);
    
    private static final long serialVersionUID = 1L;
    private final SortedSet<ProviderService> services;
	
	public MixDataSourceProvider() 
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}
	
	/**
	 * A special constructor that is only used for creating a configuration
	 * file.
	 * 
	 * @param MIXConfiguration
	 */
	private MixDataSourceProvider(MIXConfiguration mixConfiguration) 
	{
		this();
		MixDataSourceProvider.mixConfiguration = mixConfiguration;
	}
	
	public MixDataSourceProvider(String name, double version, String info) 
	{
		super(name, version, info);
		services = new TreeSet<ProviderService>();
//		services.add(
//			new ProviderService(
//				this, 
//				StudyGraphDataSourceSpi.class,
//				MixStudyGraphDataSourceService.SUPPORTED_PROTOCOL,
//				1.0F,
//				MixStudyGraphDataSourceService.class)
//		);
//		services.add(
//			new ProviderService(
//				this, 
//				ImageDataSourceSpi.class,
//				MixImageDataSourceService.SUPPORTED_PROTOCOL,
//				1.0F,
//				MixImageDataSourceService.class)
//		);
//		services.add(
//			new ProviderService(
//				this, 
//				VistaRadDataSourceSpi.class,
//				MixVistaRadDataSourceService.SUPPORTED_PROTOCOL,
//				1.0F,
//				MixVistaRadDataSourceService.class)
//		);
//		services.add(
//			new ProviderService(
//				this, 
//				VistaRadImageDataSourceSpi.class,
//				MixVistaRadImageDataSourceService.SUPPORTED_PROTOCOL,
//				1.0F,
//				MixVistaRadImageDataSourceService.class)
//		);
		services.add(
			new ProviderService(
				this, 
				StudyGraphDataSourceSpi.class,
				MixStudyGraphDataSourceServiceV1.SUPPORTED_PROTOCOL,
				1.0F,
				MixStudyGraphDataSourceServiceV1.class)
		);
		services.add(
			new ProviderService(
				this, 
				ImageDataSourceSpi.class,
				MixImageDataSourceServiceV1.SUPPORTED_PROTOCOL,
				1.0F,
				MixImageDataSourceServiceV1.class)
		);
		services.add(
			new ProviderService(
				this, 
				VistaRadDataSourceSpi.class,
				MixVistaRadDataSourceServiceV1.SUPPORTED_PROTOCOL,
				1.0F,
				MixVistaRadDataSourceServiceV1.class)
		);
		services.add(
			new ProviderService(
				this, 
				VistaRadImageDataSourceSpi.class,
				MixVistaRadImageDataSourceServiceV1.SUPPORTED_PROTOCOL,
				1.0F,
				MixVistaRadImageDataSourceServiceV1.class)
		);
		
		// load the MIXConfiguration if it exists
		synchronized(MixDataSourceProvider.class)
	    {
			try
			{
				if(mixConfiguration == null) {
					mixConfiguration = (MIXConfiguration) loadConfiguration();
				} else if (mixConfiguration.hasValueChangesToPersist(false)){
					logger.info("values unencrypted at rest detected, writing");
					storeConfiguration();
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
	    storeConfiguration(getMixConfiguration());
    }
	
	/**
	 * A package level method for SPI implementation to get the
	 * Configuration.
	 * 
	 * @return
	 */
	public static MIXConfiguration getMixConfiguration()
	{
		if(mixConfiguration == null)
			logger.error("MIXConfiguration is null, possibly called before MixDataSourceProvider was instantiated.");
		
		return mixConfiguration;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.Provider#getServices()
	 */
	@Override
	public SortedSet<ProviderService> getServices() {
		return Collections.unmodifiableSortedSet(services);
	}

	/**
	 * This creates by default a MIX data source configuration file for one DOD site.
	 * To specify the username and password for communicating with the DOD use 
	 * the -biaPassword <Password> and -biaUsername <username> parameters (for now, until install GUI changes).
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
			System.out.println("Creating MIX datasource configuration file");			
			String biaUsername = null;
			String biaPassword = null;		
			String dodConnectorHost = null;
			String dodConnectorPort = "0";
			String cvixCertPwd = null;
			String dasCertPwd = null;

			List<MIXSiteConfiguration> alienSites = new ArrayList<MIXSiteConfiguration>(); 
			List<String> emptyStudyModalities = new ArrayList<String>();
			
			for(int i = 0; i < argv.length; i++)
			{
				System.out.println("arg[" + i + "] = " + argv[i] + " " + argv[i+1]);
				
				//if("-biaUsername".equals(argv[i]))
				//{
				//	biaUsername = argv[++i];
				//}
				//else if("-biaPassword".equals(argv[i]))
				//{
				//	biaPassword = argv[++i];
				//}
				//else if("-alienSite".equals(argv[i]))
				//{
				//	String siteNumber = argv[++i];
				//	String host = argv[++i];
				//	int port = Integer.parseInt(argv[++i]);
				//	String username = argv[++i];
				//	String password = argv[++i];					
				//	alienSites.add(new MIXSiteConfiguration(siteNumber, username, password, "", "", "", "", "", 
				//			false, host, port));
				//}
				
				if("-host".equals(argv[i]))
				{
					dodConnectorHost = argv[++i];
				}
				else if("-port".equals(argv[i]))
				{
					dodConnectorPort = argv[++i];
				}
				else if("-cvixCertPwd".equals(argv[i]))
				{
					cvixCertPwd = argv[++i];
				}
				else if("-dasCertPwd".equals(argv[i]))
				{
					dasCertPwd = argv[++i];
				}

				else if("-emptyModality".equals(argv[i]))
				{
					String emptyStudyModality = argv[++i];
					emptyStudyModalities.add(emptyStudyModality);
				}
			}

			MIXConfiguration miXConfiguration = 
				MIXConfiguration.createDefaultMixConfiguration(
						emptyStudyModalities, 
						MIXConfiguration.defaultMetadataTimeout,
						dodConnectorHost,
						Integer.parseInt(dodConnectorPort),
						cvixCertPwd,
						dasCertPwd);
			
			MixDataSourceProvider provider = new MixDataSourceProvider(miXConfiguration);
			provider.storeConfiguration();
			System.out.println("Configuration file saved to '" + provider.getConfigurationFileName() + "'.");
		}
		catch(MIXConfigurationException ecX)
		{
			ecX.printStackTrace();
		}
	}
}
