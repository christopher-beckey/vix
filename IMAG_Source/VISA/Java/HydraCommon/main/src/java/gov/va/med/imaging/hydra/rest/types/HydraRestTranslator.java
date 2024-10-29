/**
 * 
  Property of ISI Group, LLC
  Date Created: May 9, 2014
  Developer:  Julian Werfel
 */
package gov.va.med.imaging.hydra.rest.types;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudySetResult;

/**
 * @author Julian Werfel
 *
 */
public class HydraRestTranslator
{
	public static HydraPatientsType translatePatients(List<Patient> patients)
	{
		if(patients == null)
			return null;
		
		HydraPatientType [] result = new HydraPatientType[patients.size()];
		for(int i = 0; i < patients.size(); i++)
		{
			result[i] = translate(patients.get(i));
		}
		
		return new HydraPatientsType(result);
	}
	
	private static HydraPatientType translate(Patient patient)
	{
		return new HydraPatientType(patient.getPatientName(), patient.getPatientIcn(), patient.getVeteranStatus(),
				patient.getPatientSex().name(), patient.getDob(), patient.getSsn(), patient.getDfn(), 
				patient.getSensitive() == null ? false : patient.getSensitive().booleanValue());
	}
	
	public static HydraStudyType translate(ArtifactResults artifactResults)
	throws MethodException
	{
		if(artifactResults == null)
			return null;
		
		StudySetResult studySetResult = artifactResults.getStudySetResult();
		if(studySetResult == null)
			return null;
		
		if(studySetResult.getArtifactSize() == 0)
			return null;
		
		if(studySetResult.getArtifactSize() > 1)
			throw new MethodException("Returned more than one study - error");
		
		Study study = studySetResult.getArtifacts().first();
		
		return translate(study, true);	
	}
	
	public static HydraStudiesType translateStudies(ArtifactResults artifactResults)
	{
		if(artifactResults == null)
			return null;
		
		StudySetResult studySetResult = artifactResults.getStudySetResult();
		if(studySetResult == null)
			return null;
		
		HydraStudyType [] result = new HydraStudyType[studySetResult.getArtifactSize()];
		
		int i = 0;
		for(Study study : studySetResult.getArtifacts())
		{
			result[i] = translate(study, false);
			i++;			
		}
		
		return new HydraStudiesType(result);
	}
	
	public static HydraStudiesType translateStudyList(List<Study> studies)
	{
		if(studies == null)
			return null;
		HydraStudyType [] result = new HydraStudyType[studies.size()];
		
		int i = 0;
		for(Study study : studies)
		{
			result[i] = translate(study, false);
			i++;			
		}
		
		return new HydraStudiesType(result);
	}
	
	public static HydraStudyType translate(Study study, boolean includeSeries)
	{
		String studyId = study.getStudyUrn().toString(SERIALIZATION_FORMAT.RAW);
		String dicomUid = study.getStudyUid();
		String description = study.getDescription();
		Date procedureDate = study.getProcedureDate();
		String procedureDescription = study.getProcedure();
		String patientIcn = study.getPatientId();
		String patientName = study.getPatientName();
		int imageCount = study.getImageCount();
		String specialtyDescription = study.getSpecialty();
		String imageType = study.getImageType();
		String event = study.getEvent();
		String origin = study.getOrigin();
		String studyClass = study.getStudyClass();
		String cptCode = study.getCptCode();
		
		
		List<HydraSeriesType> serieses = null;
		if(includeSeries)
		{
			serieses = new ArrayList<HydraSeriesType>();
			for(Series series : study)
			{
				serieses.add(translate(series));
			}
		}

		// Stupid change for fortify; hopefully that being empty is okay
		HydraSeriesesType hydraSeriesesType = null;
		if (serieses != null) {
			hydraSeriesesType = new HydraSeriesesType(serieses.toArray(new HydraSeriesType[serieses.size()]));
		} else {
			hydraSeriesesType = new HydraSeriesesType(new HydraSeriesType[0]);
		}
		
		return new HydraStudyType(studyId, dicomUid, description, procedureDate, procedureDescription, patientIcn, patientName, imageCount, 
				specialtyDescription, imageType, event, origin, studyClass, cptCode,
				hydraSeriesesType);
								
	}
	
	private static HydraSeriesType translate(Series series)
	{
		String seriesUid = series.getSeriesUid();
		String seriesNumber = series.getSeriesNumber();
		String modality = series.getModality();
		
		List<HydraImageType> images = new ArrayList<HydraImageType>();
		for(Image image : series)
		{
			images.add(translate(image));
		}
		
		return new HydraSeriesType(seriesUid, seriesNumber, modality, 
				series.getImageCount(),
				new HydraImagesType(images.toArray(new HydraImageType[images.size()])));
	}
	
	private static HydraImageType translate(Image image)
	{
		//String imageUri = createImageUri(image);
		return new HydraImageType(image.getImageUrn().toString(SERIALIZATION_FORMAT.RAW), image.getDescription(), image.getProcedureDate(),
				image.getProcedure(), image.getImageClass(), image.getImageUid(), image.getImageNumber());
	}
	
	/*
	private static String createImageUri(Image image)
	{
		StringBuilder uri = new StringBuilder();
		uri.append("image?imageUrn=" + image.getImageUrn().toString(SERIALIZATION_FORMAT.RAW));
		return uri.toString();
	}*/

}
