/**
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 4, 2017
  Developer:  vhaisltjahjb
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

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dx.DesPollerResult;
import gov.va.med.imaging.dx.cache.DxDocumentCache;
import gov.va.med.imaging.dx.datasource.DxDocumentDataSourceService;
import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import gov.va.med.imaging.dx.exceptions.DxConnectionException;
import gov.va.med.imaging.dx.rest.endpoints.DxDesProxyAdapterRestUri;
import gov.va.med.imaging.dx.rest.proxy.DxRestGetClient;
import gov.va.med.imaging.dx.translator.DxDesTranslator;
import gov.va.med.imaging.dx.translator.DxJsonConverter;
import gov.va.med.imaging.exchange.business.DocumentFilter;
import gov.va.med.imaging.exchange.business.ImageStreamResponse;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.storage.ByteBufferBackedImageInputStream;
import gov.va.med.imaging.proxy.rest.RestProxyCommon;
import gov.va.med.imaging.proxy.ssl.AuthSSLProtocolSocketFactory;
import gov.va.med.imaging.proxy.ssl.AuthSSLRemoteHostMap;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.dx.DxConnection;
import gov.va.med.imaging.url.dxs.DxsConnection;
import java.net.InetAddress;
import java.net.UnknownHostException;


import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.security.KeyStoreException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.NewCookie;

import gov.va.med.imaging.utils.NetUtilities;
import org.apache.axis2.context.ConfigurationContext;
import org.apache.commons.httpclient.protocol.DefaultProtocolSocketFactory;
import org.apache.commons.httpclient.protocol.Protocol;
import org.apache.commons.httpclient.protocol.ProtocolSocketFactory;
import gov.va.med.logging.Logger;

import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.ClientResponse.Status;

/**
 * @author vhaisltjahjb
 *
 */
public class DxDataSourceProxy 
{
	private static final Logger LOGGER = Logger.getLogger(DxDataSourceProxy.class);
	
	// The "protocol" to use for secure connections set up using the truststore
	// and keystore specified in the configuration
	public static final String SECURE_DX_VIRTUAL_PROTOCOL = "dxs";
	public static final String DX_VIRTUAL_PROTOCOL = "dx";
	
	private final ResolvedArtifactSource resolvedArtifactSource;
	private final DxDataSourceConfiguration configuration;
	
	public static final String DEFAULT_START_DATE = "19010101";
	public static final String DEFAULT_END_DATE = getTommorowDate();
	private static final String KEYSTORE_JKS = "JKS";
	
	private static ConfigurationContext configContext;
	private static URLConnection dxConnection;
	
	private TransactionContext transactionContext = TransactionContextFactory.get();
	private String transactionId;
	private URL queryUrl;
	
	/**
	 * The ResolvedArtifactSource passed to this constructor must have only one
	 * URL for the query and one for the retrieve.  Any URL fixup in protocol
	 * or path must be completed before this constructor.  This instance will use
	 * the first URL in each list without modification.
	 * 
	 * @param siteConfiguration
	 * @param site
	 * @param homeCommunityOid
	 * @throws ConnectionException
	 * @throws MalformedURLException 
	 */
	public DxDataSourceProxy(
		ResolvedArtifactSource resolvedArtifactSource, 
		DxDataSourceConfiguration configuration) throws ConnectionException
	{
		this.transactionId = transactionContext.getTransactionId();
		this.configuration = configuration;
		this.resolvedArtifactSource = resolvedArtifactSource;
		
		if(resolvedArtifactSource.getMetadataUrls().size() < 1)
			throw new ConnectionException("DxDataSourceProxy() --> The resolved artifact source [" + resolvedArtifactSource.toString() + "] does not support the required protocol [" + DxDocumentDataSourceService.SUPPORTED_PROTOCOL + "] for metadata.");
		
		this.queryUrl = resolvedArtifactSource.getMetadataUrls().get(0);
        LOGGER.debug("DxDataSourceProxy() --> Given queryUrl [{}]", this.queryUrl);
		
		// requires that the query and retrieve URL fields be set
		validateProtocolRegistration();
	}
	
	private void validateProtocolRegistration() throws DxConnectionException
	{
		// this is synchronized with the class instance so that multiple instances
		// do not try to register the protocol socket factory
		synchronized(DxDataSourceProxy.class)
		{
			if(! isProtocolHandlerRegistered(configuration.getDasProtocol())) {
				registerProtocolHandler(configuration.getDasProtocol());
			}
			
		}
	}

