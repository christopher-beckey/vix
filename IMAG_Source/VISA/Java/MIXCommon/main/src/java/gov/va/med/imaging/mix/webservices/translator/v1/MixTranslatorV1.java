/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 27, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.mix.webservices.translator.v1;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.Map.Entry;

import gov.va.med.logging.Logger;

import static org.apache.commons.lang.StringEscapeUtils.escapeHtml;

import gov.va.med.*;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.imaging.BhieImageURN;
//import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.DateUtil;
import gov.va.med.imaging.DicomDateFormat;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.exceptions.StudyURNFormatException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ArtifactResultError;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.enums.ArtifactResultErrorCode;
import gov.va.med.imaging.exchange.enums.ArtifactResultErrorSeverity;
import gov.va.med.imaging.exchange.enums.ArtifactResultStatus;
import gov.va.med.imaging.exchange.enums.ObjectOrigin;
import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.enums.VistaImageType;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.mix.MixArtifactResultError;
import gov.va.med.imaging.mix.VAStudyID;
import gov.va.med.imaging.mix.webservices.rest.types.v1.CodeType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.CodingType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.DiagnosticReport;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ModCodeType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReferenceType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ShallowStudy;
import gov.va.med.imaging.mix.webservices.rest.types.v1.TextType;

// Quoc added
import gov.va.med.imaging.dicom.ecia.scu.dto.ImageDTO;
import gov.va.med.imaging.dicom.ecia.scu.dto.SeriesDTO;
import gov.va.med.imaging.dicom.ecia.scu.dto.StudyDTO;


/**
 * @author vhaiswwerfej
 *
 */
@SuppressWarnings("deprecation")
public class MixTranslatorV1
{
	private final static Logger logger = Logger.getLogger(MixTranslatorV1.class);
	
	private static Map<ArtifactResultErrorCode, gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType> errorCodeMap;
	private static Map<ArtifactResultErrorSeverity, gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType> severityMap;
	
	static
	{
		errorCodeMap = new HashMap<ArtifactResultErrorCode, gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType>();
		errorCodeMap.put(ArtifactResultErrorCode.authorizationException, gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType.AuthorizationException);
		errorCodeMap.put(ArtifactResultErrorCode.internalException, gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType.InternalException);
		errorCodeMap.put(ArtifactResultErrorCode.invalidRequestException, gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType.InvalidRequestException);
		errorCodeMap.put(ArtifactResultErrorCode.timeoutException, gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType.TimeoutException);
		
		severityMap = new HashMap<ArtifactResultErrorSeverity, gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType>();
		severityMap.put(ArtifactResultErrorSeverity.error, gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType.error);
		severityMap.put(ArtifactResultErrorSeverity.warning, gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType.warning);
	}
	
//+++++++++++++++++++++++++  Quoc added  ++++++++++++++++++++++++++++++++
	
	// Can't name "translate" alone = type erasure
	
	/**
	 * Method to translate a list of StudyDTOs into a ReportStudyListResponseType object 
	 * 
	 * @param List<StudyDTO>					study DTOs to be translated
	 * @param Site								given Site object to get site number from
	 * @return ReportStudyListResponseType		result of translation
	 * 
	 */
	public static gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType translateDTO(List<StudyDTO> studyDTOs, Site site, boolean isMinimal) {
		
		// The SCU already checked for null or empty of List<StudyDTO>.

        logger.info("translateDTO() --> Before transfer, number of Studies in List<StudyDTO> [{}]", studyDTOs.size());
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType [] studyTypes = new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType[studyDTOs.size()];
		
		for (int i = 0; i < studyDTOs.size(); i++) {
			studyTypes[i] = toStudyType(studyDTOs.get(i), site, isMinimal);	
		}

        logger.info("translateDTO() --> After transfer, number of StudyType in array [{}]", studyTypes.length);
			
		// params: false = not partial, collected array of Studies in StudyType format, null = no errors
		return new gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType(false, studyTypes, null);
	}
	
	
	/**
	 * Helper method to transfer data from StudyDTO to StudyType.
	 * 
	 * For performance improvement, query by patient ICN will get minimal data
	 * (the first query) and by patient EDIPI (the second query)  will get all available 
	 * and appropriate data.  Must set patient EDIPIs as shown in the return object.
	 * 
	 * The study Id has this format:
	 * 
	 * "urn:namespace:siteId-studyId-patientId" 
	 * 
	 * @param StudyDTO		source of data
	 * @param Site			given Site object to get site number from
	 * @return StudyType	destination of data
	 *  
	 */
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType toStudyType(StudyDTO studyDTO, Site site, boolean isMinimal) {
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType = new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType();
		
		// siteAbbreviation isn't available from DICOM source
		// specialtyDescription isn't available from DICOM source
		// reportContent isn't available from DICOM source
		
		// Strict format:
		// 1) "bhiestudy" is required --> DO NOT change
		// 2) both values are required --> can add but DO NOT remove
		// 3) The patient Id here an EDIPI and is sent back via Study Filter; 
		// 	  thus must match the patient Id in the StudyType object to work 
		String vaStudyUrn = "urn:bhiestudy:" + studyDTO.getStudyInstanceUID() + "-" + studyDTO.getPatientId();

        logger.debug("toStudyType() --> Passed in Study Id  [{}], isMinimal [{}]", vaStudyUrn, isMinimal);

		studyType.setStudyId(vaStudyUrn);
		studyType.setDicomUid(studyDTO.getStudyInstanceUID());
		studyType.setDescription(studyDTO.getStudyDescription());
		studyType.setProcedureCodes(toStudyTypeProcedureCodes(studyDTO.getProcedureCodeSeq()));
		// It's Study Date now if Study Date exists.
		studyType.setProcedureDate(studyDTO.getProcedureCreationDate());
		
		// It's Modalities in Study now if Modalities in Study exists.
		studyType.setProcedureDescription(studyDTO.getRequestedProcedureDescription());
		
		// must be an EDIPI b/c Clinical Display will send it back for the next query to get everything  
		studyType.setPatientId(studyDTO.getPatientId());
		//studyType.setPatientId("1008678470V797882");
		studyType.setPatientName(studyDTO.getPatientName());
		
		// What's this site: where the study took place or the site to get data from such as "DOD"?
		studyType.setSiteNumber(studyDTO.getClinicalTrialSiteId());
		
		studyType.setSiteName(studyDTO.getInstitutionName());
		studyType.setSiteAbbreviation(site.getSiteAbbr());
		
		studyType.setSeriesCount(studyDTO.getSeriesCount());
		studyType.setModalities(toModalitiesType(studyDTO.getModalitiesInStudy()));
		studyType.setComponentSeries(toStudyTypeComponentSeries(studyDTO.getSeriesDTOs(), vaStudyUrn));
		
		studyType.setImageCount(studyDTO.getImageCount());
				
		// If is non-minimal, potentially update the report
		if (! (isMinimal)) {
			
			// Get report text, patient name, and study description and replace carets in the contents if nec.
			String radReport = (studyDTO.getReportTextValue() == null) ? ("No report is available") : (studyDTO.getReportTextValue().replaceAll("\\^", ","));
			String patientName = (studyDTO.getPatientName() == null) ? ("") : (studyDTO.getPatientName().replaceAll("\\^", ","));
			String studyDescription = (studyDTO.getStudyDescription() == null) ? ("") : (studyDTO.getStudyDescription().replaceAll("\\^", ","));
			
			// Update report contents
			studyType.setReportContent("1^" + patientName + "^" + studyDescription + "\n" + radReport);
		}

		// Assign "accession number" to this field as there's no equivalence
		// and this field isn't used.  No need to add "accession number" to StudyType class.
		studyType.setSpecialtyDescription(studyDTO.getAccessionNumber());
		
		return studyType;
	}
	
	
	/**
	 * Helper method to convert a String of procedure codes to an array of procedure codes.
	 * Currently, pick only one value.
	 * 
	 * Also, there is a same method below translateCptCodeToStudyProcedureCode()
	 * w/o knowing before this method is written. Keep this as it's cleaner. 
	 *  
	 * @param String		incoming procedure code(s)
	 * @return String []	converted the input code(s)
	 * 
	 */
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeProcedureCodes toStudyTypeProcedureCodes(String inCodes) {
		
		// There're more code values.  Just pick one for now b/c not sure what else to pick
		// convert inCodes when more than one value here		
		return new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeProcedureCodes(createStrArray(inCodes));
	}
	
