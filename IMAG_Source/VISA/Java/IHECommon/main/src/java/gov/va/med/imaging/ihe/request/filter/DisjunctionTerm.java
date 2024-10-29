/**
 * 
 */
package gov.va.med.imaging.ihe.request.filter;

/**
 * A binary term, consisting of two filter terms joined by an OR operator.
 * 
 * @author vhaiswbeckec
 *
 */
public class DisjunctionTerm
extends BinaryTerm
{
	public DisjunctionTerm(FilterTerm leftTerm, FilterTerm rightTerm)
	{
		super(leftTerm, rightTerm);
	}
	
	@Override
	public boolean matches(String value) 
	throws InvalidTermValueFormatException
	{
		return getLeftTerm().matches(value) && getRightTerm().matches(value);
	}

	@Override
	public String toString()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(getLeftTerm().toString());
		sb.append(" OR ");
		sb.append(getRightTerm().toString());
		
		return sb.toString();
	}
}