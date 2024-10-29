/**
 * 
 */
package gov.va.med.imaging.terminology.properties;

import gov.va.med.imaging.terminology.CodingScheme;
import java.io.InputStream;

/**
 * 
 * @author vhaiswbeckec
 *
 */
public class SnomedToVaSpecialtyTranslationService
extends PropertyFileTranslationService
{
	private static final long serialVersionUID = 1L;
	public final static String propertiesFile = "SnomedToVaSpecialty.xml";
	
	/**
	 * 
	 */
	public SnomedToVaSpecialtyTranslationService()
	throws InstantiationException
	{
		super();
	}

	
	@Override
	public CodingScheme getDestinationCodingScheme()
	{
		return CodingScheme.VASPECIALTY;
	}

	@Override
	public CodingScheme getSourceCodingScheme()
	{
		return CodingScheme.SNOMED;
	}

	@Override
	protected InputStream getInputStream()
	{
		return null;
	}
	
	@Override
	protected InputStream getXmlInputStream()
	{
		InputStream inStream = this.getClass().getClassLoader().getResourceAsStream(propertiesFile);
		return inStream;
	}
}