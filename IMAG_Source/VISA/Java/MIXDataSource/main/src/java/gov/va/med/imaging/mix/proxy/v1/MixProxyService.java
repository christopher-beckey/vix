/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 29, 2009
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
package gov.va.med.imaging.mix.proxy.v1;

import gov.va.med.imaging.proxy.ids.IDSOperation;
import gov.va.med.imaging.proxy.ids.IDSService;
import gov.va.med.imaging.proxy.services.AbstractProxyService;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration;

/**
 * @author vhaiswwerfej
 *
 */
public class MixProxyService 
extends AbstractProxyService 
implements ProxyService 
{
	
	public MixProxyService(MIXSiteConfiguration siteConfiguration, String host, 
			int port, ProxyServiceType proxyServiceType, boolean firstChoice)
	{
		super();
		this.applicationPath = siteConfiguration.getMixApplication();
		this.host = host;
		this.port = port;
		this.credentials = siteConfiguration.getPassword();
		this.uid = siteConfiguration.getUsername();
		this.protocol = ImageMixProxy.defaultImageProtocol;
		this.proxyServiceType = proxyServiceType;
		if(proxyServiceType == ProxyServiceType.image)
		{
			this.operationPath = firstChoice ? siteConfiguration.getImagePath1() : siteConfiguration.getImagePath2();
		}
		else if(proxyServiceType == ProxyServiceType.metadata)
		{
			this.operationPath = firstChoice ? siteConfiguration.getMetadataPath1() : siteConfiguration.getMetadataPath2();
		}
	}
	
	public MixProxyService(MIXSiteConfiguration siteConfiguration, 
			IDSService idsService, IDSOperation idsOperation, String host, int port)
	{
		super();
		this.applicationPath = idsService.getApplicationPath();
		this.host = host;
		this.port = port;
		this.credentials = siteConfiguration.getPassword();
		this.uid = siteConfiguration.getUsername();
		this.protocol = ImageMixProxy.defaultImageProtocol;
		this.proxyServiceType = ProxyServiceType.getProxyServiceTypeFromIDSOperation(idsOperation);
		this.operationPath = idsOperation.getOperationPath();
	}

}
