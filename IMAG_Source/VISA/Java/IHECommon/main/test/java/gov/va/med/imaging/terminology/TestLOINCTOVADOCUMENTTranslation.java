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
public class TestLOINCTOVADOCUMENTTranslation
extends AbstractTranslationTest
{
	@Override
	protected CodingScheme getSourceScheme()
	{
		return CodingScheme.LOINC;
	}
	
	@Override
	protected CodingScheme getDestinationScheme()
	{
		return CodingScheme.VADOCUMENTCLASS;
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
		return this.getClass().getClassLoader().getResourceAsStream("LoincToVaDocumentTestData.txt");
	}
}
