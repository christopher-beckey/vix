/**
 * Date Created: Apr 28, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="deleteImageUrns")
public class DeleteImageUrnsType
{
	
	private DeleteImageUrnType[] deleteImageUrns;
	private String defaultDeleteReason;
	
	public DeleteImageUrnsType()
	{
		super();
	}

	/**
	 * @param deleteImageUrns
	 */
	public DeleteImageUrnsType(DeleteImageUrnType[] deleteImageUrns)
	{
		super();
		this.deleteImageUrns = deleteImageUrns;
	}

	/**
	 * @return the imagingUrns
	 */
	@XmlElement(name="deleteImageUrn")
	public DeleteImageUrnType[] getDeleteImageUrns()
	{
		return deleteImageUrns;
	}

	/**
	 * @param imageUrns the imageUrns to set
	 */
	public void setDeleteImageUrns(DeleteImageUrnType[] deleteImageUrns)
	{
		this.deleteImageUrns = deleteImageUrns;
	}

	/**
	 * @return the defaultDeleteReason
	 */
	@XmlElement(name="defaultDeleteReason")
	public String getDefaultDeleteReason()
	{
		return defaultDeleteReason;
	}

	/**
	 * @param defaultDeleteReason the defaultDeleteReason to set
	 */
	public void setDefaultDeleteReason(String defaultDeleteReason)
	{
		this.defaultDeleteReason = defaultDeleteReason;
	}
	
	
}
