/**
 * 
 * 
 * Date Created: Feb 14, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="noteAddendumInput")
public class TIUNoteAddendumInputType
{
	private String date;
	private String addendumText;
	
	public TIUNoteAddendumInputType()
	{
		super();
	}

	/**
	 * @param date
	 * @param addendumText
	 */
	public TIUNoteAddendumInputType(String date, String addendumText)
	{
		super();
		this.date = date;
		this.addendumText = addendumText;
	}

	/**
	 * @return the date
	 */
	public String getDate()
	{
		return date;
	}

	/**
	 * @param date the date to set
	 */
	public void setDate(String date)
	{
		this.date = date;
	}

	/**
	 * @return the addendumText
	 */
	public String getAddendumText()
	{
		return addendumText;
	}

	/**
	 * @param addendumText the addendumText to set
	 */
	public void setAddendumText(String addendumText)
	{
		this.addendumText = addendumText;
	}
	
}
