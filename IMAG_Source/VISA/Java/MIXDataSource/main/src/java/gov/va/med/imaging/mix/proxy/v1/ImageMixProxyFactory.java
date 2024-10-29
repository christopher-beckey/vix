/**
 * 
 */
package gov.va.med.imaging.mix.proxy.v1;

import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;
import gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration;

/**
 * This factory should eventually implements some pooling, once we figure out that is safe to reuse
 * proxy instances.
 * 
 * 
 * @author vhaiswbeckec
 *
 */
public class ImageMixProxyFactory 
{
	private static ImageMixProxyFactory singleton;
	public static synchronized ImageMixProxyFactory getSingleton()
	{
		if(singleton == null)
			singleton = new ImageMixProxyFactory();
		
		return singleton;
	}
	
	/**
	 * @see gov.va.med.imaging.proxy.ImagingProxyPool#create(gov.va.med.imaging.proxy.ConnectionParameters, gov.va.med.imaging.proxy.ConnectionParameters)
	 */
	/*
	private ImageXChangeProxy create(
		ConnectionParameters metadataParameters,
		ConnectionParameters imageXferParameters)
	{
		return
			metadataParameters == null && imageXferParameters == null ?
			new ImageXChangeProxy() :
			new ImageXChangeProxy(metadataParameters, imageXferParameters);
	}*/

	/*
	public ImageXChangeProxy get(
			ConnectionParameters metadataParameters,
			ConnectionParameters imageXferParameters)
	{
		return create(metadataParameters, imageXferParameters);
	}*/

	public void release(ImageMixProxy proxy)
	{
		
	}
	
	public ImageMixProxy get(String host, int port, 
			MIXSiteConfiguration siteConfiguration,
			String alienSiteNumber, MIXConfiguration mixConfiguration)
	{
		ProxyServices proxyServices = new ProxyServices();
		proxyServices.add(new MixProxyService(siteConfiguration, host, port, ProxyServiceType.image, true));
		proxyServices.add(new MixProxyService(siteConfiguration, host, port, ProxyServiceType.image, false));
		proxyServices.add(new MixProxyService(siteConfiguration, host, port, ProxyServiceType.metadata, true));
		proxyServices.add(new MixProxyService(siteConfiguration, host, port, ProxyServiceType.metadata, false));
		
		/*
		ConnectionParameters imageParameters = new ConnectionParameters(ImageXChangeProxy.defaultImageProtocol, 
				host, port, siteConfiguration.getXChangeApplication(), siteConfiguration.getImagePath(), 
				siteConfiguration.getUsername(), siteConfiguration.getPassword());
		ConnectionParameters metadataParameters = new ConnectionParameters(ImageXChangeProxy.defaultImageProtocol, 
				host, port, siteConfiguration.getXChangeApplication(), siteConfiguration.getMetadataPath(), 
				siteConfiguration.getUsername(), siteConfiguration.getPassword());
				*/		
		//return new ImageXChangeProxy(metadataParameters, imageParameters);
		return new ImageMixProxy(proxyServices, alienSiteNumber, mixConfiguration);
	}
	
	/*
	public ImageXChangeProxyV2 getV2(String host, int port, 
			ExchangeSiteConfiguration siteConfiguration, IDSService idsService, IDSOperation idsOperation,
			Site site)
	{
		ProxyServices proxyServices = new ProxyServices();
		proxyServices.add(new ExchangeProxyService(siteConfiguration, host, port, ProxyServiceType.image));
		proxyServices.add(new ExchangeProxyService(siteConfiguration, host, port, ProxyServiceType.metadata));
		
			
		//return new ImageXChangeProxy(metadataParameters, imageParameters);
		return new ImageXChangeProxyV2(proxyServices, site);
	}*/
	
	/*
	public ImageXChangeProxy get(Site site, String host, int port, String uid, Object credentials) {
		ConnectionParameters imageParameters = null;
		ConnectionParameters metadataParameters = null;
		if(ExchangeUtil.isSiteDOD(site))
		{
			imageParameters = ImageXChangeProxy.createDODImageConnectionParameters(host, port, uid, credentials);
			metadataParameters = ImageXChangeProxy.createDODMetadataConnectionParameters(host, port, uid, credentials);
		}
		else
		{
			imageParameters = ImageXChangeProxy.createVAImageConnectionParameters(host, port, uid, credentials);
			metadataParameters = ImageXChangeProxy.createVAMetadataConnectionParameters(host, port, uid, credentials);
		}
		return new ImageXChangeProxy(metadataParameters, imageParameters);
	}
	*/
}
