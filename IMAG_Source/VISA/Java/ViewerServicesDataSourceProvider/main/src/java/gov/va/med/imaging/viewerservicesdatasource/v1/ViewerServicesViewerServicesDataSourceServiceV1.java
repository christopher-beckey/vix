/**
 * 
 */
package gov.va.med.imaging.viewerservicesdatasource.v1;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.url.viewerservices.ViewerServicesConnection;
import gov.va.med.imaging.viewerservices.proxy.rest.v1.ViewerServicesViewerServicesRestProxyV1;
import gov.va.med.imaging.viewerservicesdatasource.AbstractViewerServicesViewerServicesDataSourceService;

/**
 * @author William Peterson
 *
 */
public class ViewerServicesViewerServicesDataSourceServiceV1
extends AbstractViewerServicesViewerServicesDataSourceService {

	
	private final static String DATASOURCE_VERSION = "1";
	private ViewerServicesViewerServicesRestProxyV1 proxy = null;

	private final ViewerServicesConnection viewerServicesConnection;

	/**
	 * 
	 */
	public ViewerServicesViewerServicesDataSourceServiceV1(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
		
		viewerServicesConnection = new ViewerServicesConnection(getMetadataUrl());
	}
	
	@Override
	protected String getDataSourceVersion() {
		return DATASOURCE_VERSION;
	}
	
	
	@Override
	protected ViewerServicesViewerServicesRestProxyV1 getProxy(SiteConnection connection)
	throws ConnectionException
	{		
		if(proxy == null)
		{
			ProxyServices proxyServices = getProxyServices(connection);
			if(proxyServices == null)
				throw new ConnectionException("Did not receive any applicable services for site [" + getSite().getSiteNumber() + "]");
			proxy = new ViewerServicesViewerServicesRestProxyV1(proxyServices, connection, false);
		}
		
		return proxy;
		
	}
	
	@Override
	public boolean isVersionCompatible() {
		return true;
	}

	@Override
	public boolean sendViewerPreCacheWorkItems(RoutingToken routingToken, SiteConnection connection,
			List<WorkItem> workItems) 
	throws MethodException, ConnectionException 
	{
		return getProxy(connection).sendViewerPreCacheNotifications(routingToken, connection, workItems);
	}

	
	


}
