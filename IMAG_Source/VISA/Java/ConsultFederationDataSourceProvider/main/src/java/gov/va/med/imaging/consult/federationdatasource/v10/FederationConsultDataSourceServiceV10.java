package gov.va.med.imaging.consult.federationdatasource.v10;

import java.io.IOException;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.consult.ConsultFederationProxyServiceType;
import gov.va.med.imaging.consult.federation.proxy.v10.FederationRestConsultProxyV10;
import gov.va.med.imaging.consult.federationdatasource.AbstractFederationConsultDataSourceService;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityException;
import gov.va.med.imaging.federation.proxy.FederationProxyUtilities;
import gov.va.med.imaging.federationdatasource.FederationDataSourceProvider;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author William Peterson
 *
 */

public class FederationConsultDataSourceServiceV10 
extends AbstractFederationConsultDataSourceService 
{

	private final VftpConnection federationConnection;
		
	private final static String DATASOURCE_VERSION = "10";
	public final static String SUPPORTED_PROTOCOL = "vftp";
			
	private FederationRestConsultProxyV10 proxy = null;
	private ProxyServices federationProxyServices = null;


	public FederationConsultDataSourceServiceV10(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getArtifactUrl());
	}

	@Override
	public String getDataSourceVersion() {
		return DATASOURCE_VERSION;
	}
	
	private FederationRestConsultProxyV10 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getCurrentFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("Did not receive any applicable services from IDS service for site [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestConsultProxyV10(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
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
		return new ConsultFederationProxyServiceType();
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
	public List<Consult> getPatientConsults(RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier)
			throws MethodException, ConnectionException {
        getLogger().info("getPatientConsults TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting information.", ioX);
			throw new FederationConnectionException(ioX);
		}
		return getProxy().getPatientConsults(globalRoutingToken, patientIdentifier);		
	}
	


}
