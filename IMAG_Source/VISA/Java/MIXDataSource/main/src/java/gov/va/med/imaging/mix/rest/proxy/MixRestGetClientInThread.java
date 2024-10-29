package gov.va.med.imaging.mix.rest.proxy;

import java.io.InputStream;

import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;

import javax.ws.rs.core.MediaType;

import com.sun.jersey.api.client.ClientResponse;

/**
 * @author vacotittoc
 *
 */
public class MixRestGetClientInThread 
extends AbstractMixRestClientInThread
{
	public MixRestGetClientInThread(String url, MediaType mediaType, 
			MIXConfiguration mixConfiguration)
	{
		super(url, mediaType.toString(), mixConfiguration);
	}
	
    public ClientResponse getInputStreamResponse()
    {
		return executeMethodInternal(InputStream.class);
    }

    @Override
	protected <T> ClientResponse executeMethodInternal(Class<T> c) 
	{
		return getRequest().get(ClientResponse.class);
	}
}
