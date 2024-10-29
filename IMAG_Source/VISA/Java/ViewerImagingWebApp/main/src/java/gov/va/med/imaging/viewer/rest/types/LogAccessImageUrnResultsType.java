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
@XmlRootElement(name="logAccessImageUrnResults")
public class LogAccessImageUrnResultsType
{
	
	private LogAccessImageUrnResultType[] imageUrns;
	
	public LogAccessImageUrnResultsType()
	{
		super();
	}

	/**
	 * @param imageUrns
	 */
	public LogAccessImageUrnResultsType(LogAccessImageUrnResultType[] imageUrns)
	{
		super();
		this.imageUrns = imageUrns;
	}

	/**
	 * @return the imagingUrns
	 */
	@XmlElement(name="imageUrn")
	public LogAccessImageUrnResultType[] getImageUrns()
	{
		return imageUrns;
	}

	/**
	 * @param imageUrns the imageUrns to set
	 */
	public void setImageUrns(LogAccessImageUrnResultType[] imageUrns)
	{
		this.imageUrns = imageUrns;
	}

}
