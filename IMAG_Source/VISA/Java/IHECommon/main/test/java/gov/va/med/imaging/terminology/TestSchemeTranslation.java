/**
 * 
 */
package gov.va.med.imaging.terminology;

import java.net.URISyntaxException;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class TestSchemeTranslation
extends TestCase
{
	private SchemeTranslationServiceFactory factory;
	
	@Override
	protected void setUp() 
	throws Exception
	{
		super.setUp();
		factory = SchemeTranslationServiceFactory.getFactory();
	}

	public void testInstalledTranslatorsPresence() 
	throws URISyntaxException
	{
		assertNotNull( 
			factory.getSchemeTranslator(CodingScheme.LOINC, CodingScheme.VADOCUMENTCLASS)
		);
		
		assertNotNull( 
			factory.getSchemeTranslator(CodingScheme.SNOMED, CodingScheme.VASPECIALTY)
		);
		assertNotNull( 
			factory.getSchemeTranslator(CodingScheme.VASPECIALTY, CodingScheme.SNOMED)
		);
		assertNotNull( 
			factory.getSchemeTranslator(CodingScheme.SNOMED, CodingScheme.VAPROCEDURE)
		);
		assertNotNull( 
			factory.getSchemeTranslator(CodingScheme.VAPROCEDURE, CodingScheme.SNOMED)
		);
			
		assertNotNull( 
			factory.getSchemeTranslator("VIProperties", CodingScheme.SNOMED, CodingScheme.VASPECIALTY)
		);
		assertNotNull( 
			factory.getSchemeTranslator("VIProperties", CodingScheme.VASPECIALTY, CodingScheme.SNOMED)
		);
		assertNotNull( 
			factory.getSchemeTranslator("VIProperties", CodingScheme.SNOMED, CodingScheme.VAPROCEDURE)
		);
		assertNotNull( 
			factory.getSchemeTranslator("VIProperties", CodingScheme.VAPROCEDURE, CodingScheme.SNOMED)
		);
	}
	
}
