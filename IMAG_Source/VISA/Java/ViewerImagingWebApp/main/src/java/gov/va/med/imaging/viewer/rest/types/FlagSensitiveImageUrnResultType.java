package gov.va.med.imaging.viewer.rest.types;

import java.util.Date;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: Jun 1, 2017
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="imageUrn")
public class FlagSensitiveImageUrnResultType
{
	private String value;
	private String flagSensitiveResult;
	private String flagSensitiveResultMsg;
	
	public FlagSensitiveImageUrnResultType()
	{
		super();
	}

	public FlagSensitiveImageUrnResultType(String value, String result, String msg)
	{
		super();
		this.value = value;
		this.flagSensitiveResult = result;
		this.flagSensitiveResultMsg = msg;
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
	 * @return the flagSensitiveResult
	 */
	public String getFlagSensitiveResult()
	{
		return flagSensitiveResult;
	}

	/**
	 * @param flagSensitiveResult the flagSensitiveResult to set
	 */
	public void setFlagSensitiveResult(String flagSensitiveResult)
	{
		this.flagSensitiveResult = flagSensitiveResult;
	}
	
	/**
	 * @return the flagSensitiveResultMsg
	 */
	public String getFlagSensitiveResultMsg()
	{
		return flagSensitiveResultMsg;
	}

	/**
	 * @param flagSensitiveResultMsg the flagSensitiveResultMsg to set
	 */
	public void setFlagSensitiveResultMsg(String flagSensitiveResultMsg)
	{
		this.flagSensitiveResultMsg = flagSensitiveResultMsg;
	}

}
