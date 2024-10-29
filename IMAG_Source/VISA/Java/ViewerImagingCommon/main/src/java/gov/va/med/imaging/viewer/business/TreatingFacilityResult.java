/**
 * Date Created: Feb 16, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

import java.util.Date;

/**
 * @author vhaisltjahjb
 *
 */
public class TreatingFacilityResult
{
	private final String institutionIEN;
	private final String institutionName;
	private final String facilityType;
	private final String currentDateOnRecord;

	/**
	 * @param institutionIEN
	 * @param institutionName
	 * @param currentDateOnRecord
	 * @param facilityType
	 */
	public TreatingFacilityResult(
			String institutionIEN,
			String institutionName,
			String currentDateOnRecord,
			String facilityType)
	{
		super();
		this.institutionIEN = institutionIEN;
		this.institutionName = institutionName;
		this.currentDateOnRecord = currentDateOnRecord;
		this.facilityType = facilityType;
	}

	/**
	 * @return the institutionIEN
	 */
	public String getInstitutionIEN()
	{
		return institutionIEN;
	}

	/**
	 * @return the institutionName
	 */
	public String getInstitutionName()
	{
		return institutionName;
	}

	/**
	 * @return the result currentDateOnRecord
	 */
	public String getCurrentDateOnRecord()
	{
		return currentDateOnRecord;
	}
	
	/**
	 * @return the institutionName
	 */
	public String getFacilityType()
	{
		return facilityType;
	}

}


