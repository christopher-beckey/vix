package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: June 1, 2017
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="flagSensitiveImageUrn")
public class FlagSensitiveImageUrnType
{
	private String imageUrn;
	private String sensitive;
	
	public FlagSensitiveImageUrnType()
	{
		super();
	}

	/**
	 * @param imageUrn
	 * @param sensitive
	 */
	public FlagSensitiveImageUrnType(
			String imageUrn,
			String sensitive)
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
	 * @param imageUrn the imageUrn to set
	 */
	public void setImageUrn(String imageUrn)
	{
		this.imageUrn = imageUrn;
	}

	/**
	 * @return the sensitive
	 */
	public String getSensitive()
	{
		return sensitive;
	}

	/**
	 * @param sensitive the sensitive to set
	 */
	public void setSensitive(String sensitive)
	{
		this.sensitive = sensitive;
	}

}
