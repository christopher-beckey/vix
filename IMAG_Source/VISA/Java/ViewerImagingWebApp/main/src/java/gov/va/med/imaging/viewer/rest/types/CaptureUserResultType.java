package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: Apr 12, 2018
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="captureUser")
public class CaptureUserResultType
{
	private String userId;
	private String userName;
	
	public CaptureUserResultType()
	{
		super();
	}

	public CaptureUserResultType(
		String userId,
		String userName)
	{
		super();
		this.userId = userId;
		this.userName = userName;
	}

	/**
	 * @return the userId
	 */
	public String getUserId()
	{
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId)
	{
		this.userId = userId;
	}

	/**
	 * @return the userName
	 */
	public String getUserName()
	{
		return userName;
	}

	/**
	 * @param institutionName the institutionName to set
	 */
	public void setUserName(String userName)
	{
		this.userName = userName;
	}


}
