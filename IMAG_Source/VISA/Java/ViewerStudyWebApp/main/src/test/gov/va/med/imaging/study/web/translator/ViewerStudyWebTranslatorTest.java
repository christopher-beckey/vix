package gov.va.med.imaging.study.web.translator;

import gov.va.med.imaging.study.web.rest.translator.ViewerStudyWebTranslator;
import junit.framework.TestCase;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class ViewerStudyWebTranslatorTest extends TestCase{

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void testCprsValidation() {
		
		String cprsId1 = "RPT^CPRS^419^RA^6838988.8441-1^72^CAMP MASTER^^^^^^1";
		String cprsId2 = "RPT^CPRS^419^TIU^6838988.8441-1^72^CAMP MASTER^^^^^^1";
		String cprsId3 = "RPT^CPRS^419^^6838988.8441-1^72^CAMP MASTER^^^^^^1";
		
		boolean isCprsId1Valid = ViewerStudyWebTranslator.isCprsIdentifierValid(cprsId1);
		boolean isCprsId2Valid = ViewerStudyWebTranslator.isCprsIdentifierValid(cprsId2);
		boolean isCprsId3Valid = ViewerStudyWebTranslator.isCprsIdentifierValid(cprsId3);
		
		assertTrue(isCprsId1Valid);
		assertTrue(isCprsId2Valid);
		assertFalse(isCprsId3Valid);
		
	}

}
