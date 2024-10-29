/**
 * Date Created: Jun 1, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

/**
 * @author vhaisltjahjb
 *
 */
public class LogAccessImageUrn
{
	private final String imageUrn;
	private final String accessReason;

	/**
	 * @param imageUrn
	 * @param accessReason
	 */
	public LogAccessImageUrn(
			String imageUrn,
			String accessReason)
	{
		super();
		this.imageUrn = imageUrn;
		this.accessReason = accessReason;
	}

	/**
	 * @return the imageUrn
	 */
	public String getImageUrn()
	{
		return imageUrn;
	}

	/**
	 * @return the accessReason
	 */
	public String getAccessReason()
	{
		return accessReason;
	}

}

