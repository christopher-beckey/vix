package gov.va.med.imaging.url.exchange.translator;

import gov.va.med.*;
import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.ImageURN;
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

public class ExchangeTranslator 
{
	
	private static final Logger LOGGER = Logger.getLogger(ExchangeTranslator.class);	

	/**
	 * Transforms an array of webservice proxy studies into a sorted set of business study objects
	 * @param studies array of webservice proxy studies
	 * @return sorted set of business study objects
	 */
	public SortedSet<Study> transformStudies(
		Site site, 
		gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType[] studies,
		StudyFilter filter,
		List<String> emptyStudyModalities) 
	{
		if(studies == null)
			return null;
		
		SortedSet<Study> result = new TreeSet<Study>();
		String filterStudyAsString = filter != null && filter.getStudyId() != null ?
			filter.getStudyId() instanceof StudyURN ? ((StudyURN)filter.getStudyId()).toString(SERIALIZATION_FORMAT.CDTP) : filter.getStudyId().toString() : 
			null;
			
		for(int i = 0; i < studies.length; i++) 
		{
			gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType studyType = studies[i];
			Study study = null;
			if( filter != null && filter.getStudyId() != null )
			{
				// Fortify change: check for null first; second round reworked check for null first
				// OLD: if(filterStudyAsString.equals(studyType.getStudyId()))
				if(filterStudyAsString != null && studyType != null)
				{
					study = filterStudyAsString.equals(studyType.getStudyId()) ? transformStudy(site, studyType, emptyStudyModalities) : null;
				}
			}
			else
			{// QN: the same call.  Why checking for filter as id and studyType Id above?
				study = transformStudy(site, studyType, emptyStudyModalities);
			}
			
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
	@SuppressWarnings("unused")
	public Study transformStudy(
		Site site, 
		gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType studyType,
		List<String> emptyStudyModalities) 
	{
		if(studyType == null)
		{
			LOGGER.debug("ExchangeTranslator.transformStudy() --> Given study type is null.  Return null.");
			return null;
		}
		
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
		catch (URNFormatException x)
		{
            LOGGER.warn("ExchangeTranslator.transformStudy() --> Return null. URNFactory: Could not create with identifier [{}]: {}", studyId, x.getMessage());
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
			catch (Exception x)
			{
                LOGGER.warn("ExchangeTranslator.transformStudy() --> Return null. GlobalArtifactIdentifierFactory: Could not create with identifier [{}]: {}", studyId, x.getMessage());
				return null;
			}

            LOGGER.info("ExchangeTranslator.transformStudy() --> Study Identifier [{}] created by GlobalArtifactIdentifierFactory.", studyIdentifier.toString());
		}
		else
            LOGGER.info("ExchangeTranslator.transformStudy() --> Study Identifier [{}] created by URNFactory.", studyIdentifier.toString());


        LOGGER.info("ExchangeTranslator.transformStudy() --> Translating study, global artifact identifier [{}] is of type [{}]", studyIdentifier.toString(), studyIdentifier.getClass().getSimpleName());
		
		study = Study.create(studyIdentifier, StudyLoadLevel.FULL, StudyDeletedImageState.cannotIncludeDeletedImages);		
		study.setAlienSiteNumber(studyType.getSiteNumber());
		study.setDescription(studyType.getDescription() == null ? "" : studyType.getDescription());
		study.setStudyUid(studyType.getDicomUid());
		study.setImageCount(studyType.getImageCount());
		//The BHIE framework is not capable of providing the patient name for now
		study.setPatientName(studyType.getPatientName() == null ? "" : studyType.getPatientName().replaceAll("\\^", " "));		
		study.setProcedureDate(convertDICOMDateToDate(studyType.getProcedureDate()));
		study.setProcedure(studyType.getProcedureDescription() == null ? "" : studyType.getProcedureDescription());
		
		String report = "1^" + study.getDescription() +  "^" + study.getPatientName() + "\n" +
		(studyType.getRadiologyReport() == null ? "" : studyType.getRadiologyReport());

		study.setRadiologyReport(report);
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
		
		if(studyType.getModalities() != null) {		
			String[] modalities = studyType.getModalities().getModality();
			if(modalities != null) {
				for(int i = 0; i < modalities.length; i++) {
					study.addModality(modalities[i]);
				}
			}
		}
		
		Image firstImage = null;
		
		gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType []series = studyType.getComponentSeries().getSeries();
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
		gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType seriesType) 
	{
		if(seriesType == null || study == null)
		{
			LOGGER.warn("ExchangeTranslator.transformSeries() --> Return null.  Called with " + 
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
		
		gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType [] instances = 
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
			gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType[] series) 
	{
		if(series == null)
		{
			LOGGER.warn("ExchangeTranslator.transformSeries() --> Return null. Can't transform null 'series'.");
			return null;
		}
		
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
		gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType instance) 
	{
		if(instance == null || series == null || study == null)
		{
			LOGGER.warn("ExchangeTranslator.transformImage() --> Return null.  Can't transform null 'instance', 'series' or 'study' parameter.");
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
			imageUrn.setImageModality(series.getModality() == null ? "" : series.getModality());
		}
		catch (URNFormatException urnfX)
		{
            LOGGER.warn("ExchangeTranslator.transformImage() --> Return null. URNFactory: Could not create with identifier [{}]: {}", instance.getImageUrn(), urnfX.getMessage());
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
	
	public Date convertDICOMDateToDate(String dicomDate)
	{
		if((dicomDate == null) || (dicomDate.equals(""))) 
		{
			LOGGER.warn("ExchangeTranslator.convertDICOMDateToDate() --> Return null. Given 'dicomDate' is null or empty.");
			return null; // Date();
		}
		
		if(dicomDate.length() < 8) {  // This is a weird check: 4 and 6 are still good in getDateFormat() method 
			LOGGER.warn("ExchangeTranslator.convertDICOMDateToDate() --> Return null. Given 'dicomDate' length is less than 8.");
			return null;
		}
		
		//TODO: update this function to handle if only part of the date is given (no month, etc)
		//TODO: month and day are now required, do a check for length and parse on that
		//TODO: if the date is invalid, should this throw an exception or always get full list of studies?
		//String dicomDate = "20061018143643.655321+0200";
		//SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss", Locale.US);
		
		try 
		{
			return new SimpleDateFormat(getDateFormat(dicomDate), Locale.US).parse(dicomDate);
		}
		catch(ParseException pX) {
            LOGGER.error("ExchangeTranslator.convertDICOMDateToDate() --> Return null. Encountered ParseException for given date [{}]: {}", dicomDate, pX.getMessage());
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
