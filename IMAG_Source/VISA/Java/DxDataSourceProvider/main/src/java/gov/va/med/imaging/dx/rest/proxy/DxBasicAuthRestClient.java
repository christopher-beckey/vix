package gov.va.med.imaging.dx.rest.proxy;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;
import gov.va.med.imaging.url.vista.StringUtils;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.api.client.filter.HTTPBasicAuthFilter;
//import com.sun.jersey.client.apache.ApacheHttpClient;
import com.sun.jersey.client.urlconnection.HTTPSProperties;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.util.Objects;

//import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;

import javax.net.ssl.HostnameVerifier;
//import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.KeyManager;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
//import com.sun.jersey.api.client.ClientResponse;

/**
* @author vhaisltjahjb
*
*/
               
public class DxBasicAuthRestClient 
{	
    private final static Logger LOGGER = Logger.getLogger(DxBasicAuthRestClient.class);
    private String basicAuthUrl;
    private String alexdelargePassword;
    private TransactionContext transactionContext;
    
    public DxBasicAuthRestClient(String url, String alexdelargePassword) 
    {
    	this.basicAuthUrl = url;
    	this.alexdelargePassword = alexdelargePassword;
    	transactionContext = TransactionContextFactory.get();
    }

    public String getDataFromServer(String keystoreUrl, String keystorePassword) 
    {
    	String result = null;

    	HostnameVerifier hostnameVerifier = new HostnameVerifier() 
    	{
		   @Override
		   public boolean verify(String hostname, SSLSession session)
		   {
			   return !Objects.isNull(hostname);
		   }
    	};
	 	 
    	SSLContext sslContext = createSSLContext(keystoreUrl, keystorePassword, keystoreUrl, keystorePassword);
		
    	if(LOGGER.isDebugEnabled()) 
			LOGGER.debug("DX createSSLContext done.");
			   
    	DefaultClientConfig config = new DefaultClientConfig();
    	 config.getProperties().put(
			   HTTPSProperties.PROPERTY_HTTPS_PROPERTIES, new HTTPSProperties(hostnameVerifier, sslContext));
	     config.getProperties().put(
			   ClientConfig.PROPERTY_CONNECT_TIMEOUT, 30000);
    	 config.getProperties().put(
			   ClientConfig.PROPERTY_READ_TIMEOUT, 60000);

    	Client client = Client.create(config);
    	
		if(LOGGER.isDebugEnabled())
			LOGGER.debug("DX Client.reate(config) done.");
      
    	try 
    	{
		    client.addFilter(new HTTPBasicAuthFilter("alexdelarge", alexdelargePassword));

    		WebResource resource = client.resource(basicAuthUrl);
    		
    		LOGGER.debug("DX client resource done.");
    		
		    addTransactionHeaders(resource);

    		result = resource.accept(MediaType.TEXT_PLAIN_TYPE).get(String.class);
    		
    		if(LOGGER.isDebugEnabled())
                LOGGER.debug("DX got result:{}", result);
    	} 
    	catch (Exception e) 
    	{
    		LOGGER.warn("DX getDataFromServer() exception: [{}], message: {}", e.getClass().getSimpleName(), e.getMessage());
    	}
    	finally 
    	{
    		client.destroy();
    	}
	   
    	return result;
    }

