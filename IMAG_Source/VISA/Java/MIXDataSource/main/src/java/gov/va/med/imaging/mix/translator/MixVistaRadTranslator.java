/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 12, 2010
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
package gov.va.med.imaging.mix.translator;

import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.business.vistarad.Exam;
import gov.va.med.imaging.exchange.business.vistarad.ExamImage;
import gov.va.med.imaging.exchange.business.vistarad.ExamImages;
import gov.va.med.imaging.exchange.business.vistarad.ExamListResult;
import gov.va.med.imaging.exchange.enums.vistarad.ExamStatus;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;

import gov.va.med.logging.Logger;

/**
 * This translates VIX business Study objects into VIX Exam business objects
 * 
 * @author vhaiswwerfej
 *
 */
public class MixVistaRadTranslator
{
	private final static Logger logger = Logger.getLogger(MixVistaRadTranslator.class);
	
	// 1 
	public static ExamListResult translate(StudySetResult studySetResult)
	throws URNFormatException
	{
		if(studySetResult == null)
			return null;
		
		List<Exam> exams = translate(studySetResult.getArtifacts());
		
		return ExamListResult.create(exams, studySetResult.getArtifactResultStatus(), studySetResult.getArtifactResultErrors());
	}
	
	
	// 2
	private static List<Exam> translate(SortedSet<Study> studies)
	throws URNFormatException
	{
		/*
		 * if(studies == null)
			return null;
		
		List<Exam> exams = new ArrayList<Exam>(studies.size());
		
		String patientName = "";
		String patientIcn = "";
		
		if(studies.size() > 0)
		{
			Study study = studies.first();
			patientName = study.getPatientName();
			patientIcn = study.getPatientId();
		}
		*/
		
		// Replace the above
		
		if(studies == null || studies.isEmpty()) {
			if(logger.isDebugEnabled()){logger.debug("translate(2) --> List of Study(ies) is either null or contains no data.  Return null.");}
			return null;
		}
		
		List<Exam> exams = new ArrayList<Exam>(studies.size());
		
		String rawHeaderLine1 = studies.size() +  "^1~Radiology Exams for: " + studies.first().getPatientName() + " (" + studies.first().getPatientId() + ") -- ALL exams are listed.|0";
		String rawHeaderLine2 = "^Day/Case~S3~1^Lock~~2^Procedure~~6^Modifier~~25^Image Date/Time~S1~7^Status~~8^# Img~S2~9^Onl~~10^RC~~12^Site~~23^Mod~~15^Interp By~~20^Imaging Loc~~11^CPT~~27";
		
		for(Study study : studies)
		{
			Exam exam = Exam.create(study.getSiteNumber(), study.getStudyIen(), study.getPatientId());
			exam.setExamReport(study.getRadiologyReport());
			
			if(logger.isDebugEnabled()){
                logger.debug("translate(2) --> After Exam report field is set [{}]", exam.getExamReport());}
			
			// need to set the requisiton report and presentation state data to empty string to indicate they were "loaded".
			// never get these values from DoD so use empty string rather than null.
			exam.setExamRequisitionReport("");
			exam.setPresentationStateData("");
			exam.setExamStatus(ExamStatus.INTERPRETED);
			
			exam.setPatientName(study.getPatientName());
			exam.setSiteAbbr(study.getSiteAbbr());
			exam.setSiteName(study.getSiteName());
			exam.setModality(getStudyModality(study));				
			// no cpt code from DoD right now
			//exam.setCptCode("");
			
			// QN: added CPT code
			exam.setCptCode(study.getCptCode());
			
/*			String examImagesHeader = "";
			if(study.getImageCount() > 0)
			{
				examImagesHeader = study.getImageCount() + "^0~Images for DoD Case";
			}
			else
			{
				examImagesHeader = "0^2~No Images available for DoD Case";
			}
*/			
			// QN: replaced the above
			String examImagesHeader = study.getImageCount() > 0 ? study.getImageCount() + "^0~Images for DoD Case" : "0^2~No Images available for DoD Case";
			
			ExamImages examImages = new ExamImages(examImagesHeader, true);
			
			for(Series series : study.getSeries())
			{
				for(Image image : series)  // Curious how this works.  Should get SortedSet<Image> images from Series first???
				{
					ExamImage examImage = translate(image);
					examImages.add(examImage);
				}
			}
			
			exam.setImages(examImages);
			exams.add(exam);
			exam.setRawHeaderLine1(rawHeaderLine1);
			exam.setRawHeaderLine2(rawHeaderLine2);
			exam.setRawOutput(createRawExamOutput(study));
		}
		
		return exams;
	}
	
