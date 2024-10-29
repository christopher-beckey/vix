/**
 * 
 * Date Created: Jul 27, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference.rest.translator;

import gov.va.med.imaging.vistaUserPreference.rest.types.UserPreferenceKeysType;

import java.util.List;


/**
 * @author Budy Tjahjo
 *
 */
public class UserPreferenceRestTranslator
{
	
	public static UserPreferenceKeysType translateUserPreferenceKeys(List<String> userPreferenceKeys)
	{
		if(userPreferenceKeys == null)
			return null;
		
		String[] result = new String[userPreferenceKeys.size()];
		result = userPreferenceKeys.toArray(result);
		
		return new UserPreferenceKeysType(result);
	}
	
}
