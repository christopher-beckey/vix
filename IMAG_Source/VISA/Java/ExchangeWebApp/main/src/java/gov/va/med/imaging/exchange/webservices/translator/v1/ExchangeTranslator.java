/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 30, 2008
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
package gov.va.med.imaging.exchange.webservices.translator.v1;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import gov.va.med.logging.Logger;
import gov.va.med.ImageURNFactory;
import gov.va.med.URNFactory;
import gov.va.med.imaging.*;
import gov.va.med.imaging.exceptions.ImageURNFormatException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ExchangeFilter;
import gov.va.med.imaging.exchange.ProcedureFilter;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.exchange.enums.ProcedureFilterMatchMode;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.ModalitiesType;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ExchangeTranslator 
{
	private final static Logger LOGGER = Logger.getLogger(ExchangeTranslator.class);
	
	//private final static String webserviceDateFormat = "yyyyMMddHHmmss.SSSSSSZ";
	// be careful about re-using SimpleDateFormat instances because they are not thread-safe 
	private DateFormat getWebserviceDateFormat()
	{
		return new DicomDateFormat();
		//return new SimpleDateFormat(webserviceDateFormat);
	}
	
	public StudyFilter transformFilter(gov.va.med.imaging.exchange.webservices.soap.types.v1.FilterType filterType) {
		
		//(credentials == null ? "null" : credentials.toString()) + ")")
		
		ProcedureFilter filter = new ProcedureFilter(ProcedureFilterMatchMode.existInProcedureList);
		// JMW - for now set to level 2 as allowed, might change later if can get information from DoD
		// this is the same level we have always been providing to the DoD.
		filter.setMaximumAllowedLevel(PatientSensitivityLevel.DISPLAY_WARNING_REQUIRE_OK);
		if(filterType != null) 
		{
			DateFormat df = getWebserviceDateFormat();
			
			Date fromDate = null;
			try
			{
				fromDate = filterType.getFromDate() == null || filterType.getFromDate().length() == 0 ? 
						null : 
						df.parse(filterType.getFromDate());
			} 
			catch (ParseException x)
			{
                LOGGER.warn("ExchangeTranslator.transformFilter() --> Error while translating given from-date [{}]: {}", filterType.getFromDate(), x.getMessage());
				fromDate = null;
			}
			
			Date toDate = null;
			try
			{
				toDate = filterType.getToDate() == null || filterType.getToDate().length() == 0 ? 
						null : 
						df.parse(filterType.getToDate());
			} 
			catch (ParseException x)
			{
                LOGGER.warn("ExchangeTranslator.transformFilter() --> Error while translating given to-date [{}]: {}", filterType.getToDate(), x.getMessage());
				toDate = null;
			}
			
			filter.setFromDate(fromDate);
			filter.setToDate(toDate);
			// the study Id received in the filter (from the DOD) should be the entire study URN
			// need to convert that to just the internal study Id value (IEN)
			if(filterType.getStudyId() == null) 
			{
				filter.setStudyId(null);
			}
			else {
				try {
					StudyURN studyUrn = URNFactory.create(filterType.getStudyId(), StudyURN.class);
					filter.setStudyId(studyUrn);
				}
				catch(Exception ccX) {
                    LOGGER.warn("ExchangeTranslator.transformFilter() --> Error while creating StudyURN: {}", ccX.getMessage());
					filter.setStudyId(null);
				}				
			}
			//filter.setStudyId(filterType.getStudyId() == null ? "" : filterType.getStudyId());
		}		
		return filter;
	}
	
	public String translateProcedureDateToDicom(Date procedureDate) 
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
	 * Translate a String date into a DICOM formatted String date.
	 * 
	 * @param dateString
	 * @return
	 * @throws ParseException
	 */
	public String translateProcedureDateToDicom(String dateString) 
	throws ParseException
	{
		String procedureDateStringAsDicom = "";
		if (dateString != null)
		{
			String trimmedDateString = dateString.trim();
			if (trimmedDateString.length() > 0)
			{
				DateFormat procedureDateFormat = null;
				DateFormat dicomDateFormat = new DicomDateFormat();
				// post patch 59 dates include time-of-day segment
				procedureDateFormat = dateString.indexOf(":") >= 0 ?  
					new SimpleDateFormat("MM/dd/yyyy HH:mm") :
					new SimpleDateFormat("MM/dd/yyyy");
				Date procedureDate = procedureDateFormat.parse(trimmedDateString);
				procedureDateStringAsDicom = dicomDateFormat.format(procedureDate);
			}
		}
		return procedureDateStringAsDicom;
	}
	
	public StudyType transformStudy(Study study) 
	throws URNFormatException, ParseException
	{
		if(study == null)
			return null;
		// don't return the study if there is a questionable integrity/error condition
		if(study.hasErrorMessage())
		{
            LOGGER.warn("ExchangeTranslator.transformStudy() --> Study Id [{}] has error message, excluding from results.  Return null.", study.getStudyIen());
			return null;
		}
		
		if(study.isDeleted())
		{
            LOGGER.debug("ExchangeTranslator.transformStudy() --> Study Id [{}] is deleted, excluding from results.  Return null.", study.getStudyIen());
			return null;
		}
		
		gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType studyType = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType();
		
		StudyURN studyURN = study.getStudyUrn();// StudyURN.create(study.getSiteNumber(), study.getStudyIen(), study.getPatientIcn());
		
		studyType.setStudyId( studyURN.toString() );
		studyType.setDescription(study.getDescription());
		studyType.setProcedureDate(translateProcedureDateToDicom(study.getProcedureDate()));
		
		studyType.setProcedureDescription(study.getProcedure());
		studyType.setPatientId(study.getPatientId());
		studyType.setPatientName(study.getPatientName());
		studyType.setSiteNumber(study.getSiteNumber());
		studyType.setSiteAbbreviation(study.getSiteAbbr());
		studyType.setSpecialtyDescription(study.getSpecialty());
		studyType.setRadiologyReport(study.getRadiologyReport());
		studyType.setSiteName(study.getSiteName());
		
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (study.getStudyUid() != null && study.getStudyUid().trim().length() > 0)
		{
			studyType.setDicomUid(study.getStudyUid());
		}
		
		gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyTypeComponentSeries wrapper = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyTypeComponentSeries();
		
		gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType[] componentSeries = 
			(gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType[])transformSerieses(study);

		// JMW 7/16/08 accurately get the number of images by actually counting the images from each
		// series
		// This has to be done this way because while the internal count of images is now accurate, 
		// we might not give all of the internal images through this interface, this interface excludes
		// all questionable integrity images and studies/images with other problems.
		int imageCount = 0;
		for(gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType series : componentSeries)
		{
			imageCount += series.getImageCount();
		}
		studyType.setImageCount(imageCount);
		
		// series with no instances will be suppressed, so the only way to know the correct
		// series count is to use the length of the returned array - DKB
		studyType.setSeriesCount(componentSeries.length);
		
		wrapper.setSeries(componentSeries);
		studyType.setComponentSeries(wrapper);
		
		if(study.getModalities() != null)
		{
			String modalities[] = new String[study.getModalities().size()];
			int i = 0;
			for(String modality : study.getModalities())
			{
				modalities[i] = modality;
				i++;
			}
			ModalitiesType modalitiesType = new ModalitiesType(modalities);
			studyType.setModalities(modalitiesType);
		}
		
		return studyType;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.webservices.BusinessObjectIntepreter#transformImages(java.util.List)
	 */
	public gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType[] transformStudies(List<Study> studyList) 
	throws URNFormatException, ParseException
	{
		if(studyList == null || studyList.size() == 0)
			return null;
		
		// need dynamic list because not all internal studies might be given through this interface
		List<gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType> validStudyTypes = new
		 	ArrayList<gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType>(studyList.size());
		
		gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType[] result = null;

		for(Study study : studyList)
		{
			gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType studyType = transformStudy(study);
			if(studyType != null)
				validStudyTypes.add(studyType);
		}
		
		result = validStudyTypes.toArray(new gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType[validStudyTypes.size()]);		
		return result;
	}
	
	public Object[] transformSerieses(Study study) 
	throws URNFormatException 
	{
		Set<Series> seriesSet = study.getSeries();
		if(seriesSet == null || seriesSet.size() == 0)
			return null;

		ArrayList<gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType> result =
			new ArrayList<gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType>();
		
		for(Iterator<Series> seriesIter = seriesSet.iterator(); seriesIter.hasNext(); )
		{
			Series series = seriesIter.next();
			// Filter series with no images from the result set - DKB
			if (series.getImageCount() > 0)
			{
				result.add(transformSeries(series, study.getDescription()));
			}
		}
		
		return result.toArray(new gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType[result.size()]);
	}

	/**
	 * 
	 * @param series
	 * @param seriesDescription
	 * @return
	 * @throws URNFormatException
	 */
	public gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType transformSeries(Series series, 
			String seriesDescription) 
	throws URNFormatException
	{
		if(series == null)
			return null;
		
		gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType result = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType();
		// need to ues a dynamic list because we might not be sending all images through this interface
		List<gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType> validInstances = 
			new ArrayList<gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType>(series.getImageCount());
		
		
		gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType[] seriesInstances = null;

		for(Image image : series)
		{
			gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType instanceType = transformImage(image);
			if(instanceType != null)
				validInstances.add(instanceType);
		}
		seriesInstances = 
			validInstances.toArray(new gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType[validInstances.size()]);
		
		//TODO: retrieve series through VistA if possible (available in DICOM txt files)
		result.setDescription(seriesDescription);

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
		gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesTypeComponentInstances instancesWrapper = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesTypeComponentInstances();
		instancesWrapper.setInstance(seriesInstances);
		result.setComponentInstances(instancesWrapper);
		
		return result;
	}

	/*
	 * =================================================================================
	 * Image Transforms
	 * =================================================================================
	 */
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.webservices.BusinessObjectIntepreter#transformImage(gov.va.med.imaging.exchange.business.Image)
	 */
	public gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType transformImage(Image image) 
	throws ImageURNFormatException
	{
		if(image == null)
			return null;
		// JMW 7/17/08 - if the image has an error message then don't provide the image to the DOD
		if(image.hasErrorMessage())
		{
            LOGGER.debug("ExchangeTranslator.transformImage() --> Image [{}] has error message, excluding from results.  Return null.", image.getIen());
			return null;
		}
		if(image.isDeleted())
		{
            LOGGER.debug("ExchangeTranslator.transformImage() --> Image [{}] is deleted, excluding from results. Return null.", image.getIen());
			return null;
		}
		
		gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType instanceType = 
			new gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType();
		
		if(image.getGlobalArtifactIdentifier() instanceof ImageURN)
			instanceType.setImageUrn(image.getGlobalArtifactIdentifier().toString());
		else if(image.getGlobalArtifactIdentifier() instanceof BhieImageURN)
			instanceType.setImageUrn( ((BhieImageURN)image.getGlobalArtifactIdentifier()).toString());
		else
			try
			{
				instanceType.setImageUrn( (ImageURNFactory.create(image.getSiteNumber(), image.getIen(), image.getStudyIen(), image.getPatientId(), image.getImageModality(), ImageURN.class)).toString() );
			}
			catch (URNFormatException x)
			{
				String msg = "ExchangeTranslator.transformImage() --> Encountered error: " + x.getMessage();
				LOGGER.debug(msg);
				throw new ImageURNFormatException(msg);
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
	
	public String getParentIen(Image image)
	{
		return image.getStudyIen();
	}
}
