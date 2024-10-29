/**
 * 
 */
package gov.va.med.imaging.viewerservices.proxy.rest;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.viewerservices.exceptions.ViewerServicesConnectionException;
import gov.va.med.imaging.viewerservices.exceptions.ViewerServicesMethodException;
import gov.va.med.imaging.viewerservices.proxy.IViewerServicesProxy;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractViewerServicesViewerServicesRestProxy 
extends AbstractViewerServicesRestProxy
implements IViewerServicesProxy {

	/**
	 * 
	 */
	public AbstractViewerServicesViewerServicesRestProxy(ProxyServices proxyServices, SiteConnection siteConnection, boolean instanceUrlEscaped) {
		super(proxyServices, siteConnection, instanceUrlEscaped);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseProxy#getDataSourceVersion()
	 */
	@Override
	public String getRestProxyVersion() {
		return null;
	}
	
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.proxy.ImagingProxy#addOptionalGetInstanceHeaders(org.apache.commons.httpclient.methods.GetMethod)
	 */
	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) {
		// TODO Auto-generated method stub

	}

	
	protected String getRestServicePath()
	{
		//WFP-return web service endpoint.
		//return MixRestUri.mixRestUriV1;
		return null;
	}
	
	public ProxyService getProxyService()
	{
		try
		{
			return proxyServices.getProxyService(getProxyServiceType());
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
			return null;
		}
	}

	public ProxyServiceType getProxyServiceType()
	{
		//WFP-not sure if metadata or patient.
		return ProxyServiceType.metadata;
	}
	
	
	private final static String utf8 = "UTF-8"; 
	protected String encodeGai(GlobalArtifactIdentifier gai)
	throws MethodException
	{
		return encodeString(gai.toString(SERIALIZATION_FORMAT.RAW));
	}
	
	protected String encodeString(String value)
	throws MethodException
	{
		try
		{
			return URLEncoder.encode(value, utf8);
		}
		catch(UnsupportedEncodingException ueX)
		{
			throw new MethodException(ueX);
		}
	}

	@Override
	protected void addSecurityContextToHeader(HttpClient client,
			GetMethod getMethod, boolean includeVistaSecurityContext) {
		// TODO Auto-generated method stub
		
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.viewerservices.proxy.IViewerServicesProxy#sendViewerPreCacheNotifications(gov.va.med.RoutingToken, gov.va.med.imaging.exchange.business.SiteConnection, java.util.List)
	 */
	@Override
	public boolean sendViewerPreCacheNotifications(RoutingToken routingToken, SiteConnection connection,
			List<WorkItem> workItems) throws ViewerServicesMethodException, ViewerServicesConnectionException {
		throw new ViewerServicesMethodException("Unsupported ViewerServices web service proxy, sendViewerPreCacheNotifications.");
	}

}
