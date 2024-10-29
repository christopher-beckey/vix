package gov.va.med.imaging.tiu.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class FederationTIUNoteArrayType {

	private FederationTIUNoteType[] values;
		
	public FederationTIUNoteArrayType(FederationTIUNoteType[] types){
		super();
		this.values = types;
	}
	
	public FederationTIUNoteArrayType(){
		super();
		this.values = new FederationTIUNoteType[0];
	}

	public FederationTIUNoteType[] getValues() {
		return values;
	}

	public void setValues(FederationTIUNoteType[] values) {
		this.values = values;
	}		
	
	
}
