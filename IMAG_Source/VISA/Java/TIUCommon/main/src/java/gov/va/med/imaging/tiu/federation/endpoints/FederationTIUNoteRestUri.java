package gov.va.med.imaging.tiu.federation.endpoints;

/**
 * @author William Peterson
 *
 */

public class FederationTIUNoteRestUri {

	/**
	 * 
	 */
	public final static String tiuNoteServicePath = "tiu"; 
	
	/**
	 * Path to retrieve TIU Notes
	 */
	public final static String getTIUNotesPath = "notes/{routingToken}";
	public final static String getTIULocationsPath = "locations/{routingToken}";
	public final static String getTIUAuthorsPath = "authors/{routingToken}";
	public final static String associateImageWithNotePath = "associate/{routingToken}/{imageUrn}/{tiuNoteUrn}";
	public final static String createTIUNotePath = "note/{routingToken}";
	public final static String electronicallySignNotePath = "note/sign/{routingToken}/{tiuNoteUrn}";
	public final static String electronicallyFileNotePath = "note/file/{routingToken}/{tiuNoteUrn}";
	public final static String isTiuNoteAConsultPath = "consult/{routingToken}/{tiuItemUrn}";
	public final static String isNoteValidAdvanceDirectivePath = "note/advanceDirective/{routingToken}/{tiuItemUrn}";
	public final static String isPatientNoteValidAdvanceDirectivePath = "patient/note/advanceDirective/{routingToken}/{noteUrn}";
	public final static String getPatientTIUNotesPath = "patient/notes/{routingToken}";
	public final static String getTIUNoteTextPath = "patient/note/{routingToken}/{noteUrn}";
	public final static String createTIUNoteAddendumPath = "note/addendum/{routingToken}/{noteUrn}";
	public final static String isTiuNoteValidPath = "note/valid/{routingToken}";

}
