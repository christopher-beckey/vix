package gov.va.med.imaging.federation.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author William Peterson
 *
 */
@XmlRootElement
public class FederationNamespaceIdentifierType {

	private String namespace;

	public FederationNamespaceIdentifierType() {
		
	}

	public String getNamespace() {
		return namespace;
	}

	public void setNamespace(String namespace) {
		this.namespace = namespace;
	}

	
}