	/**
	 * Helper method to convert a String of modalities to an array of modalities
	 * 
	 * @param String []			modalities in study
	 * @return ModalitiesType	object contains the converted values
	 * 
	 */
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType toModalitiesType(String [] modsInStudy) {
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType modType = new gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType();
				
		modType.setModality(modsInStudy == null || modsInStudy.length == 0 ? createStrArray(null) : modsInStudy);

		return modType;
	}
	
	/**
	 * Helper method to create a String array out of one value
	 * 
	 * @param String		value to set
	 * @return String []	resultant array
	 * 
	 */
	private static String [] createStrArray(String value) {
		
		String [] tempArray = {(value == null ? "" : "" + value)};
		
		return tempArray;
	}

	/**
	 * Helper method to translate a list of Series DTOs into a StudyTypeComponentSeries object,
	 * which includes one or more SeriesType object(s)
	 * 
	 * @param List<SeriesDTO>				series DTOs to be translated
	 * @param String						study URN in VA format
	 * @return StudyTypeComponentSeries		result of translation
	 * 
	 */
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries toStudyTypeComponentSeries(List<SeriesDTO> seriesDTOs, String vaStudyUrn) {
		
		if(seriesDTOs == null || seriesDTOs.isEmpty()) {
			logger.debug("toStudyTypeComponentSeries() --> No series data from ECIA. Return null.");
			return null;
		}
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[] seriesTypes = new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[seriesDTOs.size()];
		
		for (int i = 0; i < seriesDTOs.size(); i++) {
			seriesTypes[i] = toSeriesType(seriesDTOs.get(i), vaStudyUrn);
		}
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries studySeries = new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries();
		
		studySeries.setSeries(seriesTypes);
		
		return studySeries;
	}
	
	/**
	 * Helper method to translate a series DTO into a SeriesType object, 
	 * 
	 * @param SeriesDTO		a series DTO to be translated
	 * @param String		study URN in VA format 
	 * @return SeriesType	result of translation
	 * 
	 */
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType toSeriesType(SeriesDTO seriesDTO, String vaStudyUrn) {
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType seriesType = new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType();
		
		seriesType.setSeriesId(seriesDTO.getClinicalTrialSeriesId());
		seriesType.setDicomUid(seriesDTO.getSeriesInstanceUID());
		seriesType.setDicomSeriesNumber(seriesDTO.getSeriesNumber());
		seriesType.setDescription(seriesDTO.getSeriesDescription());
		seriesType.setModality(seriesDTO.getModality());
		seriesType.setImageCount(seriesDTO.getImageCount());
		seriesType.setComponentInstances(toSeriesTypeComponentInstances(seriesDTO.getImageDTOs(), vaStudyUrn + "-" + seriesDTO.getModality(), seriesDTO.getSeriesInstanceUID()));
		
		return seriesType;
	}
	
	/**
	 * Helper method to translate a list of ImageDTOs into SeriesTypeComponentInstances object,
	 * which includes one or more InstanceType object(s) 
	 * 
	 * @param List<ImageDTO>					image DTOs to be translated
	 * @param String							study URN in VA format with series modality
	 * @param String 							series UID
	 * @return SeriesTypeComponentInstances		result of translation
	 * 
	 */
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances toSeriesTypeComponentInstances(List<ImageDTO> imageDTOs, String vaStudyUrn, String seriesUID) {
		
		if(imageDTOs == null || imageDTOs.isEmpty()) {
			logger.debug("toSeriesTypeComponentInstances() --> No image data from ECIA. Return null.");
			return null;
		}

		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType[] instanaceTypes = new gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType[imageDTOs.size()];
		
		for (int i = 0; i < imageDTOs.size(); i++) {
			instanaceTypes[i] = toInstanceType(imageDTOs.get(i), vaStudyUrn, seriesUID);
		}
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances seriesInstances = new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances();
		
		seriesInstances.setInstance(instanaceTypes);
		
		return seriesInstances;
	}

	/**
	 * Helper method to translate an ImageDTO into an InstanceType object
	 * 
	 * @param ImageDTO			an ImageDTO to be translated
	 * @param String			study URN in VA format with series modality
	 * @param String			series UID
	 * @return InstanceType		result of translation
	 * 
	 */
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType toInstanceType(ImageDTO imageDTO, String vaStudyUrn, String seriesUID) {
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType instanceType = new gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType();
		
		String imageUrn = createImageUrn(vaStudyUrn, seriesUID, imageDTO.getSopInstanceUID());

        logger.debug("toInstanceType() --> Created VA Image URN [{}]", imageUrn);
		
		instanceType.setImageUrn(imageUrn);
		instanceType.setDicomUid(imageDTO.getSopInstanceUID());
		instanceType.setDicomInstanceNumber(imageDTO.getInstanceNumber());
		
		return instanceType;
	}
	
	/**
	 * Helper method to create an Image URN
	 * 
	 * Create this way to facilitate in creation of DODImageURN (see DODImageURN for more info)
	 * 
	 * Image URN has the format for DoD (modality is optional):
	 * "urn:namespace:siteId-studyUID-seriesUID-instanceUID-patientId-modality"
	 *  
	 * @param String		study URN in VA format with modality to create Image URN from
	 * @param String		series UID
	 * @param String		SOP instance UID to insert	
	 * @return String		Image URN with the given format
	 * 
	 */
	private static String createImageUrn(String vaStudyUrn, String seriesUID, String instanceUID) {

		// Strict format:
		// 1) "bhieimage" or "vaimage" is required.  Chose "bhieimage" b/c BhieImageURN is a registered component for it.
		// 2) at least one value is required --> can add but DO NOT remove
		return new StringBuilder(vaStudyUrn)
				.insert(vaStudyUrn.indexOf("-") + 1, seriesUID + "-" + instanceUID + "-")
				.insert(vaStudyUrn.indexOf(":", vaStudyUrn.indexOf(":") + 1) + 1, "200-")
				.toString()
				.replace("bhiestudy", "bhieimage");
	}
	
	
	/**
	 * Given a list of studies, updates blacklisted entries according to a provided list of their SOP class UIDs. ImageDTOs
	 * with matching SOP class UIDs have those same UIDs changed to "useLocalImage".
	 * 
	 * @param List<StudyDTO>	 A list of studies to modify ImageDTOs
	 * @param List<String>		 A list of SOP class UIDs to check for
	 * @param List<StudyDTO>	 Result of applying black list: the same or ImageDTO(s) modified
	 * 
	 */
	public static List<StudyDTO> applySOPClassUIDBlacklist(List<StudyDTO> studies, List<String> sopClassUIDBlacklist) {
        logger.debug("applySOPClassUIDBlacklist() --> applying SOP class UID blacklist of {}", Arrays.toString(sopClassUIDBlacklist.toArray()));
		for (StudyDTO studyDTO : studies) {
			if (studyDTO.getSeriesDTOs() != null) {
				for (SeriesDTO seriesDTO : studyDTO.getSeriesDTOs()) {
                    logger.debug("applySOPClassUIDBlacklis() -->  seriesDTO has modality [{}]", seriesDTO.getModality());
					if (seriesDTO.getImageDTOs() != null) {
						for (ImageDTO imageDTO : seriesDTO.getImageDTOs()) {
                            logger.debug("applySOPClassUIDBlacklist() -->   checking SOP class UID [{}]; in list? [{}]", imageDTO.getSopClassUID(), sopClassUIDBlacklist.contains(imageDTO.getSopClassUID()));
							if (sopClassUIDBlacklist.contains(imageDTO.getSopClassUID())) {
                                logger.debug("applySOPClassUIDBlacklist() --> change current SOP Instance UID [{}]", imageDTO.getSopInstanceUID());
								imageDTO.setSopInstanceUID(imageDTO.getSopInstanceUID() + ".useLocalImage");
                                logger.debug("applySOPClassUIDBlacklist() --> NEW SOP Instance UID [{}]", imageDTO.getSopInstanceUID());
							}
						}
					}
				}
			}
		}
		
		return studies;
	}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	// translate 1
	public static StudySetResult translate(
			gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType reportStudyListResponseType,
			Site site, 
			StudyFilter studyFilter,
			List<String> emptyStudyModalities)
	{
		if(reportStudyListResponseType == null)
			return null;

        logger.debug("translate(1) --> Start translating [{}] StudyType(s) into SortedSet<Study> of StudySetResult", reportStudyListResponseType.getStudies().length);
		
		ArtifactResultStatus artifactResultStatus = (reportStudyListResponseType.isPartialResponse() ? ArtifactResultStatus.partialResult : ArtifactResultStatus.fullResult);
		List<ArtifactResultError> artifactResultErrors = translate(reportStudyListResponseType.getErrors());
		SortedSet<Study> studies = translate(reportStudyListResponseType.getStudies(), site, 
				studyFilter, emptyStudyModalities);
		
		StudySetResult result = StudySetResult.create(studies, artifactResultStatus, artifactResultErrors);

        logger.debug("translate(1) --> Successfully translated [{}] Study(ies) into SortedSet of StudySetResult", result.getArtifactSize());
		
		return result;
	}
	
