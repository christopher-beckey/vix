/**
 * 
 */
package gov.va.med.imaging.federation.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author William Peterson
 *
 */
@XmlRootElement(name="cprsIdentifiers")
public class FederationCprsIdentifiersType {

	private String[] cprsIdentifiers;
	
	/**
	 * 
	 */
	public FederationCprsIdentifiersType() {
		super();
	}
	
	/**
	 * @param cprsIdentifierTypes
	 */
	public FederationCprsIdentifiersType(String[] cprsIdentifiers)
	{
		super();
		this.cprsIdentifiers = cprsIdentifiers;
	}

	
	/**
	 * @return the cprsIdentifiers
	 */
	@XmlElement(name="cprsIdentifier")
	public String[] getCprsIdentifiers() {
		return cprsIdentifiers;
	}
	/**
	 * @param cprsIdentifiers the cprsIdentifiers to set
	 */
	public void setCprsIdentifiers(String[] cprsIdentifiers) {
		this.cprsIdentifiers = cprsIdentifiers;
	}

}
