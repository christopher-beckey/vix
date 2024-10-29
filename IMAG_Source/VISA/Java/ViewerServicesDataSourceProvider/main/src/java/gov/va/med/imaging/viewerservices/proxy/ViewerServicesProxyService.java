/**
 * 
 */
package gov.va.med.imaging.viewerservices.proxy;

import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.proxy.services.AbstractProxyService;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.viewerservices.common.DefaultViewerServicesValues;
import gov.va.med.imaging.viewerservices.common.webservices.rest.endpoints.ViewerServicesRestUri;

import java.util.Locale;

/**
 * @author William Peterson
 *
 */
public class ViewerServicesProxyService 
extends AbstractProxyService 
implements ProxyService {

	public ViewerServicesProxyService(SiteConnection siteConnection, String siteNumber, ProxyServiceType proxyServiceType)
	{
		super();
		this.applicationPath = ViewerServicesRestUri.ApplicationPath;
		this.host = siteConnection.getServer();
		this.port = siteConnection.getPort();
		this.credentials = null;
		this.uid = null;
		this.proxyServiceType = proxyServiceType;
		if(proxyServiceType == ProxyServiceType.metadata)
		{
			this.operationPath = (String) ViewerServicesRestUri.PreCachingUri;
			
			if (siteConnection.getProtocol() == null)
			{
				this.protocol = DefaultViewerServicesValues.defaultProtocol;
			}
			else if(siteConnection.getProtocol().equalsIgnoreCase(SiteConnection.siteConnectionVVSS))
			{
				this.protocol = "https";
			}
			else if(siteConnection.getProtocol().equalsIgnoreCase(SiteConnection.siteConnectionVVS))
			{
				this.protocol = "http";
			}
			else if(siteConnection.getProtocol().toLowerCase(Locale.ENGLISH).startsWith("http"))
			{
				this.protocol = siteConnection.getProtocol();
			}
			else
			{
				this.protocol = DefaultViewerServicesValues.defaultProtocol;
			}
		
		}
	}

}
