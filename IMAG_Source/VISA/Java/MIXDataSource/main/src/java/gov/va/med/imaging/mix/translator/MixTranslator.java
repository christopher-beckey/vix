package gov.va.med.imaging.mix.translator;

import gov.va.med.*;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.ObjectOrigin;
import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.enums.VistaImageType;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import gov.va.med.logging.Logger;

public class MixTranslator 
{
	
	private static Logger logger = Logger.getLogger(MixTranslator.class);	

	/**
	 * Transforms an array of webservice proxy studies into a sorted set of business study objects
	 * @param studies array of webservice proxy studies
	 * @return sorted set of business study objects
	 */
	public SortedSet<Study> transformStudies(
		Site site, 
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType[] studies,
		StudyFilter filter,
		List<String> emptyStudyModalities) 
	{
		// Improve a bit
		if(studies == null) 
		{
			if(logger.isDebugEnabled()){logger.debug("MixTranslator.transformStudies() --> Given StudyType array is null.  Return null.");}
			return null;
		}
		
		SortedSet<Study> result = new TreeSet<Study>();
		
		String filterStudyAsString = filter != null && filter.getStudyId() != null ?
			filter.getStudyId() instanceof StudyURN ? ((StudyURN)filter.getStudyId()).toString(SERIALIZATION_FORMAT.CDTP) : filter.getStudyId().toString() : 
			null;
		
		// Improve a bit
		//for(int i = 0; i < studies.length; i++) {
		//gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType = studies[i];
		for(gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType : studies)
		{
			// Fortify change: check for null first. Will never happen but fixed anyway.
			if(studyType == null) {
				if(logger.isDebugEnabled()){logger.debug("MixTranslator.transformStudies() --> Given a StudyType object is null.  Skip it and continue processing....");}
				continue;
			}

			Study study = null;
			
			if( filter != null && filter.getStudyId() != null )
			{
				if(filterStudyAsString != null && filterStudyAsString.equals(studyType.getStudyId()))
					study = transformStudy(site, studyType, emptyStudyModalities);
			}
			else
			{
				study = transformStudy(site, studyType, emptyStudyModalities);
			}
					
			
			//Study study = transformStudy(site, studyType);
			if(study != null)
			{
				result.add(study);
			}
		}
		return result;
	}
	
