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
package gov.va.med.imaging.federation.proxy;

import java.net.MalformedURLException;
import java.net.URL;
import java.security.Provider;
import java.util.Set;
import java.util.SortedSet;

import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;

import org.apache.commons.httpclient.protocol.Protocol;
import org.apache.commons.httpclient.protocol.ProtocolSocketFactory;
import gov.va.med.logging.Logger;

import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.ids.IDSOperation;
import gov.va.med.imaging.proxy.ids.IDSProxy;
import gov.va.med.imaging.proxy.ids.IDSService;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.proxy.ssl.AuthSSLProtocolSocketFactory;

/**
 * Common utilities for all Federation data sources
 * 
 * @author VHAISWWERFEJ
 *
 */
public class FederationProxyUtilities 
{	
	private final static Logger LOGGER = Logger.getLogger(FederationProxyUtilities.class);
	
	private final static IDSProxy versionProxy = new IDSProxy();
	private final static String  defaultFederationProtocol = "https";
	
	public final static int defaultFederationSslPort = 8443;
	public final static int defaultFederationSslNioPort = 8442;
	public final static int startingNioVersion = 8;
	
	/**
	 * Configure the Federation certificate protocol to use certificates to communicate with remote server
	 * @param federationConfiguration The configuration for the federation data source
	 */
	public static void configureFederationCertificate(FederationConfiguration federationConfiguration)
	{
		try
		{			
		    URL keystoreUrl = new URL(federationConfiguration.getKeystoreUrl());	// the keystore containing the key to send as the client
		    URL truststoreUrl = new URL(federationConfiguration.getTruststoreUrl());	// the keystore containing the trusted certificates, to validate the server cert against
		    		    		   
		    ProtocolSocketFactory socketFactory = 
		        new AuthSSLProtocolSocketFactory(keystoreUrl, 
		        	federationConfiguration.getKeystorePassword(), truststoreUrl, 
		        	federationConfiguration.getTruststorePassword());
		    
			Protocol httpsProtocol = new Protocol(defaultFederationProtocol, socketFactory, defaultFederationSslPort);	
		    Protocol.registerProtocol(federationConfiguration.getFederationSslProtocol(), httpsProtocol);
		    Logger.getLogger(FederationProxyUtilities.class).info("Federation HTTPS protocol handler successfully registered.");
		    dumpSSLProperties();
		} 
		catch (MalformedURLException e)
		{
		    LOGGER.error(
			    "FederationProxyUtilities.configureFederationCertificate() --> Error configuring HTTPS client within federation proxy. \n" +
			    "Keystore and/or truststore are unavailable. \n" +
			    "Federation functionality will not be available.");
		}
	}
	
	/**
	 * Helper code to output the SSL properties loaded from the keystore/truststore
	 */
	private static void dumpSSLProperties()

