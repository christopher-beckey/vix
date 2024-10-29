/**
 * Date Created: June 1, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="flagSensitiveImageUrns")
public class FlagSensitiveImageUrnsType
{
	private FlagSensitiveImageUrnType[] flagSensitiveImageUrns;
	private String defaultSensitive;

	public FlagSensitiveImageUrnsType()
	{
		super();
	}

	/**
	 * @param ImageUrns
	 */
	public FlagSensitiveImageUrnsType(FlagSensitiveImageUrnType[] flagSensitiveImageUrns)
	{
		super();
		this.flagSensitiveImageUrns = flagSensitiveImageUrns;
	}

	/**
	 * @return the imagingUrns
	 */
	@XmlElement(name="flagSensitiveImageUrn")
	public FlagSensitiveImageUrnType[] getFlagSensitiveImageUrns()
	{
		return flagSensitiveImageUrns;
	}

	/**
	 * @param imageUrns the imageUrns to set
	 */
	public void setFlagSensitiveImageUrns(FlagSensitiveImageUrnType[] flagSensitiveImageUrns)
	{
		this.flagSensitiveImageUrns = flagSensitiveImageUrns;
	}

	/**
	 * @return the defaultSensitive
	 */
	public String getDefaultSensitive()
	{
		return defaultSensitive;
	}

	/**
	 * @param defaultSensitive the defaultSensitive to set
	 */
	public void setDefaultSensitive(String defaultSensitive)
	{
		this.defaultSensitive = defaultSensitive;
	}

	
}
