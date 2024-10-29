/**
 * 
 * Date Created: June 5, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Administrator
 *
 */
@XmlRootElement(name="statusReasons")
public class StatusReasonsType
{
	
	private String[] statusReasons;
	
	public StatusReasonsType()
	{
		super();
	}

	/**
	 * @param printReasons
	 */
	public StatusReasonsType(String[] statusReasons)
	{
		super();
		this.statusReasons = statusReasons;
	}

	/**
	 * @return the printReasons
	 */
	@XmlElement(name="statusReason")
	public String[] getPrintReasons()
	{
		return statusReasons;
	}

	/**
	 * @param printReasons the statusReasons to set
	 */
	public void setPrintReasons(String[] statusReasons)
	{
		this.statusReasons = statusReasons;
	}

}