	// translate 2
	public static String translate(gov.va.med.imaging.mix.webservices.rest.types.v1.ReportType report)
	{
		logger.debug("translate(2) --> Start translating ReportType to String");
		
		String result = "1^^\n" + (report == null ? "" : "" + report.getRadiologyReport());
		
		logger.debug("translate(2) --> Successfully translated ReportType to String");
		
		return result;
	}
	
	// translate 3
	private static SortedSet<Study> translate(
			gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType [] studies,
			Site site, 
			StudyFilter studyFilter, 
			List<String> emptyStudyModalities)
	{
		if(studies == null)
			return null;

        logger.debug("translate(3) --> Start translating [{}] StudyType(s) into SortedSet<Study>", studies.length);
		
		SortedSet<Study> result = new TreeSet<Study>();
		
		String filterStudyIdAsString = studyFilter != null && studyFilter.getStudyId() != null ?
				studyFilter.getStudyId() instanceof StudyURN ? ((StudyURN)studyFilter.getStudyId()).toString(SERIALIZATION_FORMAT.NATIVE) : studyFilter.getStudyId().toString() : 
				null;
		
		if ((filterStudyIdAsString != null) && !filterStudyIdAsString.isEmpty())
		{	// study URN type mismatch --> keep only the DOD-ID of the filter URN ( string after the 2nd : )
			String[] urnParts = StringUtil.split(filterStudyIdAsString, StringUtil.COLON);
			filterStudyIdAsString = urnParts[2];

		}
		
		/* Add no value. Keep for debugging purpose only.
		if( studyFilter != null && studyFilter.getStudyId() != null )
		{
			logger.debug("translate(3) --> Study Id filter as string [" + filterStudyIdAsString + "]");
		}
		*/
		
		for(gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType : studies)
		{
			/* Add no value. Keep for debugging purpose only.
			if ((studyType.getStudyId() != null) && (filterStudyIdAsString != null)) {
				logger.debug("translate(3) --> studyType.getStudyId().contains(filterStudyIdAsString) [" + (studyType.getStudyId().contains(filterStudyIdAsString)) + "]");
			}
	        */
			
			Study study = null;
			
			if( studyFilter != null && studyFilter.getStudyId() != null && filterStudyIdAsString != null && studyType.getStudyId() != null)
			{
				// If we have a filter, study id, and filter id, apply it and potentially filter this out if they don't match
				if (studyType.getStudyId().contains(filterStudyIdAsString)) {
					study = translate(studyType, site, emptyStudyModalities);
				}
			}
			else
			{
				study = translate(studyType, site, emptyStudyModalities);
			}
			
			if(study != null)
			{
				result.add(study);
                logger.debug("translate(3) --> Successfully translated study type with Id [{}] to Study with Id [{}]", studyType.getStudyId(), study.getStudyUrn().toString());
			}
		}

        logger.debug("translate(3) --> Successfully translated [{}] Study(ies) into SortedSet<Study>", result.size());
		
		return result;
	}
	
