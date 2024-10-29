/**
 * 
 */
package gov.va.med.imaging.muse.proxy.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;

import javax.ws.rs.core.MediaType;

import com.sun.jersey.api.client.ClientResponse;

/**
 * @author William Peterson
 *
 */
public class MuseRestPostClient 
extends AbstractMuseRestClient {


	/**
	 * @param url
	 * @param mediaType
	 * @param metadataTimeoutMs
	 */
	public MuseRestPostClient(String url, String mediaType,
			int metadataTimeoutMs) {
		super(url, mediaType, metadataTimeoutMs);
	}

	public MuseRestPostClient(String url, MediaType mediaType,
			int metadataTimeoutMs) {
		super(url, mediaType, metadataTimeoutMs);
	}

	public <T> T executeRequest(Class<T> c, Object... postParameter)
			throws MethodException, ConnectionException {
		if(postParameter != null)
		{
			for(Object pp : postParameter)
			{	
				//WFP-May want to change media type to application/xml.
				getRequest().entity(pp, MediaType.TEXT_XML_TYPE);
			}
		}
		getLogger().debug("Finished building request message body.  Now executing the Request.");
		return super.executeRequest(c);
	}

	@Override
	protected <T> ClientResponse executeMethodInternal(Class<T> c) {
		return getRequest().post(ClientResponse.class);
	}
	
	

}
