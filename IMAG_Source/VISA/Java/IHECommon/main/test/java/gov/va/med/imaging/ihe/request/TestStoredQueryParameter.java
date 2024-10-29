/**
 * 
 */
package gov.va.med.imaging.ihe.request;

import gov.va.med.imaging.ihe.exceptions.ParameterFormatException;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class TestStoredQueryParameter
extends TestCase
{
	
	public void testValidValues() 
	throws ParameterFormatException
	{
		StoredQueryParameter parameter = new StoredQueryParameter("a", new String[]{});
		assertNull( parameter.getValueAsString() );

		parameter = new StoredQueryParameter("d", new String[]{"'200305010903'"});
		assertNotNull( parameter.getValueAsString() );
		try
		{ 
			parameter.getValueAsDate();
			fail("Single quoted string should not be interpretable as a Date");
		}
		catch(ParameterFormatException pfX){}
		
		// allowing string values withouy quotes because that is what HAIMS supplies
		parameter = new StoredQueryParameter("d", new String[]{"200305010903"});
		try
		{ 
			parameter.getValueAsString();
			//fail("String parameters must be surronded by single quotes.");
		}
		catch(ParameterFormatException pfX){}
		assertNotNull( parameter.getValueAsDate() );
		
		parameter = new StoredQueryParameter("i", new String[]{"42"});
		assertNotNull( parameter.getValueAsInt() );
		
		parameter = new StoredQueryParameter("f", new String[]{"42.3"});
		assertNotNull( parameter.getValueAsFloat() );
	}
}
