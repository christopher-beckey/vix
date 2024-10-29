/**
 * Date Created: Apr 28, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

/**
 * @author vhaisltjahjb
 *
 */
public class DeleteImageUrnResult
{
	private final String value;
	private final String result;
	private final String msg;

	/**
	 * @param value
	 * @param result
	 */
	public DeleteImageUrnResult(
			String value,
			String result,
			String msg)
	{
		super();
		this.value = value;
		this.result = result;
		this.msg = msg;
	}

	/**
	 * @return the value
	 */
	public String getValue()
	{
		return value;
	}

	/**
	 * @return the result
	 */
	public String getResult()
	{
		return result;
	}

	/**
	 * @return the result msg
	 */
	public String getMsg()
	{
		return msg;
	}
}

