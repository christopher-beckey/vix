package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: May 2, 2018
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="imageProperty")
public class ImagePropertyType
{
	private String ien;
	private String flags;
	private String name;
	private String value;
	
	public ImagePropertyType()
	{
		super();
	}

	/**
	 * @param name
	 * @param value
	 */
	public ImagePropertyType(
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
	
	/**
	 * @return the ien
	 */
	public String getIen()
	{
		return ien;
	}

	/**
	 * @param ien the ien to set
	 */
	public void setIen(String ien)
	{
		this.ien = ien;
	}

	/**
	 * @return the flags
	 */
	public String getFlags()
	{
		return flags;
	}

	/**
	 * @param ien flags flags to set
	 */
	public void setFlags(String flags)
	{
		this.flags = flags;
	}

	/**
	 * @return the value
	 */
	public String getValue()
	{
		return value;
	}

	/**
	 * @param value the value to set
	 */
	public void setValue(String value)
	{
		this.value = value;
	}

	/**
	 * @return the name
	 */
	public String getName()
	{
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name)
	{
		this.name = name;
	}
}
