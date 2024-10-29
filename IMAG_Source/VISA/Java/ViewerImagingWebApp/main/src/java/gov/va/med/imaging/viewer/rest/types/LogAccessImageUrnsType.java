/**
 * Date Created: July 31, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="logAccessImageUrns")
public class LogAccessImageUrnsType
{
	
	private LogAccessImageUrnType[] logAccessImageUrns;
	private String defaultLogAccessReason;
	
	public LogAccessImageUrnsType()
	{
		super();
	}

	/**
	 * @param logAccessImageUrns
	 */
	public LogAccessImageUrnsType(LogAccessImageUrnType[] logAccessImageUrns)
	{
		super();
		this.logAccessImageUrns = logAccessImageUrns;
	}

	/**
	 * @return the logAccessImageUrns
	 */
	@XmlElement(name="logAccessImageUrn")
	public LogAccessImageUrnType[] getLogAccessImageUrns()
	{
		return logAccessImageUrns;
	}

	/**
	 * @param logAccessImageUrns the logAccessImageUrns to set
	 */
	public void setLogAccessImageUrns(LogAccessImageUrnType[] logAccessImageUrns)
	{
		this.logAccessImageUrns = logAccessImageUrns;
	}

	/**
	 * @return the defaultLogAccessReason
	 */
	@XmlElement(name="defaultLogAccessReason")
	public String getDefaultLogAccessReason()
	{
		return defaultLogAccessReason;
	}

	/**
	 * @param defaultLogAccessReason the defaultLogAccessReason to set
	 */
	public void setDefaultLogAccessReason(String defaultLogAccessReason)
	{
		this.defaultLogAccessReason = defaultLogAccessReason;
	}
	
	
}
