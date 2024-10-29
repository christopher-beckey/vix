package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: Apr 23, 2018
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="imageFilter")
public class ImageFilterResultType
{
	private String filterIEN;
	private String filterName;
	private String userId;
	
	public ImageFilterResultType()
	{
		super();
	}

	public ImageFilterResultType(
		String filterIEN,
		String filterName,
		String userId)
	{
		super();
		this.filterIEN = filterIEN;
		this.filterName = filterName;
		this.userId = userId;
	}

	/**
	 * @return the filterIEN
	 */
	public String getFilterIEN()
	{
		return filterIEN;
	}

	/**
	 * @param filterIEN the filterIEN to set
	 */
	public void setFilterIEN(String filterIEN)
	{
		this.filterIEN = filterIEN;
	}

	/**
	 * @return the filterName
	 */
	public String getFilterName()
	{
		return filterName;
	}

	/**
	 * @param filterName the filterName to set
	 */
	public void setFilterName(String filterName)
	{
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
	 * @param userId the userId to set
	 */
	public void setUserId(String userId)
	{
		this.userId = userId;
	}



}
