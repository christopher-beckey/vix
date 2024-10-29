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
public class TestStoredQueryParameterList
extends TestCase
{
	public void testSimpleAdd() 
	throws ParameterFormatException
	{
		StoredQueryParameterList list = new StoredQueryParameterList();
		
		list.add( new StoredQueryParameter("name1", new String[]{"'a'"}) );
		assertNotNull( list.getByName("name1") );
		assertNotNull( list.getByName("name1").getFilterTerm() );
		
		list.add( new StoredQueryParameter("name2", new String[]{"'a'", "'b'"}) );
		assertNotNull( list.getByName("name2") );
		assertNotNull( list.getByName("name2").getFilterTerm() );
		
		list.add( new StoredQueryParameter("name3", new String[]{"'a'", "'b'", "'c'"}) );
		assertNotNull( list.getByName("name3") );
		assertNotNull( list.getByName("name3").getFilterTerm() );
		
		list.add( new StoredQueryParameter("name4", new String[]{"1"}) );
		assertNotNull( list.getByName("name4") );
		assertNotNull( list.getByName("name4").getValueAsInt() );
		
		list.add( new StoredQueryParameter("name5", new String[]{"1", "2"}) );
		assertNotNull( list.getByName("name3").getFilterTerm() );
	}
	
	public void testMergingAdd()
	{
		
	}
	
	public void testCodingSchemeMergingAdd()
	{
		
	}
}
