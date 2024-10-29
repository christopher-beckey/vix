/**
 * Date Created: May 2, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="imageProperties")
public class ImagePropertiesType
{
	
	private ImagePropertyType[] imageProperties;
	
	public ImagePropertiesType()
	{
		super();
	}

	/**
	 * @param imageProperties
	 */
	public ImagePropertiesType(ImagePropertyType[] imageProperties)
	{
		super();
		this.imageProperties = imageProperties;
	}

	/**
	 * @return the imageProperties
	 */
	@XmlElement(name="imageProperty")
	public ImagePropertyType[] getImageProperties()
	{
		return imageProperties;
	}

	/**
	 * @param imageProperties the imageProperties to set
	 */
	public void setImageProperties(ImagePropertyType[] imageProperties)
	{
		this.imageProperties = imageProperties;
	}
	
}
