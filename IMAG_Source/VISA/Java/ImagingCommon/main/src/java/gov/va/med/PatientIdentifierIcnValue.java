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
public class PatientIdentifierIcnValue
implements PatientIdentifierValue
{
	private final String icn;
	
	public PatientIdentifierIcnValue(String icn)
	{
		this.icn = icn;
	}

	/**
	 * @return the icn
	 */
	public String getIcn()
	{
		return icn;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString()
	{
		return getIcn();
	}

}
