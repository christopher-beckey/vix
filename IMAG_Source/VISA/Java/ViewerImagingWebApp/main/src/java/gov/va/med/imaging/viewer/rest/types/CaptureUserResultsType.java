/**
 * Date Created: Apr 12, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="captureUserResults")
public class CaptureUserResultsType
{
	
	private CaptureUserResultType[] captureUsers;
	
	public CaptureUserResultsType()
	{
		super();
	}

	/**
	 * @param captureUsers
	 */
	public CaptureUserResultsType(CaptureUserResultType[] captureUsers)
	{
		super();
		this.captureUsers = captureUsers;
	}

	/**
	 * @return the captureUsers
	 */
	@XmlElement(name="captureUser")
	public CaptureUserResultType[] getCaptureUsers()
	{
		return captureUsers;
	}

	/**
	 * @param captureUsers the captureUsers to set
	 */
	public void setCaptureUsers(CaptureUserResultType[] captureUsers)
	{
		this.captureUsers = captureUsers;
	}

}

