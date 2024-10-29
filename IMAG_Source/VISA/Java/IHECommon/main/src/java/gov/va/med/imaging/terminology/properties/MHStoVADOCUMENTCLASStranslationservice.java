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
public class MHStoVADOCUMENTCLASStranslationservice
extends PropertyFileTranslationService
{
	private static final long serialVersionUID = 1L;
	public final static String propertiesFile = "MHStoVADOCUMENTCLASS.xml";
	
	@Override
	public CodingScheme getDestinationCodingScheme()
	{
		return CodingScheme.VADOCUMENTCLASS;
	}

	@Override
	public CodingScheme getSourceCodingScheme()
	{
		return CodingScheme.MHS;
	}

	/**
	 * 
	 */
	public MHStoVADOCUMENTCLASStranslationservice()
	throws InstantiationException
	{
		super();
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