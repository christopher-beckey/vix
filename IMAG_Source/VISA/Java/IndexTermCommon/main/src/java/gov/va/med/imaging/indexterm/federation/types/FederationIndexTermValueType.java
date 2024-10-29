package gov.va.med.imaging.indexterm.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.rest.types.RestStringType;

/**
 * @author William Peterson
 *
 */
@XmlRootElement
public class FederationIndexTermValueType {

	private RestStringType indexTermUrn;
	private String name;
	private String abbreviation;

	public FederationIndexTermValueType() {
		super();
	}
	
	public FederationIndexTermValueType(RestStringType indexTermUrn, String name, String abbreviation) {
		super();
		this.indexTermUrn = indexTermUrn;
		this.name = name;
		this.abbreviation = abbreviation;
	}



	public RestStringType getIndexTermUrn() {
		return indexTermUrn;
	}

	public void setIndexTermUrn(RestStringType indexTermUrn) {
		this.indexTermUrn = indexTermUrn;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAbbreviation() {
		return abbreviation;
	}

	public void setAbbreviation(String abbreviation) {
		this.abbreviation = abbreviation;
	}

	
}
