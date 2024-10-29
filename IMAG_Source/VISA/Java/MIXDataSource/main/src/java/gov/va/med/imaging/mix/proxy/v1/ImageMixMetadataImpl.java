/**
 * ImageMixMetadataImpl.java
 *
 * for MIX metadata service (a CVIX only service) the client interface is placed here
 * and implemented locally
 * 
 * @author vacotittoc
 */
package gov.va.med.imaging.mix.proxy.v1;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.ecia.scu.configuration.EciaDicomConfiguration;
import gov.va.med.imaging.dicom.ecia.scu.dto.StudyDTO;
import gov.va.med.imaging.dicom.ecia.scu.find.EciaFindSCU;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.mix.rest.proxy.AbstractMixRestImageProxy;
import gov.va.med.imaging.mix.rest.proxy.MixRestGetClient;
import gov.va.med.imaging.mix.rest.proxy.MixRestGetClientInThread;
import gov.va.med.imaging.mix.translator.MixJSONConverter;
import gov.va.med.imaging.mix.webservices.rest.endpoints.MixDiagnosticReportRestUri;
import gov.va.med.imaging.mix.webservices.rest.endpoints.MixImagingStudyRestUri;
import gov.va.med.imaging.mix.webservices.rest.endpoints.MixRestUri;
// import gov.va.med.SERIALIZATION_FORMAT;
// import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
// import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
// import gov.va.med.imaging.mix.webservices.fhir.types.v1.RequestorTypePurposeOfUse;
import gov.va.med.imaging.mix.webservices.rest.exceptions.MIXDiagnosticReportException;
import gov.va.med.imaging.mix.webservices.rest.exceptions.MIXImagingStudyException;
import gov.va.med.imaging.mix.webservices.rest.exceptions.MIXMetadataException;
import gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType;
import gov.va.med.imaging.mix.webservices.rest.v1.ImageMetadata;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.url.mix.configuration.EciaDicomSiteConfiguration;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
// import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import javax.ws.rs.core.MediaType;

// import java.text.ParseException;
import org.apache.commons.httpclient.methods.GetMethod;


