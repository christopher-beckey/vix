/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Nov 14, 2016
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
package gov.va.med.imaging.mix.webservices.translator.v1;

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
// import gov.va.med.imaging.mix.MixFilter;
import gov.va.med.imaging.mix.VAImageID;
import gov.va.med.imaging.mix.VAStudyID;
import gov.va.med.imaging.exchange.ProcedureFilter;
// import gov.va.med.imaging.exchange.business.Image;
// import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.exchange.enums.ProcedureFilterMatchMode;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ImagingStudy;
import gov.va.med.imaging.mix.webservices.rest.types.v1.Instance;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ModCodeType;
// import gov.va.med.imaging.mix.webservices.rest.types.v1.InstancesType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReferenceType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.Series;
// import gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesesType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType;
import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslatorV1;

/**
 * @author vacotittoc
 *
 */
public class MixTranslator 
{
	private final static Logger logger = Logger.getLogger(MixTranslator.class);
	
	//private final static String webserviceDateFormat = "yyyyMMddHHmmss.SSSSSSZ";
	// be careful about re-using SimpleDateFormat instances because they are not thread-safe 
	private DateFormat getWebserviceDateFormat()
	{
		return new DicomDateFormat();
		//return new SimpleDateFormat(webserviceDateFormat);
	}
	
	public StudyFilter transformFilter(gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType filterType) {
		
		//(credentials == null ? "null" : "" + credentials.toString()) + ")")
		
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
                logger.error("ParseException converting webservice format string from-date '{}' to internal Date", filterType.getFromDate(), x);
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
                logger.error("ParseException converting webservice format string to-date '{}' to internal Date", filterType.getToDate(), x);
				toDate = null;
			}
			
