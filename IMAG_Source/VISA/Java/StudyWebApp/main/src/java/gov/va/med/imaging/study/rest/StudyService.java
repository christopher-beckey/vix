/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 16, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 
        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+
 */
package gov.va.med.imaging.study.rest;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.study.commands.*;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.PatVistaInfo;
import gov.va.med.imaging.study.dicom.query.PatientCFind;
import gov.va.med.imaging.study.dicom.query.QueryFactory;
import gov.va.med.imaging.study.dicom.remote.study.SeriesFetchTask;
import gov.va.med.imaging.study.dicom.vista.PatientInfo;
import gov.va.med.imaging.study.rest.types.*;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.logging.Logger;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

/**
 * @author VHAISWWERFEJ
 *
 */
@Path("")
public class StudyService {
	private final static Logger logger = Logger.getLogger(StudyService.class);
	
	private final static String ERROR_MSG = "Pass phrase was wrong. Cannot run. Please provide correct pass phrase.";

	public static String scpAuthString = null;
	static{
		try {
			scpAuthString = gov.va.med.imaging.encryption.AesEncryption.decodeByteArray("lQvcCLiPGF4WKgHF9hZRlg==");
		} catch (Exception e) {
			logger.error("Could not decrypt scpAuthString");
		}
	}
	
	@POST
	@Path("studies/va/icn/{treatingFacilitySiteId}/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public StudiesResultType getVaPatientStudiesFromIcn(
			@PathParam("treatingFacilitySiteId") String treatingFacilitySiteId,
			@PathParam("patientIcn") String patientIcn,
			StudyFilterType studyFilterType)
	throws MethodException, ConnectionException	{
		// Fixed NulPointerException from "GET" method
		if(studyFilterType != null) {
			studyFilterType.setStoredFilterId(null);
		}
		
		return new StudyGetPatientStudiesCommand(treatingFacilitySiteId,
					PatientIdentifier.icnPatientIdentifier(patientIcn),
					studyFilterType).execute();
	}
	
	@GET
	@Path("studies/va/icn/{treatingFacilitySiteId}/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	public StudiesResultType getVaPatientStudiesFromIcn(
			@PathParam("treatingFacilitySiteId") String treatingFacilitySiteId,
			@PathParam("patientIcn") String patientIcn)
	throws MethodException, ConnectionException {
		
		return getVaPatientStudiesFromIcn(treatingFacilitySiteId, patientIcn, null);
	}
	
	// VAI-1202
	@POST
	@Path("studies/site/icn/{siteId}/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public StudiesResultType getPatientStudiesFromIcn(
			@PathParam("siteId") String siteId,
			@PathParam("patientIcn") String patientIcn,
			StudyFilterType studyFilterType)
	throws MethodException, ConnectionException {
		
		StudiesResultType studies = new StudyGetStudiesCommand(siteId, PatientIdentifier.icnPatientIdentifier(patientIcn), studyFilterType).execute();
		
		for (StudyType aStudy : studies.getStudies().getStudies()) {
			aStudy.setAccessionNumber(null);
		}

		return studies;
	}

	@POST
	@Path("studies/report/site/icn/{treatingFacilitySiteId}/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public StudiesResultType getStudiesAndReportsFromSiteIcn(
			@PathParam("treatingFacilitySiteId") String treatingFacilitySiteId,
			@PathParam("patientIcn") String patientIcn,
			StudyFilterType studyFilterType)
	throws MethodException, ConnectionException {
		
		StudiesResultType studies = new StudyGetStudiesAndReportsCommand(treatingFacilitySiteId, PatientIdentifier.icnPatientIdentifier(patientIcn), studyFilterType).execute();
		
		for (StudyType aStudy : studies.getStudies().getStudies()) {
			aStudy.setAccessionNumber(null);
		}
		
		return studies;
	}
	
