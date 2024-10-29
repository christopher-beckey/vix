/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.types;

/**
 * @author Julian Werfel
 *
 */
//@XmlRootElement(name="note")
public class TIUNoteType
{
	private String tiuNoteTitleUrn;
	private String title;
	private String keyword;
	private String noteClass;
	
	public TIUNoteType()
	{
		super();
	}

	/**
	 * @param noteId
	 * @param title
	 * @param keyword
	 * @param noteClass
	 */
	public TIUNoteType(String tiuNoteTitleUrn, String title, String keyword,
		String noteClass)
	{
		super();
		this.tiuNoteTitleUrn = tiuNoteTitleUrn;
		this.title = title;
		this.keyword = keyword;
		this.noteClass = noteClass;
	}

	/**
	 * @return the noteId
	 */
	public String getTiuNoteTitleUrn()
	{
		return tiuNoteTitleUrn;
	}

	/**
	 * @param noteId the noteId to set
	 */
	public void setTiuNoteTitleUrn(String tiuNoteTitleUrn)
	{
		this.tiuNoteTitleUrn = tiuNoteTitleUrn;
	}

	/**
	 * @return the title
	 */
	public String getTitle()
	{
		return title;
	}

	/**
	 * @param title the title to set
	 */
	public void setTitle(String title)
	{
		this.title = title;
	}

	/**
	 * @return the keyword
	 */
	public String getKeyword()
	{
		return keyword;
	}

	/**
	 * @param keyword the keyword to set
	 */
	public void setKeyword(String keyword)
	{
		this.keyword = keyword;
	}

	/**
	 * @return the noteClass
	 */
	public String getNoteClass()
	{
		return noteClass;
	}

	/**
	 * @param noteClass the noteClass to set
	 */
	public void setNoteClass(String noteClass)
	{
		this.noteClass = noteClass;
	}

}
