/**
 * 
 * 
 * Date Created: Dec 5, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.vistaimagingdatasource.ingest;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;
import gov.va.med.imaging.ingest.datasource.ImageIngestDataSourceSpi;
import gov.va.med.imaging.vistaimagingdatasource.ingest.configuration.VistaImagingIngestConfiguration;

/**
 * @author Administrator
 *
 */
public class VistaImagingIngestDataSourceProvider
extends Provider
{

	private static final String PROVIDER_NAME = "VistaImagingIngestDataSource";
	private static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = 		
		"backed by a VistA data store.";

	private static final long serialVersionUID = 1L;
	
	private final SortedSet<ProviderService> services;
	private static VistaImagingIngestConfiguration configuration = null;
	private final static Logger logger = Logger.getLogger(VistaImagingIngestDataSourceProvider.class);

	/**
	 * The public "nullary" constructor that is used by the ServiceLoader class
	 * to create instances.
	 */
	public VistaImagingIngestDataSourceProvider()
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}
	
	/**
	 * A special constructor that is only used for creating a configuration
	 * file.
	 * @param configuration
	 */
	public VistaImagingIngestDataSourceProvider(VistaImagingIngestConfiguration configuration)
	{
		this();
		VistaImagingIngestDataSourceProvider.configuration = configuration;
	}
	
	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	private VistaImagingIngestDataSourceProvider(String name, double version, String info)
	{
		super(name, version, info);

		services = new TreeSet<ProviderService>();
		
		services.add(
				new ProviderService(
					this,
					ImageIngestDataSourceSpi.class,
					VistaImagingIngestDataSourceService.SUPPORTED_PROTOCOL,
					1.0F,
					VistaImagingIngestDataSourceService.class)
				);
		
		synchronized(VistaImagingIngestDataSourceProvider.class)
	    {
			try
			{
				if(configuration == null)
					configuration = (VistaImagingIngestConfiguration)loadConfiguration();
			}
			catch(ClassCastException ccX)
			{
				logger.error("Unable to load configuration because the configuration file is invalid.", ccX);
			}
	    }
		
	}
	

	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}
	
	/**
	 * A package level method for SPI implementation to get the
	 * Configuration.
	 * 
	 * @return
	 */
	public static VistaImagingIngestConfiguration getConfiguration()
	{
		if(configuration == null)
			logger.error("VistaImagingIngestConfiguration is null, possibly called before VistaImagingIngestDataSourceProvider was instantiated.");
		
		return configuration;
	}
	
	@Override
	public void storeConfiguration()
    {
	    storeConfiguration(getConfiguration());
    }
	
	public static void main(String [] args)
	{
		System.out.println("Creating vista imaging ingest datasource configuration file");	
		
		if(args.length == 2)
		{
			String thumbnailExe = args[0];
			String tempImageDirectory = args[1];
			
			VistaImagingIngestConfiguration configuration = new VistaImagingIngestConfiguration();
			configuration.setThumbnailMakerExe(thumbnailExe);
			configuration.setTempImageDirectory(tempImageDirectory);
			VistaImagingIngestDataSourceProvider provider = new VistaImagingIngestDataSourceProvider(configuration);
			provider.storeConfiguration();
			System.out.println("Configuration file saved to '" + provider.getConfigurationFileName() + "'.");	
		}
		else
		{
			System.out.println("Requires 2 arguments <ThumbnailExe> <temp image directory>");
		}		
	}
	
	
}
