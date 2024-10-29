/**
 * 
 */
package gov.va.med.imaging.viewerservicesdatasource;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.ViewerServicesDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.viewerservices.proxy.IViewerServicesProxy;
import gov.va.med.imaging.viewerservices.proxy.ViewerServicesProxyUtilities;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractViewerServicesViewerServicesDataSourceService
extends AbstractViewerServicesDataSourceService 
implements ViewerServicesDataSourceSpi {

	/**
	 * 
	 */
	public AbstractViewerServicesViewerServicesDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
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
	 * @see gov.va.med.imaging.datasource.ExternalPackageDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() 
	{
		return true;
	}	


	protected abstract IViewerServicesProxy getProxy(SiteConnection connection)
	throws ConnectionException;

	
	@Override
	protected ProxyServices getProxyServices(SiteConnection connection)
	{
		if(ViewerServicesProxyServices == null)
		{
			ViewerServicesProxyServices = 
				ViewerServicesProxyUtilities.getProxyServices(
						connection, getSite().getSiteNumber(), 
						getProxyName(), getDataSourceVersion());
		
		}
		return ViewerServicesProxyServices;
	}


	@Override
	protected String getDataSourceVersion() {
		return null;
	}

	@Override
	public boolean sendViewerPreCacheWorkItems(RoutingToken routinToken, SiteConnection connection,
			List<WorkItem> workItems) throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(ViewerServicesDataSourceSpi.class, "sendViewerPreCacheWorkItems");
	}
}