    {
    	String defaultAlgorithm = null;
    	javax.net.ssl.KeyManagerFactory keyMgrFactory = null;
    	Provider provider = null;
    	Set<Object> keySet = null;
    	javax.net.ssl.KeyManager[] keyManagers = null;
    	
    	System.out.println("==================== SSL Properties ======================================");
    	
    	try
    	{
    		defaultAlgorithm = javax.net.ssl.KeyManagerFactory.getDefaultAlgorithm();
    		System.out.println("Default Algorithm is '" + defaultAlgorithm + "'");
    	} 
    	catch (Throwable x)
    	{
    		System.out.println("Error (" + x.getMessage() + ") getting default algorithm");
    	}
    	try
    	{
    		keyMgrFactory = javax.net.ssl.KeyManagerFactory.getInstance(defaultAlgorithm);
    		
    		// Fortify change: not on list but fix anyway
    		String keyMgrFactoryClassName = keyMgrFactory != null ? keyMgrFactory.getClass().getSimpleName() : "null";
    		
    		System.out.println("KeyManagerFactory type is '" + keyMgrFactoryClassName + "'");
    	} 
    	catch (Throwable x)
    	{
    		System.out.println("Error (" + x.getMessage() + ") getting key manager factory");
    	}
    	try
    	{
        	// Fortify change: check for not null first
    		if(keyMgrFactory != null) 
    		{
        		provider = keyMgrFactory.getProvider();
        		
        		// Fortify change: not on list but fix anyway
        		String providerClassName = provider != null ? provider.getClass().getSimpleName() : "null";
        		
        		System.out.println("KeyManagerFactory Provider type is '" + providerClassName + "'");    			
    		}
    	} 
    	catch (Throwable x)
    	{
    		System.out.println("Error getting provider [" + x.getMessage() + "]");
    	}
    	System.out.println("=================== TrustManagerFactory.PKIX Trust Managers ==========================");
    	try
    	{
    		Object providerValue = null;
    		
        	// Fortify change: check for not null first.  Not on list but fix anyway
    		if(provider != null) 
    		{
    			providerValue = provider.get("TrustManagerFactory.PKIX");    			
    			TrustManagerFactory pkixTrustMgrFactory = (TrustManagerFactory)providerValue;
    			TrustManager[] pkixTrustmanagers = pkixTrustMgrFactory.getTrustManagers();
    			
            	// Fortify change: check for not null first.  Not on list but fix anyway
        		if(pkixTrustmanagers != null) 
        		{
        			for (TrustManager pkixTrustManager : pkixTrustmanagers)
        				System.out.println("Provider " + pkixTrustManager.toString() );
        		}
    		}
    	}
    	catch (Throwable x)
    	{
    		System.out.println("Error (" + x.getMessage() + ") getting TrustManagerFactory.PKIX value");
    	}
    	System.out.println("=================== TrustManagerFactory.PKIX Trust Managers ==========================");
    	try
    	{
        	// Fortify change: check for not null first
    		if(provider != null && provider.keySet() != null) 
    		{
    			keySet = provider.keySet();  			
    			for (Object key : keySet)
    			{
    				// Fortify change: check for not null first.  Not on list but fix anyway
    				// Set implemetations contain at most one null.  Can't take a chance that very one in there.
    				if (key != null) {
    					String providerKeyValue = provider.get(key) != null ? provider.get(key).toString() : "null";
    					System.out.println("Provider [" + key.toString() + "] [" + providerKeyValue + "]" );
    				}
    			}
    		}
    	} 
    	catch (Throwable x)
    	{
    		System.out.println("Error (" + x.getMessage() + ") getting provider keyset");
    	}
    	try
    	{
        	// Fortify change: check for not null first; second round
    		if(keyMgrFactory != null && keyMgrFactory.getKeyManagers() != null) 
    		{
    			keyManagers = keyMgrFactory.getKeyManagers();
    			for (javax.net.ssl.KeyManager keyManager : keyManagers) {
    				// Don't know if 'keyManager' can be null. Fix anyway.
    				String keyManagerValue = keyManager != null ? keyManager.getClass().getSimpleName() : "null";
    				System.out.println("KeyManager [" + keyManagerValue + "]" );
    			}
    		}
    	} 
    	catch (Throwable x)
    	{
    		System.out.println("Error (" + x.getMessage() + ") getting key managers");
    	}
    	System.out.println("==================== End SSL Properties ======================================");
    }
	
	/**
	 * 
	 * @param site
	 * @param serviceName
	 * @param datasourceVersion
	 * @return
	 */
	public static ProxyServices getFederationProxyServices(Site site, String serviceName, String datasourceVersion)
	{
		// get the service from the IDS on the remote web app
		SortedSet<IDSService> services = versionProxy.getImagingServices(site, serviceName, datasourceVersion);
		// if nothing is returned, then there are no facades to service this version
		if((services == null) || (services.size() <= 0))
		{
            LOGGER.warn("FederationProxyUtilities.getFederationProxyServices() --> Got null services back from IDS service for site [{}], indicates remote site does not have a VIX. Cannot use Federation for this site", site.getSiteNumber());
			return null;
		}

		IDSService service = services.first();
		
		ProxyServices proxyServices = new ProxyServices();
		
		for(IDSOperation operation : service.getOperations())
		{
			proxyServices.add(new FederationProxyService(service, operation, site.getAcceleratorServer(), defaultFederationSslPort));
		}
		
		return proxyServices;
	}
	
