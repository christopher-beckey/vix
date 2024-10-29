package gov.va.med.imaging.tiu.federation;

import java.util.Date;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUAuthor;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.TIULocation;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;

@FacadeRouterInterface(extendsClassName="gov.va.med.imaging.BaseWebFacadeRouterImpl")
@FacadeRouterInterfaceCommandTester
public interface FederationTIURouter
extends gov.va.med.imaging.BaseWebFacadeRouter
//extends FacadeRouter
{

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTIUNotesCommand")
	public abstract List<TIUNote> getTIUNotes(RoutingToken routingToken, String searchText, String titleList)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTIUAuthorsCommand")
	public abstract List<TIUAuthor> getTIUAuthors(RoutingToken routingToken, String searchText)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTIULocationsCommand")
	public abstract List<TIULocation> getTIULocations(RoutingToken routingToken, String searchText)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostTIUNoteWithImageCommand")
	public abstract Boolean associateImageWithTIUNote(AbstractImagingURN imagingUrn, PatientTIUNoteURN tiuNoteUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostTIUNoteCommand")
	public abstract PatientTIUNoteURN createTIUNote(TIUItemURN noteUrn, PatientIdentifier patientIdentifier,
		TIUItemURN locationUrn, Date noteDate, String noteText)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostTIUNoteCommand")
	public abstract PatientTIUNoteURN createTIUNote(TIUItemURN noteUrn, PatientIdentifier patientIdentifier,
		TIUItemURN locationUrn, Date noteDate, ConsultURN consultUrn, String noteText, TIUItemURN authorUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostTIUElectronicallySignNoteCommand")
	public abstract Boolean electronicallySignNote(PatientTIUNoteURN tiuNoteUrn,
		String electronicSignature)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostTIUElectronicallyFileNoteCommand")
	public abstract Boolean electronicallyFileNote(PatientTIUNoteURN tiuNoteUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTIUNoteIsConsultCommand")
	public abstract Boolean isTiuNoteAConsult(TIUItemURN tiuNoteUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTIUNoteIsAdvanceDirectiveCommand")
	public abstract Boolean isTiuNoteAdvanceDirective(TIUItemURN noteUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTIUPatientNoteAdvanceDirectiveCommand")
	public abstract Boolean isTiuPatientNoteAdvanceDirective(PatientTIUNoteURN noteUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTIUPatientNotesCommand")
	public abstract List<PatientTIUNote> getPatientTIUNotes(RoutingToken globalRoutingToken, TIUNoteRequestStatus noteStatus, PatientIdentifier patientIdentifier,
		Date fromDate, Date toDate, String authorDuz, int count, boolean ascending)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTIUNoteTextCommand")
	public abstract String getTIUNoteText(PatientTIUNoteURN noteUrn)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="PostTIUNoteAddendumCommand")
	public abstract PatientTIUNoteURN createTIUNoteAddendum(PatientTIUNoteURN noteUrn, Date date, String addendumText)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTIUNoteIsValidCommand")
	public abstract Boolean isTiuNoteValid(RoutingToken globalRoutingToken, TIUItemURN tiuNoteUrn, PatientTIUNoteURN noteUrn, String typeIndex)
	throws MethodException, ConnectionException;

}
