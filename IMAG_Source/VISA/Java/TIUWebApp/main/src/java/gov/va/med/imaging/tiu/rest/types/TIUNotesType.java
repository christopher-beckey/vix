/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="notes")
public class TIUNotesType
{
	private TIUNoteType [] note;
	
	public TIUNotesType()
	{
		super();
	}

	/**
	 * @param note
	 */
	public TIUNotesType(TIUNoteType[] note)
	{
		super();
		this.note = note;
	}

	/**
	 * @return the note
	 */
	public TIUNoteType[] getNote()
	{
		return note;
	}

	/**
	 * @param note the note to set
	 */
	public void setNote(TIUNoteType[] note)
	{
		this.note = note;
	}

}
