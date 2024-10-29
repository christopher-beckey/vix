/**
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 4, 2017
  Developer:  vhaisltjahjb
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
package gov.va.med.imaging.dx.datasource;

import gov.va.med.imaging.datasource.*;
import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import java.io.IOException;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.Collections;
import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 *
 */
public class DxDataSourceProvider
extends Provider
{
	private static final long serialVersionUID = -2475090374494375682L;
	private final static Logger LOGGER = Logger.getLogger(DxDataSourceProvider.class);
	
	public static final String PROVIDER_NAME = "DxDataSourceProvider";
	public static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = "Implements: DocumentSetDataSource SPI as an DX gateway to DES Proxy Service";

	// ========================================================================================
	//
	// ========================================================================================
	
	private ProviderConfiguration<DxDataSourceConfiguration> providerConfiguration = null;
	private DxDataSourceConfiguration configuration = null;
	private final SortedSet<ProviderService> services;
	
	public DxDataSourceProvider()
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}

	public DxDataSourceProvider(DxDataSourceConfiguration config)
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
		this.setConfiguration(config);
	}

	/**
	 * 
	 * @param name
	 * @param version
	 * @param info
	 */
	private DxDataSourceProvider(String name, double version, String info)
	{
		
		super(name, version, info);
		
		services = new TreeSet<ProviderService>();

		LOGGER.debug("DxDataSourceProvider() --> Adding provider services....");

		services.add(
			new ProviderService(
				this, 
				DocumentDataSourceSpi.class, 
				DxDocumentDataSourceService.SUPPORTED_PROTOCOL, 
				1.0F, 
				DxDocumentDataSourceService.class)
		);

		services.add(
			new ProviderService(
				this, 
				DocumentSetDataSourceSpi.class, 
				DxDocumentSetDataSourceService.SUPPORTED_PROTOCOL, 
				1.0F, 
				DxDocumentSetDataSourceService.class)
		);
		
		this.providerConfiguration = new ProviderConfiguration<DxDataSourceConfiguration>(name, version);
		
		DxDataSourceConfiguration dxConfig = null;
		
		try
		{
			dxConfig = providerConfiguration.loadConfiguration();
			setConfiguration(dxConfig);
			
			if(getInstanceConfiguration() != null) {
				
				LOGGER.info("DxDataSourceProvider() --> Configuration successfully loaded");
				
				if(getInstanceConfiguration().hasValueChangesToPersist(false)){
					LOGGER.info("DxDataSourceProvider() --> values unencrypted at rest detected. Storing....");
					storeConfiguration();
				}
			}
		}
		catch (IOException x)
		{
            LOGGER.warn("DxDataSourceProvider() --> Configuration was NOT loaded. Encountered IOException: {}", x.getMessage());
		}		
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.Provider#getServices()
	 */
	@Override
	public SortedSet<ProviderService> getServices() 
	{
		return Collections.unmodifiableSortedSet(services);
	}
	
	public ProviderConfiguration<DxDataSourceConfiguration> getProviderConfiguration()
	{
		return this.providerConfiguration;
	}

	@Override
	public void storeConfiguration()
    {
		try
		{
			getProviderConfiguration().store(getInstanceConfiguration());
		}
		catch (IOException x)
		{
            LOGGER.warn("DxDataSourceProvider.storeConfiguration() --> Could NOT store configuration. Encountered IOException: {}", x.getMessage());
		}
    }
	
	/**
	 * A package level method for SPI implementation to get the
	 * Configuration.
	 * 
	 * @return
	 */
	@Override
	protected DxDataSourceConfiguration getInstanceConfiguration()
	{
		return configuration;
	}
	
	void setConfiguration(DxDataSourceConfiguration config)
	{
		this.configuration = config;
	}
	
	
	/**
	 * 
	 * @param args
	 */
	public static void main(String[] argv)
	{
		
		String dodConnectorHost = null;
		String dodConnectorPort = null;
		String dodConnectorProvider = null;
		String dodConnectorLoinc = null;
		String dodConnectorRequestSource = null;
		String cvixCertPwd = null;
		String dasCertPwd = null;
		String hostIpAddress = null;
		String alexdelargePwd = null;
					
		try
		{
			for(int i = 0; i < argv.length; i++)
			{
				System.out.println("arg[" + i + "] = " + argv[i] + " " + argv[i+1]);


				if("-host".equals(argv[i]))
				{
					dodConnectorHost = argv[++i];
				}
				else if("-port".equals(argv[i]))
				{
					dodConnectorPort = argv[++i];
				}
				else if("-provider".equals(argv[i]))
				{
					dodConnectorProvider = argv[++i];
				}
				else if("-loinc".equals(argv[i]))
				{
					dodConnectorLoinc = argv[++i];
				}
				else if("-requestSource".equals(argv[i]))
				{
					dodConnectorRequestSource = argv[++i];
				}
				else if("-cvixCertPwd".equals(argv[i]))
				{
					cvixCertPwd = argv[++i];
				}
				else if("-dasCertPwd".equals(argv[i]))
				{
					dasCertPwd = argv[++i];
				}
				else if("-localIp".equals(argv[i]))
				{
					hostIpAddress = argv[++i];
				}
				else if("-alexdelargePwd".equals(argv[i]))
				{
					alexdelargePwd = argv[++i];
				}
				
			}
			
			DxDataSourceConfiguration dxConfiguration = DxDataSourceConfiguration.create(
					DxDataSourceConfiguration.defaultKeystoreUrl, cvixCertPwd,
					DxDataSourceConfiguration.defaultTruststoreUrl, dasCertPwd,
					DxDataSourceConfiguration.defaultTLSProtocol, DxDataSourceConfiguration.defaultTLSPort,
					DxDataSourceConfiguration.defaultKeystoreAlias, false,
					DxDataSourceConfiguration.defaultQueryTimeout, DxDataSourceConfiguration.defaultRetrieveTimeout,
					"des_proxy_adapter",
					"v1",
					"v4.0",
					DxDataSourceConfiguration.defaultDelayPeriod,
					DxDataSourceConfiguration.defaultDasProtocol,
					dodConnectorHost,
					Integer.parseInt(dodConnectorPort),
					dodConnectorRequestSource,
					dodConnectorLoinc,
					dodConnectorProvider,
					"",
					hostIpAddress,
					alexdelargePwd);
					
			DxDataSourceProvider provider = new DxDataSourceProvider(dxConfiguration);
			provider.storeConfiguration();
			System.out.println("Configuration file saved to '" + provider.getConfigurationFileName() + "'.");

		}
		catch (Exception x)
		{
			x.printStackTrace();
		}
	}
}
