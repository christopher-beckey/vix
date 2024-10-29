/**
 * 
 */
package gov.va.med.imaging.terminology.properties;

import gov.va.med.imaging.terminology.CodingScheme;
import java.io.InputStream;


/**
 * 
 * This class is the inverse of the SnomedToVaTranslationService,
 * which it subclasses.  This class simply does the lookups backwards,
 * i.e. from value to key rather than from key to value.
 * 
 * @author vhaiswbeckec
 *
 */
public class VaProcedureToSnomedTranslationService
extends PropertyFileTranslationService
{
	private static final long serialVersionUID = 1L;
	public final static String propertiesFile = "VaProcedureToSnomed.xml";
	
	/**
	 * 
	 */
	public VaProcedureToSnomedTranslationService()
	throws InstantiationException
	{
		super();
	}

	
	@Override
	public CodingScheme getDestinationCodingScheme()
	{
		return CodingScheme.SNOMED;
	}

	@Override
	public CodingScheme getSourceCodingScheme()
	{
		return CodingScheme.VAPROCEDURE;
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