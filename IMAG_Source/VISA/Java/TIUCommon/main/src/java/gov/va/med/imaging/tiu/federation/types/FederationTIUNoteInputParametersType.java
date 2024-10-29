package gov.va.med.imaging.tiu.federation.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;


@XmlRootElement
public class FederationTIUNoteInputParametersType {

	private FederationTIUNoteRequestStatusType noteStatus;
	private RestStringType patientIdentifier;
	private String fromDate; 
	private String toDate; 
	private String authorDuz; 
	private int count; 
	private boolean ascending;
	
	
	public FederationTIUNoteInputParametersType(FederationTIUNoteRequestStatusType noteStatus, RestStringType patientIdentifier,
			String fromDate, String toDate, String authorDuz, int count, boolean ascending) {
		super();
		this.noteStatus = noteStatus;
		this.patientIdentifier = patientIdentifier;
		this.fromDate = fromDate;
		this.toDate = toDate;
		this.authorDuz = authorDuz;
		this.count = count;
		this.ascending = ascending;
	}


	public FederationTIUNoteInputParametersType() {
		super();
	}


	public FederationTIUNoteRequestStatusType getNoteStatus() {
		return noteStatus;
	}


	public RestStringType getPatientIdentifier() {
		return patientIdentifier;
	}


	public String getFromDate() {
		return fromDate;
	}


	public String getToDate() {
		return toDate;
	}


	public String getAuthorDuz() {
		return authorDuz;
	}


	public int getCount() {
		return count;
	}


	public boolean isAscending() {
		return ascending;
	}


	public void setNoteStatus(FederationTIUNoteRequestStatusType noteStatus) {
		this.noteStatus = noteStatus;
	}


	public void setPatientIdentifier(RestStringType patientIdentifier) {
		this.patientIdentifier = patientIdentifier;
	}


	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}


	public void setToDate(String toDate) {
		this.toDate = toDate;
	}


	public void setAuthorDuz(String authorDuz) {
		this.authorDuz = authorDuz;
	}


	public void setCount(int count) {
		this.count = count;
	}


	public void setAscending(boolean ascending) {
		this.ascending = ascending;
	}
	
	
	
	
}
