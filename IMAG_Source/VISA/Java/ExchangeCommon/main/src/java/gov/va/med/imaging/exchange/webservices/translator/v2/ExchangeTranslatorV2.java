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
package gov.va.med.imaging.exchange.webservices.translator.v2;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.Map.Entry;

import gov.va.med.logging.Logger;

import gov.va.med.*;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.imaging.BhieImageURN;
import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.DateUtil;
import gov.va.med.imaging.DicomDateFormat;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.exceptions.StudyURNFormatException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ExchangeArtifactResultError;
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

/**
 * @author vhaiswwerfej
 *
 */
@SuppressWarnings("deprecation")
public class ExchangeTranslatorV2
{
	private final static Logger LOGGER = Logger.getLogger(ExchangeTranslatorV2.class);
	
	private static Map<ArtifactResultErrorCode, gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorCodeType> errorCodeMap;
	private static Map<ArtifactResultErrorSeverity, gov.va.med.imaging.exchange.webservices.soap.types.v2.SeverityType> severityMap;
	
	static
	{
		errorCodeMap = new HashMap<ArtifactResultErrorCode, gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorCodeType>();
		errorCodeMap.put(ArtifactResultErrorCode.authorizationException, gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorCodeType.AuthorizationException);
		errorCodeMap.put(ArtifactResultErrorCode.internalException, gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorCodeType.InternalException);
		errorCodeMap.put(ArtifactResultErrorCode.invalidRequestException, gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorCodeType.InvalidRequestException);
		errorCodeMap.put(ArtifactResultErrorCode.timeoutException, gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorCodeType.TimeoutException);
		
		severityMap = new HashMap<ArtifactResultErrorSeverity, gov.va.med.imaging.exchange.webservices.soap.types.v2.SeverityType>();
		severityMap.put(ArtifactResultErrorSeverity.error, gov.va.med.imaging.exchange.webservices.soap.types.v2.SeverityType.error);
		severityMap.put(ArtifactResultErrorSeverity.warning, gov.va.med.imaging.exchange.webservices.soap.types.v2.SeverityType.warning);
	}
	
	// translate 1
	public static StudySetResult translate(
			gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType studyListResponseType,
			Site site, 
			StudyFilter studyFilter,
			List<String> emptyStudyModalities)
	{
		if(studyListResponseType == null) {
			LOGGER.debug("ExchangeTranslatorV2.translate(1) --> Given studyListResponseType is null.  Return null.");
			return null;
		}
		
		ArtifactResultStatus artifactResultStatus = (studyListResponseType.isPartialResponse() ? ArtifactResultStatus.partialResult : ArtifactResultStatus.fullResult);
		List<ArtifactResultError> artifactResultErrors = translate(studyListResponseType.getErrors());
		SortedSet<Study> studies = translate(studyListResponseType.getStudies(), site, studyFilter, emptyStudyModalities);
		
		return StudySetResult.create(studies, artifactResultStatus, artifactResultErrors);
	}
	
	public static String translate(gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType report)
	{
		return "1^^\n" + (report == null ? "" : report.getRadiologyReport());
	}
	
	// translate 2
	private static SortedSet<Study> translate(
			gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType [] studies,
			Site site, 
			StudyFilter studyFilter, 
			List<String> emptyStudyModalities)
	{
		// Improve a bit
		if(studies == null) {
			LOGGER.debug("ExchangeTranslatorV2.translate(2) --> Given StudyType array is null.  Return null.");
			return null;
		}
		
		SortedSet<Study> result = new TreeSet<Study>();
		String filterStudyAsString = studyFilter != null && studyFilter.getStudyId() != null ?
				studyFilter.getStudyId() instanceof StudyURN ? ((StudyURN)studyFilter.getStudyId()).toString(SERIALIZATION_FORMAT.NATIVE) : studyFilter.getStudyId().toString() : 
				null;
		for(gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType studyType : studies)
		{
			// Fortify change: check for null first. Will never happen but fixed anyway.
			if(studyType == null) {
				LOGGER.debug("ExchangeTranslatorV2.translate(2) --> Given a StudyType object is null.  Skip it and continue processing....");
				continue;
			}

			Study study = null;
			
			if( studyFilter != null && studyFilter.getStudyId() != null )
			{
				// Fortify change: check for null first; second round. Didn't like the first round (only half of null check??)
				if(filterStudyAsString !=  null && filterStudyAsString.equals(studyType.getStudyId()))
					study = translate(studyType, site, emptyStudyModalities);
			}
			else
			{
				study = translate(studyType, site, emptyStudyModalities);
			}
			
			if(study != null)
			{
				result.add(study);
			}
		}				
		return result;
	}
	