	private static String getStudyModality(Study study)
	{
		if((study.getModalities() != null) && (study.getModalities().size() > 0))
		{	
			// QN: This is a bug.  Modality is Set of one or more.  Can't get the first one.
			// return study.getModalities().iterator().next();
			
			return study.getModalities().toString().replace("[", "").replace("]", "");
		}
		
		return "";
	}
	
	private static String createRawExamOutput(Study study)
	{		
		//^Day/Case~S3~1^Lock~~2^Procedure~~6^Modifier~~25^Image Date/Time~S1~7^Status~~8^# Img~S2~9^Onl~~10^RC~~12^Site~~23^Mod~~15^Interp By~~20^Imaging Loc~~11^CPT~~27
		//^040105-174^^CT ORBIT P FOS OR TEMP BON^^10/13/2004@13:31:27^WAITING FOR EXAM^25^Y^^^CT^^TD-RAD^70482^|1011^6949598.9048^1^191||W^^^CT^70482^0^191^0^^
		
		String modality = getStudyModality(study);
		
		StringBuilder sb = new StringBuilder();
		sb.append("^");
		// date/case
		sb.append(createCaseId(study));
		sb.append("^");
		// lock
		sb.append("^");
		// procedure
		//sb.append(study.getProcedure());
		// this field is the "procedure" field but the value we get from the description is better
		sb.append(extractIllegalCharacters(study.getDescription()));
		sb.append("^");
		// modifier
		sb.append("^");
		// image date/time
		
		//String dateTimeFormat = "MM/dd/yyyy@HH:mm:ss";
		
		SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy@HH:mm:ss");
		
		// QN: added the check to avoid NullPointerException
		sb.append(study.getProcedureDate() == null ? "" : "" + formatter.format(study.getProcedureDate()));
		
		sb.append("^");
		// status
		sb.append("INTERPRETED");
		sb.append("^");
		// # images
		sb.append(study.getImageCount());
		sb.append("^");
		// onl ?
		sb.append("^");
		// RC?
		sb.append("^");
		// site
		sb.append(study.getSiteName());
		sb.append("^");
		// modality
		sb.append(modality);
		sb.append("^");
		// interpreted by
		sb.append("^");
		// image location
		sb.append("^");
		// cpt
		
		sb.append("|");
		sb.append(study.getStudyIen());
		sb.append("|");
		sb.append("|");
		sb.append("I"); // interpreted
		sb.append("^");
		sb.append("^");
		sb.append("^");
		sb.append(modality);
		sb.append("^");
		// cpt code
		sb.append("^");
		sb.append("^");
		sb.append("^");
		sb.append("^");
		sb.append("^");
		
		//if(logger.isDebugEnabled()){logger.debug("createRawExamOutput() --> Exam Output [" + sb + "]");}
		
		return sb.toString();
	}
	
	private static String extractIllegalCharacters(String input)
	{
		if(input == null)
			return null;		
		
		// a description from the DoD had a '^' character in the description field
		// this caused the column headers to line up incorrectly in VistARad
		// replace the '^' character with a space
		CharSequence badCharacter = "^";
		CharSequence replacementCharacter = " ";
		input = input.replace(badCharacter, replacementCharacter);

		return input;
	}
	
