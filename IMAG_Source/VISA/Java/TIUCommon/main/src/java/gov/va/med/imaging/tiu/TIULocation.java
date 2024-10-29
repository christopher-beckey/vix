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
public class TIULocation
{
	private final TIUItemURN locationUrn;	
	private final String name;
	
	/**
	 * @param locationUrn
	 * @param name
	 */
	public TIULocation(TIUItemURN locationUrn, String name)
	{
		super();
		this.locationUrn = locationUrn;
		this.name = name;
	}
	
	/**
	 * @return the locationUrn
	 */
	public TIUItemURN getLocationUrn()
	{
		return locationUrn;
	}
	
	/**
	 * @return the name
	 */
	public String getName()
	{
		return name;
	}
	
	

}
