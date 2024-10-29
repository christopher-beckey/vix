/**
 * 
 * Date Created: Jan 20, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.vistaimagingdatasource.indexterm;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;
import gov.va.med.imaging.indexterm.datasource.IndexTermDataSourceSpi;


/**
 * @author Administrator
 *
 */
public class VistaImagingIndexTermDataSourceProvider
extends Provider
{

	private static final String PROVIDER_NAME = "VistaImagingIndexTermDataSource";
	private static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = 		
		"backed by a VistA data store.";

	private static final long serialVersionUID = 1L;
	
	private final SortedSet<ProviderService> services;
	@SuppressWarnings("unused")
	private final static Logger logger = Logger.getLogger(VistaImagingIndexTermDataSourceProvider.class);

	/**
	 * The public "nullary" constructor that is used by the ServiceLoader class
	 * to create instances.
	 */
	public VistaImagingIndexTermDataSourceProvider()
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}
	
	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	private VistaImagingIndexTermDataSourceProvider(String name, double version, String info)
	{
		super(name, version, info);

		services = new TreeSet<ProviderService>();
		
		services.add(
				new ProviderService(
					this,
					IndexTermDataSourceSpi.class,
					VistaImagingIndexTermDataSourceService.SUPPORTED_PROTOCOL,
					1.0F,
					VistaImagingIndexTermDataSourceService.class)
				);
	}
	

	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}
}
