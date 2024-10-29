/**
 * 
 */
package gov.va.med.imaging.muse.webservices.rest.endpoints;

/**
 * @author William Peterson
 *
 */
public class MuseRestUri {

	public static final String ApplicationPath = "MUSEAPIREST";
	public static final String UserOpenSessionUri = "User/UserSession/OpenSession?siteNumber={siteNumber}";
	public static final String UserCloseSessionUri = "User/UserSession/CloseSession?siteNumber={siteNumber}";
	public static final String patientArtifactsPath = "Test/TestRetrieve/GetTestsByCriteria?siteNumber={siteNumber}";
	public static final String ImagePath = "Test/TestReport/GetTestReport?siteNumber={siteNumber}";
}
