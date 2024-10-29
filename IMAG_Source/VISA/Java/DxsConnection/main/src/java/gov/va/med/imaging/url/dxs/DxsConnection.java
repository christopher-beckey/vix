package gov.va.med.imaging.url.dxs;


import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

/**
 * @author vhaisltjahjb
 *
 */
public class DxsConnection 
extends URLConnection 
{
	/**
	 * 
	 * @param url
	 * @return
	 * @throws MalformedURLException
	 */
	private static URL interpretUrl(URL url) 
	{
		try
		{
			return new URL(Handler.baseProtocolScheme, url.getHost(), url.getFile());
		}
		catch (MalformedURLException x)
		{
			x.printStackTrace();
			return null;
		}
	}
	
	public DxsConnection(URL url)
	{
		super( interpretUrl(url) );		
	}

	/* (non-Javadoc)
	 * @see java.net.URLConnection#connect()
	 */
	@Override
	public void connect() 
	throws IOException 
	{
		this.connected = true;
	}

}