	/**
	 * Transforms a webservice proxy study object into a business study object.
	 * The StudyType, from the BIA will look something like this:
	 * 
	 * <study>
	 * <study-id>urn:bhiestudy:rp02_0108_rg01-8a6b447b-2b2c-4f9d-a1a7-432bb468a53d</study-id>
	 * <dicom-uid>1.2.840.113797.2403712794.1716422.1166538607.350.4231</dicom-uid>
	 * <description>US, OB/FOLLOW-UP</description>
	 * <procedure-date>20070516091136.000000</procedure-date>
	 * <procedure-description>US</procedure-description>
	 * <patient-id>1006184063V088473</patient-id>
	 * <site-number>0108</site-number>
	 * <site-name>William Beaumont AMC</site-name>
	 * <site-abbreviation>DOD WBAMC</site-abbreviation>
	 * <image-count>22</image-count>
	 * <series-count>1</series-count>
	 * <specialty-description>OBSTETRICS</specialty-description>
	 * <modalities><modality>US</modality></modalities>
	 * <radiology-report>
	 * </radiology-report>
	 * <component-series>...</component-series>
	 * </study>
	 * 
	 * @param site The site that the study came from
	 * @param studyType the webservice proxy study
	 * @return A Business study object
	 */
	public Study transformStudy(
		Site site, 
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType,
		List<String> emptyStudyModalities) 
	{
		if(studyType == null)
			return null;
    	// CTB 27Nov2009
		//String studyId = Base32ConversionUtility.base32Encode(studyType.getStudyId());
		String studyId = studyType.getStudyId();
		Study study = null;
		StudyURN studyIdentifier = null;

		try
		{
			studyIdentifier = URNFactory.create(studyId, StudyURN.class);
			
			// BHIE identifiers are unique in that the patient ID must be set explicitly rather than
			// as part of the stringified representation of the ID
			// set the patient ID regardless of whether the URN is a BHIE or VA
			studyIdentifier.setPatientId(studyType.getPatientId());
		}
		catch (URNFormatException x1)
		{
            logger.error("Unable to create Study instance because global artifact identifier '{}' is unidentifiable.", studyId, x1);
			return null;
		}
		if(studyIdentifier == null)
		{
			try
			{
				GlobalArtifactIdentifier identifier = GlobalArtifactIdentifierFactory.create(studyId);
				if(identifier instanceof StudyURN)
				{
					studyIdentifier = (StudyURN)identifier;
					studyIdentifier.setPatientId(studyType.getPatientId());
				}
			}
			catch (GlobalArtifactIdentifierFormatException x)
			{
                logger.error("Unable to create Study instance because global artifact identifier '{}' is unidentifiable.", studyId, x);
				return null;
			}
			catch (URNFormatException urnfX)
			{
                logger.error("Unable to create Study instance because global artifact identifier '{}' is unidentifiable.", studyId, urnfX);
				return null;
			}
            logger.info("Study Identifier '{}' created by GlobalArtifactIdentifierFactory.", studyIdentifier.toString());
		}
		else
            logger.info("Study Identifier '{}' created by URNFactory.", studyIdentifier.toString());


        logger.info("Translating study, global artifact identifier '{}' is of type '{}'.", studyIdentifier.toString(), studyIdentifier.getClass().getSimpleName());
		study = Study.create(studyIdentifier, StudyLoadLevel.FULL, StudyDeletedImageState.cannotIncludeDeletedImages);
		//if(ExchangeUtil.isSiteDOD(site))
		//	study = Study.create(ObjectOrigin.DOD, site.getSiteNumber(), studyId, studyType.getPatientId(), StudyLoadLevel.FULL);
		//else
		//	study = Study.create(ObjectOrigin.VA, site.getSiteNumber(), studyId, studyType.getPatientId(), StudyLoadLevel.FULL);
		
		study.setAlienSiteNumber(studyType.getSiteNumber());
		study.setDescription(studyType.getDescription() == null ? "" : "" + studyType.getDescription());
		if ((studyType.getDescription() != null) && (!studyType.getDescription().isEmpty()) && 
			studyType.getDescription().startsWith(StringUtil.LEFT_BRACKET))
		{  
			// 3/5/18 CPT: "[xxxx-yyyyyyyy] <desc.text>" is the expected format -- extract external content ID (alternateExamNumber) from [] 
			String[] parts = StringUtil.split(studyType.getDescription(), StringUtil.RIGHT_BRACKET);
			String alternateExamNumber = parts[0];
			alternateExamNumber = alternateExamNumber.substring(1).trim(); // <-- xxxx-yyyyyyyy
			if (alternateExamNumber.contains(StringUtil.DASH)) { 	// keep yyyyyyyy only
				String[] dashedParts = StringUtil.split(alternateExamNumber, StringUtil.DASH);
				alternateExamNumber = dashedParts[parts.length-1]; // <-- yyyyyyyy
			}
			study.setAlternateExamNumber(alternateExamNumber);
            logger.info("Study AlternateExamNumber: {}", alternateExamNumber);
			// study.setDescription(studyType.getDescription());
		}

		study.setStudyUid(studyType.getDicomUid());
		study.setImageCount(studyType.getImageCount());
		//study.setPatientIcn(studyType.getPatientId());
		//study.setPatientName(studyType.getPatientName());
		
		//The BHIE framework is not capable of providing the patient name for now
		if (studyType.getPatientName() == null)
			study.setPatientName("");
		else
			study.setPatientName(studyType.getPatientName().replaceAll("\\^", " "));
		study.setProcedureDate(convertDICOMDateToDate(studyType.getProcedureDate()));
		//study.setProcedureDate(studyType.getProcedureDate() == null ? "" : "" + convertDICOMDateToRpcFormat(studyType.getProcedureDate()));
		study.setProcedure(studyType.getProcedureDescription() == null ? "" : "" + studyType.getProcedureDescription());
		
		
		String report = "1^" + study.getDescription() +  "^" + study.getPatientName() + "\n" +
		(study.getRadiologyReport() == null ? "" : "" + study.getRadiologyReport());
		study.setRadiologyReport(report);
		
		
//		study.setSiteAbbr(studyType.getSiteAbbreviation());
		study.setSiteName(studyType.getSiteName() == null ? "" : "" + studyType.getSiteName());
		//study.setSiteNumber(studyType.getSiteNumber()); // maybe this should just always be 200 in here?
		//study.setSiteNumber("200");
		study.setSpecialty(studyType.getSpecialtyDescription() == null ? "" : "" + studyType.getSpecialtyDescription());
		//study.setStudyIen(studyType.getStudyId()); // should we put this into the IEN field? then in the WS implementation it will try to create a URN
		
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
		
		if(studyType.getModalities() != null) {		
			String[] modalities = studyType.getModalities().getModality();
			if(modalities != null) {
				for(int i = 0; i < modalities.length; i++) {
					study.addModality(modalities[i]);
				}
			}
		}
		
		Image firstImage = null;
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType []series = studyType.getComponentSeries().getSeries();
		if(series != null) {
			for(int i = 0; i < series.length; i++) {
				Series newSeries = transformSeries(site, study, series[i]);
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
		study.setFirstImage(firstImage);
		// JMW 1/11/2010 P104 - if the study is a PR study it will not actually have any images
		// (just checking to be sure there really are no images)
		// if there are no series, then there are no images so set the image count to 0 regardless of what
		// was set from the web service result.
		if((study.getModalities() != null) && (study.getSeries().size() <= 0))
		{
			for(String emptyStudyModality : emptyStudyModalities)
			{
				if(study.getModalities().contains(emptyStudyModality))
				{
					study.setImageCount(0);
					if(firstImage != null)
					{
						firstImage.setAbsFilename("-1");
						firstImage.setFullFilename("-1");
						firstImage.setBigFilename("-1");
					}
					break;
				}
			}		
		}
		return study;
	}
	
	/**
	 * <series>
	 * <series-id>urn:bhieseries:rp02_0108_35712a1f-2a43-4ddb-bf97-908fa0aca060</series-id>
	 * <dicom-uid>1.2.840.113663.1100.156557589.2.1.120070126.1095029</dicom-uid>
	 * <dicom-series-number>1</dicom-series-number>
	 * <description>US</description>
	 * <modality>US</modality>
	 * <image-count>22</image-count>
	 * <component-instances>...</component-instances>
	 * </series>
	 * 
	 * @param site
	 * @param seriesType
	 * @param studyType
	 * @return
	 */
	public Series transformSeries(
		Site site,
		Study study,
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType seriesType) 
	{
		if(seriesType == null || study == null)
		{
			logger.warn("transformSeries(SeriesType, StudyType) called with " + 
				seriesType == null ? "null series" : "" + 
				study == null ? "null study " : "");
			return null;
		}
		Series series = Series.create(
			ExchangeUtil.isSiteDOD(site) ? ObjectOrigin.DOD : ObjectOrigin.VA, 
			seriesType.getSeriesId(), 
			seriesType.getDicomUid()
		);
		series.setSeriesNumber(seriesType.getDicomSeriesNumber() == null ? "" : "" + seriesType.getDicomSeriesNumber() + "");
		series.setSeriesUid(seriesType.getDicomUid() == null ? "" : "" + seriesType.getDicomUid());
		series.setModality(seriesType.getModality());
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType [] instances = 
			seriesType.getComponentInstances().getInstance();
		if(instances != null) {
			for(int i = 0; i < instances.length; i++) {
				Image image = transformImage(site, study, series, instances[i]);
				series.addImage(image);
			}
		}
		return series;
	}

	/**
	 * 
	 * @param site
	 * @param series
	 * @param studyType
	 * @return
	 */
	public Set<Series> transformSeries(
			Site site,
			Study study,
			gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[] series) 
	{
		if(series == null)
			return null;
		Set<Series> result = new TreeSet<Series>(new SeriesComparator());
		for(int i = 0; i < series.length; i++) {
			Series newSeries = transformSeries(site, study, series[i]);
			result.add(newSeries);
		}
		return result;
	}
	
	/**
	 * Transform an exchange-specific InstanceType instance into an Image instance.
	 * 
	 * <instance>
	 * <image-urn>urn:bhieimage:rp02_0108_rp01-4dcb05ac-b23c-432a-9c20-48544e83da7d</image-urn>
	 * <dicom-uid>1.2.840.113663.1100.156557589.3.1.120070126.1095036</dicom-uid>
	 * <dicom-instance-number>1</dicom-instance-number>
	 * </instance>
	 * 
	 * @param artifactSource
	 * @param instance
	 * @param seriesType
	 * @param studyType
	 * @return
	 */
	public Image transformImage(
		ArtifactSource artifactSource,
		Study study,
		Series series,
		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType instance) 
	{
		if(instance == null || series == null || study == null)
		{
			logger.warn("Null instance, seriesType or StudyType parameter passed to transfromImage().");
			return null;
		}
		
		ImageURN imageUrn = null;
		StudyURN studyUrn = study.getStudyUrn();		
		assert(studyUrn != null);
		
		try
		{
			imageUrn = URNFactory.create(instance.getImageUrn(), ImageURN.class);
			imageUrn.setStudyId( studyUrn.getStudyId() );
			imageUrn.setPatientId(study.getPatientId());
			imageUrn.setPatientIdentifierTypeIfNecessary(study.getPatientIdentifierType());
			imageUrn.setImageModality(series.getModality() == null ? "" : "" + series.getModality());
		}
		catch (URNFormatException urnfX)
		{
            logger.error("Error making URN from image ID '{}'", instance.getImageUrn(), urnfX);
			return null;
		}
		
		//String imageId = Base32ConversionUtility.base32Encode(instance.getImageUrn());
		Image image = null;
		// site.getSiteNumber(), imageId, studyType.getStudyId(), studyType.getPatientId(), seriesType.getModality()
		image = Image.create(imageUrn);
		
		image.setImageNumber(instance.getDicomInstanceNumber() + "");
		//image.setIen(instance.getImageId());
		image.setImageUid(instance.getDicomUid() == null ? "" : "" + instance.getDicomUid());
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
		
		//image.setSiteNumber(studyType.getSiteNumber());
		//image.setSiteNumber(site.getSiteNumber());
		image.setAlienSiteNumber(study.getAlienSiteNumber());
		image.setFullLocation("A");
		image.setAbsLocation("M");
		image.setDicomImageNumberForDisplay(instance.getDicomInstanceNumber() == null ? "" : "" + instance.getDicomInstanceNumber() + "");
		image.setDicomSequenceNumberForDisplay(series.getSeriesNumber());
		image.setImgType(VistaImageType.DICOM.getImageType()); // radiology
		
		return image;
	}
	
	public Date convertDICOMDateToDate(String dicomDate)
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
	private String getDateFormat(String date) {
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
	
	
}
