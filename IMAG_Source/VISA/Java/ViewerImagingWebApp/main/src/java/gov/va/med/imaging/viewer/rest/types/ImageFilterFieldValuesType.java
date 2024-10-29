/**
 * Date Created: July 31, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="imageFilterFieldValues")
public class ImageFilterFieldValuesType
{
	
	private ImageFilterFieldValueType[] imageFilterFieldValues;
	
	public ImageFilterFieldValuesType()
	{
		super();
	}

	/**
	 * @param imageFilterFieldValues
	 */
	public ImageFilterFieldValuesType(ImageFilterFieldValueType[] imageFilterFieldValues)
	{
		super();
		this.imageFilterFieldValues = imageFilterFieldValues;
	}

	/**
	 * @return the imageFilterFieldValues
	 */
	@XmlElement(name="imageFilterFieldValue")
	public ImageFilterFieldValueType[] getImageFilterFieldValues()
	{
		return imageFilterFieldValues;
	}

	/**
	 * @param imageFilterFieldValues the imageFilterFieldValues to set
	 */
	public void setImageFilterFieldValues(ImageFilterFieldValueType[] imageFilterFieldValues)
	{
		this.imageFilterFieldValues = imageFilterFieldValues;
	}
	
	
}
