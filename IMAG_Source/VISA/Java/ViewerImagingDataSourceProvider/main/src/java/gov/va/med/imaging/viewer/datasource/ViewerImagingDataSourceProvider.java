/**
 * 
 * Date Created: Apr 26, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.datasource;

import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 *
 */
public class ViewerImagingDataSourceProvider
extends Provider
{

	private static final String PROVIDER_NAME = "ViewerImagingDataSource";
	private static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = 		
		"backed by a VistA data store.";

	private static final long serialVersionUID = 1L;
	
	private final SortedSet<ProviderService> services;
	@SuppressWarnings("unused")
	private final static Logger logger = Logger.getLogger(ViewerImagingDataSourceProvider.class);

	/**
	 * The public "nullary" constructor that is used by the ServiceLoader class
	 * to create instances.
	 */
	public ViewerImagingDataSourceProvider()
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}
	
	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	private ViewerImagingDataSourceProvider(String name, double version, String info)
	{
		super(name, version, info);
		
		services = new TreeSet<ProviderService>();
		
		services.add(
				new ProviderService(
					this,
					ViewerImagingDataSourceSpi.class,
					ViewerImagingDataSourceService.SUPPORTED_PROTOCOL,
					1.0F,
					ViewerImagingDataSourceService.class)
				);		

		services.add(
				new ProviderService(
					this,
					ViewerImagingCvixDataSourceSpi.class,
					ViewerImagingDataSourceService.SUPPORTED_CVIX_PROTOCOL,
					1.0F,
					ViewerImagingDataSourceService.class)
				);		
	}
	
	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}
	

}
