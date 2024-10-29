package gov.va.med.imaging.consult.federation.endpoints;

/**
 * @author William Peterson
 *
 */

public class FederationConsultRestUri {

	/**
	 * 
	 */
	public final static String consultServicePath = "consult"; 
	
	/**
	 * Path to retrieve Consults for patient
	 */
	public final static String getConsultsPath = "consults/{routingToken}/{patientIcn}";

}
