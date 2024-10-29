package gov.va.med.imaging.indexterm.federation.endpoints;

/**
 * @author William Peterson
 *
 */

public class FederationIndexTermRestUri {

	/**
	 * 
	 */
	public final static String indexTermServicePath = "indexTerm"; 
	
	/**
	 * Path to retrieve Index Terms
	 */	
	public final static String getOriginsPath = "origins/{routingToken}";
	public final static String getProcedureEventsPath = "procedureevents/{routingToken}";
	public final static String getSpecialtiesPath = "specialties/{routingToken}";
	public final static String getTypesPath = "types/{routingToken}";


}