	/**
	 * @param protocol
	 * @throws DxConnectionException 
	 * @throws MalformedURLException 
	 */
	private void registerProtocolHandler(String protocol) throws DxConnectionException
	{
		URL dxConnectionUrl = createConnectionUrl();

		if (DX_VIRTUAL_PROTOCOL.equalsIgnoreCase(protocol))
		{
			dxConnection = new DxConnection(dxConnectionUrl);
			
			try 
			{
				dxConnection.connect();
			}
			catch(IOException ioX) 
			{
				String msg = "DxDataSourceProxy.registerProtocolHandler() --> Failed to connect to given 'dx' protocol: " + ioX.getMessage();
				LOGGER.error(msg);
				throw new DxConnectionException(msg, ioX);
			}
			
			Protocol httpProtocol = new Protocol("http", new DefaultProtocolSocketFactory(), getDasPort());
			Protocol.registerProtocol(DX_VIRTUAL_PROTOCOL, httpProtocol );
            LOGGER.debug("DxDataSourceProxy.registerProtocolHandler() --> " + DX_VIRTUAL_PROTOCOL + " is registered as {}", httpProtocol);
		}
		else if( SECURE_DX_VIRTUAL_PROTOCOL.equalsIgnoreCase(protocol) )
		{
			dxConnection = new DxsConnection(dxConnectionUrl);
			
			try 
			{
				dxConnection.connect();
			}
			catch(IOException ioX) 
			{
				String msg = "DxDataSourceProxy.registerProtocolHandler() --> Failed to connect to given 'dxs' protocol: " + ioX.getMessage();
				LOGGER.error(msg);
				throw new DxConnectionException(msg, ioX);
			}
			
			try
			{
				Protocol httpsProtocol = null;
		
				// Either keystore or truststore may be null but not both
				// or AuthSSLProtocolSocketFactory will fail to construct.
				String keystore = getKeystore();
				String truststore = getTruststore();
				String keystorePassword = getKeystorePassword();
				String truststorePassword = getTruststorePassword();

                LOGGER.debug("DxDataSourceProxy.registerProtocolHandler() --> Local keystore [{}]", keystore);
                LOGGER.debug("DxDataSourceProxy.registerProtocolHandler() --> Remote truststore [{}]", truststore);
					
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
					// register our socket factory using the 'virtual' scheme "dxs".
					// When creating a socket connection use "dxs" in the URI e.g. 
					// HttpClient httpclient = new HttpClient();
					// GetMethod httpget = new GetMethod("dxs://www.whatever.com/");
				Protocol.registerProtocol(SECURE_DX_VIRTUAL_PROTOCOL, httpsProtocol);

                LOGGER.debug("DxDataSourceProxy.registerProtocolHandler() --> " + SECURE_DX_VIRTUAL_PROTOCOL + " is registered as {}", httpsProtocol);
				
			}
			catch (MalformedURLException x)
			{
				String msg = "DxDataSourceProxy.registerProtocolHandler() --> Unable to form valid trust or key store URL for protocol [" + protocol + "]: " + x.getMessage();
				LOGGER.error(msg);
				throw new DxConnectionException(msg, x);
			}
		}
		else
            LOGGER.warn("DxDataSourceProxy.registerProtocolHandler() --> Given protocol [{}] is not registered with a socket factory.", protocol);
		
		if(isProtocolHandlerRegistered(protocol))
            LOGGER.info("DxDataSourceProxy.registerProtocolHandler() --> Given protocol [{}] was registered successfully.", protocol);
		else
            LOGGER.info("DxDataSourceProxy.registerProtocolHandler() --> Given protocol [{}] failed to register.", protocol);
	}

	private boolean isUseCertificate() {
		return configuration.isUseCertificate();
	}


	private URL createConnectionUrl() throws DxConnectionException 
	{
		String dxConnectionUrl = 
				(SECURE_DX_VIRTUAL_PROTOCOL.equalsIgnoreCase(getDasProtocol()) ? "https" : "http") + 
				"://" +
				getDasHost() +
				(getDasPort() > 0 ? ":" + getDasPort() : "");
        LOGGER.debug("DxDataSourceProxy.registerProtocolHandler() --> URL to connect [{}]", dxConnectionUrl);
		try {
			return new URL(dxConnectionUrl);
		} catch (MalformedURLException e) {
			LOGGER.debug(e.getMessage());
			throw new DxConnectionException(e);
		}
	}


	/**
	 * @return the queryUrl as passed to the constructor for this class
	 */
	public URL getQueryUrl()
	{
		return this.queryUrl;
	}

	private int getQueryTimeout()
	{
		return (configuration.getQueryTimeout() == null ? DxDataSourceConfiguration.defaultQueryTimeout : configuration.getQueryTimeout());
	}
	
