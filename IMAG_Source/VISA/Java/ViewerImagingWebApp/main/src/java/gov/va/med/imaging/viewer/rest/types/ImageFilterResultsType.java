/**
 * Date Created: Apr 23, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="imageFilters")
public class ImageFilterResultsType
{
	
	private ImageFilterResultType[] imageFilters;
	
	public ImageFilterResultsType()
	{
		super();
	}

	/**
	 * @param imageFilters
	 */
	public ImageFilterResultsType(ImageFilterResultType[] imageFilters)
	{
		super();
		this.imageFilters = imageFilters;
	}

	/**
	 * @return the imageFilters
	 */
	@XmlElement(name="imageFilter")
	public ImageFilterResultType[] getImageFilters()
	{
		return imageFilters;
	}

	/**
	 * @param captureUsers the captureUsers to set
	 */
	public void setImageFilters(ImageFilterResultType[] imageFilters)
	{
		this.imageFilters = imageFilters;
	}

}

