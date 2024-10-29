package gov.va.med.imaging.federation.rest.types;

public class FederationPatientIdentifierTypeType {

	private boolean local;
	
	private boolean requiresSiteIdentifier;

	public FederationPatientIdentifierTypeType() {
		
	}

	public boolean isLocal() {
		return local;
	}

	public void setLocal(boolean local) {
		this.local = local;
	}

	public boolean isRequiresSiteIdentifier() {
		return requiresSiteIdentifier;
	}

	public void setRequiresSiteIdentifier(boolean requiresSiteIdentifier) {
		this.requiresSiteIdentifier = requiresSiteIdentifier;
	}

	
}
