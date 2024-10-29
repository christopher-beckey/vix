/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 23, 2012
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
package gov.va.med.imaging.imagegear.datasource;

import java.lang.management.ManagementFactory;
import java.util.Collections;
import java.util.Hashtable;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.management.MBeanServer;
import javax.management.ObjectName;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.ImagingMBean;
import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;
import gov.va.med.imaging.imagegear.datasource.configuration.ImageGearConfiguration;
import gov.va.med.imaging.imagegear.datasource.statistics.ImageGearDataSourceProviderStatistics;
import gov.va.med.imaging.roi.datasource.ImageAnnotationWriterDataSourceSpi;
import gov.va.med.imaging.roi.datasource.ImageMergeWriterDataSourceSpi;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ImageGearDataSourceProvider
extends Provider
{
	private static final String PROVIDER_NAME = "ImageGearDataSource";
	private static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = 
		"Implements: \n" + 
		"StudyGraphDataSource, ImageDataSource, and ImageAccessLoggingDataSource SPI \n" + 
		"backed by a VistA data store.";

	private static final long serialVersionUID = 1L;
	private final static Logger LOGGER = Logger.getLogger(ImageGearDataSourceProvider.class);
	
	private static ImageGearConfiguration imageGearConfiguration;
	private static ImageGearDataSourceProviderStatistics statistics;
	private static ObjectName imageGearStatisticsMBeanName;
	private final SortedSet<ProviderService> services;
	
	/**
	 * The public "nullary" constructor that is used by the ServiceLoader class
	 * to create instances.
	 */
	public ImageGearDataSourceProvider()
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}

	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	private ImageGearDataSourceProvider(String name, double version, String info)
	{
		super(name, version, info);

		services = new TreeSet<ProviderService>();
		
		services.add(
				new ProviderService(
					this,
					ImageAnnotationWriterDataSourceSpi.class,
					ImageGearImageAnnotationWriterDataSourceService.SUPPORTED_PROTOCOL,
					ImageGearImageAnnotationWriterDataSourceService.protocolVersion,
					ImageGearImageAnnotationWriterDataSourceService.class)
				);
		services.add(
				new ProviderService(
					this,
					ImageMergeWriterDataSourceSpi.class,
					ImageGearImageMergeWriterDataSourceService.SUPPORTED_PROTOCOL,
					ImageGearImageMergeWriterDataSourceService.protocolVersion,
					ImageGearImageMergeWriterDataSourceService.class)
				);
		/*
		 // for local data source - put in for P118
		services.add(
				new ProviderService(
					this, 
					DataDictionaryDataSourceSpi.class,
					(byte)1, 
					VistaImagingDataDictionaryDataSourceService.class)
				);*/
		
		// load the FederationConfiguration if it exists
		synchronized(ImageGearDataSourceProvider.class)
	    {
			try
			{
				if(imageGearConfiguration == null)
				{
					imageGearConfiguration = (ImageGearConfiguration)loadConfiguration();
					if(imageGearConfiguration == null)
					{
						imageGearConfiguration = ImageGearConfiguration.createDefaultConfiguration();
					}
				}
				if(statistics == null)
					statistics = new ImageGearDataSourceProviderStatistics();
				registerMBeanServer();
				
			}
			catch(ClassCastException ccX)
			{
                LOGGER.warn("ImageGearDataSourceProvider() --> Unable to load configuration because the configuration file is invalid: {}", ccX.getMessage());
			}
	    }
		
		ImageGearMergeOutputPurge.scheduleMergeOutputPurge();
	}
	
	private static synchronized void registerMBeanServer()
	{
		if(imageGearStatisticsMBeanName == null)
		{
			LOGGER.info("ImageGearDataSourceProvider.registerMBeanServer() --> Registering Image Gear Data Source Provider with JMX");
			try
			{
	            // add statistics
				MBeanServer mBeanServer = ManagementFactory.getPlatformMBeanServer();
				Hashtable<String, String> mBeanProperties = new Hashtable<String, String>();
				mBeanProperties.put( "type", "ImageGearDataSourceProvider" );
				mBeanProperties.put( "name", "Statistics");
				imageGearStatisticsMBeanName = new ObjectName(ImagingMBean.VIX_MBEAN_DOMAIN_NAME, mBeanProperties);
				mBeanServer.registerMBean(statistics, imageGearStatisticsMBeanName);
			}
			catch(Exception ex)
			{
                LOGGER.warn("ImageGearDataSourceProvider.registerMBeanServer() --> Encountered exception [{}] Error registering Image Gear Data Source Provider with JMX: {}", ex.getClass().getSimpleName(), ex.getMessage());
			}
		}
	}
	
	/**
	 * A special constructor that is only used for creating a configuration
	 * file.
	 * 
	 * @param exchangeConfiguration
	 */
	private ImageGearDataSourceProvider(ImageGearConfiguration imageGearConfiguration) 
	{
		this();
		ImageGearDataSourceProvider.imageGearConfiguration = imageGearConfiguration;
	}

	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}
	
	@Override
	public void storeConfiguration()
    {
	    storeConfiguration(getImageGearConfiguration());
    }
	
	/**
	 * A package level method for SPI implementation to get the
	 * Configuration.
	 * 
	 * @return
	 */
	static ImageGearConfiguration getImageGearConfiguration()
	{
		if(imageGearConfiguration == null)
			LOGGER.warn("ImageGearDataSourceProvider.getImageGearConfiguration() --> ImageGearConfiguration was not configured yet !!!");
		
		return imageGearConfiguration;
	}
	
	static ImageGearDataSourceProviderStatistics getStatistics()
	{
		return statistics;
	}
	
	public static void main(String [] args)
	{
		if(args.length == 4)
		{
			String groupOutputDirectory = args[0];
			String siteName = args[1];
			String pdfGeneratorExePath = args[2];
			String burnAnnotationsExePath = args[3];
			
			ImageGearConfiguration config = ImageGearConfiguration.createDefaultConfiguration();
			config.setGroupOutputDirectory(groupOutputDirectory);
			config.setPdfGeneratorExePath(pdfGeneratorExePath);
			config.setRoiOfficeName(siteName);
			config.setBurnAnnotationsExePath(burnAnnotationsExePath);
			ImageGearDataSourceProvider provider = new ImageGearDataSourceProvider(config);
			provider.storeConfiguration();
		}
		else
		{
			System.out.println("Requires 4 parameters: <Output Temp Directory> <ROI Site Name> <PDF Generator EXE Path> <Burn Annotation EXE Path>");
		}
	}
}
