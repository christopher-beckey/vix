/**
 * Date Created: Aug 3, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="setImagePropertiesResults")
public class SetImagePropertiesResultsType
{
	
	private String[] imageProperties;
	
	public SetImagePropertiesResultsType()
	{
		super();
	}

	/**
	 * @param imageUrns
	 */
	public SetImagePropertiesResultsType(String[] imageProperties)
	{
		super();
		this.imageProperties = imageProperties;
	}

	/**
	 * @return the imageProperties
	 */
	@XmlElement(name="setImagePropertyResult")
	public String[] getImageProperties()
	{
		return imageProperties;
	}

	/**
	 * @param imageProperties the imageProperties to set
	 */
	public void setImageProperties(String[] imageProperties)
	{
		this.imageProperties = imageProperties;
	}

}
