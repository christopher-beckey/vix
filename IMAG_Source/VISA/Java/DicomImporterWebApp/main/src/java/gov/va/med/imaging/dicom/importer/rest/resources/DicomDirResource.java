package gov.va.med.imaging.dicom.importer.rest.resources;

import gov.va.med.imaging.dicom.dcftoolkit.common.mediainterchange.media.DicomMediaImpl;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.Patient.PatientSex;
import gov.va.med.imaging.exchange.business.dicom.DicomDIRRecord;
import gov.va.med.imaging.exchange.business.dicom.ImageDIRRecord;
import gov.va.med.imaging.exchange.business.dicom.PatientDIRRecord;
import gov.va.med.imaging.exchange.business.dicom.SeriesDIRRecord;
import gov.va.med.imaging.exchange.business.dicom.StudyDIRRecord;
import gov.va.med.imaging.exchange.business.dicom.importer.Series;
import gov.va.med.imaging.exchange.business.dicom.importer.SopInstance;
import gov.va.med.imaging.exchange.business.dicom.importer.Study;
import gov.va.med.imaging.xstream.FieldUpperCaseMapper;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

import gov.va.med.logging.Logger;

import com.sun.mail.util.BASE64DecoderStream;
import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.converters.basic.DateConverter;
import com.thoughtworks.xstream.mapper.MapperWrapper;

@Path("/dicomdir")
public class DicomDirResource {

	private static final Logger LOGGER = Logger.getLogger(DicomDirResource.class);

    @POST
    @Path("/readDicomDir")
    @Produces("application/xml")
    @Consumes("text/plain")
    public String getDicomDirAsStudyList(InputStream dicomDirString) throws IOException
	{
		// Wrap the input stream in a base64 decoder
		BASE64DecoderStream dicomDirStream = new BASE64DecoderStream(dicomDirString);
		
		// Call the method to convert to Study List
		return readMedia(dicomDirStream);
		
    }
    
    private String readMedia(InputStream inStream)
    {
		DicomMediaImpl media = new DicomMediaImpl();
		List<Study> studies = null;
		
		try 
		{
			DicomDIRRecord rootRecord = media.readDicomDIR(inStream);
			studies = convertDicomDIRRecordToStudyList(rootRecord);
		} 
		catch (Exception e) 
		{
            LOGGER.warn("DicomDirResource.readMedia() --> Error reading media: {}", e.getMessage());
		}

		//XStream xstream = new XStream();
    	
		XStream xstream = new XStream() {
            protected MapperWrapper wrapMapper(MapperWrapper next) {
                return new FieldUpperCaseMapper(next);
            }
    	};

    	xstream.alias("ArrayOfStudy", List.class);
    	xstream.alias("Patient", Patient.class);
    	xstream.alias("Study", Study.class);
    	xstream.alias("Series", Series.class);
    	xstream.alias("SopInstance", SopInstance.class);
    	
    	String[] acceptableDateFormats = new String[]
    	{
    		"MM-dd-yyyy",
    	    "yyyyMMdd"
    	};
    	                                        	
    	DateConverter dateConverter = new DateConverter("MM/dd/yyyy", acceptableDateFormats);
    	xstream.registerConverter(dateConverter);

    	return xstream.toXML(studies);
    }
    
    private List<Study> convertDicomDIRRecordToStudyList(DicomDIRRecord rootRecord)
    {
    	List<Study> studies = new ArrayList<Study>();
    	
    	// Loop over the top-level objects. 
    	for (DicomDIRRecord record : rootRecord.getRootRecords())
    	{
    		// If it's a patient, process the studies for that patient.
    		if(record instanceof PatientDIRRecord)
    		{
    			PatientDIRRecord patientRecord = (PatientDIRRecord)record;
    			for (StudyDIRRecord studyRecord : patientRecord.getStudies())
    			{
        			Patient patient = createPatientFromPatientDirectoryRecord((PatientDIRRecord)record);
    				Study study = createStudyFromStudyDIRRecord(studyRecord);
    				study.setPatient(patient);
    				studies.add(study);
    			}
    		}
    		
    		// If it's a study, create a dummy patient and associate the study, series, and images with the dummy patient
    		if(record instanceof StudyDIRRecord)
    		{
    			Patient patient = createDummyPatient();
    			Study study = createStudyFromStudyDIRRecord((StudyDIRRecord)record);
    			study.setPatient(patient);
    			studies.add(study);
    		}
    		
    		// If it's a series, create a dummy patient and study, and put the series and images under it
    		if(record instanceof SeriesDIRRecord)
    		{
    			Study study = createDummyStudy(createDummyPatient());
    			Series series = createSeriesFromSeriesDIRRecord((SeriesDIRRecord)record);
    			study.getSeries().add(series);
    			studies.add(study);
    		}
    		
    		// If it's an image by itself, create dummy patient, study, and series records, and attach the image to it.
    		if(record instanceof ImageDIRRecord)
    		{
    			Study study = createDummyStudy(createDummyPatient());
    			Series series = createDummySeries(study);
    			series.getSopInstances().add(createImageFromImageDIRRecord((ImageDIRRecord)record));
    			studies.add(study);
    		}
    	}
    	
    	return studies;
    }
    
