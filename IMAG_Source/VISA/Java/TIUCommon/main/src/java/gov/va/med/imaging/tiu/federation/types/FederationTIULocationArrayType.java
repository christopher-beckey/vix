package gov.va.med.imaging.tiu.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class FederationTIULocationArrayType {
	
	private FederationTIULocationType[] values;

	public FederationTIULocationArrayType(FederationTIULocationType[] types) {
		super();
		this.values = types;
	}

	public FederationTIULocationArrayType() {
		super();
		this.values = new FederationTIULocationType[0];
	}

	public FederationTIULocationType[] getValues() {
		return values;
	}

	public void setValues(FederationTIULocationType[] values) {
		this.values = values;
	}
	
	
	

}
