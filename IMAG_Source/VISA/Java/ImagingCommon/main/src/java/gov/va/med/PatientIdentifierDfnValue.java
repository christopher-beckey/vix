/**
 * 
 * 
 * Date Created: Nov 7, 2013
 * Developer: Administrator
 */
package gov.va.med;

/**
 * @author Administrator
 *
 */
public class PatientIdentifierDfnValue
{
	private final String siteNumber;
	private final String dfn;
	
	/**
	 * @param siteNumber
	 * @param dfn
	 */
	public PatientIdentifierDfnValue(String siteNumber, String dfn)
	{
		super();
		this.siteNumber = siteNumber;
		this.dfn = dfn;
	}
	
	/**
	 * @return the siteNumber
	 */
	public String getSiteNumber()
	{
		return siteNumber;
	}
	
	/**
	 * @return the dfn
	 */
	public String getDfn()
	{
		return dfn;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString()
	{
		return getSiteNumber() + "-" + getDfn();
	}

}
