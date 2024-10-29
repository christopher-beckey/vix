/**
 * 
 */
package gov.va.med.imaging.terminology.properties;

import gov.va.med.imaging.terminology.CodingScheme;
import java.io.InputStream;


/**
 * This class is the inverse of the LoincToVaTranslationService,
 * which it subclasses.  This class simply does the lookups backwards,
 * i.e. from value to key rather than from key to value.
 * 
 * @author vhaiswbeckec
 *
 */
public class VADOCUMENTCLASStoLOINCtranslationservice
extends PropertyFileTranslationService
{
	private static final long serialVersionUID = 1L;
	public final static String propertiesFile = "VADOCUMENTCLASStoLOINC.xml";
	
	/**
	 * 
	 */
	public VADOCUMENTCLASStoLOINCtranslationservice()
	throws InstantiationException
	{
		super();
	}
	
	@Override
	public CodingScheme getDestinationCodingScheme()
	{
		return CodingScheme.LOINC;
	}

	@Override
	public CodingScheme getSourceCodingScheme()
	{
		return CodingScheme.VADOCUMENTCLASS;
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