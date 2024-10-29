/**
 * Date Created: Apr 23, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;


/**
 * @author vhaisltjahjb
 *
 */
public class ImageFilterResult
{
	private final String userId;
	private final String filterIEN;
	private final String filterName;

	/**
	 * @param userId
	 * @param userName
	 */
	public ImageFilterResult(
			String filterIEN,
			String filterName,
			String userId)
	{
		super();
		this.userId = userId;
		this.filterIEN = filterIEN;
		this.filterName = filterName;
	}

	/**
	 * @return the userId
	 */
	public String getUserId()
	{
		return userId;
	}

	/**
	 * @return the filterName
	 */
	public String getFilterName()
	{
		return filterName;
	}

	/**
	 * @return the filterIEN
	 */
	public String getFilterIEN()
	{
		return filterIEN;
	}
}



