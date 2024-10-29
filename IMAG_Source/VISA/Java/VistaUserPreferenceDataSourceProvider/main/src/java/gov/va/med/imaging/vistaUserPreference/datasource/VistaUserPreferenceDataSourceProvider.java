/**
 * 
 * Date Created: Jul 27, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference.datasource;

import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

/**
 * @author Budy Tjahjo
 *
 */
public class VistaUserPreferenceDataSourceProvider
extends Provider
{

	private static final String PROVIDER_NAME = "userPreferenceDataSource";
	private static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = 		
		"backed by a VistA data store.";

	private static final long serialVersionUID = 1L;
	
	private final SortedSet<ProviderService> services;
	@SuppressWarnings("unused")
	private final static Logger logger = Logger.getLogger(VistaUserPreferenceDataSourceProvider.class);

	/**
	 * The public "nullary" constructor that is used by the ServiceLoader class
	 * to create instances.
	 */
	public VistaUserPreferenceDataSourceProvider()
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}
	
	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	private VistaUserPreferenceDataSourceProvider(String name, double version, String info)
	{
		super(name, version, info);

		services = new TreeSet<ProviderService>();
		
		services.add(
				new ProviderService(
					this,
					VistaUserPreferenceDataSourceSpi.class,
					VistaUserPreferenceDataSourceService.SUPPORTED_PROTOCOL,
					1.0F,
					VistaUserPreferenceDataSourceService.class)
				);		
	}
	

	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}
	

}
