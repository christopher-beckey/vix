/**
 * 
 * Date Created: Apr 24, 2017
 * Developer: vhaisltjahjb
 */

package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="userInfo")
public class UserInfoType
{
	private String userName;
	private String userInitials;
	private UserSecurityKeysType securityKeys;
	
	public UserInfoType()
	{
		super();
	}

	/**
	 * @param userName
	 * @param userInitials
	 * @param UserSecurityKeyType
	 */
	public UserInfoType(String userName, String userInitials, UserSecurityKeysType securityKeys)
	{
		super();
		this.userName = userName;
		this.userInitials = userInitials;
		this.securityKeys = securityKeys;
	}

	/**
	 * @return the userName
	 */
	public String getUserName()
	{
		return userName;
	}

	/**
	 * @param userName the userName to set
	 */
	public void setUserName(String userName)
	{
		this.userName = userName;
	}
	
	/**
	 * @return the userInitials
	 */
	public String getUserInitials()
	{
		return userInitials;
	}

	/**
	 * @param userInitials the userInitials to set
	 */
	public void setUserInitials(String userInitials)
	{
		this.userInitials = userInitials;
	}
	
	/**
	 * @return the SecurityKeys
	 */
	@XmlElement(name="securityKeys")
	public UserSecurityKeysType getSecurityKeys()
	{
		return securityKeys;
	}

	/**
	 * @param securityKeys the securityKeys to set
	 */
	public void setSecurityKeys(UserSecurityKeysType securityKeys)
	{
		this.securityKeys = securityKeys;
	}

}
