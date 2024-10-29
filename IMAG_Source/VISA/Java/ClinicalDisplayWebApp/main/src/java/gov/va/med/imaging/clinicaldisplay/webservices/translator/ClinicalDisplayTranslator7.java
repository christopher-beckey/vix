/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 16, 2011
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
package gov.va.med.imaging.clinicaldisplay.webservices.translator;

import gov.va.med.PatientArtifactIdentifierImpl;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URN;
import gov.va.med.URNFactory;
import gov.va.med.WellKnownOID;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.clinicaldisplay.configuration.ClinicalDisplayWebAppConfiguration;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.ImageAccessLogEvent.ImageAccessLogEventType;
import gov.va.med.imaging.exchange.business.ArtifactResultError;
import gov.va.med.imaging.exchange.business.ArtifactResultErrorComparator;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;
import gov.va.med.imaging.exchange.business.PassthroughParameter;
import gov.va.med.imaging.exchange.business.PassthroughParameterType;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.business.UserInformation;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotation;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationDetails;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationSource;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationUser;
import gov.va.med.imaging.exchange.business.documents.Document;
import gov.va.med.imaging.exchange.business.documents.DocumentSet;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.ArtifactResultErrorCode;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.ObjectStatus;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.exchange.enums.SiteConnectivityStatus;
import gov.va.med.imaging.exchange.enums.VistaImageType;

