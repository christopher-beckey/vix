package gov.va.med.imaging.tiu.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class FederationTIUAuthorArrayType {
	
	private FederationTIUAuthorType[] values;

	public FederationTIUAuthorArrayType(FederationTIUAuthorType[] types) {
		super();
		this.values = types;
	}

	public FederationTIUAuthorArrayType() {
		super();
		this.values = new FederationTIUAuthorType[0];

	}

	public FederationTIUAuthorType[] getValues() {
		return values;
	}

	public void setValues(FederationTIUAuthorType[] values) {
		this.values = values;
	}
	
	

}
