package gov.va.med.imaging.indexterm.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.federation.rest.types.FederationNamespaceIdentifierType;

/**
 * @author William Peterson
 *
 */
@XmlRootElement
public class FederationIndexTermURNType {

	private String originatingSiteId;
	private FederationIndexTermType indexTerm;
	private String fieldId;
	private FederationNamespaceIdentifierType namespace;
	

	public FederationIndexTermURNType() {
		super();
	}


	public FederationIndexTermURNType(String originatingSiteId, FederationIndexTermType indexTerm, String fieldId,
			FederationNamespaceIdentifierType namespace) {
		super();
		this.originatingSiteId = originatingSiteId;
		this.indexTerm = indexTerm;
		this.fieldId = fieldId;
		this.namespace = namespace;
	}





	public String getOriginatingSiteId() {
		return originatingSiteId;
	}


	public void setOriginatingSiteId(String originatingSiteId) {
		this.originatingSiteId = originatingSiteId;
	}


	public FederationIndexTermType getIndexTerm() {
		return indexTerm;
	}


	public void setIndexTerm(FederationIndexTermType indexTerm) {
		this.indexTerm = indexTerm;
	}


	public String getFieldId() {
		return fieldId;
	}


	public void setFieldId(String fieldId) {
		this.fieldId = fieldId;
	}


	public FederationNamespaceIdentifierType getNamespace() {
		return namespace;
	}


	public void setNamespace(FederationNamespaceIdentifierType namespace) {
		this.namespace = namespace;
	}

	
}
