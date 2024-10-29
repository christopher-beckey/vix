/**
 * 
 */
package gov.va.med.imaging.muse.proxy.rest;

import gov.va.med.imaging.muse.DefaultMuseValues;
import gov.va.med.imaging.musedatasource.MuseDataSourceProvider;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.rest.AbstractRestClient;

import javax.ws.rs.core.MediaType;

import com.sun.jersey.api.client.ClientResponse;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractMuseRestClient 
extends AbstractRestClient {

	public final static String httpHeaderMuseAPIKey = "MUSEAPILicenseKey";
	public final static String httpHeaderConnectionType = "Connection";

	private final String CONTENTTYPE = "application/xml";
	private final String KEEPALIVE = "Keep-Alive";
	
	public AbstractMuseRestClient(String url, String mediaType, 
			int metadataTimeoutMs){
		super(url, mediaType, metadataTimeoutMs);
	}

	
	public AbstractMuseRestClient(String url, MediaType mediaType,
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
	protected void addTransactionHeaders() {

		request.header(httpHeaderMuseAPIKey, MuseDataSourceProvider.getMuseConfiguration().getMuseAPIKey());
	
		request.header(httpHeaderConnectionType, KEEPALIVE);
	}
	
	
	protected static int getMetadataTimeoutMs(MuseServerConfiguration museServer)
	{
		if(museServer != null)
		{
			return museServer.getMetadataTimeoutMs();
		}
		return DefaultMuseValues.defaultMetadataTimeoutMs;
	}


}
