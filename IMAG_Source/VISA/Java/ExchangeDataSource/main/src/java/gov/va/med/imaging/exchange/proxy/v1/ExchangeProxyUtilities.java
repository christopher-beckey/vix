/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 8, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.exchange.proxy.v1;

import java.util.SortedSet;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.proxy.ids.IDSOperation;
import gov.va.med.imaging.proxy.ids.IDSProxy;
import gov.va.med.imaging.proxy.ids.IDSService;
import gov.va.med.imaging.url.exchange.configuration.ExchangeSiteConfiguration;

/**
 * Common utilities for all Exchange data sources
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ExchangeProxyUtilities 
{
	
	private final static IDSProxy versionProxy = new IDSProxy();
	private final static Logger LOGGER = Logger.getLogger(ExchangeProxyUtilities.class);
	
	
	public static boolean isExchangeSiteServiceAvailable(Site site, String serviceName, String datasourceVersion)
	{
		// get the service from the IDS on the remote web app
		SortedSet<IDSService> services = versionProxy.getImagingServices(site, serviceName, datasourceVersion);
		// if nothing is returned, then there are no facades to service this version
		if((services == null) || (services.size() <= 0))
			return false;
		IDSService service = services.first();
		IDSOperation imageOperation = service.getOperationByType(IDSOperation.IDS_OPERATION_IMAGE);
		IDSOperation metadataOperation = service.getOperationByType(IDSOperation.IDS_OPERATION_METADATA);
		if((imageOperation == null) || (metadataOperation == null))
		{
            LOGGER.warn("ExchangeProxyUtilities.isExchangeSiteServiceAvailable() --> Missing an IDS operation [{}] null for site [{}]", imageOperation == null ? "image" : "metadata", site.getSiteNumber());
			return false;
		}	
		return true;
	}
	
	public static ExchangeProxyServices getExchangeProxyServices(ExchangeSiteConfiguration siteConfiguration,  
			String siteNumber, String serviceName, String datasourceVersion, 
			String host, int port, String alienSiteNumber)
	{
		// get the service from the IDS on the remote web app
		SortedSet<IDSService> services = versionProxy.getImagingServices(siteNumber, 
				host, port, serviceName, datasourceVersion);
		// if nothing is returned, then there are no facades to service this version
		if((services == null) || (services.size() <= 0))
		{
            LOGGER.warn("ExchangeProxyUtilities.getExchangeProxyServices() --> Got null services back from IDS service for site [{}], indicates remote site does not have a VIX. Cannot use Federation for this site", siteNumber);
			return null;
		}
		
		IDSService service = services.first();
		
		ExchangeProxyServices proxyServices = new ExchangeProxyServices(alienSiteNumber);		
		
		for(IDSOperation operation : service.getOperations())
		{
			proxyServices.add(new ExchangeProxyService(siteConfiguration, service, operation, host, port));
		}
		
		return proxyServices;
	}
}
