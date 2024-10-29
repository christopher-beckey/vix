/**
 * 
  Property of ISI Group, LLC
  Date Created: May 9, 2014
  Developer:  Julian Werfel
 */
package gov.va.med.imaging.hydra.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="images")
public class HydraImagesType
{
	private HydraImageType [] image;

	public HydraImagesType(HydraImageType[] image) {
		super();
		this.image = image;
	}
	
	public HydraImagesType()
	{
		super();
	}

	public HydraImageType[] getImage() {
		return image;
	}

	public void setImage(HydraImageType[] image) {
		this.image = image;
	}
}
