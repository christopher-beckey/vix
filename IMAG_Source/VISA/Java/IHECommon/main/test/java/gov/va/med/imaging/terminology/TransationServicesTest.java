/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * @date Jul 14, 2010
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author vhaiswbeckec
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */

package gov.va.med.imaging.terminology;

import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class TransationServicesTest
	extends TestCase
{

	public void testLOINCtoVADOCUMENTCLASSTranslationServiceExistence()
	{
		SchemeTranslationServiceFactory factory = SchemeTranslationServiceFactory.getFactory();
		SchemeTranslationSPI schemeTranslator = factory.getSchemeTranslator(CodingScheme.LOINC, CodingScheme.VADOCUMENTCLASS);
		assertNotNull(schemeTranslator);
	}		
	
	public void testSNOMEDtoVAPROCEDURETranslationServiceExistence()
	{
		SchemeTranslationServiceFactory factory = SchemeTranslationServiceFactory.getFactory();
		SchemeTranslationSPI schemeTranslator = factory.getSchemeTranslator(CodingScheme.SNOMED, CodingScheme.VAPROCEDURE);
		assertNotNull(schemeTranslator);
	}		
	
	public void testSNOMEDtoVASPECIALTYTranslationServiceExistence()
	{
		SchemeTranslationServiceFactory factory = SchemeTranslationServiceFactory.getFactory();
		SchemeTranslationSPI schemeTranslator = factory.getSchemeTranslator(CodingScheme.SNOMED, CodingScheme.VASPECIALTY);
		assertNotNull(schemeTranslator);
	}		
	
	public void testVADOCUMENTCLASStoLOINCTranslationServiceExistence()
	{
		SchemeTranslationServiceFactory factory = SchemeTranslationServiceFactory.getFactory();
		SchemeTranslationSPI schemeTranslator = factory.getSchemeTranslator(CodingScheme.VADOCUMENTCLASS, CodingScheme.LOINC);
		assertNotNull(schemeTranslator);
	}		
	
	public void testVADOCUMENTCLASStoMHSTranslationServiceExistence()
	{
		SchemeTranslationServiceFactory factory = SchemeTranslationServiceFactory.getFactory();
		SchemeTranslationSPI schemeTranslator = factory.getSchemeTranslator(CodingScheme.VADOCUMENTCLASS, CodingScheme.MHS);
		assertNotNull(schemeTranslator);
	}		
	
	public void testVASPECIALTYtoSNOMEDTranslationServiceExistence()
	{
		SchemeTranslationServiceFactory factory = SchemeTranslationServiceFactory.getFactory();
		SchemeTranslationSPI schemeTranslator = factory.getSchemeTranslator(CodingScheme.VASPECIALTY, CodingScheme.SNOMED);
		assertNotNull(schemeTranslator);
	}
}
