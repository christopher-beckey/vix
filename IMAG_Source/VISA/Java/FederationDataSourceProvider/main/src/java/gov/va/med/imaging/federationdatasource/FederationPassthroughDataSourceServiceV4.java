/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 21, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.federationdatasource;

import java.io.IOException;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;
import gov.va.med.imaging.federation.proxy.v4.FederationRestPassthroughProxyV4;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationPassthroughDataSourceServiceV4 
extends AbstractFederationPassthroughDataSourceService 
{
	private final static String DATASOURCE_VERSION = "4";
	private FederationRestPassthroughProxyV4 proxy = null;	
	
	/**
	 * 
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException if the ResolvedArtifactSource is not an instance of ResolvedSite
	 */
	public FederationPassthroughDataSourceServiceV4(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.AbstractFederationPassthroughDataSourceService#getDataSourceVersion()
	 */
	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}
	
	@Override
	public String executePassthroughMethod(RoutingToken globalRoutingToken, PassthroughInputMethod method)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationPassthroughDataSourceServiceV4.executePassthroughMethod() -->  Given method [{}], transaction Id [{}]", method, TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationPassthroughDataSourceServiceV4.executePassthroughMethod() --> Error executing passthrough method [" + method + "]: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		return getProxy().executePassthroughMethod(globalRoutingToken, method);	
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.PassthroughDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() 
	{
		if(getFederationProxyServices() == null)
		{
			getLogger().debug("FederationPassthroughDataSourceServiceV4.isVersionCompatible() --> No FederationProxyServices.  Return false.");
			return false;
		}
		
		ProxyServiceType serviceType = ProxyServiceType.metadata;
		String siteNumber = getSite().getSiteNumber();
		
		try
		{

            getLogger().debug("FederationPassthroughDataSourceServiceV4.isVersionCompatible() --> Found FederationProxyServices, looking for [{}] service type at site number [{}]", serviceType, siteNumber);
			getFederationProxyServices().getProxyService(serviceType);
            getLogger().debug("FederationPassthroughDataSourceServiceV4.isVersionCompatible() --> Found service type [{}] at site number [{}], returning true for version compatible.", serviceType, siteNumber);
			return true;
		}
		catch(gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("FederationPassthroughDataSourceServiceV4.isVersionCompatible() --> Return false. Cannot find proxy service type [{}] at site number [{}]", serviceType, siteNumber);
			return false;
		}
	}
	
	protected FederationRestPassthroughProxyV4 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationPassthroughDataSourceServiceV4.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestPassthroughProxyV4(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}
}
