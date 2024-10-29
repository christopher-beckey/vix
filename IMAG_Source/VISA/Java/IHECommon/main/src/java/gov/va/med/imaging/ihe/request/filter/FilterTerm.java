/**
 * 
 */
package gov.va.med.imaging.ihe.request.filter;

import java.util.Iterator;


/**
 * 
 * @author vhaiswbeckec
 *
 */
public abstract class FilterTerm
{
	private String codingScheme;
	
	/**
	 * @param codingScheme
	 */
	public FilterTerm(String codingScheme)
	{
		super();
		this.codingScheme = codingScheme;
	}
	
	public FilterTerm()
	{
		super();
		this.codingScheme = null;
	}
	
	public abstract boolean matches(String value) 
	throws InvalidTermValueFormatException;

	public String getCodingScheme()
	{
		return this.codingScheme;
	}
	
	public void setCodingScheme(String codingScheme)
	{
		this.codingScheme = codingScheme;
	}

	public abstract Iterator<SimpleTerm> getSimpleTermIterator();
}