/**
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 2, 2017
  Developer:  vhaisatittoc
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
package gov.va.med.imaging.mix.proxy;

// import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
// import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;
import gov.va.med.imaging.url.mix.exceptions.MIXConnectionException;
// import gov.va.med.imaging.mixdatasource.MixImageDataSourceService;
// import gov.va.med.imaging.proxy.rest.RestProxyCommon;
import gov.va.med.imaging.proxy.ssl.AuthSSLProtocolSocketFactory;
import gov.va.med.imaging.proxy.ssl.AuthSSLRemoteHostMap;
// import gov.va.med.imaging.transactioncontext.TransactionContext;
// import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.mix.MIXConnection;
import gov.va.med.imaging.url.mixs.MIXsConnection;

import java.io.IOException;
// import java.io.InputStream;
// import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
// import java.net.URLEncoder;
// import java.security.KeyStoreException;
import java.text.DateFormat;
// import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
// import java.util.HashMap;
// import java.util.Map;

// import javax.ws.rs.core.MediaType;
// import javax.ws.rs.core.NewCookie;

// import org.apache.axis2.context.ConfigurationContext;
import org.apache.commons.httpclient.protocol.DefaultProtocolSocketFactory;
import org.apache.commons.httpclient.protocol.Protocol;
import org.apache.commons.httpclient.protocol.ProtocolSocketFactory;
import gov.va.med.logging.Logger;

// import com.sun.jersey.api.client.ClientResponse;
// import com.sun.jersey.api.client.ClientResponse.Status;

/**
 * @author vhaisatittoc
 *
 */
public class MixDataSourceProxy 
{

	private final static Logger logger = Logger.getLogger(MixDataSourceProxy.class);
	// The "protocol" to use for secure connections set up using the truststore
	// and keystore specified in the configuration
	public static final String SECURE_MIX_VIRTUAL_PROTOCOL = "mixs";
	public static final String MIX_VIRTUAL_PROTOCOL = "mix";
		
		
//	private final ResolvedArtifactSource resolvedArtifactSource;
	private final MIXConfiguration configuration;
		
		public static final String DEFAULT_START_DATE = "19010101";
		public static final String DEFAULT_END_DATE = getTommorowDate();
//		private static final String KEYSTORE_JKS = "JKS";
		
//		private static ConfigurationContext configContext;
		private static URLConnection mixConnection;
		
//		private TransactionContext transactionContext = TransactionContextFactory.get();
//		private String transactionId = null;
//		private URL queryUrl = null;
		
		/**
		 * The ResolvedArtifactSource passed to this constructor must have only one
		 * URL for the query and one for the retrieve.  Any URL fixup in protocol
		 * or path must be completed before this constructor.  This instance will use
		 * the first URL in each list without modification.
		 * 
		 * @param mixConfiguration
		 * @throws ConnectionException
		 */
		public MixDataSourceProxy(
//			ResolvedArtifactSource resolvedArtifactSource, 
			MIXConfiguration configuration) throws ConnectionException
		{
//			this.transactionId = transactionContext.getTransactionId();
			this.configuration = configuration;
//			this.resolvedArtifactSource = resolvedArtifactSource;
			
//			if(resolvedArtifactSource.getMetadataUrls().size() < 1)
//				throw new ConnectionException("The resolved artifact source '" + resolvedArtifactSource.toString() +"' does not support the required protocol '" + MixImageDataSourceService.SUPPORTED_PROTOCOL + "' for metadata.");

//			if(resolvedArtifactSource.getArtifactUrls().size() < 1)
//				throw new ConnectionException("The resolved artifact source '" + resolvedArtifactSource.toString() +"' does not support the required protocol '" + MixImageDataSourceService.SUPPORTED_PROTOCOL + "' for artifacts.");
			
//			this.queryUrl = resolvedArtifactSource.getMetadataUrls().get(0);
//			if(logger.isDebugEnabled()){logger.debug("queryUrl = " + this.queryUrl);}
			
			// requires that the query and retrieve URL fields be set
			validateProtocolRegistration();
		}
		
		
		private void validateProtocolRegistration() throws MIXConnectionException
		{
			// this is synchronized with the class instance so that multiple instances
			// do not try to register the protocol socket factory
			synchronized(MixDataSourceProxy.class)
			{
				if(! isProtocolHandlerRegistered(MIXConfiguration.DEFAULT_DAS_PROTOCOL)) {
					registerProtocolHandler(MIXConfiguration.DEFAULT_DAS_PROTOCOL);
				}
				
			}
		}

