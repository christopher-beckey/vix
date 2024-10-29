/**
 * 
 */
package gov.va.med.imaging.url.dx;

import java.net.MalformedURLException;
import java.net.URL;
import junit.framework.TestCase;

/**
 * @author vhaisltjahjb
 *
 */
public class TestDxConnection
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
						"" + handlerPackages + "|" + "gov.va.med.imaging.url");
		System.out.println("java.protocol.handler.pkgs: " + System.getProperty("java.protocol.handler.pkgs"));
	}

	public void testUrlAvailability()
	{
		try
        {
	        URL url = new URL("dx://localhost:8080");
	        assertNotNull(url);
        } 
		catch (MalformedURLException e)
        {
			fail("Protocol 'dx' is not available.");
        }
		
	}
	
	@Override
	protected void tearDown() 
	throws Exception
	{
		super.tearDown();
	}

}
