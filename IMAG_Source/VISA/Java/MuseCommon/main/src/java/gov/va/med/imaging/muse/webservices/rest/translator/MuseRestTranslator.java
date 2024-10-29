/**
 * 
 */
package gov.va.med.imaging.muse.webservices.rest.translator;

import java.io.ByteArrayInputStream;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.URN;
import gov.va.med.imaging.MuseStudyURN;
import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.MuseOpenSessionResults;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.enums.ObjectOrigin;
import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.enums.VistaImageType;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.muse.webservices.rest.type.image.response.MuseTestReportResultType;
import gov.va.med.imaging.muse.webservices.rest.type.opensession.response.MuseOpenSessionAuthTokenType;
import gov.va.med.imaging.muse.webservices.rest.type.opensession.response.MuseOpenSessionTheResultType;
import gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.response.MuseArtifactResultTestType;
import gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.response.MuseArtifactResultsType;

/**
 * @author William Peterson
 *
 */
public class MuseRestTranslator{

	
	private static Logger logger = Logger.getLogger(MuseRestTranslator.class);
	
	private static HashMap<String, String> imageTestTypeMap = new HashMap<String, String>();
	private static List<String> activeKeys = Collections.synchronizedList(new ArrayList<String>());
	private static final int MAX_CACHE_LENGTH = 10000;
	
	private static final String MUSEMODALITY = "MUSEECG";
	
	public static MuseOpenSessionResults translate(MuseOpenSessionAuthTokenType results)
			throws TranslationException{
		if(results == null){
			return null;
		}
		
		MuseOpenSessionResults openResults = new MuseOpenSessionResults();
		
		openResults.setErrorMessage(results.getErrorMessage());
		openResults.setException(results.getException());
		openResults.setStatus(results.getStatus());
		
		MuseOpenSessionTheResultType returnedData = results.getResult();
		openResults.setBinaryToken(returnedData.getBinaryToken());
		openResults.setPassword(returnedData.getPassword());
		openResults.setExpiration(returnedData.getExpiration());
		openResults.setSiteNumber(returnedData.getSiteNumber());
		openResults.setUserName(returnedData.getUserName());
		
		return openResults;
	}
	
	
	public static ArtifactResults extractArtifactResults(Site site, StudyLoadLevel studyLoadLevel, 
			PatientIdentifier patientIdentifier, StudyFilter filter, int museServerId, 
			MuseArtifactResultsType results) throws TranslationException{
		
		logger.debug("extracting Artifact Result from Muse Query result.");
		SortedSet<Study> studyList = new TreeSet<Study>();
		String filterTestId = null;
		if(filter != null){
			if(filter.getStudyId() instanceof MuseStudyURN){
				MuseStudyURN museStudyUrn = (MuseStudyURN)filter.getStudyId();
				filterTestId = String.valueOf(museStudyUrn.getStudyId());
                logger.debug("Translator Filter Test Id: {}", filterTestId);
			}
		}
		//loop thru all test objects
		for(MuseArtifactResultTestType test : results.getResults().getTests())
		{	
			Study study;
			
			//populate study object. There is 1 study per Muse Test.
			try
			{
				if(filterTestId != null){
					if(filterTestId.equals(String.valueOf(test.getTestIdInt()))){
						study = createStudy(site, studyLoadLevel, patientIdentifier, filter, museServerId, test);
						if(study != null){
                            logger.debug("study: {}", study.toString());
							logger.debug("adding study to study list.");
							studyList.add(study);
						}
					}
				}
				else{
					study = createStudy(site, studyLoadLevel, patientIdentifier, filter, museServerId, test);
					if(study != null){						
						StringBuilder sb = new StringBuilder();
						sb.append("adding study " + study.toString());
						sb.append(" to study list.");
						logger.debug(sb.toString());
						studyList.add(study);
					}					
				}
			}
			catch (URNFormatException x)
			{
                logger.error("URNFormatException creating a Study from the '{}'.", (test != null) ? test.getTestId() : "null object", x);
			}
			
		}
		
		//convert studyList into StudySetResult object
		StudySetResult studySetResult = StudySetResult.createFullResult(studyList);
		//convert StudySetResult object into ArtifactResults object
		ArtifactResults artifactResults = ArtifactResults.createStudySetResult(studySetResult);
		//return ArtifactResults object
		return artifactResults;
	}

	public static SizedInputStream translate(MuseTestReportResultType result)throws TranslationException{
		logger.debug("I GOT AN REPORT FROM MUSE!");
		
		byte[] data = result.getResult();
		ByteArrayInputStream istream = new ByteArrayInputStream(data);
		
		SizedInputStream sistream = new SizedInputStream(istream, data.length);
        logger.debug("Muse Report size: {}", data.length);
		
		return sistream;
	}
	
