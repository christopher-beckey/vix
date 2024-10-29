/**
 * 
 * Date Created: May 26, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Administrator
 *
 */
@XmlRootElement(name="deleteReasons")
public class DeleteReasonsType
{
	
	private String[] deleteReasons;
	
	public DeleteReasonsType()
	{
		super();
	}

	/**
	 * @param deleteReasons
	 */
	public DeleteReasonsType(String[] deleteReasons)
	{
		super();
		this.deleteReasons = deleteReasons;
	}

	/**
	 * @return the deleteReasons
	 */
	@XmlElement(name="deleteReason")
	public String[] getDeleteReasons()
	{
		return deleteReasons;
	}

	/**
	 * @param deleteReasons the deleteReasons to set
	 */
	public void setDeleteReasons(String[] deleteReasons)
	{
		this.deleteReasons = deleteReasons;
	}

}
