/**
 * 
 */
package gov.va.med.imaging.terminology;

import gov.va.med.imaging.ihe.exceptions.TranslationException;
import gov.va.med.imaging.terminology.ClassifiedValue;
import gov.va.med.imaging.terminology.CodingScheme;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class TestSchemeTranslationServiceFactory
extends TestCase
{
	@Override
	protected void setUp() throws Exception
	{
		super.setUp();
	}

	public void testClassifiedValueTranslation() 
	throws TranslationException
	{
		SchemeTranslationServiceFactory factory = SchemeTranslationServiceFactory.getFactory();
		SchemeTranslationSPI schemeTranslator = null;
		ClassifiedValue[] translatedValue = null;
		
		// translate a value that is mapped, the result should be in the destination coding scheme
		schemeTranslator = factory.getSchemeTranslator(CodingScheme.VADOCUMENTCLASS, CodingScheme.MHS);
		assertNotNull(schemeTranslator);
		translatedValue = schemeTranslator.translate("INSURANCE FORM");
		assertNotNull(translatedValue);
		assertEquals( CodingScheme.MHS, translatedValue[0].getCodingScheme() );
		
		// translate a value that is NOT mapped, the result should be in the source coding scheme
		schemeTranslator = factory.getSchemeTranslator(CodingScheme.VADOCUMENTCLASS, CodingScheme.LOINC);
		assertNotNull(schemeTranslator);
		translatedValue = schemeTranslator.translate("6");
		assertEquals( CodingScheme.VADOCUMENTCLASS, translatedValue[0].getCodingScheme() );
		
		// translate a value that is mapped, the result should be in the destination coding scheme
		schemeTranslator = factory.getSchemeTranslator(CodingScheme.VADOCUMENTCLASS, CodingScheme.LOINC);
		assertNotNull(schemeTranslator);
		translatedValue = schemeTranslator.translate("PATIENT RIGHTS AND RESPONSIBILITIES");
		assertNotNull(translatedValue);
		assertEquals( CodingScheme.LOINC, translatedValue[0].getCodingScheme() );
		
		// translate a value that is NOT mapped, the result should be in the source coding scheme
		schemeTranslator = factory.getSchemeTranslator(CodingScheme.VADOCUMENTCLASS, CodingScheme.MHS);
		assertNotNull(schemeTranslator);
		translatedValue = schemeTranslator.translate("Yata Yata Yata");
		assertEquals( CodingScheme.VADOCUMENTCLASS, translatedValue[0].getCodingScheme() );
	}
}
