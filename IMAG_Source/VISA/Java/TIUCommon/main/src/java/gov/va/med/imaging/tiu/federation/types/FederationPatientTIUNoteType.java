package gov.va.med.imaging.tiu.federation.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.rest.types.RestStringType;

/**
 * @author William Peterson
 *
 */
@XmlRootElement
public class FederationPatientTIUNoteType {

	private RestStringType patientTiuNoteUrn;
	private String title;
	private Date date;
	private String patientName;
	private String authorName;
	private String authorDuz;
	private String hospitalLocation;
	private String signatureStatus;
	private Date dischargeDate;
	private int numberAssociatedImages;
	private RestStringType parentPatientTiuNoteUrn;
	
	public FederationPatientTIUNoteType(RestStringType patientTiuNoteUrn, String title, Date date, String patientName,
			String authorName, String authorDuz, String hospitalLocation, String signatureStatus, Date dischargeDate,
			int numberAssociatedImages, RestStringType parentPatientTiuNoteUrn) {
		super();
		this.patientTiuNoteUrn = patientTiuNoteUrn;
		this.title = title;
		this.date = date;
		this.patientName = patientName;
		this.authorName = authorName;
		this.authorDuz = authorDuz;
		this.hospitalLocation = hospitalLocation;
		this.signatureStatus = signatureStatus;
		this.dischargeDate = dischargeDate;
		this.numberAssociatedImages = numberAssociatedImages;
		this.parentPatientTiuNoteUrn = parentPatientTiuNoteUrn;
	}
	
	public FederationPatientTIUNoteType() {
		super();
	}



	public RestStringType getPatientTiuNoteUrn() {
		return patientTiuNoteUrn;
	}

	public String getTitle() {
		return title;
	}

	public Date getDate() {
		return date;
	}

	public String getPatientName() {
		return patientName;
	}

	public String getAuthorName() {
		return authorName;
	}

	public String getAuthorDuz() {
		return authorDuz;
	}

	public String getHospitalLocation() {
		return hospitalLocation;
	}

	public String getSignatureStatus() {
		return signatureStatus;
	}

	public Date getDischargeDate() {
		return dischargeDate;
	}

	public int getNumberAssociatedImages() {
		return numberAssociatedImages;
	}

	public RestStringType getParentPatientTiuNoteUrn() {
		return parentPatientTiuNoteUrn;
	}

	public void setPatientTiuNoteUrn(RestStringType patientTiuNoteUrn) {
		this.patientTiuNoteUrn = patientTiuNoteUrn;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public void setPatientName(String patientName) {
		this.patientName = patientName;
	}

	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}

	public void setAuthorDuz(String authorDuz) {
		this.authorDuz = authorDuz;
	}

	public void setHospitalLocation(String hospitalLocation) {
		this.hospitalLocation = hospitalLocation;
	}

	public void setSignatureStatus(String signatureStatus) {
		this.signatureStatus = signatureStatus;
	}

	public void setDischargeDate(Date dischargeDate) {
		this.dischargeDate = dischargeDate;
	}

	public void setNumberAssociatedImages(int numberAssociatedImages) {
		this.numberAssociatedImages = numberAssociatedImages;
	}

	public void setParentPatientTiuNoteUrn(RestStringType parentPatientTiuNoteUrn) {
		this.parentPatientTiuNoteUrn = parentPatientTiuNoteUrn;
	}
	
	
}
