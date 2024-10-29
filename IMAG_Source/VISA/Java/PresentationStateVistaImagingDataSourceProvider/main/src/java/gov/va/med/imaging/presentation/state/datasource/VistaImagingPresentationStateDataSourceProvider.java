/**
 * 
 */
package gov.va.med.imaging.presentation.state.datasource;

import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;
import gov.va.med.imaging.presentation.state.datasource.PresentationStateDataSourceSpi;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

/**
 * @author William Peterson
 *
 */
public class VistaImagingPresentationStateDataSourceProvider 
extends Provider {

	
	private static final long serialVersionUID = -8506787893035034503L;
	private static final String PROVIDER_NAME = "VistaImagingPresentationStateDataSource";
	private static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = "backed by a VistA data store.";

	
	private final SortedSet<ProviderService> services;
	
	@SuppressWarnings("unused")
	private final static Logger logger = Logger.getLogger(VistaImagingPresentationStateDataSourceProvider.class);

	/**
	 * 
	 */
	public VistaImagingPresentationStateDataSourceProvider() {
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}


	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	public VistaImagingPresentationStateDataSourceProvider(String name,
			double version, String info) {
		super(name, version, info);

		services = new TreeSet<ProviderService>();
		
		services.add(
				new ProviderService(
					this,
					PresentationStateDataSourceSpi.class,
					VistaImagingPresentationStateDataSourceService.SUPPORTED_PROTOCOL,
					1.0F,
					VistaImagingPresentationStateDataSourceService.class)
				);		
	}

	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}

}