	/**
	 * Retrieves the testType for the provided image key if one has been cached.
	 * 
	 * @param key The composite key String uniquely identifying an image / test type relationship.
	 * 
	 * @return The String value of the associated testType if one has been stored.
	 */
	public static String findTestTypeForImageKey(String key) {
		return imageTestTypeMap.get(key);
	}
	
	/**
	 * Adds a image / test type relation to the cache and adds its composite key identifier String
	 * to the end of the active image keys list (removing previous instances of the key).
	 * 
	 * @param key The key string representing a specific image instance.
	 * @param testType The study test type related to the image, used as the map value.
	 */
	private static void addTestTypeForImageToCache(String key, String testType) {
		if (activeKeys.contains(key)) {
            logger.debug("imageURN key '{}' already mapped, moving it to the end of the list", key);
			activeKeys.remove(key);
		}
		
		activeKeys.add(key);
		imageTestTypeMap.put(key, testType);
        logger.debug("Adding test type '{}' to imageTestTypeMap with key: '{}'", testType, key);
		
		shortenTestTypeForImageCache(MAX_CACHE_LENGTH);
	}
	
	/**
	 * Removes the provided key from the cache.
	 * 
	 * @param key The key string representing the image / test type relation to be removed from the cache.
	 */
	private static void removeTestTypeForImageFromCache(String key) {
		activeKeys.remove(key);
		imageTestTypeMap.remove(key);
	}
	
	/**
	 * Ensures the imageUrnTypeMap contains no more than the provided number of keys.
	 * References the activeImageurns list to identify and remove the oldest keys first.
	 * If the cache already contains the specified number of keys or fewer, no changes will be made.
	 * 
	 * @param length The desired number of keys to leave in the cache. Negative numbers will be handled as 0.
	 */
	private static void shortenTestTypeForImageCache(int length) {
        logger.debug("ImageURN testType cache contains {} keys.", imageTestTypeMap.size());
		if (imageTestTypeMap.size() > length) {
            logger.debug("{} oldest keys will be removed from the cache.", imageTestTypeMap.size() - length);
		}
		
		String oldestImageUrnKey;
		
		while (imageTestTypeMap.size() > length && activeKeys.size() > 0) {
			oldestImageUrnKey = activeKeys.get(0);
			removeTestTypeForImageFromCache(oldestImageUrnKey);
		}
	}
	
	/**
	 * 
	 * @param site
	 * @param studyLine
	 * @return
	 * @throws URNFormatException 
	 */
	private static Study createStudy(Site site, StudyLoadLevel studyLoadLevel, 
			PatientIdentifier patientIdentifier, StudyFilter filter, int museServerId, MuseArtifactResultTestType test) 
	throws URNFormatException, TranslationException
    {
	    // we must have the IEN to create a Study
		String temp = test.getTestId();
		String[] testids = StringUtil.split(temp, ",");
		String studyIen = null;
		
		String firstImageIen = null;
		if(temp != null){
			studyIen = StringUtil.removeNonNumericChars(testids[0]);
		    firstImageIen = StringUtil.removeNonNumericChars(testids[1]);	    
		}
		else{
			studyIen = String.valueOf(test.getTestIdInt());
			firstImageIen = "1";
		}	
		
	    int imageCount = 1;
	    String studyUid = "";

        logger.debug("studyIen: '{}'", studyIen);
        logger.debug("firstImageIen: '{}'", firstImageIen);
	    
	    String patientName = test.getPatient().getLastName() + "," + test.getPatient().getFirstName();
	    
	    //WFP-determine if I should be using alienSiteNumber
	    Study study = Study.create(ObjectOrigin.VA, site.getSiteNumber(), studyIen, 
	    		patientIdentifier, String.valueOf(museServerId), studyLoadLevel, 
	    		StudyDeletedImageState.cannotIncludeDeletedImages, true);
	    study.setSiteName(site.getSiteName());
	    study.setSiteAbbr(site.getSiteAbbr());
	    //study.setMuseServerId(String.valueOf(museServerId));
	    
	    study.setAccessionNumber(temp);
	    study.setStudyUid(studyUid);

    	study.setPatientName(patientName);
 
	    if(!studyLoadLevel.isIncludeImages())
	    {
            logger.debug("Study is not loaded with images, setting image count to '{}' and first image IEN to '{}'.", imageCount, firstImageIen);
	    	study.setImageCount(imageCount);
	    	study.setFirstImageIen(firstImageIen);
	    }
	    
	    study.addModality(MUSEMODALITY);
    	
    	Date capDate = convertMuseDatetoDate(test.getAcquisitionTimestamp());
    	study.setCaptureDate(convertMuseDateToDateString(capDate));
    	study.setAlternateExamNumber(temp);
    	
    	study.setProcedureDate(capDate);
    	
    	study.setProcedure(test.getTestTypeText());
    	    
    	final String status = "CONFIRMED".equalsIgnoreCase(test.getTheTestStatus()) ? "Confirmed" : "Unconfirmed";
		study.setDescription(test.getTestTypeText() + " : " + status);
    	    	
	    String altFirstImageIen = "";
    	Series series = createSeries(site, study, patientIdentifier, filter, museServerId, test);

        logger.debug("study.globalArtifactIdentifier.documentUniqueId:{}", study.getGlobalArtifactIdentifier().getDocumentUniqueId());
	        	
	    if(studyLoadLevel.IsIncludeSeries()){
	    	if(series != null){
	    		logger.debug("Series added to study.");
	    		study.addSeries(series);
	    	}
	    }
    
	    if(firstImageIen == null || firstImageIen.length() == 0){
	    	firstImageIen = altFirstImageIen;
	    }

	    
	    return study;
    }


