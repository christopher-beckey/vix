package gov.va.med.imaging.viewerservices.common.webservices.rest.type;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

//@XmlRootElement(name="study")
public class PreCacheNotificationStudyType 
implements Serializable{

	private static final long serialVersionUID = 1L;
	private String contextId = null;
	private String studyId = null;
	private String patientICN = null;
	private String patientDFN = null;
	private String siteNumber = null;
	private List<PreCacheNotificationSeriesesType> study = null;
	
	
	public PreCacheNotificationStudyType() 
	{
		
	}


	/**
	 * @param contextId the contextId to set
	 */
	public void setContextId(String contextId) {
		this.contextId = contextId;
	}

	public String getContextId() {
		return contextId;
	}

	/**
	 * @param studyId the studyId to set
	 */
	public void setStudyId(String studyId) {
		this.studyId = studyId;
	}

	public String getStudyId() {
		return studyId;
	}

	/**
	 * @param patientICN the patientICN to set
	 */
	public void setPatientICN(String patientICN) {
		this.patientICN = patientICN;
	}

	public String getPatientICN() {
		return patientICN;
	}


	/**
	 * @param patientDFN the patientDFN to set
	 */
	public void setPatientDFN(String patientDFN) {
		this.patientDFN = patientDFN;
	}

	public String getPatientDFN() {
		return patientDFN;
	}

	/**
	 * @param siteNumber the siteNumber to set
	 */
	public void setSiteNumber(String siteNumber) {
		this.siteNumber = siteNumber;
	}

	public String getSiteNumber() {
		return siteNumber;
	}

	/**
	 * @param study the study to set
	 */
	public void setStudy(List<PreCacheNotificationSeriesesType> study) {
		this.study = study;
	}
	
	@XmlElement(name = "serieses")
	public List<PreCacheNotificationSeriesesType> getStudy() {
		return study;
	}


}
