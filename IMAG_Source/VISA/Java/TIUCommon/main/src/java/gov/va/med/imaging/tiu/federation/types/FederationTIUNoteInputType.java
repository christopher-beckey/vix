package gov.va.med.imaging.tiu.federation.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.rest.types.RestStringType;


@XmlRootElement
public class FederationTIUNoteInputType {

	private RestStringType noteUrn; 
	private RestStringType patientIdentifier;
	private RestStringType locationUrn;
	private Date noteDate; 
	private RestStringType consultUrn; 
	private RestStringType noteText;
	private RestStringType authorUrn;
	
	
	public FederationTIUNoteInputType(RestStringType noteUrn, RestStringType patientIdentifier,
			RestStringType locationUrn, Date noteDate, RestStringType consultUrn, RestStringType noteText) {
		super();
		this.noteUrn = noteUrn;
		this.patientIdentifier = patientIdentifier;
		this.locationUrn = locationUrn;
		this.noteDate = noteDate;
		this.consultUrn = consultUrn;
		this.noteText = noteText;
	}

	public FederationTIUNoteInputType(RestStringType noteUrn, RestStringType patientIdentifier,
									  RestStringType locationUrn, Date noteDate, RestStringType consultUrn,
									  RestStringType noteText, RestStringType authorUrn) {
		super();
		this.noteUrn = noteUrn;
		this.patientIdentifier = patientIdentifier;
		this.locationUrn = locationUrn;
		this.noteDate = noteDate;
		this.consultUrn = consultUrn;
		this.noteText = noteText;
		this.authorUrn = authorUrn;
	}

	public FederationTIUNoteInputType() {
		super();
	}


	public RestStringType getNoteUrn() {
		return noteUrn;
	}


	public RestStringType getPatientIdentifier() {
		return patientIdentifier;
	}


	public RestStringType getLocationUrn() {
		return locationUrn;
	}


	public Date getNoteDate() {
		return noteDate;
	}


	public RestStringType getConsultUrn() {
		return consultUrn;
	}


	public RestStringType getNoteText() {
		return noteText;
	}


	public void setNoteUrn(RestStringType noteUrn) {
		this.noteUrn = noteUrn;
	}


	public void setPatientIdentifier(RestStringType patientIdentifier) {
		this.patientIdentifier = patientIdentifier;
	}


	public void setLocationUrn(RestStringType locationUrn) {
		this.locationUrn = locationUrn;
	}


	public void setNoteDate(Date noteDate) {
		this.noteDate = noteDate;
	}


	public void setConsultUrn(RestStringType consultUrn) {
		this.consultUrn = consultUrn;
	}


	public void setNoteText(RestStringType noteText) {
		this.noteText = noteText;
	}

	public RestStringType getAuthorUrn() {
		return authorUrn;
	}

	public void setAuthorUrn(RestStringType authorUrn) {
		this.authorUrn = authorUrn;
	}
	
	
	
	
	
}
