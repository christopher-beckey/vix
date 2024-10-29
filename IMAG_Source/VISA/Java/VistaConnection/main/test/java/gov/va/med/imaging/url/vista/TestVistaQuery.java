/**
 * 
 */
package gov.va.med.imaging.url.vista;

import gov.va.med.imaging.url.vista.enums.VistaConnectionType;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import java.util.HashMap;
import java.util.Map;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class TestVistaQuery
extends TestCase
{
	
	public void testStrPack()
	{
		assertEquals( "00010HelloWorld", VistaQuery.strPack("HelloWorld", 5) );
		assertEquals( "10HelloWorld", VistaQuery.strPack("HelloWorld", 2) );
		assertEquals( "00", VistaQuery.strPack(null, 2) );
	}
	
	public void testBuildMessage() 
	throws VistaMethodException
	{
		VistaQuery vistaQuery = new VistaQuery("RPCName");
		System.out.println( vistaQuery.buildMessage(VistaConnectionType.oldStyle) );
		
		vistaQuery.addParameter(VistaQuery.LITERAL, "parameter0");
		System.out.println( vistaQuery.buildMessage(VistaConnectionType.oldStyle) );
		
		Map<String, String> listParameter = new HashMap<String, String>();
		listParameter.put("1", "ListValue001");
		vistaQuery.addParameter(VistaQuery.LIST, listParameter);
		System.out.println( vistaQuery.buildMessage(VistaConnectionType.oldStyle) );
	}
	
	public void testNothing()
	{
		System.out.println( "Executing null test" );
	}
	
	public void testPackLength()
	{
		System.out.println("Executing packLength test");
		assertEquals("00035", VistaQuery.packLength(35, 5));
		assertEquals("35", VistaQuery.packLength(35, 2));
		assertEquals("56000", VistaQuery.packLength(356000, 5));
	}
	
	public void testBuildLargeArrayQuery()
	{
		System.out.println("Executing BuildLargeArrayQuery test");
		VistaQuery query = new VistaQuery("MAGVA ENQUEUE Q MSG");
		HashMap<String, String> params = new HashMap<String, String>();
		params.put("QUEUE", "4");
		params.put("PRIORITY", "1");
		params.put("EARLIEST DELIVERY DATE/TIME", "20130305.141810");
		
		for(int i = 1; i <= 10000; i++)
		{
			params.put("MAGMSG" + i, getEnqueueMessage());
		}
		query.addParameter(VistaQuery.ARRAY, params);
	
		try
		{
			long startTime = System.currentTimeMillis();
			String rpcMsg = query.buildMessage(VistaConnectionType.oldStyle);
			long endTime = System.currentTimeMillis();
			assertNotNull(rpcMsg);
			assertEquals(2639040, rpcMsg.length());
			
			
			long differenceTime = (endTime - startTime);
			System.out.println("Generated RPC in [" + differenceTime + "] ms");
			assertTrue( (differenceTime < 1000) ) ; // ensure it takes less than 1 second to generate the query
			
			// be sure the start is correct with the right number of prefix characters
			assertTrue(rpcMsg.startsWith("{XWB}3903000047007XWB;;;;000321MAGVA ENQUEUE Q MSG"));
			
			
			
			//System.out.println("RpcMsg [" + rpcMsg.substring(0, 100) + "]");
			
			// 2639040
			// System.out.println("Temp length [" + temp.length() + "]");
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			fail(ex.getMessage());
		}
	}
	
	private String getEnqueueMessage()
	{
		return "Role in development of a national healthcare network Role in development \\nof a national healthcare network Role in development of a national healthcare ne\\ntwork Role in development of a national healthcare network Role in development o\\nf a nat";		
	}
}