	// translate 4
	// Some of the log statements are overkill. Turn on when debugging
	private static Study translate(gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType, 
			Site site, List<String> emptyStudyModalities)
	{
		if(studyType == null)
			return null;

        logger.debug("translate(4) --> Start translating a StudyType with study Id [{}] to Study", studyType.getStudyId());
		
		String studyId = studyType.getStudyId();
		Study study = null;
		StudyURN studyURN = null;

		try
		{
			studyURN = URNFactory.create(studyId, StudyURN.class);
            logger.debug("translate(4) --> StudyURN instance [{}] was created by URNFactory.", studyURN != null ? studyURN.toString() : "null");
		}
		catch (URNFormatException x1)
		{
            logger.error("translate(4) --> Unable to create a StudyURN instance using URNFactory because given Id [{}] is unidentifiable.  Trying with GlobalArtifactIdentifierFactory", studyId, x1);
			try
			{
				GlobalArtifactIdentifier identifier = GlobalArtifactIdentifierFactory.create(studyId);
				
				if(identifier instanceof StudyURN)  // What if it is not??
					studyURN = (StudyURN) identifier;
				
				// Fortify change
                logger.debug("translate(4) --> StudyURN instance [{}] was created by GlobalArtifactIdentifierFactory.", studyURN != null ? studyURN.toString() : "null");
			}
			catch (GlobalArtifactIdentifierFormatException x)
			{
                logger.error("translate(4) --> Unable to create a StudyURN instance using GlobalArtifactIdentifierFactory because global artifact identifier [{}] is unidentifiable.  Return null.", studyId, x);
				return null;
			}
		}

		// BHIE identifiers are unique in that the patient ID must be set explicitly rather than
		// as part of the stringified representation of the ID
		// set the patient ID regardless of whether the URN is a BHIE or VA
		try
		{
			studyURN.setPatientId(studyType.getPatientId());
			studyURN.setPatientIdentifierTypeIfNecessary(PatientIdentifierType.icn);  // This should be EDIPI = doesn't exist
		}
		catch (StudyURNFormatException x)
		{
            logger.error("translate(4) --> Failed to set --> invalid format patient Id [{}] in the newly created StudyURN.  Return null.", studyType.getPatientId(), x);
			return null;
		}

        logger.debug("translate(4) --> Created StudyURN [{}] is of type [{}] for given study Id [{}].", studyURN.toString(), studyURN.getClass().getSimpleName(), studyId);
		
		// v2 does not include the report

        logger.debug("Creating Study. ReportContent length = [{}", (studyType.getReportContent() == null) ? ("null]") : ("[" + studyType.getReportContent().length() + "]"));
		
		StudyLoadLevel studyLoadLevel = ((studyType.getReportContent() != null) && (studyType.getReportContent().length() != 0)) ? (StudyLoadLevel.STUDY_AND_REPORT) : (StudyLoadLevel.STUDY_AND_IMAGES);
		study = Study.create(studyURN, studyLoadLevel, StudyDeletedImageState.cannotIncludeDeletedImages);

        logger.debug("translate(4) --> A Study instance with Id [{}] is created with load level [{}]", study.getGlobalArtifactIdentifier().toString(), study.getStudyLoadLevel());

		study.setAlienSiteNumber(studyType.getSiteNumber());
		study.setDescription(studyType.getDescription() == null ? "" : "" + studyType.getDescription());
		study.setAlternateExamNumber(getAccessionNumber(studyType.getSpecialtyDescription()));	
		study.setAccessionNumber(getAccessionNumber(studyType.getSpecialtyDescription()));
		//logger.debug("translate(4A) --> A Study instance with accessionNumber [" + study.getAccessionNumber() + "] is created with load level [" + study.getStudyLoadLevel() + "]");
		study.setStudyUid(studyType.getDicomUid());		
		study.setImageCount(studyType.getImageCount());	
		//The BHIE framework is not capable of providing the patient name for now		
		study.setPatientName(studyType.getPatientName() == null ? "" : "" + studyType.getPatientName().replaceAll("\\^", " "));
		study.setProcedureDate(translateDICOMDateToDate(studyType.getProcedureDate()));	
		study.setProcedure(studyType.getProcedureDescription() == null ? "" : "" + studyType.getProcedureDescription());
		// Note: Exchange v2 did not include study report; added now!!!
		study.setRadiologyReport(studyType.getReportContent());
		study.setSiteName(studyType.getSiteName() == null ? "" : "" + studyType.getSiteName());
		
		// for readability and to avoid testing and return null, which is not allowed in Hashtable
		String tempStr = studyType.getSpecialtyDescription() == null ? "" : "" + studyType.getSpecialtyDescription();
		study.setSpecialty(tempStr.isEmpty() || Character.isLetter(tempStr.charAt(0)) ? tempStr : "");
		
		String siteAbbr = studyURN.toString().contains(":200") ? "DOD" : "" + site.getSiteAbbr();
		
		study.setSiteAbbr(siteAbbr);
		study.setOrigin(siteAbbr);
		
		// Turn on as needed
		//logger.debug("translate(4) --> Study AlienSiteNumber = [" + study.getAlienSiteNumber() + "]");
		//logger.debug("translate(4) --> Study Description [" + study.getDescription() + "]");
		//logger.debug("translate(4) --> study.getAlternateExamNumber [" + study.getAlternateExamNumber() + "]");
		//logger.debug("translate(4) --> Study UID [" + study.getStudyUid() + "]");
		//logger.debug("translate(4) --> Study Image Count [" + study.getImageCount() + "]");
		//logger.debug("translate(4) --> Study Patient Name [" + study.getPatientName() + "]");
		//logger.debug("translate(4) --> Study Procedure Date [" + study.getProcedureDate() + "]");
		//logger.debug("translate(4) --> Study Procedure [" + study.getProcedure() + "]");
		//logger.debug("translate(4) --> AFTER setting Study Radiology Report [" + study.getRadiologyReport() + "]");
		//logger.debug("translate(4) --> Study Site Name [" + study.getSiteName() + "]");
		//logger.debug("translate(4) --> Study Specialty [" + study.getSpecialty() + "]");
		
		//logger.debug("translate(4) --> Study Site Abbr [" + study.getSiteAbbr() + "]");
		//logger.debug("  Study Origin [" + study.getOrigin() + "]");
		
		Image firstImage = null;
		
		// Changed for performance enhancement
		if(studyType.getComponentSeries() != null) 
		{
			
			gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[] series = studyType.getComponentSeries().getSeries();
		
			if(series != null) 
			{
			
				//logger.debug("translate(4) --> Study - looking for first Image for number of Series [" + series.length + "]");
			
				for(int i = 0; i < series.length; i++) 
				{
					Series newSeries = translate(series[i], study, site);

					study.addSeries(newSeries);
					
					// first series, first image
					if(i == 0) 
					{
						Iterator<Image> imageIter = newSeries.iterator();
						
						if(imageIter.hasNext()) 
						{
							firstImage = imageIter.next();
						}
					}
				}
			}
		}
		
		if(firstImage == null)
		{
            logger.debug("translate(4) -->  Creating fake first image for study [{}], study has [{}] images.", study.getStudyUrn().toString(), study.getImageCount());
			firstImage = createdCannedFirstImage(study, site);
		} 
		else 
		{
			logger.debug("translate(4) --> Study - first Image found !!!");
		}
		
		study.setFirstImage(firstImage);

		// NEW logic for empty modalities filtering
		
		if(studyType.getModalities() != null)
		{
			String [] modalities = studyType.getModalities().getModality();

            logger.debug("translate(4) --> modalities in study {}", new HashSet<String>(Arrays.asList(modalities)));
            logger.debug("translate(4) --> empty modalities list {}", emptyStudyModalities);
			
			if(modalities != null) 
			{
				//TODO: convert modality as shown above from String [] to Set<String> and add setModalities(Set<String>) to Study.java
				// study.setModalities(new HashSet<String>(Arrays.asList(modalities));
				// Do it this way for now for testing. If works, can leave as is or do the TODO.
				for(int i = 0; i < modalities.length; i++) 
				{
					study.addModality(modalities[i]);
				}
				
				// Can't use this --> Set<String> givenMods = study.getModalities();
				// retainAll() method will alter it.  Use a separate object instead
				Set<String> givenMods = new HashSet<String> (Arrays.asList(modalities));
				
				int oriSize = givenMods.size();
								
				// retain all the elements of given modality(ies) in ArrayList that exist(s) in empty modality ArrayList
				givenMods.retainAll(emptyStudyModalities);
				
				// If oriSize is greater than the size of the modified given modality ArrayList, it means that
				// either there's no match between the two ArrayLists or there, at least, remains a non-match value.
				// In either case, the requirement is NOT to change it to "no image"
				// If oriSize equals the size of the modified given modality ArrayList, it means that the given modality(ies)
				// is/are totally matched in the empty modality ArrayList and no non-match remains.
				// In this case, the requirement is to change to "no image".
				
				if(oriSize == givenMods.size()) 
				{
					logger.debug("translate(4) --> Changing first image............");
					// TODO: remove "SR" from empty modality list in the config file
					study.setImageCount(0);
					
					if(firstImage != null) 
					{
						firstImage.setAbsFilename("-1");
						firstImage.setFullFilename("-1");
						firstImage.setBigFilename("-1");
					}
				}
					
			}
				
		}	
/*
		
// OLD logic for empty modalities filtering

		if(studyType.getModalities() != null) // -- *** investigate this section for DAS!!
		{
			String [] modalities = studyType.getModalities().getModality();
			
			logger.debug("translate(4) --> modalities in study " + (new HashSet<String>(Arrays.asList(modalities))) );
			logger.debug("translate(4) --> empty modalities list " +  emptyStudyModalities);
			
			if(modalities != null) 
			{
				// JMW 4/11/2011 P04
				// a study from the DoD may have multiple modalities.  If it does, one or more of them
				// might be on the emptyStudyModality list indicating there are no images for that
				// modality.  But if there is a modality on this list and one that is not on this list
				// in a single study, then there should be images in the study and the empty modality
				// should be ignored
				
				boolean emptyStudyModalityFound = false;
				boolean nonEmptyStudyModalityFound = false;
				
				for(int i = 0; i < modalities.length; i++) 
				{
					logger.debug("translate(4) --> a modality in study [" + modalities[i] + "]");
					study.addModality(modalities[i]);
					// JMW 1/11/2010 P104 - special case for PR modality studies
					// these studies have no image, set the image count to 0 regardless of what the BIA says
					// JMW 4/11/2011 P104
					boolean thisModalityEmptyStudyFound = false;
					for(String emptyStudyModality : emptyStudyModalities)
					{
						//logger.debug("translate(4) --> emptyStudyModality [" + emptyStudyModality + "]");
						if(modalities[i].equals(emptyStudyModality))
						{
							// found a modality that does not contain any images
							logger.debug("translate(4) --> found empty modality [" + modalities[i] + "].  Set emptyStudyModalityFound & thisModalityEmptyStudyFound to true" );
							emptyStudyModalityFound = true;
							thisModalityEmptyStudyFound = true;
						}
					}
					// JMW 4/11/2011 P104
					// if this specific modality was not found to be empty, then at least one modality
					// in this study should contain images
					if(!thisModalityEmptyStudyFound)
						nonEmptyStudyModalityFound = true;
				}
				// JMW 4/11/2011 P104
				// if there is one or more modality that does not contain images and no modality 
				// that does contain images in the study, set the study to not have any images
				logger.debug("translate(4) --> before changing values --> emptyStudyModalityFound ["+ emptyStudyModalityFound +"], nonEmptyStudyModalityFound ["+ nonEmptyStudyModalityFound + "]");
				logger.debug("translate(4) --> emptyStudyModalityFound && !nonEmptyStudyModalityFound [" + (emptyStudyModalityFound && !nonEmptyStudyModalityFound) + "]");
				if(emptyStudyModalityFound && !nonEmptyStudyModalityFound)
				{
					//11/30/2020: Quoc commented out --> study.setImageCount(0);
					if(firstImage != null)
					{
						firstImage.setAbsFilename("-1");
						firstImage.setFullFilename("-1");
						firstImage.setBigFilename("-1");
					}
				}
			}
		}			
		
*/	
		if(studyType.getProcedureCodes() != null)
		{
			// The DoD may provide more than one cpt code, we are only going to grab the first one
			String [] cptCodes = studyType.getProcedureCodes().getCptCode();
			if((cptCodes != null) && (cptCodes.length > 0))
			{
				study.setCptCode(cptCodes[0]);
			}			
		}

        logger.debug("translate(4) -->  Study [{}] is translated.", studyURN.toString());
		
		return study;
	}
	
