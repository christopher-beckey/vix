/**
 * 
 */
package gov.va.med.imaging.muse.proxy.rest.v1;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.MuseOpenSessionResults;
import gov.va.med.imaging.muse.proxy.rest.AbstractMuseRestProxy;
import gov.va.med.imaging.muse.proxy.rest.MuseRestPostClient;
import gov.va.med.imaging.muse.webservices.rest.endpoints.MuseRestUri;
import gov.va.med.imaging.muse.webservices.rest.type.closesession.request.MuseCloseSessionInputType;
import gov.va.med.imaging.muse.webservices.rest.type.closesession.response.MuseCloseSessionResultType;
import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;

/**
 * @author William Peterson
 *
 */
public class MuseCloseUserSessionRestProxyV1 extends AbstractMuseRestProxy {

	private final static String MUSE_SERVER_VERSION = "8.0";
	private final static String RESTPROXY_VERSION = "1";
	private final static String CLOSE_SESSION_SUCCESS = "Success";

	
	public MuseCloseUserSessionRestProxyV1(ProxyServices proxyServices,
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
		return MuseRestUri.UserCloseSessionUri;
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

	
	public void closeMuseSession(MuseOpenSessionResults openResults, String routingTokenString)
	throws MethodException, ConnectionException{
		
		TransactionContext transactionContext = TransactionContextFactory.get();
        getLogger().info("closeMuseSession, Transaction [{}] initiated to '{}'.", transactionContext.getTransactionId(), routingTokenString);
		setDataSourceMethodAndVersion("closeMuseSession V1");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{siteNumber}", museServer.getMuseSiteNumber());
		String url = getWebResourceUrl(getRestServicePath(), urlParameterKeyValues);
        getLogger().debug("Closing Muse Site Number: {}", museServer.getMuseSiteNumber());
		MuseRestPostClient postClient = new MuseRestPostClient(url, MediaType.APPLICATION_XML_TYPE, 
				getMetadataTimeoutMs());
		MuseCloseSessionInputType input = new MuseCloseSessionInputType();
		input.setToken(openResults.getBinaryToken());
		
		MuseCloseSessionResultType result = postClient.executeRequest(MuseCloseSessionResultType.class, input);
		if(!result.getStatus().equals(CLOSE_SESSION_SUCCESS)){
            getLogger().error("Failed to close Muse Session properly. Muse Return Status: {}", result.getStatus());
		}
		else{
            getLogger().info("closeMuseSession, Transaction [{}]", transactionContext.getTransactionId());
		}
	}

	@Override
	protected void addSecurityContextToHeader(HttpClient client,
			GetMethod getMethod, boolean includeVistaSecurityContext) {		
	}

	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) {
		
	}
}