	// translate 3
	private static Study translate(gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType studyType, 
			Site site, List<String> emptyStudyModalities)
	{
		if(studyType == null)
			return null;
		
		String studyId = studyType.getStudyId();
		
		Study study = null;
		StudyURN studyIdentifier = null;

		try
		{
			studyIdentifier = URNFactory.create(studyId, StudyURN.class);
		}
		catch (URNFormatException x)
		{
            LOGGER.warn("ExchangeTranslatorV2.translate(3) --> Return null: Unable to create Study Id using URNFactory for given Id [{}]: {}", studyId, x.getMessage());
			return null;
		}
		
		if(studyIdentifier == null)
		{
			try
			{
				GlobalArtifactIdentifier identifier = GlobalArtifactIdentifierFactory.create(studyId);
				if(identifier instanceof StudyURN)
					studyIdentifier = (StudyURN)identifier;
			}
			catch (GlobalArtifactIdentifierFormatException x)
			{
                LOGGER.warn("ExchangeTranslatorV2.translate(3) --> Return null: Unable to create Study Id using GlobalArtifactIdentifierFactory for given Id [{}]: {}", studyId, x.getMessage());
				return null;
			}
            LOGGER.info("ExchangeTranslatorV2.translate(3) --> Study Id [{}] created by GlobalArtifactIdentifierFactory.", studyIdentifier.toString());
		}
		else
            LOGGER.info("ExchangeTranslatorV2.translate(3) --> Study Id [{}] created by URNFactory.", studyIdentifier.toString());
			
		
		// BHIE identifiers are unique in that the patient ID must be set explicitly rather than
		// as part of the stringified representation of the ID
		// set the patient ID regardless of whether the URN is a BHIE or VA
		try
		{
			studyIdentifier.setPatientId(studyType.getPatientId());
			studyIdentifier.setPatientIdentifierTypeIfNecessary(PatientIdentifierType.icn);
		}
		catch (StudyURNFormatException x)
		{
            LOGGER.error("ExchangeTranslatorV2.translate(3) --> StudyURNFormatException: patient Id [{}] format is invalid: {}", studyType.getPatientId(), x.getMessage());
			return null;
		}
		
		// v2 does not include the report
		study = Study.create(studyIdentifier, StudyLoadLevel.STUDY_AND_IMAGES, StudyDeletedImageState.cannotIncludeDeletedImages);

		study.setAlienSiteNumber(studyType.getSiteNumber());
		study.setDescription(studyType.getDescription() == null ? "" : studyType.getDescription());
		study.setStudyUid(studyType.getDicomUid());
		study.setImageCount(studyType.getImageCount());
		
		//The BHIE framework is not capable of providing the patient name for now
		if (studyType.getPatientName() == null)
			study.setPatientName("");
		else
			study.setPatientName(studyType.getPatientName().replaceAll("\\^", " "));
		study.setProcedureDate(translateDICOMDateToDate(studyType.getProcedureDate()));
		study.setProcedure(studyType.getProcedureDescription() == null ? "" : studyType.getProcedureDescription());
			
		study.setRadiologyReport(null); //v2 does not include study report
		
		study.setSiteName(studyType.getSiteName() == null ? "" : studyType.getSiteName());
		study.setSpecialty(studyType.getSpecialtyDescription() == null ? "" : studyType.getSpecialtyDescription());
		
		if(studyIdentifier instanceof BhieStudyURN)
		{
			study.setOrigin("DOD"); // hard code the origin to the DOD so it displays on the Display client image list window
			study.setSiteAbbr("DOD"); // needed because CPS test rig no longer passes us useful information
		}
		else
		{
			study.setSiteAbbr(site.getSiteAbbr());
			study.setOrigin(site.getSiteAbbr());
		}
		
		Image firstImage = null;		
		gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType []series = studyType.getComponentSeries().getSeries();
		if(series != null) {
			for(int i = 0; i < series.length; i++) {
				Series newSeries = translate(series[i], study, site);
				study.addSeries(newSeries);
				// first series
				if(i == 0) {
					Iterator<Image> imageIter = newSeries.iterator();
					if(imageIter.hasNext()) {
						firstImage = imageIter.next();
					}
				}
			}
		}
		
		if(firstImage == null)
		{
            LOGGER.info("ExchangeTranslatorV2.translate(3) --> Creating fake first image for study URN [{}], study has [{} image(s).", study.getStudyUrn().toString(), study.getImageCount());
			firstImage = createdCannedFirstImage(study, site);
		}
		
		study.setFirstImage(firstImage);
		
		if(studyType.getModalities() != null) 
		{		
			String[] modalities = studyType.getModalities().getModality();
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
					study.addModality(modalities[i]);
					// JMW 1/11/2010 P104 - special case for PR modality studies
					// these studies have no image, set the image count to 0 regardless of what the BIA says
					// JMW 4/11/2011 P104
					boolean thisModalityEmptyStudyFound = false;
					for(String emptyStudyModality : emptyStudyModalities)
					{
						if(modalities[i].equals(emptyStudyModality))
						{
							// found a modality that does not contain any images
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
				if(emptyStudyModalityFound && !nonEmptyStudyModalityFound)
				{
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
		
		if(studyType.getProcedureCodes() != null)
		{
			// The DoD may provide more than one cpt code, we are only going to grab the first one
			String [] cptCodes = studyType.getProcedureCodes().getCptCode();
			if((cptCodes != null) && (cptCodes.length > 0))
			{
				study.setCptCode(cptCodes[0]);
			}
		}
		
		return study;
	}
	
	/**
	 * In some cases we are seeing studies come back from the BIA that do not have any images in them.
	 * Most of these are from Landstuhl.  The CVIX in Federation V4 and the Clinical Display client both
	 * do not handle a null first image in the study.  To fix this issue we create a "fake" image for the first
	 * image field but it is not actually included in the study
	 * @param study
	 * @return
	 */
	private static Image createdCannedFirstImage(Study study, ArtifactSource artifactSource)
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
			imageUrn.setStudyId(studyUrn==null ? null : studyUrn.getStudyId());
			imageUrn.setPatientId(study.getPatientId());
			imageUrn.setPatientIdentifierTypeIfNecessary(study.getPatientIdentifierType());
			imageUrn.setImageModality("");
		}
		catch (URNFormatException urnfX)
		{
            LOGGER.error("ExchangeTranslatorV2.createdCannedFirstImage() --> Retrun null. URNFormatException: image URN for study URN [{}]: {}", studyUrn.toString(), urnfX.getMessage());
			return null;
		}
		
		Image image = Image.create(imageUrn);
		image.setAbsFilename("-1");
		image.setFullFilename("-1");
		image.setBigFilename("-1");
		image.setImageNumber("");
		image.setImageUid("");
		image.setDescription(study.getDescription());
		image.setPatientName(study.getPatientName());
		image.setProcedureDate(study.getProcedureDate());
		image.setProcedure(study.getProcedure());
		
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

	// translate 4
	private static Series translate(
			gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType seriesType,
			Study study,
			Site site) 
	{
		if(seriesType == null || study == null)
		{
			LOGGER.warn("ExchangeTranslatorV2.translate(4) --> Return null because given " + 
				seriesType == null ? "null series" : "" + 
				study == null ? "null study " : "");
			return null;
		}
		
		Series series = Series.create(
			ExchangeUtil.isSiteDOD(site) ? ObjectOrigin.DOD : ObjectOrigin.VA, 
			seriesType.getSeriesId(), 
			seriesType.getDicomUid()
		);
		
		series.setSeriesNumber(seriesType.getDicomSeriesNumber() == null ? "" : seriesType.getDicomSeriesNumber() + "");
		series.setSeriesUid(seriesType.getDicomUid() == null ? "" : seriesType.getDicomUid());
		series.setModality(seriesType.getModality());
		
		gov.va.med.imaging.exchange.webservices.soap.types.v2.InstanceType [] instances = 
			seriesType.getComponentInstances().getInstance();
		
		if(instances != null) {
			for(int i = 0; i < instances.length; i++) {
				Image image = translate(instances[i], site, study, series);
				series.addImage(image);
			}
		}
		return series;
	}
	
	// translate 5
	private static Image translate(
			gov.va.med.imaging.exchange.webservices.soap.types.v2.InstanceType instance,
			ArtifactSource artifactSource,
			Study study,
			Series series) 
	{
		if(instance == null || series == null || study == null)
		{
			LOGGER.warn("ExchangeTranslatorV2.translate(5) --> Return null because given instance or seriesType or StudyType parameter is null.");
			return null;
		}
		
		ImageURN imageUrn = null;
		StudyURN studyUrn = study.getStudyUrn();		
		
		try
		{
			imageUrn = URNFactory.create(instance.getImageUrn(), ImageURN.class);
			imageUrn.setStudyId(studyUrn==null ? null : studyUrn.getStudyId());
			imageUrn.setPatientId(study.getPatientId());
			imageUrn.setPatientIdentifierTypeIfNecessary(study.getPatientIdentifierType());
			imageUrn.setImageModality(series.getModality() == null ? "" : series.getModality());
		}
		catch (URNFormatException urnfX)
		{
            LOGGER.warn("ExchangeTranslatorV2.translate(5) --> Error making URN from image Id [{}]: {}", instance.getImageUrn(), urnfX.getMessage());
			return null;
		}
		
		
		Image image = Image.create(imageUrn);

		image.setImageNumber(instance.getDicomInstanceNumber() + "");
		image.setImageUid(instance.getDicomUid() == null ? "" : instance.getDicomUid());
		image.setDescription(study.getDescription());
		image.setPatientName(study.getPatientName());
		image.setProcedureDate(study.getProcedureDate());
		image.setProcedure(study.getProcedure());
		
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
		image.setDicomImageNumberForDisplay(instance.getDicomInstanceNumber() == null ? "" : instance.getDicomInstanceNumber() + "");
		image.setDicomSequenceNumberForDisplay(series.getSeriesNumber());
		image.setImgType(VistaImageType.DICOM.getImageType()); // radiology
		
		return image;
	}
	
	private static Date translateDICOMDateToDate(String dicomDate)
	{
		if((dicomDate == null) || (dicomDate.equals(""))) {
			return null;// Date();
		}
		if(dicomDate.length() < 8) {
			return null;
		}
		
		//TODO: update this function to handle if only part of the date is given (no month, etc)
		//TODO: month and day are now required, do a check for length and parse on that
		//TODO: if the date is invalid, should this throw an exception or always get full list of studies?
		//String dicomDate = "20061018143643.655321+0200";
		//SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss", Locale.US);
		
		String format = getDateFormat(dicomDate);
	
		if("".equals(format))
			return null;
	
		SimpleDateFormat sdf = new SimpleDateFormat(format, Locale.US);
		Date d = null;
		try 
		{
			d = sdf.parse(dicomDate);
			return d;
		}
		catch(ParseException pX) {
            LOGGER.error("ExchangeTranslatorV2.translateDICOMDateToDate() --> ParseException for DICOM date [{}]: {}", dicomDate, pX.getMessage());
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
	
	// translate 6
	private static List<ArtifactResultError> translate(gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType [] errors)
	{
		if(errors == null)
			return null;
		
		List<ArtifactResultError> result = new ArrayList<ArtifactResultError>();
		
		for(gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType error : errors)
		{
			result.add(translate(error));
		}		
		
		return result;
	}
	
	// translate 7
	private static ArtifactResultError translate(gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType error)
	{
		ArtifactResultErrorCode errorCode = translate(error.getErrorCode());
		ArtifactResultErrorSeverity severity = translate(error.getSeverity()); 
		return new ExchangeArtifactResultError(error.getCodeContext(), error.getLocation(), 
				errorCode, severity);
	}
	
	// translate 8
	public static gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType translate(StudyFilter studyFilter)
	{
		StudyURN studyUrn = (StudyURN)studyFilter.getStudyId();
		gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType ft = studyFilter == null ? 
				new gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType() : 
				new gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType(
						studyFilter.getFromDate() == null ? null : DateUtil.getDicomDateFormat().format(studyFilter.getFromDate()), 
								studyFilter.getToDate() == null ? null : DateUtil.getDicomDateFormat().format(studyFilter.getToDate()), 
					studyUrn == null ? null : studyUrn.toString(SERIALIZATION_FORMAT.NATIVE));
				return ft;
	}
	
	// translate 9
	public static gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType translate(
			StudySetResult studySetResult)
	throws TranslationException
	{
		if(studySetResult == null)
			return null;
		// consistent with V1 translator
		if((studySetResult.getArtifacts() == null) || (studySetResult.getArtifacts().size() == 0))
			return null;
		
		gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType result = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType();
		
		result.setPartialResponse(studySetResult.isPartialResult());
		gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType [] studyTypes = 
			translate(studySetResult.getArtifacts());
        LOGGER.info("ExchangeTranslatorV2.translate(8) --> Translated [{}] study(ies) into study type(s) to return in Exchange interface", studyTypes == null ? "null" : studyTypes.length);
		result.setStudies(studyTypes);
		result.setErrors(translate(studySetResult.getArtifactResultErrors()));
		
		return result;
	}
	
	// translate 10
	private static gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType[] translate(
			List<ArtifactResultError> artifactResultErrors)
	{
		if(artifactResultErrors == null)
			return null;
		
		gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType []result =
			new gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType[artifactResultErrors.size()];
		
		int i = 0;
		for(ArtifactResultError artifactResultError : artifactResultErrors)
		{
			result[i] = translate(artifactResultError);
			i++;
		}
		
		return result;
	}
	
	// translate 11
	private static gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType translate(
			ArtifactResultError artifactResultError)
	{
		gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType result = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType();
		
		result.setCodeContext(artifactResultError.getCodeContext());
		result.setLocation(artifactResultError.getLocation());
		result.setErrorCode(translate(artifactResultError.getErrorCode()));
		result.setSeverity(translate(artifactResultError.getSeverity()));
		
		return result;
	}
	
	// translate 12
	private static ArtifactResultErrorCode translate(gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorCodeType errorCodeType)
	{
		for(Entry<ArtifactResultErrorCode, gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorCodeType> entry : errorCodeMap.entrySet())
		{
			if(entry.getValue() == errorCodeType)
				return entry.getKey();
		}
		return ArtifactResultErrorCode.internalException;
	}
	
	private static gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorCodeType translate(ArtifactResultErrorCode artifactResultErrorCode)
	{
		for(Entry<ArtifactResultErrorCode, gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorCodeType> entry : errorCodeMap.entrySet())
		{
			if(entry.getKey() == artifactResultErrorCode)
				return entry.getValue();
		}
		return gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorCodeType.InternalException;
	}
	
	// translate 13
	private static gov.va.med.imaging.exchange.webservices.soap.types.v2.SeverityType translate(ArtifactResultErrorSeverity artifactResultErrorSeverity)
	{
		for(Entry<ArtifactResultErrorSeverity, gov.va.med.imaging.exchange.webservices.soap.types.v2.SeverityType> entry : severityMap.entrySet())
		{
			if(entry.getKey() == artifactResultErrorSeverity)
			{
				return entry.getValue();
			}
		}
		return gov.va.med.imaging.exchange.webservices.soap.types.v2.SeverityType.error;
	}
	
	// translate 14
	private static ArtifactResultErrorSeverity translate(gov.va.med.imaging.exchange.webservices.soap.types.v2.SeverityType severityType)
	{
		for(Entry<ArtifactResultErrorSeverity, gov.va.med.imaging.exchange.webservices.soap.types.v2.SeverityType> entry : severityMap.entrySet())
		{
			if(entry.getValue() == severityType)
			{
				return entry.getKey();
			}
		}
		return ArtifactResultErrorSeverity.error;
	}
	
	// translate 15
	private static gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType [] translate(SortedSet<Study> studies)
	throws TranslationException
	{
		// not all studies in the result might be included (deleted or error studies are not included)
		
		List<gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType> result = 
			new ArrayList<gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType>();
		
		for(Study study : studies)
		{
			gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType studyType = translate(study);
			if(studyType != null)
				result.add(studyType);
		}
		
		return result.toArray(new gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType[result.size()]);
	}
	
	// translate 16
	private static gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType translate(Study study)
	throws TranslationException
	{
		if(study == null)
			return null;
		// don't return the study if there is a questionable integrity/error condition
		if(study.hasErrorMessage())
		{
            LOGGER.debug("ExchangeTranslatorV2.translate(16) --> Study [{}] has error message, excluding from results.", study.getStudyIen());
			return null;
		}
		if(study.isDeleted())
		{
            LOGGER.debug("ExchangeTranslatorV2.translate(16) --> Study [{}] is deleted, excluding from results.", study.getStudyIen());
			return null;
		}
		gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType result = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType();
		
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
			throw new TranslationException("ExchangeTranslatorV2.translate(16) --> ParseException unable to translate study procedure date [" + study.getProcedureDate() + "]: " + pX.getMessage());
		}
		
		result.setProcedureDescription(study.getProcedure());
		result.setPatientId(study.getPatientId());
		result.setPatientName(study.getPatientName());
		result.setSiteNumber(study.getSiteNumber());
		result.setSiteAbbreviation(study.getSiteAbbr());
		result.setSpecialtyDescription(study.getSpecialty());
		result.setSiteName(study.getSiteName());
		
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (study.getStudyUid() != null && study.getStudyUid().trim().length() > 0)
		{
			result.setDicomUid(study.getStudyUid());
		}
		
		gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyTypeComponentSeries wrapper = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyTypeComponentSeries();
		
		gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType[] componentSeries = 
			translate(study.getSeries(), study);

		// JMW 7/16/08 accurately get the number of images by actually counting the images from each
		// series
		// This has to be done this way because while the internal count of images is now accurate, 
		// we might not give all of the internal images through this interface, this interface excludes
		// all questionable integrity images and studies/images with other problems.
		int imageCount = 0;
		for(gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType series : componentSeries)
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
			gov.va.med.imaging.exchange.webservices.soap.types.v2.ModalitiesType modalitiesType = 
				new gov.va.med.imaging.exchange.webservices.soap.types.v2.ModalitiesType(modalities);
			result.setModalities(modalitiesType);
		}
		
		return result;
	}
	
	// translate 17
	private static gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType[] translate(
			Set<Series> serieses, Study study)
	throws TranslationException
	{
		List<gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType> result = 
			new ArrayList<gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType>();
		
		for(Series series : serieses)
		{
			// Filter series with no images from the result set - DKB
			if(series.getImageCount() > 0)
			{
				gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType seriesType = 
					translate(series, study);	
				if(seriesType != null)
					result.add(seriesType);
			}
		}
		
		return result.toArray(new gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType[result.size()]);
	}
	
	// translate 18
	private static gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType translate(Series series,
			Study study)
	throws TranslationException
	{
		if(series == null)
			return null;
		gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType result = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType();
		
		List<gov.va.med.imaging.exchange.webservices.soap.types.v2.InstanceType> validInstances = 
			new ArrayList<gov.va.med.imaging.exchange.webservices.soap.types.v2.InstanceType>(series.getImageCount());
		
		
		gov.va.med.imaging.exchange.webservices.soap.types.v2.InstanceType[] seriesInstances = null;

		for(Image image : series)
		{
			gov.va.med.imaging.exchange.webservices.soap.types.v2.InstanceType instanceType = translate(image);
			if(instanceType != null)
				validInstances.add(instanceType);
		}
		seriesInstances = 
			validInstances.toArray(new gov.va.med.imaging.exchange.webservices.soap.types.v2.InstanceType[validInstances.size()]);
		
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
		gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesTypeComponentInstances instancesWrapper = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesTypeComponentInstances();
		instancesWrapper.setInstance(seriesInstances);
		result.setComponentInstances(instancesWrapper);
		
		return result;
	}
	
	// translate 19
	private static gov.va.med.imaging.exchange.webservices.soap.types.v2.InstanceType translate(Image image)
	throws TranslationException
	{
		if(image == null)
			return null;
		// JMW 7/17/08 - if the image has an error message then don't provide the image to the DOD
		if(image.hasErrorMessage())
		{
            LOGGER.debug("ExchangeTranslatorV2.translate(19) --> Return null: Image [{}] has error message, excluding from results.", image.getIen());
			return null;
		}
		if(image.isDeleted())
		{
            LOGGER.debug("ExchangeTranslatorV2.translate(19) --> Return null: Image [{}] is deleted, excluding from results.", image.getIen());
			return null;
		}
		
		gov.va.med.imaging.exchange.webservices.soap.types.v2.InstanceType instanceType = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v2.InstanceType();
		
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
	
	public static gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType translateToStudyReport(Study study)
	throws TranslationException
	{
		gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType result = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType();
		
		result.setPatientId(study.getPatientId());
		result.setProcedureCodes(translateCptCodeToReportProcedureCode(study.getCptCode()));
		try
		{
			result.setProcedureDate(translate(study.getProcedureDate()));
		}
		catch(ParseException pX)
		{
			throw new TranslationException("ExchangeTranslatorV2.translateToStudyReport() --> ParseException unable to translate study procedure date [" + study.getProcedureDate() + "]: " + pX.getMessage());
		}
		//TODO: what to do if report is missing or something?
		result.setRadiologyReport(study.getRadiologyReport());
		result.setSiteAbbreviation(study.getSiteAbbr());
		result.setSiteName(study.getSiteName());
		result.setSiteNumber(study.getSiteNumber());
		result.setStudyId(study.getStudyUrn().toString());
		
		return result;
	}
	
	private static gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportTypeProcedureCodes translateCptCodeToReportProcedureCode(String cptCode)
	{
		gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportTypeProcedureCodes result = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportTypeProcedureCodes();
		
		String [] cptCodes = new String[1];
		
		// cannot be null value (according to the WSDL)
		cptCodes[0] = (cptCode == null ? "" : cptCode);
		result.setCptCode(cptCodes);
		
		return result;
	}
	
	private static gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyTypeProcedureCodes translateCptCodeToStudyProcedureCode(String cptCode)
	{		
		gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyTypeProcedureCodes result = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyTypeProcedureCodes();
		
		String [] cptCodes = new String[1];
		
		// cannot be null value (according to the WSDL)
		cptCodes[0] = (cptCode == null ? "" : cptCode);
		result.setCptCode(cptCodes);
		
		return result;
	}
	
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
}
