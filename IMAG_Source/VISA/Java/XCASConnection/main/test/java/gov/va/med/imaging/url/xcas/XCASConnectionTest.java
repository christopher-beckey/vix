/**
 * 
 */
package gov.va.med.imaging.url.xcas;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class XCASConnectionTest
extends TestCase
{
	/**
	 * 
	 * java -Djava.protocol.handler.pkgs=gov.va.med.imaging.url
	 * 
	 * @see junit.framework.TestCase#setUp()
	 */
	@Override
	protected void setUp() 
	throws Exception
	{
		super.setUp();
		
		String handlerPackages = System.getProperty("java.protocol.handler.pkgs");
		System.setProperty("java.protocol.handler.pkgs",
				handlerPackages == null || handlerPackages.length() == 0 ? 
						"gov.va.med.imaging.url" : 
						handlerPackages + "|" + "gov.va.med.imaging.url");
		System.out.println("java.protocol.handler.pkgs: " + System.getProperty("java.protocol.handler.pkgs"));
	}

	public void testUrlAvailability()
	{
		try
        {
	        URL secureUrl = new URL("xcas://www.google.com");
	        assertNotNull(secureUrl);
	        URL url = new URL("xca://www.google.com");
	        
	        URLConnection secureConnection = secureUrl.openConnection();
	        secureConnection.connect();
	        System.out.println("Connected to '" + secureConnection.getURL().toString() + "'.");
	        
	        URLConnection connection = url.openConnection();
	        connection.connect();
	        System.out.println("Connected to '" + connection.getURL().toString() + "'.");
	        
	        //Object content = connection.getContent();
	        //assertNotNull(content);
	        //System.out.println("GOT an object of type '" + content.getClass().getCanonicalName() + "'.");
	        //assertNotNull( connection.getHeaderField("content-type") );
        } 
		catch (MalformedURLException e)
        {
			fail("Protocol 'xcas' is not available.");
        }
		catch (IOException x)
		{
			x.printStackTrace();
			fail("Protocol 'xcas' failed to connct as https.");
		}
		
	}
	
	@Override
	protected void tearDown() 
	throws Exception
	{
		super.tearDown();
	}

}