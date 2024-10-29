/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Nov 14, 2016
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vacotittoc
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
package gov.va.med.imaging.mix.proxy.v1;

import gov.va.med.imaging.conversion.IdConversion;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.mix.webservices.rest.exceptions.MIXMetadataException;
import gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorTypePurposeOfUse;
import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslatorV1;
import gov.va.med.imaging.mixdatasource.MixDataSourceProvider;

import com.sun.jersey.client.apache.ApacheHttpClient;

import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;
import gov.va.med.imaging.url.mix.configuration.EciaDicomSiteConfiguration;
import gov.va.med.imaging.url.mix.exceptions.MIXConfigurationException;

/* Quoc added */


import gov.va.med.imaging.dicom.ecia.scu.find.EciaFindSCU;
import gov.va.med.imaging.dicom.ecia.scu.configuration.EciaDicomConfiguration;
import gov.va.med.imaging.dicom.ecia.scu.dto.StudyDTO;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Date;
import java.util.List;

/**
 * @author vacotittoc
 *
 */
public class ImageMixStudyProxyV1
extends ImageMixProxyV1
{
	private final Site site;
	
	public ImageMixStudyProxyV1(ProxyServices proxyServices, Site site, MIXConfiguration mixConfiguration)
	{
		super(proxyServices, mixConfiguration);
		this.site = site;
	}
	
	/**
	 * Old entry point into this flow.
	 * Made it private and changed its name so the new version of it would be in effect.
	 * 
	 * @param String				patient ICN to query for
	 * @param StudyFilter			query criteria
	 * @param StudyLoadLevel		query level in DICOM and types of data
	 * @return StudySetResult		query result
	 * @throws MethodException		required exception
	 * @throws ConnectionException	required exception
	 * 
	 */
	private StudySetResult getPatientStudiesFromMIX(String patientIcn,
			StudyFilter filter, StudyLoadLevel studyLoadLevel)
					throws MethodException, ConnectionException	{

        logger.info("ImageMixStudyProxyV1.getPatientStudiesFromMIX() --> Getting studies for given ICN [{}]", patientIcn);

		TransactionContext transactionContext = TransactionContextFactory.get();
		
		String transactionId = transactionContext.getTransactionId();

        logger.info("ImageMixStudyProxyV1.getPatientStudiesFromMIX() -->  Transaction [{}] initiated ", transactionId);
		
		ImageMixMetadataImpl imageMetadata = new ImageMixMetadataImpl(proxyServices, MixDataSourceProvider.getMixConfiguration());
		
		// if the metadata connection parameters are not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		// *** setMetadataCredentials(imageMetadata);
		
		// JMW 8/13/08 - set the connection socket timeout to 30 seconds (default of 600 seconds)
		// CPT 11/14/16 - take care of this inside MIX call
		// ((org.apache.axis.client.Stub)imageMetadata).setTimeout(mixConfiguration.getMetadataTimeout());
		RequestorType rt = 
				new RequestorType(
						transactionContext.getFullName(), 
						transactionContext.getSsn(), 
						transactionContext.getSiteNumber(), 
						transactionContext.getSiteName(), 
				RequestorTypePurposeOfUse.value1);
		
		FilterType ft = MixTranslatorV1.translate(filter);
		
		String datasource = defaultDatasource;
		ReportStudyListResponseType reportStudyListResponse = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		
		try	{
			// make MIX client calls to build MIX Pass 1 (metadata) response
			//       1. to get the Patient's study shallow list with reports using filters, (JSON-> DiagnosticReport)
			//       2. then to collect study graphs for each study (JSON-> ImagingSudy-s of DiagnosticReport)

			Thread.currentThread().setContextClassLoader(ApacheHttpClient.class.getClassLoader());
			reportStudyListResponse = imageMetadata.getPatientReportStudyList(   
					datasource, 
					rt, 
					ft, 
					patientIcn, 
					true, // fullTree with study list would be nice; from 200, only shallow study list comes back
					transactionContext.getTransactionId(),
					defaultDatasource
			);
		} catch(MIXMetadataException rX) {
			logger.error("ImageMixStudyProxyV1.getPatientStudiesFromMIX() --> Exception was thrown ", rX);
			throw new ConnectionException(rX);
		} finally {
			Thread.currentThread().setContextClassLoader(loader);
		}
		
		if (reportStudyListResponse == null) {
            logger.info("ImageMixStudyProxyV1.getPatientStudiesFromMIX() --> Transaction [{}] received null study list response", transactionId);
		} else { // there is response content
			if (reportStudyListResponse.getStudies() == null) {
				if(logger.isDebugEnabled()){
                    logger.debug("ImageMixStudyProxyV1.getPatientStudiesFromMIX() --> Transaction [{}] received NO studies", transactionId);}
			} else {
				if(logger.isDebugEnabled()){
                    logger.debug("ImageMixStudyProxyV1.getPatientStudiesFromMIX() --> Transaction [{}] received [{}] study(ies)", transactionId, reportStudyListResponse.getStudies().length);}
				gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType[] studies = reportStudyListResponse.getStudies();
				if(logger.isDebugEnabled()){
                    logger.debug("ImageMixStudyProxyV1.getPatientStudiesFromMIX() --> StudyType first study Id [{}]", studies[0].getStudyId());}
			}
		}
		
		StudySetResult result = MixTranslatorV1.translate(reportStudyListResponse, site, filter, mixConfiguration.getEmptyStudyModalities());
        logger.info("ImageMixStudyProxyV1.getPatientStudiesFromMIX() --> StudySetResult translation summary: {}", result == null ? "null" : result.toString(true));
		
		transactionContext.addDebugInformation("ImageMixStudyProxyV1.getPatientStudiesFromMIX() --> StudySetResult --> " + (result == null ? "null" : result.toString(true)));
		
		return result;
	}
	
	// 	Quoc added all the below for switching between MIX and ECIA data source

	/**
	 * New entry point to this flow to accommodate switching between MIX and ECIA data source
	 * 
	 * @param String				patient ICN to query for
	 * @param StudyFilter			query criteria
	 * @param StudyLoadLevel		query level in DICOM and types of data
	 * @return StudySetResult		query result
	 * @throws MethodException		required exception
	 * @throws ConnectionException	required exception
	 * 
	 */
	public StudySetResult getPatientStudies(String patientIcn,
			StudyFilter filter, StudyLoadLevel studyLoadLevel) throws MethodException, ConnectionException {
		
		// mixConfiguration object is in parent class.
		boolean useEica = this.mixConfiguration == null ? MIXConfiguration.DEFAULT_USE_ECIA : this.mixConfiguration.useEcia();

        logger.info("ImageMixStudyProxyV1.getPatientStudies() --> switch to ECIA = {}", useEica);
		
		return (useEica ? getPatientStudiesFromECIA(patientIcn, filter) : getPatientStudiesFromMIX(patientIcn, filter, studyLoadLevel));		
	}

	/**
	 * Query ECIA for studies by patient and study identifier as needed
	 * 
	 * @param String			patient id, if present, to query for
	 * @param StudyFilter		filter for the query.  May be used to retrieve study Id
	 * @return StudySetResult	result(s) if any
	 * @throws MethodException 	required exception
	 * 
	 */
	private StudySetResult getPatientStudiesFromECIA(String patientId, StudyFilter filter) throws MethodException {

        logger.info("ImageMixStudyProxyV1.getPatientStudiesFromECIA() --> Getting study(ies) for patient Id [{}] and filter [{}]", patientId, filter);
		
		// Reject if no patient identifier is provided
		if ((patientId == null || patientId.equals("")) && (filter.getStudyId() == null)) {
			throw new IllegalArgumentException("ImageMixStudyProxyV1.getPatientStudiesFromECIA() --> Patient id or study Id is required and should not be empty.");
		}
		
		try {
			// Initialize EciaFindSCU
			EciaFindSCU eciaFindScu = new EciaFindSCU(getEciaDicomConfiguration());
					
			// Get the given date range if present
			String dateRange = getQueryDateRange(filter);
			
			// Check to see if a study ID is provided. If so, query by study id.  Otherwise, query by patient (ICN) Id
			List<StudyDTO> eciaResults = (filter.getStudyId() == null) ? (queryECIAByPatientId(patientId, eciaFindScu, dateRange)) : (queryECIAByStudyUID(filter, eciaFindScu, dateRange));
			
			// No data from ECIA.  Return null right away = no need to translate null to get null.
			if (eciaResults == null || eciaResults.isEmpty()) {
				if(logger.isDebugEnabled()){logger.debug("ImageMixStudyProxyV1.getPatientStudiesFromECIA() -->  No data from ECIA. Return null.");}
				return null;
			}
				
			// Skip this section if query by study instance UID, the second query (expected only one result).
			// Only do this if query by patient Id, the first query.
			// QN: added the second condition to query for more data for Clinical Display ONLY.
			
			// For testing only:
			//if(logger.isDebugEnabled()){logger.debug("ImageMixStudyProxyV1.getPatientStudiesFromECIA() --> setting origin to for testing  --> " + MIXConfiguration.VIEWER_CLINICAL_DISPLAY);}
			//filter.setOrigin(MIXConfiguration.VIEWER_CLINICAL_DISPLAY);
			
			if(filter.getStudyId() == null && filter.getOrigin().equalsIgnoreCase(MIXConfiguration.VIEWER_CLINICAL_DISPLAY)) {
				if(logger.isDebugEnabled()){
                    logger.debug("ImageMixStudyProxyV1.getPatientStudiesFromECIA() --> Getting more data for filter origin {}]", filter.getOrigin());}
				//for(StudyDTO eciaResult :  eciaResults) {  // Can't use this b/c of the need to replace object below
				for(int i = 0; i < eciaResults.size(); ++i) {
					StudyDTO eciaResult = eciaResults.get(i);
					if(eciaResult.getImageCount() == 1) {
						if(logger.isDebugEnabled()){
                            logger.debug("ImageMixStudyProxyV1.getPatientStudiesFromECIA() --> Image count is 1 for study instance UID [{}]. Getting more data...", eciaResult.getStudyInstanceUID());}
						List<StudyDTO> studies = eciaFindScu.getStudyByStudyUID(eciaResult.getStudyInstanceUID(), dateRange, this.mixConfiguration);
						// Expected only one Study.
						if(studies != null) {
							if(logger.isDebugEnabled()){
                                logger.debug("ImageMixStudyProxyV1.getPatientStudiesFromECIA() --> Found more data for study instance UID [{}]. Replacing for previous result...", eciaResult.getStudyInstanceUID());}
							eciaResults.set(i, studies.get(0));
						}
					}
				}
			} else { // For information only. Not really needed.
				if(logger.isDebugEnabled()){
                    logger.debug("ImageMixStudyProxyV1.getPatientStudiesFromECIA() --> NOT getting more data for filter origin [{}]", filter.getOrigin());}
			}
			
			// Do translation
			return getTranslatedResults(filter, eciaResults);
			
		} catch (Exception e) {
			logger.error("ImageMixStudyProxyV1.getPatientStudiesFromECIA() --> Error querying ECIA to retrieve studies", e);
			throw new MethodException("ImageMixStudyProxyV1.getPatientStudiesFromECIA() --> Error querying ECIA to retrieve studies", e);
		}
	}

	/**
	 * Queries ECIA for studies, instances, and images given a study identifier and date range.
	 * 
	 * @param StudyFilter 		patient (ICN) id to query for
	 * @param EciaFindSCU		object to query data source
	 * @param String	 		date range from the filter to apply, if applicable
	 * @return List<StudyDTO>	result(s) if any
	 * @throws MethodException 	required exception
	 * 
	 */
	private List<StudyDTO> queryECIAByStudyUID(StudyFilter filter, EciaFindSCU eciaFindScu, String dateRange) throws MethodException {
		 
		try {
			
			// Get and check study identifier
			String localStudyId = filter.getStudyId().getDocumentUniqueId();
			if (localStudyId == null) {
				if(logger.isDebugEnabled()){logger.debug("ImageMixStudyProxyV1.queryECIAByStudyUID() --> localStudyId (filter.getStudyId().getDocumentUniqueId()) is null. Return null.");}
				return null;
			}
			
			// Update study identifier (might come in as "etcetc:identifier-patientidentifier")
			localStudyId = localStudyId.replaceAll(".*:(.*)-.*", "$1");
			if (localStudyId.contains("-")) {
				localStudyId = localStudyId.substring(0, localStudyId.indexOf("-"));
			}
			
			if(logger.isDebugEnabled()){
                logger.debug("ImageMixStudyProxyV1.queryECIAByStudyUID() --> Updated localStudyId is [{}]", localStudyId);}
		
			// Query to get the found study result
			List<StudyDTO> eciaResults = eciaFindScu.getStudyByStudyUID(localStudyId, dateRange, this.mixConfiguration);
			if (eciaResults == null) {
				if(logger.isDebugEnabled()){
                    logger.debug("ImageMixStudyProxyV1.queryECIAByStudyUID() --> No data from ECIA for study ID [{}]", localStudyId);}
			}
			
			return eciaResults;
			
		} catch (Exception e) {
			logger.error("ImageMixStudyProxyV1.queryECIAByStudyUID() --> Error while querying by study ID", e);
			throw new MethodException("ImageMixStudyProxyV1.queryECIAByStudyUID() --> Error while querying by study ID", e);
		}
	}

	/**
	 * Queries ECIA given a patient (ICN) identifier and returns a shallow list of studies
	 * 
	 * @param String 			patient (ICN) id to query for
	 * @param EciaFindSCU		object to query data source
	 * @param String	 		date range from the filter to apply, if applicable
	 * @return List<StudyDTO>	result(s) if any
	 * @throws MethodException 	required exception
	 * 
	 */
	private List<StudyDTO> queryECIAByPatientId(String patientId, EciaFindSCU eciaFindScu, String dateRange) throws MethodException {
		
		if(logger.isDebugEnabled()){
            logger.debug("ImageMixStudyProxyV1.queryECIAByPatientId() --> Given patient Id [{}]", patientId);}
		
		try {
			// Get patient identifier and verify it could be translated
			String localPatientId = IdConversion.toEdipiByIcn(patientId);
			if (localPatientId == null || localPatientId.equals("")) {
				String msg = "ImageMixStudyProxyV1.queryECIAByPatientId() --> Given patient Id (ICN) [" + patientId + "] couldn't be translated to an EDIPI."; 
				if(logger.isDebugEnabled()){logger.debug(msg);}
				throw new MethodException(msg);
			}
		
			// Run the actual query
			List<StudyDTO> eciaResults = eciaFindScu.getStudyListByPatientId(localPatientId, dateRange);
			
			// Log if the results here are empty (just contextualizing with the patient ID)
			if (eciaResults == null || eciaResults.isEmpty()) {
				if(logger.isDebugEnabled()){
                    logger.debug("ImageMixStudyProxyV1.queryECIAByPatientId() --> No data from ECIA for patient EDIPI [{}]", localPatientId);}
			}
			
			return eciaResults;
			
		} catch (Exception e) {
			if(logger.isDebugEnabled()){logger.debug("ImageMixStudyProxyV1.queryECIAByPatientId() --> Error while querying by patient Id", e);}
			throw new MethodException("ImageMixStudyProxyV1.queryECIAByPatientId() --> Error while querying by patient Id", e);
		}
	}

	/**
	 * Helper method to get results from data source translated.  Optionally applying SOP blacklist filtering.
	 * 
	 * @param StudyFilter 		filter to use as part of translation (also indicates if the translation is minimal)
	 * @param List<StudyDTO> 	result list to translate
	 * @param boolean 			flag to to apply SOP blacklist filtering or not
	 * @return StudySetResult	translated study result set
	 * 
	 */
	private StudySetResult getTranslatedResults(StudyFilter filter, List<StudyDTO> eciaResults)  {

		if ((filter.getOrigin() == null) || (filter.getOrigin().length() == 0)) {
			if(logger.isDebugEnabled()){logger.debug("ImageMixStudyProxyV1.getTranslatedResults() --> provided filter origin is null or empty.  Can't apply SOP blacklist filtering.");}
		} else {
			if(logger.isDebugEnabled()){
                logger.debug("ImageMixStudyProxyV1.getTranslatedResults() --> provided filter origin is [{}].  Applying blacklist...", filter.getOrigin());}
			eciaResults = MixTranslatorV1.applySOPClassUIDBlacklist(eciaResults, mixConfiguration.getSOPBlacklistByName(filter.getOrigin()));
		}			

		return MixTranslatorV1.translate(MixTranslatorV1.translateDTO(eciaResults, site, (filter.getStudyId() == null)), site, filter, mixConfiguration.getEmptyStudyModalities());
	}
	
	
	/**
	 * Helper method to get ECIA DICOM configuration object with values from
	 * ECIA DICOM Site configuration that comes from loading MIXDataSource-1.0.config file
	 * 
	 * @return EciaDicomConfiguration	loaded object
	 * 
	 */
	private EciaDicomConfiguration getEciaDicomConfiguration() throws MIXConfigurationException {
		
		EciaDicomSiteConfiguration eciaSiteConfig = (EciaDicomSiteConfiguration) this.mixConfiguration.getSiteConfiguration(MIXConfiguration.DEFAULT_ECIA_DICOM_SITE, MIXConfiguration.DEFAULT_ECIA_DICOM_SITE);
		
		return new EciaDicomConfiguration(eciaSiteConfig.getHost(), eciaSiteConfig.getPort(), eciaSiteConfig.getCallingAE(), eciaSiteConfig.getCalledAE(), eciaSiteConfig.getConnectTimeOut(), eciaSiteConfig.getCfindRspTimeOut() );
	}
	
	/**
	 * Helper method to get from and to dates into query-ready String
	 * 
	 * @param StudyFilter	object contains from and to dates
	 * @return String		formatted, ready for query String of from and to dates
	 * 
	 */
	private String getQueryDateRange(StudyFilter filter) {
		
		if(logger.isDebugEnabled()){logger.debug("ImageMixStudyProxyV1.getQueryDateRange() --> Getting query date range....");}
		
		// For Fortify and no need to default dates
		Date fromDate = filter.getFromDate();
		Date toDate = filter.getToDate();

		if(fromDate == null && toDate == null) {
			if(logger.isDebugEnabled()){logger.debug("ImageMixStudyProxyV1.getQueryDateRange() --> No dates given in filter object. Return null for date range.");}
			return null;
		}
		
		// fromDate = toDate is a valid use case
		
		if(fromDate.after(toDate)) {
            logger.error("ImageMixStudyProxyV1.getQueryDateRange() --> 'from' date [{}] is after 'to' date [{}]", fromDate, toDate);
			throw new IllegalArgumentException("ImageMixStudyProxyV1.getQueryDateRange() --> 'from' date [" + fromDate + "] is after 'to' date " + toDate + "]");
		}
		
		// Don't want to use the existing DicomDateFormat object --> leave the time component off
		// Don't want to use SimpleDateFormat object more than once --> not thread safe.
		
		String dateRange = new SimpleDateFormat("yyyyMMdd").format(fromDate) + "-" + new SimpleDateFormat("yyyyMMdd").format(toDate);
		if(logger.isDebugEnabled()){
            logger.debug("ImageMixStudyProxyV1.getQueryDateRange() --> Got query date range --> {}", dateRange);}
		
		return dateRange;
	}
}

