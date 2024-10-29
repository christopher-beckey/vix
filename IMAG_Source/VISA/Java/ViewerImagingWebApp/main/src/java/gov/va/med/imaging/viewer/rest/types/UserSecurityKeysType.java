package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="securityKeys")
public class UserSecurityKeysType
{
	private String[] securityKeys;
	
	public UserSecurityKeysType()
	{
		super();
	}

	/**
	 * @param UserSecurityKeyType
	 */
	public UserSecurityKeysType(String[] securityKeys)
	{
		super();
		this.securityKeys = securityKeys;
	}

	/**
	 * @return the SecurityKeys
	 */
	@XmlElement(name="securityKey")
	public String[] getSecurityKeys()
	{
		return securityKeys;
	}

	/**
	 * @param securityKeys the securityKeys to set
	 */
	public void setSecurityKeys(String[] securityKeys)
	{
		this.securityKeys = securityKeys;
	}

}
