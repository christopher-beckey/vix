/**
 * 
 */
package gov.va.med.imaging.ihe.request.filter;

public class ConjunctionTerm
extends BinaryTerm
{
	public ConjunctionTerm(FilterTerm leftTerm, FilterTerm rightTerm)
	{
		super(leftTerm, rightTerm);
	}
	
	@Override
	public boolean matches(String value) 
	throws InvalidTermValueFormatException
	{
		return getLeftTerm().matches(value) || getRightTerm().matches(value);
	}

	@Override
	public String toString()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(getLeftTerm().toString());
		sb.append(" AND ");
		sb.append(getRightTerm().toString());
		
		return sb.toString();
	}
}