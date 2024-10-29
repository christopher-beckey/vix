/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 4, 2008
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

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent.ImageAccessLogEventType;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.ImageAccessLogEventTypeEventType;

import java.math.BigInteger;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ClinicalDisplayTranslator 
{
	private final static Logger LOGGER = Logger.getLogger(ClinicalDisplayTranslator.class);
	
	private final static String clinicalDisplayWebserviceDateFormat = "MM/dd/yyyy";
	
	public ClinicalDisplayTranslator()
	{
		super();
	}
	
	// be careful about re-using SimpleDateFormat instances because they are not thread-safe 
	private DateFormat getClinicalDisplayWebserviceDateFormat()
	{
		return new SimpleDateFormat(clinicalDisplayWebserviceDateFormat);
	}
	
	/**
	 * Transform a clinical display webservice FilterType to an internal Filter instance.
	 * 
	 */
	public StudyFilter transformFilter(gov.va.med.imaging.clinicaldisplay.webservices.soap.FilterType filterType) 
	{
		StudyFilter filter = new StudyFilter();
		
		if(filterType != null) 
		{
			DateFormat df = getClinicalDisplayWebserviceDateFormat();
			
			Date fromDate = null;
			try
			{
				fromDate = filterType.getFromDate() == null  || filterType.getFromDate().length() == 0 ? null : df.parse(filterType.getFromDate());
			} 
			catch (ParseException x)
			{
                LOGGER.warn("ClinicalDisplayTranslator.transformFilter() --> Could not convert 'from date' [{}] to internal Date: {}", filterType.getFromDate(), x.getMessage());
			}
			
			Date toDate = null;
			try
			{
				toDate = filterType.getToDate() == null || filterType.getToDate().length() == 0 ? null : df.parse(filterType.getToDate());
			} 
			catch (ParseException x)
			{
                LOGGER.warn("ClinicalDisplayTranslator.transformFilter() --> Could not convert 'to date' [{}] to internal Date: {}", filterType.getToDate(), x.getMessage());
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
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.ShallowStudyType[] transformStudiesToShallowStudies(List<Study> studyList) 
	throws URNFormatException 
	{
		if(studyList == null || studyList.size() == 0)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.ShallowStudyType [] res = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.ShallowStudyType[studyList.size()];
		
		int index = 0;
		for(Iterator<Study> studiesIter = studyList.iterator(); studiesIter.hasNext(); ++index)
			res[index] = transformStudyToShallowStudy(studiesIter.next());
		
		return res;
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.ShallowStudyType transformStudyToShallowStudy(Study study) 
	throws URNFormatException 
	{
		if(study == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.ShallowStudyType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.ShallowStudyType();
		
		result.setDescription(study.getDescription());
		result.setEvent(study.getEvent());
		result.setImageCount(BigInteger.valueOf(study.getImageCount()));
		result.setImagePackage(study.getImagePackage());
		result.setImageType(study.getImageType());
		result.setNoteTitle(study.getNoteTitle());
		result.setOrigin(study.getOrigin());
		result.setPatientIcn(study.getPatientId());
		result.setPatientName(study.getPatientName());
		result.setProcedure(study.getProcedure());
		result.setRadiologyReport(study.getRadiologyReport());
		result.setSiteNumber(study.getSiteNumber());
		result.setSpecialty(study.getSpecialty());
		
		// 2/19/08 - now include the site name so the Display client shows what specific DOD facility the study is from
		if(ExchangeUtil.isSiteDOD(study.getSiteNumber()))
		{
			result.setSiteAbbreviation(study.getSiteAbbr()+ (study.getSiteName() != null ? "-" + study.getSiteName() : ""));			
		}
		else
		{
			result.setSiteAbbreviation(study.getSiteAbbr());
		}				
		result.setStudyPackage(study.getImagePackage());
		result.setStudyClass(study.getStudyClass() == null ? "" : study.getStudyClass()); // get this from study
		result.setStudyType(study.getImageType());
		result.setCaptureDate(study.getCaptureDate());
		result.setCapturedBy(study.getCaptureBy());		
		if(study.getProcedureDate() == null)
		{
			LOGGER.warn("ClinicalDisplayTranslator.transformStudyToShallowStudy() --> Setting empty procedure date for study");
			result.setProcedureDate("");
		}
		else
		{
			result.setProcedureDate(getClinicalDisplayWebserviceDateFormat().format(study.getProcedureDate()));
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
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.FatImageType firstImage = 
			transformImageToFatImage(study.getFirstImage(), firstSeries);
		
		result.setFirstImage(firstImage);
		
		// need to add site number field
			
		GlobalArtifactIdentifier studyIdentifier = "200".equals(study.getSiteNumber()) ? BhieStudyURN.create(study.getStudyIen(), study.getPatientId()) : study.getStudyUrn();
		
		result.setStudyId(studyIdentifier.toString());
		
		return result;
	}
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.FatImageType[] transformStudyToFatImages(Study study) 
	throws URNFormatException 
	{
		if(study == null)
			return null;
		
		if(study.getSeries() == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.FatImageType[] result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.FatImageType[study.getImageCount()];
		
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

	public gov.va.med.imaging.clinicaldisplay.webservices.soap.FatImageType transformImageToFatImage(
		Image image, 
		Series series) 
	throws URNFormatException 
	{
		if(image == null)
			return null;
		
		gov.va.med.imaging.clinicaldisplay.webservices.soap.FatImageType result = 
			new gov.va.med.imaging.clinicaldisplay.webservices.soap.FatImageType();
		
		result.setDescription(image.getDescription());
		result.setDicomImageNumber(image.getDicomImageNumberForDisplay());
		result.setDicomSequenceNumber((series != null) && (series.getSeriesNumber() != null) && (series.getSeriesNumber().length() > 0) ? series.getSeriesNumber() : image.getDicomSequenceNumberForDisplay());
		result.setPatientIcn(image.getPatientId());
		result.setPatientName(image.getPatientName());
		result.setProcedure(image.getProcedure());
		if(image.getProcedureDate() == null)
		{
			LOGGER.warn("ClinicalDisplayTranslator.transformImageToFatImage() --> Setting empty procedure date for image");
			result.setProcedureDate("");
		}
		else 
		{
			result.setProcedureDate(getClinicalDisplayWebserviceDateFormat().format(image.getProcedureDate()));
		}
		result.setSiteNumber(image.getSiteNumber());
		result.setSiteAbbr(image.getSiteAbbr());
		result.setImageClass(image.getImageClass());
		result.setAbsLocation(image.getAbsLocation());
		result.setFullLocation(image.getFullLocation());
		
		result.setQaMessage(image.getQaMessage());
		result.setImageType(BigInteger.valueOf(image.getImgType()));

		// The URN classes are responsible for serializing themselves using a filename safe character set
		result.setImageId( image.getGlobalArtifactIdentifier().toString(SERIALIZATION_FORMAT.CDTP) );
		result.setAbsImageURI("imageURN=" + result.getImageId() + "&imageQuality=20&contentType=image/jpeg");
		result.setFullImageURI("imageURN=" + result.getImageId() + "&imageQuality=70&contentType=application/dicom");
		result.setBigImageURI("imageURN=" + result.getImageId() + "&imageQuality=90&contentType=application/dicom");

		return result;
	}
	
	public ImageAccessLogEvent transformLogEvent(gov.va.med.imaging.clinicaldisplay.webservices.soap.ImageAccessLogEventType logEventType) 
	throws URNFormatException 
	{
		if(logEventType == null)
			return null;
		
		ImageURN imageUrn = URNFactory.create(logEventType.getImageId(), SERIALIZATION_FORMAT.CDTP, ImageURN.class);
		
		ImageAccessLogEventType imageAccessLogEventType = transformLogEventType(logEventType.getEventType());
		ImageAccessLogEvent result = 
			new ImageAccessLogEvent(imageUrn.getImageId(), "", logEventType.getPatientIcn(), 
					imageUrn.getOriginatingSiteId(), System.currentTimeMillis(), 
					logEventType.getReason(), "", imageAccessLogEventType, 
					logEventType.getCredentials().getSiteNumber());
		
		return result;
	}

	public ImageAccessLogEventType transformLogEventType(gov.va.med.imaging.clinicaldisplay.webservices.soap.ImageAccessLogEventTypeEventType eventType) 
	{
		return (eventType == ImageAccessLogEventTypeEventType.IMAGE_COPY ? ImageAccessLogEventType.IMAGE_COPY : ImageAccessLogEventType.IMAGE_PRINT);
	}
}
