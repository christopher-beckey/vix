/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 28, 2010
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
package gov.va.med.imaging.proxy.rest;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.core.MediaType;
import javax.xml.bind.JAXBContext;

import gov.va.med.logging.Logger;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientHandlerException;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.ClientResponse.Status;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.api.client.filter.GZIPContentEncodingFilter;
import com.sun.jersey.client.apache.ApacheHttpClient;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.PatientNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.rest.exceptions.RestExceptionCodes;
import gov.va.med.imaging.rest.exceptions.RestExceptionMessage;
import gov.va.med.imaging.rest.exceptions.RestInsufficientPatientSensitivityExceptionMessage;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractRestClient
{
	private final static Logger logger = Logger.getLogger(AbstractRestClient.class);
	protected final WebResource.Builder request;	
	private final int metadataTimeoutMs;
	
	// ok to have one single client for the entire application, it is thread safe (see comment below)
	//private static Client client = null;
	private static Map<Integer, Client> clientPool = new HashMap<Integer, Client>();
	
	/**
	 * According to https://jersey.dev.java.net/nonav/documentation/latest/user-guide.html#d4e604
	 * Clients are expensive, and thread safe, so only create them once
	 * 
	 * @param metadataTimeoutMs read timeout value in milliseconds
	 * @return
	 */
	private static synchronized Client getClient(int metadataTimeoutMs)
	{
		// use a map to pool connections based on the timeout
		Client client = clientPool.get(metadataTimeoutMs);
		if(client == null)
		{
			DefaultClientConfig clientConfig = new DefaultClientConfig();
			
			clientConfig.getProperties().put(
			        ClientConfig.PROPERTY_CONNECT_TIMEOUT, 30000);
			clientConfig.getProperties().put(
			        ClientConfig.PROPERTY_READ_TIMEOUT, metadataTimeoutMs);
			// According to http://jersey.java.net/nonav/apidocs/1.2/contribs/jersey-apache-client/com/sun/jersey/client/apache/ApacheHttpClient.html
			// some properties must be provided in constructor of ApacheHttpClient		
			client = ApacheHttpClient.create(clientConfig);
			
			((ApacheHttpClient)client).getClientHandler().getHttpClient().getParams().setConnectionManagerTimeout(metadataTimeoutMs);
			((ApacheHttpClient)client).getClientHandler().getHttpClient().getHttpConnectionManager().getParams().setDefaultMaxConnectionsPerHost(50);
			((ApacheHttpClient)client).getClientHandler().getHttpClient().getHttpConnectionManager().getParams().setMaxTotalConnections(200);
			
			int defaultMaxConnectionsPerHost = ((ApacheHttpClient)client).getClientHandler().getHttpClient().getHttpConnectionManager().getParams().getDefaultMaxConnectionsPerHost();
			int maxTotalConnections = ((ApacheHttpClient)client).getClientHandler().getHttpClient().getHttpConnectionManager().getParams().getMaxTotalConnections();

            logger.info("Creating new ApacheHttpClient with maxConnectionsPerHost: {}, and maxTotalConnections: {}", defaultMaxConnectionsPerHost, maxTotalConnections);
			
			// using HTTP Commons Client in order to take advantage of configuration for certificate
			//client = ApacheHttpClient.create();
			
			// Enable GZIP
			client.addFilter(new GZIPContentEncodingFilter(false));
			
			clientPool.put(metadataTimeoutMs, client);
		}
		return client;
	}	
	
	public AbstractRestClient(String url, String mediaType, int metadataTimeoutMs)
	{
		this.metadataTimeoutMs = metadataTimeoutMs;
		WebResource webResource = createWebResource(url);
        getLogger().info("Creating web request to URL '{}'.", url);
		gov.va.med.imaging.transactioncontext.TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.addDebugInformation("REST request to '" + url + "'.");
		request = webResource.accept(mediaType);
		addTransactionHeaders();
	}
	
	public AbstractRestClient(String url, MediaType mediaType, int metadataTimeoutMs)
	{
		this(url, mediaType.toString(), metadataTimeoutMs);
	}
	
	protected Logger getLogger()
	{
		return logger;
	}
	
	private WebResource createWebResource(String url)
	{
		Client client = getClient(this.metadataTimeoutMs);
		return client.resource(url);
	}
	
	/**
	 * Execute the actual method with the specified return type
	 * @param <T>
	 * @param c
	 * @return
	 */
	//protected abstract <T extends Object> T executeMethodInternal(Class<T> c);
	protected abstract <T extends Object> ClientResponse executeMethodInternal(Class<T> c);
	
	protected abstract void addTransactionHeaders();
	
	/**
	 * Execute the request, handles exceptions from the web service and converts 
	 * them to internal VIX exceptions
	 * @param <T>
	 * @param c
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public <T extends Object> T executeRequest(Class<T> c)
	throws MethodException, ConnectionException
	{
		ClientResponse clientResponse = null;
		try
		{
			try
			{
				clientResponse = executeMethodInternal(c);
				if(clientResponse.getStatus() == Status.OK.getStatusCode())
				{
					getLogger().debug("Web Service Response return OK.");
					// not sure if this should be here - this maybe only applies to Federation
					String machineName = 
						clientResponse.getHeaders().getFirst(TransactionContextHttpHeaders.httpHeaderMachineName);
						//clientResponse.getHeaders().getFirst("wl-proxy-client-ip");
		
					if(machineName != null)
						TransactionContextFactory.get().setDataSourceResponseServer(machineName);
                    getLogger().info("Received response from machine '{}'.", machineName);
					
					if (c == String.class)
					{
						return (T) inputStreamToString(clientResponse.getEntityInputStream());
					}
					else if (MediaType.TEXT_HTML_TYPE.equals(clientResponse.getType()))
					{
						// Handle case where a service incorrectly annotates itself as text/html (MUSE NX)
						Object responseObject;
						try {
							JAXBContext jaxbContext = JAXBContext.newInstance(c);
							responseObject = jaxbContext.createUnmarshaller().unmarshal(clientResponse.getEntityInputStream());
						} catch (Exception e) {
							throw new IOException("Could not unmarshall response received", e);
						}

						// Check that it's the valid type
						if (! (c.isInstance(responseObject))) {
							throw new IOException("Could not unmarshall response received; expected type does not match the received type");
						}

						return (T) responseObject;
					} else {
						return clientResponse.getEntity(c);
					}
				}
				else{
                    getLogger().debug("Web Service returned an error: {}", clientResponse.getStatus());
					// Removed; this causes errors if the entity doesn't match the expected type
					//getLogger().debug(clientResponse.getEntity(c));
				}
			}
			catch(UniformInterfaceException uiX)
			{			
				// this probably won't ever happen anymore since the responses from the FederationWebApp are 
				// now all wrapped in Response objects, but keeping this here just in case
				//clientResponse = uiX.getResponse();
                getLogger().warn("UniformInterfaceException executing GET request, {}", uiX.getMessage());
				throw new ConnectionException(uiX);
			}
			catch(ClientHandlerException chX)
			{			
				// this probably won't ever happen anymore since the responses from the FederationWebApp are 
				// now all wrapped in Response objects, but keeping this here just in case
				//clientResponse = clX.getResponse();
                getLogger().warn("ClientHandlerException executing GET request, {}", chX.getMessage());
				throw new ConnectionException(chX);
			}
			catch(Exception eX)
			{
				// something went very wrong - this should not happen
                getLogger().warn("Exception executing GET request, {}", eX.getMessage());
				throw new ConnectionException(eX);
			}
			if(clientResponse != null)
				handleException(clientResponse);
			throw new ConnectionException("Did not properly handle response from client - THIS SHOULD NEVER HAPPEN!");
		}
		finally
		{
			// according to http://jersey.java.net/nonav/apidocs/1.2/contribs/jersey-apache-client/com/sun/jersey/client/apache/ApacheHttpClient.html
			// should call close on the response
			if(clientResponse != null)
			{
				try 
				{ clientResponse.close(); } 
				catch(Exception ex) 
				{
                    logger.debug("Exception closing clientResponse, {}", ex.getMessage());
				}
			}
		}
	}
	
	// convert InputStream to String
	private String inputStreamToString(InputStream is) {

		BufferedReader br = null;
		StringBuilder sb = new StringBuilder();

		String line;
		try {

			br = new BufferedReader(new InputStreamReader(is));
			while ((line = br.readLine()) != null) {
				sb.append(line);
				sb.append("\r\n");
			}

		} catch (IOException e) {
            getLogger().error("InputStream to String error. {}", e.getMessage());
			return null;
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
                    getLogger().error("InputStream to String error. {}", e.getMessage());
					
					// Fortify change: removed.  Shouldn't be here.
					//return null;
				}
			}
		}


		return sb.toString();

	}

	private void handleException(ClientResponse response)
	throws ConnectionException, MethodException
	{
		int responseStatus = response.getStatus();
        getLogger().warn("Received exception with error code '{}'.", responseStatus);
		String machineName = 
			response.getHeaders().getFirst(TransactionContextHttpHeaders.httpHeaderMachineName);
		if(machineName != null)
			TransactionContextFactory.get().setDataSourceResponseServer(machineName);
        getLogger().info("Received exception response from machine '{}'.", machineName);
		if(responseStatus >= 600)
		{				
			switch(response.getStatus())
			{
				case RestExceptionCodes.restInvalidSecurityCredentialsExceptionCode:
					throw new SecurityCredentialsExpiredException(getExceptionMessageFromResponse(response));
				case RestExceptionCodes.restMethodExceptionCode:
					throw new MethodException(getExceptionMessageFromResponse(response));
				case RestExceptionCodes.restPatientNotFoundExceptionCode:
					throw new PatientNotFoundException(getExceptionMessageFromResponse(response));
				case RestExceptionCodes.restInsufficientPatientSensitivityCode:
					RestInsufficientPatientSensitivityExceptionMessage insufficientPatientSensitivityExceptionMessage =
						response.getEntity(RestInsufficientPatientSensitivityExceptionMessage.class);
					PatientSensitivityLevel sensitiveLevel = PatientSensitivityLevel.getPatientSensitivityLevel(insufficientPatientSensitivityExceptionMessage.getSensitiveErrorCode());
					PatientSensitivityLevel allowedLevel = PatientSensitivityLevel.getPatientSensitivityLevel(insufficientPatientSensitivityExceptionMessage.getAllowedLevelCode());
					PatientSensitiveValue sensitiveValue = new PatientSensitiveValue(sensitiveLevel, insufficientPatientSensitivityExceptionMessage.getMessage());
					InsufficientPatientSensitivityException ipsX = 
						InsufficientPatientSensitivityException.createInsufficientPatientSensitivityException(sensitiveValue, 
								PatientIdentifier.icnPatientIdentifier(insufficientPatientSensitivityExceptionMessage.getPatientIcn()), 
								allowedLevel);
					throw ipsX;
				default:
					throw new ConnectionException(getExceptionMessageFromResponse(response));
			}
		}
		else
		{
			// not a VIX error, might be 404 or 500
			throw new ConnectionException("Recieved exception of status '" + responseStatus + "'.");
		}
	}
	
	private String getExceptionMessageFromResponse(ClientResponse response)
	{
		RestExceptionMessage exceptionMessage = response.getEntity(RestExceptionMessage.class);
		String message = "";
		if(exceptionMessage == null)
		{
			// this shouldn't happen, but if it does!
			message = "Exception did not contain message, this should not happen.  Error code was '" + response.getStatus() + "'.";
		}
		else
		{
			message = exceptionMessage.getMessage();
		}
		return message;
	}

	protected WebResource.Builder getRequest() 
	{
		return request;
	}
}
