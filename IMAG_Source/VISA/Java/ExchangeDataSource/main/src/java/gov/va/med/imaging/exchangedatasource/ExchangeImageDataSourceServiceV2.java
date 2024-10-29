/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 8, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.exchangedatasource;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.proxy.ExchangeProxy;
import gov.va.med.imaging.exchange.proxy.v2.ImageXChangeProxyV2;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;

import java.io.IOException;
import java.util.HashMap;

/**
 * @author vhaiswwerfej
 *
 */
public class ExchangeImageDataSourceServiceV2
extends AbstractExchangeImageDataSourceService
{
	private final static String DATASOURCE_VERSION = "2";
	
	// Hashmap to hold proxies based on the alien site number (if empty string, will return proxy to BIA), otherwise will use wormhole.
	private HashMap<String, ImageXChangeProxyV2> xchangeProxies = new HashMap<String, ImageXChangeProxyV2>();
	
	/**
     * The Provider will use the create() factory method preferentially
     * over a constructor.  This allows for caching of VistaStudyGraphDataSourceService
     * instances according to the criteria set here.
     * 
     * @param url
     * @param site
     * @return
     * @throws ConnectionException
     * @throws UnsupportedProtocolException 
     */
    public static ExchangeImageDataSourceServiceV2 create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
    throws ConnectionException, UnsupportedProtocolException
    {
    	return new ExchangeImageDataSourceServiceV2(resolvedArtifactSource, protocol);
    }
    
    /**
     * 
     * @param resolvedArtifactSource
     * @param protocol
     * @throws UnsupportedProtocolException if the ResolvedArtifactSource is not an instance of ResolvedSite
     */
	public ExchangeImageDataSourceServiceV2(ResolvedArtifactSource resolvedArtifactSource, String protocol) 
	throws UnsupportedProtocolException
	{
		super(resolvedArtifactSource, protocol);
	}

	@Override
	protected ExchangeProxy getProxy(Image image) 
	throws IOException
	{
		String alienSiteNumber = null;
		if((image != null) && (image.getAlienSiteNumber() != null))
		{
			alienSiteNumber = image.getAlienSiteNumber();
			if(xchangeProxies.containsKey(alienSiteNumber))
			{
				return xchangeProxies.get(alienSiteNumber);
			}			
		}
		// If the proxy was not in the cache then create a new one
		// get the services for this site, pass in the alien site number from the image (null if the image is null or not in the image)
		// getExchangeProxyServices() will find the configuration for the alien site if there is one
		// if there is an alien site, then the host and port will be specified in the configuration for the alien site.
		// if the host and port are specified in the alien site configuration, then that server and port will be used
		// this code does NOT support falling back to the non-alien configuration if the alien configuration fails		
		
		// JMW 3/14/2011 Pass null for the Site object, its only needed within the proxy 
		ImageXChangeProxyV2 proxy = new ImageXChangeProxyV2(getExchangeProxyServices(alienSiteNumber), 
				ExchangeDataSourceProvider.getExchangeConfiguration());
		
		xchangeProxies.put(alienSiteNumber, proxy);	
		
		return proxy;
	}

	@Override
	public boolean isVersionCompatible() 
	throws SecurityException
	{
		ProxyServiceType serviceType = ProxyServiceType.image;
		String siteSource = getResolvedArtifactSourceString();
		
		try
		{
			// unfortunately this checks if the primary site is version compatible, not the alien site we might talk to
			// not really sure how to fix that since we can't get to the alien site without having an image object
			// might need to fall back to primary site if alien site fails when we actually go to get the image
			ProxyServices proxyServices = getExchangeProxyServices(null);	
			if(proxyServices == null)
			{
                getLogger().warn("ExchangeImageDataSourceServiceV2.isVersionCompatible() --> Got null proxy service back, indicates site [{}] for version [" + DATASOURCE_VERSION + "] is not version compatible.", siteSource);
				return false;
			}
			proxyServices.getProxyService(serviceType);
		}
		catch(IOException ioX)
		{
            getLogger().warn("ExchangeImageDataSourceServiceV2.isVersionCompatible() --> Error finding proxy services from site [{}]", siteSource);
			return false;
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("ExchangeImageDataSourceServiceV2.isVersionCompatible() --> Could not find proxy service type [{}] from site [{}]", serviceType, siteSource);
		}
		
		return true;
	}

	@Override
	protected String getDataSourceVersion()
	{
		return DATASOURCE_VERSION;
	}	
}
