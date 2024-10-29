/**
 * 
 * 
 * Date Created: Feb 11, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.vistaimagingdatasource.consult;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.consult.datasource.ConsultDataSourceSpi;
import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;

/**
 * @author Julian Werfel
 *
 */
public class VistaImagingConsultDataSourceProvider
extends Provider
{

	private static final String PROVIDER_NAME = "VistaImagingConsultDataSource";
	private static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = 		
		"backed by a VistA data store.";

	private static final long serialVersionUID = 1L;
	
	private final SortedSet<ProviderService> services;
	@SuppressWarnings("unused")
	private static Logger log = Logger.getLogger(VistaImagingConsultDataSourceProvider.class);

	/**
	 * The public "nullary" constructor that is used by the ServiceLoader class
	 * to create instances.
	 */
	public VistaImagingConsultDataSourceProvider()
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}
	
	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	private VistaImagingConsultDataSourceProvider(String name, double version, String info)
	{
		super(name, version, info);

		services = new TreeSet<ProviderService>();
		
		services.add(
				new ProviderService(
					this,
					ConsultDataSourceSpi.class,
					VistaImagingConsultDataSourceService.SUPPORTED_PROTOCOL,
					1.0F,
					VistaImagingConsultDataSourceService.class)
				);		
	}
	

	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}
}