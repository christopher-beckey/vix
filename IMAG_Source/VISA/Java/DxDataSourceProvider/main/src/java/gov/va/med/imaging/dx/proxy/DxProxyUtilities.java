/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 7, 2008
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
package gov.va.med.imaging.dx.proxy;

import java.net.MalformedURLException;
import java.net.URL;
import org.apache.commons.httpclient.protocol.Protocol;
import org.apache.commons.httpclient.protocol.ProtocolSocketFactory;
import gov.va.med.logging.Logger;

import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import gov.va.med.imaging.proxy.ssl.AuthSSLProtocolSocketFactory;
import gov.va.med.net.TLSUtility;

/**
 * Common utilities for all DX data sources
 * 
 * @author VHAISWWERFEJ
 *
 */
public class DxProxyUtilities 
{	
	private final static Logger LOGGER = Logger.getLogger(DxProxyUtilities.class);
	
	/**
	 * Configure the DX certificate protocol to use certificates to communicate with remote server
	 * @param dxConfiguration The configuration for the DX data source
	 */
	public static void configureDxCertificate(DxDataSourceConfiguration dxConfiguration)
	{
		try
		{			
			LOGGER.info("DxProxyUtilities.configureDxCertificate() --> Configuring DX Certificate...");
			
		    URL keystoreUrl = new URL(dxConfiguration.getKeystoreUrl());	// the keystore containing the key to send as the client
		    URL truststoreUrl = new URL(dxConfiguration.getTruststoreUrl());	// the keystore containing the trusted certificates, to validate the server cert against
		    		    		   
		    ProtocolSocketFactory socketFactory = 
		        new AuthSSLProtocolSocketFactory(keystoreUrl, 
		        		dxConfiguration.getKeystorePassword(), truststoreUrl, 
		        		dxConfiguration.getTruststorePassword());
		    Protocol httpsProtocol = new Protocol(dxConfiguration.getTLSProtocol(), socketFactory, dxConfiguration.getTLSPort());	
	
		    Protocol.registerProtocol(dxConfiguration.getTLSProtocol(), httpsProtocol);
		    Logger.getLogger(DxProxyUtilities.class).info("DX HTTPS protocol handler successfully registered.");
		    ( new TLSUtility(System.out) ).dumpSSLProperties();
		} 
		catch (MalformedURLException e)
		{
			LOGGER.error(
			    "Error configuring HTTPS client within DX proxy. \n" +
			    "Keystore and/or truststore are unavailable. \n" +
			    "DX functionality will not be available.");
		}
	}
}
