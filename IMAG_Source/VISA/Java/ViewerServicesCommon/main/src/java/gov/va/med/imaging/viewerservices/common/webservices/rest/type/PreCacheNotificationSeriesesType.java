package gov.va.med.imaging.viewerservices.common.webservices.rest.type;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="serieses")
public class PreCacheNotificationSeriesesType 
implements Serializable{

	private static final long serialVersionUID = 1L;
	private List<PreCacheNotificationSeriesType> serieses = null;

	public PreCacheNotificationSeriesesType() 
	{
		
	}

	/**
	 * @param studies the studies to set
	 */
	public void setSerieses(List<PreCacheNotificationSeriesType> serieses) 
	{
		this.serieses = serieses;
	}
	
	@XmlElement(name = "series")
	public List<PreCacheNotificationSeriesType> getSerieses()
	{
		return serieses;
	}

}
