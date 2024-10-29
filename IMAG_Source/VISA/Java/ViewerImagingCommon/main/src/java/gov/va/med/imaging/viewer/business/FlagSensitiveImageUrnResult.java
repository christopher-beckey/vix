/**
 * Date Created: June 1, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

/**
 * @author vhaisltjahjb
 *
 */
public class FlagSensitiveImageUrnResult
{
	private final String imageUrn;
	private final String result;
	private final String msg;

	/**
	 * @param value
	 * @param result
	 */
	public FlagSensitiveImageUrnResult(
			String imageUrn,
			String result,
			String msg)
	{
		super();
		this.imageUrn = imageUrn;
		this.result = result;
		this.msg = msg;
	}

	/**
	 * @return the imageUrn
	 */
	public String getImageUrn()
	{
		return imageUrn;
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

