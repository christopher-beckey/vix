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
public class TestVaSpecialtyToSnomedTranslation
extends AbstractTranslationTest
{
	@Override
	protected CodingScheme getSourceScheme()
	{
		return CodingScheme.VASPECIALTY;
	}
	
	@Override
	protected CodingScheme getDestinationScheme()
	{
		return CodingScheme.SNOMED;
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
		return this.getClass().getClassLoader().getResourceAsStream("VaSpecialtyToSnomedTestData.txt");
	}
}
