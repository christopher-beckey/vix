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
public class SnomedToVaProcedureTranslationService
extends PropertyFileTranslationService
{
	private static final long serialVersionUID = 1L;
	public final static String propertiesFile = "SnomedToVaProcedure.xml";
	
	/**
	 * 
	 */
	public SnomedToVaProcedureTranslationService()
	throws InstantiationException
	{
		super();
	}

	
	@Override
	public CodingScheme getDestinationCodingScheme()
	{
		return CodingScheme.VAPROCEDURE;
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
		return this.getClass().getClassLoader().getResourceAsStream(propertiesFile);
	}
}