	/**
	 * In some cases we are seeing studies come back from the BIA that do not have any images in them.
	 * Most of these are from Landstuhl.  The CVIX in Federation V4 and the Clinical Display client both
	 * do not handle a null first image in the study.  To fix this issue we create a "fake" image for the first
	 * image field but it is not actually included in the study
	 * 
	 * @param study
	 * @return
	 */
	public static Image createdCannedFirstImage(Study study, ArtifactSource artifactSource)
	{
		ImageURN imageUrn = null;
		StudyURN studyUrn = study.getStudyUrn();		
		
		try
		{
			
			StringBuilder fakeBhieUrn = new StringBuilder();
			
			fakeBhieUrn.append("urn:");
			fakeBhieUrn.append(BhieImageURN.getManagedNamespace().getNamespace());
			fakeBhieUrn.append(":");
			fakeBhieUrn.append("fakeImage");
			imageUrn = URNFactory.create(fakeBhieUrn.toString(), ImageURN.class);
			
			imageUrn = URNFactory.create(fakeBhieUrn.toString(), ImageURN.class);
			imageUrn.setStudyId(studyUrn == null ? null : studyUrn.getStudyId());
			imageUrn.setPatientId(study.getPatientId());
			imageUrn.setPatientIdentifierTypeIfNecessary(study.getPatientIdentifierType());
			imageUrn.setImageModality("");
			
		}
		catch (URNFormatException urnfX)
		{
            logger.error("createdCannedFirstImage() --> URNFormatException making a fake first image URN for study [{}]", studyUrn.toString(), urnfX);
			return null;
		}
		
		Image image = Image.create(imageUrn);
		image.setAbsFilename("-1");
		image.setFullFilename("-1");
		image.setBigFilename("-1");
		
		image.setImageNumber("1");
		image.setImageUid("");
		image.setDescription(study.getDescription());
		//image.setPatientName(studyType.getPatientName());
		image.setPatientName(study.getPatientName());
		image.setProcedureDate(study.getProcedureDate());
		image.setProcedure(study.getProcedure());
		
		//image.setSiteAbbr(studyType.getSiteAbbreviation());
		if( WellKnownOID.BHIE_RADIOLOGY.isApplicable(imageUrn.getHomeCommunityId()) ||
			WellKnownOID.HAIMS_DOCUMENT.isApplicable(imageUrn.getHomeCommunityId()) )
		{
			image.setSiteAbbr("DOD"); // needed because CPS test rig no longer passes us useful information
			image.setObjectOrigin(ObjectOrigin.DOD);
		}
		else 
		{
			if(artifactSource instanceof Site)
				image.setSiteAbbr( ((Site)artifactSource).getSiteAbbr() );
			image.setObjectOrigin(ObjectOrigin.VA);
		}
		
		image.setAlienSiteNumber(study.getAlienSiteNumber());
		image.setFullLocation("A");
		image.setAbsLocation("M");
		image.setDicomImageNumberForDisplay("");
		image.setDicomSequenceNumberForDisplay("");
		image.setImgType(VistaImageType.DICOM.getImageType()); // radiology
		
		return image;
	}
	
	// translate 5
	private static Series translate(
			gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType seriesType,
			Study study,
			Site site) 
	{
		logger.debug("translate(5) --> Translate Series ...");
		
		if(seriesType == null || study == null || site == null)
		{
			logger.warn("translate(5) --> Null SeriesType, Study or Site parameter passed in."); 
			return null;
		}
		
		logger.debug("translate(5) --> Creating new Series ...");
		
		gov.va.med.imaging.exchange.business.Series series = gov.va.med.imaging.exchange.business.Series.create(
			ExchangeUtil.isSiteDOD(site) ? ObjectOrigin.DOD : ObjectOrigin.VA, 
			seriesType.getSeriesId(), 
			seriesType.getDicomUid()
		);
		
		series.setSeriesNumber(seriesType.getDicomSeriesNumber() == null ? "" : "" + seriesType.getDicomSeriesNumber().toString());
		//logger.debug("translate(5) --> Series Number   = " + series.getSeriesNumber());
		
		series.setSeriesIen(series.getSeriesNumber().equals("") ? "1" : "" + series.getSeriesNumber());
		//logger.debug("translate(5) --> Series IEN [" + series.getSeriesIen() + "]");
		
		series.setSeriesUid(seriesType.getDicomUid() == null ? "" : "" + seriesType.getDicomUid());
		//logger.debug("translate(5) --> Series DICOM UID [" + seriesType.getDicomUid() + "]");
		
		series.setModality(seriesType.getModality());
		//logger.debug("translate(5) --> Series Modality [" + series.getModality() + "]");
		
		series.setDescription(seriesType.getDescription());
		//logger.info("translate(5) --> Series description [" + series.getDescription() + "]");
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType [] instances = seriesType.getComponentInstances().getInstance();
		
		if(instances != null) {
			for(int i = 0; i < instances.length; i++) {
				Image image = translate(instances[i], site, study, series);
				series.addImage(image);
			}

            logger.debug("translate(5) --> Series contains [{}] translated image(s).", series.getImageCount());
		}
		
		logger.debug("translate(5) --> Successfully translated Series!");
		
		return series;
	}
	
	// translate 6
	private static Image translate(
			gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType instance,
			ArtifactSource artifactSource,
			Study study,
			Series series) 
	{
		//logger.debug("translate(6) --> Translate Image ...");
		
		if(instance == null || series == null || study == null)
		{
			logger.warn("translate(6) --> Null InstanceType, Series or Study parameter passed in.");
			return null;
		}
		
		ImageURN imageUrn = null;
		StudyURN studyUrn = study.getStudyUrn();
		
		//logger.debug("translate(6) --> Instance ImageURN = " + instance.getImageUrn());
		
		try
		{
			imageUrn = URNFactory.create(instance.getImageUrn(), ImageURN.class);
			imageUrn.setPatientIdentifierTypeIfNecessary(study.getPatientIdentifierType());
			
			// These three should have been set while creating.  
			// Why set them again?  Maybe, not available at the time to create URN Code Value?
			imageUrn.setStudyId(studyUrn == null ? null : studyUrn.getStudyId());
			imageUrn.setPatientId(study.getPatientId());
			imageUrn.setImageModality(series.getModality() == null ? "" : "" + series.getModality());
		}
		catch (URNFormatException urnfX)
		{
            logger.error("translate(6) --> Error making URN from image ID [{}]", instance.getImageUrn(), urnfX);
			return null;
		}

        logger.debug("translate(6) --> ImageURN [{}]", imageUrn);
		
		// pretty much empty, except to retain the ImageURN object in its GlobalArtifactIdentifier field
		Image image = Image.create(imageUrn); 
		
		//image.setIen(instance.getImageId());
		//image.setPatientName(studyType.getPatientName());
		//image.setSiteNumber(studyType.getSiteNumber());
		//image.setSiteNumber(site.getSiteNumber());

		image.setImageNumber(instance.getDicomInstanceNumber() + "");
		image.setImageUid(instance.getDicomUid() == null ? "" : "" + instance.getDicomUid());
		image.setDescription(study.getDescription());
		image.setPatientName(study.getPatientName());
		image.setProcedureDate(study.getProcedureDate());
		image.setProcedure(study.getProcedure());
		
		image.setSiteAbbr(study.getSiteAbbr());
		
		if(study.getStudyUrn().toString().contains(":200")) 
		{
			image.setSiteAbbr("DOD"); // needed because CPS test rig no longer passes us useful information
			image.setObjectOrigin(ObjectOrigin.DOD);
		}
		else 
		{
			if(artifactSource instanceof Site)
				image.setSiteAbbr( ((Site)artifactSource).getSiteAbbr() );
			image.setObjectOrigin(ObjectOrigin.VA);
		}
		
		image.setAlienSiteNumber(study.getAlienSiteNumber());
		image.setFullLocation("A");
		image.setAbsLocation("M");
		image.setDicomImageNumberForDisplay(instance.getDicomInstanceNumber() == null ? "" : "" + instance.getDicomInstanceNumber() + "");
		image.setDicomSequenceNumberForDisplay(series.getSeriesNumber());
		image.setImgType(VistaImageType.DICOM.getImageType()); // radiology
		
		logger.debug("translate(6) --> Successfully translated Image!");
		
		return image;
	}
	
	private static Date translateDICOMDateToDate(String dicomDate)
	{
		if((dicomDate == null) || (dicomDate.equals("")) || (dicomDate.length() < 8)) {
			return null;// Date();
		}
		
		//TODO: update this function to handle if only part of the date is given (no month, etc)
		//TODO: month and day are now required, do a check for length and parse on that
		//TODO: if the date is invalid, should this throw an exception or always get full list of studies?
		//String dicomDate = "20061018143643.655321+0200";
		//SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss", Locale.US);
		
		String format = getDateFormat(dicomDate);
		if("".equals(format))
			return null;
		
		//SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd", Locale.US);
		SimpleDateFormat sdf = new SimpleDateFormat(format, Locale.US);
		Date d = null;
		try 
		{
			d = sdf.parse(dicomDate);
			return d;
		}
		catch(ParseException pX) {
			logger.error(pX);
			return null;	
		}
	}
	
