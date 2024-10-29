/**
 * Date Created: Apr 28, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import gov.va.med.imaging.viewer.business.DeleteImageUrnResult;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="deleteImagesResult")
public class DeleteImageUrnResultsType
{
	
	private DeleteImageUrnResultType[] imageUrns;
	
	public DeleteImageUrnResultsType()
	{
		super();
	}

	/**
	 * @param imageUrns
	 */
	public DeleteImageUrnResultsType(DeleteImageUrnResultType[] imageUrns)
	{
		super();
		this.imageUrns = imageUrns;
	}

	/**
	 * @return the imagingUrns
	 */
	@XmlElement(name="imageUrn")
	public DeleteImageUrnResultType[] getImageUrns()
	{
		return imageUrns;
	}

	/**
	 * @param imageUrns the imageUrns to set
	 */
	public void setImageUrns(DeleteImageUrnResultType[] imageUrns)
	{
		this.imageUrns = imageUrns;
	}

}
