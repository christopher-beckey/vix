/**
 * 
 */
package gov.va.med.imaging.muse.proxy;

import gov.va.med.imaging.muse.DefaultMuseValues;
import gov.va.med.imaging.muse.webservices.rest.endpoints.MuseRestUri;
import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.services.AbstractProxyService;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;

/**
 * @author William Peterson
 *
 */
public class MuseProxyService 
extends AbstractProxyService 
implements ProxyService {

	public MuseProxyService(MuseConfiguration museConfiguration, MuseServerConfiguration museServer, String host, 
			int port, ProxyServiceType proxyServiceType)
	{
		super();
		this.applicationPath = museConfiguration.getMuseApplicationName();
		this.host = host;
		this.port = port;
		this.credentials = museServer.getPassword();
		this.uid = museServer.getUsername();
		this.proxyServiceType = proxyServiceType;
		if(proxyServiceType == ProxyServiceType.image)
		{
			this.operationPath = (String) MuseRestUri.ImagePath;
			this.protocol = museServer.getProtocol();
		}
		else if(proxyServiceType == ProxyServiceType.metadata)
		{
			this.operationPath = (String) MuseRestUri.patientArtifactsPath;
			this.protocol = museServer.getProtocol();
		}
	}
	
	
}
