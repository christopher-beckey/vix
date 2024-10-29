package gov.va.med.imaging.indexterm.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author William Peterson
 *
 */
@XmlRootElement
public enum FederationIndexClassType {

	admin("ADMIN"),
	clin("CLIN"), 
	clinAdmin("CLIN/ADMIN"), 
	adminClin("ADMIN/CLIN");
	
	private String value;
	
	FederationIndexClassType(String value)
	{
		this.value = value;
	}
	
	

	private FederationIndexClassType() {
	}



	/**
	 * @return the value
	 */
	public String getValue()
	{
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
	


	
}
