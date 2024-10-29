/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 4, 2009
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
package gov.va.med.imaging.federation.webservices.translator;

import gov.va.med.GlobalArtifactIdentifierFactory;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.imaging.DicomDateFormat;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.ImageAccessLogEvent.ImageAccessLogEventType;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.Patient.PatientSex;
import gov.va.med.imaging.exchange.enums.ObjectOrigin;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesTypeComponentInstances;
import gov.va.med.imaging.federation.webservices.types.v2.FederationStudyTypeComponentSeries;
import gov.va.med.imaging.federation.webservices.types.v2.FederationStudyTypeStudyModalities;

import java.math.BigInteger;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Set;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationWebAppTranslator_v2 
extends AbstractFederationWebAppTranslator 
{
	public gov.va.med.imaging.federation.webservices.types.v2.PatientType [] transformPatients(List<Patient> patients)
	{
		if(patients == null)
			return null;
		gov.va.med.imaging.federation.webservices.types.v2.PatientType [] result = 
			new gov.va.med.imaging.federation.webservices.types.v2.PatientType[patients.size()];
		for(int i = 0; i < patients.size(); i++)
		{
			try
			{
				result[i] = transformPatient(patients.get(i));				
			}
			catch(ParseException pX)
			{
				getLogger().error("Error parsing patient", pX);
			}
		}
		return result;
	}
	
	private gov.va.med.imaging.federation.webservices.types.v2.PatientType transformPatient(Patient patient)
	throws ParseException
	{
		if(patient == null)
			return null;
		gov.va.med.imaging.federation.webservices.types.v2.PatientType result = 
			new gov.va.med.imaging.federation.webservices.types.v2.PatientType();
		result.setPatientDob(convertPatientDobToString(patient.getDob()));
		result.setPatientIcn(patient.getPatientIcn());
		result.setPatientName(patient.getPatientName());
		result.setPatientSex(transformPatientSex(patient.getPatientSex()));
		result.setVeteranStatus(patient.getVeteranStatus());
		return result;
	}
	
	public ImageAccessLogEvent transformLogEvent(
			gov.va.med.imaging.federation.webservices.types.v2.FederationImageAccessLogEventType logEventType) 
	throws URNFormatException 
	{
		if(logEventType == null)
			return null;
		
		ImageAccessLogEventType imageAccessLogEventType = transformLogEventType(logEventType.getEventType());
		ImageAccessLogEvent result = 
			new ImageAccessLogEvent(logEventType.getImageId(), "", logEventType.getPatientIcn(), 
					logEventType.getSiteNumber(), System.currentTimeMillis(), 
					logEventType.getReason(), "",
					imageAccessLogEventType, logEventType.getUserSiteNumber());
		
		return result;
	}
	
	private ImageAccessLogEventType transformLogEventType(gov.va.med.imaging.federation.webservices.types.v2.FederationImageAccessLogEventTypeEventType eventType) 
	{
		ImageAccessLogEventType result;// = new gov.va.med.imaging.exchange.enums.ImageAccessLogEventType();
		if(eventType == gov.va.med.imaging.federation.webservices.types.v2.FederationImageAccessLogEventTypeEventType.IMAGE_COPY) 
		{
			result = ImageAccessLogEventType.IMAGE_COPY;
		}
		else if(eventType == gov.va.med.imaging.federation.webservices.types.v2.FederationImageAccessLogEventTypeEventType.IMAGE_PRINT) 
		{
			result = ImageAccessLogEventType.IMAGE_PRINT;
		}
		else if(eventType == gov.va.med.imaging.federation.webservices.types.v2.FederationImageAccessLogEventTypeEventType.PATIENT_ID_MISMATCH) 
		{
			result = ImageAccessLogEventType.PATIENT_ID_MISMATCH;
		}
		else if(eventType == gov.va.med.imaging.federation.webservices.types.v2.FederationImageAccessLogEventTypeEventType.RESTRICTED_ACCESS) 
		{	
			result = ImageAccessLogEventType.RESTRICTED_ACCESS;
		}
		else
		{
			result = ImageAccessLogEventType.IMAGE_ACCESS;
		}
		return result;
	}	
	
	private String convertPatientDobToString(Date dob)
    throws ParseException
    {
    	SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yy", Locale.US);
    	return sdf.format(dob);
    }
	
	private gov.va.med.imaging.federation.webservices.types.v2.FederationPatientSexType transformPatientSex(PatientSex patientSex)
	{
		gov.va.med.imaging.federation.webservices.types.v2.FederationPatientSexType result = null;
		if(patientSex == PatientSex.Male)
			result = gov.va.med.imaging.federation.webservices.types.v2.FederationPatientSexType.MALE;
		else if(patientSex == PatientSex.Female)
			result = gov.va.med.imaging.federation.webservices.types.v2.FederationPatientSexType.FEMALE;
		else
			result = gov.va.med.imaging.federation.webservices.types.v2.FederationPatientSexType.UNKNOWN;
		return result;
	}
	
	public StudyLoadLevel transformStudyLoadLevel(
		gov.va.med.imaging.federation.webservices.types.v2.FederationStudyLoadLevelType studyLoadLevelType)
	{
		if(studyLoadLevelType == gov.va.med.imaging.federation.webservices.types.v2.FederationStudyLoadLevelType.STUDY_ONLY)
		{
			return StudyLoadLevel.STUDY_ONLY;
		}
		else if(studyLoadLevelType == gov.va.med.imaging.federation.webservices.types.v2.FederationStudyLoadLevelType.STUDY_AND_REPORT)
		{
			return StudyLoadLevel.STUDY_AND_REPORT;
		}
		return StudyLoadLevel.FULL;
	}
	
	/**
	 * Transform a clinical display webservice FilterType to an internal Filter instance.
	 * @throws GlobalArtifactIdentifierFormatException 
	 * 
	 */
	public StudyFilter transformFilter(
		gov.va.med.imaging.federation.webservices.types.v2.FederationFilterType filterType,
		int authorizedSensitiveLevel) 
	throws GlobalArtifactIdentifierFormatException 
	{
		StudyFilter filter = new StudyFilter();
		filter.setMaximumAllowedLevel(PatientSensitivityLevel.getPatientSensitivityLevel(authorizedSensitiveLevel));
		if(filterType != null) 
		{
			DateFormat df = getFederationWebserviceShortDateFormat();
			
			Date fromDate = null;
			try
			{
				fromDate = filterType.getFromDate() == null  || filterType.getFromDate().length() == 0 ? null : df.parse(filterType.getFromDate());
			} 
			catch (ParseException x)
			{
                getLogger().error("ParseException converting webservice format string from-date '{}' to internal Date", filterType.getFromDate(), x);
				fromDate = null;
			}
			
			Date toDate = null;
			try
			{
				toDate = filterType.getToDate() == null || filterType.getToDate().length() == 0 ? null : df.parse(filterType.getToDate());
			} 
			catch (ParseException x)
			{
                getLogger().error("ParseException converting webservice format string to-date '{}' to internal Date", filterType.getToDate(), x);
				fromDate = null;
			}
			
			// some business rules for the filter dates
			if (fromDate != null && toDate == null)
			{
				// default toDate to today
				toDate = new Date();
			}
			else if (fromDate == null && toDate != null)
			{
				// default to unfiltered
				toDate = null;
			}
			
			filter.setFromDate(fromDate);
			filter.setToDate(toDate);
			
			filter.setStudy_class(filterType.get_class() == null ? "" : filterType.get_class());
			filter.setStudy_event(filterType.getEvent() == null ? "" : filterType.getEvent());
			filter.setStudy_package(filterType.get_package() == null ? "" : filterType.get_package());
			filter.setStudy_specialty(filterType.getSpecialty() == null ? "" : filterType.getSpecialty());
			filter.setStudy_type(filterType.getTypes() == null ? "" : filterType.getTypes());
			filter.setStudyId(filterType.getStudyId() == null ? null : GlobalArtifactIdentifierFactory.create(filterType.getStudyId()));
			if(filterType.getOrigin() == null) {
				filter.setOrigin("");
			}
			else {
				if("UNSPECIFIED".equals(filterType.getOrigin().getValue())) {
					filter.setOrigin("");
				}
				else {
					filter.setOrigin(filterType.getOrigin().getValue());
				}
			}
			// don't have a study id used here
		}
		return filter;
	}
	
	/**
	 * This method converts a list of studies that match a progress note/radiology consult into a single study containing all of the images
	 * @param studies
	 * @return
	 */
	public gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType transformStudiesToStudy(List<Study> studies)
	throws ParseException
	{
		gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType result = 
			new gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType();
		
		if(studies == null)
			return result;
		Study study = studies.get(0);
		int totalImageCount = 0;
		int totalSeriesCount = 0;
		totalImageCount = study.getImageCount();
		totalSeriesCount = study.getSeriesCount();
		result = transformStudy(study);
		List<gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType> series = null;
		for(int i = 1; i < studies.size(); i++)
		{
			if(series == null)
			{
				series = new ArrayList<gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType>();
				if(result.getComponentSeries() != null)
				{
					for(gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType ser : result.getComponentSeries().getSeries())
					{
						series.add(ser);						
					}
				}				
			}
			
			Study currentStudy = studies.get(i);
			totalImageCount += currentStudy.getImageCount();
			totalSeriesCount += currentStudy.getSeriesCount();
			gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType studyType = transformStudy(currentStudy);
			if(studyType.getComponentSeries() != null)
			{
				for(gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType ser : studyType.getComponentSeries().getSeries())
				{
					series.add(ser);						
				}
			}
			
		}
		if(series != null)
		{
			result.setComponentSeries(new FederationStudyTypeComponentSeries(series.toArray(new gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType[series.size()])));
		}
		result.setSeriesCount(totalSeriesCount);
		result.setImageCount(totalImageCount);
		
		return result;		
	}
	
	public gov.va.med.imaging.federation.webservices.types.v2.StudiesType transformStudiesToResponse(List<Study> studies)
	throws ParseException
	{
		gov.va.med.imaging.federation.webservices.types.v2.StudiesType result = 
			new gov.va.med.imaging.federation.webservices.types.v2.StudiesType();		
		result.setStudy(transformStudies(studies));		
		return result;		
	}
	
	public gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType[] transformStudies(List<Study> studies)
	throws ParseException
	{
		if(studies == null || studies.size() == 0)
			return null;
		gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType[] result = 
			new gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType[studies.size()];
		
		
		for(int i = 0; i < studies.size(); i++)
		{
			result[i] = transformStudy(studies.get(i));
		}		
		return result;
	}
	
	public gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType transformStudy(Study study)
	throws ParseException
	{
		if(study == null)
			return null;
		gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType result = 
			new gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType();
		
		result.setDescription(study.getDescription());
		
		result.setEvent(study.getEvent());
		result.setImageCount(study.getImageCount());
		result.setImagePackage(study.getImagePackage());
		result.setImageType(study.getImageType());
		result.setNoteTitle(study.getNoteTitle());
		result.setOrigin(study.getOrigin());
		result.setPatientIcn(study.getPatientId());
		result.setPatientName(study.getPatientName());
		result.setProcedureDescription(study.getProcedure());
		result.setRadiologyReport(study.getRadiologyReport());
		result.setSiteNumber(study.getSiteNumber());
		result.setSiteName(study.getSiteName());
		result.setSiteAbbreviation(study.getSiteAbbr());
		result.setSpecialtyDescription(study.getSpecialty());
		result.setProcedureDate(translateProcedureDateToDicom(study.getProcedureDate()));
		
		result.setStudyPackage(study.getImagePackage());
		result.setStudyClass(study.getStudyClass() == null ? "" : study.getStudyClass());
		result.setStudyType(study.getImageType());
		result.setCaptureDate(study.getCaptureDate());
		result.setCapturedBy(study.getCaptureBy());	
		result.setRpcResponseMsg(study.getRpcResponseMsg());
		result.setErrorMessage(study.getErrorMessage() == null ? "" : study.getErrorMessage());
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (study.getStudyUid() != null && study.getStudyUid().trim().length() > 0)
		{
			result.setDicomUid(study.getStudyUid());
		}
		else
		{
			result.setDicomUid(null);
		}
		
		result.setStudyId(study.getStudyIen());
		
		gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType [] series = transformSerieses(study);
		result.setComponentSeries(new FederationStudyTypeComponentSeries(series));
		if(series != null)
		{
			result.setSeriesCount(series.length);
		}
		else
		{
			result.setSeriesCount(0);
		}
		
		gov.va.med.imaging.federation.webservices.types.v2.FederationInstanceType firstImage = 
			transformImage(study.getFirstImage());
		result.setFirstImage(firstImage);
		result.setFirstImageIen(firstImage.getImageId());
		result.setObjectOrigin(transformObjectOrigin(study.getObjectOrigin()));
		result.setStudyModalities(new FederationStudyTypeStudyModalities(study.getModalities().toArray(new String[study.getModalities().size()])));
		
		
		return result;
	}
	
	private gov.va.med.imaging.federation.webservices.types.v2.ObjectOriginType transformObjectOrigin(ObjectOrigin origin)
	{
		if(origin == ObjectOrigin.VA)
		{
			return gov.va.med.imaging.federation.webservices.types.v2.ObjectOriginType.VA;
		}
		else if(origin == ObjectOrigin.DOD)
		{
			return gov.va.med.imaging.federation.webservices.types.v2.ObjectOriginType.DOD;
		}
		else
			return gov.va.med.imaging.federation.webservices.types.v2.ObjectOriginType.OTHER;		
	}
	
	private String translateProcedureDateToDicom(Date procedureDate) 
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
	
	private gov.va.med.imaging.federation.webservices.types.v2.FederationInstanceType transformImage(Image image) 
	throws ParseException
	{
		if(image == null)
			return null;
		
		gov.va.med.imaging.federation.webservices.types.v2.FederationInstanceType instanceType = 
			new gov.va.med.imaging.federation.webservices.types.v2.FederationInstanceType();
		
		instanceType.setImageId(image.getIen());
		
		// Exchange fields
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (image.getImageUid()!= null && image.getImageUid().trim().length() > 0)
		{
			instanceType.setDicomUid(image.getImageUid().trim());
		}
		
		
		if (image.getImageNumber() != null && image.getImageNumber().trim().length() > 0)
		{
			try
			{
				Integer imageNumber = new Integer(image.getImageNumber());
				instanceType.setImageNumber(imageNumber);
			}
			catch (NumberFormatException ex)
			{
				// not a number - return null
				instanceType.setImageNumber(null);
			}
		}
		else
		{
			instanceType.setImageNumber(null);
		}
		
		// Clinical Display fields
		instanceType.setDescription(image.getDescription());
		instanceType.setDicomImageNumberForDisplay(image.getDicomImageNumberForDisplay());
		instanceType.setDicomSequenceNumberForDisplay(image.getDicomSequenceNumberForDisplay());
		instanceType.setPatientIcn(image.getPatientId());
		instanceType.setPatientName(image.getPatientName());
		instanceType.setProcedure(image.getProcedure());
		if(image.getProcedureDate() == null)
		{
			getLogger().warn("Setting null procedure date for image");
			instanceType.setProcedureDate("");
		}
		else 
		{
			/*
			// if the hour and minute are not 0, then likely they contain real values for hour and minute (not 00:00)
			// this leaves open the possibility of invalid data, if the real date was at 00:00 then this would not show that time.
			// we would then omit data, not show invalid data
			if((image.getProcedureDate().getHours() > 0) && (image.getProcedureDate().getMinutes() > 0))
			{
				instanceType.setProcedureDate(getFederationWebserviceLongDateFormat().format(image.getProcedureDate()));
			}
			else
			{
				instanceType.setProcedureDate(getFederationWebserviceShortDateFormat().format(image.getProcedureDate()));
			}
			*/
			instanceType.setProcedureDate(translateProcedureDateToDicom(image.getProcedureDate()));
		}
		instanceType.setSiteNumber(image.getSiteNumber());
		instanceType.setSiteAbbr(image.getSiteAbbr());
		instanceType.setImageClass(image.getImageClass());
		instanceType.setAbsLocation(image.getAbsLocation());
		instanceType.setFullLocation(image.getFullLocation());
		
		instanceType.setQaMessage(image.getQaMessage());
		instanceType.setImageType(BigInteger.valueOf(image.getImgType()));
		instanceType.setFullImageFilename(image.getFullFilename());
		instanceType.setAbsImageFilename(image.getAbsFilename());
		instanceType.setBigImageFilename(image.getBigFilename());

		instanceType.setStudyId(image.getStudyIen());
		instanceType.setGroupId(null);
		//instanceType.setStudyId(image.getStudyIen());		
		//instanceType.setGroupId(image.getGroupIen());
		
		instanceType.setImageModality(image.getImageModality());
		instanceType.setObjectOrigin(transformObjectOrigin(image.getObjectOrigin()));
		instanceType.setErrorMessage(image.getErrorMessage() == null ? "" : image.getErrorMessage());
		return instanceType;
	}
	
	private gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType[] transformSerieses(Study study) 
	throws ParseException
	{
		Set<Series> seriesSet = study.getSeries();
		if(seriesSet == null)// || seriesSet.size() == 0)
			return null;
		ArrayList<gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType> serieses = 
			new ArrayList<gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType>();
		
		for(Series series : seriesSet)
		{
			// Filter series with no images from the result set - DKB
			if(series.getImageCount() > 0)
			{
				serieses.add(transformSeries(series, study.getDescription()));
			}
		}
		
		return serieses.toArray(new gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType[serieses.size()]);
	}
	private gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType transformSeries(
			Series series, String seriesDescription) 
	throws ParseException
	{
		if(series == null)
			return null;
		
		gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType result = 
			new gov.va.med.imaging.federation.webservices.types.v2.FederationSeriesType();
		gov.va.med.imaging.federation.webservices.types.v2.FederationInstanceType[] instances = 
			new gov.va.med.imaging.federation.webservices.types.v2.FederationInstanceType[series.getImageCount()];

		int index=0;
		for(Image image : series)
		{
			instances[index] = transformImage(image);
			index++;
		}
	

		//TODO: retrieve series through VistA if possible (available in DICOM txt files)
		result.setDescription(seriesDescription);

		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (series.getSeriesUid() != null && series.getSeriesUid().trim().length() > 0)
		{
			result.setDicomUid(series.getSeriesUid());
		}
		
		if(!"".equals(series.getSeriesNumber())) {
			int serNum = Integer.parseInt(series.getSeriesNumber());
			result.setDicomSeriesNumber(serNum);
		}
		result.setSeriesId(series.getSeriesIen());
		result.setImageCount(instances.length);
		result.setComponentInstances(new FederationSeriesTypeComponentInstances(instances));
		result.setSeriesModality(series.getModality());
		result.setObjectOrigin(transformObjectOrigin(series.getObjectOrigin()));
		
		return result;
	}
	
	public gov.va.med.imaging.federation.webservices.types.v2.StudiesType transformExceptionToShallowStudiesType(InsufficientPatientSensitivityException ipsX)
	{
		gov.va.med.imaging.federation.webservices.types.v2.StudiesType result = 
			new gov.va.med.imaging.federation.webservices.types.v2.StudiesType();
		
		gov.va.med.imaging.federation.webservices.types.v2.FederationStudiesErrorMessageType errorType = 
			new gov.va.med.imaging.federation.webservices.types.v2.FederationStudiesErrorMessageType();
		errorType.setErrorCode(BigInteger.valueOf(ipsX.getSensitiveValue().getSensitiveLevel().getCode()));
		errorType.setErrorMessage(ipsX.getSensitiveValue().getWarningMessage());
		errorType.setStudiesError(gov.va.med.imaging.federation.webservices.types.v2.FederationStudiesErrorType.INSUFFICIENT_SENSITIVE_LEVEL);
		result.setError(errorType);
		return result;
	}
	
	public gov.va.med.imaging.federation.webservices.types.v2.PatientSensitiveCheckResponseType transformPatientSensitiveValue(PatientSensitiveValue sensitiveValue)
	{
		gov.va.med.imaging.federation.webservices.types.v2.PatientSensitiveCheckResponseType result = 
			new gov.va.med.imaging.federation.webservices.types.v2.PatientSensitiveCheckResponseType();
		result.setWarningMessage(sensitiveValue.getWarningMessage());
		result.setPatientSensitivityLevel(transformPatientSensitiveLevel(sensitiveValue.getSensitiveLevel()));
		
		return result;
	}
	
	private gov.va.med.imaging.federation.webservices.types.v2.PatientSensitivityLevelType transformPatientSensitiveLevel(PatientSensitivityLevel sensitiveLevel)
	{
		gov.va.med.imaging.federation.webservices.types.v2.PatientSensitivityLevelType result = null;
		
		if(sensitiveLevel == PatientSensitivityLevel.ACCESS_DENIED)
		{
			result = gov.va.med.imaging.federation.webservices.types.v2.PatientSensitivityLevelType.ACCESS_DENIED;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DATASOURCE_FAILURE)
		{
			result = gov.va.med.imaging.federation.webservices.types.v2.PatientSensitivityLevelType.RPC_FAILURE;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DISPLAY_WARNING)
		{
			result = gov.va.med.imaging.federation.webservices.types.v2.PatientSensitivityLevelType.DISPLAY_WARNING;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DISPLAY_WARNING_CANNOT_CONTINUE)
		{
			result = gov.va.med.imaging.federation.webservices.types.v2.PatientSensitivityLevelType.DISPLAY_WARNING_CANNOT_CONTINUE;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.DISPLAY_WARNING_REQUIRE_OK)
		{
			result = gov.va.med.imaging.federation.webservices.types.v2.PatientSensitivityLevelType.DISPLAY_WARNING_REQUIRE_OK;
		}
		else if(sensitiveLevel == PatientSensitivityLevel.NO_ACTION_REQUIRED)
		{
			result = gov.va.med.imaging.federation.webservices.types.v2.PatientSensitivityLevelType.NO_ACTION_REQUIRED;
		}
		return result;
	}
}
