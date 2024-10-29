package gov.va.med.imaging.viewer.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: Apr 28, 2017
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="imageUrn")
public class DeleteImageUrnResultType
{
	private String value;
	private String deleteResult;
	private String deleteResultMsg;
	
	public DeleteImageUrnResultType()
	{
		super();
	}

	public DeleteImageUrnResultType(String value, String result, String msg)
	{
		super();
		this.value = value;
		this.deleteResult = result;
		this.deleteResultMsg = msg;
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
	 * @return the deleteResult
	 */
	public String getDeleteResult()
	{
		return deleteResult;
	}

	/**
	 * @param result the deleteResult to set
	 */
	public void setDeleteResult(String result)
	{
		this.deleteResult = result;
	}
	
	/**
	 * @return the deleteResultMsg
	 */
	public String getDeleteResultMsg()
	{
		return deleteResultMsg;
	}

	/**
	 * @param msg the deleteResultMsg to set
	 */
	public void setDeleteResultMsg(String msg)
	{
		this.deleteResultMsg = msg;
	}

}
