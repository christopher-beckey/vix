package gov.va.med.imaging.tiu.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class FederationPatientTIUNoteArrayType {

	private FederationPatientTIUNoteType[] values;

	public FederationPatientTIUNoteArrayType() {
		super();
		this.values = new FederationPatientTIUNoteType[0];
	}

	public FederationPatientTIUNoteArrayType(FederationPatientTIUNoteType[] types) {
		super();
		this.values = types;
	}

	public FederationPatientTIUNoteType[] getValues() {
		return values;
	}

	public void setValues(FederationPatientTIUNoteType[] types) {
		this.values = types;
	}
	

}
