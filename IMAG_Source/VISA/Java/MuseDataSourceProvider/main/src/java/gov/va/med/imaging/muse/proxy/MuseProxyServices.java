/**
 * 
 */
package gov.va.med.imaging.muse.proxy;

import gov.va.med.imaging.proxy.services.ProxyServices;

/**
 * @author William Peterson
 *
 */
public class MuseProxyServices 
extends ProxyServices {

	private static final long serialVersionUID = 1L;
	
	private String alienSiteNumber;
	
	public MuseProxyServices(String alienSiteNumber)
	{
		super();
		this.alienSiteNumber = alienSiteNumber;
	}

	public String getAlienSiteNumber()
	{
		return alienSiteNumber;
	}

	public void setAlienSiteNumber(String alienSiteNumber)
	{
		this.alienSiteNumber = alienSiteNumber;
	}

}
