package gov.va.med.imaging.url.awiv;


import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

/**
 * @author VHAISWWERFEJ
 *
 */
public class Connection 
extends URLConnection 
{
	/**
	 * 
	 * @param awivUrl
	 * @return
	 * @throws MalformedURLException
	 */
	private static URL interpretUrl(URL awivUrl) 
	throws MalformedURLException
	{
		return new URL(Handler.baseProtocolScheme, awivUrl.getHost(), awivUrl.getFile());
	}
	
	public Connection(URL url)
	{
		super(url);		
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
