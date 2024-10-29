package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: Jul 31, 2017
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="logAccessImageUrn")
public class LogAccessImageUrnType
{
	private String value;
	private String reason;
	
	public LogAccessImageUrnType()
	{
		super();
	}

	/**
	 * @param value
	 * @param reason
	 */
	public LogAccessImageUrnType(
			String value,
			String reason)
	{
		super();
		this.value = value;
		this.reason = reason;
	}
	
	/**
	 * @return the value
	 */
	public String getValue()
	{
		return value;
	}

	/**
	 * @param value the value to set
	 */
	public void setValue(String value)
	{
		this.value = value;
	}

	/**
	 * @return the reason
	 */
	public String getReason()
	{
		return reason;
	}

	/**
	 * @param reason the reason to set
	 */
	public void setReason(String reason)
	{
		this.reason = reason;
	}
}
