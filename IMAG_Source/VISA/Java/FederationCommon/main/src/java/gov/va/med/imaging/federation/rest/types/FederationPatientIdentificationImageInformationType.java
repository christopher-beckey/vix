package gov.va.med.imaging.federation.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class FederationPatientIdentificationImageInformationType {

	private String patientName;

	private String filename;

	private String imageIen;
	
	private String studyIen;

	private String siteId;

	private String patientIcn;

	private Date dateCaptured;
	
	private String imageFormat;
	
	private String imageExtension;
	
	public FederationPatientIdentificationImageInformationType() {
    	super();
	}

	public String getPatientName() {
		return patientName;
	}

	public void setPatientName(String patientName) {
		this.patientName = patientName;
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public String getImageIen() {
		return imageIen;
	}

	public void setImageIen(String imageIen) {
		this.imageIen = imageIen;
	}

	public Date getDateCaptured() {
		return dateCaptured;
	}

	public void setDateCaptured(Date dateCaptured) {
		this.dateCaptured = dateCaptured;
	}

	public String getStudyIen() {
		return studyIen;
	}

	public void setStudyIen(String studyIen) {
		this.studyIen = studyIen;
	}

	public String getSiteId() {
		return siteId;
	}

	public void setSiteId(String siteId) {
		this.siteId = siteId;
	}

	public String getPatientIcn() {
		return patientIcn;
	}

	public void setPatientIcn(String patientIcn) {
		this.patientIcn = patientIcn;
	}

	public String getImageFormat() {
		return imageFormat;
	}

	public void setImageFormat(String imageFormat) {
		this.imageFormat = imageFormat;
	}

	public String getImageExtension() {
		return imageExtension;
	}

	public void setImageExtension(String imageExtension) {
		this.imageExtension = imageExtension;
	}

	
}