	/**
	 * Determines the string format of the date based on the length of the date. Assumes date is in a DICOM format but not sure how many levels of precision it contains
	 * @param date DICOM date with unknown amount of precision
	 * @return A formatter string for parsing the date 
	 */
	private static String getDateFormat(String date) {
		if(date == null)
			return "";
		switch(date.length()) {
			case 4:
				return "yyyy";
			case 6:
				return "yyyyMM";
			case 8:
				return "yyyyMMdd";
			case 10:
				return "yyyyMMddHH";
			case 12:
				return "yyyyMMddHHmm";
			case 14:
				return "yyyyMMddHHmmss";
			default:
				return "yyyyMMddHHmmss";				
		}			
	}
	
	/**
	 * Translate Date into a JSON formatted String date[Time].
	 * 
	 * @param Date				Date object to translate
	 * @return String			translated result
	 * @throws ParseException	required exception
	 * 
	 */
	public static String translateDateToJSON(Date date) 
//	throws ParseException
	{ // TODO make this really produce yyyy-MM-ddTHH:MI:SS+HH:MI (UTC time)
		String dateStringAsJSON = "";
		if (date!=null) 
		{
			DateFormat jsonDate = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ"); // yyyy-MM-dd'T'HH:mm:ss.SSSZ
			dateStringAsJSON = jsonDate.format(date);
			// this produces 'yyyy-MM-ddTHH:mm:ss+HHmm' or '...-HHmm' --> 24 chars
			// insert ':' to UTC part
			if (dateStringAsJSON.length()==24) {
				String beg = dateStringAsJSON.substring(0,22);
				String end = dateStringAsJSON.substring(22,24);
				dateStringAsJSON = beg + ":" + end;
			}
		}
		return dateStringAsJSON;
	}

	/**
	 * Translate a DICOM style String date into a JSON formatted String date.
	 * 
	 * @param String			Date in String format
	 * @return String			translated result
	 * @throws ParseException	required exception
	 * 
	 */
	public static String translateDateToJSON(String dateString) 
	throws ParseException
	{
		String dateStringAsJSON = "";
		if (dateString != null)
		{
			String trimmedDateString = dateString.trim();
			if (trimmedDateString.length() > 0)
			{
				DicomDateFormat dicomDateFormat = new DicomDateFormat();
				// post patch 59 dates include time-of-day segment
				DateFormat jsonDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ"); 
				Date date = dicomDateFormat.parse(trimmedDateString);
				dateStringAsJSON = jsonDateFormat.format(date);
			}
		}
		return dateStringAsJSON;
	}

	private static List<ArtifactResultError> translate(gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorResultType [] errors)
	{
		if(errors == null)
			return null;
		
		List<ArtifactResultError> result = new ArrayList<ArtifactResultError>();
		
		for(gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorResultType error : errors)
		{
			result.add(translate(error));
		}		
		
		return result;
	}
	
	private static ArtifactResultError translate(gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorResultType error)
	{
		ArtifactResultErrorCode errorCode = translate(error.getErrorCode());
		ArtifactResultErrorSeverity severity = translate(error.getSeverity()); 
		return new MixArtifactResultError(error.getCodeContext(), error.getLocation(), 
				errorCode, severity);
	}
	
	// translate 7
	public static gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType translate(StudyFilter studyFilter)
	{
		StudyURN studyUrn = (StudyURN)studyFilter.getStudyId();
		gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType ft = studyFilter == null ? 
				new gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType() : 
				new gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType(
						studyFilter.getFromDate() == null ? null : DateUtil.getDicomDateFormat().format(studyFilter.getFromDate()), 
								studyFilter.getToDate() == null ? null : DateUtil.getDicomDateFormat().format(studyFilter.getToDate()), 
					studyUrn == null ? null : studyUrn.toString(SERIALIZATION_FORMAT.NATIVE));
		if ((ft.getFromDate() != null) || (ft.getToDate()!=null) || (ft.getStudyId()!=null))
		{
            logger.debug("translate(7) --> Study Filter [{}]", ft.toString());
		}
		return ft;
	}
	
	// translate 8
	public static gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType translate(
			StudySetResult studySetResult)
	throws TranslationException
	{
		if(studySetResult == null)
			return null;
		// consistent with V1 translator
		if((studySetResult.getArtifacts() == null) || (studySetResult.getArtifacts().size() == 0))
			return null;
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType result = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType();
		
		result.setPartialResponse(studySetResult.isPartialResult());
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType [] studyTypes = 
			translate(studySetResult.getArtifacts());
        logger.debug("translate(8) --> Translated studies into [{}] study types to return in Exchange interface", studyTypes == null ? "null" : "" + studyTypes.length);
		result.setStudies(studyTypes);
		result.setErrors(translate(studySetResult.getArtifactResultErrors()));
		
		return result;
	}
	
	public static DiagnosticReport[] convertStudies(StudySetResult studySetResult)
	throws TranslationException
	{
		if(studySetResult == null)
			return null;
		// consistent with V1 translator
		if((studySetResult.getArtifacts() == null) || (studySetResult.getArtifacts().size() == 0))
			return null;
		
		List <DiagnosticReport> dRs = null;
			
		// result.setPartialResponse(studySetResult.isPartialResult());
		dRs = groupStudiesByReport(studySetResult.getArtifacts());

		int numAllStudies = 0;
		if ((dRs != null) && (dRs.size() > 0))
		{
			for(DiagnosticReport dR : dRs)
			{
				numAllStudies += dR.getShallowStudy().length;
			}
		}
        logger.debug("convertStudies() --> Translated [{}] studies into [{}] DiagnosticReport group(s) to return in MIX interface", numAllStudies, (dRs == null) ? "0" : "" + dRs.size());
		// result.addShallowStudies(ShallowStudies);
		// result.setErrors(translate(studySetResult.getArtifactResultErrors()));
		
		// convert List to array
		DiagnosticReport[] dRArray = new DiagnosticReport[dRs.size()];
		for (int i=0; i<dRs.size(); i++) {
			dRArray[i] = dRs.get(i);
		}
		return dRArray;
	}
	
	// translate 9
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorResultType[] translate(
			List<ArtifactResultError> artifactResultErrors)
	{
		if(artifactResultErrors == null)
			return null;
		
		logger.debug("translate(9) --> Translate ArtifactResultErrors (plural) into ErrorResultType array");
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorResultType []result =
			new gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorResultType[artifactResultErrors.size()];
		
		int i = 0;
		for(ArtifactResultError artifactResultError : artifactResultErrors)
		{
			result[i] = translate(artifactResultError);
			i++;
		}
		
		logger.debug("translate(9) --> Successfully translated ArtifactResultErrors into ErrorResultType");
		
		return result;
	}
	
	// translate 10
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorResultType translate(
			ArtifactResultError artifactResultError)
	{
		
		//logger.debug("translate(10) --> Translate ArtifactResultError (singular) into ErrorResultType");
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorResultType result = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorResultType();
		
		result.setCodeContext(artifactResultError.getCodeContext());
		result.setLocation(artifactResultError.getLocation());
		result.setErrorCode(translate(artifactResultError.getErrorCode()));
		result.setSeverity(translate(artifactResultError.getSeverity()));
		
		//logger.debug("translate(10) --> Translate ArtifactResultError (singular) into ErrorResultType");
		
		return result;
	}
	
	// translate 11
	private static ArtifactResultErrorCode translate(gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType errorCodeType)
	{
		for(Entry<ArtifactResultErrorCode, gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType> entry : errorCodeMap.entrySet())
		{
			if(entry.getValue() == errorCodeType)
				return entry.getKey();
		}
		return ArtifactResultErrorCode.internalException;
	}
	
	// translate 12
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType translate(ArtifactResultErrorCode artifactResultErrorCode)
	{
		for(Entry<ArtifactResultErrorCode, gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType> entry : errorCodeMap.entrySet())
		{
			if(entry.getKey() == artifactResultErrorCode)
				return entry.getValue();
		}
		return gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType.InternalException;
	}
	
	// translate 13
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType translate(ArtifactResultErrorSeverity artifactResultErrorSeverity)
	{
		for(Entry<ArtifactResultErrorSeverity, gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType> entry : severityMap.entrySet())
		{
			if(entry.getKey() == artifactResultErrorSeverity)
			{
				return entry.getValue();
			}
		}
		return gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType.error;
	}
	
	// translate 14
	private static ArtifactResultErrorSeverity translate(gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType severityType)
	{
		for(Entry<ArtifactResultErrorSeverity, gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType> entry : severityMap.entrySet())
		{
			if(entry.getValue() == severityType)
			{
				return entry.getKey();
			}
		}
		return ArtifactResultErrorSeverity.error;
	}
	
