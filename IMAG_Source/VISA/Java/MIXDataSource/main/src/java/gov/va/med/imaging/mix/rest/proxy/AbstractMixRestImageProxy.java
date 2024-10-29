package gov.va.med.imaging.mix.rest.proxy;

import java.util.Map;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.mix.proxy.AbstractMixProxy;
import gov.va.med.imaging.mix.proxy.IMixProxy;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;
import gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration;
import gov.va.med.imaging.url.mix.exceptions.MIXConfigurationException;
import gov.va.med.imaging.proxy.rest.RestProxyCommon;
// import gov.va.med.imaging.mix.webservices.rest.endpoints.MixImageWADORestUri;
import gov.va.med.imaging.mix.webservices.rest.endpoints.MixRestUri;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;

/**
 * @author vacotittoc
 *
 */
public abstract class AbstractMixRestImageProxy 
extends AbstractMixProxy 
implements IMixProxy 
{	
	protected Logger getLogger()
	{
		return logger;
	}
	
	public AbstractMixRestImageProxy(ProxyServices proxyServices, 
			MIXConfiguration mixConfiguration)
	{
		super(proxyServices, mixConfiguration);
	}
	
	protected String getRestServicePath()
	{
		return MixRestUri.mixRestUriV1;
	}
	
	protected ProxyServiceType getProxyServiceType()
	{
		return ProxyServiceType.image;
	}

	public String getWebResourceUrl(String methodUri, Map<String, String> urlParameterKeyValues) // was protected...
	throws ConnectionException
	{
		StringBuilder url = new StringBuilder();
		//url.append("https://das-xxx.va.gov:443/haims/");
//		url.append(proxyServices.getProxyService(getProxyServiceType()).getConnectionURL()); // protocol://FQDN:port
		url.append(MIXConfiguration.defaultMIXProtocol + "://");
		boolean gotConfig = false;
		try
		{
			if ((this.mixConfiguration != null) &&
				(this.mixConfiguration.getSiteConfiguration(MIXConfiguration.DEFAULT_DAS_SITE, MIXConfiguration.DEFAULT_DAS_SITE) != null)) {
				MIXSiteConfiguration mixSiteConfig = this.mixConfiguration.getSiteConfiguration(MIXConfiguration.DEFAULT_DAS_SITE, MIXConfiguration.DEFAULT_DAS_SITE);
				url.append(mixSiteConfig.getHost() + ":" + mixSiteConfig.getPort() + "/" + mixSiteConfig.getMixApplication() + "/");
				gotConfig=true;
			}
		} catch(MIXConfigurationException mce) {
		}
		if (!gotConfig) {
			getLogger().debug("MIXClient WARNING: Using hardcoded DOD Configuration!!!");
			url.append(MIXConfiguration.defaultDODImageHost + ":"+ MIXConfiguration.defaultDODImagePort + "/" + MIXConfiguration.defaultDODXChangeApplication);
		}
		url.append(getRestServicePath());
		url.append("/");
		url.append(RestProxyCommon.replaceMethodUriWithValues(methodUri, urlParameterKeyValues));

        getLogger().debug("MIXClient WebResourceUrl: {}", url.toString());
		return url.toString();
	}
}
