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
public class TIUAuthor
{
	private final TIUItemURN authorUrn;
	private final String name;
	private final String service;
	
	/**
	 * @param authorUrn
	 * @param name
	 * @param service
	 */
	public TIUAuthor(TIUItemURN authorUrn, String name, String service)
	{
		super();
		this.authorUrn = authorUrn;
		this.name = name;
		this.service = service;
	}
	
	/**
	 * @return the authorUrn
	 */
	public TIUItemURN getAuthorUrn()
	{
		return authorUrn;
	}
	
	/**
	 * @return the name
	 */
	public String getName()
	{
		return name;
	}
	
	/**
	 * @return the service
	 */
	public String getService()
	{
		return service;
	}
}
