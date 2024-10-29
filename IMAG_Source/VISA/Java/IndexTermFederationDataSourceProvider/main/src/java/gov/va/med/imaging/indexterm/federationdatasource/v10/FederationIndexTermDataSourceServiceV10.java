package gov.va.med.imaging.indexterm.federationdatasource.v10;

import java.io.IOException;
import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityException;
import gov.va.med.imaging.federation.proxy.FederationProxyUtilities;
import gov.va.med.imaging.federationdatasource.FederationDataSourceProvider;
import gov.va.med.imaging.indexterm.IndexTermFederationProxyServiceType;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.enums.IndexClass;
import gov.va.med.imaging.indexterm.federation.proxy.v10.FederationRestIndexTermProxyV10;
import gov.va.med.imaging.indexterm.federationdatasource.AbstractFederationIndexTermDataSourceService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author William Peterson
 *
 */

public class FederationIndexTermDataSourceServiceV10 
extends AbstractFederationIndexTermDataSourceService 
{

	private final VftpConnection federationConnection;
		
	private final static String DATASOURCE_VERSION = "10";
	public final static String SUPPORTED_PROTOCOL = "vftp";
			
	private FederationRestIndexTermProxyV10 proxy = null;
	private ProxyServices federationProxyServices = null;


	
	public FederationIndexTermDataSourceServiceV10(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getArtifactUrl());
	}

	@Override
	public String getDataSourceVersion() {
		return DATASOURCE_VERSION;
	}
	
	private FederationRestIndexTermProxyV10 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getCurrentFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("Did not receive any applicable services from IDS service for site [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestIndexTermProxyV10(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}
	
	/**
	 * Returns the current version of proxy services, if none are available then null is returned
	 */
	private ProxyServices getCurrentFederationProxyServices()
	{
		if(federationProxyServices == null)
		{
			federationProxyServices = 
				FederationProxyUtilities.getCurrentFederationProxyServices(getSite(), 
						getFederationProxyName(), getDataSourceVersion());
		}
		return federationProxyServices;
	}

	private ProxyServiceType getProxyServiceType()
	{
		//return ProxyServiceType.metadata;
		return new IndexTermFederationProxyServiceType();
	}
	
	@Override
	public boolean isVersionCompatible() 
	throws SecurityException
	{
		if(getFederationProxyServices() == null)			
			return false;
		
		try
		{

            getLogger().debug("Found FederationProxyServices, looking for '{}' service type at site [{}].", getProxyServiceType(), getSite().getSiteNumber());
			getFederationProxyServices().getProxyService(getProxyServiceType());
            getLogger().debug("Found service type '{}' at site [{}], returning true for version compatible.", getProxyServiceType(), getSite().getSiteNumber());
			return true;
		}
		catch(gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("Cannot find proxy service type '{}' at site [{}]", getProxyServiceType(), getSite().getSiteNumber());
			return false;
		}
	}

	@Override
	public List<IndexTermValue> getOrigins(RoutingToken globalRoutingToken)
			throws MethodException, ConnectionException {

        getLogger().info("getOrigins TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}
		return getProxy().getOrigins(globalRoutingToken);		
	}

	@Override
	public List<IndexTermValue> getSpecialties(RoutingToken globalRoutingToken, List<IndexClass> indexClasses,
			List<IndexTermURN> eventUrns) throws MethodException, ConnectionException {
        getLogger().info("getSpecialties TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}
		return getProxy().getSpecialties(globalRoutingToken, indexClasses, eventUrns);		
	}

	@Override
	public List<IndexTermValue> getProcedureEvents(RoutingToken globalRoutingToken, List<IndexClass> indexClasses,
			List<IndexTermURN> specialtyUrns) throws MethodException, ConnectionException {
        getLogger().info("getProcedureEvents TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}
		return getProxy().getProcedureEvents(globalRoutingToken, indexClasses, specialtyUrns);		
	}

	@Override
	public List<IndexTermValue> getTypes(RoutingToken globalRoutingToken, List<IndexClass> indexClasses)
			throws MethodException, ConnectionException {
        getLogger().info("getTypes TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}
		return getProxy().getTypes(globalRoutingToken, indexClasses);		
	}

	@Override
	public void setConfiguration(Object configuration) {
		// TODO Auto-generated method stub
		
	}


}
