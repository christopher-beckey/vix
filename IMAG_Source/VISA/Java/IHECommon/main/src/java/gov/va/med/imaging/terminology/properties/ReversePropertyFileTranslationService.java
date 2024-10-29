/**
 * 
 */
package gov.va.med.imaging.terminology.properties;

import gov.va.med.imaging.terminology.ClassifiedValue;
import java.io.InputStream;
import java.net.URI;
import java.util.Enumeration;
import java.util.Properties;
import gov.va.med.logging.Logger;

/**
 * When the translation from one coding scheme to another is symmetric then
 * this class may be used for the reverse mapping.  
 * That is:
 * for every value A in coding scheme 1 there is one and only one
 * value in coding scheme 2, to which the value may be mapped and
 * for every value B in coding scheme 2 there is one and only one
 * value in coding scheme 1, to which the value may be mapped
 * 
 * e.g. 
 * VADOCUMENTClass.54->LOINC.18842-5
 * -and-
 * LOINC.18842-5->VADOCUMENTClass.54
 * 
 * The simple one-to-one symmetric mapping applies for all values in 
 * LOINC and VADOCUMENT.
 * 
 * @author vhaiswbeckec
 *
 */
public abstract class ReversePropertyFileTranslationService
extends PropertyFileTranslationService
{
	private Logger logger = Logger.getLogger(ReversePropertyFileTranslationService.class);
	

	/**
	 * @throws InstantiationException
	 */
	public ReversePropertyFileTranslationService()
	throws InstantiationException
	{
		super();
	}

	private Properties reverseMapping;
	private synchronized Properties getReverseMapping()
	{
		if(reverseMapping == null)
		{
			reverseMapping = new Properties();
			for( Enumeration<?> keyEnum = this.keys(); keyEnum != null && keyEnum.hasMoreElements(); )
			{
				// note the reverse of key and value in the next two lines is intentional
				Object value = keyEnum.nextElement();
				Object key = this.get(value);
				reverseMapping.put(key, value);
			}
		}
		
		return reverseMapping;
	}
	
	@Override
	public ClassifiedValue[] translate(String sourceCode)
	{
		String rawTranslatedValue = getReverseMapping().getProperty(sourceCode);
        logger.info("Translating '{}' => '{}'.", sourceCode, rawTranslatedValue);
		
		if(rawTranslatedValue == null)
			return new ClassifiedValue[]{new ClassifiedValue(getSourceCodingScheme(), sourceCode)};
		else
		{
			// if the mapping is one to many, then the values will be comma delimited
			String[] translatedValues = rawTranslatedValue.split(",");
			ClassifiedValue[] result = new ClassifiedValue[translatedValues.length];
			
			for(int index=0; index<translatedValues.length; ++index)
				result[index] = 
					new ClassifiedValue(getDestinationCodingScheme(), translatedValues[index]);
			
			return result;
		}
	}
	
}
