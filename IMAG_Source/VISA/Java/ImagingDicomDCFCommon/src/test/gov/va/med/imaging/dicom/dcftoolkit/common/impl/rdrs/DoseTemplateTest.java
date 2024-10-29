package gov.va.med.imaging.dicom.dcftoolkit.common.impl.rdrs;


import gov.va.med.imaging.dicom.dcftoolkit.common.impl.rdsr.DoseTemplate;
import junit.framework.TestCase;

import org.junit.Test;

public class DoseTemplateTest extends TestCase {

	@Test
	public void testMeanCTDIVolConversionOne() {
		DoseTemplate template = new DoseTemplate();
		String valueWithUnits = "51.70|mGy";
		String desiredUnits = "mGy";
		String result = template.getNumericValueInSpecifiedUnits(valueWithUnits, desiredUnits);
		assertEquals("51.7", result);
	}

	@Test
	public void testDLPConversionOne() {
		DoseTemplate template = new DoseTemplate();
		String valueWithUnits = "1266.90|mGycm";
		String desiredUnits = "mGycm";
		String result = template.getNumericValueInSpecifiedUnits(valueWithUnits, desiredUnits);
		assertEquals("1266.9", result);
	}
	@Test
	public void testDAPConversionOne() {
		DoseTemplate template = new DoseTemplate();
		String valueWithUnits = "0.00000138|Gym2";
		String desiredUnits = "Gycm2";
		String result = template.getNumericValueInSpecifiedUnits(valueWithUnits, desiredUnits);
		assertEquals("0.0138", result);
	}
	@Test
	public void testDAPConversionTwo() {
		DoseTemplate template = new DoseTemplate();
		String valueWithUnits = "0.00000138|Gy.m2";
		String desiredUnits = "Gycm2";
		String result = template.getNumericValueInSpecifiedUnits(valueWithUnits, desiredUnits);
		assertEquals("0.0138", result);
	}
	@Test
	public void testDAPConversionThree() {
		DoseTemplate template = new DoseTemplate();
		String valueWithUnits = "0.00000117|Gym2";
		String desiredUnits = "Gycm2";
		String result = template.getNumericValueInSpecifiedUnits(valueWithUnits, desiredUnits);
		assertEquals("0.0117", result);
	}
	@Test
	public void testDAPConversionFour() {
		DoseTemplate template = new DoseTemplate();
		String valueWithUnits = "0.00000022900|Gy.m2";
		String desiredUnits = "Gycm2";
		String result = template.getNumericValueInSpecifiedUnits(valueWithUnits, desiredUnits);
		assertEquals("0.00229", result);
	}
	@Test
	public void testDAPConversionFive() {
		DoseTemplate template = new DoseTemplate();
		String valueWithUnits = "2.113e-006|Gym2";
		String desiredUnits = "Gycm2";
		String result = template.getNumericValueInSpecifiedUnits(valueWithUnits, desiredUnits);
		assertEquals("0.02113", result);
	}
	@Test
	public void testDAPConversionSix() {
		DoseTemplate template = new DoseTemplate();
		String valueWithUnits = "2.113e-003|mGym2";
		String desiredUnits = "Gycm2";
		String result = template.getNumericValueInSpecifiedUnits(valueWithUnits, desiredUnits);
		assertEquals("0.02113", result);
	}
	@Test
	public void testDAPConversionSeven() {
		DoseTemplate template = new DoseTemplate();
		String valueWithUnits = "0.00022900|mGycm2";
		String desiredUnits = "Gycm2";
		String result = template.getNumericValueInSpecifiedUnits(valueWithUnits, desiredUnits);
		assertEquals("0.000000229", result);
	}
	@Test
	public void testDoseTotalConversionOne() {
		DoseTemplate template = new DoseTemplate();
		String valueWithUnits = "0|Gy";
		String desiredUnits = "mGy";
		String result = template.getNumericValueInSpecifiedUnits(valueWithUnits, desiredUnits);
		assertEquals("0", result);
	}
	@Test
	public void testDoseTotalConversionTwo() {
		DoseTemplate template = new DoseTemplate();
		String valueWithUnits = "20.6|Gy";
		String desiredUnits = "mGy";
		String result = template.getNumericValueInSpecifiedUnits(valueWithUnits, desiredUnits);
		assertEquals("20600", result);
	}

}
