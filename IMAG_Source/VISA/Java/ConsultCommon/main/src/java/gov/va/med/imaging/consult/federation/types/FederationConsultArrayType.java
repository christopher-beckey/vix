package gov.va.med.imaging.consult.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class FederationConsultArrayType {

	private FederationConsultType[] values;
	
	public FederationConsultArrayType() {
		super();
		this.values = new FederationConsultType[0];
	}

	public FederationConsultArrayType(FederationConsultType[] values) {
		super();
		this.values = values;
	}

	public FederationConsultType[] getValues() {
		return values;
	}

	public void setValues(FederationConsultType[] values) {
		this.values = values;
	}


	
}