	@GET
	@Path("studies/report/site/icn/{treatingFacilitySiteId}/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public StudiesResultType getStudiesAndReportFromSiteIcn(
			@PathParam("treatingFacilitySiteId") String treatingFacilitySiteId,
			@PathParam("patientIcn") String patientIcn)
	throws MethodException, ConnectionException {
		
		StudiesResultType studies = new StudyGetStudiesAndReportsCommand(treatingFacilitySiteId, PatientIdentifier.icnPatientIdentifier(patientIcn), null).execute();
		
		for (StudyType aStudy : studies.getStudies().getStudies()) {
			aStudy.setAccessionNumber(null);
		}
		
		return studies;
	}
	
	@POST
	@Path("studiesWithAccessionNumber/site/icn/{siteId}/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public StudiesResultType getPatientStudiesFromIcnWithAccessionNumber(
			@PathParam("siteId") String siteId,
			@PathParam("patientIcn") String patientIcn,
			StudyFilterType studyFilterType)
	throws MethodException, ConnectionException {
		
		StudiesResultType studies = new StudyGetStudiesCommand(siteId, PatientIdentifier.icnPatientIdentifier(patientIcn), studyFilterType).execute();
		
		for (StudyType aStudy : studies.getStudies().getStudies()) {
			aStudy.setAwivParameters(null);
			aStudy.setFirstImage(null);
		}
		
		return studies;
	}
	
	// VAI-1202
	@GET
	@Path("studies/site/icn/{siteId}/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	public StudiesResultType getPatientStudiesFromIcn(
			@PathParam("siteId") String siteId,
			@PathParam("patientIcn") String patientIcn)
	throws MethodException, ConnectionException {
		
		StudiesResultType studies = new StudyGetStudiesCommand(siteId, PatientIdentifier.icnPatientIdentifier(patientIcn), null).execute();
		
		for (StudyType aStudy : studies.getStudies().getStudies()) {
			aStudy.setAccessionNumber(null);
		}

		return studies;
	}

	@GET
	@Path("studiesWithAccessionNumber/site/icn/{siteId}/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	public StudiesResultType getPatientStudiesFromIcnWithAccessionNumber(
			@PathParam("siteId") String siteId,
			@PathParam("patientIcn") String patientIcn)
	throws MethodException, ConnectionException {
		
		StudiesResultType studies = new StudyGetStudiesCommand(siteId, PatientIdentifier.icnPatientIdentifier(patientIcn), null).execute();
		
		for (StudyType aStudy : studies.getStudies().getStudies()) {
			aStudy.setAwivParameters(null);
			aStudy.setFirstImage(null);
		}
		
		return studies;
	}

	@POST
	@Path("studies/local/dfn/{patientDfn}")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public StudiesResultType getLocalPatientStudiesFromDfn(@PathParam("patientDfn") String patientDfn, StudyFilterType studyFilterType)
	throws MethodException, ConnectionException {
		
		return new StudyGetStudiesCommand(null,	PatientIdentifier.dfnPatientIdentifier(patientDfn, null), studyFilterType).execute();
	}
	
	@GET
	@Path("studies/local/dfn/{patientDfn}")
	@Produces(MediaType.APPLICATION_XML)
	public StudiesResultType getLocalPatientStudiesFromDfn(@PathParam("patientDfn") String patientDfn) 
	throws MethodException, ConnectionException {
		
		return new StudyGetStudiesCommand(null,	PatientIdentifier.dfnPatientIdentifier(patientDfn, null), null).execute();
	}
	
