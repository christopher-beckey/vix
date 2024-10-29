package gov.va.med.imaging.tiu.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.rest.types.RestStringType;

/**
 * @author William Peterson
 *
 */
@XmlRootElement
public class FederationTIULocationType {

	private RestStringType locationUrn;	
	private String name;


	public FederationTIULocationType(RestStringType locationUrn, String name) {
		super();
		this.locationUrn = locationUrn;
		this.name = name;
	}
	
	

	public FederationTIULocationType() {
		super();
	}



	public String getName() {
		return name;
	}

	public RestStringType getLocationUrn() {
		return locationUrn;
	}



	public void setLocationUrn(RestStringType locationUrn) {
		this.locationUrn = locationUrn;
	}



	public void setName(String name) {
		this.name = name;
	}
	
}
