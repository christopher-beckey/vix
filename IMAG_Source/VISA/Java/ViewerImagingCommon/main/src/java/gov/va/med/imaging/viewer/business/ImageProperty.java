/**
 * Date Created: May 2, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

/**
 * @author vhaisltjahjb
 *
 */
public class ImageProperty
{
	private final String name;
	private final String value;

	private final String ien;
	private final String flags;

	/**
	 * @param ien
	 * @param flags
	 * @param name
	 * @param value
	 * @param reason
	 */
	public ImageProperty(
			String ien,
			String flags,
			String name,
			String value)
	{
		super();
		this.ien = ien;
		this.flags = flags;
		this.name = name;
		this.value = value;
	}

	public ImageProperty(
			String name,
			String value)
	{
		super();
		this.ien = "";
		this.flags = "";
		this.name = name;
		this.value = value;
	}

	/**
	 * @return the ien
	 */
	public String getIen()
	{
		return ien;
	}

	/**
	 * @return the flags
	 */
	public String getFlags()
	{
		return flags;
	}

	/**
	 * @return the value
	 */
	public String getValue()
	{
		return value;
	}

	/**
	 * @return the name
	 */
	public String getName()
	{
		return name;
	}

}

