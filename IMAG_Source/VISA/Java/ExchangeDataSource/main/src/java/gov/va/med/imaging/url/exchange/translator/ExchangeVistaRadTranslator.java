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
package gov.va.med.imaging.url.exchange.translator;

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
import java.util.List;
import java.util.SortedSet;

import gov.va.med.logging.Logger;

/**
 * This translates VIX business Study objects into VIX Exam business objects
 * 
 * @author vhaiswwerfej
 *
 */
public class ExchangeVistaRadTranslator
{
	private final static Logger LOGGER = Logger.getLogger(ExchangeVistaRadTranslator.class);
	
	public static ExamListResult translate(StudySetResult studySetResult)
	throws URNFormatException
	{
		if(studySetResult == null)
		{
			LOGGER.warn("ExchangeVistaRadTranslator.translate(1) --> Return null. Given StudySetResult is null.");
			return null;
		}
		
		return ExamListResult.create(translate(studySetResult.getArtifacts()), studySetResult.getArtifactResultStatus(), studySetResult.getArtifactResultErrors());
	}

	private static List<Exam> translate(SortedSet<Study> studies)
	throws URNFormatException
	{
		if(studies == null)
		{
			LOGGER.warn("ExchangeVistaRadTranslator.translate(2) --> Return null. Given SortedSet<Study> is null.");
			return null;
		}
		
		List<Exam> exams = new ArrayList<Exam>(studies.size());
		String patientName = null;
		String patientIcn = null;
		
		if(studies.size() > 0)
		{
			Study study = studies.first();
			patientName = study.getPatientName();
			patientIcn = study.getPatientId();
		}
		
		String rawHeaderLine1 = studies.size() +  "^1~Radiology Exams for: " + patientName + " (" + patientIcn + ") -- ALL exams are listed.|0";
		String rawHeaderLine2 = "^Day/Case~S3~1^Lock~~2^Procedure~~6^Modifier~~25^Image Date/Time~S1~7^Status~~8^# Img~S2~9^Onl~~10^RC~~12^Site~~23^Mod~~15^Interp By~~20^Imaging Loc~~11^CPT~~27";
		
		for(Study study : studies)
		{
			Exam exam = Exam.create(study.getSiteNumber(), study.getStudyIen(), study.getPatientId());
			exam.setExamReport(study.getRadiologyReport());
			// need to set the requisition report and presentation state data to empty string to indicate they were "loaded".
			// never get these values from DoD so use empty string rather than null.
			exam.setExamRequisitionReport("");
			exam.setPresentationStateData("");
			exam.setExamStatus(ExamStatus.INTERPRETED);
			exam.setPatientName(study.getPatientName());
			exam.setSiteAbbr(study.getSiteAbbr());
			exam.setSiteName(study.getSiteName());
			exam.setModality(getStudyModality(study));				
			// no cpt code from DoD right now
			exam.setCptCode("");
			
			String examImagesHeader = study.getImageCount() > 0 ? study.getImageCount() + "^0~Images for DoD Case" : "0^2~No Images available for DoD Case";
			
			ExamImages examImages = new ExamImages(examImagesHeader, true);
			
			for(Series series : study.getSeries())
			{
				for(Image image : series)
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
			return study.getModalities().iterator().next();
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
		
		sb.append(new SimpleDateFormat("MM/dd/yyyy@HH:mm:ss").format(study.getProcedureDate()));
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
		
		return sb.toString();
	}
	
	private static String extractIllegalCharacters(String input)
	{
		if(input == null)
		{
			LOGGER.warn("ExchangeVistaRadTranslator.extractIllegalCharacters() --> Return null. Given String is null.");
			return null;		
		}
		
		// a description from the DoD had a '^' character in the description field
		// this caused the column headers to line up incorrectly in VistARad
		// replace the '^' character with a space
		return input.replace("^", " ");
	}
	
	/**
	 * Create a unique case ID for the exam based on values of the exam, the case ID created should consistently create the same ID
	 * given the same study
	 * @param study
	 * @return
	 */
	private static String createCaseId(Study study)
	{
		try
		{
			StringBuilder sb = new StringBuilder();
			
			sb.append("DOD");
			sb.append("-");
			sb.append(new SimpleDateFormat("MMddyy").format(study.getProcedureDate()));
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
            LOGGER.warn("ExchangeVistaRadTranslator.createCaseId() --> Return 'DOD-9999'. Could not create case Id for study IEN [{}] from the DoD: {}", study.getStudyIen(), ex.getMessage());
			return "DOD-9999";
		}
	}
	
	private static ExamImage translate(Image image)
	throws URNFormatException
	{
		ExamImage examImage = ExamImage.create(image.getSiteNumber(), 
				image.getIen(), 
				image.getStudyIen(), 
				image.getPatientId()
			);

		examImage.setPatientName(image.getPatientName());
		examImage.setAlienSiteNumber(image.getAlienSiteNumber());
		
		return examImage;
	}
}