public class ImageMixMetadataImpl
extends AbstractMixRestImageProxy
implements ImageMetadata
{
	private static String defaultFromDate = "1900-01-01";
				
	private String mixNode;
	private RequestorType requestor;
	private FilterType filter;
	private String patientId;
	private Boolean fullStudylist;
	private String transactionId;
	private Integer failedStudyCount;
	private Integer addedStudyCount;
	private Integer studyCounter;
	private Integer numStudies=0;
	
	private ReportStudyListResponseType reportStudyListResponse=null;

	private List<String> studyUIDList = new ArrayList<String>();
	private final HashMap<String, StudyType> studyTypeCache = 
			new HashMap<String, StudyType>();
	
	private int defaultMetadataMaxConcurrentThreads = 10;
	
	public int getDefaultMetadataMaxConcurrentThreads()	{
		int maxThreads = defaultMetadataMaxConcurrentThreads;

		if ((mixConfiguration != null) && (mixConfiguration.getMaxConcurentThreads()!=0))
		{
			maxThreads = mixConfiguration.getMaxConcurentThreads();
		}

		return maxThreads;
	}

	private int defaultConcurentQueryTimeoutMs = 5000; // pessimistic!

	public int getConcurentQueryTimeout()	{
		int timeoutMs = defaultConcurentQueryTimeoutMs;

		if ((mixConfiguration != null) && (mixConfiguration.getMaxConcurentThreads()!=0))
		{
			timeoutMs = mixConfiguration.getMetadataConcurentQueryTimeout();
		}

		return timeoutMs;
	}

	public ImageMixMetadataImpl (ProxyServices proxyServices, MIXConfiguration mixConfiguration) {
		super(proxyServices, mixConfiguration);
	}

	@Override
	protected ProxyServiceType getProxyServiceType() {
		return ProxyServiceType.metadata;
	}
	
	@Override
	protected String getDataSourceVersion() {
		return "1";
	}
	
	@Override
	protected String getRestServicePath() {
		// Note, mix service path is the same for all MIX services
		return MixRestUri.mixRestUriV1;
	}

	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) {
		// no Image access here, nothing to do...
	}

	@Override
	protected ProxyServiceType getInstanceRequestProxyServiceType() {
		return ProxyServiceType.image;
	}

	@Override
	protected ProxyServiceType getTextFileRequestProxyServiceType() {
		// unused method in MIX world
		return ProxyServiceType.text;
	}
	
	/**
	 * Make MIX FHIR client calls to collect Study Graphs (including reports) for given patient within date range; with limited timeout
	 *  level 1 query: DiagnosticReport array returns shallow study list with UIDs
	 *  level 2 query(ies): returns Study graph details for each study (in concurrent calls loop, if there are more than 1 studies).
	 * @param datasource the target MIX server (DAS, etc.) gateway: 200 - default
	 * @param reqtor requesting entity (Name, SSN, site)
	 * @param filtr from/to date, study id
	 * @param patId ICN
	 * @param transactId for transaction logging
	 * @return ReportStudyListResponseType have status, error info and study graphs (including report)
	 * @throws MIXMetadataException
	 */
	// timeout is ~45 seconds from MIXConfig (default is 60) for DR and another 4 seconds per max studies bundle (concurrently called from threads)
	public ReportStudyListResponseType getPatientReportStudyList(String datasource, RequestorType reqtor,
			FilterType filtr, String patId, Boolean fullTree, String transactId, String requestedSite) // requestedSite is ignored, it is 200, the datasource
			throws MIXMetadataException
	{
		
		if ((datasource==null) || (datasource.isEmpty()) ||
			(filtr==null) ||
			(transactId == null) ||(transactId.isEmpty()) ||
			(patId == null) || (patId.isEmpty())) {
			throw new MIXMetadataException("MIXClient getPatientReportStudyList: Invalid or null input parameter(s)!");
		}
		this.mixNode = datasource;
		this.requestor = reqtor;
		this.filter = filtr;
		this.patientId = patId;
		this.fullStudylist = fullTree;
		this.transactionId = transactId;
		// requestedSite is ignored, it is the datasource (200)
		
		try { 
			// get the Patient's study shallow list with reports (JSON-> DiagnosticReport) in local variable
			getPatientReportsAndShallowStudyList();
		} 
		catch (MIXDiagnosticReportException mdre) {
			// ***
			logger.error("getPatientReportStudyList() --> ", mdre);
			throw new MIXMetadataException("MIXClient getPatientReportStudyList: Failed to get reports with shallow study list!");
		}
		
		// exit on empty list or if no full tree needed
		if ((reportStudyListResponse==null) || (reportStudyListResponse.getStudies().length == 0) || !fullTree) {
			return reportStudyListResponse;
		}

		reportStudyListResponse.setPartialResponse(true);

		// COLLECT study graphs for each study (JSON-> ImagingSudy-s of DiagnosticReport)

		//   1. get list of study UIDs and fill studyTypeCache with nulls
		for (StudyType study : reportStudyListResponse.getStudies()) {
			studyUIDList.add(study.getDicomUid());
			studyTypeCache.put(study.getDicomUid(), null);
		}
		numStudies = studyUIDList.size();
		failedStudyCount = 0;
		addedStudyCount = 0;

		//   2. loop through all studies in maxConcurrentThreads-chunk steps and issue/wait for queries
		studyCounter = 0;
		while (studyCounter < numStudies) {
			List<String> nextUIDListChunk = getNextChunk();
//			if(logger.isDebugEnabled()){logger.debug("MIXClient getPatientFullStudyList starts requesting StudyGraph(s) for UIDs: " + nextUIDListChunk.toString());}
			List<StudyType> studyTypeListResults = getStudyGraphs(nextUIDListChunk);
			for(StudyType studyType : studyTypeListResults) {
				if (studyType != null) {
					studyTypeCache.replace(studyType.getDicomUid(), studyType);
				}
			}
		}

		//   3. call reportStudyListResponse.setStudies(..,..) for each non-null results in studyTypeCache
		for (StudyType study : reportStudyListResponse.getStudies()) {
			StudyType studyType = studyTypeCache.get(study.getDicomUid());
			if (studyType == null) {
				failedStudyCount++;
			} else {
				// make sure the report there is kept!
				studyType.setReportContent(study.getReportContent());
				// add studyType into reportStudyListResponse 
				reportStudyListResponse.setStudies(addedStudyCount, studyType);
				addedStudyCount++;
			}
		}	
		
		if (failedStudyCount == 0)
			reportStudyListResponse.setPartialResponse(false);
		if ((reportStudyListResponse != null) && (reportStudyListResponse.getStudies() != null)) {
			if(logger.isDebugEnabled()){
                logger.debug("MIXClient 1st studyId is '{}' after getPatientFullStudyList.", reportStudyListResponse.getStudies(0).getStudyId());}
		}
	
		return reportStudyListResponse;
	}
	// chunking support - moves range(window of maxConcurrentThreads) through list
	private List<String> getNextChunk() {
		List<String> uidListChunk = new ArrayList<String>();
		int rangeBegin = studyCounter;
		int rangeEnd;
		if ((numStudies - studyCounter) >= getDefaultMetadataMaxConcurrentThreads()) {
			// stage next full chunk of UIDs
			rangeEnd = rangeBegin + getDefaultMetadataMaxConcurrentThreads() - 1;
		} else {
			// stage last chunk of UIDs
			rangeEnd = numStudies - 1;
		}
		// fill UID list chunk

		for (int j=rangeBegin; j<=rangeEnd; j++) {
			uidListChunk.add(studyUIDList.get(j));
		}
		studyCounter = rangeEnd+1;
		
		return uidListChunk;
	}
	
	// <<< concurrent threading >>>
	private CountDownLatch countdownLatch;
	private static int threadCount = 0;
	
	private synchronized static int getNextThreadId()
	{
		if(threadCount >= Integer.MAX_VALUE)
		{
			threadCount = 0;
		}
		else
		{
			threadCount += 1;
		}
		return threadCount;
	}
	
	public List<StudyType> getStudyGraphs(List<String> StudyUIDs)
	{
		countdownLatch = new CountDownLatch(StudyUIDs.size());
		final List<StudyType> result = new ArrayList<StudyType>();
		for(String studyUID : StudyUIDs)
		{
			final String stdUID = studyUID;
			Thread t = new Thread("StudyGraphArray-" + getNextThreadId())
			{

				@Override
				public void run()
				{
					try {
						result.add(getPatientFullStudyList(stdUID));
					} catch (MIXImagingStudyException mise) {
						// ignore
					}
					if(countdownLatch != null)
						countdownLatch.countDown();
				}				
			};
			t.start();
		}
		
		try
		{
			countdownLatch.await(getConcurentQueryTimeout(), TimeUnit.MILLISECONDS);		
		}
		catch(InterruptedException iX)
		{
            logger.error("InterruptedException waiting for StudyGraph, {}", iX.getMessage(), iX);
		}
		long remaining = countdownLatch.getCount();
		countdownLatch = null;
        logger.info("Completed processing '{}' study graphs, got '{}' results. '{}' did not complete in time", StudyUIDs.size(), result.size(), remaining);
		return result;
	}


	// fills reports and shallow study list only
	private void getPatientReportsAndShallowStudyList()
			throws MIXDiagnosticReportException
	{
		// ConnectionException & MethodException
        getLogger().info("MIXClient getPatientReportsAndShallowStudyList, Transaction [{}] initiated, patient '{}'.", transactionId, patientId); // + routingToken.toRoutingTokenString() + "'.");
		setDataSourceMethodAndVersion("getPatientReportsAndShallowStudyList");

		String fromDate = defaultFromDate;
		if ((filter != null) && (filter.getFromDate() != null) && !filter.getFromDate().isEmpty())
			fromDate = filter.getFromDate(); // make sure of yyyy-MM-dd format

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.US);
		Date d = new Date();
		String toDate = sdf.format(d);
		if ((filter != null) && (filter.getToDate() != null) && !filter.getToDate().isEmpty())
			toDate = filter.getToDate(); // make sure of yyyy-MM-dd format
		
		// compose URL to client
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		// urlParameterKeyValues.put("{routingToken}", routingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{patientIcn}", patientId);
		urlParameterKeyValues.put("{fromDate}", fromDate);
		urlParameterKeyValues.put("{toDate}", toDate);
		String url="";
		try {
			url = getWebResourceUrl(MixDiagnosticReportRestUri.reportStudyListPath, urlParameterKeyValues); 
		}
		catch (ConnectionException ce) {
			logger.error("getPatientReportsAndShallowStudyList() --> ", ce);
			throw new MIXDiagnosticReportException("MIXClient getPatientReportsAndShallowStudyList: Failed to connect to/compose URL source!" + ce.getMessage());
		}
		
		// request to Client and translate (json) response
		MixRestGetClient getClient = new MixRestGetClient(url, MediaType.APPLICATION_JSON_TYPE, mixConfiguration);
		String jsonResponse="";
		try{
			jsonResponse = getClient.executeRequest(String.class);
		}
		catch (ConnectionException ce) {
			logger.error("getPatientReportsAndShallowStudyList() --> ", ce);
			throw new MIXDiagnosticReportException("MIXClient getPatientReportsAndShallowStudyList: Failed to connect to Resource!");
		}
		catch (MethodException me) {
			logger.error("getPatientReportsAndShallowStudyList() --> ", me);
			throw new MIXDiagnosticReportException("MIXClient getPatientReportsAndShallowStudyList: Error getting Resource response!" + me.getMessage());
		}
		boolean nullResponse = (jsonResponse == null) || jsonResponse.isEmpty();
		boolean emptyResponse = false;
		if (!nullResponse) {
            getLogger().debug("MIXClient getPatientReportsAndShallowStudyList, Transaction [{}] received json response >>>{}<<<.", transactionId, jsonResponse);
			if (jsonResponse.equals("[]")) {
				// substitute [] with {}
				// jsonResponse= "{}";
				emptyResponse=true;
			} 
			else if (jsonResponse.startsWith("[")) {
				// prefix the first "[" with "{"DRs":" and append a "}" on the end
				String jsonDRsArray = "{\"DRs\":";
				jsonResponse = jsonDRsArray.concat(jsonResponse);
				jsonResponse = jsonResponse.concat("}");
			}
		}
        getLogger().info("MIXClient getPatientReportsAndShallowStudyList, Transaction [{}] final json response >>>{}<<<.", transactionId, nullResponse ? "null" : "" + jsonResponse);
		ReportStudyListResponseType result=null;
		if (!emptyResponse) {
			result = MixJSONConverter.ConvertDiagnosticReportToJava(jsonResponse, this.patientId);
		}
		boolean emptyResult = (result == null) || (result.getStudies().length==0);
        getLogger().info("MIXClient getPatientReportsAndShallowStudyList, Transaction [{}] returned translated response of [{}] studies in reportStudyListResponse business object.", transactionId, emptyResult ? 0 : result.getStudies().length);
		reportStudyListResponse = result;
	}


	// fills study graph for given study
	private StudyType getPatientFullStudyList(String studyUID)
			throws MIXImagingStudyException
	{
		// ConnectionException & MethodException
        getLogger().info("MIXClient getPatientFullStudyList, Transaction [{}] initiated, study '{}'.", transactionId, studyUID); // + routingToken.toRoutingTokenString() + "'.");
		setDataSourceMethodAndVersion("getPatientFullStudyList");

		// compose URL to client
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		// urlParameterKeyValues.put("{routingToken}", routingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{studyUid}", studyUID);
		String url="";
		try {
			url = getWebResourceUrl(MixImagingStudyRestUri.studyListPath, urlParameterKeyValues); 
		}
		catch (ConnectionException ce) {
			throw new MIXImagingStudyException("MIXClient getPatientFullStudyList: Failed to connect to/compose URL source!" + ce.getMessage());
		}
		
		// request to Client and translate (json) response
		MixRestGetClientInThread getClient = new MixRestGetClientInThread(url, MediaType.APPLICATION_JSON_TYPE, mixConfiguration);
		String jsonResponse="";
		try{
			jsonResponse = getClient.executeRequest(String.class);
		}
		catch (ConnectionException ce) {
			throw new MIXImagingStudyException("MIXClient getPatientFullStudyList: Failed to connect to Client!");
		}
		catch (MethodException me) {
			throw new MIXImagingStudyException("MIXClient getPatientFullStudyList: Error/Timeout getting Client response!" + me.getMessage());
		}
        getLogger().info("MIXClient getPatientFullStudyList, Transaction [{}] returned [{}] JSON response on Study UID={}", transactionId, ((jsonResponse == null) || jsonResponse.isEmpty()) ? "null" : "not null", studyUID);
		StudyType result = MixJSONConverter.ConvertImagingStudyToJava(jsonResponse, this.patientId, mixConfiguration.getEmptyStudyModalities());
        getLogger().info("MIXClient getPatientFullStudyList, Transaction [{}] returned translated response of [{}] reportStudyListResponse business object on Study UID={}", transactionId, result == null ? "null" : "not null", studyUID);
        return result;
	}
	
	public ReportType getPatientReport(String datasource, RequestorType reqtor, String patId,  String studyId, String transactId) throws MIXMetadataException {
        logger.info("getPatientReport() --> switch to ECIA = {}", mixConfiguration.useEcia());
		if (mixConfiguration.useEcia()) {
			return getPatientReportFromECIA(patId, studyId);
		} else {
			return getPatientReportFromMIX(datasource, reqtor, patId, studyId, transactId);
		}
	}
	
	/**
	 * Returns patient report information from an ECIA (DoD) source given a patient identifier and study identifier
	 * 
	 * @param patientId The patient identifier to use for querying for patient report information
	 * @param studyId The study identifier to use for querying for a specific study
	 * @return A ReportType containing the report text and some details
	 * @throws MIXMetadataException In the event of any exceptions
	 */
	public ReportType getPatientReportFromECIA(String patientId, String studyId) throws MIXMetadataException {
		if(logger.isDebugEnabled()){
            logger.debug("getPatientReportFromECIA() --> Querying with patientId [{}] and studyId [{}]", patientId, studyId);}
		
		// Initialize the ECIA query class
		EciaFindSCU eciaFindScu;
		try {
			if(logger.isDebugEnabled()){logger.debug("getPatientReportFromECIA() --> Initializing ECIAFindSCU");}
			EciaDicomSiteConfiguration eciaSiteConfig = (EciaDicomSiteConfiguration) this.mixConfiguration.getSiteConfiguration(MIXConfiguration.DEFAULT_ECIA_DICOM_SITE, MIXConfiguration.DEFAULT_ECIA_DICOM_SITE);			
			eciaFindScu = new EciaFindSCU(new EciaDicomConfiguration(eciaSiteConfig.getHost(), eciaSiteConfig.getPort(), eciaSiteConfig.getCallingAE(), eciaSiteConfig.getCalledAE(), eciaSiteConfig.getConnectTimeOut(), eciaSiteConfig.getCfindRspTimeOut()));
		} catch (Exception e) {
			throw new MIXMetadataException("Error retrieiving ECIA configuration", e);
		}
		
		// Query for the study
		List<StudyDTO> studyDTOResults;
		try {
			if(logger.isDebugEnabled()){logger.debug("getPatientReportFromECIA() --> -NOT- Getting study by study id");}
			studyDTOResults = eciaFindScu.getStudyByStudyUID(studyId, null, this.mixConfiguration);
		} catch (Exception e) {
			throw new MIXMetadataException("Error querying for study", e);
		}
		
		ReportType reportType = null;
		if ((studyDTOResults != null) && (studyDTOResults.size() != 0)) {
			StudyDTO studyDTO = studyDTOResults.get(0);
			
			// Build and return the report type
			reportType = new ReportType();
			
			// Get report text, patient name, and study description
			String radReport = studyDTO.getReportTextValue();
			String patientName = studyDTO.getPatientName();
			String studyDescription = studyDTO.getStudyDescription();
			
			// Replace carets in the contents
			radReport = (radReport == null) ? ("No report is available") : (radReport.replaceAll("\\^", ","));
			patientName = (patientName == null) ? ("") : (patientName.replaceAll("\\^", ","));
			studyDescription = (studyDescription == null) ? ("") : (studyDescription.replaceAll("\\^", ","));
			
			if(logger.isDebugEnabled()){
                logger.debug("getPatientReportFromECIA() --> Returning radReport value of [{}]", radReport);}
			
			// Update report contents
			reportType.setRadiologyReport("1^" + patientName + "^" + studyDescription + "\n" + radReport);

			// Update the other values
			reportType.setPatientId(patientId);
			reportType.setStudyId(studyId);
			reportType.setSiteNumber(mixNode); // 200
			reportType.setSiteName("DOD");
			reportType.setSiteAbbreviation("DOD");
			reportType.setProcedureDate(studyDTO.getProcedureCreationDate());

		}
		
		return reportType;
	}
	
	/**
	 * Make MIX client call(s) to collect one Study Report with limited timeout
	 * @param datasource the target MIX server (DAS, etc.) gateway: 200 - default
	 * @param reqtor requesting entity (Name, SSN, site)
	 * @param patientId ICN
	 * @param transactionId for transaction logging
	 * @param studyId opaque, unique study identifier (preferably Study UID)
	 * @return ReportType including the report or null if not found
	 * @throws MIXMetadataException
	 */
	// TODO: limit timeout to 30-45 second!?
	public 	ReportType getPatientReportFromMIX(String datasource, RequestorType reqtor, String patId,  String studyId, String transactId) // DICOM Study UID expected, not studyUrn.toString(SERIALIZATION_FORMAT.NATIVE)!
			throws MIXMetadataException {
		
		ReportType reportType=null;
		
		if(logger.isDebugEnabled()){
            logger.debug("getPatientReport() --> datasource == null --> [{}]; datasource.isEmpty() --> [{}]", datasource == null, datasource.isEmpty());
            logger.debug("getPatientReport() --> transactId == null --> [{}]; transactId.isEmpty() --> [{}]", transactId == null, transactId.isEmpty());
            logger.debug("getPatientReport() --> studyId == null --> [{}]; studyId.isEmpty() --> [{}]", studyId == null, studyId.isEmpty());
            logger.debug("getPatientReport() --> patId == null --> [{}]", patId == null);
		}
		patId = "1606681433";
		if(logger.isDebugEnabled()){
            logger.debug("getPatientReport() --> hardcoded patId to --> [{}]", patId);}
		
		
		patId = "1606681433";
		
		if ((datasource==null) || (datasource.isEmpty()) ||
				(transactId == null) ||(transactId.isEmpty()) ||
				(studyId == null) ||(studyId.isEmpty()) ||
				(patId == null) || (patId.isEmpty())) {
				throw new MIXMetadataException("MIXClient getPatientReport: Invalid or null input parameter(s)!");
		}
		this.mixNode = datasource;
		this.requestor = reqtor;
		this.patientId = patId;	
		this.transactionId = transactId;

		if (reportStudyListResponse==null) {
			// request entire report/shallow study list for patient (filter is null)
			try {
				
				FilterType filtr = new FilterType();
				filtr.setStudyId(studyId);
				if(logger.isDebugEnabled()){
                    logger.debug("getPatientReport() --> FilterType object created and set studyId to --> [{}]", filtr.getStudyId());}
				if(logger.isDebugEnabled()){logger.debug("getPatientReport() --> Pass in FilterType object instead of null............");}
				
				reportStudyListResponse = getPatientReportStudyList(datasource, reqtor, filtr, patId, false, transactId, mixNode);
				//reportStudyListResponse = getPatientReportStudyList(datasource, reqtor, null, patId, false, transactId, mixNode);
			} 
			catch (MIXMetadataException mmde) {
				logger.error("getPatientReport() --> ", mmde);
				throw new MIXMetadataException("MIXClient getPatientReport: Failed getting Reports/Shallow study list.");
			}
		}

		// get report from local reportStudyListResponse structure using studyId
		for (StudyType study : reportStudyListResponse.getStudies()) {
			if (study.getDicomUid().equals(studyId) || study.getStudyId().equals(studyId)) {
				reportType = new ReportType();
				reportType.setRadiologyReport(study.getReportContent());
				reportType.setPatientId(patId);
				reportType.setStudyId(studyId);
				reportType.setSiteNumber(mixNode); // 200
				reportType.setSiteName("DOD");
				reportType.setSiteAbbreviation("DOD");
				reportType.setProcedureDate(study.getProcedureDate()); // *** check/fix format translate!
			}
		}
		return reportType;
	}

}
