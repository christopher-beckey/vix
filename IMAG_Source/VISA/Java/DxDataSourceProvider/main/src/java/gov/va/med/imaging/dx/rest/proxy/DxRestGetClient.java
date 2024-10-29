package gov.va.med.imaging.dx.rest.proxy;

import java.io.InputStream;
import javax.ws.rs.core.MediaType;
import com.sun.jersey.api.client.ClientResponse;import gov.va.med.logging.Logger;

/**
* @author vhaisltjahjb
*
*/
public class DxRestGetClient 
extends AbstractDxRestClient
{
    private final static Logger logger = Logger.getLogger(DxRestGetClient.class);
		
	public DxRestGetClient(String url, MediaType mediaType) 
	{
		super(url, mediaType);
	}
       
   @Override
   protected <T> ClientResponse executeMethodInternal(Class<T> c) 
   {
		ClientResponse res = getRequest().get(ClientResponse.class); 
		return res;
   }

   public ClientResponse getInputStreamResponse()
   {
		return executeMethodInternal(InputStream.class);
   }
}
