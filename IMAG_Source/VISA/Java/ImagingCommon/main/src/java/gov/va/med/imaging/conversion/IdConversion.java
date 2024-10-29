package gov.va.med.imaging.conversion;

import gov.va.med.imaging.configuration.RefreshableConfig;
import gov.va.med.imaging.configuration.VixConfiguration;
import gov.va.med.logging.Logger;

import gov.va.med.imaging.facade.configuration.IdConversionConfiguration;
import org.apache.tomcat.jni.SSL;

import javax.net.ssl.SSLSocketFactory;

// Should be removed along with getEntity_OLD() method
//import java.util.Iterator;
//import org.json.simple.*;
//import org.json.simple.parser.*;

/**
 * Class to convert an ICN to an EDIPI or vice versa
 * 
 * Quoc reworked.
 * 
 * @author Sonny Jiang
 * 
 */
public class IdConversion
{

    private static final Logger LOGGER = Logger.getLogger(IdConversion.class);

    private final static String DOD_ORG_OID = "200DOD^USDOD";
    //private final static String ICN_ORG_OID = "200M^USVHA"; // From Lamont: the "200M" part may change.  Check for "USVHA" only?
    private final static String ICN_ORG_OID = "Organization";
    private final static String UNKNOWN = "Unknown";  // Checked with Lamont: "Unknown" is OK.
    private final static String ICN_METHOD = "=getIcnViaEdipi";  // DO NOT remove the equal sign "="
    private final static String EDIPI_METHOD = "=getEdiViaIcn"; // DO NOT remove the equal sign "=" and the value is fixed as shown.
    private final static String REPLACE_QRY_METHOD = "{queryMethod}";
    private final static String REPLACE_AMP_SIGN = "{ampersandSign}";

    // Cached configuration so we don't need to load trust stores and the like for every call
	private static final Object SYNC_OBJECT = new Object();
    private static IdConversionConfiguration CONFIGURATION;
    private static SSLSocketFactory SSL_SOCKET_FACTORY;

    // Static method to get the current configuration instead of loading it every call
    private static IdConversionConfiguration getConfiguration() {
    	synchronized (SYNC_OBJECT) {
    		if (CONFIGURATION == null) {
    			CONFIGURATION = IdConversionConfiguration.getConfiguration();
			}
		}

		return CONFIGURATION;
	}

	// Static method to get a cached SSLSocketFactory instead of initializing it every call
	private static SSLSocketFactory getSSLSocketFactory() throws Exception {
    	synchronized (SYNC_OBJECT) {
    		if (SSL_SOCKET_FACTORY == null) {
				// Get a SSLSocketFactory for re-use
				IdConversionConfiguration configuration = getConfiguration();
				SSL_SOCKET_FACTORY = HttpsCalls.getSSLSocketFactory(configuration.getKeyStoreFilePath(), configuration.getKeyStorePassword(), configuration.getTrustStoreFilePath(), configuration.getTrustStorePassword());
			}
		}

		return SSL_SOCKET_FACTORY;
	}

  //==========================================================================================================
    
    /**
     * Method to convert an ICN to an EDIPI
     * 
     * @param icn 			ICN to convert
     * @return String		resultant EDIPI
     * @throws Exception	Catch all exception
     * 
     */
    public static String toEdipiByIcn(String icn) throws Exception {
        LOGGER.debug("IdConversion.toEdipiByIcn(1) --> Given ICN [{}]", icn);

		String username = null;
		String password = null;
		IdConversionConfiguration config = IdConversionConfiguration.getConfiguration();
		if (config != null) {
			username = config.getUsername();
			password = config.getPassword();
		}

    	return (isValid(icn) ? convertId(icn, DOD_ORG_OID, username, password, UNKNOWN) : null);
    }

