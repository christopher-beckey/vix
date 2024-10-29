/**
 * Date Created: June 1, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="flagSensitiveImageUrnResults")
public class FlagSensitiveImageUrnResultsType
{
	
	private FlagSensitiveImageUrnResultType[] imageUrns;
	
	public FlagSensitiveImageUrnResultsType()
	{
		super();
	}

	/**
	 * @param imageUrns
	 */
	public FlagSensitiveImageUrnResultsType(FlagSensitiveImageUrnResultType[] imageUrns)
	{
		super();
		this.imageUrns = imageUrns;
	}

	/**
	 * @return the imagingUrns
	 */
	@XmlElement(name="imageUrn")
	public FlagSensitiveImageUrnResultType[] getImageUrns()
	{
		return imageUrns;
	}

	/**
	 * @param imageUrns the imageUrns to set
	 */
	public void setImageUrns(FlagSensitiveImageUrnResultType[] imageUrns)
	{
		this.imageUrns = imageUrns;
	}

}
