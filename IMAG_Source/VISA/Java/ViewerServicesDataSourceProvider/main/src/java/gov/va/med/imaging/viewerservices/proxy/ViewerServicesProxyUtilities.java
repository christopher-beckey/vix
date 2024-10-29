package gov.va.med.imaging.viewerservices.proxy;

import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;

public class ViewerServicesProxyUtilities {

	public static ProxyServices getProxyServices(SiteConnection siteConnection, String siteNumber, String serviceName, String datasourceVersion)
	{
		String host = siteConnection.getServer();
		int port = siteConnection.getPort();
		String alienSiteNumber = siteNumber;
		
		ViewerServicesProxyServices proxyServices = new ViewerServicesProxyServices(alienSiteNumber);		
		proxyServices.add(new ViewerServicesProxyService(siteConnection, siteNumber, ProxyServiceType.metadata));
		
		return proxyServices;
	}

}
