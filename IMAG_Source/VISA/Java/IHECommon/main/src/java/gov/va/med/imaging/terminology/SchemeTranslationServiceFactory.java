/**
 * 
 */
package gov.va.med.imaging.terminology;

import gov.va.med.imaging.terminology.SchemeTranslationProvider.SchemeTranslationServiceMapping;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.ServiceLoader;
import gov.va.med.logging.Logger;

/**
 * @author vhaiswbeckec
 *
 */
public class SchemeTranslationServiceFactory
{
	private static SchemeTranslationServiceFactory singleton;
	private final static Logger LOGGER = Logger.getLogger(SchemeTranslationServiceFactory.class);
	
	public static synchronized SchemeTranslationServiceFactory getFactory()
	{
		return singleton = singleton != null ? singleton : new SchemeTranslationServiceFactory();
	}
	
	// ========================================================================
	private ServiceLoader<SchemeTranslationProvider> serviceLoader;

	private SchemeTranslationServiceFactory()
	{
		serviceLoader = ServiceLoader.load(SchemeTranslationProvider.class);
	}

	private ServiceLoader<SchemeTranslationProvider> getServiceLoader()
	{
		return this.serviceLoader;
	}
	
	private List<SchemeTranslationProvider.SchemeTranslationServiceMapping> availableServices; 
	
	private synchronized List<SchemeTranslationProvider.SchemeTranslationServiceMapping> getAvailableServices()
	{
		if(availableServices == null)
		{
			availableServices = new ArrayList<SchemeTranslationProvider.SchemeTranslationServiceMapping>();
			
			for(SchemeTranslationProvider provider : getServiceLoader() )
				availableServices.addAll( provider.getSchemeTranslationServiceMappings() );
		}
		
		return availableServices;
	}
	
	// ===============================================================================================
	// Various Factory Methods
	// ===============================================================================================
	
	/**
	 * 
	 * @param sourceScheme
	 * @param destinationScheme
	 * @return
	 */
	public SchemeTranslationSPI getSchemeTranslator(String sourceScheme, String destinationScheme)
	throws URISyntaxException
	{
		return getSchemeTranslator(null, new URI(sourceScheme), new URI(destinationScheme));
	}

	/**
	 * 
	 * @param manufacturer
	 * @param sourceScheme
	 * @param destinationScheme
	 * @return
	 * @throws URISyntaxException
	 */
	public SchemeTranslationSPI getSchemeTranslator(String manufacturer, String sourceScheme, String destinationScheme) 
	throws URISyntaxException
	{
		return getSchemeTranslator( manufacturer, new URI(sourceScheme), new URI(destinationScheme) );
	}
	
	/**
	 * 
	 * @param sourceScheme
	 * @param destinationScheme
	 * @return
	 */
	public SchemeTranslationSPI getSchemeTranslator(URI sourceScheme, URI destinationScheme) 
	{
		return getSchemeTranslator(null, sourceScheme, destinationScheme);
	}
	
	public SchemeTranslationSPI getSchemeTranslator(String manufacturer, URI sourceScheme, URI destinationScheme) 
	{
		if(sourceScheme == null)
		{
			LOGGER.warn("SchemeTranslationServiceFactory.getSchemeTranslator() --> Given source scheme URI is null. Return null.");
			return null;
		}
		if(destinationScheme == null)
		{
			LOGGER.warn("SchemeTranslationServiceFactory.getSchemeTranslator() --> Given destination scheme URI is null. Return null.");
			return null;
		}
		
		CodingScheme sourceCodingScheme = CodingScheme.valueOf(sourceScheme);
		CodingScheme destinationCodingScheme = CodingScheme.valueOf(destinationScheme);
		
		if(sourceCodingScheme == null)
		{
            LOGGER.warn("SchemeTranslationServiceFactory.getSchemeTranslator() --> Given source scheme URI [{}] does not map to a known coding scheme. Return null.", sourceCodingScheme);
			return null;
		}
		if(destinationCodingScheme == null)
		{
            LOGGER.warn("SchemeTranslationServiceFactory.getSchemeTranslator() --> Given source scheme URI [{}] does not map to a known coding scheme. Return null.", destinationCodingScheme);
			return null;
		}
		
		return getSchemeTranslator(manufacturer, sourceCodingScheme, destinationCodingScheme);
	}
	
