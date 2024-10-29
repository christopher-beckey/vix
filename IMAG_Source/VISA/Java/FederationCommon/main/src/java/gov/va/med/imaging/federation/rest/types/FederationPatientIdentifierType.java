package gov.va.med.imaging.federation.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author William Peterson
 *
 */
@XmlRootElement
public class FederationPatientIdentifierType {

	private String value;
	private FederationPatientIdentifierTypeType patientIdentifierType;
	private String patientIdentifierSource;

	public FederationPatientIdentifierType() {
		
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public FederationPatientIdentifierTypeType getFederationPatientIdentifierTypeType() {
		return patientIdentifierType;
	}

	public void setPatientIdentifierType(FederationPatientIdentifierTypeType patientIdentifierType) {
		this.patientIdentifierType = patientIdentifierType;
	}

	public String getPatientIdentifierSource() {
		return patientIdentifierSource;
	}

	public void setPatientIdentifierSource(String patientIdentifierSource) {
		this.patientIdentifierSource = patientIdentifierSource;
	}

	
}
