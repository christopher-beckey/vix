package gov.va.med.imaging.vistaUserPreference.rest.endpoints;

/**
 * @author Budy Tjahjo
 *
 */
public class UserPreferenceRestUri {

	/**
	 * Service application
	 */
	public final static String userPreferencePath = "userPreference"; 
	
	public final static String userPreferenceGetMethodPath = "/load";
	public final static String userPreferenceStoreMethodPath = "/store";
	public final static String userPreferenceDeleteMethodPath = "/delete";
	public final static String userPreferenceGetKeysMethodPath = "/getKeys";

	public final static String userPreferenceGetUserEntityMethodPath = "/load/{userID}/{key}";
	public final static String userPreferenceStoreUserEntityMethodPath = "/store/{userID}/{key}";
	public final static String userPreferenceDeleteUserEntityMethodPath = "/delete/{userID}/{key}";
	public final static String userPreferenceGetKeysUserEntityMethodPath = "/getKeys/{userID}";
}