import java.math.BigInteger;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ClinicalDisplayTranslator7
extends AbstractBaseClinicalDisplayTranslator
{
	private final static Logger LOGGER = Logger.getLogger(ClinicalDisplayTranslator7.class);
	
	private static Map<PatientSensitivityLevel, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitivityLevelType> patientSensitiveLevelMap;
	private static Map<SiteConnectivityStatus, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PingServerTypePingResponse> siteConnectivityStatusMap;
	private static Map<ImageAccessLogEventType, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventTypeEventType> imageAccessLogEventMap;
	private static Map<PassthroughParameterType, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodParameterTypeType> passthroughParameterTypeMap;
	private static Map<ImageAnnotationSource, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationTypeSource> annotationSourceMap;	
	
	static
	{
		patientSensitiveLevelMap = new HashMap<PatientSensitivityLevel, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitivityLevelType>();
		patientSensitiveLevelMap.put(PatientSensitivityLevel.ACCESS_DENIED, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitivityLevelType.ACCESS_DENIED);
		
		patientSensitiveLevelMap.put(PatientSensitivityLevel.DATASOURCE_FAILURE, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitivityLevelType.RPC_FAILURE);
		patientSensitiveLevelMap.put(PatientSensitivityLevel.DISPLAY_WARNING, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitivityLevelType.DISPLAY_WARNING);
		patientSensitiveLevelMap.put(PatientSensitivityLevel.DISPLAY_WARNING_CANNOT_CONTINUE, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitivityLevelType.DISPLAY_WARNING_CANNOT_CONTINUE);
		patientSensitiveLevelMap.put(PatientSensitivityLevel.DISPLAY_WARNING_REQUIRE_OK, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitivityLevelType.DISPLAY_WARNING_REQUIRE_OK);
		patientSensitiveLevelMap.put(PatientSensitivityLevel.NO_ACTION_REQUIRED, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitivityLevelType.NO_ACTION_REQUIRED);
		
		siteConnectivityStatusMap = new HashMap<SiteConnectivityStatus, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PingServerTypePingResponse>();
		siteConnectivityStatusMap.put(SiteConnectivityStatus.DATASOURCE_UNAVAILABLE, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PingServerTypePingResponse.VISTA_UNAVAILABLE);
		siteConnectivityStatusMap.put(SiteConnectivityStatus.VIX_READY, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PingServerTypePingResponse.SERVER_READY);
		siteConnectivityStatusMap.put(SiteConnectivityStatus.VIX_UNAVAILABLE, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PingServerTypePingResponse.SERVER_UNAVAILABLE);
		
		imageAccessLogEventMap = 
			new HashMap<ImageAccessLogEventType, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventTypeEventType>();
		imageAccessLogEventMap.put(ImageAccessLogEventType.IMAGE_ACCESS, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventTypeEventType.IMAGE_ACCESS);		
		imageAccessLogEventMap.put(ImageAccessLogEventType.IMAGE_COPY, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventTypeEventType.IMAGE_COPY);
		imageAccessLogEventMap.put(ImageAccessLogEventType.IMAGE_PRINT, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventTypeEventType.IMAGE_PRINT);
		imageAccessLogEventMap.put(ImageAccessLogEventType.PATIENT_ID_MISMATCH, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventTypeEventType.PATIENT_ID_MISMATCH);
		imageAccessLogEventMap.put(ImageAccessLogEventType.RESTRICTED_ACCESS, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventTypeEventType.LOG_RESTRICTED_ACCESS);
		
		passthroughParameterTypeMap = 
			new HashMap<PassthroughParameterType, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodParameterTypeType>();
		passthroughParameterTypeMap.put(PassthroughParameterType.list, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodParameterTypeType.LIST);
		passthroughParameterTypeMap.put(PassthroughParameterType.literal, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodParameterTypeType.LITERAL);
		passthroughParameterTypeMap.put(PassthroughParameterType.reference, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodParameterTypeType.REFERENCE);
		
		annotationSourceMap = 
			new HashMap<ImageAnnotationSource, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationTypeSource>();
		annotationSourceMap.put(ImageAnnotationSource.clinicalDisplay, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationTypeSource.ClinicalDisplay);
		annotationSourceMap.put(ImageAnnotationSource.vistaRad, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationTypeSource.VistARad);
		annotationSourceMap.put(ImageAnnotationSource.clinicalCapture, 
				gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationTypeSource.ClinicalCapture);
		
	}	
	
	public static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitiveCheckResponseType translate(
			PatientSensitiveValue sensitiveValue)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitiveCheckResponseType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitiveCheckResponseType();
		result.setWarningMessage(sensitiveValue.getWarningMessage());
		result.setPatientSensitivityLevel(translate(sensitiveValue.getSensitiveLevel()));
		
		return result;
	}
		
	private static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitivityLevelType translate(
		PatientSensitivityLevel sensitiveLevel)
	{
		for(Entry<PatientSensitivityLevel, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitivityLevelType> entry : ClinicalDisplayTranslator7.patientSensitiveLevelMap.entrySet())
		{
			if(entry.getKey() == sensitiveLevel)
				return entry.getValue();			
		}
		return null;
	}
	
	public static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PingServerTypePingResponse transform(
			SiteConnectivityStatus siteStatus)
	{
		for(Entry<SiteConnectivityStatus, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PingServerTypePingResponse> entry : siteConnectivityStatusMap.entrySet())
		{
			if(entry.getKey() == siteStatus)
				return entry.getValue();
		}
		return null;
	}
	
	public static ImageAccessLogEvent translate(
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventType logEventType) 
	throws URNFormatException 
	{
		if(logEventType == null)
			return null;
		
		URN urn = URNFactory.create(logEventType.getId(), SERIALIZATION_FORMAT.CDTP);
				
		if(urn instanceof AbstractImagingURN)
		{
			AbstractImagingURN abstractImagingUrn = (AbstractImagingURN)urn;
			boolean isDodImage = ExchangeUtil.isSiteDOD(abstractImagingUrn.getOriginatingSiteId());		
			
			ImageAccessLogEventType imageAccessLogEventType = translate(logEventType.getEventType());
			ImageAccessLogEvent result = 			
				new ImageAccessLogEvent(abstractImagingUrn.getImagingIdentifier(), "", logEventType.getPatientIcn(), 
						abstractImagingUrn.getOriginatingSiteId(), System.currentTimeMillis(), 
					logEventType.getReasonCode(), logEventType.getReasonDescription(), 
					imageAccessLogEventType, isDodImage, logEventType.getCredentials().getSiteNumber());		
			return result;
		}
		else if(urn instanceof PatientArtifactIdentifierImpl)
		{
			PatientArtifactIdentifierImpl pai = (PatientArtifactIdentifierImpl)urn;
			
			ImageAccessLogEventType imageAccessLogEventType = translate(logEventType.getEventType());
			ImageAccessLogEvent result = 			
				new ImageAccessLogEvent(pai.toString(), "", logEventType.getPatientIcn(), 
						"200", System.currentTimeMillis(), 
						logEventType.getReasonCode(), logEventType.getReasonDescription(), 
						imageAccessLogEventType, true, logEventType.getCredentials().getSiteNumber());		
			return result;
		}
		else
		{
            LOGGER.warn("ClinicalDisplayTranslator7.translate() --> Image Id [{}] is not an AbstractImagingURN or PatientArtifactIdentifier and cannot be logged at this time.", logEventType.getId());
			return null;
		}
	}	

	private static ImageAccessLogEventType translate(
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventTypeEventType eventType) 
	{
		for(Entry<ImageAccessLogEventType, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventTypeEventType> entry : imageAccessLogEventMap.entrySet())
		{
			if(entry.getValue() == eventType)
			{
				return entry.getKey();
			}
		}
		return null;
	}

	public static PassthroughInputMethod translate(String methodName,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodInputParameterType inputParameters)
	{
		if(methodName == null)
			return null;
		
		PassthroughInputMethod result = new PassthroughInputMethod(methodName);
		
		if(inputParameters != null)
		{
			if(inputParameters.getRemoteMethodParameter() != null)
			{
				for(gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodParameterType parameter : inputParameters.getRemoteMethodParameter())
				{
					result.getParameters().add(translate(parameter));
				}
			}
		}
		return result;
	}
	
	private static PassthroughParameter translate(
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodParameterType parameter)
	{
		PassthroughParameter result = new PassthroughParameter();
		result.setIndex(parameter.getParameterIndex().intValue());
		result.setParameterType(translate(parameter.getParameterType()));
		if(parameter.getParameterValue() == null)
		{
			result.setValue(null);
			result.setMultipleValues(null);
		}
		else
		{
			result.setValue(parameter.getParameterValue().getValue());
			result.setMultipleValues(translate(parameter.getParameterValue().getMultipleValue()));
		}
		
		return result;
	}
	
	private static String [] translate(gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodParameterMultipleType multiples)
	{
		if(multiples == null)
			return null;
		return multiples.getMultipleValue();
	}
	
	private static PassthroughParameterType translate(
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodParameterTypeType parameterType)
	{
		if(parameterType != null)
		{
			for(Entry<PassthroughParameterType, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodParameterTypeType> entry : passthroughParameterTypeMap.entrySet())
			{
				if(entry.getValue() == parameterType)
				{
					return entry.getKey();
				}
			}
		}
		
		return PassthroughParameterType.literal;
	}
	
	public static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType[] translate(
			Study study, boolean includeDeletedImages) 
	throws URNFormatException 
	{
		if(study == null)
			return null;
		if(study.getSeries() == null)
			return null;
		
		List<gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType> result =
			new ArrayList<gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType>();		
		
		for(Series series : study.getSeries())
		{
			if(series != null)
			{
				for(Image image : series)
				{
					gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType img = translate(image, series, includeDeletedImages);
					if(img != null)
						result.add(img);
				}
			}				 
		}
		return result.toArray(new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType[result.size()]);
	}

	@SuppressWarnings("deprecation")
	public static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType translate(
		Image image, Series series, boolean includeDeletedImages) 
	throws URNFormatException 
	{
		if(image == null)
			return null;
		
		if(image.isDeleted() && !includeDeletedImages)
		{
            LOGGER.warn("ClinicalDisplayTranslator7.translate() --> Image [{}] is deleted and not including deleted images, excluding from result.", image.getImageUrn().toRoutingTokenString());
			return null;
		}
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType();
		
		result.setDescription(extractIllegalCharacters(image.getDescription()));
		result.setDicomImageNumber((image.getImageNumber() != null) && (image.getImageNumber().length() > 0) ? image.getImageNumber() : image.getDicomImageNumberForDisplay());
		result.setDicomSequenceNumber((series != null) && (series.getSeriesNumber() != null) && (series.getSeriesNumber().length() > 0) ? series.getSeriesNumber() : image.getDicomSequenceNumberForDisplay());
		result.setPatientIcn(image.getPatientId());
		result.setPatientName(image.getPatientName());
		result.setProcedure(extractIllegalCharacters(image.getProcedure()));
		
		if(image.getProcedureDate() == null)
		{
			LOGGER.warn("ClinicalDisplayTranslator7.translate() --> Setting empty procedure date for image");
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
		result.setImageId(image.getImageUrn().toString(SERIALIZATION_FORMAT.CDTP));
		
		boolean isRadImage = isRadImage(image);
		// JMW 9/23/2010 P104 - if the filename starts with a '.', then just pass that filename back and let the client get the file
		if((image.getFullFilename() != null) && 
				((image.getFullFilename().startsWith("-1")) || image.getFullFilename().startsWith(".")))
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
		// JMW 9/23/2010 P104 - if the filename starts with a '.', then just pass that filename back and let the client get the file
		if((image.getAbsFilename() != null) && 
				((image.getAbsFilename().startsWith("-1")) || image.getAbsFilename().startsWith(".")))
		{
			result.setAbsImageURI(image.getAbsFilename());
		}
		else
		{
			result.setAbsImageURI("imageURN=" + result.getImageId() + "&imageQuality=20&contentType=" + getContentType(image, ImageQuality.THUMBNAIL));
		}
		if(isRadImage)
		{
			// JMW 9/23/2010 P104 - if the filename starts with a '.', then just pass that filename back and let the client get the file
			if((image.getBigFilename() != null) && 
					((image.getBigFilename().startsWith("-1")) || (image.getBigFilename().startsWith("."))))
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
		if(image.getCaptureDate() != null)
		{
			result.setCaptureDate(getClinicalDisplayWebserviceLongDateFormat().format(image.getCaptureDate()));	
		}
		else
		{
			result.setCaptureDate("");
		}
		if(image.getDocumentDate() != null)
		{
			result.setDocumentDate(getClinicalDisplayWebserviceLongDateFormat().format(image.getDocumentDate()));
		}
		else
		{
			result.setDocumentDate("");
		}
		result.setStatus(image.getImageStatus().getValue() + "");
		result.setSensitive(image.isSensitive());
		result.setViewStatus(image.getImageViewStatus().getValue() + "");
		result.setAssociatedNoteResulted(image.getAssociatedNoteResulted() == null ? "" : image.getAssociatedNoteResulted());
		result.setImagePackage(image.getImagePackage() == null ? "" : image.getImagePackage());
		result.setImageAnnotationStatus(BigInteger.valueOf(image.getImageAnnotationStatus()));
		result.setImageAnnotationStatusDescription(image.getImageAnnotationStatusDescription() == null ? "" : image.getImageAnnotationStatusDescription());
		result.setImageHasAnnotations(image.isImageHasAnnotations());
		
		return result;
	}
	
	/**
	 * Transform a clinical display webservice FilterType to an internal Filter instance.
	 * 
	 */
	public static StudyFilter translate(gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FilterType filterType,
			int authorizedSensitiveLevel) 
	{
		StudyFilter filter = new StudyFilter();
		
		if(filterType != null) 
		{			
			Date fromDate = null;
			try
			{
				if(filterType.getFromDate() != null && filterType.getFromDate().length() > 0)
				{
					DateFormat df = getClinicalDisplayWebserviceFormat(filterType.getFromDate());
					if(df != null)
						fromDate = df.parse(filterType.getFromDate());
				}
			} 
			catch (ParseException x)
			{
                LOGGER.warn("ClinicalDisplayTranslator7.translate() --> Could not convert 'from date' [{}] to internal Date: {}", filterType.getFromDate(), x.getMessage());
			}
			
			Date toDate = null;
			try
			{
				if(filterType.getToDate() != null && filterType.getToDate().length() > 0)
				{
					DateFormat df = getClinicalDisplayWebserviceFormat(filterType.getToDate());
					if(df != null)
						toDate = df.parse(filterType.getToDate());
				}
			} 
			catch (ParseException x)
			{
                LOGGER.warn("ClinicalDisplayTranslator6.translate() --> Could not convert 'to date' [{}] to internal Date: {}", filterType.getToDate(), x.getMessage());
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
			filter.setIncludeDeleted(filterType.getIncludeDeleted() == null ? false : filterType.getIncludeDeleted());
			// don't have a study id used here
		}
		filter.setMaximumAllowedLevel(PatientSensitivityLevel.getPatientSensitivityLevel(authorizedSensitiveLevel));
		return filter;
	}
	
	public static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType translate(
			InsufficientPatientSensitivityException ipsX)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType();
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesErrorMessageType errorType = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesErrorMessageType();
		errorType.setErrorCode(BigInteger.valueOf(ipsX.getSensitiveValue().getSensitiveLevel().getCode()));
		errorType.setErrorMessage(ipsX.getSensitiveValue().getWarningMessage());
		errorType.setShallowStudiesError(gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesErrorType.INSUFFICIENT_SENSITIVE_LEVEL);
		result.setError(errorType);
		result.setPartialResultMessage(""); // cannot be null
		return result;
	}
	
	public static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType translate(
			ArtifactResults artifactResults, StudyFilter studyFilter) 
	throws URNFormatException, MethodException
	{
		if(artifactResults == null)
			return null;
		
		if(artifactResults.getStudySetResult() == null && artifactResults.getDocumentSetResult() == null)
		{
			LOGGER.warn("ClinicalDisplayTranslator7.translate() --> Both StudySetResult and DocumentSetResult of ArtifactResults are null, possible error. Returning null.");
			return null;
		}
		
		List<gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType> shallowStudyTypeResults = 
			new ArrayList<gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType>();
		
		boolean isPartial = artifactResults.isPartialResult();
		StudySetResult studySetResult = artifactResults.getStudySetResult();
		boolean gotAResult = false;
		SortedSet<ArtifactResultError> errors = 
			new TreeSet<ArtifactResultError>(new ArtifactResultErrorComparator());
		if(studySetResult != null)
		{
			if(studySetResult.getArtifacts() != null)
			{
				for(Study study : studySetResult.getArtifacts())
				{
					gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType sst = translateStudy(study, studyFilter);
					if(sst != null)
					{
						shallowStudyTypeResults.add(sst);
						gotAResult = true;
					}
				}
			}
			if(studySetResult.getArtifactResultErrors() != null)
			{
				for(ArtifactResultError error : studySetResult.getArtifactResultErrors())
				{
					errors.add(error);
				}
			}
		}
		DocumentSetResult documentSetResult = artifactResults.getDocumentSetResult();
		if(documentSetResult != null)
		{
			// this will only be populated if getting documents from the DoD, otherwise VA documents 
			// will be included in the StudySetResult
			if(documentSetResult.getArtifacts() != null)
			{
				for(DocumentSet documentSet : documentSetResult.getArtifacts())
				{
					shallowStudyTypeResults.addAll(translate(documentSet));
					gotAResult = true;
				}
			}
			if(documentSetResult.getArtifactResultErrors() != null)
			{
				for(ArtifactResultError error : documentSetResult.getArtifactResultErrors())
				{
					errors.add(error);
				}
			}
		}
		StringBuilder partialResultErrorMessage = new StringBuilder();
		if(!gotAResult)
		{
			// if no result was included, then send an exception message from the error code
			if(errors.size() > 0)
			{
				// taking the highest priority error code to throw
				ArtifactResultError error = errors.first();
				ArtifactResultErrorCode errorCode = error.getErrorCode();
				if(errorCode == ArtifactResultErrorCode.timeoutException)
					throw new MethodException("ClinicalDisplayTranslator7.translate() --> java.net.SocketTimeoutException: Read timed out");
				else
					
					throw new MethodException(errorCode.name() + ": " + error.getCodeContext());
			}			
		}
		else
		{
			// got a valid result but want to include the details of the error message
			//if((isPartial) && ( errors.size() > 0))
			// JMW 5/23/2011 P104 - if there are any errors, include them in the error message
			if(errors.size() > 0)
			{
				partialResultErrorMessage.append("Recevieved '" + errors.size() + "' errors: ");
				for(ArtifactResultError error : errors)
				{					
					partialResultErrorMessage.append(error.getCodeContext());
					partialResultErrorMessage.append("; ");
				}
			}
		}
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType();
		result.setPartialResult(isPartial);
		result.setPartialResultMessage(partialResultErrorMessage.toString());

		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesStudiesType holder = new 
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesStudiesType();
		holder.setStudy(shallowStudyTypeResults.toArray(new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType[shallowStudyTypeResults.size()]));
		result.setStudies(holder);
		
		return result;
	}
	
	private static List<gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType> translate(DocumentSet documentSet)
	{
		if(documentSet == null)
			return null;
		
		List<gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType> result = 
			new ArrayList<gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType>();
		
		for(Document document : documentSet)
		{
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType studyType = 
				new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType();
			
			VistaImageType vistaImageType = getImageType(document);
			if(vistaImageType == null)
			{
				vistaImageType = VistaImageType.UNKNOWN_IMAGING_TYPE;
                LOGGER.warn("ClinicalDisplayTranslator7.translate() --> Document with media type [{}], returning VistaImageType of '{}' for Clinical Display.", document.getMediaType(), vistaImageType);
			}		
			String id = document.getGlobalArtifactIdentifier().toString(SERIALIZATION_FORMAT.CDTP);
			
			studyType.setStudyId(id);
			studyType.setPatientIcn(documentSet.getPatientIcn());
			studyType.setPatientName(documentSet.getPatientName());
			studyType.setRpcResponseMsg(documentSet.getRpcResponseMsg());
			
			Date procedureDate = documentSet.getProcedureDate() != null 
					? documentSet.getProcedureDate() 
					: document.getCreationDate() != null ? document.getCreationDate() : null;			

			studyType.setProcedureDate(procedureDate == null ? "" : getClinicalDisplayWebserviceLongDateFormat().format(procedureDate));
			
			studyType.setProcedure(document.getName());
			studyType.setImageType(vistaImageType.getImageType() + "");
			studyType.setImageCount(BigInteger.valueOf(1));
			studyType.setFirstImage(translate(documentSet, document, vistaImageType));
			studyType.setStatus(ObjectStatus.NO_STATUS.getValue() + "");
			studyType.setViewStatus(ObjectStatus.NO_STATUS.getValue() + "");
			studyType.setSensitive(false);
			studyType.setOrigin("DOD");
			studyType.setSiteAbbreviation("DoD");
			
			if((WellKnownOID.HAIMS_DOCUMENT.isApplicable(document.getGlobalArtifactIdentifier().getHomeCommunityId()) || 
					(ncatRepositoryId.equals(document.getRepositoryId()))))
			{
				studyType.setSiteNumber("200");
			}				
			else
			{
				// this should be a VA document, set the site number to the repository (there should not actually 
				// be VA documents here but just in case)
				studyType.setSiteNumber(document.getRepositoryId());
			}
			result.add(studyType);
		
		}
		return result;
	}
	
	private static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType translate(DocumentSet documentSet, 
			Document document, VistaImageType vistaImageType)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType image = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType();
		image.setProcedure(document.getName());
		//image.setImageId(document.getDocumentUrn().toString(SERIALIZATION_FORMAT.CDTP));
		image.setImageId(document.getGlobalArtifactIdentifier().toString(SERIALIZATION_FORMAT.CDTP));
		image.setImageType(BigInteger.valueOf(vistaImageType.getImageType()));
		image.setSensitive(false);
		image.setStatus(ObjectStatus.NO_STATUS.getValue() + "");
		image.setViewStatus(ObjectStatus.NO_STATUS.getValue() + "");
		
		
		if(WellKnownOID.HAIMS_DOCUMENT.isApplicable(document.getGlobalArtifactIdentifier().getHomeCommunityId()))
		{
			// if there is no defined abstract image and the image is from the DoD, use the following canned image
			image.setAbsImageURI(cannedDoDAbstract);
		}
		else
		{
			image.setAbsImageURI("");
		}
		image.setFullImageURI("imageURN=" + image.getImageId() + "&imageQuality=" + ImageQuality.DIAGNOSTICUNCOMPRESSED.getCanonical() + "&contentType=" + document.getMediaType().toString().toLowerCase());
		
		// Patch 122 fields
		image.setAssociatedNoteResulted("");
		image.setImagePackage("");
		image.setImageAnnotationStatus(BigInteger.valueOf(0));
		image.setImageAnnotationStatusDescription("");
		image.setImageHasAnnotations(false);
		
		return image;
	}
	
	private final static String ncatRepositoryId = "2.16.840.1.113883.3.198.1";
	
	private static VistaImageType getImageType(Document document)
	{
		return (ncatRepositoryId.equals(document.getRepositoryId()) ? VistaImageType.NCAT : ClinicalDisplayWebAppConfiguration.getConfiguration().getVistaImageType(document.getMediaType()));	
	}
	
	/**
	 * 
	 * @param study
	 * @return
	 * @throws URNFormatException
	 */
	@SuppressWarnings("deprecation")
	private static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType translateStudy(
		Study study, StudyFilter studyFilter) 
	throws URNFormatException 
	{
		if(study == null)
			return null;
		
		if(study.isDeleted() && !studyFilter.isIncludeDeleted())
		{
            getLogger().debug("Study '{}' is deleted and not including in result.", study.getStudyUrn().toRoutingTokenString());
			return null;
		}
		
		// Temporarily filtering MUSE images from response, will remove this filter later
		// Derrick Kelley (derrick.kelley@va.gov)
		if (study.getDescription().trim().toUpperCase(Locale.ENGLISH).endsWith(" : CONFIRMED") || study.getDescription().trim().toUpperCase(Locale.ENGLISH).endsWith(" : UNCONFIRMED")) {
			LOGGER.warn("ClinicalDisplayTranslator7.translateStudy() --> Filtering image with description ending in confirmed / unconfirmed");
			return null;
		}
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudyType();

		result.setStudyId(study.getStudyUrn().toString(SERIALIZATION_FORMAT.CDTP));
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
			LOGGER.warn("ClinicalDisplayTranslator7.translateStudy() --> Setting null procedure date for study");
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
		// the first image in the study should not be deleted so include it if for some reason it is
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType firstImage = 
			translate(study.getFirstImage(), firstSeries, true);
		
		result.setFirstImage(firstImage);
		result.setDocumentDate(study.getDocumentDate() != null ? getClinicalDisplayWebserviceLongDateFormat().format(study.getDocumentDate()) : "");
		result.setStatus(study.getStudyStatus().getValue() + "");
		result.setSensitive(study.isSensitive());
		result.setViewStatus(study.getStudyViewStatus().getValue() + "");
		result.setStudyImagesHaveAnnotations(study.isStudyImagesHaveAnnotations());
		
		return result;
	}
	
	public static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType[] translate(List<ImageAnnotation> imageAnnotations)
	{
		if(imageAnnotations == null)
		{
			return new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType[0];
		}
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType[] result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType[imageAnnotations.size()];
		
		for(int i = 0; i < imageAnnotations.size(); i++)
		{
			result[i] = translate(imageAnnotations.get(i));
		}
		
		return result;
	}
	
	private static SimpleDateFormat getAnnotationDateFormat()
	{
		return new SimpleDateFormat(annotationDateFormat);
	}	
	
	public static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType translate(ImageAnnotation imageAnnotation)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType();
		
		result.setAnnotationId(imageAnnotation.getAnnotationUrn().toString(SERIALIZATION_FORMAT.CDTP));
		result.setImageId(imageAnnotation.getImagingUrn().toString(SERIALIZATION_FORMAT.CDTP));
		result.setAnnotationVersion(imageAnnotation.getAnnotationVersion());
		result.setSavedAfterResult(imageAnnotation.isSavedAfterResult());
		result.setSavedDate(imageAnnotation.getAnnotationSavedDate() == null ? "" : getAnnotationDateFormat().format(imageAnnotation.getAnnotationSavedDate()));
		result.setSource(translate(imageAnnotation.getAnnotationSource()));
		result.setUser(translate(imageAnnotation.getAnnotationSavedByUser()));
		result.setAnnotationDeleted(imageAnnotation.isAnnotationDeleted());
		
		return result;
	}
	
	private static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationTypeSource translate (
			ImageAnnotationSource annotationSource)
	{
		for(Entry<ImageAnnotationSource, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationTypeSource> entry : ClinicalDisplayTranslator7.annotationSourceMap.entrySet())
		{
			if(entry.getKey() == annotationSource)
				return entry.getValue();			
		}
		return null;
	}
	
	private static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationUserType translate(
			ImageAnnotationUser user)
	{
		if(user == null)
			return new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationUserType();
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationUserType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationUserType();
		
		result.setDuz(user.getUserId());
		result.setName(user.getName());
		result.setService(user.getService());
		
		return result;
	}
	
	public static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationDetailsType translate(
			ImageAnnotationDetails imageAnnotationDetails)
	{
		if(imageAnnotationDetails == null)
		{
			return new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationDetailsType();
		}
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationDetailsType result =
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationDetailsType();
		
		result.setAnnotation(translate(imageAnnotationDetails.getImageAnnotation()));
		result.setDetails(imageAnnotationDetails.getAnnotationXml());
		
		return result;
	}
	
	public static gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserType translate(UserInformation userInformation)
	{
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserType();
		
		if(userInformation != null)
		{
			result.setUserId(userInformation.getUser().getUserId());
			List<String> keyList = userInformation.getKeys();
			String [] keys = new String[keyList == null ? 0 : keyList.size()];
			if(keyList != null)
			{
				for(int i = 0; i < keyList.size(); i++)
				{
					keys[i] = keyList.get(i);
				}
			}
			result.setKey(keys);
			result.setCanCreateAnnotations(userInformation.isUserCanAnnotate());
		}
		
		return result;
	}
}
