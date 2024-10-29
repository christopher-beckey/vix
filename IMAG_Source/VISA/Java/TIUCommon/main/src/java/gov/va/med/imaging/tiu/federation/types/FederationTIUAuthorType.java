package gov.va.med.imaging.tiu.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.rest.types.RestStringType;

/**
 * @author William Peterson
 *
 */
@XmlRootElement
public class FederationTIUAuthorType {

	private RestStringType authorUrn;
	private String name;
	private String service;
	
	
	public FederationTIUAuthorType(RestStringType authorUrn, String name, String service) {
		super();
		this.authorUrn = authorUrn;
		this.name = name;
		this.service = service;
	}
	
	
	public FederationTIUAuthorType() {
		super();
	}


	public RestStringType getAuthorUrn() {
		return authorUrn;
	}
	public String getName() {
		return name;
	}
	public String getService() {
		return service;
	}


	public void setAuthorUrn(RestStringType authorUrn) {
		this.authorUrn = authorUrn;
	}


	public void setName(String name) {
		this.name = name;
	}


	public void setService(String service) {
		this.service = service;
	}


	
}