    private static SSLContext createSSLContext(
    		String keystoreFile, String keystorePwd, 
       		String truststoreFile, String truststorePwd) 
   	{
		if(LOGGER.isDebugEnabled())
            LOGGER.debug("keystore File [{}]", keystoreFile);

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

    private static KeyStore createKeyStore(final URL url, final String pwd) 
   	throws KeyStoreException, NoSuchAlgorithmException, CertificateException, IOException
   	{
   		if(url == null)
   			throw new IllegalArgumentException("Keystore url may not be null");

   		KeyStore keystore = KeyStore.getInstance("jks");
   		
   		try(InputStream is = url.openStream())
   		{
   			keystore.load(is, pwd != null ? pwd.toCharArray() : null);
   		}

   		return keystore;
   	}
   		    
    private static KeyManager [] createKeyManagers(final KeyStore keystore, final String pwd)
       		throws KeyStoreException, NoSuchAlgorithmException, UnrecoverableKeyException
   	{
   		if(keystore == null)
   			throw new IllegalArgumentException("Keystore may not be null");

   		KeyManagerFactory kmfactory = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
   		kmfactory.init(keystore, pwd != null ? pwd.toCharArray() : null);
   		
   		return kmfactory.getKeyManagers();
   	}

   	private static TrustManager [] createTrustManagers(final KeyStore keystore)
   	throws KeyStoreException, NoSuchAlgorithmException
   	{
   		if (keystore == null)
   			throw new IllegalArgumentException("Keystore may not be null");

   		TrustManagerFactory tmfactory = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
   		tmfactory.init(keystore);
   		tmfactory.getTrustManagers();
   		
   		return tmfactory.getTrustManagers();
   	}

   	private void addTransactionHeaders(WebResource request)
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		String duz = transactionContext.getDuz();
		if(!StringUtils.isEmpty(duz))
		   request.header(TransactionContextHttpHeaders.httpHeaderDuz, duz);
		
		String fullname = transactionContext.getFullName();
		if(!StringUtils.isEmpty(fullname))
			request.header(TransactionContextHttpHeaders.httpHeaderFullName, fullname);
		
		String sitename = transactionContext.getSiteName();
		if(!StringUtils.isEmpty(sitename))
			request.header(TransactionContextHttpHeaders.httpHeaderSiteName, sitename);
		
		String sitenumber = transactionContext.getSiteNumber();
		if(!StringUtils.isEmpty(sitenumber))
			request.header(TransactionContextHttpHeaders.httpHeaderSiteNumber, sitenumber);
		
		String ssn = transactionContext.getSsn();
		if(!StringUtils.isEmpty(ssn))
			request.header(TransactionContextHttpHeaders.httpHeaderSSN, ssn);
		
		String securityToken = transactionContext.getBrokerSecurityToken();
		if(!StringUtils.isEmpty(securityToken))
			request.header(TransactionContextHttpHeaders.httpHeaderBrokerSecurityTokenId, securityToken);
		
		String cacheLocationId = transactionContext.getCacheLocationId();
		if(!StringUtils.isEmpty(cacheLocationId))
			request.header(TransactionContextHttpHeaders.httpHeaderCacheLocationId, cacheLocationId);
		
		String userDivision = transactionContext.getUserDivision();
		if(!StringUtils.isEmpty(userDivision))
			request.header(TransactionContextHttpHeaders.httpHeaderUserDivision, userDivision);     
		
		String transactionId = transactionContext.getTransactionId();
		if(!StringUtils.isEmpty(transactionId))
			request.header(TransactionContextHttpHeaders.httpHeaderTransactionId, transactionId);
		
		String requestingVixSiteNumber = transactionContext.getVixSiteNumber();
		if(!StringUtils.isEmpty(requestingVixSiteNumber))
			request.header(TransactionContextHttpHeaders.httpHeaderRequestingVixSiteNumber, requestingVixSiteNumber);
		
		String imagingSecurityContextType = transactionContext.getImagingSecurityContextType();
		if(!StringUtils.isEmpty(imagingSecurityContextType))
			request.header(TransactionContextHttpHeaders.httpHeaderOptionContext, imagingSecurityContextType);
		
		debugHeaders();
	}
	
	private void debugHeaders()
	{
		String duz = transactionContext.getDuz();
		if(!StringUtils.isEmpty(duz))
		    if(LOGGER.isDebugEnabled()) 
                LOGGER.debug("Header Duz: {}", duz);
		
		String fullname = transactionContext.getFullName();
		if(!StringUtils.isEmpty(fullname))
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("Header fullname: {}", fullname);
		       
		String sitename = transactionContext.getSiteName();
		if(!StringUtils.isEmpty(sitename))
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("Header sitename: {}", sitename);
		       
		String sitenumber = transactionContext.getSiteNumber();
		if(!StringUtils.isEmpty(sitenumber))
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("Header sitenumber: {}", sitenumber);
		       
		String ssn = transactionContext.getSsn();
		if(!StringUtils.isEmpty(ssn))
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("Header ssn: {}", ssn);
		       
		String securityToken = transactionContext.getBrokerSecurityToken();
		if(!StringUtils.isEmpty(securityToken))
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("Header securityToken: {}", securityToken);
		       
		String cacheLocationId = transactionContext.getCacheLocationId();
		if(!StringUtils.isEmpty(cacheLocationId))
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("Header cacheLocationId: {}", cacheLocationId);
		       
		String userDivision = transactionContext.getUserDivision();
		if(!StringUtils.isEmpty(userDivision))
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("Header userDivision: {}", userDivision);
		       
		String transactionId = transactionContext.getTransactionId();
		if(!StringUtils.isEmpty(transactionId))
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("Header transactionId: {}", transactionId);
		       
		String requestingVixSiteNumber = transactionContext.getVixSiteNumber();
		if(!StringUtils.isEmpty(requestingVixSiteNumber))
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("Header requestingVixSiteNumber: {}", requestingVixSiteNumber);
		       
		String imagingSecurityContextType = transactionContext.getImagingSecurityContextType();
		if(!StringUtils.isEmpty(imagingSecurityContextType))
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("Header imagingSecurityContextType: {}", imagingSecurityContextType);
	}

	// java.exe 
	// 	-Dlog4j.configuration=file:/C:/VixConfig/log4j.properties 
	// 	-cp ./*;DxDataSourceProvider-0.1.jar 
	// 	gov.va.med.imaging.dx.rest.proxy.DxBasicAuthRestClient <params>
//	public static void main(String[] argv)
//	{
//		String keystoreUrl = "file:///C:/VixCertStore/cvix.jks";
//		String keystorePassword = "cVIX_DAS_if#";
//		String url = "https://10.225.84.206/MIXWebApp/restservices/mix/DasCachedDocumentId?repoId=central&docId=h0103d64813f486400db75d39430b805f110111-10.225.84.206";
//		
//		DxBasicAuthRestClient basicClient = new DxBasicAuthRestClient(url); 
//		String result = basicClient.getDataFromServer(keystoreUrl, keystorePassword);
//		System.out.println(result);
//	}	
	
}

