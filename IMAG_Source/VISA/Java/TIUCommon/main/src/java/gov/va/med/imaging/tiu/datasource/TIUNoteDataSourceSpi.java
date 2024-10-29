/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.datasource;

import java.util.Date;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.datasource.annotations.SPI;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUAuthor;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.TIULocation;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;

/**
 * @author Julian Werfel
 *
 */
@SPI(description="Defines the interface for TIU notes")
public interface TIUNoteDataSourceSpi
extends VersionableDataSourceSpi
{
	
	public abstract List<TIUNote> getMatchingTIUNotes(RoutingToken globalRoutingToken, String searchText, String titleList)
	throws MethodException, ConnectionException;
	
	public abstract List<TIUAuthor> getAuthors(RoutingToken globalRoutingToken, String searchText)
	throws MethodException, ConnectionException;
	
	public abstract List<TIULocation> getLocations(RoutingToken globalRoutingToken, String searchText)
	throws MethodException, ConnectionException;
	
	public abstract Boolean associateImageWithTIUNote(AbstractImagingURN imagingUrn, PatientTIUNoteURN tiuItemIdentifier)
	throws MethodException, ConnectionException;
	
	public abstract PatientTIUNoteURN createTIUNote(TIUItemURN noteUrn, PatientIdentifier patientIdentifier,
		TIUItemURN locationUrn, Date noteDate, ConsultURN consultUrn, String noteText, TIUItemURN authorUrn)
	throws MethodException, ConnectionException;
	
	public abstract Boolean electronicallySignTIUNote(PatientTIUNoteURN tiuNoteUrn, String electronicSignature)
	throws MethodException, ConnectionException;
	
	public abstract Boolean electronicallyFileTIUNote(PatientTIUNoteURN tiuNoteUrn)
	throws MethodException, ConnectionException;
	
	public abstract Boolean isTIUNoteAConsult(TIUItemURN tiuNoteUrn)
	throws MethodException, ConnectionException;
	
	public abstract Boolean isNoteValidAdvanceDirective(TIUItemURN noteUrn)
	throws MethodException, ConnectionException;
	
	public abstract Boolean isPatientNoteValidAdvanceDirective(PatientTIUNoteURN noteUrn)
	throws MethodException, ConnectionException;
	
	public abstract List<PatientTIUNote> getPatientTIUNotes(RoutingToken globalRoutingToken, 
			TIUNoteRequestStatus noteStatus, PatientIdentifier patientIdentifier,
			Date fromDate, Date toDate, String authorDuz, int count, boolean ascending)
	throws MethodException, ConnectionException;
	
	public abstract String getTIUNoteText(PatientTIUNoteURN noteUrn)
	throws MethodException, ConnectionException;
	
	public abstract PatientTIUNoteURN createTIUNoteAddendum(PatientTIUNoteURN noteUrn,
		Date date, String addendumText)
	throws MethodException, ConnectionException;
	
	public abstract Boolean isTIUNoteValid(RoutingToken globalRoutingToken, TIUItemURN noteUrn, 
			PatientTIUNoteURN tiuNoteUrn, String typeIndex)
	throws MethodException, ConnectionException;

}
