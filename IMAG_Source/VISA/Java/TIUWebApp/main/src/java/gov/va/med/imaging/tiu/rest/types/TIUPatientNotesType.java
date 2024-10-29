/**
 * 
 * 
 * Date Created: Feb 13, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="patientNotes")
public class TIUPatientNotesType
{
	private TIUPatientNoteType [] patientNote;
	
	public TIUPatientNotesType()
	{
		super();
	}

	/**
	 * @param note
	 */
	public TIUPatientNotesType(TIUPatientNoteType[] note)
	{
		super();
		this.patientNote = note;
	}

	/**
	 * @return the note
	 */
	public TIUPatientNoteType[] getNote()
	{
		return patientNote;
	}

	/**
	 * @param note the note to set
	 */
	public void setNote(TIUPatientNoteType[] note)
	{
		this.patientNote = note;
	}

}
