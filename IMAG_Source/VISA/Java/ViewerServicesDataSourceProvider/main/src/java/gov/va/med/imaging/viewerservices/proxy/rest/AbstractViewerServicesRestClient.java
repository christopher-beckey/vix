/**
 * 
 */
package gov.va.med.imaging.viewerservices.proxy.rest;

import javax.ws.rs.core.MediaType;

import com.sun.jersey.api.client.ClientResponse;

import gov.va.med.imaging.proxy.rest.AbstractRestClient;
import gov.va.med.imaging.viewerservices.common.DefaultViewerServicesValues;

/**
 * @author William
 *
 */
public abstract class AbstractViewerServicesRestClient 
extends AbstractRestClient {

	public final static String httpHeaderConnectionType = "Connection";
	public final static String httpHeaderContentType = "Content-Type";
	public final static String httpHeaderSecurityToken = "xxx-securityToken";

	private final String CONTENTTYPE = "application/xml";
	private final String KEEPALIVE = "Keep-Alive";
	
	public AbstractViewerServicesRestClient(String url, String mediaType, 
			int metadataTimeoutMs){
		super(url, mediaType, metadataTimeoutMs);
	}

	
	public AbstractViewerServicesRestClient(String url, MediaType mediaType,
			int metadataTimeoutMs) {
		super(url, mediaType, metadataTimeoutMs);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.proxy.rest.AbstractRestClient#executeMethodInternal(java.lang.Class)
	 */
	@Override
	protected <T> ClientResponse executeMethodInternal(Class<T> c) {
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.proxy.rest.AbstractRestClient#addTransactionHeaders()
	 */
	@Override
	protected void addTransactionHeaders() 
	{
		request.header(httpHeaderConnectionType, KEEPALIVE);
		request.header(httpHeaderContentType, CONTENTTYPE);
	}
	
	
	protected static int getMetadataTimeoutMs()
	{
		return DefaultViewerServicesValues.defaultMetadataTimeoutMs;
	}

}