	// VAI-1202
	@GET
	@Path("study/{studyId}")
	@Produces(MediaType.APPLICATION_XML)
	public LoadedStudyType getStudy(
			@PathParam("studyId") String studyId,
			@QueryParam("includeSeriesDescription") boolean includeDescription)
	throws MethodException, ConnectionException
	{
		//VAI-1080 Technically the LoadLevel indicates the report should be included but it hasn't been so far
		 LoadedStudyType aStudy = new StudyGetStudyCommand(studyId).execute();
		 aStudy.setAccessionNumber(null);
		 aStudy.setRadiologyReport(null);

		 // If the description is not requested, explicitly remove it
		 if (! (includeDescription)) {
			 StudySeriesesType studySeriesesType = aStudy.getSeries();
			 if (studySeriesesType != null) {
				 if (studySeriesesType.getSeries() != null) {
					 for (StudySeriesType studySeriesType : studySeriesesType.getSeries()) {
						 studySeriesType.setDescription(null);
					 }
				 }
			 }
		 }

		 return aStudy;
	}

	@GET
	@Path("/dicom/study/{studyId}")
	@Produces(MediaType.APPLICATION_XML)
	public LoadedStudyType getStudy(
			@PathParam("studyId") String studyId,
			@HeaderParam("scpauth") String authString)
			throws MethodException, ConnectionException{
		LoadedStudyType lst = new LoadedStudyType();
		try {
			if(isUserAuthenticated(authString)) {
				SeriesFetchTask task = new SeriesFetchTask(studyId, TransactionContextFactory.get().getTransactionId());
				return task.getStudyAndSeriesMeta();
			}else{
				lst.setDescription("Not authed");
			}
		}catch (Exception e){
			logger.error("Problem with series fetch task ", e);
			lst.setDescription("Problem with series fetch task for " + studyId + " msg: " + e.getMessage());
		}
		return lst;
	}

	@GET
	@Path("/dicom/cache/local/{studyId}")
	@Produces(MediaType.APPLICATION_XML)
	public RestStringType cacheLocalStudy(
			@PathParam("studyId") String studyId,
			@QueryParam("callingAe") String callingAe,
			@QueryParam("callingIp") String callingIp,
			@QueryParam("icn") String icn) {
		return DicomService.cacheLocalStudy(studyId,callingAe,callingIp,icn);
	}
	
	// VAI-1202
	@GET
	@Path("study/report/{studyId}")
	@Produces(MediaType.APPLICATION_XML)
	public RestStringType getStudyReport(@PathParam("studyId") String studyId)
	throws MethodException, ConnectionException	{

		return new StudyGetStudyReportCommand(studyId).execute();
	}

