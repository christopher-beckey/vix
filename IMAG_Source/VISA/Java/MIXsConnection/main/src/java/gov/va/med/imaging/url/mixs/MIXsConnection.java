package gov.va.med.imaging.url.mixs;


import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import gov.va.med.imaging.url.vista.StringUtils;


/**
 * @author vhaisatittoc
 *
 */
public class MIXsConnection 
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
			return new URL(Handler.baseProtocolScheme, url.getHost(), 
					StringUtils.cleanString(url.getFile()));
		}
		catch (MalformedURLException x)
		{
			x.printStackTrace();
			return null;
		}
	}
	
	public MIXsConnection(URL url)
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