	/**
	 * Create a unique case ID for the exam based on values of the exam, the case ID created should consistently create the same ID
	 * given the same study
	 * @param study
	 * @return
	 */
	private static String createCaseId(Study study)
	{
		if(logger.isDebugEnabled()){
            logger.debug("createCaseId() --> Given procedure date value [{}]", study.getProcedureDate());}
		
		try
		{
			//String dateTimeFormat = "MMddyy";
			SimpleDateFormat formatter = new SimpleDateFormat("MMddyy");
			
			StringBuilder sb = new StringBuilder();
			sb.append("DOD");
			sb.append("-");
			// QN added the check to avoid NullPointerException
			sb.append(study.getProcedureDate() == null ? "" : "" + formatter.format(study.getProcedureDate()));
			sb.append("-");
			sb.append("");
			int hashCodeValue = 9999;
			if(study.getStudyIen() != null)
			{
				hashCodeValue = study.getStudyIen().hashCode();
				if(hashCodeValue < 0)
					hashCodeValue *= -1;
			}
			
			sb.append(hashCodeValue);
		
			return sb.toString();
		}
		catch(Exception ex)
		{
            logger.error("Error creating case ID for study '{}' from the DoD, {}", study.getStudyIen(), ex.getMessage(), ex);
			return "DOD-9999";
		}
	}
	
	// 3
	private static ExamImage translate(Image image) throws URNFormatException
	{
		ExamImage examImage = ExamImage.create(image.getSiteNumber(), 
				image.getIen(), 
				image.getStudyIen(), 
				image.getPatientId()
			);
		examImage.setPatientName(image.getPatientName());
		examImage.setAlienSiteNumber(image.getAlienSiteNumber());
		
		// no need to set path here - not going to have a value from the DoD
		/*
		if((image.getBigFilename() != null) && (image.getBigFilename().length() > 0))
		{
			examImage.setDiagnosticFilePath(image.getBigFilename());
		}*/
		
		return examImage;
	}
	
	/**
	 * Method to filter Study(ies) object(s) out of StudySetResult object
	 * based on a given modality blacklist - pre-configured in MIXConfiguration
	 * 
	 * @param StudySetResult	object to filter
	 * @param List<String> 		modality blackList to filter by
	 * @return StudySetResult	result after filtered
	 * 
	 */
	public static StudySetResult filterByModality(StudySetResult studySetResult, List<String> modBlackList) {

		SortedSet<Study> studies = studySetResult.getArtifacts();
		
		if( (studies == null || studies.isEmpty()) || (modBlackList == null || modBlackList.isEmpty())) {
			if(logger.isDebugEnabled()){logger.debug("filterByModality() --> studies and/or modality blacklist contain(s) no data.  Return null.");}
			return null;
		}
		
		int preFilterNum = studies.size();
		
		if(logger.isDebugEnabled()){
            logger.debug("filterByModality() --> Modality blacklist to filter by  [{}]", modBlackList);}
		
		if(logger.isDebugEnabled()){
            logger.debug("filterByModality() --> Pre-filter number of Study(ies) in List [{}]", preFilterNum);}
		

		//for(Study study : studies) { //java.util.ConcurrentModificationException (based on the Iterator for looping???)
		//for(int i = 0; i < studies.size(); ++i) { // won't process the last one of two studies???
		//if(modBlackList.containsAll(study.getModalities())) { // can't use containsAll()
		// Only Iterator works.

		Iterator<Study> itr = studies.iterator();
		
		while (itr.hasNext()) {
			for(String modInStudy : itr.next().getModalities()) {
				if(modBlackList.contains(modInStudy)) {  
					itr.remove();
				}
			}
		}
		
		if(logger.isDebugEnabled()){
            logger.debug("filterByModality() --> Post-filter number of Study(ies) in List [{}]", studies.size());}
		if(logger.isDebugEnabled()){
            logger.debug("filterByModality() --> Number of Study(ies) removed [{}]", preFilterNum - studies.size());}
		
		return studySetResult;
	}

}
