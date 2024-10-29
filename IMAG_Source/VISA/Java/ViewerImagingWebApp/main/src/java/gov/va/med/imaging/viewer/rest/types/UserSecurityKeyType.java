package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="securityKey")
public class UserSecurityKeyType {

	private String securityKey;
	
	public UserSecurityKeyType()
	{
		super();
	}

	/**
	 * @param securityKey
	 */
	public UserSecurityKeyType(
			String securityKey)
	{
		super();
		this.securityKey = securityKey;
	}
	
	/**
	 * @return the securityKey
	 */
	public String getSecurityKey()
	{
		return securityKey;
	}

	/**
	 * @param securityKey the securityKey to set
	 */
	public void setSecurityKey(String securityKey)
	{
		this.securityKey = securityKey;
	}
	
}
