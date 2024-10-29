/**
 * Date Created: Apr 28, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

/**
 * @author vhaisltjahjb
 *
 */
public class DeleteImageUrn
{
	private final String value;
	private final Boolean deleteGroup;
	private final String reason;

	/**
	 * @param value
	 * @param deleteGroup
	 * @param reason
	 */
	public DeleteImageUrn(
			String value,
			Boolean deleteGroup,
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
	 * @return the deleteGroup
	 */
	public Boolean isDeleteGroup()
	{
		return deleteGroup;
	}

	/**
	 * @return the reason
	 */
	public String getReason()
	{
		return reason;
	}

}

