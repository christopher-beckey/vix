/**
 * 
 * 
 * Date Created: Feb 7, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="authors")
public class TIUAuthorsType
{
	private TIUAuthorType [] author;
	
	public TIUAuthorsType()
	{
		super();
	}

	/**
	 * @param author
	 */
	public TIUAuthorsType(TIUAuthorType[] author)
	{
		super();
		this.author = author;
	}

	/**
	 * @return the author
	 */
	public TIUAuthorType[] getAuthor()
	{
		return author;
	}

	/**
	 * @param author the author to set
	 */
	public void setAuthor(TIUAuthorType[] author)
	{
		this.author = author;
	}

}
