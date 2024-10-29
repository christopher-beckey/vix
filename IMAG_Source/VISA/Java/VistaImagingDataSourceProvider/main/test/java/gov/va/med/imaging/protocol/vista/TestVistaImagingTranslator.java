/**
 * 
 */
package gov.va.med.imaging.protocol.vista;

import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;

import org.apache.logging.log4j.Level;
import gov.va.med.logging.Logger;
import org.apache.logging.log4j.core.config.Configurator;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.ObjectOrigin;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.protocol.vista.exceptions.VistaParsingException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistaobjects.VistaImage;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class TestVistaImagingTranslator
	extends TestCase
{
	
	
	private static final Logger logger = Logger.getLogger(TestVistaImagingTranslator.class);


	@Override
	protected void setUp() throws Exception {
		super.setUp();
	    Configurator.setRootLevel(Level.INFO);

	}

	/**
	 * Test method for {@link gov.va.med.imaging.protocol.vista.VistaImagingTranslator#convertStringToPatientSensitiveValue(java.lang.String, java.lang.String)}.
	 */
	public void testConvertStringToPatientSensitiveValue()
	{
		try
		{
			VistaImagingTranslator.convertStringToPatientSensitiveValue(null, "655321");
			fail("Simulated null response was not detected.");
		}
		catch (VistaMethodException x){}
		
		try
		{
			VistaImagingTranslator.convertStringToPatientSensitiveValue("-1", "655321");
			fail("Simulated error response was not detected.");
		}
		catch (VistaMethodException x){}
		
		String vistaResponse;
		
		try
		{
			vistaResponse = "0";
			PatientSensitiveValue patientSensitivity = 
				VistaImagingTranslator.convertStringToPatientSensitiveValue(vistaResponse, "655321");
			assertNotNull(patientSensitivity);
			assertEquals(PatientSensitivityLevel.NO_ACTION_REQUIRED, patientSensitivity.getSensitiveLevel());
		}
		catch (VistaMethodException x){fail(x.getMessage());}
		
		try
		{
			vistaResponse = "1";
			PatientSensitiveValue patientSensitivity = 
				VistaImagingTranslator.convertStringToPatientSensitiveValue(vistaResponse, "655321");
			assertNotNull(patientSensitivity);
			assertEquals(PatientSensitivityLevel.DISPLAY_WARNING, patientSensitivity.getSensitiveLevel());
		}
		catch (VistaMethodException x){fail(x.getMessage());}
		
		try
		{
			vistaResponse = "2";
			PatientSensitiveValue patientSensitivity = 
				VistaImagingTranslator.convertStringToPatientSensitiveValue(vistaResponse, "655321");
			assertNotNull(patientSensitivity);
			assertEquals(PatientSensitivityLevel.DISPLAY_WARNING_REQUIRE_OK, patientSensitivity.getSensitiveLevel());
		}
		catch (VistaMethodException x){fail(x.getMessage());}
		
		try
		{
			vistaResponse = "3";
			PatientSensitiveValue patientSensitivity = 
				VistaImagingTranslator.convertStringToPatientSensitiveValue(vistaResponse, "655321");
			assertNotNull(patientSensitivity);
			assertEquals(PatientSensitivityLevel.DISPLAY_WARNING_CANNOT_CONTINUE, patientSensitivity.getSensitiveLevel());
		}
		catch (VistaMethodException x){fail(x.getMessage());}
		
		try
		{
			vistaResponse = "4";
			PatientSensitiveValue patientSensitivity = 
				VistaImagingTranslator.convertStringToPatientSensitiveValue(vistaResponse, "655321");
			assertNotNull(patientSensitivity);
			assertEquals(PatientSensitivityLevel.ACCESS_DENIED, patientSensitivity.getSensitiveLevel());
		}
		catch (VistaMethodException x){fail(x.getMessage());}

	}

	/**
	 * Test method for {@link gov.va.med.imaging.protocol.vista.VistaImagingTranslator#createImageGroupFromImageLines(java.lang.String, gov.va.med.imaging.exchange.business.Study)}.
	 * @throws VistaParsingException 
	 * @throws URNFormatException 
	 */
	public void testParse_RPC_MAG_GET_STUDY_IMAGES() 
	throws VistaParsingException, URNFormatException
	{
		Study study = Study.create(ObjectOrigin.VA, "660", "12345", PatientIdentifier.icnPatientIdentifier("655321"), 
				StudyLoadLevel.FULL, StudyDeletedImageState.cannotIncludeDeletedImages);
		
		// DVB>S MAGIEN=4763
		// DVB>D GROUP^MAGGTIG(.MAGRY,MAGIEN,1)
		// DVB>ZW

		String vistaResponse = 
            "B2^4764^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\47\\DM004764.DCM^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\47\\DM004764.ABS^SPINE ENTIRE AP&LAT (#1)^3030508.0856^100^US^05/08/2003 08:56^^M^A^1^27^1^1^SLC^^^720^PATIENT,SEVENTWOZERO^CLIN^05/09/2003 09:49:15^^^";
		
		SortedSet<VistaImage> vistaImages = VistaImagingTranslator.createImageGroupFromImageLines(vistaResponse, study);
		assertNotNull(vistaImages);
		
		//String vistaResponse = 
		//	 "1^Class: CLIN -\f" + 
		//	 "Item~S2^Site^Note Title~~W0^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0\f" +
		//	 "1^WAS^NURSING NOTE^09/28/2001 00:01^NOTE^2^CONSULT NURSE MEDICAL WOUND SPEC INPT^NOTE^CLIN^CONSULT^NURSING^WOUND ASSESSMENT^VA^09/28/2001 01:35^IMAGPROVIDERONETWOSIX,ONETWOSIX^1752|1752^\\\\ISW-IMGGOLDBACK\\image1$\\DM\\00\\17\\DM001753.JPG^\\\\ISW-IMGGOLDBACK\\image1$\\DM\00\\17\\DM001753.ABS^CONSULT NURSE MEDICAL WOUND SPEC INPT^3010928^11^NOTE^09/28/2001^36^M^A^^^2^1^WAS^^^711^IMAGPATIENT1055,1055^CLIN^^^\f" +
		//	 "2^WAS^OPHTHALMOLOGY^08/20/2001 00:01^OPH^10^Ophthalmology^NOTE^CLIN^IMAGE^EYE CARE^^VA^08/20/2001 22:32^IMAGPROVIDERONETWOSIX,ONETWOSIX^1783|1783^\\\\ISW-IMGGOLDBACK\\image1$\\DM\\00\\17\\DM001784.DCM^\\\\ISW-IMGGOLDBACK\\image1$\\DM\\00\\17\\DM001784.ABS^Ophthalmology^3010820^11^OPH^08/20/2001^41^M^A^^^10^1^WAS^^^711^IMAGPATIENT1055,1055^CLIN^^^^";
	}

	/**
	 * Test the parsing of a response from  RPC MAG4 PAT GET IMAGES call
	 * @throws VistaParsingException 
	 */
	public void testParse_MAG4_PAT_GET_IMAGES() 
	throws VistaParsingException
	{
		// RPC MAG4 PAT GET IMAGES
		// S DFN=720
		// DVB>S DFN=720
		// DVB>D PGI^MAGSIXG1(.MAGOUT,DFN)
		// DVB>ZW
		String vistaResponse = 
			"1^All existing images\n" +
			"Item~S2^Site^Note Title~~W0^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0\n" + 
			"1^SLC^   ^05/09/2003 14:20^RAD NM^120^UNLISTED RADIOLOGIC PROCEDURE^RAD^CLIN^IMAGE^NUCLEAR MEDICINE^NUCLEAR MEDICINE SCAN^VA^05/09/2003 14:41:09^^5529^|5529^\\\\vhaiswimmixvi1\\image1$\\DM\00\\55\\DM005530.TGA^\\\\vhaiswimmixvi1\\image1$\\DM\00\\55\\DM005530.ABS^UNLISTED RADIOLOGIC PROCEDURE^3030509.142^11^RAD NM^05/09/2003 14:20^^M^A^^^120^1^SLC^^^720^PATIENT,SEVENTWOZERO^CLIN^05/09/2003 14:41:09^^^\n" + 
			"2^SLC^   ^05/08/2003 08:56^RAD US^1^SPINE ENTIRE AP&LAT^RAD^CLIN^IMAGE^RADIOLOGY^ULTRASOUND^VA^05/09/2003 09:49:15^^4764^|4764^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\47\\DM004764.DCM^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\47\\DM004764.ABS^SPINE ENTIRE AP&LAT^3030508.0856^100^RAD US^05/08/2003 08:56^^M^A^^^1^1^SLC^^^720^PATIENT,SEVENTWOZERO^CLIN^05/09/2003 09:49:15^^^\n" + 
			"3^SLC^   ^05/08/2003 08:54^RAD CR^4^CHEST SINGLE VIEW^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED RADIOGRAPHY^VA^05/08/2003 15:37:17^^4730^|4730^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\47\\DM004731.DCM^\\\\vhaiswimmixvi1\\image1$\\DM\00\\47\\DM004731.ABS^CHEST SINGLE VIEW^3030508.0854^11^RAD CR^05/08/2003 08:54^^M^A^^^4^1^SLC^^^720^PATIENT,SEVENTWOZERO^CLIN^05/08/2003 15:37:17^^^\n" +
			"4^SLC^   ^05/08/2003 08:54^RAD CR^4^CHEST 2 VIEWS PA&LAT^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED RADIOGRAPHY^VA^05/08/2003 14:22:43^^3730^|3730^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\37\\DM003731.TGA^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\37\\DM003731.ABS^CHEST 2 VIEWS PA&LAT^3030508.0854^11^RAD CR^05/08/2003 08:54^^M^A^^^4^1^SLC^^\\vhaiswimmixvi1\\image1$\\DM\\00\\37\\DM003731.BIG^720^PATIENT,SEVENTWOZERO^CLIN^05/08/2003 14:22:43^^^\n" +
			"5^SLC^   ^05/08/2003 08:39^RAD NM^2^ECHOGRAM PELVIC B-SCAN &/OR REAL TIME W/IMAGING^RAD^CLIN^IMAGE^NUCLEAR MEDICINE^NUCLEAR MEDICINE SCAN^VA^05/09/2003 14:00:22^^5526^|5526^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\55\\DM005527.DCM^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\55\\DM005527.ABS^ECHOGRAM PELVIC B-SCAN &/OR REAL TIME W/IMAGING^3030508.0839^11^RAD NM^05/08/2003 08:39^^M^A^^^2^1^SLC^^^720^PATIENT,SEVENTWOZERO^CLIN^05/09/2003 14:00:22^^^\n" +
			"6^SLC^   ^05/08/2003 08:38^RAD MR^156^MAGNETIC IMAGE,BRAIN STEM^RAD^CLIN^IMAGE^RADIOLOGY^MAGNETIC RESONANCE SCAN^VA^05/09/2003 11:48:58^^4926^|4926^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\49\\DM004927.TGA^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\49\\DM004927.ABS^MAGNETIC IMAGE,BRAIN STEM^3030508.0838^11^RAD MR^05/08/2003 08:38^^M^A^^^156^1^SLC^^^720^PATIENT,SEVENTWOZERO^CLIN^05/09/2003 11:48:58^^^\n" + 
			"7^SLC^   ^05/08/2003 08:38^RAD MR^156^MAGNETIC IMAGE,ABDOMEN^RAD^CLIN^IMAGE^RADIOLOGY^MAGNETIC RESONANCE SCAN^VA^05/09/2003 10:28:24^^4769^|4769^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\47\\DM004770.TGA^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\47\\DM004770.ABS^MAGNETIC IMAGE,ABDOMEN^3030508.0838^11^RAD MR^05/08/2003 08:38^^M^A^^^156^1^SLC^^^720^PATIENT,SEVENTWOZERO^CLIN^05/09/2003 10:28:24^^^\n" + 
			"8^SLC^   ^05/08/2003 08:26^RAD CT^208^CT THORAX W/O CONT^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED TOMOGRAPHY^VA^05/09/2003 13:32:52^^5317^|5317^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\53\\DM005318.DCM^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\53\\DM005318.ABS^CT THORAX W/O CONT^3030508.0826^11^RAD CT^05/08/2003 08:26^^M^A^^^208^1^SLC^^^720^PATIENT,SEVENTWOZERO^CLIN^05/09/2003 13:32:52^^^\n" + 
			"9^SLC^   ^05/08/2003 08:26^RAD CT^206^CT HEAD W/O CONT^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED TOMOGRAPHY^VA^05/09/2003 12:42:29^^5105^|5105^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\51\\DM005106.TGA^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\51\\DM005106.ABS^CT HEAD W/O CONT^303058.0826^11^RAD CT^05/08/2003 08:26^^M^A^^^206^1^SLC^^^720^PATIENT,SEVENTWOZERO^CLIN^05/09/2003 12:42:29^^^";

		List<Image> images = 
			VistaImagingTranslator.createImagesForFirstImagesFromVistaGroupList(vistaResponse, 
					PatientIdentifier.icnPatientIdentifier("655321"), "660");
		assertEquals(9, images.size());
		
	}
	
	/**
	 * 
	 * @throws VistaParsingException
	 * @throws URNFormatException 
	 */
	public void testParse_MAGG_GROUP_IMAGES() 
	throws VistaParsingException, URNFormatException
	{
		// DVB>S MAGIEN=4763
		// DVB>D GROUP^MAGGTIG(.MAGRY,MAGIEN,1)
		// DVB>ZW
		 
		String vistaResponse = 
			"1^1\n" +
			"B2^4764^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\47\\DM004764.DCM^\\\\vhaiswimmixvi1\\image1$\\DM\\00\\47\\DM004764.ABS^SPINE ENTIRE AP&LAT (#1)^3030508.0856^100^US^05/08/2003 08:56^^M^A^1^27^1^1^SLC^^^720^PATIENT,SEVENTWOZERO^CLIN^05/09/2003 09:49:15^^^";
		String siteId = "660";
		String decodedStudyIen = "42";
		String patientIcn = "655321";
		
		List<Image> images = VistaImagingTranslator.VistaImageStringListToImageList(vistaResponse, siteId, 
				decodedStudyIen, PatientIdentifier.icnPatientIdentifier(patientIcn));
	}
	
	public void testParse_MAG3_CPRS_TIU_NOTE() 
	throws VistaParsingException
	{
		// DVB>K ^TMP
		// DVB>D DT^DICRW
		// DVB>S TIUDA=481
		// DVB>D IMAGES^MAGGNTI(.MAGRY,TIUDA)
		// DVB>ZW

		String vistaResponse = 
			"12^12 Images for the selected TIU NOTE^481^PATIENT,ONEZEROTWOTHREE  OPHTHALMOLOGIST CONSULT NOTE  17 Mar 04@15:42:16^8811\n" +
			"B2^8800^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008800.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008800.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:41^^^\n" +
			"B2^8801^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008801.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008801.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:42^^^\n" +
			"B2^8802^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008802.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008802.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:42^^^\n" +
			"B2^8803^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008803.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008803.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:43^^^\n" + 
			"B2^8804^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008804.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008804.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:43^^^\n" +
			"B2^8805^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008805.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008805.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:43^^^\n" +
			"B2^8806^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008806.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008806.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:43^^^\n" +
			"B2^8807^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008807.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008807.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:44^^^\n" +
			"B2^8808^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008808.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008808.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:44^^^\n" +
			"B2^8809^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008809.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008809.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:44^^^\n" +
			"B2^8810^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008810.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008810.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:45^^^\n" +
			"B2^8811^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008811.DCM^\\\\vhaiswimmixvi1\\image1$\\DM00\\00\\00\\00\\88\\DM000000008811.ABS^OPHTHALMOLOGIST CONSULT NOTE^3040317^100^OT^03/17/2004^^M^A^^^1^1^SLC^^^1023^PATIENT,ONEZEROTWOTHREE^CLIN^03/17/2004 15:46:45^^^";
		
		List<VistaImage> vistaImages = 
			VistaImagingTranslator.extractVistaImageListFromVistaResult(vistaResponse);
	}
	
	public void testParse_MAGG_CPRS_RAD_EXAM() 
	throws VistaParsingException
	{
		// DVB>S DATA="RPT^CPRS^711^RA^i7029271.8955-1^30^^^^^^^1"
		// DVB>D IMAGEC^MAGGTRAI(.MAGZRY,DATA)
		// DVB>ZW
			 		
		String vistaResponse = 
			"1^Images for the selected Radiology Exam^44^072897-30  CHEST SINGLE VIEW  2970728.1044^52\n" +
			"B2^52^\\\\vhaiswimmixvi1\\image1$\\IE000052.TGA^\\\\vhaiswimmixvi1\\image1$\\IE000052.ABS^X-RAY   CHEST SINGLE VIEW  7/28/97^2970728^3^[S]GEN. MED.^07/28/1997^1^M^A^^^1^1^SLC^^^711^PATIENT,SEVENONEONE^CLIN^03/26/1998 11:00^^^";
		
		List<VistaImage> vistaImages = 
			VistaImagingTranslator.extractVistaImageListFromVistaResult(vistaResponse);
	}
	
	/**
	public void testParse_RPC_MAGN_CPRS_IMAGE_LIST_1() 
	throws VistaParsingException, URNFormatException
	{
		
		PatientIdentifier patient = PatientIdentifier.icnPatientIdentifier("655321777V105660");

		Site site = new SLCSite();
		StudyFilter filter = new StudyFilter();

		StringBuffer buffer = new StringBuffer();
		buffer.append("1\r\n");
		buffer.append("NEXT_CONTEXTID|RPT^CPRS^100899^TIU^12550^^^^^^^^1|1|12\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.500.1.936|\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.500.1.936\r\n");
		buffer.append("STUDY_IEN|10469|2|10470||500\r\n");
		buffer.append("STUDY_INFO|^^VEHU IMAGING CONSULT RESULT^09/12/2017 19:39:02^CON/PROC^^CP ELECTROCARDIOGRAM^CONS^CLIN^IMAGE^CARDIOLOGY^ECHOCARDIOGRAM^VA^09/12/2017 16:29:30^^10469^^^^|TIU-12550\r\n");
		buffer.append("STUDY_PAT|100899|5000002703V636083|PATIENT,DANIELLE I\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_IEN|10469\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|10470\r\n");
		buffer.append("GROUP_IEN|10469\r\n");
		buffer.append("IMAGE_INFO|^10470^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010470.DCM^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010470.ABS^CP ELECTROCARDIOGRAM (#1)^3170912.193902^100^CR^09/12/2017 19:39:02^20^M^A^^^1^1^PAN^^^100899^PATIENT,DANIELLE I^CLIN^09/12/2017 16:29:30^07/31/2001 19:39:22^10469^^^^0^1^1^0^1^1^Image is Viewable.^CONS^\r\n");
		
		CprsIdentifierImages cprsIdentifiers = null;
		try {
			cprsIdentifiers = VistaImagingTranslator.extractCprsImageListFromVistaResult(site, patient, buffer.toString(), filter);
		} catch (TranslationException tX) {
			fail();
		}
		assertNotNull(cprsIdentifiers);
		HashMap<String,List<Study> > studies = cprsIdentifiers.getVistaStudies();
		List<Study> studyList = studies.get("RPT^CPRS^100899^TIU^12550^^^^^^^^1");
		Study study = (Study)studyList.get(0);
		assertEquals("1.2.840.113754.1.4.500.1.936", study.getStudyUid());
		assertEquals("10469", study.getStudyIen());
	}
	
	public void testParse_RPC_MAGN_CPRS_IMAGE_LIST_2() 
	throws VistaParsingException, URNFormatException
	{
		
		PatientIdentifier patient = PatientIdentifier.icnPatientIdentifier("655321777V105660");

		Site site = new SLCSite();
		StudyFilter filter = new StudyFilter();


		StringBuffer buffer = new StringBuffer();
		buffer.append("1\r\n");
		buffer.append("NEXT_CONTEXTID|RPT^CPRS^100899^TIU^12550^^^^^^^^1|1|12\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.500.1.936|\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.500.1.936\r\n");
		buffer.append("STUDY_IEN|10469|2|10470||500\r\n");
		buffer.append("STUDY_INFO|^^VEHU IMAGING CONSULT RESULT^09/12/2017 19:39:02^CON/PROC^^CP ELECTROCARDIOGRAM^CONS^CLIN^IMAGE^CARDIOLOGY^ECHOCARDIOGRAM^VA^09/12/2017 16:29:30^^10469^^^^660-GMR-12345|TIU-12550\r\n");
		buffer.append("STUDY_PAT|100899|5000002703V636083|PATIENT,DANIELLE I\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_IEN|10469\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|10470\r\n");
		buffer.append("GROUP_IEN|10469\r\n");
		buffer.append("IMAGE_INFO|^10470^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010470.DCM^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010470.ABS^CP ELECTROCARDIOGRAM (#1)^3170912.193902^100^CR^09/12/2017 19:39:02^20^M^A^^^1^1^PAN^^^100899^PATIENT,DANIELLE I^CLIN^09/12/2017 16:29:30^07/31/2001 19:39:22^10469^^^^0^1^1^0^1^1^Image is Viewable.^CONS^\r\n");
		
		CprsIdentifierImages cprsIdentifiers = null;
		try {
			cprsIdentifiers = VistaImagingTranslator.extractCprsImageListFromVistaResult(site, patient, buffer.toString(), filter);
		} catch (TranslationException tX) {
			fail();
		}
		assertNotNull(cprsIdentifiers);
		HashMap<String,List<Study> > studies = cprsIdentifiers.getVistaStudies();
		List<Study> studyList = studies.get("RPT^CPRS^100899^TIU^12550^^^^^^^^1");
		Study study = (Study)studyList.get(0);
		assertEquals("1.2.840.113754.1.4.500.1.936", study.getStudyUid());
		assertEquals("10469", study.getStudyIen());
		assertEquals("660-GMR-12345", study.getAccessionNumber());
		assertEquals("TIU-12550", study.getAlternateExamNumber());
		assertFalse(study.isStudyInNewDataStructure());
	}
	
	
	public void testParse_RPC_MAGN_CPRS_IMAGE_LIST_3() 
	throws VistaParsingException, URNFormatException
	{
		
		Site site = new SLCSite();
		StudyFilter filter = new StudyFilter();


		PatientIdentifier patient = PatientIdentifier.icnPatientIdentifier("6553211234V777660");

		StringBuffer buffer = new StringBuffer();
		buffer.append("1\r\n");
		buffer.append("NEXT_CONTEXTID|RPT^CPRS^100899^TIU^12550^^^^^^^^1|1|67\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.500.1.936|NEW\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.500.1.936\r\n");
		buffer.append("STUDY_IEN|6|2\r\n");
		buffer.append("STUDY_INFO|^^^09/12/2017 10:39:04^^^^CONS^^^^^VA^09/12/2017 10:39:04^^^^^^660-GMR-12345|TIU-12550\r\n");
		buffer.append("STUDY_PAT|100899|5000002703V636083|PATIENT,DANIELLE I\r\n");
		buffer.append("STUDY_MODALITY|\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.2008.7274.1505246785870.6.3.1.1\r\n");
		buffer.append("SERIES_IEN|40\r\n");
		buffer.append("SERIES_MODALITY|ECG\r\n");
		buffer.append("SERIES_NUMBER|\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.2008199502.727436826.1505246785870.8.0\r\n");
		buffer.append("IMAGE_IEN|29\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|29^^^^^IMAGE^^^^^^^^^^^^^^^^05/14/2013 10:39:04^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|29\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|31\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170912.163003\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20170912.163027\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000031.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|2\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|35\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|31\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170921.144944\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000031.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\WORMOTG$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|31\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|33\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170912.163027\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000033.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|2\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|33\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|33\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170921.144942\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000033.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\WORMOTG$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
	
		CprsIdentifierImages cprsIdentifiers;
		try {
			cprsIdentifiers = VistaImagingTranslator.extractCprsImageListFromVistaResult(site, patient, buffer.toString(), filter);
		} catch (TranslationException tX) {
			throw new VistaParsingException(tX);
		}
		assertNotNull(cprsIdentifiers);
		HashMap<String,List<Study> > studies = cprsIdentifiers.getVistaStudies();
		List<Study> studyList = studies.get("RPT^CPRS^100899^TIU^12550^^^^^^^^1");
		Study study = (Study)studyList.get(0);
		assertEquals("1.2.840.113754.1.4.500.1.936", study.getStudyUid());
		assertEquals("6", study.getStudyIen());
		assertEquals("660-GMR-12345", study.getAccessionNumber());
		assertEquals("TIU-12550", study.getAlternateExamNumber());
		assertTrue(study.isStudyInNewDataStructure());
		
		Set<Series> series = study.getSeries();
		Iterator<Series> iter = series.iterator();
		while(iter.hasNext()){
			Series serie = (Series)iter.next();
			assertEquals("40", serie.getSeriesIen());
			assertEquals("ECG", serie.getModality());
			assertTrue(serie.isSeriesInNewDataStructure());
			
			
			Iterator<Image> iter2 = serie.iterator();
			while(iter2.hasNext()){
				Image image = (Image)iter2.next();
				assertEquals("1.3.6.1.4.1.5962.99.1.2008199502.727436826.1505246785870.8.0", image.getImageUid());
				assertEquals("29", image.getIen());
				assertEquals("\\\\54.235.72.148\\IMAGE1$\\500\\00\\00\\00\\00\\00\\00\\500_00000000000031.dcm", image.getFullFilename());
				assertEquals("\\\\54.235.72.148\\WORMOTG$\\500\\00\\00\\00\\00\\00\\00\\500_00000000000031.jpg", image.getAbsFilename());
				assertTrue(image.isImageInNewDataStructure());
			}
		}
	}
	
	/**
	public void testParse_RPC_MAGN_CPRS_IMAGE_LIST_4() 
	throws VistaParsingException, URNFormatException
	{
		
		Site site = new SLCSite();
		StudyFilter filter = new StudyFilter();


		PatientIdentifier patient = PatientIdentifier.icnPatientIdentifier("6553211234V777660");

		StringBuffer buffer = new StringBuffer();
		buffer.append("1\r\n");
		buffer.append("NEXT_CONTEXTID|RPT^CPRS^100899^TIU^12550^^^^^^^^1|1|79\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.500.1.936|\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.500.1.936\r\n");
		buffer.append("STUDY_IEN|10469|2|10470||500\r\n");
		buffer.append("STUDY_INFO|^^VEHU IMAGING CONSULT RESULT^09/12/2017 19:39:02^CON/PROC^^CP ELECTROCARDIOGRAM^CONS^CLIN^IMAGE^CARDIOLOGY^ECHOCARDIOGRAM^VA^09/12/2017 16:29:30^^10469^^^^660-GMR-12345|TIU-12550\r\n");
		buffer.append("STUDY_PAT|100899|5000002703V636083|PATIENT,DANIELLE I\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_IEN|10469\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|10470\r\n");
		buffer.append("GROUP_IEN|10469\r\n");
		buffer.append("IMAGE_INFO|^10470^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010470.DCM^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010470.ABS^CP ELECTROCARDIOGRAM (#1)^3170912.193902^100^CR^09/12/2017 19:39:02^20^M^A^^^1^1^PAN^^^100899^PATIENT,DANIELLE I^CLIN^09/12/2017 16:29:30^07/31/2001 19:39:22^10469^^^^0^1^1^0^1^1^Image is Viewable.^CONS^\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.500.1.936|NEW\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.500.1.936\r\n");
		buffer.append("STUDY_IEN|6|2\r\n");
		buffer.append("STUDY_INFO|^^^09/12/2017 10:39:04^^^^CONS^^^^^VA^09/12/2017 10:39:04^^^^^^660-GMR-12345|TIU-12550\r\n");
		buffer.append("STUDY_PAT|100899|5000002703V636083|PATIENT,DANIELLE I\r\n");
		buffer.append("STUDY_MODALITY|\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.2008.7274.1505246785870.6.3.1.1\r\n");
		buffer.append("SERIES_IEN|40\r\n");
		buffer.append("SERIES_MODALITY|ECG\r\n");
		buffer.append("SERIES_NUMBER|\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.2008199502.727436826.1505246785870.8.0\r\n");
		buffer.append("IMAGE_IEN|29\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|29^^^^^IMAGE^^^^^^^^^^^^^^^^05/14/2013 10:39:04^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|29\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|31\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170912.163003\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20170912.163027\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000031.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|2\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|35\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|31\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170921.144944\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000031.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\WORMOTG$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|31\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|33\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170912.163027\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000033.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|2\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|33\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|33\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170921.144942\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000033.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\WORMOTG$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
	
		CprsIdentifierImages cprsIdentifiers;
		try {
			cprsIdentifiers = VistaImagingTranslator.extractCprsImageListFromVistaResult(site, patient, buffer.toString(), filter);
		} catch (TranslationException tX) {
			throw new VistaParsingException(tX);
		}
		assertNotNull(cprsIdentifiers);
		HashMap<String,List<Study> > studies = cprsIdentifiers.getVistaStudies();
		List<Study> studyList = studies.get("RPT^CPRS^100899^TIU^12550^^^^^^^^1");
		Study study0 = (Study)studyList.get(0);
		assertEquals("1.2.840.113754.1.4.500.1.936", study0.getStudyUid());
		assertEquals("10469", study0.getStudyIen());
		assertEquals("660-GMR-12345", study0.getAccessionNumber());
		assertEquals("TIU-12550", study0.getAlternateExamNumber());
		assertFalse(study0.isStudyInNewDataStructure());

		
		Study study1 = (Study)studyList.get(1);
		assertEquals("1.2.840.113754.1.4.500.1.936", study1.getStudyUid());
		assertEquals("6", study1.getStudyIen());
		assertEquals("660-GMR-12345", study1.getAccessionNumber());
		assertEquals("TIU-12550", study1.getAlternateExamNumber());
		assertTrue(study1.isStudyInNewDataStructure());
		
		Set<Series> series = study1.getSeries();
		Iterator<Series> iter = series.iterator();
		while(iter.hasNext()){
			Series serie = (Series)iter.next();
			assertEquals("40", serie.getSeriesIen());
			assertEquals("ECG", serie.getModality());
			assertTrue(serie.isSeriesInNewDataStructure());
			
			
			Iterator<Image> iter2 = serie.iterator();
			while(iter2.hasNext()){
				Image image = (Image)iter2.next();
				assertEquals("1.3.6.1.4.1.5962.99.1.2008199502.727436826.1505246785870.8.0", image.getImageUid());
				assertEquals("29", image.getIen());
				assertEquals("\\\\54.235.72.148\\IMAGE1$\\500\\00\\00\\00\\00\\00\\00\\500_00000000000031.dcm", image.getFullFilename());
				assertEquals("\\\\54.235.72.148\\WORMOTG$\\500\\00\\00\\00\\00\\00\\00\\500_00000000000031.jpg", image.getAbsFilename());
				assertTrue(image.isImageInNewDataStructure());
			}
		}
	}
	
	public void testParse_RPC_MAGN_CPRS_IMAGE_LIST_5() 
	throws VistaParsingException, URNFormatException
	{
		
		Site site = new SLCSite();
		StudyFilter filter = new StudyFilter();


		PatientIdentifier patient = PatientIdentifier.icnPatientIdentifier("6553211234V777660");

		StringBuffer buffer = new StringBuffer();
		buffer.append("1\r\n");
		buffer.append("NEXT_CONTEXTID|RPT^CPRS^101038^RA^6829173.8396-1^^^^^^^^1|1|118\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.500.6829173.8396.1.82617.86|NEW\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.500.6829173.8396.1.82617.86\r\n");
		buffer.append("STUDY_IEN|1|30\r\n");
		buffer.append("STUDY_INFO|^^^08/26/2017 12:28^^^^RAD^^^^^VA^08/26/2017 12:28^^^^^^082617-86|RAD-750\r\n");
		buffer.append("STUDY_PAT|101038|5000002744V988457|PATIENT,DAN XVII\r\n");
		buffer.append("STUDY_MODALITY|\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.686.3969.1503925127881.95.3.1.1\r\n");
		buffer.append("SERIES_IEN|29\r\n");
		buffer.append("SERIES_MODALITY|CT\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|29\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.686541513.396984826.1503925127881.96.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|29^^^^^IMAGE^^^^^^^^^^^^^^^^12/19/2006 10:16:06^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|1\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|3\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170828.154419\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20170828.154523\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000003.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|2\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
		buffer.append("ARTIFACTINSTANCE_URL|this is a first linsecond line\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|2\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|5\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170828.154524\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000005.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|2\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.686.3969.1503925127881.95.3.30.2\r\n");
		buffer.append("SERIES_IEN|30\r\n");
		buffer.append("SERIES_MODALITY|CT\r\n");
		buffer.append("SERIES_NUMBER|2\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|30\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.686541513.396984826.1503925127881.97.0\r\n");
		buffer.append("IMAGE_NUMBER|2\r\n");
		buffer.append("IMAGE_INFO|30^^^^^IMAGE^^^^^^^^^^^^^^^^12/19/2006 13:33:01^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|3\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|4\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170828.154639\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20170828.154734\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000004.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|2\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|4\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|6\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170828.154735\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000006.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|2\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.68.3969.1503925127881.109.3.2.501\r\n");
		buffer.append("SERIES_IEN|34\r\n");
		buffer.append("SERIES_MODALITY|SR\r\n");
		buffer.append("SERIES_NUMBER|501\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|34\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.686541513.396984826.1503925127881.110.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|34^^^^^IMAGE^^^^^^^^^^^^^^^^03/26/2009 09:35:48^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|11\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|13\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170828.1624\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20170828.162442\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000013.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|2\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|12\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|14\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170828.162442\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|500_00000000000014.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|2\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\54.235.72.148\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|500\\00\\00\\00\\00\\00\\00\\\r\n");

		CprsIdentifierImages cprsIdentifiers;
		try {
			cprsIdentifiers = VistaImagingTranslator.extractCprsImageListFromVistaResult(site, patient, buffer.toString(), filter);
		} catch (TranslationException tX) {
			throw new VistaParsingException(tX);
		}
		assertNotNull(cprsIdentifiers);
		HashMap<String,List<Study> > studies = cprsIdentifiers.getVistaStudies();
		List<Study> studyList = studies.get("RPT^CPRS^101038^RA^6829173.8396-1^^^^^^^^1");
		Study study = (Study)studyList.get(0);
		assertEquals("1.2.840.113754.1.4.500.6829173.8396.1.82617.86", study.getStudyUid());
		assertEquals("1", study.getStudyIen());
		assertEquals(30, study.getImageCount());
		assertEquals("082617-86", study.getAccessionNumber());
		assertEquals("RAD-750", study.getAlternateExamNumber());
		assertTrue(study.isStudyInNewDataStructure());

		/*
		Set<Series> series = study.getSeries();
		Iterator<Series> iter = series.iterator();
		while(iter.hasNext()){
			Series serie = (Series)iter.next();
			assertEquals("40", serie.getSeriesIen());
			assertEquals("ECG", serie.getModality());
			assertTrue(serie.isSeriesInNewDataStructure());
			
			
			Iterator<Image> iter2 = serie.iterator();
			while(iter2.hasNext()){
				Image image = (Image)iter2.next();
				assertEquals("1.3.6.1.4.1.5962.99.1.2008199502.727436826.1505246785870.8.0", image.getImageUid());
				assertEquals("29", image.getIen());
				assertEquals("\\\\54.235.72.148\\IMAGE1$\\500\\00\\00\\00\\00\\00\\00\\500_00000000000031.dcm", image.getFullFilename());
				assertEquals("\\\\54.235.72.148\\WORMOTG$\\500\\00\\00\\00\\00\\00\\00\\500_00000000000031.jpg", image.getAbsFilename());
				assertTrue(image.isImageInNewDataStructure());
			}
		}
		
	}
	**/
	
	public void testParse_RPC_MAGN_PATIENT_IMAGE_LIST_1() 
	throws VistaParsingException, URNFormatException
	{	
		PatientIdentifier patient = PatientIdentifier.icnPatientIdentifier("800012234V737373737");
		Site site = new SLCSite();
		StudyFilter filter = new StudyFilter();

		StringBuffer buffer = new StringBuffer();
		buffer.append("1\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.442.6949397.8664.1.60205.171|\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.442.6949397.8664.1.60205.171\r\n");
		buffer.append("STUDY_IEN|264187|2|264188|71020|994\r\n");
		buffer.append("STUDY_INFO|^^   ^06/02/2005 13:35^RAD CR^^CHEST 2 VIEWS PA&LAT^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED RADIOGRAPHY^VA^06/02/2005 13:51:45^^264187^^^^060205-171|RAD-178791|RPT^CPRS^7169791^RA^i6949397.8664-1^171\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|PATIENT,LUCIA A\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_IEN|264187\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|264188\r\n");
		buffer.append("GROUP_IEN|264187\r\n");
		buffer.append("IMAGE_INFO|^264188^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\41\\CHY00000264188.TGA^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\41\\CHY00000264188.ABS^CHEST 2 VIEWS PA&LAT (#1)^3050602.1335^3^CR^06/02/2005 13:35^^M^A^^^1^1^CHY^^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\41\\CHY00000264188.BIG^7169791^IPOAASEN,LUCIA A^CLIN^06/02/2005 13:51:45^^264187^^^^0^1^1^0^^1^Image is Viewable.^RAD^\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.442.7009097.8443.1.90299.147|\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.442.7009097.8443.1.90299.147\r\n");
		buffer.append("STUDY_IEN|264249|2|264250|71020|994\r\n");
		buffer.append("STUDY_INFO|^^   ^09/02/1999 15:56^RAD CR^^CHEST 2 VIEWS PA&LAT^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED RADIOGRAPHY^VA^06/02/2005 14:31:49^^264249^^^^090299-147|RAD-109746|RPT^CPRS^7169791^RA^i7009097.8443-1^147\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|PATIENT,LUCIA A\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_IEN|264249\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|264250\r\n");
		buffer.append("GROUP_IEN|264249\r\n");
		buffer.append("IMAGE_INFO|^264250^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\42\\CHY00000264250.TGA^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\42\\CHY00000264250.ABS^CHEST 2 VIEWS PA&LAT (#1)^2990902.1556^3^CR^09/02/1999 15:56^^M^A^^^1^1^CHY^^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\42\\CHY00000264250.BIG^7169791^IPOAASEN,LUCIA A^CLIN^06/02/2005 14:31:49^^264249^^^^0^1^1^0^^1^Image is Viewable.^RAD^\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.994.6829376.8767.1.62317.36|NEW\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.994.6829376.8767.1.62317.36\r\n");
		buffer.append("STUDY_IEN|3|1\r\n");
		buffer.append("STUDY_INFO|^^^06/23/2017 12:10^^Specials~NeuroPCT (Adult)^^RAD^^^^^VA^06/23/2017 12:10^^^^^^062317-36|RAD-287429|RPT^CPRS^7169791^RA^i6829376.8767-1^36\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|PATIENT,LUCIA A\r\n");
		buffer.append("STUDY_MODALITY|\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.387.1857.1502813667272.20.3.2.501\r\n");
		buffer.append("SERIES_IEN|4\r\n");
		buffer.append("SERIES_MODALITY|SR\r\n");
		buffer.append("SERIES_NUMBER|501\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|4\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.3870048200.1857158264.1502813667272.21.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|4^^^^^IMAGE^^^^^^^^^^^^^^^^03/26/2009 09:35:48^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|7\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|7\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170815.133338\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20170815.133407\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000007.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|8\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|8\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170815.133407\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000008.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.994.6819696.8557.1.30318.55|NEW\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.994.6819696.8557.1.30318.55\r\n");
		buffer.append("STUDY_IEN|10|3\r\n");
		buffer.append("STUDY_INFO|^^^03/03/2018 12:42^^Axial MS brain with flair,t2 and pre/post contrast^^RAD^^^^^VA^03/03/2018 12:42^^^^^^030318-55|RAD-287446|RPT^CPRS^7169791^RA^i6819696.8557-1^55\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|PATIENT,LUCIA A\r\n");
		buffer.append("STUDY_MODALITY|\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.399.1980.1520117330169.18.3.5007.1\r\n");
		buffer.append("SERIES_IEN|17\r\n");
		buffer.append("SERIES_MODALITY|MR\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|21\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.3993841913.1980141043.1520117330169.21.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|21^^^^^IMAGE^^^^^^^^^^^^^^^^12/19/2006 00:00:14^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|57\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|41\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.12562\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20180304.125706\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000041.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|62\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|41\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125711\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000041.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGEJB2$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|60\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|44\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125707\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000044.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|66\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|44\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125718\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000044.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGEJB2$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.399.1980.1520117330169.18.3.5010.2\r\n");
		buffer.append("SERIES_IEN|18\r\n");
		buffer.append("SERIES_MODALITY|MR\r\n");
		buffer.append("SERIES_NUMBER|2\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|22\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.3993841913.1980141043.1520117330169.20.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|22^^^^^IMAGE^^^^^^^^^^^^^^^^12/19/2006 00:00:14^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|58\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|42\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125627\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20180304.125709\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000042.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|64\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|42\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125715\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000042.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGEJB2$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|61\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|45\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.12571\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000045.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|67\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|45\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125719\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000045.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGEJB2$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.399.1980.1520117330169.18.3.5010.1\r\n");
		buffer.append("SERIES_IEN|19\r\n");
		buffer.append("SERIES_MODALITY|MR\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|23\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.3993841913.1980141043.1520117330169.19.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|23^^^^^IMAGE^^^^^^^^^^^^^^^^12/19/2006 00:00:14^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|59\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|43\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125634\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20180304.125711\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000043.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|65\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|43\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125717\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000043.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGEJB2$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|63\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|46\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125712\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000046.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|68\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|46\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125719\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000046.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGEJB2$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		
		
		SortedSet<Study> studies = VistaImagingTranslator.createFilteredStudiesFromGraph(site, 
				buffer.toString(), StudyLoadLevel.STUDY_ONLY, filter, StudyDeletedImageState.doesNotIncludeDeletedImages);

		assertNotNull(studies);
		assertEquals(4, studies.size());
		Study study = (Study)studies.first();
		assertEquals("800012234V737373737", study.getPatientIdentifier().getValue());
	}
	
	public void testParse_RPC_MAGN_PATIENT_IMAGE_LIST_2() 
	throws VistaParsingException, URNFormatException
	{
		PatientIdentifier patient = PatientIdentifier.icnPatientIdentifier("800012234V737373737");
		Site site = new SLCSite();
		StudyFilter filter = new StudyFilter();

		StringBuffer buffer = new StringBuffer();
		buffer.append("1\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.442.6949397.8664.1.60205.171|\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.442.6949397.8664.1.60205.171\r\n");
		buffer.append("STUDY_IEN|264187|2|264188|71020|994\r\n");
		buffer.append("STUDY_INFO|^^   ^06/02/2005 13:35^RAD CR^^CHEST 2 VIEWS PA&LAT^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED RADIOGRAPHY^VA^06/02/2005 13:51:45^^264187^^^^060205-171|RAD-178791|RPT^CPRS^7169791^RA^i6949397.8664-1^171\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|PATIENT,LUCIA A\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_IEN|264187\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|264188\r\n");
		buffer.append("GROUP_IEN|264187\r\n");
		buffer.append("IMAGE_INFO|^264188^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\41\\CHY00000264188.TGA^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\41\\CHY00000264188.ABS^CHEST 2 VIEWS PA&LAT (#1)^3050602.1335^3^CR^06/02/2005 13:35^^M^A^^^1^1^CHY^^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\41\\CHY00000264188.BIG^7169791^IPOAASEN,LUCIA A^CLIN^06/02/2005 13:51:45^^264187^^^^0^1^1^0^^1^Image is Viewable.^RAD^\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.442.7009097.8443.1.90299.147|\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.442.7009097.8443.1.90299.147\r\n");
		buffer.append("STUDY_IEN|264249|2|264250|71020|994\r\n");
		buffer.append("STUDY_INFO|^^   ^09/02/1999 15:56^RAD CR^^CHEST 2 VIEWS PA&LAT^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED RADIOGRAPHY^VA^06/02/2005 14:31:49^^264249^^^^090299-147|RAD-109746|RPT^CPRS^7169791^RA^i7009097.8443-1^147\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|PATIENT,LUCIA A\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_IEN|264249\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|264250\r\n");
		buffer.append("GROUP_IEN|264249\r\n");
		buffer.append("IMAGE_INFO|^264250^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\42\\CHY00000264250.TGA^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\42\\CHY00000264250.ABS^CHEST 2 VIEWS PA&LAT (#1)^2990902.1556^3^CR^09/02/1999 15:56^^M^A^^^1^1^CHY^^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\42\\CHY00000264250.BIG^7169791^IPOAASEN,LUCIA A^CLIN^06/02/2005 14:31:49^^264249^^^^0^1^1^0^^1^Image is Viewable.^RAD^\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.994.6829376.8767.1.62317.36|NEW\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.994.6829376.8767.1.62317.36\r\n");
		buffer.append("STUDY_IEN|3|1\r\n");
		buffer.append("STUDY_INFO|^^^06/23/2017 12:10^^Specials~NeuroPCT (Adult)^^RAD^^^^^VA^06/23/2017 12:10^^^^^^062317-36|RAD-287429|RPT^CPRS^7169791^RA^i6829376.8767-1^36\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|PATIENT,LUCIA A\r\n");
		buffer.append("STUDY_MODALITY|\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.387.1857.1502813667272.20.3.2.501\r\n");
		buffer.append("SERIES_IEN|4\r\n");
		buffer.append("SERIES_MODALITY|SR\r\n");
		buffer.append("SERIES_NUMBER|501\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|4\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.3870048200.1857158264.1502813667272.21.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|4^^^^^IMAGE^^^^^^^^^^^^^^^^03/26/2009 09:35:48^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|7\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|7\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170815.133338\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20170815.133407\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000007.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|8\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|8\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170815.133407\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000008.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.994.6819696.8557.1.30318.55|NEW\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.994.6819696.8557.1.30318.55\r\n");
		buffer.append("STUDY_IEN|10|3\r\n");
		buffer.append("STUDY_INFO|^^^03/03/2018 12:42^^Axial MS brain with flair,t2 and pre/post contrast^^RAD^^^^^VA^03/03/2018 12:42^^^^^^030318-55|RAD-287446|RPT^CPRS^7169791^RA^i6819696.8557-1^55\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|IPOAASEN,LUCIA A\r\n");
		buffer.append("STUDY_MODALITY|\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.399.1980.1520117330169.18.3.5007.1\r\n");
		buffer.append("SERIES_IEN|17\r\n");
		buffer.append("SERIES_MODALITY|MR\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|21\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.3993841913.1980141043.1520117330169.21.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|21^^^^^IMAGE^^^^^^^^^^^^^^^^12/19/2006 00:00:14^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.399.1980.1520117330169.18.3.5010.2\r\n");
		buffer.append("SERIES_IEN|18\r\n");
		buffer.append("SERIES_MODALITY|MR\r\n");
		buffer.append("SERIES_NUMBER|2\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|22\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.3993841913.1980141043.1520117330169.20.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|22^^^^^IMAGE^^^^^^^^^^^^^^^^12/19/2006 00:00:14^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|58\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|42\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125627\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20180304.125709\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000042.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|64\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|42\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125715\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000042.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGEJB2$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|61\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|45\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.12571\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000045.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|67\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|45\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125719\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000045.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGEJB2$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.399.1980.1520117330169.18.3.5010.1\r\n");
		buffer.append("SERIES_IEN|19\r\n");
		buffer.append("SERIES_MODALITY|MR\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|23\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.3993841913.1980141043.1520117330169.19.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|23^^^^^IMAGE^^^^^^^^^^^^^^^^12/19/2006 00:00:14^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|59\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|43\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125634\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20180304.125711\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000043.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|65\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|43\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125717\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000043.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGEJB2$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|63\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|46\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125712\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000046.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|68\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|46\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|2\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|JUKEBOX\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20180304.125719\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000046.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|8\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGEJB2$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		
		SortedSet<Study> studies = VistaImagingTranslator.createFilteredStudiesFromGraph(site, 
				buffer.toString(), StudyLoadLevel.STUDY_ONLY, filter, StudyDeletedImageState.doesNotIncludeDeletedImages);

		assertNotNull(studies);
		assertEquals(4, studies.size());
		Study study = (Study)studies.first();
		assertEquals("800012234V737373737", study.getPatientIdentifier().getValue());
	}

	
	public void testParse_RPC_MAGN_PATIENT_IMAGE_LIST_3() 
	throws VistaParsingException, URNFormatException
	{
		PatientIdentifier patient = PatientIdentifier.icnPatientIdentifier("800012234V737373737");
		Site site = new SLCSite();
		StudyFilter filter = new StudyFilter();

		StringBuffer buffer = new StringBuffer();
		buffer.append("1\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.442.6949397.8664.1.60205.171|\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.442.6949397.8664.1.60205.171\r\n");
		buffer.append("STUDY_IEN|264187|2|264188|71020|994\r\n");
		buffer.append("STUDY_INFO|^^   ^06/02/2005 13:35^RAD CR^^CHEST 2 VIEWS PA&LAT^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED RADIOGRAPHY^VA^06/02/2005 13:51:45^^264187^^^^060205-171|RAD-178791|RPT^CPRS^7169791^RA^i6949397.8664-1^171\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|PATIENT,LUCIA A\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_IEN|264187\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|264188\r\n");
		buffer.append("GROUP_IEN|264187\r\n");
		buffer.append("IMAGE_INFO|^264188^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\41\\CHY00000264188.TGA^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\41\\CHY00000264188.ABS^CHEST 2 VIEWS PA&LAT (#1)^3050602.1335^3^CR^06/02/2005 13:35^^M^A^^^1^1^CHY^^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\41\\CHY00000264188.BIG^7169791^IPOAASEN,LUCIA A^CLIN^06/02/2005 13:51:45^^264187^^^^0^1^1^0^^1^Image is Viewable.^RAD^\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.442.7009097.8443.1.90299.147|\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.442.7009097.8443.1.90299.147\r\n");
		buffer.append("STUDY_IEN|264249|2|264250|71020|994\r\n");
		buffer.append("STUDY_INFO|^^   ^09/02/1999 15:56^RAD CR^^CHEST 2 VIEWS PA&LAT^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED RADIOGRAPHY^VA^06/02/2005 14:31:49^^264249^^^^090299-147|RAD-109746|RPT^CPRS^7169791^RA^i7009097.8443-1^147\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|PATIENT,LUCIA A\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_IEN|264249\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|264250\r\n");
		buffer.append("GROUP_IEN|264249\r\n");
		buffer.append("IMAGE_INFO|^264250^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\42\\CHY00000264250.TGA^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\42\\CHY00000264250.ABS^CHEST 2 VIEWS PA&LAT (#1)^2990902.1556^3^CR^09/02/1999 15:56^^M^A^^^1^1^CHY^^\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\CHY0\\00\\00\\26\\42\\CHY00000264250.BIG^7169791^IPOAASEN,LUCIA A^CLIN^06/02/2005 14:31:49^^264249^^^^0^1^1^0^^1^Image is Viewable.^RAD^\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.994.6829376.8767.1.62317.36|NEW\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.994.6829376.8767.1.62317.36\r\n");
		buffer.append("STUDY_IEN|3|1\r\n");
		buffer.append("STUDY_INFO|^^^06/23/2017 12:10^^Specials~NeuroPCT (Adult)^^RAD^^^^^VA^06/23/2017 12:10^^^^^^062317-36|RAD-287429|RPT^CPRS^7169791^RA^i6829376.8767-1^36\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|PATIENT,LUCIA A\r\n");
		buffer.append("STUDY_MODALITY|\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.387.1857.1502813667272.20.3.2.501\r\n");
		buffer.append("SERIES_IEN|4\r\n");
		buffer.append("SERIES_MODALITY|SR\r\n");
		buffer.append("SERIES_NUMBER|501\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|4\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.3870048200.1857158264.1502813667272.21.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|4^^^^^IMAGE^^^^^^^^^^^^^^^^03/26/2009 09:35:48^^^^^^0^^^^^^^\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|7\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|7\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|DICOM\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170815.133338\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|20170815.133407\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000007.dcm\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_ARTIFACTINSTANCE\r\n");
		buffer.append("ARTIFACTINSTANCE_PK|8\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACT|8\r\n");
		buffer.append("ARTIFACTINSTANCE_ARTIFACTFORMAT|JPEG\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDER|1\r\n");
		buffer.append("ARTIFACTINSTANCE_STORAGEPROVIDERTYPE|RAID\r\n");
		buffer.append("ARTIFACTINSTANCE_CREATEDDATETIME|20170815.133407\r\n");
		buffer.append("ARTIFACTINSTANCE_LASTACCESSDATETIME|\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEREF|994_00000000000008.jpg\r\n");
		buffer.append("ARTIFACTINSTANCE_DISKVOLUME|1\r\n");
		buffer.append("ARTIFACTINSTANCE_PHYSICALREFERENCE|\\\\VAAUSIVEAPP80.AAC.DVA.VA.GOV\\IMAGE1$\\\r\n");
		buffer.append("ARTIFACTINSTANCE_FILEPATH|994\00\00\00\00\00\00\\r\n");
		buffer.append("NEXT_STUDY|1.2.840.113754.1.4.994.6819696.8557.1.30318.55|NEW\r\n");
		buffer.append("STUDY_UID|1.2.840.113754.1.4.994.6819696.8557.1.30318.55\r\n");
		buffer.append("STUDY_IEN|10|3\r\n");
		buffer.append("STUDY_INFO|^^^03/03/2018 12:42^^Axial MS brain with flair,t2 and pre/post contrast^^RAD^^^^^VA^03/03/2018 12:42^^^^^^030318-55|RAD-287446|RPT^CPRS^7169791^RA^i6819696.8557-1^55\r\n");
		buffer.append("STUDY_PAT|7169791|800012234V737373737|IPOAASEN,LUCIA A\r\n");
		buffer.append("STUDY_MODALITY|\r\n");
		buffer.append("NEXT_SERIES\r\n");
		buffer.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.399.1980.1520117330169.18.3.5007.1\r\n");
		buffer.append("SERIES_IEN|17\r\n");
		buffer.append("SERIES_MODALITY|MR\r\n");
		buffer.append("SERIES_NUMBER|1\r\n");
		buffer.append("SERIES_CLASS_INDEX|CLIN\r\n");
		buffer.append("SERIES_PROC/EVENT_INDEX|\r\n");
		buffer.append("SERIES_SPEC/SUBSPEC_INDEX|\r\n");
		buffer.append("NEXT_IMAGE\r\n");
		buffer.append("IMAGE_IEN|21\r\n");
		buffer.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.3993841913.1980141043.1520117330169.21.0\r\n");
		buffer.append("IMAGE_NUMBER|1\r\n");
		buffer.append("IMAGE_INFO|21^^^^^IMAGE^^^^^^^^^^^^^^^^12/19/2006 00:00:14^^^^^^0^^^^^^^\r\n");
		
		
		SortedSet<Study> studies = VistaImagingTranslator.createFilteredStudiesFromGraph(site, 
				buffer.toString(), StudyLoadLevel.STUDY_ONLY, filter, StudyDeletedImageState.doesNotIncludeDeletedImages);
		
		assertNotNull(studies);
		assertEquals(4, studies.size());
		Study study = (Study)studies.last();
		assertEquals("800012234V737373737", study.getPatientIdentifier().getValue());
		Iterator<Study> iter = studies.iterator();
		while(iter.hasNext()){
			Study temp = (Study)iter.next();
			if(temp.getStudyIen().equals("264187")){
				assertEquals(1, temp.getSeriesCount());
				assertEquals(2,temp.getImageCount());
				assertEquals("264187", temp.getGroupIen());
			}
			else if (temp.getStudyIen().equals("264249")){
				assertEquals(1,temp.getSeriesCount());
				assertEquals(2,temp.getImageCount());
				assertEquals("264249",temp.getGroupIen());
			}
			else if (temp.getStudyIen().equals("3")){
				assertEquals(1,temp.getSeriesCount());
				assertEquals(1,temp.getImageCount());
				assertEquals("1.2.840.113754.1.4.994.6829376.8767.1.62317.36", temp.getStudyUid());
			}
		}
	}
	
	
	public void testParse_RPC_MAGN_PATIENT_IMAGE_LIST_4() 
	throws VistaParsingException, URNFormatException
	{
		PatientIdentifier patient = PatientIdentifier.icnPatientIdentifier("10121V598061");
		Site site = new SLCSite();
		StudyFilter filter = new StudyFilter();

		StringBuffer sb = new StringBuffer();
		sb.append("1\r\n");
		sb.append("NEXT_CONTEXTID|RPT^CPRS^419^RA^6829273.8242-1|1|36\r\n");
		sb.append("NEXT_STUDY|1.3.6.1.4.1.5962.99.1.1081116502.943362196.1457075062614.445.0|\r\n");
		sb.append("STUDY_UID|1.3.6.1.4.1.5962.99.1.1081116502.943362196.1457075062614.445.0\r\n");
		sb.append("STUDY_IEN|10454|4|10455|77056|500|4\r\n");
		sb.append("STUDY_INFO|^^   ^07/26/2017 17:57^RAD MG^^MAMMOGRAM BILAT^RAD^CLIN^IMAGE^RADIOLOGY^MAMMOGRAPHY^VA^07/26/2017 18:02:44^^10454^^^^072617-84|RAD-745|RPT^CPRS^419^RA^6829273.8242-1\r\n");
		sb.append("STUDY_PAT|419|10121V598061|TWENTYONE,PATIENT\r\n");
		sb.append("NEXT_SERIES\r\n");
		sb.append("SERIES_UID|1.3.6.1.4.1.5962.99.1.1081116502.943362196.1457075062614.446.0\r\n");
		sb.append("SERIES_IEN|10454\r\n");
		sb.append("SERIES_MODALITY|MG\r\n");
		sb.append("SERIES_NUMBER|2213\r\n");
		sb.append("NEXT_IMAGE\r\n");
		sb.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.1081116502.943362196.1457075062614.444.0\r\n");
		sb.append("IMAGE_IEN|10457\r\n");
		sb.append("GROUP_IEN|10454\r\n");
		sb.append("IMAGE_NUMBER|11\r\n");
		sb.append("IMAGE_INFO|B2^10457^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010457.DCM^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010457.ABS^MAMMOGRAM BILAT (#3)^3170726.1757^100^MG^07/26/2017 17:57^^M^A^2213^11^1^1^PAN^^^419^TWENTYONE,PATIENT^CLIN^07/26/2017 18:02:52^11/17/2005 18:07:01^10454^^^^0^1^1^1^^1^Image is Viewable.^RAD^|500\r\n");
		sb.append("NEXT_IMAGE\r\n");
		sb.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.1081116502.943362196.1457075062614.448.0\r\n");
		sb.append("IMAGE_IEN|10456\r\n");
		sb.append("GROUP_IEN|10454\r\n");
		sb.append("IMAGE_NUMBER|12\r\n");
		sb.append("IMAGE_INFO|B2^10456^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010456.DCM^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010456.ABS^MAMMOGRAM BILAT (#2)^3170726.1757^100^MG^07/26/2017 17:57^^M^A^2213^12^1^1^PAN^^^419^TWENTYONE,PATIENT^CLIN^07/26/2017 18:02:49^11/17/2005 18:07:16^10454^^^^0^1^1^1^^1^Image is Viewable.^RAD^|500\r\n");
		sb.append("NEXT_IMAGE\r\n");
		sb.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.1081116502.943362196.1457075062614.450.0\r\n");
		sb.append("IMAGE_IEN|10458\r\n");
		sb.append("GROUP_IEN|10454\r\n");
		sb.append("IMAGE_NUMBER|13\r\n");
		sb.append("IMAGE_INFO|B2^10458^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010458.DCM^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010458.ABS^MAMMOGRAM BILAT (#4)^3170726.1757^100^MG^07/26/2017 17:57^^M^A^2213^13^1^1^PAN^^^419^TWENTYONE,PATIENT^CLIN^07/26/2017 18:02:56^11/17/2005 18:07:31^10454^^^^0^1^1^1^^1^Image is Viewable.^RAD^|500\r\n");
		sb.append("NEXT_IMAGE\r\n");
		sb.append("IMAGE_UID|1.3.6.1.4.1.5962.99.1.1081116502.943362196.1457075062614.452.0\r\n");
		sb.append("IMAGE_IEN|10455\r\n");
		sb.append("GROUP_IEN|10454\r\n");
		sb.append("IMAGE_NUMBER|14\r\n");
		sb.append("IMAGE_INFO|B2^10455^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010455.DCM^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\01\\04\\PAN00000010455.ABS^MAMMOGRAM BILAT (#1)^3170726.1757^100^MG^07/26/2017 17:57^^M^A^2213^14^1^1^PAN^^^419^TWENTYONE,PATIENT^CLIN^07/26/2017 18:02:45^11/17/2005 18:07:44^10454^^^^0^1^1^1^^1^Image is Viewable.^RAD^|500\r\n");
		sb.append("STUDY_MODALITY|MG\r\n");
		sb.append("NEXT_CONTEXTID|RPT^CPRS^419^TIU^12530|1|16\r\n");
		sb.append("NEXT_STUDY||5148\r\n");
		sb.append("STUDY_IEN|5148|2|5149||500|0\r\n");
		sb.append("STUDY_INFO|^^DERMATOLOGY NOTE^09/08/2016 20:52^NOTE^^DERMATOLOGY NOTE^NOTE^CLIN^IMAGE^DERMATOLOGY^PHOTOGRAPHY^VA^09/08/2016 20:52:30^RADTECH,FIFTYTWO^5148^^^^|TIU-12530|RPT^CPRS^419^TIU^12530\r\n");
		sb.append("STUDY_PAT|419|10121V598061|TWENTYONE,PATIENT\r\n");
		sb.append("NEXT_SERIES\r\n");
		sb.append("SERIES_IEN|5148\r\n");
		sb.append("SERIES_NUMBER|1\r\n");
		sb.append("NEXT_IMAGE\r\n");
		sb.append("IMAGE_IEN|5149\r\n");
		sb.append("GROUP_IEN|5148\r\n");
		sb.append("IMAGE_INFO|B2^5149^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\00\\51\\PAN00000005149.JPG^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\00\\51\\PAN00000005149.ABS^DERMATOLOGY NOTE^3160908.2052^1^NOTE^09/08/2016 20:52^^M^A^^^1^1^PAN^^^419^TWENTYONE,PATIENT^CLIN^09/08/2016 20:52:31^09/08/2016^5148^^^^0^1^1^1^1^1^Image is Viewable.^NOTE^|500\r\n");
		sb.append("NEXT_IMAGE\r\n");
		sb.append("IMAGE_IEN|5150\r\n");
		sb.append("GROUP_IEN|5148\r\n");
		sb.append("IMAGE_INFO|B2^5150^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\00\\51\\PAN00000005150.JPG^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\00\\51\\PAN00000005150.ABS^DERMATOLOGY NOTE^3160908.2052^1^NOTE^09/08/2016 20:52^^M^A^^^1^1^PAN^^^419^TWENTYONE,PATIENT^CLIN^09/08/2016 20:52:35^09/08/2016^5148^^^^0^1^1^1^1^1^Image is Viewable.^NOTE^|500");
		
		
		SortedSet<Study> studies = VistaImagingTranslator.createFilteredStudiesFromGraph(site, 
				sb.toString(), StudyLoadLevel.STUDY_ONLY_NOSERIES, filter, StudyDeletedImageState.doesNotIncludeDeletedImages);
		
		assertNotNull(studies);
		assertEquals(2, studies.size());
		Study study = (Study)studies.last();
		assertEquals("10121V598061", study.getPatientIdentifier().getValue());
		Iterator<Study> iter = studies.iterator();
		while(iter.hasNext()){
			Study temp = (Study)iter.next();
			if(temp.getStudyIen().equals("10454")){
				assertEquals(0, temp.getSeriesCount());
				assertEquals(4,temp.getImageCount());
				assertEquals("10454", temp.getGroupIen());
			}
			else if (temp.getStudyIen().equals("5148")){
				assertEquals(0,temp.getSeriesCount());
				assertEquals(2,temp.getImageCount());
				assertEquals("5148",temp.getGroupIen());
			}
		}
	}

}