	// translate 15
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType [] translate(SortedSet<Study> studies)
	throws TranslationException
	{
		// not all studies in the result might be included (deleted or error studies are not included)
		
		List<gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType> result = 
			new ArrayList<gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType>();
		
		for(Study study : studies)
		{
			gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType = translate(study);
			if(studyType != null)
				result.add(studyType);
		}
		
		return result.toArray(new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType[result.size()]);
	}
	
	// processStudy: 
	// if no matching report, make new dR with shallowStudy, populate dR fields,
	// on dR found add new shallowStudy only
	private static void processStudy(List <DiagnosticReport> dRs, Study study)
	throws TranslationException
	{
		// look for existing dR
		boolean isNewDR = true;
		DiagnosticReport theDR=null;
		Date issued = null;
		String id = "";
		String theReport = "";
		if (study.getRadiologyReport()!=null) {
			id= Integer.toHexString(study.getRadiologyReport().hashCode());
			issued = study.getDocumentDate();
			theReport = study.getRadiologyReport();
		}
		for(DiagnosticReport dR : dRs)
		{	 
			if (dR.getId().equals(id)) {
				theDR = dR;
				isNewDR = false;
				break;
			}
		}
		if (theDR == null) { // isNewDR
			// dR not found -->  create one, and populate content
			theDR=new DiagnosticReport();

			theDR.setId(id);
			
			String escapedReport=""; // empty report
			if (!theReport.isEmpty()) {
				escapedReport = escapeHtml(theReport); // make sure ", &, <, > are escaped
				escapedReport.replace(" ", "%20"); // make sure spaces are escaped too
			}
			TextType text = new TextType("additional", "<div>" + escapedReport + "</div>");
			theDR.setText(text);

			// [{\"code\": [{\"coding\": {\"system\": \"http://hl7.org/fhir/v2/0074/\", \"code\":\"" + category + "\"}]]
			CodingType coding = new CodingType("http://hl7.org/fhir/v2/0074/", "RAD", null); // TODO set proper code when specialty is different!
			CodingType[] codingArray = new CodingType[1];
			codingArray[0] = coding;
			CodeType code = new CodeType(codingArray);
			theDR.setCategory(code); 
			
			// [{\"code\": [{\"coding\": {\"system\": \"http://www.ama-assn.org/go/cpt/\", \"code\":\"" + code + "\", \"display\": \"Radiology Report\"}]
			CodingType coding2 = new CodingType("http://www.ama-assn.org/go/cpt/", study.getCptCode(), "Radiology Report"); // TODO set proper code when specialty is different!
			CodingType[] codingArray2 = new CodingType[1];
			codingArray2[0] = coding2;
			CodeType code2 = new CodeType(codingArray2);
			theDR.setCode(code2);
			
			ReferenceType subject = new ReferenceType("Patient/"+study.getPatientId());
			theDR.setSubject(subject);
			
//			try {
//				theDR.setEffectiveDateTime(translateDateToJSON(study.getProcedureDateString()));
//				theDR.setIssued(translateDateToJSON(study.getProcedureDateString()));
//			}
//			catch (ParseException pe) {
//				throw new TranslationException("Unable to parse study procedure date, " + pe.getMessage(), pe);
//			}
			theDR.setEffectiveDateTime(translateDateToJSON(study.getProcedureDate()));
			theDR.setIssued(translateDateToJSON(issued));
			
			ReferenceType performer = new ReferenceType("Organization/VHA"); // agreed upon as VHA or DOD
			theDR.setPerformer(performer);
		}
		
		ShallowStudy shallowStudy = convertShallowStudy(study);
		if(shallowStudy != null)
			theDR.addShallowStudy(shallowStudy);
		
		if (isNewDR)
			dRs.add(theDR);
	}
	
	// Loop through studies and created DR with shallow studies structure -- sorted: latest study (procedureDate) first
	private static List<DiagnosticReport> groupStudiesByReport(SortedSet<Study> studies)
	throws TranslationException
	{
		// not all studies in the result might be included (deleted or error studies are not included)
		List <DiagnosticReport> dRs = null; 
		
		for(Study study : studies)
		{
			if (dRs==null) 
				dRs = new ArrayList<DiagnosticReport>();
	
			processStudy(dRs, study);
		}
		
		return dRs; // .toArray(new gov.va.med.imaging.mix.webservices.fhir.types.v1.ShallowStudy[result.size()]);
	}
	
	// translate 16
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType translate(Study study)
	throws TranslationException
	{
		if(study == null)
			return null;
		// don't return the study if there is a questionable integrity/error condition
		if(study.hasErrorMessage())
		{
            logger.debug("translate(16) --> Study [{}] has error message, excluding from results.", study.getStudyIen());
			return null;
		}
		if(study.isDeleted())
		{
            logger.debug("translate(16) --> Study [{}] is deleted, excluding from results.", study.getStudyIen());
			return null;
		}
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType result = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType();
		
		StudyURN studyURN = study.getStudyUrn();
		
		result.setStudyId( studyURN.toString() );
		result.setDescription(study.getDescription());
		result.setProcedureCodes(translateCptCodeToStudyProcedureCode(study.getCptCode()));
		try
		{
		result.setProcedureDate(translate(study.getProcedureDate()));
		}
		catch(ParseException pX)
		{
			throw new TranslationException("translate(16) --> Unable to parse study procedure date, " + pX.getMessage(), pX);
		}
		
		result.setProcedureDescription(study.getProcedure());
		result.setPatientId(study.getPatientId());
		result.setPatientName(study.getPatientName());
		result.setSiteNumber(study.getSiteNumber());
		result.setSiteAbbreviation(study.getSiteAbbr());
		result.setSpecialtyDescription(study.getSpecialty());
		result.setReportContent(study.getRadiologyReport()); // added for MIX
		result.setSiteName(study.getSiteName());
		
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB; *** check for MIX!
		if (study.getStudyUid() != null && study.getStudyUid().trim().length() > 0)
		{
			result.setDicomUid(study.getStudyUid());
		}
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries wrapper = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries();
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[] componentSeries = 
			translate(study.getSeries(), study);

		// JMW 7/16/08 accurately get the number of images by actually counting the images from each
		// series
		// This has to be done this way because while the internal count of images is now accurate, 
		// we might not give all of the internal images through this interface, this interface excludes
		// all questionable integrity images and studies/images with other problems.
		int imageCount = 0;
		for(gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType series : componentSeries)
		{
			imageCount += series.getImageCount();
		}
		result.setImageCount(imageCount);
		
		// series with no instances will be suppressed, so the only way to know the correct
		// series count is to use the length of the returned array - DKB
		result.setSeriesCount(componentSeries.length);
		
		wrapper.setSeries(componentSeries);
		result.setComponentSeries(wrapper);
		
		if(study.getModalities() != null)
		{
			String modalities[] = new String[study.getModalities().size()];
			int i = 0;
			for(String modality : study.getModalities())
			{
				modalities[i] = modality;
				i++;
			}
			gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType modalitiesType = 
				new gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType(modalities);
			result.setModalities(modalitiesType);
		}
		
		return result;
	}
	
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.ShallowStudy convertShallowStudy(Study study)
	throws TranslationException
	{
		if(study == null)
			return null;
		// don't return the study if there is a questionable integrity/error condition
		if(study.hasErrorMessage())
		{
            logger.debug("convertShallowStudy() --> Study [{}] has error message, excluding from results.", study.getStudyIen());
			return null;
		}
		if(study.isDeleted())
		{
            logger.debug("convertShallowStudy() --> Study [{}] is deleted, excluding from results.", study.getStudyIen());
			return null;
		}
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.ShallowStudy result = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.ShallowStudy();
		
		// create a MIX smart study URN that is passes as study UID
		StudyURN studyURN = study.getStudyUrn();
		VAStudyID vaStudyID = new VAStudyID();
		String theMIXStudyUid = "";
		try {
			theMIXStudyUid = vaStudyID.create(studyURN.getOriginatingSiteId(), studyURN.getStudyId(), studyURN.getPatientId()); // patientICN !!!
		}
		catch (URNFormatException ufe) {
			throw new TranslationException("MixTranslatorV1.convertShallowStudy() --> URN translation exception, " + ufe.getMessage(), ufe);
			
		}

        logger.debug("convertShallowStudy() --> Given StudyURN [{}] --> MIX Study Uid [{}]", studyURN.toString(), theMIXStudyUid.toString());
		
		result.setUid( theMIXStudyUid );
		result.setProcedure(study.getProcedure());
		result.setStarted(translateDateToJSON(study.getProcedureDate())); // yyyyMMddhhmmss.SSSSSS > yyyy-MM-ddTHH:MI+HH:MI !!!

		// gov.va.med.imaging.mix.webservices.fhir.types.v1.StudyTypeComponentSeries wrapper = 
		//	new gov.va.med.imaging.mix.webservices.fhir.types.v1.StudyTypeComponentSeries();
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[] componentSeries = 
			translate(study.getSeries(), study);

		// JMW 7/16/08 accurately get the number of images by actually counting the images from each
		// series
		// This has to be done this way because while the internal count of images is now accurate, 
		// we might not give all of the internal images through this interface, this interface excludes
		// all questionable integrity images and studies/images with other problems.
		int imageCount = 0;
		for(gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType series : componentSeries)
		{
			imageCount += series.getImageCount();
		}
		result.setNumberOfInstances(imageCount);
		
		// series with no instances will be suppressed, so the only way to know the correct
		// series count is to use the length of the returned array - DKB
		result.setNumberOfSeries(componentSeries.length);
				
		if(study.getModalities() != null)
		{
			// [{\"code\": \" + modality + \"}]
			int numMods = study.getModalities().size();

			ModCodeType[] modCodeArray = new ModCodeType[numMods];
			
			int i=0;
			for(String modality : study.getModalities())
			{
				modCodeArray[i] = new ModCodeType(modality);
				i++;
			}

			result.setModalitiesInStudy(modCodeArray);
		}
		
		return result;
	}
	
