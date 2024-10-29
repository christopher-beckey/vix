package gov.va.med.imaging.indexterm.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class FederationIndexClassArrayType {
	
	private FederationIndexClassType[] values;

	public FederationIndexClassArrayType() {
		super();
		this.values = new FederationIndexClassType[0];
	}

	public FederationIndexClassArrayType(FederationIndexClassType[] values) {
		super();
		this.values = values;
	}

	public FederationIndexClassType[] getValues() {
		return values;
	}

	public void setValues(FederationIndexClassType[] values) {
		this.values = values;
	}

}