		/**
		 * @param protocol
		 * @throws MIXConnectionException 
		 * @throws MalformedURLException 
		 */
		private void registerProtocolHandler(String protocol) throws MIXConnectionException
		{
			if(logger.isDebugEnabled()){
                logger.debug("registering protocol: {}", protocol);}
			
			URL mixConnectionUrl = createConnectionUrl();

			if (MIX_VIRTUAL_PROTOCOL.equalsIgnoreCase(protocol))
			{
				mixConnection = new MIXConnection(mixConnectionUrl);
				
				try 
				{
					mixConnection.connect();
				}
				catch(IOException ioX) 
				{
					logger.error("Failed to connect to mix protocol", ioX);
					throw new MIXConnectionException(ioX);
				}
				
				Protocol httpProtocol = new Protocol("http", new DefaultProtocolSocketFactory(), getDasPort());
				Protocol.registerProtocol(MIX_VIRTUAL_PROTOCOL, httpProtocol );
				if(logger.isDebugEnabled()){
                    logger.debug(MIX_VIRTUAL_PROTOCOL + " is registered as {}", httpProtocol);}
			}
			else if( SECURE_MIX_VIRTUAL_PROTOCOL.equalsIgnoreCase(protocol) )
			{
				mixConnection = new MIXsConnection(mixConnectionUrl);
				
				try 
				{
					mixConnection.connect();
				}
				catch(IOException ioX) 
				{
					logger.error("Failed to connect to mixs protocol", ioX);
					throw new MIXConnectionException(ioX);
				}
				
				try
				{
					Protocol httpsProtocol = null;
//					if (isUseCertificate()) 
//					{
						// Either keystore or truststore may be null but not both
						// or AuthSSLProtocolSocketFactory will fail to construct.
						String keystore = getKeystore();
						String truststore = getTruststore();
						String keystorePassword = getKeystorePassword();
						String truststorePassword = getTruststorePassword();
						if(logger.isDebugEnabled()){
                            logger.debug("Local keystore: {} pwd:{}", keystore, keystorePassword);}
						if(logger.isDebugEnabled()){
                            logger.debug("Remote truststore: {} pwd:{}", truststore, truststorePassword);}
						
						URL keystoreUrl = null; 
						if (keystore != null)
						{
							keystoreUrl = new URL(keystore);	// the keystore containing the key to send as the client
						}
						
						URL truststoreUrl = null; 
						if (truststore != null)
						{
							truststoreUrl = new URL(truststore);	// the keystore containing the trusted certificates, to validate the server cert against
						}
						
						ProtocolSocketFactory socketFactory = 
						    new AuthSSLProtocolSocketFactory(
						    	keystoreUrl, keystorePassword, 
						    	truststoreUrl, truststorePassword);
						
						AuthSSLRemoteHostMap map = new AuthSSLRemoteHostMap(getDasPort(),
										keystoreUrl, //String keystoreUrl, 
										keystorePassword, //String keystorePassword, 
										truststoreUrl, //String truststoreUrl, 
										truststorePassword, //String truststorePassword,
										10000); //Timeout

						AuthSSLProtocolSocketFactory.AddCvixHostMap(getDasHost(), map);
						
						httpsProtocol = new Protocol("https", socketFactory, getDasPort());
						// register our socket factory using the 'virtual' scheme "mixs".
						// When creating a socket connection use "mixs" in the URI e.g. 
						// HttpClient httpclient = new HttpClient();
						// GetMethod httpget = new GetMethod("mixs://www.whatever.com/");
						Protocol.registerProtocol(SECURE_MIX_VIRTUAL_PROTOCOL, httpsProtocol);
//					}
//					else
//					{
//						if(logger.isDebugEnabled()){logger.debug("Using default Certificate");}
//						httpsProtocol = new Protocol("https", new DefaultProtocolSocketFactory(), getDasPort());
//						Protocol.registerProtocol(SECURE_MIX_VIRTUAL_PROTOCOL, httpsProtocol );
//					}
					if(logger.isDebugEnabled()){
                        logger.debug(SECURE_MIX_VIRTUAL_PROTOCOL + " is registered as {}", httpsProtocol);}
					
				}
				catch (MalformedURLException x)
				{
                    logger.error("Failed to register protocol '{}' unable to form valid trust or key store URL [{}].", protocol, x.getMessage());
					throw new MIXConnectionException(x);
				}
			}
			else
                logger.error("Protocol '{}' is not registered with a socket factory.", protocol);
			
			if(isProtocolHandlerRegistered(protocol))
                logger.info("Protocol '{}' registered successfully.", protocol);
			else
                logger.info("Protocol '{}' failed to register.", protocol);
		}

//		private boolean isUseCertificate() {
//			return true; // configuration.isUseCertificate();
//		}