    /**
     * Method to convert an ICN to an EDIPI
     *  
     * @param icn 				ICN to convert
     * @param userId			user Id
     * @param userName			user name
     * @param facility			facility number
     * @return String			resultant EDIPI
     * @throws Exception		Catch all exception
     * 
     */
    public static String toEdipiByIcn(String icn, String userId, String userName, String facility) throws Exception {
        LOGGER.debug("IdConversion.toEdipiByIcn(2) --> Given ICN [{}]", icn);
        return (isValid(icn) ? convertId(icn, DOD_ORG_OID, userId, userName, facility) : null);
    }

    /**
     * Method to convert an EDIPI to an ICN
     * 
     * @param edipi			EIDPI
     * @return String		resultant ICN
     * @throws Exception	Catch all exception
     * 
     */
    public static String toIcnByEdipi(String edipi) throws Exception {
        LOGGER.debug("IdConversion.toIcnByEdipi(1) --> Given EDIPI [{}]", edipi);

		String username = null;
		String password = null;
		IdConversionConfiguration config = IdConversionConfiguration.getConfiguration();
		if (config != null) {
			username = config.getUsername();
			password = config.getPassword();
		}

        return (isValid(edipi) ? convertId(edipi, ICN_ORG_OID, username, password, UNKNOWN) : null);
	}

    /**
     * Method to convert an EDIPI to an ICN
     *  
     * @param edipi 			EDIPI to convert
     * @param userId			user Id
     * @param userName			user name
     * @param facilityNum		facility number
     * @return String			resultant ICN
     * @throws Exception		Catch all exception
     * 
     */
    public static String toIcnByEdipi(String edipi, String userId, String userName, String facilityNum) throws Exception {
        LOGGER.debug("IdConversion.toIcnByEdipi(2) --> Given EDIPI [{}]", edipi);
        return (isValid(edipi)? convertId(edipi, ICN_ORG_OID, userId, userName, facilityNum) : null);
	}
    
    /**
     * Place-holder to demonstrate naming and exception convention only
     * 
     * @return String			DFN to convert
     * @throws Exception		Catch all exception
     */
    public static String toDfnByIcn(String dfn) throws Exception {
    	throw new UnsupportedOperationException("IdConversion.toDfnByIcn() --> Conversion from a DFN to an ICN is currently not supported.");
    }

    //==========================================================================================================
    
    /**
     * Common method to convert an id in one format to another
     * Intentionally log here to shorten codes above
     * and to obscure the ids a bit
     * 
     * @param id				Id to convert
     * @param orgOID			org OID
     * @param userId			user Id
     * @param userName			user name
     * @param facilityNum		facility number
     * @return String			converted Id
     * @throws Exception		Catch all exception
     * 
     */
    private static String convertId(String id, String orgOID, String userId, String userName, String facilityNum) throws Exception {
        try {
        	// Resolve protocol here since it can also change which HTTP call method we use
			IdConversionConfiguration config = IdConversionConfiguration.getConfiguration();
			String protocol = isValid(config.getProtocol()) ? config.getProtocol() : IdConversionConfiguration.DEF_PROTOCOL;

			// Get the converted id
			String convertedId = null;
			
			if ("https".equalsIgnoreCase(protocol)) {
				convertedId = getEntityId(HttpsCalls.HttpsCall(createUrl(config, protocol, id, userId, userName, facilityNum, DOD_ORG_OID.equalsIgnoreCase(orgOID)), getConfiguration().getUsername(), getConfiguration().getPassword(), getSSLSocketFactory()), orgOID);
			} else {
				convertedId = getEntityId(HttpsCalls.HttpCall(createUrl(config, protocol, id, userId, userName, facilityNum, DOD_ORG_OID.equalsIgnoreCase(orgOID)), getConfiguration().getUsername(), getConfiguration().getPassword()), orgOID);
			}

            LOGGER.debug("IdConversion.convertId() --> Given Id [{}] converted to [{}]", id, convertedId);
            return convertedId;
            
		} catch (Exception e) {
            LOGGER.error("IdConversion.convertId() --> Encountered exception [{}]: {}", e.getClass().getSimpleName(), e.getMessage());
			throw e;
		}
	}
    
