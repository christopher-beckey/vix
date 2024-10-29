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
@XmlRootElement(name="locations")
public class TIULocationsType
{
	private TIULocationType [] location;
	
	public TIULocationsType()
	{
		super();
	}

	/**
	 * @param location
	 */
	public TIULocationsType(TIULocationType[] location)
	{
		super();
		this.location = location;
	}

	/**
	 * @return the location
	 */
	public TIULocationType[] getLocation()
	{
		return location;
	}

	/**
	 * @param location the location to set
	 */
	public void setLocation(TIULocationType[] location)
	{
		this.location = location;
	}

}
