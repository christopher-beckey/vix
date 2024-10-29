package gov.va.med.imaging.viewerservices.common.webservices.rest.type;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="studies")
public class PreCacheNotificationType 
implements Serializable{

	private static final long serialVersionUID = 1L;
	private List<PreCacheNotificationStudyType> studies = null;

	public PreCacheNotificationType() 
	{
		
	}

	/**
	 * @param studies the studies to set
	 */
	public void setStudies(List<PreCacheNotificationStudyType> studies) 
	{
		this.studies = studies;
	}
	
	@XmlElement(name = "study")
	public List<PreCacheNotificationStudyType> getStudies()
	{
		return studies;
	}

}
