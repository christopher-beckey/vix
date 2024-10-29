/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian
 *
 */
@XmlRootElement(name="images")
public class ViewerStudyImagesType
{
	
	private ViewerStudyImageType [] images;
	
	public ViewerStudyImagesType()
	{
		super();
	}

	public ViewerStudyImagesType(ViewerStudyImageType[] images)
	{
		super();
		this.images = images;
	}

	@XmlElement(name = "image")
	public ViewerStudyImageType[] getImages()
	{
		return images;
	}

	public void setImages(ViewerStudyImageType[] images)
	{
		this.images = images;
	}

}