	/**
	 * 
	 * @param site
	 * @param parentStudy
	 * @param seriesLine
	 * @return
	 * @throws URNFormatException 
	 */
	private static Series createSeries(Site site, Study parentStudy, PatientIdentifier patientIdentifier, 
			StudyFilter filter, int museServerId, MuseArtifactResultTestType test) 
	throws URNFormatException, TranslationException
    {
		Series series = new Series();
		
		String uid = "";
    	series.setSeriesUid(uid);
    
    	String seriesIen = "0";
    	series.setSeriesIen(seriesIen);
    
    	String seriesNumber = "0";
    	series.setSeriesNumber(seriesNumber);
    
    	series.setModality(MUSEMODALITY);    
    
		Image image = createImage(site, parentStudy, patientIdentifier, filter, museServerId, test);	    	
		
		if(image != null){
			logger.debug("adding image to series.");
			series.addImage(image);
		}
	    
		return series;
    }

	
	/**
	 * 
	 * @param site
	 * @param parentStudy
	 * @param parentSeries
	 * @param seriesLine
	 * @return
	 * @throws URNFormatException 
	 */
	private static Image createImage(Site site, Study parentStudy, 
		PatientIdentifier patientIdentifier, StudyFilter filter, int museServerId, MuseArtifactResultTestType test) 
	throws URNFormatException, TranslationException
    {

		String temp = test.getTestId();
		String[] testids = null;
		String imageIen = null;
		
		if(temp != null){
			testids = StringUtil.split(temp, ",");
			imageIen = StringUtil.removeNonNumericChars(testids[1]);
		}
		else{
			imageIen = String.valueOf(test.getTestIdInt());
		}

	    String imageUid = "";
	    
	    String imageNumber = "1";
	    
	    Image image = Image.create(site.getSiteNumber(), imageIen, 
	    		parentStudy.getStudyIen(), parentStudy.getPatientIdentifier(), 
	    		String.valueOf(museServerId), MuseRestTranslator.MUSEMODALITY, false, true);
	    
	    image.setImageUid(imageUid);
	    image.setImageNumber(imageNumber);
	    
	    image.setImgType(VistaImageType.PDF.getImageType());
	    
	    if(parentStudy.getFirstImage() == null)
    	{
    		parentStudy.setFirstImage(image);
    		parentStudy.setFirstImageIen(image.getIen());
    	}
	    
	    final StringBuilder builder = new StringBuilder();
	    builder.append(site.getSiteNumber());
	    builder.append(URN.namespaceSpecificStringDelimiter);
	    builder.append(image.getStudyIen());
	    builder.append(URN.namespaceSpecificStringDelimiter);
	    builder.append(image.getPatientId());
	    final String key = builder.toString();
	    
	    addTestTypeForImageToCache(key, test.getType());
	    
		return image;
    }

	private static Date convertMuseDatetoDate(String museDate) {
		if ((museDate == null) || (museDate.length() <= 0))
			return null;
		try {
			// if the value includes the time, include that in the parse
			if (museDate.length() > 10) {
				SimpleDateFormat format = new SimpleDateFormat(
						"yyyy-MM-dd'T'HH:mm:ss", Locale.US);
				return format.parse(museDate);
			} 
			else {
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd",
						Locale.US);
				return format.parse(museDate);
			}
		} catch (ParseException pX) {
            logger.error("Error parsing date [{}] from VistA", museDate, pX);
		}
		return null;
	}
	
	private static String convertMuseDateToDateString(Date museDate){
		
		if(museDate == null){
			return null;
		}
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
        
        //to convert Date to String, use format method of SimpleDateFormat class.
        String strDate = dateFormat.format(museDate);
       
        return strDate;
	}
}
