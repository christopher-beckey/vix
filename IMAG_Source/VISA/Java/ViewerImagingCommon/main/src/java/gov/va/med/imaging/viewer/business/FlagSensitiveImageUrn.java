/**
 * Date Created: Jun 1, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

/**
 * @author vhaisltjahjb
 *
 */
public class FlagSensitiveImageUrn
{
	private final String imageUrn;
	private final Boolean sensitive;

	/**
	 * @param imageUrn
	 * @param sensitive
	 */
	public FlagSensitiveImageUrn(
			String imageUrn,
			Boolean sensitive)
	{
		super();
		this.imageUrn = imageUrn;
		this.sensitive = sensitive;
	}

	/**
	 * @return the imageUrn
	 */
	public String getImageUrn()
	{
		return imageUrn;
	}

	/**
	 * @return the sensitive
	 */
	public Boolean isSensitive()
	{
		return sensitive;
	}

}