		private URL createConnectionUrl() throws MIXConnectionException 
		{
			String mixConnectionUrl = 
					(SECURE_MIX_VIRTUAL_PROTOCOL.equalsIgnoreCase(getDasProtocol()) ? "https" : "http") + 
					"://" +
					getDasHost() +
					(getDasPort() > 0 ? ":" + getDasPort() : "");
			if(logger.isDebugEnabled()){logger.debug(mixConnectionUrl);}
			try {
				return new URL(mixConnectionUrl);
			} catch (MalformedURLException e) {
				if(logger.isDebugEnabled()){logger.debug(e.getMessage());}
				throw new MIXConnectionException(e);
			}
		}

		private String getDasProtocol()
		{
			return MIXConfiguration.DEFAULT_DAS_PROTOCOL;
		}

		private String getDasHost()
		{
			
			String dasHost=MIXConfiguration.defaultDODImageHost;
			try {
				dasHost = configuration.getSiteConfiguration(MIXConfiguration.DEFAULT_DAS_SITE, null).getHost();
			} 
			catch (Exception e) {
				if(logger.isDebugEnabled()){
                    logger.debug("Using default DOD host={} -- Failure to get DAS host from MIX data source configuration:{}", dasHost, e.getMessage());}
			}
			return dasHost;
		}

		private int getDasPort()
		{
			int dasPort=MIXConfiguration.defaultDODImagePort;
			try {
				dasPort = configuration.getSiteConfiguration(MIXConfiguration.DEFAULT_DAS_SITE, null).getPort();
			} 
			catch (Exception e) {
				if(logger.isDebugEnabled()){
                    logger.debug("Using default DOD port={} -- Failure to get DAS port from MIX data source configuration:{}", dasPort, e.getMessage());}
			}
			return dasPort;
		}
		
//		private int getTlsPort()
//		{
//			return configuration.getTLSPort();
//		}
		
		private String getKeystore()
		{
			return configuration.getKeystoreUrl();
			//return null;
		}
		
		private String getKeystorePassword()
		{
			return configuration.getKeystorePassword();
			//return null;
		}
		
		private String getTruststore()
		{
			return configuration.getTruststoreUrl();
			//return null;
		}
		
		private String getTruststorePassword()
		{
			return configuration.getTruststorePassword();
			//return null;
		}

		/**
		 * @param protocol
		 * @return
		 */
		private boolean isProtocolHandlerRegistered(String protocol)
		{
			try
			{
				return Protocol.getProtocol(protocol) != null;
			}
			catch (IllegalStateException x)
			{
				return false;
			}
		}
		

//		/**
//		 * @return the configuration
//		 */
//		public DxDataSourceConfiguration getConfiguration()
//		{
//			return this.configuration;
//		}

//		private String getWebResourceUrl(String methodUri, Map<String, String> urlParameterKeyValues)
//		throws ConnectionException
//		{
//			StringBuilder url = new StringBuilder();
//			url.append(getDxConnectionPath());
//			url.append("/");
//			url.append(getDxRestServicePath());
//			url.append("/");
//			url.append(RestProxyCommon.replaceMethodUriWithValues(methodUri, urlParameterKeyValues));		
//			
//			return url.toString();
//		}
//		
//		private String getDxConnectionPath()
//		{
//			URL url = dxConnection.getURL();
//			return 	url.getProtocol() + "://" + url.getHost() + (url.getPort() > 0 ? ":" + url.getPort() : "");
//		}
//		
//		private String getDxRestServicePath() {
//			return configuration.getDesService() + "/" + configuration.getDesVersion();
//		}
		
		private static String getQueryDate(Date queryDate)
		{
			DateFormat df = new SimpleDateFormat("yyyyMMdd");
			String result = df.format(queryDate);
			return result;
		}

		private static Date addDays(Date date, int days) 
		{
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			cal.add(Calendar.DATE, days);
			return cal.getTime();
		}

		private static String getTommorowDate() {
			Date tomorrow = addDays(new Date(), 1);
			return getQueryDate(tomorrow);
		}

}
