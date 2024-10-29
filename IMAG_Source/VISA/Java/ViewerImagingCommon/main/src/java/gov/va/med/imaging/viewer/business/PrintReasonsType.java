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
@XmlRootElement(name="printReasons")
public class PrintReasonsType
{
	
	private String[] printReasons;
	
	public PrintReasonsType()
	{
		super();
	}

	/**
	 * @param printReasons
	 */
	public PrintReasonsType(String[] printReasons)
	{
		super();
		this.printReasons = printReasons;
	}

	/**
	 * @return the printReasons
	 */
	@XmlElement(name="printReason")
	public String[] getPrintReasons()
	{
		return printReasons;
	}

	/**
	 * @param printReasons the printReasons to set
	 */
	public void setPrintReasons(String[] printReasons)
	{
		this.printReasons = printReasons;
	}

}
