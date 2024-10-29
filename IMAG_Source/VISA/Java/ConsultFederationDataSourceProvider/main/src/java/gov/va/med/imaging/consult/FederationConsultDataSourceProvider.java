package gov.va.med.imaging.consult;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.imaging.consult.datasource.ConsultDataSourceSpi;
import gov.va.med.imaging.consult.federationdatasource.v10.FederationConsultDataSourceServiceV10;
import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;

public class FederationConsultDataSourceProvider 
extends Provider 
{
	private static final String PROVIDER_NAME = "FederationConsultDataSource";
	private static final double PROVIDER_VERSION = 10.0d;
	private static final String PROVIDER_INFO = "Implements: \nConsultDataSource \n backed by a Federation data store.";

	private static final long serialVersionUID = 1L;
	private final SortedSet<ProviderService> services;

	/**
	 * The public "nullary" constructor that is used by the ServiceLoader class
	 * to create instances.
	 */
	public FederationConsultDataSourceProvider()
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}
	
	/**
	 * A special constructor that is only used for creating a configuration
	 * file.
	 * 
	 * @param exchangeConfiguration
	 */
	/*
	private FederationPathologyDataSourceProvider(FederationConfiguration federationConfiguration) 
	{
		this();
		FederationPathologyDataSourceProvider.federationConfiguration = federationConfiguration;
	}*

	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	private FederationConsultDataSourceProvider(String name, double version, String info)
	{
		super(name, version, info);

		services = new TreeSet<ProviderService>();

		services.add(
			new ProviderService(
				this, 
				ConsultDataSourceSpi.class,
				FederationConsultDataSourceServiceV10.SUPPORTED_PROTOCOL,
				10.0F,
				FederationConsultDataSourceServiceV10.class)
		);
			
	}

	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}

	
}
