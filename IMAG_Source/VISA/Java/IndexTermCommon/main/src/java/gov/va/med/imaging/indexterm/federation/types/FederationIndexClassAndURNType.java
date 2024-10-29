package gov.va.med.imaging.indexterm.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.rest.types.RestStringArrayType;

@XmlRootElement
public class FederationIndexClassAndURNType {
	
	private FederationIndexClassArrayType federationIndexClasses;
	
	private RestStringArrayType federationIndexTermURNs;

	
	public FederationIndexClassAndURNType() {
		super();
	}

	public FederationIndexClassAndURNType(FederationIndexClassArrayType federationIndexClasses,
			RestStringArrayType federationIndexTermURNs) {
		super();
		this.federationIndexClasses = federationIndexClasses;
		this.federationIndexTermURNs = federationIndexTermURNs;
	}

	public FederationIndexClassArrayType getFederationIndexClasses() {
		return federationIndexClasses;
	}

	public void setFederationIndexClasses(FederationIndexClassArrayType federationIndexClasses) {
		this.federationIndexClasses = federationIndexClasses;
	}

	public RestStringArrayType getFederationIndexTermURNs() {
		return federationIndexTermURNs;
	}

	public void setFederationIndexTermURNs(RestStringArrayType federationIndexTermURNs) {
		this.federationIndexTermURNs = federationIndexTermURNs;
	}
	

}
