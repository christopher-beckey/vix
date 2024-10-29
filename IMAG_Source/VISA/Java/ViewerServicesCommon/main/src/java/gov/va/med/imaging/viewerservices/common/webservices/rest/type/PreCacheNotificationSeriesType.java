package gov.va.med.imaging.viewerservices.common.webservices.rest.type;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

//@XmlRootElement(name="series")
public class PreCacheNotificationSeriesType 
implements Serializable{

	private static final long serialVersionUID = 1L;
	private List<PreCacheNotificationImagesType> series = null;

	public PreCacheNotificationSeriesType() {
		
	}

	/**
	 * @param series the series to set
	 */
	public void setSeries(List<PreCacheNotificationImagesType> series) {
		this.series = series;
	}
	
	@XmlElement(name = "images")
	public List<PreCacheNotificationImagesType> getSeries() {
		return series;
	}
	

}