			filter.setFromDate(fromDate);
			filter.setToDate(toDate);
			// the study Id recieved in the filter (from the DOD) should be the entire study URN
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
				catch(ClassCastException ccX) {
					filter.setStudyId(null);
				}
				catch(URNFormatException iurnfX) {
					filter.setStudyId(null);
				}
				
			}
			//filter.setStudyId(filterType.getStudyId() == null ? "" : "" + filterType.getStudyId());
		}		
		return filter;
	}
	
	/*
	public StudyFilter transformFilter(gov.va.med.imaging.mix.webservices.fhir.types.v1.FilterType filter)
	{
		if(filter == null)
			return null;	
		Date fromDate = null;
		if(filter.getFromDate() != null)
		{
			fromDate = ExchangeUtil.convertDICOMDateToDate(filter.getFromDate());
		}
		Date toDate = null;
		if(filter.getToDate() != null)
		{
			toDate = ExchangeUtil.convertDICOMDateToDate(filter.getToDate());
		}
		StudyFilter studyFilter = new StudyFilter(fromDate, toDate, filter.getStudyId());		
		return studyFilter;
	}
	*/
	public static String translateProcedureDateToDicom(Date procedureDate) 
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
	
	public static StudyType transformStudy(Study study) 
	throws URNFormatException, ParseException
	{
		if(study == null)
			return null;
		// don't return the study if there is a questionable integrity/error condition
		if(study.hasErrorMessage())
		{
            logger.debug("Study [{}] has error message, excluding from results.", study.getStudyIen());
			return null;
		}
		if(study.isDeleted())
		{
            logger.debug("Study [{}] is deleted, excluding from results.", study.getStudyIen());
			return null;
		}
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType();
		
		StudyURN studyURN = study.getStudyUrn();// StudyURN.create(study.getSiteNumber(), study.getStudyIen(), study.getPatientIcn());
		
		studyType.setStudyId( studyURN.toString() );
		studyType.setDescription(study.getDescription());
//		studyType.setProcedureDate(study.getProcedureDate()); // yyyyMMddhhmmss.SSSSSS > yyyy-MM-dd
		studyType.setProcedureDate(translateProcedureDateToDicom(study.getProcedureDate()));
		
		studyType.setProcedureDescription(study.getProcedure());
		studyType.setPatientId(study.getPatientId());
		studyType.setPatientName(study.getPatientName());
		studyType.setSiteNumber(study.getSiteNumber());
		studyType.setSiteAbbreviation(study.getSiteAbbr());
		studyType.setSeriesCount(study.getSeriesCount());
		studyType.setImageCount(study.getImageCount());
		studyType.setSpecialtyDescription(study.getSpecialty());
		studyType.setReportContent(study.getRadiologyReport());
		studyType.setSiteName(study.getSiteName());
		
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (study.getStudyUid() != null && study.getStudyUid().trim().length() > 0)
		{
			studyType.setDicomUid(study.getStudyUid());
		}
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries wrapper = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries();
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[] componentSeries = 
			(gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[])transformSerieses(study);

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

	
	public static ImagingStudy translateStudy(Study study) 
	throws URNFormatException, ParseException
	{
		if(study == null)
			return null;
		// don't return the study if there is a questionable integrity/error condition
		if(study.hasErrorMessage())
		{
            logger.debug("Study [{}] has error message, excluding from results.", study.getStudyIen());
			return null;
		}
		if(study.isDeleted())
		{
            logger.debug("Study [{}] is deleted, excluding from results.", study.getStudyIen());
			return null;
		}
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.ImagingStudy imagingStudy = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.ImagingStudy();
		
		// create a MIX smart study URN that is passes as study UID
		StudyURN studyURN = study.getStudyUrn();// StudyURN.create(study.getSiteNumber(), study.getStudyIen(), study.getPatientIcn());
		VAStudyID vaStudyID = new VAStudyID();
		String theMIXStudyUid = vaStudyID.create(studyURN.getOriginatingSiteId(), studyURN.getStudyId(), studyURN.getPatientId()); // patientICN !!!
		
		imagingStudy.setUid(theMIXStudyUid); // this a rather a MIX tailored VAstudyURN
		imagingStudy.setDescription(study.getDescription());
		imagingStudy.setStarted(MixTranslatorV1.translateDateToJSON(study.getProcedureDate())); // yyyyMMddhhmmss.SSSSSS > yyyy-MM-ddTHH:MI+HH:MI !!!
		
		ReferenceType procedure = new ReferenceType("Procedure/"+study.getProcedure());
		imagingStudy.setProcedure(procedure);
//		imagingStudy.setProcedure(study.getProcedure());
		ReferenceType patient = new ReferenceType("Patient/"+study.getPatientId());
		imagingStudy.setPatient(patient);
		// studyType.setPatientName(study.getPatientName());
		// studyType.setSeriesCount(study.getSeriesCount());
		// studyType.setImageCount(study.getImageCount());
		// imagingStudy.setDescription(study.getSpecialty());
		// studyType.setReportContent(study.getRadiologyReport()); *** this must be set on DR level!
		int numMods = study.getModalities().size();

		String serMty = (numMods!=1) ? "": "" + (study.getModalities().toString().replace("[", "").replace("]", "")); // try delegating Study modality if Series modality is empty
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.Series[] serieses = 
			(gov.va.med.imaging.mix.webservices.rest.types.v1.Series[])translateSerieses(study, theMIXStudyUid, serMty);

        logger.debug("MIX Study serieses in SeriesesType: {}", serieses.length); // *** Comment this out
		// JMW 7/16/08 accurately get the number of images by actually counting the images from each
		// series
		// This has to be done this way because while the internal count of images is now accurate, 
		// we might not give all of the internal images through this interface, this interface excludes
		// all questionable integrity images and studies/images with other problems.
		for(gov.va.med.imaging.mix.webservices.rest.types.v1.Series series : serieses)
		{
			if (series.getInstance()!=null) {
//				// no need to add instances to the series again as its done in translateSeries(VistaSeries series, String seriesDescription)				
//
//				for(gov.va.med.imaging.mix.webservices.rest.types.v1.Instance instance : series.getInstance())
//				{
//					series.addInstance(instance);
//				}
				imagingStudy.addSeries(series);
			}
		}
        logger.debug("MIX {} series added to imagingStudy. ", imagingStudy.getSeries().length); // *** Comment this out
		
		// series with no instances will be suppressed, so the only way to know the correct
		// series count is to use the length of the returned array - DKB
		// studyType.setSeriesCount(serieses.length);
		
		// wrapper.setSeries(serieses);
		// studyType.setComponentSeries(wrapper);
		
		if(study.getModalities() != null)
		{
//			String modalitiesinStudy = "";
//			for(String modality : study.getModalities())
//			{
//				if (!modalitiesinStudy.isEmpty())
//					modalitiesinStudy += ",";
//				modalitiesinStudy += modality;
//			}
//			imagingStudy.setModalitiesInStudy(modalitiesinStudy);
			// [{\"code\": \" + modality + \"}]
			ModCodeType[] modCodeArray = new ModCodeType[numMods];
			
			int i=0;
			for(String modality : study.getModalities())
			{
				modCodeArray[i] = new ModCodeType(modality);
				i++;
			}

			imagingStudy.setModalitiesInStudy(modCodeArray);
		}
		
		return imagingStudy;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.webservices.BusinessObjectIntepreter#transformImages(java.util.List)
	 */
	public gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType[] transformStudies(List<Study> studyList) 
	throws URNFormatException, ParseException
	{
		if(studyList == null || studyList.size() == 0)
			return null;
		
		// need dynamic list because not all internal studies might be given through this interface
		List<gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType> validStudyTypes = new
		 	ArrayList<gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType>(studyList.size());
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType[] result = null;

		for(Study study : studyList)
		{
			gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType = transformStudy(study);
			if(studyType != null)
				validStudyTypes.add(studyType);
		}
		
		result = validStudyTypes.toArray(new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType[validStudyTypes.size()]);		
		return result;
	}
	
	public static Object[] transformSerieses(Study study) 
	throws URNFormatException 
	{
		Set<gov.va.med.imaging.exchange.business.Series> seriesSet = study.getSeries();
		if(seriesSet == null || seriesSet.size() == 0)
			return null;

		ArrayList<gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType> result =
			new ArrayList<gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType>();
		
		for(Iterator<gov.va.med.imaging.exchange.business.Series> seriesIter = seriesSet.iterator(); seriesIter.hasNext(); )
		{
			gov.va.med.imaging.exchange.business.Series series = seriesIter.next();
			// Filter series with no images from the result set - DKB
			if (series.getImageCount() > 0)
			{
				result.add(transformSeries(series, study.getDescription()));
			}
		}
		
		return result.toArray(new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[result.size()]);
	}

	public static Series[] translateSerieses(Study study, String stdOID, String mty) 
	throws URNFormatException 
	{
		Set<gov.va.med.imaging.exchange.business.Series> seriesSet = study.getSeries();
		if(seriesSet == null || seriesSet.size() == 0)
			return null;

		// Serieses[] serieses = new Serieses[seriesSet.size()];
		Series[] seriesArray = new Series[seriesSet.size()];
		
		int i=0;
		String serOID=null;
		for(Iterator<gov.va.med.imaging.exchange.business.Series> seriesIter = seriesSet.iterator(); seriesIter.hasNext(); )
		{
			gov.va.med.imaging.exchange.business.Series series = seriesIter.next();
			// Filter series with no images from the result set - DKB -- does this apply here???
			if (series.getImageCount() > 0)
			{
				serOID=stdOID.replace("vastudy", "vaseries") + "-" + String.valueOf(i+1); // mock vaseries OID like 'stdOID-ser#'
				seriesArray[i] = translateSeries(series, study.getDescription(), serOID, mty);
				i++;
			}
		}
        logger.debug("MIX Study SeriesArray[] got {} members of {}", i, seriesSet.size());

		if (i<seriesSet.size()) {
		// resize/remake array in case there were Series without Instances
			Series[] seriesArray2 = new Series[i];
			for (int j=0; j<i; j++)
				seriesArray2[j] = seriesArray[j];
			return seriesArray2;
		}

		// serieses.setSerieses(seriesArray);
		// return serieses;
		return seriesArray;
	}

	/**
	 * 
	 * @param series
	 * @param seriesDescription
	 * @return
	 * @throws URNFormatException
	 */
	public static gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType transformSeries(gov.va.med.imaging.exchange.business.Series series, 
			String seriesDescription) 
	throws URNFormatException
	{
		if(series == null)
			return null;
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType result = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType();
		// need to use a dynamic list because we might not be sending all images through this interface
		List<gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType> validInstances = 
			new ArrayList<gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType>(series.getImageCount());
		
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType[] seriesInstances = null;

		for(gov.va.med.imaging.exchange.business.Image image : series)
		{
			gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType instanceType = transformImage(image);
			if(instanceType != null)
				validInstances.add(instanceType);
		}
		seriesInstances = 
			validInstances.toArray(new gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType[validInstances.size()]);
		
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
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances instancesWrapper = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances();
		instancesWrapper.setInstance(seriesInstances);
		result.setComponentInstances(instancesWrapper);
		
		return result;
	}

	/**
	 * Translates a VI Series into an FHIR Series
	 * @param series a VI series
	 * @param seriesDescription
	 * @return
	 * @throws URNFormatException
	 */
	public static Series translateSeries(gov.va.med.imaging.exchange.business.Series series, String seriesDescription, String serOID, String modality) 
	throws URNFormatException
	{
		if(series == null)
			return null;
		
		Series result =	new Series();

		if(!"".equals(series.getSeriesNumber())) {
			int serNum = Integer.parseInt(series.getSeriesNumber());
			result.setNumber(serNum);
		}
		String mty = ((series.getModality()==null) || series.getModality().isEmpty()) ? modality : series.getModality();
		ModCodeType mct = new ModCodeType(mty);
		result.setModality(mct);
		//TODO: do we want to have a series URN or should we just use the series IEN from VistA?
		String serUID = ((series.getSeriesUid()==null) || series.getSeriesUid().isEmpty()) ? serOID : series.getSeriesUid();
		result.setUid(serUID);
		result.setAvailability("ONLINE");
		//TODO: retrieve series through VistA if possible (available in DICOM txt files)
		result.setDescription(seriesDescription);
		// result.setStarted(translateDateToJSON(series.???));

		// need to use a dynamic list because we might not be sending all images through this interface
		// InstancesType allInstances = new InstancesType();
		Instance [] instancesArray = new Instance[series.getImageCount()];
		int i=0;
		for(gov.va.med.imaging.exchange.business.Image image : series)
		{
			Instance instance = translateImage(image);
			if(instance != null) {
				instancesArray[i] = instance;
				i++;
			}
		}
		// allInstances.setInstances(instancesArray);

        logger.debug("MIX Series instancesArray[] got {} members of {}", i, series.getImageCount());

		if (i<series.getImageCount()) {
		// resize/remake array in case there were empty? images in series
			// InstancesType validInstances = new InstancesType();
			Instance[] instancesArray2 = new Instance[i];
			for (int j=0; j<i; j++)
				instancesArray2[j] = instancesArray[j];
			// validInstances.setInstances(instancesArray2);
			result.setInstances(instancesArray2);
		} else {
			result.setInstances(instancesArray);
		}
		
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (series.getSeriesUid() != null && series.getSeriesUid().trim().length() > 0)
		{
			result.setUid(series.getSeriesUid());
		}
		
		// result.setImageCount(seriesInstances.length);
		
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
	public static gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType transformImage(gov.va.med.imaging.exchange.business.Image image) 
	throws ImageURNFormatException
	{
		if(image == null)
			return null;
		// JMW 7/17/08 - if the image has an error message then don't provide the image to the DOD
		if(image.hasErrorMessage())
		{
            logger.debug("Image [{}] has error message, excluding from results.", image.getIen());
			return null;
		}
		if(image.isDeleted())
		{
            logger.debug("Image [{}] is deleted, excluding from results.", image.getIen());
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
				instanceType.setImageUrn( (ImageURNFactory.create(image.getSiteNumber(), image.getIen(), image.getStudyIen(), image.getPatientId(), image.getImageModality(), ImageURN.class)).toString() );
			}
			catch (URNFormatException x)
			{
				throw new ImageURNFormatException(x);
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

	/* 
	 * Translates a VI Image into an FHIR Instance
	 */
	public static Instance translateImage(gov.va.med.imaging.exchange.business.Image image) 
	throws ImageURNFormatException
	{
		if(image == null) 
		{
			logger.debug("MIX returns Instance=null for Image = null."); // *** comment out
			return null;
		}

		// JMW 7/17/08 - if the image has an error message then don't provide the image to the DOD
		if(image.hasErrorMessage())
		{
            logger.debug("MIX: Image [{}] has error message, excluding from results.", image.getIen());
			return null;
		}
		if(image.isDeleted())
		{
            logger.debug("MIX: Image [{}] is deleted, excluding from results.", image.getIen());
			return null;
		}
		
		Instance instance = new Instance();
		
		try
		{
			if(image.getGlobalArtifactIdentifier() instanceof ImageURN)
			{
                logger.debug("MIX implanting smart VAImageID for Image [{}].", image.getIen()); // *** comment out
				// implanting smart VAImageID, so on external request the ID tells which site to route to
				ImageURN imageURN = image.getImageUrn();
				VAImageID vaImageID = new VAImageID();
				String theMIXImageUid = vaImageID.create(imageURN.getOriginatingSiteId(), imageURN.getImageId(), imageURN.getStudyId(), imageURN.getPatientId()); // patientICN !!!
				instance.setUid(theMIXImageUid); 
			}
			else if(image.getGlobalArtifactIdentifier() instanceof BhieImageURN) 
			{ // this is not our case
                logger.debug("MIX use BHIEImageURN for Image [{}].", image.getIen()); // *** comment out
				instance.setUid(((BhieImageURN)image.getGlobalArtifactIdentifier()).toString());
			}
			else 
			{
                logger.debug("MIX use ImageURNFactory for Image [{}].", image.getIen()); // *** comment out
				instance.setUid( (ImageURNFactory.create(image.getSiteNumber(), image.getIen(), image.getStudyIen(), image.getPatientId(), image.getImageModality(), ImageURN.class)).toString() );
			}
		}
		catch (URNFormatException x)
		{
				throw new ImageURNFormatException(x);
		}
		
		if (image.getDicomImageNumberForDisplay()!= null && image.getImageNumber().trim().length() > 0)
		{
			try
			{
				Integer imageNumber = new Integer(image.getImageNumber());
				instance.setNumber(imageNumber);
			}
			catch (NumberFormatException ex)
			{
				// not a number - return null
				instance.setNumber(null);
			}
		}
		else
		{
			instance.setNumber(null);
		}

        logger.debug("MIX returns Instance[{}; #={}] for Image [{}] record.", instance.getUid(), instance.getNumber(), image.getIen());
		return instance;
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.webservices.BusinessObjectIntepreter#transformImages(java.util.List)
	 */
	/*
	public gov.va.med.imaging.mix.webservices.fhir.types.v1.InstanceType[] transformImages(List<Image> imageList) 
	throws ImageURNFormatException
	{
		if(imageList == null || imageList.size() == 0)
			return null;
		
		gov.va.med.imaging.mix.webservices.fhir.types.v1.InstanceType[] result = 
			new gov.va.med.imaging.mix.webservices.fhir.types.v1.InstanceType[ imageList.size() ];
		
		int index=0;
		for(Iterator<Image> imageIter = imageList.iterator(); imageIter.hasNext(); ++index)
			result[index] = transformImage(imageIter.next());
		
		
		return result;
	}
	*/
	
	public String getParentIen(gov.va.med.imaging.exchange.business.Image image)
	{
		return image.getStudyIen();
	}

}
