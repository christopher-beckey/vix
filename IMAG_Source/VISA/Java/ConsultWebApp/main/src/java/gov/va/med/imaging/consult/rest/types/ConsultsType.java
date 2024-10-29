/**
 * 
 * 
 * Date Created: Feb 12, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="consults")
public class ConsultsType
{
	private ConsultType [] consult;
	
	public ConsultsType()
	{
		super();
		this.consult = new ConsultType[0];
	}

	/**
	 * @param consult
	 */
	public ConsultsType(ConsultType[] consult)
	{
		super();
		this.consult = consult;
	}

	/**
	 * @return the consult
	 */
	public ConsultType[] getConsult()
	{
		return consult;
	}

	/**
	 * @param consult the consult to set
	 */
	public void setConsult(ConsultType[] consult)
	{
		this.consult = consult;
	}

}
