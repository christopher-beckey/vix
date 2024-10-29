/**
 * 
 */
package gov.va.med.imaging.musedatasource.translator;

import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudySetResult;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.SortedSet;

import gov.va.med.logging.Logger;

/**
 * @author William Peterson
 *
 */
public class MuseDatasourceTranslator{
	
	private final static Logger logger = Logger.getLogger(MuseDatasourceTranslator.class);


	public static ArtifactResults mergeMuseResults(ArtifactResults collectedResults, 
			ArtifactResults museResult)
	{

		if(museResult == null || !museResult.containsStudySetResult()){
			return collectedResults;
		}

		if(collectedResults == null || !collectedResults.containsStudySetResult()){
			return ArtifactResults.createStudySetResult(museResult.getStudySetResult());
		}

		StudySetResult museStudySetResult = museResult.getStudySetResult();
		StudySetResult collectedStudySetResult = collectedResults.getStudySetResult();

		SortedSet<Study> collectedStudies = collectedStudySetResult.getArtifacts();
		SortedSet<Study> museStudies = museStudySetResult.getArtifacts();
		
		if(collectedStudies != null)
		{
			for(Study study : museStudies)
			{
				collectedStudies.add(study);
			}
		}
		StudySetResult updateStudySetResult = StudySetResult.createFullResult(collectedStudies);
		return ArtifactResults.createStudySetResult(updateStudySetResult);
	}
	
	
	public Date convertMuseDateToDate(String dicomDate)
	{
		if((dicomDate == null) || (dicomDate.equals(""))) {
			return null;// Date();
		}
		if(dicomDate.length() < 8) {
			return null;
		}
				
		String format = getDateFormat(dicomDate);
		if("".equals(format))
			return null;
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
