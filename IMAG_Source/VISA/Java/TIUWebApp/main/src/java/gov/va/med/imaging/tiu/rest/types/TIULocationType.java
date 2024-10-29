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
//@XmlRootElement(name="location")
public class TIULocationType
{
	private String tiuNoteLocationUrn;
	private String name;
	
	public TIULocationType()
	{
		super();
	}

	/**
	 * @param locationId
	 * @param name
	 */
	public TIULocationType(String tiuNoteLocationUrn, String name)
	{
		super();
		this.tiuNoteLocationUrn = tiuNoteLocationUrn;
		this.name = name;
	}

	/**
	 * @return the locationId
	 */
	public String getTiuNoteLocationUrn()
	{
		return tiuNoteLocationUrn;
	}

	/**
	 * @param locationId the locationId to set
	 */
	public void setTiuNoteLocationUrn(String tiuNoteLocationUrn)
	{
		this.tiuNoteLocationUrn = tiuNoteLocationUrn;
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
	

}
