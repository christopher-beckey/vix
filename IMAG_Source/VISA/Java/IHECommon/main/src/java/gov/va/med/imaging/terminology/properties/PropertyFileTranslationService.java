package gov.va.med.imaging.terminology.properties;

import gov.va.med.imaging.terminology.ClassifiedValue;
import gov.va.med.imaging.terminology.SchemeTranslationSPI;
import java.io.IOException;
import java.io.InputStream;
import java.util.InvalidPropertiesFormatException;
import java.util.Properties;
import gov.va.med.logging.Logger;

/**
 *
 */
abstract class PropertyFileTranslationService
extends Properties
implements SchemeTranslationSPI
{
	private static final long serialVersionUID = 1L;

	private final static Logger LOGGER = Logger.getLogger(PropertyFileSchemeTranslationProvider.class);
	
	/**
	 * 
	 * @throws InstantiationException
	 */
	PropertyFileTranslationService() 
	throws InstantiationException
	{
		InputStream inStream = null;
		try
		{
			inStream = getXmlInputStream();
			if(inStream != null)
				this.loadFromXML(inStream);
			else
			{
				inStream = getInputStream();
				
				if(inStream != null)
					this.load(inStream);
				else
				{
					String msg = "PropertyFileTranslationService() --> Derived class [" + this.getClass().getSimpleName() + "] does not return an input stream for initialization.";
					LOGGER.error(msg);
					throw new java.lang.InstantiationException(msg);
				}
			}
		}
		catch (InvalidPropertiesFormatException x)
		{
			String msg = "PropertyFileTranslationService() --> Derived class [" + this.getClass().getSimpleName() + "] references a properties file in an invalid format.";
			LOGGER.error(msg);
			throw new java.lang.InstantiationException(msg);
		}
		catch (IOException x)
		{
			String msg = "PropertyFileTranslationService() --> Derived class [" + this.getClass().getSimpleName() + "] references a properties file that is inaccessible.";
			LOGGER.error(msg);
			throw new java.lang.InstantiationException(msg);
		} finally {
			if (inStream != null) {
				try {
					inStream.close();
				} catch (Exception e) {
					// Ignore
				}
			}
		}
	}
	
	protected abstract InputStream getInputStream();
	protected abstract InputStream getXmlInputStream();

	@Override
	public ClassifiedValue[] translate(String sourceCode)
	{
		String rawTranslatedValue = this.getProperty(sourceCode);
        LOGGER.debug("PropertyFileTranslationService.translate() --> Translate from source code [{}] to [{}]", sourceCode, rawTranslatedValue);
		
		if(rawTranslatedValue == null)
			return new ClassifiedValue[]{new ClassifiedValue(getSourceCodingScheme(), sourceCode)};
		else
		{
			// if the mapping is one to many, then the values will be comma delimited
			String [] translatedValues = rawTranslatedValue.split(",");
			
			ClassifiedValue[] result = new ClassifiedValue[translatedValues.length];
			
			for(int index = 0; index<translatedValues.length; ++index)
				result[index] = new ClassifiedValue(getDestinationCodingScheme(), translatedValues[index]);
			
			return result;
		}
	}
}