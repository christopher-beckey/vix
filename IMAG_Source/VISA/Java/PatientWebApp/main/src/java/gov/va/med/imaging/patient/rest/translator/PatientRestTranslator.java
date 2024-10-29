/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 9, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.patient.rest.translator;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import gov.va.med.imaging.exchange.business.HealthSummaryType;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.PatientMeansTestResult;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.patient.rest.types.PatientHealthSummariesType;
import gov.va.med.imaging.patient.rest.types.PatientHealthSummaryType;
import gov.va.med.imaging.patient.rest.types.PatientMeansTestType;
import gov.va.med.imaging.patient.rest.types.PatientSensitiveValueType;
import gov.va.med.imaging.patient.rest.types.PatientSensitivityLevelType;
import gov.va.med.imaging.patient.rest.types.PatientType;

/**
 * @author VHAISWWERFEJ
 *
 */
public class PatientRestTranslator
{
	
	private static Map<PatientSensitivityLevel, PatientSensitivityLevelType> patientSensitiveLevelTypeMap;
	
	static
	{
		patientSensitiveLevelTypeMap = new HashMap<PatientSensitivityLevel, PatientSensitivityLevelType>();
		patientSensitiveLevelTypeMap.put(PatientSensitivityLevel.ACCESS_DENIED, 
				PatientSensitivityLevelType.ACCESS_DENIED);
		patientSensitiveLevelTypeMap.put(PatientSensitivityLevel.DATASOURCE_FAILURE, 
				PatientSensitivityLevelType.DATASOURCE_FAILURE);
		patientSensitiveLevelTypeMap.put(PatientSensitivityLevel.DISPLAY_WARNING, 
				PatientSensitivityLevelType.DISPLAY_WARNING);
		patientSensitiveLevelTypeMap.put(PatientSensitivityLevel.DISPLAY_WARNING_CANNOT_CONTINUE, 
				PatientSensitivityLevelType.DISPLAY_WARNING_CANNOT_CONTINUE);
		patientSensitiveLevelTypeMap.put(PatientSensitivityLevel.DISPLAY_WARNING_REQUIRE_OK, 
				PatientSensitivityLevelType.DISPLAY_WARNING_REQUIRE_OK);
		patientSensitiveLevelTypeMap.put(PatientSensitivityLevel.NO_ACTION_REQUIRED, 
				PatientSensitivityLevelType.NO_ACTION_REQUIRED);
	}
	
	public static PatientHealthSummariesType translateHealthSummaries(List<HealthSummaryType> healthSummaries)
	{
		if(healthSummaries == null)
			return null;
		
		PatientHealthSummaryType [] result = new PatientHealthSummaryType[healthSummaries.size()];
		for(int i = 0; i < healthSummaries.size(); i++)
		{
			HealthSummaryType healthSummary = healthSummaries.get(i);
			result[i] = new PatientHealthSummaryType(healthSummary.getHealthSummaryUrn().toString(), healthSummary.getName());
		}
		
		return new PatientHealthSummariesType(result);
		
	}
	
	public static PatientSensitiveValueType translate(PatientSensitiveValue sensitiveValue)
	{
		if(sensitiveValue == null)
			return null;

		return new PatientSensitiveValueType(sensitiveValue.getWarningMessage(), 
				translate(sensitiveValue.getSensitiveLevel()));		
	}
	
	private static PatientSensitivityLevelType translate(PatientSensitivityLevel sensitivityLevel)
	{
		for( Entry<PatientSensitivityLevel, PatientSensitivityLevelType> entry : PatientRestTranslator.patientSensitiveLevelTypeMap.entrySet() )
			if( entry.getKey() == sensitivityLevel )
				return entry.getValue();
		
		return null;
	}
	
	public static PatientType translate(Patient patient)
	{
		if(patient == null)
			return null;
		return new PatientType(patient.getPatientName(), patient.getPatientIcn(),
				patient.getVeteranStatus(), patient.getPatientSex().name(), patient.getDob(), 
				patient.getSsn(), patient.getDfn(), patient.getSensitive());
	}

	public static PatientMeansTestType translateMeansTest(PatientMeansTestResult meansTest) 
	{
		if (meansTest == null)
			return null;
		
		return new PatientMeansTestType(meansTest.getCode(), meansTest.getMessage());
	}

}
