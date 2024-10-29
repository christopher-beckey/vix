/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 8, 2018
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaisltjahjb
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

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.WorkListDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.federation.proxy.FederationProxyUtilities;
import gov.va.med.imaging.federation.proxy.IFederationProxy;
import gov.va.med.imaging.proxy.services.ProxyServices;

import java.util.List;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 *
 */
public abstract class AbstractFederationWorkListDataSourceService
extends AbstractFederationDataSourceService
implements WorkListDataSourceSpi 
{
	private ProxyServices federationProxyServices = null;
	protected final static String FEDERATION_PROXY_SERVICE_NAME = "Federation";
	
	public final static String SUPPORTED_PROTOCOL = "vftp";
	
	private final static Logger logger = Logger.getLogger(AbstractFederationImageDataSourceService.class);
	
	protected abstract String getDataSourceVersion();
	
	protected abstract IFederationProxy getFederationProxy()
	throws ConnectionException;
	
	/**
	 * 
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException if the ResolvedArtifactSource is not an instance of ResolvedSite
	 */
	public AbstractFederationWorkListDataSourceService(
		ResolvedArtifactSource resolvedArtifactSource,
		String protocol)
	throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}

	/**
	 * The artifact source must be checked in the constructor to assure that it is an instance
	 * of ResolvedSite.
	 * 
	 * @return
	 */
	protected ResolvedSite getResolvedSite()
	{
		return (ResolvedSite)getResolvedArtifactSource();
	}
	
	protected Site getSite()
	{
		return getResolvedSite().getSite();
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() 
	{
		if(getFederationProxyServices() == null)
			return false;		
		return true;
	}
	
	protected String getFederationProxyName()
	{
		return FEDERATION_PROXY_SERVICE_NAME;
	}
	
	/**
	 * Returns the proxy services available, if none are available then null is returned
	 */
	protected ProxyServices getFederationProxyServices()
	{
		if(federationProxyServices == null)
		{
			federationProxyServices = 
				FederationProxyUtilities.getFederationProxyServices(getSite(), 
						getFederationProxyName(), getDataSourceVersion());
		}
		return federationProxyServices;
	}
	
	
	protected Logger getLogger()
	{
		return logger;
	}

}
