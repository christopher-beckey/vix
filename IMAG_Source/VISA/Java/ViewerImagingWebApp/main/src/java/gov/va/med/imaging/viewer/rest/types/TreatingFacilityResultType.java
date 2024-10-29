package gov.va.med.imaging.viewer.rest.types;

import java.util.Date;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: Feb 16, 2018
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="treatingFacility")
public class TreatingFacilityResultType
{
	private String institutionIEN;
	private String institutionName;
	private String currentDateOnRecord;
	private String facilityType;
	
	public TreatingFacilityResultType()
	{
		super();
	}

	public TreatingFacilityResultType(
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
	 * @param institutionIEN the institutionIEN to set
	 */
	public void setInstitutionIEN(String institutionIEN)
	{
		this.institutionIEN = institutionIEN;
	}

	/**
	 * @return the institutionName
	 */
	public String getInstitutionName()
	{
		return institutionName;
	}

	/**
	 * @param institutionName the institutionName to set
	 */
	public void setInstitutionName(String institutionName)
	{
		this.institutionName = institutionName;
	}

	/**
	 * @return the result currentDateOnRecord
	 */
	public String getCurrentDateOnRecord()
	{
		return currentDateOnRecord;
	}
	
	/**
	 * @param currentDateOnRecord the currentDateOnRecord to set
	 */
	public void setCurrentDateOnRecord(String currentDateOnRecord)
	{
		this.currentDateOnRecord = currentDateOnRecord;
	}

	/**
	 * @return the institutionName
	 */
	public String getFacilityType()
	{
		return facilityType;
	}

	/**
	 * @param facilityType the facilityType to set
	 */
	public void setFacilityType(String facilityType)
	{
		this.facilityType = facilityType;
	}


}
