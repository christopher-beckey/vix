package gov.va.med.imaging.dx.rest.proxy;


import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.KeyManager;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.ws.rs.core.MediaType;

import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.logging.Logger;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.client.apache.ApacheHttpClient;
import com.sun.jersey.client.urlconnection.HTTPSProperties;

/**
 * @author vhaisltjahjb
 *
 */
public abstract class RestTest
{
	private final static Logger LOGGER = Logger.getLogger(RestTest.class);
	
	public RestTest()
	{
		if(LOGGER.isDebugEnabled())
			LOGGER.debug( "Creating Rest Test!");
    }
	
	private static KeyStore createKeyStore(final URL url, final String password) 
	throws KeyStoreException, NoSuchAlgorithmException, CertificateException, IOException
	{
		if (url == null)
			throw new IllegalArgumentException("Keystore url may not be null");

		KeyStore keystore = KeyStore.getInstance("jks");
		
		try (InputStream is = url.openStream())
		{
			keystore.load(is, password != null ? password.toCharArray() : null);
		}

		return keystore;
	}
		    
    private static SSLContext createSSLContext(String keystoreFile, String keystorePwd, 
    		String truststoreFile, String truststorePwd) 
	{
		try
		{
			KeyManager [] keyManagers = null;
			
			if(LOGGER.isDebugEnabled())
                LOGGER.debug("keystore file [{}], truststore file [{}]", keystoreFile, truststoreFile);
			
			if (!StringUtils.isEmpty(keystoreFile)) 
			{
				keyManagers = createKeyManagers(createKeyStore(new URL(keystoreFile), keystorePwd), keystorePwd);
			}

			TrustManager [] trustmanagers = null;
			
			if (!StringUtils.isEmpty(truststoreFile)) 
			{
				trustmanagers = createTrustManagers(createKeyStore(new URL(truststoreFile), truststorePwd));
			}
			
			SSLContext sslcontext = SSLContext.getInstance("TLSv1.2");
			sslcontext.init(keyManagers, trustmanagers, null);
			return sslcontext;
		}
		catch(Exception e)
		{
			LOGGER.warn("Encountered [{}] while creating SSL context: {}", e.getClass().getSimpleName(), e.getMessage());
		}
		
		return null;
	}

    private static KeyManager [] createKeyManagers(final KeyStore keystore, final String password)
    throws KeyStoreException, NoSuchAlgorithmException, UnrecoverableKeyException
	{
		if (keystore == null)
			throw new IllegalArgumentException("Keystore may not be null");

		KeyManagerFactory kmfactory = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
		kmfactory.init(keystore, password != null ? password.toCharArray() : null);
		return kmfactory.getKeyManagers();
	}

	private static TrustManager[] createTrustManagers(final KeyStore keystore)
	throws KeyStoreException, NoSuchAlgorithmException
	{
		if (keystore == null)
			throw new IllegalArgumentException("Keystore may not be null");

		TrustManagerFactory tmfactory = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
		tmfactory.init(keystore);
		tmfactory.getTrustManagers();
		return tmfactory.getTrustManagers();
	}
	
	protected ClientResponse executeSslRequest(
			MediaType mediaTypex,
			String urlx,
			String truststoreUrl, 
			String truststorePassword,
			String keystoreUrl, 
			String keystorePassword)
	{
		if(LOGGER.isDebugEnabled())
		{
			LOGGER.debug( "Https Rest Test!");
            LOGGER.debug("---- truststorefile [{}] pwd [{}]", truststoreUrl, truststorePassword);
            LOGGER.debug("---- keystorefile [{}] pwd [{}]", keystoreUrl, keystorePassword);
        }
        
		HostnameVerifier hostnameVerifier = HttpsURLConnection.getDefaultHostnameVerifier();
        DefaultClientConfig config = new DefaultClientConfig();
        
        SSLContext sslContext = createSSLContext(null, null, truststoreUrl, truststorePassword);
        
        config.getProperties().put(HTTPSProperties.PROPERTY_HTTPS_PROPERTIES, new HTTPSProperties(hostnameVerifier, sslContext));
		config.getProperties().put(
				ClientConfig.PROPERTY_CONNECT_TIMEOUT, 30000);
		config.getProperties().put(
				ClientConfig.PROPERTY_READ_TIMEOUT, 60000);

		// According to http://jersey.java.net/nonav/apidocs/1.2/contribs/jersey-apache-client/com/sun/jersey/client/apache/ApacheHttpClient.html
		// some properties must be provided in constructor of ApacheHttpClient		
		Client client = ApacheHttpClient.create(config);
		((ApacheHttpClient)client).getClientHandler().getHttpClient().getParams().setConnectionManagerTimeout(60000);
		((ApacheHttpClient)client).getClientHandler().getHttpClient().getHttpConnectionManager().getParams().setDefaultMaxConnectionsPerHost(50);
		((ApacheHttpClient)client).getClientHandler().getHttpClient().getHttpConnectionManager().getParams().setMaxTotalConnections(200);
        
        String url = 
        		"https://das-test.va.gov/des_proxy_adapter/v1/filter/dmix/dataservice/v4.0/mhs/query/123/ICN:1008689409V873033/34794-8?queryStartDate=19000101&queryEndDate=20170609&requestSource=VADAS";
           		//"http://localhost:57772/csp/samples/docserver/v1/filter/dmix/dataservice/v4.0/mhs/query/VAPROVIDER/:icn/:loinc";
  
		String mediaType = MediaType.APPLICATION_JSON;

        if(LOGGER.isDebugEnabled())
        	LOGGER.debug( "---- Creating WebResource");
        
		WebResource webResource = client.resource(url);

		if(LOGGER.isDebugEnabled())
			LOGGER.debug( "---- Creating WebResource.Builder request");
		
		WebResource.Builder request = webResource.accept(mediaType);

		if(LOGGER.isDebugEnabled())
            LOGGER.debug("---- Executing get request for url [{}] mediaType: [{}]", url, mediaType);
		
		try
		{
			ClientResponse res = request.get(ClientResponse.class);
			
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("**** DAS response: [{}]", (res == null ? "null" : res.getEntity(String.class)));
		}
		catch (Exception e)
		{
			LOGGER.warn("Encountered [{}] while creating SSL context: {}", e.getClass().getSimpleName(), e.getMessage());
		}
		
        return null;
	}
}
