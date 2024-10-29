/**
 * 
 */
package gov.va.med.imaging.terminology;

import java.io.InputStream;
import java.net.URI;

/**
 * @author vhaiswbeckec
 *
 */
public class TestSnomedToVaSpecialtyTranslation
extends AbstractTranslationTest
{
	@Override
	protected CodingScheme getSourceScheme()
	{
		return CodingScheme.SNOMED;
	}
	
	@Override
	protected CodingScheme getDestinationScheme()
	{
		return CodingScheme.VASPECIALTY;
	}
	
	/**
	 * Return an InputStream containing a text file formatted as lines in the
	 * form: value=value
	 * 
	 * @return
	 */
	@Override
	protected InputStream getTestData()
	{
		return this.getClass().getClassLoader().getResourceAsStream("SnomedToVaSpecialtyTestData.txt");
	}
}
