package gov.va.med.imaging.viewerservices.common.webservices.rest.type;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

//@XmlRootElement(name="images")
public class PreCacheNotificationImagesType 
implements Serializable{

	private static final long serialVersionUID = 1L;
	private List<PreCacheNotificationImageType> images = null;

	public PreCacheNotificationImagesType() 
	{
		
	}

	/**
	 * @param images the images to set
	 */
	public void setImages(List<PreCacheNotificationImageType> images) 
	{
		this.images = images;
	}
	
	@XmlElement(name = "image")
	public List<PreCacheNotificationImageType> getImages()
	{
		return images;
	}

}
