/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 21, 2008
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

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URN;
import gov.va.med.URNFactory;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.ImageAccessLogEvent.ImageAccessLogEventType;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.SiteConnectivityStatus;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageAccessLogEventTypeEventType;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.PingServerTypeResponse;

import java.math.BigInteger;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ClinicalDisplayTranslator2 
{
	private final static Logger LOGGER = Logger.getLogger(ClinicalDisplayTranslator2.class);
	
	private final static String clinicalDisplayWebserviceShortDateFormat = "MM/dd/yyyy";
	private final static String clinicalDisplayWebserviceLongDateFormat = "MM/dd/yyyy HH:mm";
	
	public ClinicalDisplayTranslator2()
	{
		super();
	}
	
	// be careful about re-using SimpleDateFormat instances because they are not thread-safe 
	private DateFormat getClinicalDisplayWebserviceShortDateFormat()
	{
		return new SimpleDateFormat(clinicalDisplayWebserviceShortDateFormat);
	}
	
	private DateFormat getClinicalDisplayWebserviceLongDateFormat()
	{
		return new SimpleDateFormat(clinicalDisplayWebserviceLongDateFormat);
	}
	
	/**
	 * Transform a clinical display webservice FilterType to an internal Filter instance.
	 * 
	 */
	public StudyFilter transformFilter(gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FilterType filterType) 
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
                LOGGER.warn("ClinicalDisplayTranslator2.transformFilter() --> Could not convert 'from date' [{}] to internal Date: {}", filterType.getFromDate(), x.getMessage());
			}
			
			Date toDate = null;
			try
			{
				toDate = filterType.getToDate() == null || filterType.getToDate().length() == 0 ? null : df.parse(filterType.getToDate());
			} 
			catch (ParseException x)
			{
                LOGGER.warn("ClinicalDisplayTranslator2.transformFilter() --> Could not convert 'to date' [{}] to internal Date: {}", filterType.getToDate(), x.getMessage());
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
		return filter;
	}
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType[] transformStudiesToShallowStudies(
			ArtifactResults artifactResults) 
	throws URNFormatException 
	{
		if(artifactResults == null)
			return null;
		if(artifactResults.getStudySetResult() == null)
			return null;
		return transformStudiesToShallowStudies(artifactResults.getStudySetResult().getArtifacts());
		
	}
	
	private gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType[] transformStudiesToShallowStudies(Collection<Study> studyList) 
	throws URNFormatException 
	{
		if(studyList == null || studyList.size() == 0)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType [] res = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType[studyList.size()];
		
		int index = 0;
		for(Iterator<Study> studiesIter = studyList.iterator(); studiesIter.hasNext(); ++index)
			res[index] = transformStudyToShallowStudy(studiesIter.next());
		
		return res;
	}
	
	/**
	 * 
	 * @param study
	 * @return
	 * @throws URNFormatException
	 */
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType transformStudyToShallowStudy(
		Study study) 
	throws URNFormatException 
	{
		if(study == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType();
		
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
		result.setRadiologyReport(study.getRadiologyReport());
		result.setSiteNumber(study.getSiteNumber());
		result.setSpecialty(extractIllegalCharacters(study.getSpecialty()));
		
		// 2/19/08 - now include the site name so the Display client shows what specific DOD facility the study is from
		if(study.getStudyUrn().isOriginDOD())
			result.setSiteAbbreviation(study.getSiteAbbr()+ (study.getSiteName() != null ? "-" + study.getSiteName() : ""));			
		else
			result.setSiteAbbreviation(study.getSiteAbbr());
		
		result.setStudyPackage(extractIllegalCharacters(study.getImagePackage()));
		result.setStudyClass(extractIllegalCharacters(study.getStudyClass() == null ? "" : study.getStudyClass())); // get this from study
		result.setStudyType(extractIllegalCharacters(study.getImageType()));
		result.setCaptureDate(study.getCaptureDate());
		result.setCapturedBy(study.getCaptureBy());		
		if(study.getProcedureDate() == null)
		{
			LOGGER.warn("ClinicalDisplayTranslator2.transformStudyToShallowStudy() --> Setting empty procedure date for study");
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
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType firstImage = 
			transformImageToFatImage(study.getFirstImage(), firstSeries);
		
		result.setFirstImage(firstImage);
		
		// use the VA Internal form of the URN because this is going to Clinical Display
		result.setStudyId( study.getStudyUrn().toStringCDTP() );
		
		return result;
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType[] transformStudyToFatImages(
		Study study) 
	throws URNFormatException 
	{
		if(study == null)
			return null;
		
		if(study.getSeries() == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType[] result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType[study.getImageCount()];
		
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
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType transformImageToFatImage(
		Image image, Series series) 
	throws URNFormatException 
	{
		if(image == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType();
		
		result.setDescription(extractIllegalCharacters(image.getDescription()));
		result.setDicomImageNumber(image.getDicomImageNumberForDisplay());
		result.setDicomSequenceNumber((series != null) && (series.getSeriesNumber() != null) && (series.getSeriesNumber().length() > 0) ? series.getSeriesNumber() : image.getDicomSequenceNumberForDisplay());
		result.setPatientIcn(image.getPatientId());
		result.setPatientName(image.getPatientName());
		result.setProcedure(extractIllegalCharacters(image.getProcedure()));
		if(image.getProcedureDate() == null)
		{
			LOGGER.warn("ClinicalDisplayTranslator2.transformImageToFatImage() --> Setting empty procedure date for study");
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

		// use the VA Internal form of the URN because this is going to Clinical
		// Display.
		result.setImageId( image.getImageUrn().toStringCDTP() );
		
		if((image.getFullFilename() != null) && (image.getFullFilename().startsWith("-1")))
		{
			result.setFullImageURI(image.getFullFilename()); // put in error state
		}
		else
		{
			result.setFullImageURI("imageURN=" + result.getImageId() + "&imageQuality=70&contentType=" + getContentType(image, false));
		}
		if((image.getAbsFilename() != null) && (image.getAbsFilename().startsWith("-1")))
		{
			result.setAbsImageURI(image.getAbsFilename());
		}
		else
		{
			result.setAbsImageURI("imageURN=" + result.getImageId() + "&imageQuality=20&contentType=" + getContentType(image, true));
		}
		if((image.getBigFilename() != null) && (image.getBigFilename().startsWith("-1")))
		{
			result.setBigImageURI(image.getBigFilename());
		}
		else
		{
			result.setBigImageURI("imageURN=" + result.getImageId() + "&imageQuality=90&contentType=" + getContentType(image, false));
		}
		
		return result;
	}
	
	private String getContentType(Image image, boolean isThumbnail)
	{
		String contentType = "";
		switch(image.getImgType())
		{
			// still color images
			case 1: // JPEG
			case 9: // bwmed
			case 17: // color scan
			case 18: // patient photo
			case 19: // XRAY JPEG
			// document images
			case 15: // TIF
				contentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + 
					ImageFormat.BMP.getMime();
				break;
			case 21: // motion video
				if(isThumbnail)
				{
					contentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
				}
				else
				{
					contentType = ImageFormat.AVI.getMime();
				}
				break;
			case 101: // html
				if(isThumbnail)
				{
					contentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
				}
				else
				{
					contentType = ImageFormat.HTML.getMime();
				}
				break;
			case 102: // Word document
				if(isThumbnail)
				{
					contentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
				}
				else
				{
					contentType = ImageFormat.DOC.getMime();
				}
				break;
			case 103: // text (ASCII text)
				if(isThumbnail)
				{
					contentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
				}
				else
				{
					contentType = ImageFormat.TEXT_PLAIN.getMime();
				}
				break;
			case 104: // PDF
				if(isThumbnail)
				{
					contentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
				}
				else
				{
					contentType = ImageFormat.PDF.getMime();
				}
				break;
			case 105: // RTF
				if(isThumbnail)
				{
					contentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
				}
				else
				{
					contentType = ImageFormat.RTF.getMime();
				}
				break;
			case 106: // Audio
				if(isThumbnail)
				{
					contentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
				}
				else
				{
					contentType = ImageFormat.WAV + "," + ImageFormat.MP3;
				}
				break;
			case 3: // XRAY
			case 100: // DICOM
				if(isThumbnail)
				{
					contentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TGA.getMime() + 
					"," + ImageFormat.BMP.getMime();
				}
				else
				{
					contentType = ImageFormat.DICOM.getMime() + "," + ImageFormat.J2K.getMime() + "," + ImageFormat.TGA.getMime();
				}
				break;
		}
		
		if(contentType.length() > 0)
		{
			contentType += ",*/*";
		}
		else
		{
			contentType = "*/*";
		}
		return contentType;
	}
	
	public ImageAccessLogEvent transformLogEvent(gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageAccessLogEventType logEventType) 
	throws URNFormatException 
	{
		if(logEventType == null)
			return null;
		// JMW 9/22/08 In the v2 Clin Disp web service the URN from the client might either be
		// an image URN or a study URN (for a single image study). In this case we don't know
		// which it will be so we try to convert the input into both before throwing an 
		// exception. This is handled better in the v3 Clin Disp web service.
		String imageId = null;
		String siteId = null;
		try
		{
			URN urn = URNFactory.create(logEventType.getImageId(), 
					SERIALIZATION_FORMAT.CDTP, ImageURN.class);
			if(urn instanceof ImageURN)
			{
				imageId = ((ImageURN)urn).getImageId();
				siteId = ((ImageURN)urn).getOriginatingSiteId();
			}
			else if(urn instanceof StudyURN)
			{
				imageId = ((StudyURN)urn).getStudyId();
				siteId = ((StudyURN)urn).getOriginatingSiteId();
			}
		}
		catch(URNFormatException iurnfX)
		{
		}
		
		ImageAccessLogEventType imageAccessLogEventType = transformLogEventType(logEventType.getEventType());
		ImageAccessLogEvent result = 
			new ImageAccessLogEvent(imageId, "", logEventType.getPatientIcn(), siteId, 
				System.currentTimeMillis(), logEventType.getReason(), "", 
				imageAccessLogEventType, logEventType.getCredentials().getSiteNumber());
		
		return result;
	}

	public ImageAccessLogEventType transformLogEventType(ImageAccessLogEventTypeEventType eventType) {

		return (eventType == ImageAccessLogEventTypeEventType.IMAGE_COPY 
							? ImageAccessLogEventType.IMAGE_COPY 
							: (eventType == ImageAccessLogEventTypeEventType.PATIENT_ID_MISMATCH ? ImageAccessLogEventType.PATIENT_ID_MISMATCH : ImageAccessLogEventType.IMAGE_PRINT));
	}
	
	public PingServerTypeResponse transformServerStatusToPingServerResponse(SiteConnectivityStatus siteStatus)
	{
		return (siteStatus == SiteConnectivityStatus.VIX_READY 
							? PingServerTypeResponse.SERVER_READY 
							: (siteStatus == SiteConnectivityStatus.DATASOURCE_UNAVAILABLE ? PingServerTypeResponse.VISTA_UNAVAILABLE : PingServerTypeResponse.SERVER_UNAVAILABLE));
	}
	
	/**
	 * Certain characters cannot be given to the Clinical Display client because they will cause exceptions
	 * in the parsing, they must be removed to ensure proper display of metadata. This function removes those
	 * characters and replaces them with a space
	 * @param input Input string to check
	 * @return
	 */
	private String extractIllegalCharacters(String input)
	{
		return (input == null ? "" : input.replaceAll("\\^", " "));	
	}
}
