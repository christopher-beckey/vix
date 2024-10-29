/**
 * 
 */
package gov.va.med.imaging.muse.proxy;

import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;

/**
 * @author William Peterson
 *
 */
public class MuseProxyUtilities {
		
	public static ProxyServices getProxyServices(MuseConfiguration museConfiguration, MuseServerConfiguration museServer, 
			String siteNumber, String serviceName, String datasourceVersion)
	{
		String host = museServer.getHost();
		int port = new Integer(museServer.getPort()).intValue();
		String alienSiteNumber = museServer.getMuseSiteNumber();
		
		MuseProxyServices proxyServices = new MuseProxyServices(alienSiteNumber);		
		proxyServices.add(new MuseProxyService(museConfiguration, museServer, host, port, ProxyServiceType.metadata));
		proxyServices.add(new MuseProxyService(museConfiguration, museServer, host, port, ProxyServiceType.image));
		
		return proxyServices;
	}


}