	private int getDelayPeriod()
	{
		return (configuration.getDelayPeriod() == null ? DxDataSourceConfiguration.defaultDelayPeriod : configuration.getDelayPeriod());
	}

	private String getDasProtocol()
	{
		return (configuration.getDasProtocol() == null ? DxDataSourceConfiguration.defaultDasProtocol : configuration.getDasProtocol());
	}

	private String getDasHost()
	{
		return (configuration.getDasHost() == null ? DxDataSourceConfiguration.defaultDasHost : configuration.getDasHost());
	}

	private int getDasPort()
	{
		return configuration.getDasPort();
	}
	
	private int getTlsPort()
	{
		return configuration.getTLSPort();
	}
	
	private String getKeystore()
	{
		return configuration.getKeystoreUrl();
	}
	
	private String getKeystorePassword()
	{
		return configuration.getKeystorePassword();
	}
	
	private String getTruststore()
	{
		return configuration.getTruststoreUrl();
	}
	
	private String getTruststorePassword()
	{
		return configuration.getTruststorePassword();
	}

	private String getAccessibleIpAddress()
	{
		return configuration.getAccessibleIpAddress();
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
	

	/**
	 * @return the configuration
	 */
	public DxDataSourceConfiguration getConfiguration()
	{
		return this.configuration;
	}
	
	/**
	 * 
	 * @param patientIcn
	 * @param filter
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 * @throws InterruptedException 
	 */
	public DocumentSetResult getPatientDocumentSets(
		DocumentFilter filter)	
	throws MethodException, ConnectionException, InterruptedException
	{
		String patientId = filter.getPatientId();
        LOGGER.info("DxDataSourceProxy.getPatientDocumentSets() --> for Transaction [{}], patientId [{}]", transactionId, patientId);

		try
		{
			//First pass request: async request to DPAS. DPAS will return queryId
			String queryId = dpasQuery(filter);
			
			//Second pass request: keep checking for DPAS completion of the first request
			DesPollerResult pollerResult = dpasPoller(queryId);

			//COnvert DesPollerResult to DocumentSetResult
			DocumentSetResult result = DxDesTranslator.translate(pollerResult);
			transactionContext.addDebugInformation("DxDataSourceProxy.getPatientDocumentSets() --> Result [" + (result == null ? "null" : result.toString(true)) + "]");
			
			//Cache ComplexURL, this URL will be used to retrieve the document based on repoID and docID
			DxDocumentCache.cacheDocuments(result);

			return result;
		}
		catch(MethodException mX)
		{
			String msg = "DxDataSourceProxy.getPatientDocumentSets() --> Error making DX Query Request: " + mX.getMessage();  
			LOGGER.error(msg);
			throw new MethodException(msg, mX);
		}
		catch (ConnectionException cX)
		{
			String msg = "DxDataSourceProxy.getPatientDocumentSets() --> Error connectiong to DPAS: " + cX.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, cX);
		}
		catch (IOException e) {
			String msg = "DxDataSourceProxy.getPatientDocumentSets() --> IOException: " + e.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, e);
		}
	}

	private String dpasQuery(DocumentFilter filter) 
	throws ConnectionException, MethodException
	{	
		LOGGER.debug("DxDataSourceProxy.dpasQuery() --> dpasQuery, filter: ");
        LOGGER.debug("---------  version: {}", configuration.getDesServiceVersion());
        LOGGER.debug("---------  provider: {}", configuration.getDesProvider());
        LOGGER.debug("---------  icn: {}", filter.getPatientId());
        LOGGER.debug("---------  loinc: {}", configuration.getDesLoinc());
        LOGGER.debug("---------  requestSource: {}", configuration.getDesRequestSource());

		// compose URL to client
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{version}", configuration.getDesServiceVersion());
		urlParameterKeyValues.put("{provider}", configuration.getDesProvider());
		urlParameterKeyValues.put("{icn}", filter.getPatientId());
		urlParameterKeyValues.put("{loinc}", configuration.getDesLoinc());
		urlParameterKeyValues.put("{requestSource}", configuration.getDesRequestSource());

		StringBuilder dpasQueryPath = new StringBuilder(DxDesProxyAdapterRestUri.dpasQueryPath.length());
		dpasQueryPath.append(DxDesProxyAdapterRestUri.dpasQueryPath);
		
		Date startDocDate = filter.getCreationTimeFrom(); 
		Date endDocDate = filter.getCreationTimeTo(); 
		String queryStartDate = DEFAULT_START_DATE;
		String queryEndDate = DEFAULT_END_DATE;
		
		if ( startDocDate != null) {
			queryStartDate = getQueryDate(startDocDate);
		}

		if ( endDocDate != null) {
			queryEndDate = getQueryDate(endDocDate);
		}

        LOGGER.debug("---------  queryStartDate: {}", queryStartDate);
        LOGGER.debug("---------  queryEndDate: {}", queryEndDate);
		
		dpasQueryPath.append("&queryStartDate={queryStartDate}");
		urlParameterKeyValues.put("{queryStartDate}", queryStartDate);

		dpasQueryPath.append("&queryEndDate={queryEndDate}");
		urlParameterKeyValues.put("{queryEndDate}", queryEndDate);
		
		String url = null;
		
		try {
            LOGGER.debug("DxDataSourceProxy.dpasQuery() --> Constructed path [{}]", dpasQueryPath.toString());
			url = getWebResourceUrl(dpasQueryPath.toString(), urlParameterKeyValues);
            LOGGER.debug("DxDataSourceProxy.dpasQuery() --> Constructed URL [{}]", url);
		}
		catch (ConnectionException ce) {
			String msg = "DxDataSourceProxy.dpasQuery() --> Failed to compose URL: " + ce.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, ce);
		}
			
		String jsonResponse = null;
		
		try{
			// request to Client and translate (json) response
			DxRestGetClient getClient = new DxRestGetClient(url, MediaType.APPLICATION_JSON_TYPE);
			jsonResponse = getClient.executeRequest(String.class);
		}
		catch (ConnectionException ce) {
			String msg = "DxDataSourceProxy.dpasQuery() --> Failed to connect to Client: " + ce.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, ce);
		}
		catch (MethodException me) {
			String msg = "DxDataSourceProxy.dpasQuery() --> Failed to get Client response: " + me.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, me);
		}

        LOGGER.debug("DxDataSourceProxy.dpasQuery() --> JSON response [{}]", jsonResponse);
		String result = DxJsonConverter.ConvertJsonDpasQueryResult(jsonResponse);
        LOGGER.debug("DxDataSourceProxy.dpasQuery() --> Translated from JSON response [{}]", result);
		return result;
	}

	private DesPollerResult dpasPoller(String queryId) 
	throws ConnectionException, InterruptedException, MethodException
	{	
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{version}", configuration.getDesServiceVersion());
		urlParameterKeyValues.put("{queryId}", queryId);

		String url = null;
		
		try {
			url = getWebResourceUrl(DxDesProxyAdapterRestUri.dpasPollerPath, urlParameterKeyValues); 
			LOGGER.debug(url);
		}
		catch (ConnectionException ce) {
			String msg = "DxDataSourceProxy.dpasPoller() --> Failed to compose URL: " + ce.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, ce);
		}
		
		long delayPeriod = getDelayPeriod(); //in mms
		long queryTimeout = getQueryTimeout(); //in mms
        LOGGER.debug("DxDataSourceProxy.dpasPoller() --> delayPeriod [{}], queryTimeout [{}]", delayPeriod, queryTimeout);

		Boolean completed = false;
		long runningPeriod = 0;
		DesPollerResult result = null;
		
		while (!completed)
		{
			String jsonResponse = performDpasPollerCheck(url);

            LOGGER.debug("DxDataSourceProxy.dpasPoller() --> JSON response [{}]", jsonResponse);
			
			completed = DxJsonConverter.isPollerCompleted(jsonResponse);
			
			if (completed) {
				result = DxJsonConverter.ConvertJsonDpasPollerResult(jsonResponse, getAccessibleIpAddress());
                LOGGER.debug("DxDataSourceProxy.dpasPoller() --> Result from JSON response [{}]", result);
			}
			else if (runningPeriod > queryTimeout) 
			{
				break;
			}
			else
			{
				Thread.sleep(delayPeriod);
				runningPeriod += delayPeriod;
			}
		}
		
		return result;
	}
	
	private String performDpasPollerCheck(String url) 
	throws ConnectionException, MethodException
	{
		try{
			// request to Client and translate (json) response
			DxRestGetClient getClient = new DxRestGetClient(url, MediaType.APPLICATION_JSON_TYPE);
			return getClient.executeRequest(String.class);
		}
		catch (ConnectionException ce) {
			String msg = "DxDataSourceProxy.performDpasPollerCheck() --> Failed to connect to Client: " + ce.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, ce);
		}
		catch (MethodException me) {
			String msg = "DxDataSourceProxy.performDpasPollerCheck() --> Failed to get Client response: " + me.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, me);
		}
	}

	private String getWebResourceUrl(String methodUri, Map<String, String> urlParameterKeyValues)
	throws ConnectionException
	{
		StringBuilder url = new StringBuilder();
		url.append(getDxConnectionPath());
		url.append("/");
		url.append(getDxRestServicePath());
		url.append("/");
		url.append(RestProxyCommon.replaceMethodUriWithValues(methodUri, urlParameterKeyValues));		
		
		return url.toString();
	}

	private String getWebResourceRetrievalUrl(String methodUri, Map<String, String> urlParameterKeyValues)
	throws ConnectionException
	{
		StringBuilder url = new StringBuilder();
		url.append(getDxConnectionPath());
		url.append("/");
		url.append(RestProxyCommon.replaceMethodUriWithValues(methodUri, urlParameterKeyValues));		
		
		return url.toString();
	}
	
	private String getDxConnectionPath()
	{
		URL url = dxConnection.getURL();
		return 	url.getProtocol() + "://" + url.getHost() + (url.getPort() > 0 ? ":" + url.getPort() : "");
	}
	
	private String getDxRestServicePath() {
		return configuration.getDesService() + "/" + configuration.getDesVersion();
	}
	
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
	/**
	 * @param homeCommunityUid
	 * @param repositoryUniqueId
	 * @param documentId
	 * @return
	 * @throws MethodException 
	 * @throws ConnectionException 
	 */
	public ImageStreamResponse getPatientDocument(String homeCommunityUid, 
			String repositoryUniqueId, String documentId) 
	throws MethodException, ConnectionException
	{
        LOGGER.info("DxDataSourceProxy.getPatientDocument() --> Creating DX Retrieve document request for document [{}:{}:{}]", homeCommunityUid, repositoryUniqueId, documentId);

		String encDocId = null;
		try {

			encDocId = DxDocumentCache.getEncryptedDocumentId(
					repositoryUniqueId, documentId, doGetLocalHost(), 
					configuration.getKeystoreUrl(), configuration.getKeystorePassword(),
					configuration.getAlextdelargePassword());
            LOGGER.debug("Encrypted DocumentId: {}", encDocId);
		}
		catch (IOException e) 
		{
			String msg = "DxDataSourceProxy.getPatientDocument() --> Failed to get encrypted document Id: " + e.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, e);
		}
		
		// compose URL to client
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{version}", configuration.getDesServiceVersion());
		urlParameterKeyValues.put("{encDocId}", encDocId);
		urlParameterKeyValues.put("{requestSource}", configuration.getDesRequestSource());
		
		StringBuilder dpasDocumentPath = new StringBuilder(DxDesProxyAdapterRestUri.dpasDocumentPath.length());
		dpasDocumentPath.append(DxDesProxyAdapterRestUri.dpasDocumentPath);
		
		String url = null;
		
		try {
            LOGGER.debug("DxDataSourceProxy.getPatientDocument() --> Constructed dpas document path [{}]", dpasDocumentPath.toString());
			url = getWebResourceUrl(dpasDocumentPath.toString(), urlParameterKeyValues);
            LOGGER.debug("DxDataSourceProxy.getPatientDocument() --> Constructed URL [{}]", url);
		}
		catch (ConnectionException ce) {
			String msg = "DxDataSourceProxy.dpasPoller() --> Failed to compose URL: " + ce.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, ce);
		}
			
		ClientResponse clientResponse = null;
		ImageStreamResponse imageStreamResponse= null;
		InputStream inputStream =null;
		
		DxRestGetClient getClient = new DxRestGetClient(url, MediaType.APPLICATION_OCTET_STREAM_TYPE);
		clientResponse = getClient.getInputStreamResponse();
		
		if(clientResponse.getStatus() == Status.OK.getStatusCode())
		{
			LOGGER.debug("DxDataSourceProxy.getPatientDocument() --> response is returned successfully !!!");
			
			inputStream = clientResponse.getEntityInputStream();
			
			if (inputStream != null)
			{
				imageStreamResponse = new ImageStreamResponse(new ByteBufferBackedImageInputStream(inputStream, 0));
				imageStreamResponse.setImageQuality(ImageQuality.DIAGNOSTICUNCOMPRESSED);
				imageStreamResponse.setMediaType(MediaType.APPLICATION_OCTET_STREAM);
				transactionContext.setDataSourceImageFormatReceived(imageStreamResponse.getImageFormat() == null ? "" : imageStreamResponse.getImageFormat().toString());
				transactionContext.setDataSourceImageQualityReceived(imageStreamResponse.getImageQuality().toString());
			}
		}				

		return imageStreamResponse;
	}

	private String doGetLocalHost()
	{
		return NetUtilities.getUnsafeLocalHostName("Unknown");
	}
}
