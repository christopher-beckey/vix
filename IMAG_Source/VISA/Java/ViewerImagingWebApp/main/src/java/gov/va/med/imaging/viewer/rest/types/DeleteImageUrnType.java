package gov.va.med.imaging.viewer.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: Apr 28, 2017
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="deleteImageUrn")
public class DeleteImageUrnType
{
	private String value;
	private String deleteGroup;
	private String reason;
	
	public DeleteImageUrnType()
	{
		super();
	}

	/**
	 * @param value
	 * @param deleteGroup
	 * @param reason
	 */
	public DeleteImageUrnType(
			String value,
			String deleteGroup,
			String reason)
	{
		super();
		this.value = value;
		this.deleteGroup = deleteGroup;
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
	 * @return the deleteGroup
	 */
	public String getDeleteGroup()
	{
		return deleteGroup;
	}

	/**
	 * @param deleteGroup the deleteGroup to set
	 */
	public void setDeleteGroup(String deleteGroup)
	{
		this.deleteGroup = deleteGroup;
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
