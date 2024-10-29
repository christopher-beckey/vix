package gov.va.med.imaging.study.web.rest.types;


import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Budy Tjahjo
 *
 */
@XmlRootElement(name="cprsIdentifiers")
public class CprsIdentifiersType
{
	
	private String[] cprsIdentifiers;
	
	public CprsIdentifiersType()
	{
		super();
	}

	/**
	 * @param cprsIdentifierTypes
	 */
	public CprsIdentifiersType(String[] cprsIdentifiers)
	{
		super();
		this.cprsIdentifiers = cprsIdentifiers;
	}

	/**
	 * @return the cprsIdentifiers
	 */
	@XmlElement(name="cprsIdentifier")
	public String[] getCprsIdentifiers()
	{
		return cprsIdentifiers;
	}

	/**
	 * @param cprsIdentifiers the cprsIdentifiers to set
	 */
	public void setCprsIdentifiers(String[] cprsIdentifiers)
	{
		this.cprsIdentifiers = cprsIdentifiers;
	}

}
