package gov.va.med.imaging.consult.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.rest.types.RestStringType;

/**
 * @author William Peterson
 *
 */
@XmlRootElement
public class FederationConsultType {

	private RestStringType consultUrn;
	private String date;
	private String service;
	private String procedure;
	private String status;
	private int numberNotes;

	public FederationConsultType() {
		super();
	}
	
	public FederationConsultType(RestStringType consultUrn, String date, String service, String procedure,
			String status, int numberNotes) {
		super();
		this.consultUrn = consultUrn;
		this.date = date;
		this.service = service;
		this.procedure = procedure;
		this.status = status;
		this.numberNotes = numberNotes;
	}



	public RestStringType getConsultUrn() {
		return consultUrn;
	}

	public void setConsultUrn(RestStringType consultUrn) {
		this.consultUrn = consultUrn;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getService() {
		return service;
	}

	public void setService(String service) {
		this.service = service;
	}

	public String getProcedure() {
		return procedure;
	}

	public void setProcedure(String procedure) {
		this.procedure = procedure;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public int getNumberNotes() {
		return numberNotes;
	}

	public void setNumberNotes(int numberNotes) {
		this.numberNotes = numberNotes;
	}

	
}
