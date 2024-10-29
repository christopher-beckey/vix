/**
 * Date Created: Apr 23, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

/**
 * @author vhaisltjahjb
 *
 */
public class ImageFilterFieldValue
{
	private final String fieldName;
	private final String fieldValue;

	/**
	 * @param fieldName
	 * @param fieldValue
	 */
	public ImageFilterFieldValue(
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
	 * @return the fieldName
	 */
	public String getFieldName()
	{
		return fieldName;
	}

}

