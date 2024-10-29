package gov.va.med.imaging.viewer.rest.types;

import java.util.Date;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: Jun 1, 2017
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="imageUrn")
public class LogAccessImageUrnResultType
{
	private String value;
	private String logAccessImageResult;
	private String logAccessImageResultMsg;
	
	public LogAccessImageUrnResultType()
	{
		super();
	}

	public LogAccessImageUrnResultType(String value, String result, String msg)
	{
		super();
		this.value = value;
		this.logAccessImageResult = result;
		this.logAccessImageResultMsg = msg;
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
	 * @return the logAccessImageResult
	 */
	public String getLogAccessImageResult()
	{
		return logAccessImageResult;
	}

	/**
	 * @param logAccessImageResult the logAccessImageResult to set
	 */
	public void setLogAccessImageResult(String logAccessImageResult)
	{
		this.logAccessImageResult = logAccessImageResult;
	}
	
	/**
	 * @return the logAccessImageResultMsg
	 */
	public String getLogAccessImageResultMsg()
	{
		return logAccessImageResultMsg;
	}

	/**
	 * @param logAccessImageResultMsg the logAccessImageResultMsg to set
	 */
	public void setLogAccessImageResultMsg(String logAccessImageResultMsg)
	{
		this.logAccessImageResultMsg = logAccessImageResultMsg;
	}

}
