package gov.va.med.imaging.url.dxs;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLStreamHandler;

/**
 * @author VHAISWWERFEJ
 *
 */
public class Handler 
extends URLStreamHandler 
{
	public static final String protocolScheme = "dxs";
	public static final String baseProtocolScheme = "https";
	
	/* (non-Javadoc)
	 * @see java.net.URLStreamHandler#openConnection(java.net.URL)
	 */
	@Override
	protected URLConnection openConnection(URL url) 
	throws IOException 
	{
		if(url == null)
			throw new MalformedURLException("Null URL passed to " + this.getClass().getName() + ".openConnection()");
		
		if(url.getProtocol() == null)
			throw new MalformedURLException("Null protocol in URL passed to " + this.getClass().getName() + ".openConnection()");
		
		if(url.getHost() == null)
			throw new MalformedURLException("Null host in URL passed to " + this.getClass().getName() + ".openConnection()");
		
		if(!protocolScheme.equals(url.getProtocol()) )
			throw new MalformedURLException("Unsupported protocol '" + url.getProtocol() + "' passed to " + this.getClass().getName() + ".openConnection()");
		
		return new gov.va.med.imaging.url.dxs.DxsConnection(url);
	}

}
