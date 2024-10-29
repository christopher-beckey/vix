/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 22, 2017
  Developer:  VHAISLTJAHJB
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
package gov.va.med.imaging.federationdatasource.v8;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.federation.proxy.FederationProxyService;
import gov.va.med.imaging.federation.proxy.v8.FederationRestImageAccessLoggingProxyV8;
import gov.va.med.imaging.federationdatasource.v7.FederationImageAccessLoggingDataSourceServiceV7;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.federation.proxy.FederationProxyUtilities;

/**
 * @author VHAISLTJAHJB
 *
 */
public class FederationImageAccessLoggingDataSourceServiceV8
extends FederationImageAccessLoggingDataSourceServiceV7
{
	private final static String DATASOURCE_VERSION = "8";
	private FederationRestImageAccessLoggingProxyV8 proxy = null;
	private ProxyServices federationProxyServices = null;

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationImageAccessLoggingDataSourceServiceV8(
			ResolvedArtifactSource resolvedArtifactSource, String protocol)
			throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.AbstractFederationImageAccessLoggingDataSourceService#getDataSourceVersion()
	 */
	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.FederationImageAccessLoggingDataSourceServiceV4#getProxyServiceType()
	 */
	@Override
	protected ProxyServiceType getProxyServiceType()
	{
		return ProxyServiceType.imageAccessLogging;
	}

	@Override
	protected FederationRestImageAccessLoggingProxyV8 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getCurrentFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("Did not receive any applicable services from IDS service for site [" + getSite().getSiteNumber() + "]");
			
			proxy = new FederationRestImageAccessLoggingProxyV8(proxyServices, getFederationConfiguration());
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
	
}