    /**
     * Helper method to create a URL to invoke with given parameters
     *
	 * @param config		configuration to use
	 * @param protocol		configuration protocol to use for the URL
     * @param id			id to convert
     * @param userId		user Id
     * @param userName		user name
     * @param facilityNum	facility number
     * @param toEdipi		flag to replace which query method in String
     * @return String		URL created to invoke
     * 
     */
    private static String createUrl(IdConversionConfiguration config, String protocol, String id, String userId, String userName, String facilityNum, boolean toEdipi) {
    	// Use this for testing only. Should be removed along with testing section below when done and uncomment the above
		//IdConversionConfiguration config = IdConversion.loadedConfig != null ? IdConversion.loadedConfig : IdConversionConfiguration.getConfiguration();
		
		StringBuilder urlBuilder = new StringBuilder();
		
		urlBuilder.append(protocol);
		urlBuilder.append("://");
		urlBuilder.append(isValid(config.getHost()) ? config.getHost() : IdConversionConfiguration.DEF_HOST);
		urlBuilder.append(":");
		urlBuilder.append(config.getPort() != null && config.getPort().intValue() > 0 ? config.getPort().toString() : IdConversionConfiguration.DEF_PORT.toString());
		String urlResource = isValid(config.getUrlResource()) ? config.getUrlResource() : IdConversionConfiguration.DEF_URL_RESOURCE;
		urlBuilder.append(urlResource.replace(IdConversion.REPLACE_AMP_SIGN, "&") + "=" + id);
		
		if (isValid(userId)) {
			urlBuilder.append("&_elements=identifier&-userid=" + userId);
		}

		if (isValid(userName)) {
			urlBuilder.append("&-username=" + userName);
		}
		
		if (isValid(facilityNum)) {
			urlBuilder.append("&-facility=" + facilityNum);
		}
		
		String createdUrl = urlBuilder.toString().replace(REPLACE_QRY_METHOD, toEdipi ? EDIPI_METHOD : ICN_METHOD);

        LOGGER.debug("createUrl() --> URL created [{}] for {}", createdUrl, toEdipi ? "EDIPI" : "ICN");
		
    	return createdUrl;
    }
    
    /**
     * Helper method to get the converted Id from the query result
     * 
     * Created this version because the JSON package used isn't TRM-approved.
     * Used solely String manipulation to get the converted Id
     * 
     * Pros: no dependency on third party jar, (a little) performance enhancement (parsing is supposedly memory intensive)
     * Cons: the format of response is pretty fixed, especially the "value":"EDIPI_OR_ICN" part
     * 
     * @param queryResult	query result
     * @param orgOID 		facility OID
     * @return String		converted Id
     * @throws Exception	Catch all exception
     * 
     */
    private static String getEntityId(String queryResult, String orgOID) throws Exception {
    	
    	/* sample response from the translation source (all in one line)
    	 
    	[{"resourceType":"Bundle","id":"95906554-ac9d-4ea4-995c-f2af808f05ea","total":1,"entry":[{"resource":{"resourceType":"Patient",
    	"identifier":[{"system":"urn:oid:2.16.840.1.113883.4.349","value":"1606681433","assigner":{"reference":"Organization","display":"200DOD^USDOD"}}]}}]}]
    	
    	*/
    	
    	if( !isValid(queryResult) ) {
    		LOGGER.debug("IdConversion.getEntityId() --> Given query result is null or empty. Return null.");
    		return null;
    	}
    	
    	if( !isValid(orgOID) ) {  // Do we even need this ??? Sanity check??
    		LOGGER.debug("IdConversion.getEntityId() --> Given org OID is null or empty. Return null.");
    		return null;
    	}

    	String result = null;
    	
		if(queryResult.contains(orgOID)) { // Do we even need this ??? Sanity check??
			
			// Work on this piece "value":"1606681433"
			
			// get the index of "value", which is at the first double quotes.  Add 9 to get past the third double quotes
			int startIndex = queryResult.indexOf("\"value\"") + 9;
			
			// get the index of the fourth (last) double quotes starting from the third double quotes
			int endIndex = queryResult.indexOf("\"", startIndex);
			
			// get everything between the third and the fourth double quotes. Should accommodate both EDIPI and ICN (different lengths)
			result = queryResult.substring(startIndex, endIndex);
			
		} else {
            LOGGER.debug("IdConversion.getEntityId() --> No Id found for given org OID [{}]. Should return null.", orgOID);
			// Should return null below
		}

        LOGGER.debug("IdConversiongetEntityId() --> Return the result [{}]", result);
		
    	return result;
    }
    
 
    /**
     * Helper method to validate a String with both conditions being true
     * 
     * a) must not be null
     * b) has some value (length > 0)
     * 
     * @param value			value to validate
     * @return boolean		whether or not the given value is valid
     */
    private static boolean isValid(String value) {
		return  value != null && value.length() > 0;
	}
    
