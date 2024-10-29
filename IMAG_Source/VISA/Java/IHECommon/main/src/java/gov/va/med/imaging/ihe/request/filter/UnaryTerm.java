/**
 * 
 */
package gov.va.med.imaging.ihe.request.filter;

/**
 * @author vhaiswbeckec
 *
 */
public abstract class UnaryTerm
extends FilterTerm
{

	/**
	 * 
	 */
	public UnaryTerm()
	{
		super();
	}

	/**
	 * @param codingScheme
	 */
	public UnaryTerm(String codingScheme)
	{
		super(codingScheme);
	}

}
