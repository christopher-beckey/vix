/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 1, 2009
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
package gov.va.med.imaging.clinicaldisplay.webservices.translator;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.*;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.ImageAccessLogEvent.ImageAccessLogEventType;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.exchange.enums.SiteConnectivityStatus;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PingServerTypePingResponse;

import java.math.BigInteger;
import java.text.DateFormat;
import java.text.ParseException;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayTranslator4 
extends AbstractBaseClinicalDisplayTranslator
{
	private final static Logger LOGGER = Logger.getLogger(ClinicalDisplayTranslator4.class);
	
	public ClinicalDisplayTranslator4()
	{
		super();
	}	
	
	/**
	 * Transform a clinical display webservice FilterType to an internal Filter instance.
	 * 
	 */
	public StudyFilter transformFilter(gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.FilterType filterType,
			int authorizedSensitiveLevel) 
	{
		StudyFilter filter = new StudyFilter();
		
		if(filterType != null) 
		{
			DateFormat df = getClinicalDisplayWebserviceShortDateFormat();
			
			Date fromDate = null;
			try
			{
				fromDate = filterType.getFromDate() == null  || filterType.getFromDate().length() == 0 ? null : df.parse(filterType.getFromDate());
			} 
			catch (ParseException x)
			{
                LOGGER.warn("ClinicalDisplayTranslator4.transformFilter() --> Could not convert 'from date' [{}] to internal Date: {}", filterType.getFromDate(), x.getMessage());
			}
			
			Date toDate = null;
			try
			{
				toDate = filterType.getToDate() == null || filterType.getToDate().length() == 0 ? null : df.parse(filterType.getToDate());
			} 
			catch (ParseException x)
			{
                LOGGER.warn("ClinicalDisplayTranslator4.transformFilter() --> Could not convert 'to date' [{}] to internal Date: {}", filterType.getToDate(), x.getMessage());
			}
			
			// some business rules for the filter dates
			if (fromDate != null && toDate == null)
			{
				// default toDate to today
				toDate = new Date();
			}
			else if (fromDate == null && toDate != null)
			{
				// default to unfiltered
				toDate = null;
			}
			
			filter.setFromDate(fromDate);
			filter.setToDate(toDate);
			
			filter.setStudy_class(filterType.get_class() == null ? "" : filterType.get_class());
			filter.setStudy_event(filterType.getEvent() == null ? "" : filterType.getEvent());
			filter.setStudy_package(filterType.get_package() == null ? "" : filterType.get_package());
			filter.setStudy_specialty(filterType.getSpecialty() == null ? "" : filterType.getSpecialty());
			filter.setStudy_type(filterType.getTypes() == null ? "" : filterType.getTypes());
			
			if(filterType.getOrigin() == null) {
				filter.setOrigin("");
			}
			else {
				if("UNSPECIFIED".equals(filterType.getOrigin().getValue())) {
					filter.setOrigin("");
				}
				else {
					filter.setOrigin(filterType.getOrigin().getValue());
				}
			}
			// don't have a study id used here
		}
		filter.setMaximumAllowedLevel(PatientSensitivityLevel.getPatientSensitivityLevel(authorizedSensitiveLevel));
		return filter;
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesType transformStudiesToShallowStudies(
			ArtifactResults artifactResults) 
		throws URNFormatException 
	{
		if(artifactResults == null)
			return null;
		
		if(artifactResults.getStudySetResult() == null)
			return null;
		
		return transformStudiesToShallowStudies(artifactResults.getStudySetResult().getArtifacts());
	}
	
	private gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesType transformStudiesToShallowStudies(
		Collection<Study> studyList) 
	throws URNFormatException 
	{
		if(studyList == null || studyList.size() == 0)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesType();
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudyType [] res = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudyType[studyList.size()];
		
		int index=0;
		for(Iterator<Study> studiesIter = studyList.iterator(); studiesIter.hasNext(); ++index)
			res[index] = transformStudyToShallowStudy(studiesIter.next());
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesStudiesType holder = new 
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesStudiesType();
		holder.setStudy(res);
		result.setStudies(holder);
		
		return result;
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesType transformExceptionToShallowStudiesType(
		InsufficientPatientSensitivityException ipsX)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesType();
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesErrorMessageType errorType = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesErrorMessageType();
		errorType.setErrorCode(BigInteger.valueOf(ipsX.getSensitiveValue().getSensitiveLevel().getCode()));
		errorType.setErrorMessage(ipsX.getSensitiveValue().getWarningMessage());
		errorType.setShallowStudiesError(gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesErrorType.INSUFFICIENT_SENSITIVE_LEVEL);
		result.setError(errorType);
		return result;
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudyType transformStudyToShallowStudy(
		Study study) 
	throws URNFormatException 
	{
		if(study == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudyType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudyType();
		
		result.setDescription(extractIllegalCharacters(study.getDescription()));
		result.setEvent(extractIllegalCharacters(study.getEvent()));
		result.setImageCount(BigInteger.valueOf(study.getImageCount()));
		result.setImagePackage(extractIllegalCharacters(study.getImagePackage()));
		result.setImageType(study.getImageType());
		result.setNoteTitle(extractIllegalCharacters(study.getNoteTitle()));
		result.setOrigin(extractIllegalCharacters(study.getOrigin()));
		result.setPatientIcn(study.getPatientId());
		result.setPatientName(study.getPatientName());
		result.setProcedure(extractIllegalCharacters(study.getProcedure()));
		result.setSiteNumber(study.getSiteNumber());
		result.setSpecialty(extractIllegalCharacters(study.getSpecialty()));
		
		// 2/19/08 - now include the site name so the Display client shows what specific DOD facility the study is from
		if(ExchangeUtil.isSiteDOD(study.getSiteNumber()))
		{
			result.setSiteAbbreviation(study.getSiteAbbr() + (study.getSiteName() != null ? "-" + study.getSiteName() : ""));			
		}
		else
		{
			result.setSiteAbbreviation(study.getSiteAbbr());
		}				
		result.setStudyPackage(extractIllegalCharacters(study.getImagePackage()));
		result.setStudyClass(extractIllegalCharacters(study.getStudyClass() == null ? "" : study.getStudyClass())); // get this from study
		result.setStudyType(extractIllegalCharacters(study.getImageType()));
		result.setCaptureDate(study.getCaptureDate());
		result.setCapturedBy(study.getCaptureBy());		
		if(study.getProcedureDate() == null)
		{
			LOGGER.warn("ClinicalDisplayTranslator4.transformStudyToShallowStudy() --> Setting empty procedure date for study");
			result.setProcedureDate("");
		}
		else
		{
			if((study.getProcedureDateString() == null) || (study.getProcedureDateString().length() <= 0))
			{
				// if the hour and minute are not 0, then likely they contain real values for hour and minute (not 00:00)
				// this leaves open the possibility of invalid data, if the real date was at 00:00 then this would not show that time.
				// we would then omit data, not show invalid data
				if((study.getProcedureDate().getHours() <= 0) && (study.getProcedureDate().getMinutes() <= 0))
				{
					result.setProcedureDate(getClinicalDisplayWebserviceShortDateFormat().format(study.getProcedureDate()));
				}
				else
				{
					result.setProcedureDate(getClinicalDisplayWebserviceLongDateFormat().format(study.getProcedureDate()));
				}
				
			}
			else if(study.getProcedureDateString().length() > 10)
			{
				result.setProcedureDate(getClinicalDisplayWebserviceLongDateFormat().format(study.getProcedureDate()));
			}
			else {
				result.setProcedureDate(getClinicalDisplayWebserviceShortDateFormat().format(study.getProcedureDate()));
			}
		}
		result.setRpcResponseMsg(study.getRpcResponseMsg());
		// JMW - need to find series for first image, ugly but necessary
		Series firstSeries = null;
		for(Series series : study.getSeries())
		{
			for(Image image : series)
			{
				if(image.equals(study.getFirstImage()))
				{
					firstSeries = series;
					break;
				}						
			}
			if(firstSeries != null)
			{
				break;
			}			 
		}
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.FatImageType firstImage = 
			transformImageToFatImage(study.getFirstImage(), firstSeries);
		
		result.setFirstImage(firstImage);
		
		// need to add site number field
		
		GlobalArtifactIdentifier identifier = study.getGlobalArtifactIdentifier();
		
		if(identifier instanceof BhieStudyURN)
			result.setStudyId( ((BhieStudyURN)identifier).toStringCDTP() );
		else
			result.setStudyId( identifier.toString() );
		
		return result;
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.FatImageType[] transformStudyToFatImages(Study study) 
	throws URNFormatException 
	{
		if(study == null)
			return null;
		if(study.getSeries() == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.FatImageType[] result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.FatImageType[study.getImageCount()];
		
		int index = 0;
		
		for(Series series : study.getSeries())
		{
			if(series != null)
			{
				for(Image image : series)
				{
					result[index] = transformImageToFatImage(image, series);
					index++;
				}
			}
				 
		}
		return result;
	}

	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.FatImageType transformImageToFatImage(Image image, Series series) 
	throws URNFormatException 
	{
		if(image == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.FatImageType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.FatImageType();
		
		result.setDescription(extractIllegalCharacters(image.getDescription()));
		result.setDicomImageNumber((image.getImageNumber() != null) && (image.getImageNumber().length() > 0) ? image.getImageNumber() : image.getDicomImageNumberForDisplay());
		result.setDicomSequenceNumber((series != null) && (series.getSeriesNumber() != null) && (series.getSeriesNumber().length() > 0) ? series.getSeriesNumber() : image.getDicomSequenceNumberForDisplay());
		result.setPatientIcn(image.getPatientId());
		result.setPatientName(image.getPatientName());
		result.setProcedure(extractIllegalCharacters(image.getProcedure()));
		
		if(image.getProcedureDate() == null)
		{
			LOGGER.warn("ClinicalDisplayTranslator4.transformImageToFatImage() --> Setting empty procedure date for study");
			result.setProcedureDate("");
		}
		else 
		{
			// if the hour and minute are not 0, then likely they contain real values for hour and minute (not 00:00)
			// this leaves open the possibility of invalid data, if the real date was at 00:00 then this would not show that time.
			// we would then omit data, not show invalid data
			if((image.getProcedureDate().getHours() <= 0) && (image.getProcedureDate().getMinutes() <= 0))
			{
				result.setProcedureDate(getClinicalDisplayWebserviceShortDateFormat().format(image.getProcedureDate()));
			}
			else
			{
				result.setProcedureDate(getClinicalDisplayWebserviceLongDateFormat().format(image.getProcedureDate()));
			}
		}
		result.setSiteNumber(image.getSiteNumber());
		result.setSiteAbbr(image.getSiteAbbr());
		result.setImageClass(extractIllegalCharacters(image.getImageClass()));
		result.setAbsLocation(image.getAbsLocation());
		result.setFullLocation(image.getFullLocation());
		
		result.setQaMessage(image.getQaMessage());
		result.setImageType(BigInteger.valueOf(image.getImgType()));

		GlobalArtifactIdentifier identifier = image.getGlobalArtifactIdentifier();
		if(identifier instanceof BhieStudyURN)
			result.setImageId( ((BhieStudyURN)identifier).toStringCDTP() );
		else
			result.setImageId( identifier.toString() );
		
		boolean isRadImage = isRadImage(image);
		if((image.getFullFilename() != null) && (image.getFullFilename().startsWith("-1")))
		{
			result.setFullImageURI(image.getFullFilename()); // put in error state
		}
		else
		{
			// if the image is not radiology, then this is a ref image request, if not rad image
			// then ref location is for the diagnostic image.
			int imageQuality = (isRadImage ? ImageQuality.REFERENCE.getCanonical() : ImageQuality.DIAGNOSTICUNCOMPRESSED.getCanonical());			
			result.setFullImageURI("imageURN=" + result.getImageId() + "&imageQuality=" + imageQuality + "&contentType=" + getContentType(image, ImageQuality.REFERENCE));
		}
		if((image.getAbsFilename() != null) && (image.getAbsFilename().startsWith("-1")))
		{
			result.setAbsImageURI(image.getAbsFilename());
		}
		else
		{
			result.setAbsImageURI("imageURN=" + result.getImageId() + "&imageQuality=20&contentType=" + getContentType(image, ImageQuality.THUMBNAIL));
		}
		if(isRadImage)
		{
			if((image.getBigFilename() != null) && (image.getBigFilename().startsWith("-1")))
			{
				result.setBigImageURI(image.getBigFilename());
			}
			else
			{
				result.setBigImageURI("imageURN=" + result.getImageId() + "&imageQuality=90&contentType=" + getContentType(image, ImageQuality.DIAGNOSTIC));
			}
		}
		else
		{
			result.setBigImageURI("");
		}
		return result;
	}
	
	public ImageAccessLogEvent transformLogEvent(gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ImageAccessLogEventType logEventType) 
	throws URNFormatException 
	{
		if(logEventType == null)
			return null;
		
		AbstractImagingURN urn = URNFactory.create(logEventType.getId(), 
				SERIALIZATION_FORMAT.CDTP, AbstractImagingURN.class);
		
		boolean isDodImage = ExchangeUtil.isSiteDOD(urn.getOriginatingSiteId());		
		
		ImageAccessLogEventType imageAccessLogEventType = transformLogEventType(logEventType.getEventType());
		ImageAccessLogEvent result = 			
			new ImageAccessLogEvent(urn.getImagingIdentifier(), "", logEventType.getPatientIcn(), 
					urn.getOriginatingSiteId(), System.currentTimeMillis(), 
				logEventType.getReason(), "", 
				imageAccessLogEventType, isDodImage, logEventType.getCredentials().getSiteNumber());
		
		return result;
	}	

	public ImageAccessLogEventType transformLogEventType(gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ImageAccessLogEventTypeEventType eventType) {
		
		ImageAccessLogEventType result = null;
		
		if(eventType == gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ImageAccessLogEventTypeEventType.IMAGE_COPY) {
			result = ImageAccessLogEventType.IMAGE_COPY;
		}
		else if(eventType == gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ImageAccessLogEventTypeEventType.PATIENT_ID_MISMATCH)
		{
			result = ImageAccessLogEventType.PATIENT_ID_MISMATCH;
		}
		else if(eventType == gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ImageAccessLogEventTypeEventType.IMAGE_ACCESS)
		{
			result = ImageAccessLogEventType.IMAGE_ACCESS;
		}
		else if(eventType == gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ImageAccessLogEventTypeEventType.LOG_RESTRICTED_ACCESS)
		{
			result = ImageAccessLogEventType.RESTRICTED_ACCESS;
		}
		else 
		{
			result = ImageAccessLogEventType.IMAGE_PRINT;
		}
		return result;
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PingServerTypePingResponse transformServerStatusToPingServerResponse(SiteConnectivityStatus siteStatus)
	{
		return (siteStatus == SiteConnectivityStatus.VIX_READY 
				? PingServerTypePingResponse.SERVER_READY 
				: (siteStatus == SiteConnectivityStatus.DATASOURCE_UNAVAILABLE ? PingServerTypePingResponse.VISTA_UNAVAILABLE : PingServerTypePingResponse.SERVER_UNAVAILABLE));
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitiveCheckResponseType transformPatientSensitiveValue(PatientSensitiveValue sensitiveValue)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitiveCheckResponseType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitiveCheckResponseType();
		result.setWarningMessage(sensitiveValue.getWarningMessage());
		result.setPatientSensitivityLevel(transformPatientSensitiveLevel(sensitiveValue.getSensitiveLevel()));
		
		return result;
	}
	
	private gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitivityLevelType transformPatientSensitiveLevel(PatientSensitivityLevel sensitiveLevel)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitivityLevelType result = null;
		
		if(sensitiveLevel == PatientSensitivityLevel.ACCESS_DENIED)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitivityLevelType.ACCESS_DENIED;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DATASOURCE_FAILURE)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitivityLevelType.RPC_FAILURE;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DISPLAY_WARNING)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitivityLevelType.DISPLAY_WARNING;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DISPLAY_WARNING_CANNOT_CONTINUE)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitivityLevelType.DISPLAY_WARNING_CANNOT_CONTINUE;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DISPLAY_WARNING_REQUIRE_OK)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitivityLevelType.DISPLAY_WARNING_REQUIRE_OK;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.NO_ACTION_REQUIRED)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitivityLevelType.NO_ACTION_REQUIRED;
		}
		return result;
	}
}
