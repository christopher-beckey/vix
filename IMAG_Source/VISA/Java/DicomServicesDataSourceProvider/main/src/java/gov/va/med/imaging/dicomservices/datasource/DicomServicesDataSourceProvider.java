/**
 * 
 */
package gov.va.med.imaging.dicomservices.datasource;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.DataSourceExceptionHandler;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.datasource.DicomServicesDataSourceSpi;
import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;
import gov.va.med.imaging.dicomservices.common.DefaultDicomServicesValues;
import gov.va.med.imaging.dicomservices.datasource.configuration.DicomServicesConfiguration;
import gov.va.med.imaging.dicomservices.datasource.v1.DicomServicesDicomServicesDataSourceServiceV1;

/**
 * @author William Peterson
 *
 */
public class DicomServicesDataSourceProvider 
extends Provider {

	private static final long serialVersionUID = 1L;
	private final static Logger LOGGER = Logger.getLogger(DicomServicesDataSourceProvider.class);
	
	private static final String PROVIDER_NAME = "DicomServicesDataSource";
	private static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = "Implements: \nDicomServicesDataSource SPI \n backed by a DicomServices data store.";

	private static DicomServicesConfiguration dicomServicesConfiguration = null;
	private final SortedSet<ProviderService> services;

	/**
	 * 
	 */
	public DicomServicesDataSourceProvider() {
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}

	/**
	 * @param serviceClassLoader
	 */
	private DicomServicesDataSourceProvider(DicomServicesConfiguration dicomServicesConfiguration) {
		this();
		DicomServicesDataSourceProvider.dicomServicesConfiguration = dicomServicesConfiguration;
		
	}

	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	private DicomServicesDataSourceProvider(String name, double version, String info) {
		super(name, version, info);
		
		services = new TreeSet<ProviderService>();
		
		services.add(
			new ProviderService(
				this, 
				DicomServicesDataSourceSpi.class, 
				DefaultDicomServicesValues.SUPPORTED_PROTOCOL, 
				1.0F, 
				DicomServicesDicomServicesDataSourceServiceV1.class)
		);
		
		synchronized(DicomServicesDataSourceProvider.class)
	    {
			try
			{
				if(dicomServicesConfiguration == null)
				{
					LOGGER.debug("DicomServicesDataSourceProvider() --> Load Dicom Services configuration....");
					
					dicomServicesConfiguration = (DicomServicesConfiguration)loadConfiguration();
					
					if(dicomServicesConfiguration == null)
					{	
						LOGGER.debug("DicomServicesDataSourceProvider() --> Create Muse default configuration.");
						dicomServicesConfiguration = DicomServicesConfiguration.createDefaultConfiguration();
					}
				}				
			}
			catch(ClassCastException ccX)
			{
                LOGGER.warn("DicomServicesDataSourceProvider() --> Unable to load configuration because the configuration file is invalid: {}", ccX.getMessage());
			}
	    }
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.DataSourceProvider#createDicomServicesDataSource(gov.va.med.imaging.artifactsource.ResolvedArtifactSource, java.lang.String, gov.va.med.imaging.core.interfaces.DataSourceExceptionHandler[])
	 */
	@Override
	public DicomServicesDataSourceSpi createDicomServicesDataSource(ResolvedArtifactSource resolvedArtifactSource,
			String protocol, DataSourceExceptionHandler... dataSourceExceptionHandlers) throws ConnectionException {
		// TODO Auto-generated method stub
		return null;
	}
	
	
	@Override
	public void storeConfiguration()
    {
	    storeConfiguration(getDicomServicesConfiguration());
    }
	
	/**
	 * A package level method for SPI implementation to get the
	 * Configuration.
	 * 
	 * @return
	 */
	public static DicomServicesConfiguration getDicomServicesConfiguration()
	{
		if(dicomServicesConfiguration == null)
			LOGGER.info("DicomServicesDataSourceProvider.getDicomServicesConfiguration() --> No Dicom Services Configuration. VIX will not retrieve Dicom Services data.");
		
		return dicomServicesConfiguration;
	}

	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}
	
	public static void main(String [] args)
	{			
		DicomServicesConfiguration config = DicomServicesConfiguration.createDefaultConfiguration();
		DicomServicesDataSourceProvider provider = new DicomServicesDataSourceProvider(config);
		provider.storeConfiguration();
	}
}

