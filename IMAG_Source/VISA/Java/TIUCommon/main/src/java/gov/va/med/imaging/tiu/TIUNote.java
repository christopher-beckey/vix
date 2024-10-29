/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu;

/**
 * @author Julian Werfel
 *
 */
public class TIUNote
{
	private final TIUItemURN noteUrn;
	private final String title;
	private final String keyWord;
	private final String noteClass;
	
	/**
	 * @param tiuNoteUrn
	 * @param title
	 * @param keyWord
	 * @param noteClass
	 */
	public TIUNote(TIUItemURN noteUrn, String title, String keyWord,
		String noteClass)
	{
		super();
		this.noteUrn = noteUrn;
		this.title = title;
		this.keyWord = keyWord;
		this.noteClass = noteClass;
	}

	/**
	 * @return the noteUrn
	 */
	public TIUItemURN getNoteUrn()
	{
		return noteUrn;
	}

	/**
	 * @return the title
	 */
	public String getTitle()
	{
		return title;
	}

	/**
	 * @return the keyWord
	 */
	public String getKeyWord()
	{
		return keyWord;
	}

	/**
	 * @return the noteClass
	 */
	public String getNoteClass()
	{
		return noteClass;
	}


}
