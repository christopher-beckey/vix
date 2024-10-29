package gov.va.med.imaging.tiu.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class FederationTIUNoteAddendumInputType {

	private String date;
	private String addendumText;
	
	public FederationTIUNoteAddendumInputType() {
		super();
	}
	
	public FederationTIUNoteAddendumInputType(String date, String addendumText) {
		super();
		this.date = date;
		this.addendumText = addendumText;
	}
	
	public String getDate() {
		return date;
	}
	public String getAddendumText() {
		return addendumText;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public void setAddendumText(String addendumText) {
		this.addendumText = addendumText;
	}
	
	
	
}
