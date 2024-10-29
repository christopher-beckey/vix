package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: Apr 23, 2018
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="imageFilterFieldValue")
public class ImageFilterFieldValueType
{
	private String fieldName;
	private String fieldValue;
	
	public ImageFilterFieldValueType()
	{
		super();
	}

	/**
	 * @param fieldName
	 * @param fieldValue
	 */
	public ImageFilterFieldValueType(
			String fieldName,
			String fieldValue)
	{
		super();
		this.fieldName = fieldName;
		this.fieldValue = fieldValue;
	}
	
	/**
	 * @return the fieldValue
	 */
	public String getFieldValue()
	{
		return fieldValue;
	}

	/**
	 * @param fieldValue the fieldValue to set
	 */
	public void setFieldValue(String fieldValue)
	{
		this.fieldValue = fieldValue;
	}

	/**
	 * @return the fieldName
	 */
	public String getFieldName()
	{
		return fieldName;
	}

	/**
	 * @param fieldName the fieldName to set
	 */
	public void setFieldName(String fieldName)
	{
		this.fieldName = fieldName;
	}
}