	// translate 17
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[] translate(
			Set<Series> serieses, Study study)
	throws TranslationException
	{
		List<gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType> result = 
			new ArrayList<gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType>();
		
		for(Series series : serieses)
		{
			// Filter series with no images from the result set - DKB
			if(series.getImageCount() > 0)
			{
				gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType seriesType = 
					translate(series, study);	
				if(seriesType != null)
					result.add(seriesType);
			}
		}
		
		return result.toArray(new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[result.size()]);
	}
	
	// translate 18
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType translate(Series series,
			Study study)
	throws TranslationException
	{
		if(series == null)
			return null;
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType result = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType();
		
		List<gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType> validInstances = 
			new ArrayList<gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType>(series.getImageCount());
		
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType[] seriesInstances = null;

		for(Image image : series)
		{
			gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType instanceType = translate(image);
			if(instanceType != null)
				validInstances.add(instanceType);
		}
		seriesInstances = 
			validInstances.toArray(new gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType[validInstances.size()]);
		
		//TODO: retrieve series through VistA if possible (available in DICOM txt files)
		result.setDescription(study.getDescription());

		result.setModality(series.getModality());
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (series.getSeriesUid() != null && series.getSeriesUid().trim().length() > 0)
		{
			result.setDicomUid(series.getSeriesUid());
		}
		
		if(!"".equals(series.getSeriesNumber())) {
			int serNum = Integer.parseInt(series.getSeriesNumber());
			result.setDicomSeriesNumber(serNum);
		}
		//TODO: do we want to have a series URN or should we just use the series IEN from VistA?
		result.setSeriesId(series.getSeriesIen());
		result.setImageCount(seriesInstances.length);
//		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances instancesWrapper = 
//			new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances();
//		instancesWrapper.setInstance(seriesInstances);
//		result.setComponentInstances(instancesWrapper);
		
		return result;
	}
	
	// translate 19
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType translate(Image image)
	throws TranslationException
	{
		if(image == null)
			return null;
		// JMW 7/17/08 - if the image has an error message then don't provide the image to the DOD
		if(image.hasErrorMessage())
		{
            logger.debug("translate(19) --> Image [{}] has error message, excluding from results.", image.getIen());
			return null;
		}
		if(image.isDeleted())
		{
            logger.debug("translate(19) --> Image [{}] is deleted, excluding from results.", image.getIen());
			return null;
		}
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType instanceType = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType();
		
		if(image.getGlobalArtifactIdentifier() instanceof ImageURN)
			instanceType.setImageUrn(image.getGlobalArtifactIdentifier().toString());
		else if(image.getGlobalArtifactIdentifier() instanceof BhieImageURN)
			instanceType.setImageUrn( ((BhieImageURN)image.getGlobalArtifactIdentifier()).toString());
		else
			try
			{
				instanceType.setImageUrn( (ImageURNFactory.create(image.getSiteNumber(), 
						image.getIen(), image.getStudyIen(), image.getPatientId(), image.getImageModality(), ImageURN.class)).toString() );
			}
			catch (URNFormatException x)
			{
				throw new TranslationException(x);
			}
		
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (image.getImageUid()!= null && image.getImageUid().trim().length() > 0)
		{
			instanceType.setDicomUid(image.getImageUid().trim());
		}
		
		if (image.getDicomImageNumberForDisplay()!= null && image.getImageNumber().trim().length() > 0)
		{
			try
			{
				Integer imageNumber = new Integer(image.getImageNumber());
				instanceType.setDicomInstanceNumber(imageNumber);
			}
			catch (NumberFormatException ex)
			{
				// not a number - return null
				instanceType.setDicomInstanceNumber(null);
			}
		}
		else
		{
			instanceType.setDicomInstanceNumber(null);
		}
		
		return instanceType;
	}
	
	public static gov.va.med.imaging.mix.webservices.rest.types.v1.ReportType translateToStudyReport(Study study)
	throws TranslationException
	{
		gov.va.med.imaging.mix.webservices.rest.types.v1.ReportType result = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.ReportType();
		
		result.setPatientId(study.getPatientId());
		result.setProcedureCodes(translateCptCodeToReportProcedureCode(study.getCptCode()));
		try
		{
			result.setProcedureDate(translate(study.getProcedureDate()));
		}
		catch(ParseException pX)
		{
			throw new TranslationException("MixTranslatorV1.translateToStudyReport() --> ParseException unable to translate study procedure date, " + pX.getMessage(), pX);
		}
		//TODO: what to do if report is missing or something?
		result.setRadiologyReport(study.getRadiologyReport());
		result.setSiteAbbreviation(study.getSiteAbbr());
		result.setSiteName(study.getSiteName());
		result.setSiteNumber(study.getSiteNumber());
		result.setStudyId(study.getStudyUrn().toString());
		return result;
	}
	
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.ReportTypeProcedureCodes translateCptCodeToReportProcedureCode(String cptCode)
	{
		gov.va.med.imaging.mix.webservices.rest.types.v1.ReportTypeProcedureCodes result = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.ReportTypeProcedureCodes();
		
		String [] cptCodes = new String[1];
		
		// cannot be null value (according to the WSDL)
		cptCodes[0] = (cptCode == null ? "" : "" + cptCode);
		result.setCptCode(cptCodes);
		
		return result;
	}
	
	private static gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeProcedureCodes translateCptCodeToStudyProcedureCode(String cptCode)
	{		
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeProcedureCodes result = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeProcedureCodes();
		
		String [] cptCodes = new String[1];
		
		// cannot be null value (according to the WSDL)
		cptCodes[0] = (cptCode == null ? "" : "" + cptCode);
		result.setCptCode(cptCodes);
		
		return result;
	}
	
	// translate 20
	private static String translate(Date procedureDate) 
	throws ParseException
	{
		String procedureDateStringAsDicom = "";
		
		if(procedureDate != null)
		{
			DateFormat dicomDateFormat = new DicomDateFormat();
			procedureDateStringAsDicom = dicomDateFormat.format(procedureDate);
		}
		
		return procedureDateStringAsDicom;
	}
	
	/**
	 * Helper method to abstract out the real accession number from given String
	 * 
	 * @param String		given accession number from ECIA
	 * @return String		result of abstraction or null
	 * 
	 */
	private static String getAccessionNumber(String eciaAccNumber) {
		
		String accNumber = null;
		
		// formats: 55555, 4444, null or empty = do nothing, return null
		if( !(eciaAccNumber == null || eciaAccNumber.length() <= 5) ) { 
			if(eciaAccNumber.contains("-")) { // format: 0125-11120846
				accNumber = eciaAccNumber.substring(5);
			} else if (Character.isLetter(eciaAccNumber.charAt(5))) { // format: 00125XR200081314
				accNumber = eciaAccNumber.substring(7);
			} else { // The only format left: 01251111111
				accNumber = eciaAccNumber.substring(4);
			}
		}
		
		return accNumber;
	}


}
