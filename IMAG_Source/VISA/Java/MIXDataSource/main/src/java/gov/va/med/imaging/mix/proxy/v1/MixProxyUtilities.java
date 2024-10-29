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
package gov.va.med.imaging.mix.proxy.v1;

import java.util.SortedSet;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.exchange.business.Site;
// import gov.va.med.imaging.proxy.ids.IDSOperation;
// import gov.va.med.imaging.proxy.ids.IDSProxy;
// import gov.va.med.imaging.proxy.ids.IDSService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration;

/**
 * Common utilities for all Exchange data sources
 * 
 * @author VHAISWWERFEJ
 *
 */
public class MixProxyUtilities 
{
	
//	private final static IDSProxy versionProxy = new IDSProxy();
	private final static Logger logger = Logger.getLogger(MixProxyUtilities.class);
	
	
	public static boolean isMixSiteServiceAvailable(Site site, String serviceName, String datasourceVersion)
	{
//		// get the service from the IDS on the remote web app
//		SortedSet<IDSService> services = versionProxy.getImagingServices(site, serviceName, datasourceVersion);
//		// if nothing is returned, then there are no facades to service this version
//		if((services == null) || (services.size() <= 0))
//			return false;
//		IDSService service = services.first();
//		IDSOperation imageOperation = service.getOperationByType(IDSOperation.IDS_OPERATION_IMAGE);
//		IDSOperation metadataOperation = service.getOperationByType(IDSOperation.IDS_OPERATION_METADATA);
//		if((imageOperation == null) || (metadataOperation == null))
//		{
//			logger.error("Missing an IDS operation (" + (imageOperation == null ? "image" : "metadata") + " null for site [" + site.getSiteNumber() + "]");
//			return false;
//		}	
		return true;
	}
	
	public static MixProxyServices getMixProxyServices(MIXSiteConfiguration siteConfiguration,  
			String siteNumber, String serviceName, String datasourceVersion, 
			String host, int port, String alienSiteNumber)
	{
		// TODO no IDS in DAS: implant DAS MIX services for good here and return them
		// ****
		// get the service from the IDS on the remote web app
//		SortedSet<IDSService> services = versionProxy.getImagingServices(siteNumber, 
//				host, port, serviceName, datasourceVersion);
//		// if nothing is returned, then there are no facades to service this version
//		if((services == null) || (services.size() <= 0))
//		{
//			logger.warn("Got null services back from IDS service for site [" + siteNumber + "], indicates remote site does not have a VIX. Cannot use Federation for this site");
//			return null;
//		}
//		IDSService service = services.first();
		
		MixProxyServices proxyServices = new MixProxyServices(alienSiteNumber);		
		proxyServices.add(new MixProxyService(siteConfiguration, host, port, ProxyServiceType.metadata, true)); // pass 1 level 1
		proxyServices.add(new MixProxyService(siteConfiguration, host, port, ProxyServiceType.metadata, false)); // pass 1 level 2
		proxyServices.add(new MixProxyService(siteConfiguration, host, port, ProxyServiceType.image, true)); // pass 2 TN
		proxyServices.add(new MixProxyService(siteConfiguration, host, port, ProxyServiceType.image, false)); // pass 2 REF/DIAG
		
//		for(IDSOperation operation : service.getOperations())
//		{
//			proxyServices.add(new MixProxyService(siteConfiguration, service, operation, host, port));
//		}
//		
		return proxyServices;
	}
	

}