    //===========================  Unused for now  ===================================
    
    /**
     * Helper method to parse the query result for the converted Id
     * 
     * Keep this for comparison and in case we need to go back to JSON parsing.
     * 
     * Can be removed after P254 release and/or after thorough testing with translation source.
     * 
     * @param String		query result
     * @param String 		facility OID
     * @return String		converted Id
     * @throws Exception	Catch all exception
     * 
     
    private static String getEntityId_OLD(String queryResult, String orgOID) throws Exception {
    	
    	if(queryResult == null || queryResult.equals("")) {
    		logger.debug("getEntityId() --> Given query result is null or empty. Return null.");
    		return null;
    	}
    	
    	if(orgOID == null || orgOID.equals("")) {
    		logger.debug("getEntityId() --> Given facility OID is null or empty. Return null.");
    		return null;
    	}
    	
    	String convertedId = null;
		
    	logger.debug("getEntityId() --> Facility OID to look for [" + orgOID + "]");
    	logger.debug("getEntityId() --> Given query result [" + queryResult + "]");
    	
    	try {    		
    		
    		JSONObject json = (JSONObject) new JSONParser().parse(queryResult);

    		//JSONArray msg = (JSONArray) json.get("entry");
    		//JSONObject res = (JSONObject) msg.get(0);
    		//JSONObject res1 = (JSONObject) res.get("resource");
    		//JSONArray ids = (JSONArray) res1.get("identifier");
    		
    		// Replace the above
    		JSONObject resp = (JSONObject) ((JSONArray) json.get("entry")).get(0);
    		JSONArray ids = (JSONArray) ((JSONObject) resp.get("resource")).get("identifier");

    		if (ids == null) {
    			logger.debug("getEntityId() --> No Ids found. Return null.");
    			return null;
    		}
        
    		// loop array
    		Iterator<JSONObject> iterator = ids.iterator();
    		
    		while (iterator.hasNext()) {
    			
    			JSONObject set = (JSONObject) iterator.next();
    			JSONObject asn = (JSONObject) set.get("assigner");
    			String dis = (String) asn.get("display");
    			String sys = (String) set.get("value");
    			
    			
    			if (orgOID.compareTo(dis) == 0) { 
    				convertedId = sys;
    			}
    		}
    	} catch (Exception e) {
			logger.error("getEntityId() --> Exception = " + e);
			throw e;    		
    	}
		
    	logger.debug("getEntityId() --> Return the converted Id [" + convertedId + "]");
 
    	return convertedId;
    }
    
    */
            
    //===========================  Added for testing purposes only  ===================================
    
    protected static IdConversionConfiguration loadedConfig;
    
    public static void setLoadedConfig(IdConversionConfiguration loadedConfig) {
    	IdConversion.loadedConfig = loadedConfig;
    }

	//===========================  Added for testing purposes only  ===================================
}
