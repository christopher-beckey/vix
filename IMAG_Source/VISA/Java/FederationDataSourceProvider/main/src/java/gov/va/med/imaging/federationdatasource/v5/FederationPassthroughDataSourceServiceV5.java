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
package gov.va.med.imaging.federationdatasource.v5;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.federation.proxy.v5.FederationRestPassthroughProxyV5;
import gov.va.med.imaging.federationdatasource.v4.FederationPassthroughDataSourceServiceV4;
import gov.va.med.imaging.proxy.services.ProxyServices;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationPassthroughDataSourceServiceV5 
extends FederationPassthroughDataSourceServiceV4 
{
	private final static String DATASOURCE_VERSION = "5";
	private FederationRestPassthroughProxyV5 proxy = null;	
	
	/**
	 * 
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException if the ResolvedArtifactSource is not an instance of ResolvedSite
	 */
	public FederationPassthroughDataSourceServiceV5(ResolvedArtifactSource resolvedArtifactSource, String protocol)
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
	protected FederationRestPassthroughProxyV5 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("Did not receive any applicable services from IDS service for site [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestPassthroughProxyV5(proxyServices, getFederationConfiguration());
		}
		return proxy;
	}

}
