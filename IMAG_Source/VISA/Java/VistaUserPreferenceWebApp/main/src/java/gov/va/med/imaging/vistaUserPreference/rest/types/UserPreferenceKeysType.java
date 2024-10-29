/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Jan 10, 2014
 * Developer: Administrator
 */
package gov.va.med.imaging.vistaUserPreference.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Administrator
 *
 */
@XmlRootElement(name="userPreferenceKeys")
public class UserPreferenceKeysType
{
	
	private String[] userPreferenceKeys;
	
	public UserPreferenceKeysType()
	{
		super();
	}

	/**
	 * @param userPreferenceKeys
	 */
	public UserPreferenceKeysType(String[] userPreferenceKeys)
	{
		super();
		this.userPreferenceKeys = userPreferenceKeys;
	}

	/**
	 * @return the userPreferenceKeys
	 */
	@XmlElement(name="userPreferenceKey")
	public String[] getUserPreferenceKeys()
	{
		return userPreferenceKeys;
	}

	/**
	 * @param userPreferenceKeys the userPreferenceKeys to set
	 */
	public void setUserPreferenceKeys(String[] userPreferenceKeys)
	{
		this.userPreferenceKeys = userPreferenceKeys;
	}

}
