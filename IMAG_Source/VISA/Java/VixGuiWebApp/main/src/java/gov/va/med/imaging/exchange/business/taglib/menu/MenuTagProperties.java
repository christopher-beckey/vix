package gov.va.med.imaging.exchange.business.taglib.menu;

import java.util.MissingResourceException;
import java.util.ResourceBundle;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class MenuTagProperties
{
	private final ResourceBundle resourceBundle;

	MenuTagProperties(String propertyBundleName)
	{
		this.resourceBundle = ResourceBundle.getBundle(propertyBundleName);
	}

	public String getString(String key)
	{
		try
		{
			return resourceBundle.getString(key);
		} 
		catch (MissingResourceException e)
		{
			return '!' + key + '!';
		}
	}
	
	/**
	 * 
	 * @param key
	 * @return 
	 * a String array, parsing the property value assuming a comma delimiter
	 * a null if the there is no resource identified by the key
	 * a zero element String array if the property is null
	 */
	public String[] getStringArray(String key)
	{
		try
		{
			String propertyValue = resourceBundle.getString(key);
			if( propertyValue == null)
				return new String[]{};
			
			return propertyValue.split(",");
		} 
		catch (MissingResourceException e)
		{
			return null;
		}
	}
}