	/**
	 * 
	 * @param site
	 * @param serviceName
	 * @param datasourceVersion
	 * @return
	 */
	public static ProxyServices getCurrentFederationProxyServices(Site site, String serviceName, String datasourceVersion)
	{
		int callerVersion = Integer.parseInt(datasourceVersion);

		// get the service from the IDS on the remote web app
		SortedSet<IDSService> services = versionProxy.getImagingServices(site, serviceName, datasourceVersion);

		// if nothing is returned, then there are no facades to service this version
		if((services == null) || (services.size() <= 0))
		{
            LOGGER.warn("FederationProxyUtilities.getCurrentFederationProxyServices() --> Got null services back from IDS service for site [{}], indicates remote site does not have a VIX. Cannot use Federation for this site", site.getSiteNumber());
			return null;
		}

		IDSService currentService = services.first();

        LOGGER.debug("FederationProxyUtilities.getCurrentFederationProxyServices() --> Current Federation IDSService version on site [{}] is {}", site.getSiteNumber(), currentService.getVersion());

		int version = Integer.parseInt(currentService.getVersion());
		int port = (version < startingNioVersion) ? defaultFederationSslPort : defaultFederationSslNioPort;

		ProxyServices proxyServices = new ProxyServices();
		
		for (IDSService service : services)
		{
			int serviceVersion = Integer.parseInt(service.getVersion());
			if (callerVersion >= serviceVersion)
			{
				for(IDSOperation operation : service.getOperations())
				{
					if (!IsProxyServiceInList(
							proxyServices, service, 
							operation, site.getAcceleratorServer(), port))
					{
                        LOGGER.debug("FederationProxyUtilities.getCurrentFederationProxyServices() --> Adding Federation IDSService version [{}] operation type [{}]", service.getVersion(), operation.getOperationType());
						proxyServices.add(new FederationProxyService(service, operation, site.getAcceleratorServer(), port));
					}
				}
			}
		}
		return proxyServices;
	}
		
	
	private static boolean IsProxyServiceInList(ProxyServices proxyServices, 
			IDSService service, IDSOperation operation,
			String host, int port) 
	{
		for (ProxyService proxyService : proxyServices)
		{
			ProxyServiceType proxyServiceType = 
					ProxyServiceType.getProxyServiceTypeFromIDSOperation(operation);

			String applicationPath = service.getApplicationPath();

			if ((proxyService.getHost().equals(host)) 
				&& (proxyService.getPort() == port)
				&& (proxyService.getProxyServiceType().equals(proxyServiceType))
				&& (proxyService.getApplicationPath().equals(applicationPath))
				)
			{
				return true;
			}
		}			
		return false;
	}

	public static ProxyServices getCurrentFederationProxyServices(
			IDSService service,
			Site site)
	{
		int version = Integer.parseInt(service.getVersion());
		int port = (version < startingNioVersion) ? defaultFederationSslPort : defaultFederationSslNioPort;

		ProxyServices proxyServices = new ProxyServices();
		
		for(IDSOperation operation : service.getOperations())
		{
			proxyServices.add(new FederationProxyService(service, operation, site.getAcceleratorServer(), port));
		}
		
		return proxyServices;
	}

	
	public static IDSService getIDSService(Site site, String serviceName)
	{
		// get the service from the IDS on the remote web app
		SortedSet<IDSService> services = versionProxy.getImagingServices(site, serviceName, "");

		// if nothing is returned, then there are no facades to service this version
		if((services == null) || (services.size() <= 0))
		{
            LOGGER.warn("FederationProxyUtilities.getIDSService() --> Got null services back from IDS service for site [{}], indicates remote site does not have a VIX. Cannot use Federation for this site", site.getSiteNumber());
			return null;
		}

		IDSService service = services.first();
        LOGGER.debug("FederationProxyUtilities.getIDSService() --> Current Federation IDSService version [{}]", service.getVersion());
		
		return service;
	}
}
