/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 30, 2009
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
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.BhieImageURN;
import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.ImageAccessLogEvent.ImageAccessLogEventType;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;
import gov.va.med.imaging.exchange.business.PassthroughParameter;
import gov.va.med.imaging.exchange.business.PassthroughParameterType;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.documents.Document;
import gov.va.med.imaging.exchange.business.documents.DocumentSet;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.exchange.enums.SiteConnectivityStatus;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PingServerTypePingResponse;

import java.math.BigInteger;
import java.text.DateFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayTranslator5 
extends AbstractBaseClinicalDisplayTranslator
{
	private final static Logger LOGGER = Logger.getLogger(ClinicalDisplayTranslator5.class);
	
	public ClinicalDisplayTranslator5()
	{
		super();
	}
	
	public PassthroughInputMethod transformPassthroughMethod(String methodName,
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodInputParameterType inputParameters)
	{
		if(methodName == null)
			return null;
		
		PassthroughInputMethod result = new PassthroughInputMethod(methodName);
		
		if(inputParameters != null)
		{
			if(inputParameters.getRemoteMethodParameter() != null)
			{
				for(gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodParameterType parameter : inputParameters.getRemoteMethodParameter())
				{
					result.getParameters().add(transformParameter(parameter));
				}
			}
		}
		return result;
	}
	
	private PassthroughParameter transformParameter(
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodParameterType parameter)
	{
		PassthroughParameter result = new PassthroughParameter();
		result.setIndex(parameter.getParameterIndex().intValue());
		result.setParameterType(transformParameterType(parameter.getParameterType()));
		if(parameter.getParameterValue() == null)
		{
			result.setValue(null);
			result.setMultipleValues(null);
		}
		else
		{
			result.setValue(parameter.getParameterValue().getValue());
			result.setMultipleValues(transformMultiples(parameter.getParameterValue().getMultipleValue()));
		}
		
		return result;
	}
	
	private String [] transformMultiples(gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodParameterMultipleType multiples)
	{
		return (multiples == null ? null : multiples.getMultipleValue());
	}
	
	private PassthroughParameterType transformParameterType(
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodParameterTypeType parameterType)
	{
		PassthroughParameterType result = PassthroughParameterType.literal;
		
		if(parameterType != null)
		{
			if(parameterType != null)
			{
				if(parameterType == gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodParameterTypeType.LIST)
				{
					result = PassthroughParameterType.list;
				}
				else if(parameterType == gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodParameterTypeType.REFERENCE)
				{
					result = PassthroughParameterType.reference;
				}
			}
		}
		
		return result;
	}
	
	/**
	 * Transform a clinical display webservice FilterType to an internal Filter instance.
	 * 
	 */
	public StudyFilter transformFilter(gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterType filterType,
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
                LOGGER.warn("ClinicalDisplayTranslator5.transformFilter() --> Could not convert 'from date' [{}] to internal Date: {}", filterType.getFromDate(), x.getMessage());
			}
			
			Date toDate = null;
			try
			{
				toDate = filterType.getToDate() == null || filterType.getToDate().length() == 0 ? null : df.parse(filterType.getToDate());
			} 
			catch (ParseException x)
			{
                LOGGER.warn("ClinicalDisplayTranslator5.transformFilter() --> Could not convert 'to date' [{}] to internal Date: {}", filterType.getToDate(), x.getMessage());
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
	
	private gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType transformStudiesToShallowStudies(
			Collection<Study> studyList) 
		throws URNFormatException 
	{		
		if(studyList == null || studyList.size() == 0)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType();
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType [] res = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType[studyList.size()];
		
		int index = 0;
		for(Iterator<Study> studiesIter = studyList.iterator(); studiesIter.hasNext(); ++index)
			res[index] = transformStudyToShallowStudy(studiesIter.next());
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesStudiesType holder = new 
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesStudiesType();
		holder.setStudy(res);
		result.setStudies(holder);
		
		return result;
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType transformStudiesToShallowStudies(
			ArtifactResults artifactResults) 
	throws URNFormatException 
	{
		if(artifactResults == null)
			return null;
		
		if(artifactResults.getStudySetResult() == null)
			return null;
		
		SortedSet<Study> studyList = artifactResults.getStudySetResult().getArtifacts();
		
		return transformStudiesToShallowStudies(studyList);
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType transformExceptionToShallowStudiesType(
		InsufficientPatientSensitivityException ipsX)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType();
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesErrorMessageType errorType = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesErrorMessageType();
		errorType.setErrorCode(BigInteger.valueOf(ipsX.getSensitiveValue().getSensitiveLevel().getCode()));
		errorType.setErrorMessage(ipsX.getSensitiveValue().getWarningMessage());
		errorType.setShallowStudiesError(gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesErrorType.INSUFFICIENT_SENSITIVE_LEVEL);
		result.setError(errorType);
		return result;
	}
	
	/**
	 * 
	 * @param study
	 * @return
	 * @throws URNFormatException
	 */
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType transformStudyToShallowStudy(
		Study study) 
	throws URNFormatException 
	{
		if(study == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType();
		
		// If the study has a StudyURN then use the string form of that, which can be
		// turned back into a StudyURN on subsequent presentation by the client to
		// this interface.
		// If the study has a BhieStudyURN then the patient identifier must be tacked
		// onto the stringified version so that it is re-presented on subsequent calls
		// by the client.
		// Otherwise, just punt and stringify the global artifact identifier.
		GlobalArtifactIdentifier identifier = study.getGlobalArtifactIdentifier();
		if(identifier instanceof BhieStudyURN)
			result.setStudyId( ((BhieStudyURN)identifier).toStringCDTP() );
		else
			result.setStudyId( identifier.toString() );
		
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
			result.setSiteAbbreviation(study.getSiteAbbr()+ (study.getSiteName() != null ? "-" + study.getSiteName() : ""));			
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
			LOGGER.warn("ClinicalDisplayTranslator5.transformStudyToShallowStudy() --> Setting empty procedure date for study");
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
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType firstImage = 
			transformImageToFatImage(study.getFirstImage(), firstSeries);
		
		result.setFirstImage(firstImage);
		
		return result;
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[] transformStudyToFatImages(
		Study study) 
	throws URNFormatException 
	{
		if(study == null)
			return null;
		if(study.getSeries() == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[] result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[study.getImageCount()];
		
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

	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType transformImageToFatImage(
		Image image, Series series) 
	throws URNFormatException 
	{
		if(image == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType();
		
		result.setDescription(extractIllegalCharacters(image.getDescription()));
		//result.setDicomImageNumber(image.getDicomImageNumberForDisplay());
		result.setDicomImageNumber((image.getImageNumber() != null) && (image.getImageNumber().length() > 0) ? image.getImageNumber() : image.getDicomImageNumberForDisplay());
		//result.setDicomSequenceNumber(image.getDicomSequenceNumberForDisplay());
		result.setDicomSequenceNumber((series != null) && (series.getSeriesNumber() != null) && (series.getSeriesNumber().length() > 0) ? series.getSeriesNumber() : image.getDicomSequenceNumberForDisplay());
		//result.setDicomSequenceNumber(image.get)
		result.setPatientIcn(image.getPatientId());
		result.setPatientName(image.getPatientName());
		result.setProcedure(extractIllegalCharacters(image.getProcedure()));
		if(image.getProcedureDate() == null)
		{
			LOGGER.warn("ClinicalDisplayTranslator5.transformImageToFatImage() --> Setting empty procedure date for study");
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

		//ImageURN imageUrn = ImageURN.create(image.getSiteNumber(), image.getIen(), parentIen(image), image.getPatientICN(), image.getImageModality());
		GlobalArtifactIdentifier identifier = image.getGlobalArtifactIdentifier();
		if(identifier instanceof BhieImageURN)
			result.setImageId( ((BhieImageURN)identifier).toStringCDTP() );
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
	
	public ImageAccessLogEvent transformLogEvent(
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventType logEventType) 
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

	public ImageAccessLogEventType transformLogEventType(
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventTypeEventType eventType) 
	{
		ImageAccessLogEventType result = null;
		
		if(eventType == gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventTypeEventType.IMAGE_COPY) {
			result = ImageAccessLogEventType.IMAGE_COPY;
		}
		else if(eventType == gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventTypeEventType.PATIENT_ID_MISMATCH)
		{
			result = ImageAccessLogEventType.PATIENT_ID_MISMATCH;
		}
		else if(eventType == gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventTypeEventType.IMAGE_ACCESS)
		{
			result = ImageAccessLogEventType.IMAGE_ACCESS;
		}
		else if(eventType == gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventTypeEventType.LOG_RESTRICTED_ACCESS)
		{
			result = ImageAccessLogEventType.RESTRICTED_ACCESS;
		}
		else 
		{
			result = ImageAccessLogEventType.IMAGE_PRINT;
		}
		return result;
	}
	
	public PingServerTypePingResponse transformServerStatusToPingServerResponse(
		SiteConnectivityStatus siteStatus)
	{
		return (siteStatus == SiteConnectivityStatus.VIX_READY 
				? PingServerTypePingResponse.SERVER_READY 
				: (siteStatus == SiteConnectivityStatus.DATASOURCE_UNAVAILABLE ? PingServerTypePingResponse.VISTA_UNAVAILABLE : PingServerTypePingResponse.SERVER_UNAVAILABLE));
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitiveCheckResponseType transformPatientSensitiveValue(
		PatientSensitiveValue sensitiveValue)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitiveCheckResponseType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitiveCheckResponseType();
		result.setWarningMessage(sensitiveValue.getWarningMessage());
		result.setPatientSensitivityLevel(transformPatientSensitiveLevel(sensitiveValue.getSensitiveLevel()));
		
		return result;
	}
	
	private gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitivityLevelType transformPatientSensitiveLevel(
		PatientSensitivityLevel sensitiveLevel)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitivityLevelType result = null;
		
		if(sensitiveLevel == PatientSensitivityLevel.ACCESS_DENIED)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitivityLevelType.ACCESS_DENIED;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DATASOURCE_FAILURE)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitivityLevelType.RPC_FAILURE;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DISPLAY_WARNING)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitivityLevelType.DISPLAY_WARNING;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DISPLAY_WARNING_CANNOT_CONTINUE)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitivityLevelType.DISPLAY_WARNING_CANNOT_CONTINUE;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DISPLAY_WARNING_REQUIRE_OK)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitivityLevelType.DISPLAY_WARNING_REQUIRE_OK;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.NO_ACTION_REQUIRED)
		{
			result = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitivityLevelType.NO_ACTION_REQUIRED;
		}
		return result;
	}

	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType translate(List<DocumentSet> documentSets)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType();
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesStudiesType studiesType =
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesStudiesType();
		result.setStudies(studiesType);
		
		List<gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType> studyTypes =
			new ArrayList<gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType>();
		
		for(DocumentSet documentSet : documentSets)
		{
			List<gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType> studyTypeArray = 
				translate(documentSet);
			studyTypes.addAll(studyTypeArray);
		}
		
		studiesType.setStudy(studyTypes.toArray(new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType[studyTypes.size()]));
		
		return result;
	}
	
	/**
	 * Convert the documentSet into a list of ShallowStudyTypes, each Document will become its own ShallowStudyType
	 * @param documentSet
	 * @return
	 */	
	private List<gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType> translate(DocumentSet documentSet)
	{
		List<gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType> result = 
			new ArrayList<gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType>();
		
		for(Document document : documentSet)
		{
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType studyType = 
				new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType();
			
			if(documentSet.getAcquisitionDate() != null)
			{
				studyType.setCaptureDate(getClinicalDisplayWebserviceLongDateFormat().format(documentSet.getAcquisitionDate()));
			}
			
			studyType.setDescription(document.getDescription());
			studyType.setEvent("canned event");
			studyType.setImageCount(BigInteger.valueOf(1));
			studyType.setNoteTitle("canned note title");
			studyType.setImagePackage("image package");
			studyType.setOrigin("canned origin");
			studyType.setPatientIcn(documentSet.getPatientIcn());
			studyType.setProcedure("canned procedure");
			if(documentSet.getProcedureDate() != null)
			{
				studyType.setProcedureDate(getClinicalDisplayWebserviceLongDateFormat().format(documentSet.getProcedureDate()));
			}
			studyType.setRpcResponseMsg(documentSet.getRpcResponseMsg());
			studyType.setSiteAbbreviation(documentSet.getSiteAbbr());
			studyType.setSiteNumber(documentSet.getRepositoryId());
			studyType.setSpecialty("canned specialty");
			studyType.setStudyClass("canned study class");
			studyType.setStudyId(document.getDocumentUrn().toString());
			studyType.setStudyPackage("canned study package");
			studyType.setStudyType("canned study type");
			
			studyType.setFirstImage(translate(documentSet, document));
			
			result.add(studyType);
		}
		
		return result;
	}
	
	private gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType translate(DocumentSet documentSet, 
			Document document)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType();
		
		result.setDescription(document.getDescription());
		result.setImageId(document.getDocumentUrn().toString());
		result.setPatientIcn(document.getPatientId());
		result.setPatientName(documentSet.getPatientName());
		result.setAbsImageURI("-1^abs image URI");
		result.setAbsLocation("O");
		result.setBigImageURI("-1^big image URI");
		result.setDicomImageNumber("");
		result.setDicomSequenceNumber("");
		result.setFullImageURI("-1^full image URI");
		result.setFullLocation("O");
		result.setImageClass("canned image class");
		result.setImageType(BigInteger.valueOf(document.getVistaImageType()));
		result.setProcedure("canned procedure");
		
		if(documentSet.getProcedureDate() != null)
		{
			result.setProcedureDate(getClinicalDisplayWebserviceLongDateFormat().format(documentSet.getProcedureDate()));
		}
		
		result.setQaMessage("");
		result.setSiteAbbr(documentSet.getSiteAbbr());
		result.setSiteNumber(document.getSiteNumber());
		
		return result;
	}
}
