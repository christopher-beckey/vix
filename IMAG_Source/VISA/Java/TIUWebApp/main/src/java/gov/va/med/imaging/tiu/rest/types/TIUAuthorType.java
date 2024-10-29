/**
 * 
 * 
 * Date Created: Feb 7, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.types;

/**
 * @author Julian Werfel
 *
 */
//@XmlRootElement(name="author")
public class TIUAuthorType
{
	private String tiuNoteAuthorUrn;
	private String name;
	private String service;
	
	public TIUAuthorType()
	{
		super();
	}
	
	/**
	 * @param authorId
	 * @param name
	 * @param service
	 */
	public TIUAuthorType(String tiuNoteAuthorUrn, String name, String service)
	{
		super();
		this.tiuNoteAuthorUrn = tiuNoteAuthorUrn;
		this.name = name;
		this.service = service;
	}

	/**
	 * @return the authorId
	 */
	public String getTiuNoteAuthorUrn()
	{
		return tiuNoteAuthorUrn;
	}

	/**
	 * @param authorId the authorId to set
	 */
	public void setTiuNoteAuthorUrn(String tiuNoteAuthorUrn)
	{
		this.tiuNoteAuthorUrn = tiuNoteAuthorUrn;
	}

	/**
	 * @return the name
	 */
	public String getName()
	{
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name)
	{
		this.name = name;
	}

	/**
	 * @return the service
	 */
	public String getService()
	{
		return service;
	}

	/**
	 * @param service the service to set
	 */
	public void setService(String service)
	{
		this.service = service;
	}

}