    private Patient createPatientFromPatientDirectoryRecord(PatientDIRRecord patientRecord)
    {
    	
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd", Locale.US);
    	
    	Date dob = null;

    	try
    	{
    		dob = sdf.parse(patientRecord.getDob());
    	}
    	catch (Exception e)
    	{
    	}
    	
    	Patient patient = Patient.create(
    			patientRecord.getPatientName().trim(), 
    			null, 
    			null, PatientSex.valueOfPatientSex(patientRecord.getPatientSex()), dob, patientRecord.getPatientID().trim(), null, null);
    	return patient;
    }

    private Study createStudyFromStudyDIRRecord(StudyDIRRecord studyRecord)
    {
    	// Create and fill in study fields
    	Study study = new Study();
    	study.setAccessionNumber(studyRecord.getAccessionNumber().trim());
    	study.setUid(studyRecord.getStudyInstanceUID().trim());
    	study.setStudyDate(studyRecord.getStudyDate());
    	study.setStudyTime(studyRecord.getStudyTime());
    	study.setDescription(studyRecord.getStudyDescription());
    	study.setModalitiesInStudy(studyRecord.getModalitiesInStudy());
    	study.setReferringPhysician(studyRecord.getReferringPhysician());
    	
    	
    	for (SeriesDIRRecord record : studyRecord.getSeries())
    	{
    		study.getSeries().add(createSeriesFromSeriesDIRRecord(record));
    	}
    	return study;
    }

    private Series createSeriesFromSeriesDIRRecord(SeriesDIRRecord seriesRecord)
    {
    	Series series = new Series();
    	series.setUid(seriesRecord.getSeriesInstanceUID().trim());
    	series.setModality(seriesRecord.getModality());
    	series.setSeriesNumber(seriesRecord.getSeriesNumber());
    	series.setFacility(seriesRecord.getFacility());
    	series.setInstitutionAddress(seriesRecord.getInstitutionAddress());
    	series.setSeriesDescription(seriesRecord.getSeriesDescription());

    	for (ImageDIRRecord record : seriesRecord.getImages())
    	{
    		SopInstance instance = createImageFromImageDIRRecord(record);
    		if (instance != null)
    		{
        		series.getSopInstances().add(createImageFromImageDIRRecord(record));
    		}
    	}

    	return series;
    }

    private SopInstance createImageFromImageDIRRecord(ImageDIRRecord record)
    {

    	SopInstance instance = new SopInstance();

    	String fileId = record.getFileID() != null ? record.getFileID().trim() : "";
    	instance.setFilePath(fileId);

    	String instanceUid = record.getImageInstanceUID() != null ? record.getImageInstanceUID().trim() : "";
    	instance.setUid(instanceUid);
    	instance.setSopClassUid(record.getSopClassUid());

    	if (instance.getFilePath() != "")
    		return instance;
    	else
    		return null;
    }
    
    private Patient createDummyPatient()
    {
    	return Patient.create("Unknown", null, null, PatientSex.Unknown, null, null, null, null);
    }
    
    private Study createDummyStudy(Patient patient)
    {
    	Study study = new Study();
    	study.setDescription("Unknown Study");
    	study.setPatient(patient);
    	return study;
    }
    
    private Series createDummySeries(Study study)
    {
    	Series series = new Series();
    	study.getSeries().add(series);
    	return series;
    }
}