	public SchemeTranslationSPI getSchemeTranslator(CodingScheme sourceScheme, CodingScheme destinationScheme) 
	{
		return getSchemeTranslator( null, sourceScheme, destinationScheme );
	}

	/**
	 * 
	 * @param manufacturer
	 * @param sourceScheme
	 * @param destinationScheme
	 * @return
	 * @throws URISyntaxException 
	 */
	public SchemeTranslationSPI getSchemeTranslator(String manufacturer, CodingScheme sourceScheme, CodingScheme destinationScheme)
	{
		if(sourceScheme == null)
		{
			LOGGER.warn("SchemeTranslationServiceFactory.getSchemeTranslator(1) --> Given source coding scheme is null. Return null.");
			return null;
		}
		if(destinationScheme == null)
		{
			LOGGER.warn("SchemeTranslationServiceFactory.getSchemeTranslator(1) --> Given destination coding scheme is null. Return null.");
			return null;
		}
		
		// IdentitySchemeTranslation just passes back what it is given
		if(sourceScheme.equals(destinationScheme))
		{
            LOGGER.info("SchemeTranslationServiceFactory.getSchemeTranslator(1) --> Manufacturer [{}], source coding scheme [{}], destination coding scheme [{}] is IDENTITY.", manufacturer, sourceScheme.toString(), destinationScheme.toString());
			return IdentitySchemeTranslation.create(sourceScheme);
		}
		
		for(SchemeTranslationServiceMapping serviceMapping : getAvailableServices() )
		{
			if( (manufacturer == null || manufacturer.equals(serviceMapping.getManufacturer())) &&
				sourceScheme.equals(serviceMapping.getSourceScheme()) && 
				destinationScheme.equals(serviceMapping.getDestinationScheme()) )
			{
				Class<? extends SchemeTranslationSPI> translationClass = serviceMapping.getTranslationClass();
				
				SchemeTranslationSPI translator = getOrCreateServiceInstance(translationClass);

                LOGGER.debug("SchemeTranslationServiceFactory.getSchemeTranslator(1) --> Manufacturer [{}], source coding scheme [{}], destination coding scheme [{}], translator [{}]", manufacturer, sourceScheme.toString(), destinationScheme.toString(), translator == null ? "NULL (failed to create or get)" : translator.getClass().getName());
							
				return translator;
			}
		}

        LOGGER.info("SchemeTranslationServiceFactory.getSchemeTranslator(1) --> Manufacturer [{}], source coding scheme [{}], destination coding scheme [{}]. No translator. Return null.", manufacturer, sourceScheme.toString(), destinationScheme.toString());
		return null;
	}
	
	private List<SchemeTranslationSPI> serviceCache = new ArrayList<SchemeTranslationSPI>();
	
	/**
	 * Get from the cache or create a new service instance (and cache it).
	 * 
	 * @param translationClass
	 * @return
	 */
	private SchemeTranslationSPI getOrCreateServiceInstance(Class<? extends SchemeTranslationSPI> translationClass)
	{
		if(translationClass == null)
			return null;
		
		synchronized (serviceCache)
		{
			for(SchemeTranslationSPI serviceInstance : serviceCache)
				if( translationClass.getCanonicalName().equals(serviceInstance.getClass().getCanonicalName()) )
						return serviceInstance;
			
			try
			{
				SchemeTranslationSPI newServiceInstance = translationClass.newInstance();
				serviceCache.add(newServiceInstance);
				return newServiceInstance;
			}
			catch (InstantiationException x)
			{
                LOGGER.warn("SchemeTranslationServiceFactory.getOrCreateServiceInstance() --> Return null --> InstantiationException: {}", x.getMessage());
				return null;
			}
			catch (IllegalAccessException x)
			{
                LOGGER.warn("SchemeTranslationServiceFactory.getOrCreateServiceInstance() --> Return null --> IllegalAccessException: {}", x.getMessage());
				return null;
			}
		}
	}
}
