/**
 * 
 */
package gov.va.med.imaging.viewerservices.proxy.rest.v1;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.viewerservices.common.webservices.rest.endpoints.ViewerServicesRestUri;
import gov.va.med.imaging.viewerservices.common.webservices.rest.translator.ViewerRestTranslator;
import gov.va.med.imaging.viewerservices.common.webservices.rest.type.PreCacheNotificationType;
import gov.va.med.imaging.viewerservices.exceptions.ViewerServicesConnectionException;
import gov.va.med.imaging.viewerservices.exceptions.ViewerServicesMethodException;
import gov.va.med.imaging.viewerservices.proxy.rest.AbstractViewerServicesViewerServicesRestProxy;
import gov.va.med.imaging.viewerservices.proxy.rest.ViewerServicesRestPostClient;

/**
 * @author William Peterson
 *
 */
public class ViewerServicesViewerServicesRestProxyV1 
extends AbstractViewerServicesViewerServicesRestProxy {

	private final static String RESTPROXY_VERSION = "1";
	

	public ViewerServicesViewerServicesRestProxyV1(ProxyServices proxyServices,
			SiteConnection siteConnection, boolean instanceUrlEscaped) {
		super(proxyServices, siteConnection, instanceUrlEscaped);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.viewerservices.proxy.rest.AbstractViewerServicesViewerServicesRestProxy#sendViewerPreCacheNotifications(gov.va.med.RoutingToken, gov.va.med.imaging.exchange.business.SiteConnection, java.util.List)
	 */
	@Override
	public boolean sendViewerPreCacheNotifications(RoutingToken routingToken, SiteConnection connection,
			List<WorkItem> workItems) throws ViewerServicesMethodException, ViewerServicesConnectionException {

		TransactionContext transactionContext = TransactionContextFactory.get();
        getLogger().info("sendViewerPreCacheNotifications, Transaction [{}] initiated ' to '{}'.", transactionContext.getTransactionId(), routingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("sendViewerPreCacheNotifications V1");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		
		String url;
		String viewerResult = null;
		try 
		{
			url = getWebResourceUrl(getRestServicePath(), urlParameterKeyValues);
			url = replaceUrlProtocol(url, connection.getProtocol());
			ViewerServicesRestPostClient postClient = new ViewerServicesRestPostClient(url, MediaType.APPLICATION_XML_TYPE, 
					getMetadataTimeoutMs());
	
			PreCacheNotificationType notifications = ViewerRestTranslator.translate(workItems);
			viewerResult = postClient.executeRequest(String.class, notifications);
		} 
		catch (ConnectionException cX) 
		{
            getLogger().error("Connection Exception: {}", cX.getMessage());
			return false;
		} 
		catch (MethodException mX) 
		{
            getLogger().error("Method Exception: {}", mX.getMessage());
			return false;
		} 
		catch (URNFormatException urnX) 
		{
            getLogger().error("URN Format Exception: {}", urnX.getMessage());
			return false;
		}
		catch (Exception e) 
		{
            getLogger().error("Exception: {}", e.getMessage());
			return false;
		}

		if(viewerResult == null)
		{
			getLogger().error("Got null results from VIX Viewer.");			
			return false;
		}
        getLogger().info("sendViewerPreCacheNotifications, Transaction [{}] returned [{}] RestBooleanReturnType.", transactionContext.getTransactionId(), viewerResult == null ? "null" : "not null");
		
		return true;
	}


	private String replaceUrlProtocol(String url, String protocol) 
	{
        getLogger().debug("replaceProtocol url = {} with {}", url, protocol);

		if((protocol != null) && (protocol.equalsIgnoreCase(SiteConnection.siteConnectionVVSS)))
		{
			String[] urlParse = url.split(":");
			url = "https";
			for(int i = 1; i<urlParse.length; i++)
				url += ":" + urlParse[i];

		}

        getLogger().debug("replaced url = {}", url);
		return url;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseProxy#getDataSourceVersion()
	 */
	@Override
	public String getRestProxyVersion() {
		return RESTPROXY_VERSION;
	}
	
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#getWebResourceUrl(java.lang.String, java.util.Map)
	 */
	@Override
	public String getWebResourceUrl(String methodUri,
			Map<String, String> urlParameterKeyValues)
			throws ConnectionException {
		return super.getWebResourceUrl(methodUri, urlParameterKeyValues);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#encodeGai(gov.va.med.GlobalArtifactIdentifier)
	 */
	@Override
	protected String encodeGai(GlobalArtifactIdentifier gai)
			throws MethodException {
		return super.encodeGai(gai);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#encodeString(java.lang.String)
	 */
	@Override
	protected String encodeString(String value) throws MethodException {
		return super.encodeString(value);
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#addSecurityContextToHeader(org.apache.commons.httpclient.HttpClient, org.apache.commons.httpclient.methods.GetMethod, boolean)
	 */
	@Override
	protected void addSecurityContextToHeader(HttpClient client,
			GetMethod getMethod, boolean includeVistaSecurityContext) {
		super.addSecurityContextToHeader(client, getMethod, includeVistaSecurityContext);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#getRestServicePath()
	 */
	@Override
	protected String getRestServicePath() {
		return ViewerServicesRestUri.PreCachingUri;
	}

}