	@GET
	@Path("filters/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public StoredFiltersType getStudyFilters(@PathParam("siteId") String siteId)
	throws MethodException, ConnectionException {
		
		return new GetStoredFiltersCommand(siteId).execute();
	}
	
	@GET
	@Path("cprs/{siteId}/{patientIcn}/{cprsIdentifier}")
	@Produces(MediaType.APPLICATION_XML)
	public StudiesType getImagesAssociatedWithCprsIdentifier(
		@PathParam("siteId") String siteId,
		@PathParam("patientIcn") String patientIcn,
		@PathParam("cprsIdentifier") String cprsIdentifierString)
	throws MethodException, ConnectionException {
		return new StudyGetCprsImagesCommand(siteId, patientIcn, cprsIdentifierString).execute();
	}

	@GET
	@Path("filter")
	@Produces(MediaType.APPLICATION_XML)
	public StudyFilterType getFilter()
	{
		StudyFilterType filter = new StudyFilterType();
		Calendar fromDate = Calendar.getInstance();
		fromDate.set(Calendar.YEAR, 2010);
		fromDate.set(Calendar.MONTH, 0);
		fromDate.set(Calendar.DAY_OF_MONTH, 1);
		
		filter.setFromDate(fromDate.getTime());
		filter.setToDate(Calendar.getInstance().getTime());
		filter.setResultType(StudyFilterResultType.all);
		
		List<String> cptCodes = new ArrayList<String>();
		cptCodes.add("Code1");
		cptCodes.add("Code2");
		
		filter.setCptCodes(cptCodes);
		
		List<String> modalityCodes = new ArrayList<String>();
		modalityCodes.add("Code1");
		modalityCodes.add("Code2");
		
		filter.setModalityCodes(modalityCodes);

		return filter;
	}

	// works on VIX, might be made private
	@GET
	@Path("study/dicom/{ien}")
	@Produces(MediaType.APPLICATION_XML)
	public RestStringType getStudyInfo(@PathParam("ien") String ien, @HeaderParam("scpauth") String authString) {
		
		return (isUserAuthenticated(authString) ? new RestStringType(DicomService.getStudyInfo(ien)) 
												: new RestStringType(ERROR_MSG));
	}

	@GET
	@Path("study/dicom/{siteId}/{ien}")
	@Produces(MediaType.APPLICATION_XML)
	public RestStringType getStudyInfo(@PathParam("siteId") String siteId, 
			@PathParam("ien") String ien,
			@HeaderParam("scpauth") String authString) {
		
		return (isUserAuthenticated(authString) ? new RestStringType(DicomService.getRemoteStudyInfo(siteId, ien)) 
												: new RestStringType(ERROR_MSG));
	}

	@GET
	@Path("study/accnum/{ien}")
	@Produces(MediaType.APPLICATION_XML)
	public RestStringType getStudyAccnum(@PathParam("ien") String ien,
			@HeaderParam("scpauth") String authString) {	
		
		return (isUserAuthenticated(authString) ? new RestStringType(DicomService.getStudyAccessionNumber(ien))
												: new RestStringType(ERROR_MSG));
	}

	@GET
	@Path("study/accnum/{siteId}/{ien}")
	@Produces(MediaType.APPLICATION_XML)
	public RestStringType getStudyAccnum(@PathParam("siteId") String siteId,
			@PathParam("ien") String ien,
			@HeaderParam("scpauth") String authString) {	
		return (isUserAuthenticated(authString) ? new RestStringType(DicomService.getRemoteAccessionNumber(siteId, ien))
												: new RestStringType(ERROR_MSG));
	}

	@GET
	@Path("study/icn/{ien}")
	@Produces(MediaType.APPLICATION_XML)
	public RestStringType getStudyIcn(@PathParam("ien") String ien,
			@HeaderParam("scpauth") String authString) {	

		return (isUserAuthenticated(authString) ? new RestStringType(DicomService.getStudyIcn(ien))
												: new RestStringType(ERROR_MSG));
	}

	@GET
	@Path("study/icn/{siteId}/{ien}")
	@Produces(MediaType.APPLICATION_XML)
	public RestStringType getStudyIcn(@PathParam("siteId") String siteId,
			@PathParam("ien") String ien,
			@HeaderParam("scpauth") String authString) {	
		
		return (isUserAuthenticated(authString) ? new RestStringType(DicomService.getRemoteIcn(siteId, ien))
												: new RestStringType(ERROR_MSG));
	}
	
	@GET
	@Path("studies/icn/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	public StudiesResultType getPatientStudiesFromIcn(
			@PathParam("patientIcn") String patientIcn)
	throws Exception {
		
		return getPatientStudiesFromIcnWithFilter(patientIcn, "all");
	}

	@GET
	@Path("studies/icn/{patientIcn}/{filterType}")
	@Produces(MediaType.APPLICATION_XML)
	public StudiesResultType getPatientStudiesFromIcnWithFilter(
			@PathParam("patientIcn") String patientIcn,
			@PathParam("filterType") String filterType)
	throws Exception {
		
		PatientCFind patientCFind = QueryFactory.getPatientCFindForWebService(patientIcn, filterType);
		Map<String, List<StudyType>> studiesBySite = patientCFind.getPatientStudies();
		StudiesResultType toReturn = new StudiesResultType();
		StudiesType returnStudiesContainer = new StudiesType();
		List<StudyType> allStudies = new ArrayList<>();
		
		for(Map.Entry<String, List<StudyType>> entry : studiesBySite.entrySet()) {
			allStudies.addAll(entry.getValue());
		}
		
		returnStudiesContainer.setStudies(allStudies.toArray(new StudyType[0]));
		toReturn.setStudies(returnStudiesContainer);
		
		return toReturn;
	}

	@GET
	@Path("dicom/studies/icn/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	public StudiesResultType getDicomStudiesForPatient(
			@PathParam("patientIcn") String patientId,
			@QueryParam("timeOutMillis") long timeOutMillis)
			throws Exception
	{
		PatientCFind patientCFind = QueryFactory.getPatientCFindForWebService(patientId, null);
		Map<String, List<StudyType>> studiesBySite = patientCFind.getPatientStudies();
		StudiesResultType toReturn = new StudiesResultType();
		StudiesType returnStudiesContainer = new StudiesType();
		List<StudyType> allStudies = new ArrayList<>();
		for(Map.Entry<String, List<StudyType>> entry : studiesBySite.entrySet()){
			allStudies.addAll(entry.getValue());
		}
		returnStudiesContainer.setStudies(allStudies.toArray(new StudyType[0]));
		toReturn.setStudies(returnStudiesContainer);
		return toReturn;
	}

	// get a patient's info and MTF list
	@GET
	@Path("patient/tfl/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	public RestStringType getPatientTFL(
			@PathParam("patientIcn") String patientIcn,
			@HeaderParam("scpauth") String authString)
	{
		try{
			if (isUserAuthenticated(authString)) {
				PatientCFind query = QueryFactory.getPatientCFindForWebService(patientIcn, "all");
				logger.info("WebService TFL query is " + query);
				return new DicomService().getPatientTFL(query);
			}else
				return new RestStringType("PassPhrase wrong. Cannot run. Please provide correct PassPhrase.");
		}catch (Exception e){
			return new RestStringType(e.getMessage());
		}
	}

	// get a patient's info and MTF list
	@GET
	@Path("patient/mtf/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	public PatVistaInfo getPatientMTF(
			@PathParam("patientIcn") String patientIcn)
	{
		try{

			PatientCFind query = QueryFactory.getPatientCFindForWebService(patientIcn, "all");
			logger.info("WebService TFL query is " + query);
			if(query == null) return new PatVistaInfo(new PatientInfo());
			PatientInfo patientInfo = new DicomService().getPatientTFL(query, false);
			PatVistaInfo pvi = new PatVistaInfo(patientInfo);
			logger.info("WebService TFL returning {}", pvi.toString());
			return pvi;
		}catch (Exception e){
			logger.error("Failed to get TFL with exception", e);
			return new PatVistaInfo(new PatientInfo());
		}
	}

	// reset a patient's all cached info (study and series metadata and images)
	@GET
	@Path("patient/resetcache/{patientIcn}")
	@Produces(MediaType.APPLICATION_XML)
	public RestStringType getPatientReset(
			@PathParam("patientIcn") String patientIcn,
			@HeaderParam("scpauth") String authString)
	{
		try{
			if (isUserAuthenticated(authString)) {
				PatientCFind query = QueryFactory.getPatientCFindForWebService(patientIcn, "all");
				return new DicomService().resetCache(query);
			}
			else
				return new RestStringType("PassPhrase wrong. Cannot run. Please provide correct PassPhrase.");
		}catch(Exception e){
			return new RestStringType(e.getMessage());
		}
	}
	
	@GET
	@Path("scp/refresh")
	@Produces(MediaType.APPLICATION_XML)
	public RestStringType scpRefresh(@HeaderParam("scpauth") String authString)
	{	
		if (authString == null || !isUserAuthenticated(authString)) return new RestStringType("Not Authorized");

		return DicomService.refresh();
	}
	
    private boolean isUserAuthenticated(String authString) {
    	
    	String code = null;
    	
    	try {
    		code = scpAuthString;
    	} catch (Exception e) {
    		logger.error("This should never happen! Decode error: " + e.getMessage());
    	}
    	
    	return (authString != null && authString.equalsIgnoreCase(code));
    }

}