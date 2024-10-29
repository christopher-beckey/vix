/**
 * 
 */
package gov.va.med.imaging.viewerservicesdatasource;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;
import gov.va.med.imaging.datasource.ViewerServicesDataSourceSpi;
import gov.va.med.imaging.viewerservices.common.DefaultViewerServicesValues;
import gov.va.med.imaging.viewerservicesdatasource.v1.ViewerServicesViewerServicesDataSourceServiceV1;

/**
 * @author William Peterson
 *
 */
public class ViewerServicesDataSourceProvider 
extends Provider {

	private static final String PROVIDER_NAME = "ViewerServicesDataSource";
	private static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = "Implements: \nViewerServicesDataSource SPI \n backed by a ViewerServices data store.";

	private static final long serialVersionUID = 1L;
	private final SortedSet<ProviderService> services;
	private final static Logger logger = Logger.getLogger(ViewerServicesDataSourceProvider.class);


	/**
	 * 
	 */
	public ViewerServicesDataSourceProvider() {
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}
	
	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	private ViewerServicesDataSourceProvider(String name, double version, String info) {
		super(name, version, info);

		services = new TreeSet<ProviderService>();
		
		services.add(
			new ProviderService(
				this, 
				ViewerServicesDataSourceSpi.class, 
				DefaultViewerServicesValues.SUPPORTED_PROTOCOL, 
				1.0F, 
				ViewerServicesViewerServicesDataSourceServiceV1.class)
		);
					
	}
	
	
	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}
}
