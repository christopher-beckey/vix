/**
 * 
 */
package gov.va.med.imaging.federationdatasource.v6;

import java.io.IOException;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.federation.proxy.v6.FederationRestExternalPackageProxyV6;
import gov.va.med.imaging.federationdatasource.v5.FederationExternalPackageDataSourceServiceV5;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;

/**
 * @author William Peterson
 *
 */
public class FederationExternalPackageDataSourceServiceV6 extends
		FederationExternalPackageDataSourceServiceV5 {

	private final static String DATASOURCE_VERSION = "6";
	private FederationRestExternalPackageProxyV6 proxy;


	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationExternalPackageDataSourceServiceV6(ResolvedArtifactSource resolvedArtifactSource, String protocol)
			throws UnsupportedOperationException 
	{	
		super(resolvedArtifactSource, protocol);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.AbstractFederationExternalPackageDataSourceService#getDataSourceVersion()
	 */
	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}

	@Override
	protected FederationRestExternalPackageProxyV6 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationExternalPackageDataSourceServiceV6.getProxy() --> Did not receive any applicable services from IDS service for site [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestExternalPackageProxyV6(proxyServices, getFederationConfiguration());
		}
		return proxy;
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.AbstractFederationExternalPackageDataSourceService#postStudiesFromCprsIdentifiers(gov.va.med.RoutingToken, gov.va.med.PatientIdentifier, java.util.List)
	 */
	@Override
	public List<Study> postStudiesFromCprsIdentifiers(
			RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier,
			List<CprsIdentifier> cprsIdentifiers) 
			throws MethodException, ConnectionException 
	{
        getLogger().info("FederationExternalPackageDataSourceServiceV6.postStudiesFromCprsIdentifiers() --> Transaction Id [{}]", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationExternalPackageDataSourceServiceV6.postStudiesFromCprsIdentifiers() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		return getProxy().postStudiesFromCprsIdentifiers(globalRoutingToken, patientIdentifier, cprsIdentifiers);		
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.PassthroughDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() 
	{
		if(getFederationProxyServices() == null)
			return false;		
		
		ProxyServiceType serviceType = ProxyServiceType.externalpackage;
		String siteNumber = getSite().getSiteNumber();
		
		try
		{
            getLogger().debug("FederationExternalPackageDataSourceServiceV6.isVersionCompatible() --> Found FederationProxyServices, looking for [{}] service type at site number [{}]", serviceType, siteNumber);
			getFederationProxyServices().getProxyService(serviceType);
            getLogger().debug("FederationExternalPackageDataSourceServiceV6.isVersionCompatible() --> Found service type [{}] at site [{}], returning true for version compatible.", serviceType, siteNumber);
			return true;
		}
		catch(gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("FederationExternalPackageDataSourceServiceV6.isVersionCompatible() --> Cannot find proxy service type [{}] at site number [{}]", serviceType, siteNumber);
			return false;
		}
	}
}
