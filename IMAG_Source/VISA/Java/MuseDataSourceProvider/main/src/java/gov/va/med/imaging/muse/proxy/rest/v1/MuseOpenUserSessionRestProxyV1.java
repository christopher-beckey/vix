/**
 * 
 */
package gov.va.med.imaging.muse.proxy.rest.v1;

import java.time.OffsetDateTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;
import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.MuseOpenSessionResults;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.muse.proxy.rest.AbstractMuseRestProxy;
import gov.va.med.imaging.muse.proxy.rest.MuseRestPostClient;
import gov.va.med.imaging.muse.webservices.rest.endpoints.MuseRestUri;
import gov.va.med.imaging.muse.webservices.rest.translator.MuseRestTranslator;
import gov.va.med.imaging.muse.webservices.rest.type.opensession.request.MuseOpenSessionInputType;
import gov.va.med.imaging.muse.webservices.rest.type.opensession.response.MuseOpenSessionAuthTokenType;
import gov.va.med.imaging.musedatasource.MuseDataSourceProvider;
import gov.va.med.imaging.musedatasource.cache.MuseOpenSession;
import gov.va.med.imaging.musedatasource.cache.MuseOpenSessionResultsCache;
import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author William Peterson
 *
 */
public class MuseOpenUserSessionRestProxyV1 
extends AbstractMuseRestProxy {

	private final static Logger logger = Logger.getLogger(MuseOpenUserSessionRestProxyV1.class);

	
	private final static String MUSE_SERVER_VERSION = "8.0";
	private final static String RESTPROXY_VERSION = "1";
	private final static String OPEN_SESSION_SUCCESS = "Success";

	private static MuseConfiguration config = MuseDataSourceProvider.getMuseConfiguration();
		
	public MuseOpenUserSessionRestProxyV1(ProxyServices proxyServices,
			MuseConfiguration museConfiguration, MuseServerConfiguration museServer, boolean instanceUrlEscaped) {
		super(proxyServices, museConfiguration, museServer, instanceUrlEscaped);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseRestProxy#getProxyService()
	 */
	@Override
	public ProxyService getProxyService() {
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseRestProxy#getProxyServiceType()
	 */
	@Override
	public ProxyServiceType getProxyServiceType() {
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseRestProxy#getRestServicePath()
	 */
	@Override
	protected String getRestServicePath() {
		return MuseRestUri.UserOpenSessionUri;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseRestProxy#getRestProxyVersion()
	 */
	@Override
	public String getRestProxyVersion() {
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseRestProxy#getMuseServerVersion()
	 */
	@Override
	public String getMuseServerVersion() {
		return null;
	}

	
	public MuseOpenSessionResults openMuseSession(String routingTokenString)
	throws MethodException, ConnectionException{
		TransactionContext transactionContext = TransactionContextFactory.get();
		MuseOpenSessionResults result = null;
		synchronized(MuseOpenUserSessionRestProxyV1.class) {
			
			if(MuseOpenSessionResultsCache.get(museServer.getHost())!=null &&
					!isExpired(MuseOpenSessionResultsCache.get(museServer.getHost())) &&
					config.isEnableSessionCache()) {
                logger.info("OpenMuseSession, Transaction [{}] using a cached instance of a MuseOpenSessionResults business object.", transactionContext.getTransactionId());
				result = MuseOpenSessionResultsCache.get(museServer.getHost()).getResults();
			}
			else {
				//The session needs to be created or updated
				setDataSourceMethodAndVersion("openMuseSession V1");
				Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
				urlParameterKeyValues.put("{siteNumber}", museServer.getMuseSiteNumber());
				String url = getWebResourceUrl(getRestServicePath(), urlParameterKeyValues); 
				MuseRestPostClient postClient = new MuseRestPostClient(url, MediaType.APPLICATION_XML, getMetadataTimeoutMs());
				MuseOpenSessionInputType input = new MuseOpenSessionInputType();
				input.setPassword(museServer.getPassword());
				input.setSiteNumber(museServer.getMuseSiteNumber());
				input.setUserName(museServer.getUsername());
				
				MuseOpenSessionAuthTokenType openResult = postClient.executeRequest(MuseOpenSessionAuthTokenType.class, input);
				if(openResult == null)
				{
					logger.error("Got null results from Muse Server");			
					return null;
				}
				if(!openResult.getStatus().equals(OPEN_SESSION_SUCCESS)){
                    logger.error("Failed to open Muse Session properly. Muse Return Status: {}", openResult.getStatus());
					throw new ConnectionException("Failed to open Muse Server connection. " + openResult.getErrorMessage());
				} else {
					if(logger.isDebugEnabled()){
                        logger.debug("openSession got back a {} status", openResult.getStatus());
					}
				}
				
				try
				{
					result = MuseRestTranslator.translate(openResult);
					
					if(result.getExpiration()==null) {
						logger.error("Got null expiration value from Muse Server");			
						return null;
					}
	
					if(logger.isDebugEnabled()) {
                        logger.debug("openMuseSession, using pre expiration minutes of {}", config.getPreExpirationMinutes());
                        logger.debug("openMuseSession, using expiration date format of {}", config.getExpirationDateFormat());
					}
					
					DateTimeFormatter formatter = DateTimeFormatter.ofPattern(config.getExpirationDateFormat());
					OffsetDateTime dateTime = OffsetDateTime.parse(result.getExpiration().replaceAll(":",""),formatter);
					ZonedDateTime expirationLocal = dateTime.atZoneSameInstant(ZonedDateTime.now().getZone());	
					ZonedDateTime expirationAdjusted = expirationLocal.minusMinutes(config.getPreExpirationMinutes());
					
					if(logger.isDebugEnabled()) {
                        logger.debug("OpenMuseSession Expiration: {}", expirationAdjusted.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
					}
					
					MuseOpenSessionResultsCache.put(museServer.getHost(), new MuseOpenSession(result, expirationAdjusted));

                    logger.info("openMuseSession, Transaction [{}] created MuseOpenSessionResultsType that expires in {} seconds", transactionContext.getTransactionId(), expirationAdjusted.toEpochSecond() - ZonedDateTime.now().toEpochSecond());
					
					transactionContext.addDebugInformation(result == null ? "null MuseOpenSessionResults" : "" + result.toString());
				}
				catch(TranslationException tX)
				{
                    logger.error("Error translating artifact results into business objects, {}", tX.getMessage(), tX);
					throw new MethodException(tX);			
				}
			} 
		}
		
		return result;
	}
	
	private boolean isExpired(MuseOpenSession session) {
		if(logger.isDebugEnabled()) {
            logger.debug("openMuseSession cache check: expiration({}", session.getExpiration().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
            logger.debug("openMuseSession cache check: now({}", ZonedDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
		}
		return ZonedDateTime.now().isAfter(session.getExpiration());
	}


	@Override
	protected void addSecurityContextToHeader(HttpClient client,
			GetMethod getMethod, boolean includeVistaSecurityContext) {
		
	}

	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) {
		
	}
}
