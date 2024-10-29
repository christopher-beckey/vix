/**
 * Date Created: Apr 12, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

import java.util.Date;

/**
 * @author vhaisltjahjb
 *
 */
public class CaptureUserResult
{
	private final String userId;
	private final String userName;

	/**
	 * @param userId
	 * @param userName
	 */
	public CaptureUserResult(
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
	 * @return the userName
	 */
	public String getUserName()
	{
		return userName;
	}

}



