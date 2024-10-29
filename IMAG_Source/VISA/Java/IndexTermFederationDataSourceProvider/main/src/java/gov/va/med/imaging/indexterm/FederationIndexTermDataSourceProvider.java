package gov.va.med.imaging.indexterm;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;
import gov.va.med.imaging.indexterm.datasource.IndexTermDataSourceSpi;
import gov.va.med.imaging.indexterm.federationdatasource.v10.FederationIndexTermDataSourceServiceV10;

public class FederationIndexTermDataSourceProvider 
extends Provider 
{
	private static final String PROVIDER_NAME = "FederationIndexTermDataSource";
	private static final double PROVIDER_VERSION = 10.0d;
	private static final String PROVIDER_INFO = "Implements: \nIndexTermDataSource \n backed by a Federation data store.";

	private static final long serialVersionUID = 1L;
	private final SortedSet<ProviderService> services;

	/**
	 * The public "nullary" constructor that is used by the ServiceLoader class
	 * to create instances.
	 */
	public FederationIndexTermDataSourceProvider()
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
	private FederationIndexTermDataSourceProvider(String name, double version, String info)
	{
		super(name, version, info);

		services = new TreeSet<ProviderService>();

		services.add(
			new ProviderService(
				this, 
				IndexTermDataSourceSpi.class,
				FederationIndexTermDataSourceServiceV10.SUPPORTED_PROTOCOL,
				10.0F,
				FederationIndexTermDataSourceServiceV10.class)
		);
			
	}

	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}

}
