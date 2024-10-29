/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Nov 11, 2016
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vacotittoc
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
package gov.va.med.imaging.mixdatasource;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.mix.proxy.MixProxy;
import gov.va.med.imaging.mix.proxy.v1.ImageMixProxyV1;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;

import java.io.IOException;
import java.util.HashMap;

/**
 * @author vacotittoc
 *
 */
public class MixImageDataSourceServiceV1
extends AbstractMixImageDataSourceService
{
	private final static String DATASOURCE_VERSION = "1";
	
	// Hashmap to hold proxies based on the alien site number (if empty string, will return proxy to DAS), otherwise will use wormhole.
	private HashMap<String, ImageMixProxyV1> mixProxies = new HashMap<String, ImageMixProxyV1>();
	
	/**
     * The Provider will use the create() factory method preferentially
     * over a constructor.  This allows for caching of VistaImageDataSourceService
     * instances according to the criteria set here.
     * 
     * @param url
     * @param protocol
     * @return
     * @throws ConnectionException
     * @throws UnsupportedProtocolException 
     */
    public static MixImageDataSourceServiceV1 create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
    throws ConnectionException, UnsupportedProtocolException
    {
    	return new MixImageDataSourceServiceV1(resolvedArtifactSource, protocol);
    }
    
    /**
     * 
     * @param resolvedArtifactSource
     * @param protocol
     * @throws UnsupportedProtocolException if the ResolvedArtifactSource is not an instance of ResolvedSite
     */
	public MixImageDataSourceServiceV1(ResolvedArtifactSource resolvedArtifactSource, String protocol) 
	throws UnsupportedProtocolException
	{
		super(resolvedArtifactSource, protocol);
	}

	@Override
	protected MixProxy getProxy(Image image) 
	throws IOException
	{
		String alienSiteNumber = MIXConfiguration.DEFAULT_DAS_SITE;// null;
		if((image != null) && (image.getAlienSiteNumber() != null))
		{
			alienSiteNumber = image.getAlienSiteNumber();
			if(mixProxies.containsKey(alienSiteNumber))
			{
				return mixProxies.get(alienSiteNumber);
			}			
		}
		// If the proxy was not in the cache then create a new one
		// get the services for this site, pass in the alien site number from the image (null if the image is null or not in the image)
		// getMIXProxyServices() will find the configuration for the alien site if there is one
		// if there is an alien site, then the host and port will be specified in the configuration for the alien site.
		// if the host and port are specified in the alien site configuration, then that server and port will be used
		// this code does NOT support falling back to the non-alien configuration if the alien configuration fails		
		
		// JMW 3/14/2011 Pass null for the Site object, its only needed within the proxy 
		ImageMixProxyV1 proxy = new ImageMixProxyV1(getMixProxyServices(alienSiteNumber), 
				MixDataSourceProvider.getMixConfiguration());
		
		mixProxies.put(alienSiteNumber, proxy);	
		
		return proxy;
	}

	@Override
	public boolean isVersionCompatible() 
	throws SecurityException
	{
		ProxyServiceType serviceType = ProxyServiceType.image;
		try
		{
			// unfortunately this checks if the primary site is version compatible, not the alien site we might talk to
			// not really sure how to fix that since we can't get to the alien site without having an image object
			// might need to fall back to primary site if alien site fails when we actually go to get the image
			// cpt: override null with alien site number -- to prevent nullpointer exception in MIXConfiguration.getSiteConfiguration(primSite, secSite)
			ProxyServices proxyServices = getMixProxyServices(MIXConfiguration.DEFAULT_DAS_SITE); // (null);	
			if(proxyServices == null)
			{
				getLogger().warn("MIXClient got null proxy services back, indicates site '" + MIXConfiguration.DEFAULT_DAS_SITE + "' for version '" + DATASOURCE_VERSION + "' is not version compatible.");
				return false;
			}
			proxyServices.getProxyService(serviceType);
		}
		catch(IOException ioX)
		{
			getLogger().error("MIXClient error finding proxy services from site '" + MIXConfiguration.DEFAULT_DAS_SITE + "'.");
			return false;
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
            getLogger().error("MIXClient could not find proxy service type '{}' from site '" + MIXConfiguration.DEFAULT_DAS_SITE + "'.", serviceType);
		}
		
		return true;
	}

	@Override
	protected String getDataSourceVersion()
	{
		return DATASOURCE_VERSION;
	}	

}
