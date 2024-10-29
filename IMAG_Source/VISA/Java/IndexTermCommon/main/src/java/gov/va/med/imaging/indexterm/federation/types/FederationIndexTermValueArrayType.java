package gov.va.med.imaging.indexterm.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class FederationIndexTermValueArrayType {

	private FederationIndexTermValueType[] values;

	public FederationIndexTermValueArrayType(){
		super();
		this.values = new FederationIndexTermValueType[0];
	}
	
	public FederationIndexTermValueArrayType(FederationIndexTermValueType[] types){
		super();
		this.values = types;
	}
	public FederationIndexTermValueType[] getValues() {
		return values;
	}

	public void setValues(FederationIndexTermValueType[] values) {
		this.values = values;
	}
	

}
