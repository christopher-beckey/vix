/**
 * Date Created: Feb 16, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="treatingFacilityResults")
public class TreatingFacilityResultsType
{
	
	private TreatingFacilityResultType[] treatingFacilities;
	
	public TreatingFacilityResultsType()
	{
		super();
	}

	/**
	 * @param treatingFacilities
	 */
	public TreatingFacilityResultsType(TreatingFacilityResultType[] treatingFacilities)
	{
		super();
		this.treatingFacilities = treatingFacilities;
	}

	/**
	 * @return the treatingFacilities
	 */
	@XmlElement(name="treatingFacility")
	public TreatingFacilityResultType[] getTreatingFacilities()
	{
		return treatingFacilities;
	}

	/**
	 * @param treatingFacilities the treatingFacilities to set
	 */
	public void setTreatingFacilities(TreatingFacilityResultType[] treatingFacilities)
	{
		this.treatingFacilities = treatingFacilities;
	}

}

