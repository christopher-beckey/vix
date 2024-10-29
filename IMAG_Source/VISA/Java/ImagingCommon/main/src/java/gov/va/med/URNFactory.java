/**
 * 
 */
package gov.va.med;

import gov.va.med.imaging.exceptions.URNFormatException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.*;
import gov.va.med.logging.Logger;

/**
 * @author vhaiswbeckec
 * 
 * ========================================================================================================================
 * create() methods can be divided along three dimensions:
 * 1.) Whether the stringified URN is in URNComponents form or String form
 * 2.) Whether the create should handle casting
 * 3.) Whether the serialization format is assumed or explicitly stated
 * 
 * The organization of the create() methods works like this:
 * 1.) A create() taking stringified URNS, parses the URN and then delegates to a create() method
 *     with the same argument list, except URNComponents is substituted for the String
 * 2.) A create() method that specifies an expected type will delegate to a create() method with 
 *     the same argument list, except the expected type, then will dynamically cast the result and return
 * 3.) A create() method that does not take a serialization format will delegate to a create() method
 *     with the same arguments, except with the SERIALIZATION_FORMAT parameter added.
 *     
 * All registered URN classes (the ones that this class creates instances of) must:
 * 1.) implement a public static create(URNComponents, SERIALIZATION_FORMAT) method
 * 2.) implement a public toString(SERIALIZATION_FORMAT) method
 * 3.) implement a toString() method equivalent to toString(SERIALIZATION_FORMAT.RFC2141)
 * 4.) the create(URNComponents, SERIALIZATION_FORMAT) and the toString(SERIALIZATION_FORMAT) must be implemented such that:
 *     URNFactory.create( urn.toString(s), s ).equals(urn)
 *     where urn is of any registered URN type
 *     and s is any value of type SERIALIZATION_FORMAT
 */
public class URNFactory
{
	private static final Logger LOGGER = Logger.getLogger(URNFactory.class);

	// a URN class must implement: 
	// public static <T extends URN> T create(URNComponents, SERIALIZATION_FORMAT)
	// public static String getManagedNamespace();
	protected static final String FACTORY_METHOD_NAME = "create";
	private static final String TOSTRING_METHOD_NAME = "toString";
	
	private static final Class<?>[] FACTORY_METHOD_PARAMETERS = new Class[]{URNComponents.class, SERIALIZATION_FORMAT.class};
	private static final Class<?>[] TOSTRING_METHOD_PARAMETERS = new Class[]{SERIALIZATION_FORMAT.class};

	protected static Map<NamespaceIdentifier, Class<? extends URN>> urnClasses = 
		Collections.synchronizedMap(new HashMap<NamespaceIdentifier, Class<? extends URN>>());

	// Register all of the urn derived classes that we know of.
	// Registered classes can be created by this class based on 
	// their namespace identifiers.
	static
	{
		// JMW 6/30/2011 P122 - now load the URN classes using a provider pattern.
		// This allows URNs to be included/excluded from VISA implementations but they can be
		// registered with this single URNFactory
		ServiceLoader<URNProvider> serviceLoader = ServiceLoader.load(URNProvider.class);
		
		for(URNProvider urnProvider : serviceLoader)
		{
			Class<? extends URN> [] urnClasses = urnProvider.getUrnClasses();
			
			for(Class<? extends URN> urnClass : urnClasses)
			{
				registerUrnClass(urnClass);
			}
		}		
	}

	/**
	 * Register a class as a URN class, this makes the class available to
	 * the create() method of this class so that it can make instances of the 
	 * registered class.
	 * 
	 * @param urnClass
	 */
	protected static void registerUrnClass(Class<? extends URN> urnClass)
	{
		URNType urnType = urnClass.getAnnotation(URNType.class);
		NamespaceIdentifier namespace = null;
		boolean requiredFactoryExists = false;
		boolean requiredToStringExists = false;
		
		if(urnType == null)
            LOGGER.error("URNFactory.registerUrnClass() --> Unable to register URN class [{}] because the required annotation 'URNType' did not exist.", urnClass.getName());
		else
			namespace = new NamespaceIdentifier(urnType.namespace());
		
		try
		{
			// if the static create does not exist then the class is not a valid URN
			Method factory = urnClass.getMethod("create", FACTORY_METHOD_PARAMETERS);
			
			if( Modifier.isStatic(factory.getModifiers()) & Modifier.isPublic(factory.getModifiers()) )
				requiredFactoryExists = true;
		}
		catch (Exception x)
		{
            LOGGER.warn("URNFactory.registerUrnClass() --> Unable to register URN class [{}] because the factory method 'public {} create (URNComponents, SERIALIZATION_FORMAT)' does not exist: [{}]", urnClass.getName(), urnClass.getSimpleName(), x.getMessage());
		}

		try
		{
			// if the toString(SERIALIZATION_FORMAT) does not exist then the class is not a valid URN
			Method toString = urnClass.getMethod(TOSTRING_METHOD_NAME, TOSTRING_METHOD_PARAMETERS);
			
			if( !Modifier.isStatic(toString.getModifiers()) && Modifier.isPublic(toString.getModifiers()) )
				requiredToStringExists = true;
			else
                LOGGER.warn("URNFactory.registerUrnClass() --> The method public toString(SERIALIZATION_FORMAT) does not exist for class [{}]", urnClass.getName());
		}
		catch (Exception x)
		{
            LOGGER.warn("URNFactory.registerUrnClass() --> Unable to register URN class [{}] because the factory method 'public {} create (URNComponents, SERIALIZATION_FORMAT)' does not exist: {}", urnClass.getName(), urnClass.getSimpleName(), x.getMessage());
		}
		
		if(namespace != null && requiredFactoryExists && requiredToStringExists)
		{
			urnClasses.put(namespace, urnClass);
            LOGGER.info("URNFactory.registerUrnClass() --> URN class [{}] is now registered with URNFactory with the namespace [{}]", urnClass.getName(), namespace);
		}
	}
	
	// ========================================================================================================================
	// create() methods
	// These can be divided along three dimensions:
	// 1.) Whether the stringified URN is in URNComponents form or String form
	// 2.) Whether the create should handle casting
	// 3.) Whether the serialization format is assumed or explicitly stated
	// 
	// ========================================================================================================================
	
	/**
	 * Create an instance of a URN, validating that it is of the expected type.
	 * This version of create will not throw a ClassCastException if the type
	 * of URN created is not that expected, instead it will throw a URNFormatException
	 * wrapped around the ClassCastException.
	 * 
	 * @param <T>
	 * @param urnAsString
	 * @param expectedClass
	 * @return
	 * @throws URNFormatException
	 */
	public static <T extends URN> T create(String urnAsString, Class<T> expectedClass) 
	throws URNFormatException
	{
		try
		{
			return expectedClass.cast(create(urnAsString));
		}
		catch (ClassCastException ccX)
		{
			String msg = "URNFactory.create() --> Unable to cast created URN by [" + urnAsString + "] to [" + expectedClass.getSimpleName() + ": " + ccX.getMessage();
			LOGGER.error(msg);
			throw new URNFormatException(msg, ccX);
		}
		catch(URNFormatException ux)
		{
			String msg = "URNFactory.create() --> Unable to create URN using [" + urnAsString + "]: " + ux.getMessage();
			LOGGER.error(msg);
			throw ux;			
		}
	}

	/**
	 * ALL of the variations on the create() method taking the URN as a String MUST eventually 
	 * call this create() method to construct the URNs.
	 * 
	 * @param <T>
	 * @param urnAsString
	 * @param base32Decode
	 * @return
	 * @throws URNFormatException
	 */
	@SuppressWarnings("unchecked")
	public static <T extends URN> T create(String urnAsString) 
	throws URNFormatException
	{
		return (T)create(URNComponents.parse(urnAsString));
	}


	/**
	 * A factory method to create any kind of registered URN given the
	 * URN component parts.  This method should be used to replace calls to 
	 * class-specific create methods taking the same parameters.
	 * 
	 * @param namespaceIdentifier
	 * @param namespaceSpecificString
	 * @param additionalIdentifiers
	 * @return
	 * @throws URNFormatException
	 */
	@SuppressWarnings("unchecked")
	public <T extends URN> T create(NamespaceIdentifier namespaceIdentifier, String namespaceSpecificString, Class<T> expectedClass)
	throws URNFormatException
	{
		try
		{
			return expectedClass.cast((T)create(URNComponents.create(namespaceIdentifier, namespaceSpecificString)));
		}
		catch (ClassCastException ccX)
		{
			String msg = "URNFactory.create(1) --> Unable to cast created URN by [" + namespaceIdentifier + ":" + namespaceSpecificString + "] to [" + expectedClass.getSimpleName() + ": " + ccX.getMessage();
			LOGGER.error(msg);
			throw new URNFormatException(msg, ccX);
		}
		catch(URNFormatException ux)
		{
			String msg = "URNFactory.create(1) --> Unable to create URN from [" + namespaceIdentifier + ":" + namespaceSpecificString + "]: " + ux.getMessage();
			LOGGER.error(msg);
			throw ux;			
		}
	}

	/**
	 * 
	 * @param <T>
	 * @param urnComponents
	 * @param base32Decode
	 * @return
	 * @throws URNFormatException
	 */
	@SuppressWarnings( "unchecked" )
	private static <T extends URN> T create(URNComponents urnComponents)
	throws URNFormatException
	{
		Class<? extends URN> registeredClass = getRegisteredUrnClass(urnComponents.getNamespaceIdentifier());
		
		return registeredClass == null ? (T)(new URN(urnComponents, SERIALIZATION_FORMAT.NATIVE))
									   : (T)create(registeredClass, FACTORY_METHOD_NAME, FACTORY_METHOD_PARAMETERS, new Object[]{urnComponents, SERIALIZATION_FORMAT.NATIVE});
	}
	
	@SuppressWarnings( "unchecked" )
	public static <T extends URN> T create(String urnAsString, SERIALIZATION_FORMAT serializationFormat, Class<T> expectedClass)
	throws URNFormatException
	{
		try
		{
			return expectedClass.cast((T)create(urnAsString, serializationFormat));
		}
		catch (ClassCastException ccX)
		{
			String msg = "URNFactory.create(2) --> Unable to cast URN created by [" + urnAsString + "] to [" + expectedClass.getSimpleName() + ": " + ccX.getMessage();
			LOGGER.error(msg);
			throw new URNFormatException(msg, ccX);
		}
		catch(URNFormatException ux)
		{
			String msg = "URNFactory.create(2) --> Unable to create URN from [" + urnAsString + "]: " + ux.getMessage();
			LOGGER.error(msg);
			throw ux;			
		}
	}
	
	@SuppressWarnings("unchecked")
	public static <T extends URN> T create(String urnAsString, SERIALIZATION_FORMAT serializationFormat)
	throws URNFormatException
	{
		return (T) create(URNComponents.parse(urnAsString, serializationFormat), serializationFormat);
	}
	
	@SuppressWarnings("unchecked")
	public static <T extends URN> T create(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat, Class<T> expectedClass)
	throws URNFormatException
	{
		try
		{
			return expectedClass.cast((T) create(urnComponents, serializationFormat));
		}
		catch (ClassCastException ccX)
		{
			String msg = "URNFactory.create(3) --> Unable to cast URN created by [" + urnComponents + "] to [" + expectedClass.getSimpleName() + ": " + ccX.getMessage();
			LOGGER.error(msg);
			throw new URNFormatException(msg, ccX);
		}
		catch(URNFormatException ux)
		{
			String msg = "URNFactory.create(3) --> Unable to create URN from [" + urnComponents + "]: " + ux.getMessage();
			LOGGER.error(msg);
			throw ux;			
		}
	}
	
	/**
	 * @param <T>
	 * @param urnComponents
	 * @param serializationFormat
	 * @return
	 * @throws URNFormatException
	 */
	@SuppressWarnings("unchecked")
	public static <T extends URN> T create(URNComponents urnComponents,	SERIALIZATION_FORMAT serializationFormat)
	throws URNFormatException
	{
		Class<? extends URN> registeredClass = getRegisteredUrnClass(urnComponents.getNamespaceIdentifier());

		return registeredClass == null ? (T) (new URN(urnComponents, serializationFormat))
									   : (T) create(registeredClass, FACTORY_METHOD_NAME, FACTORY_METHOD_PARAMETERS, new Object[]{urnComponents, serializationFormat});
	}
	
	/**
	 * Generic "create" that all other creates call.
	 * Tries to create an instance of a URN by first finding and calling a create()
	 * factory method and then a constructor if the factory method does not exist.
	 * The parameter types and parameters are the same for both the factory method
	 * and for the constructor.
	 * 
	 * @param <T>
	 * @return
	 * @throws URNFormatException 
	 */
	@SuppressWarnings( "unchecked" )
	protected static <T extends URN> T create(Class<? extends URN> registeredClass, String createMethodName, Class<?>[] parameterTypes,	Object[] parameters) 
	throws URNFormatException
	{
		assert(parameterTypes.length == parameters.length);
		
		// build a string used to identify the URN we are creating for logging
		String msgIdentifier = buildMessageIdentifier(parameterTypes, parameters);
		
		try
		{
			// Try to find and use a create method in the registered class,
			// if none is available then use a constructor directly.
			// This construct allows registered classes to create instances
			// of derived classes rather than creating the registered class.
			try
			{
				Method factoryMethod = registeredClass.getDeclaredMethod(createMethodName, parameterTypes);
				T urn = (T)( factoryMethod.invoke(null, parameters) );
                LOGGER.trace("Creating URN from parameters [{}, created [{}] using factory method.", msgIdentifier, urn.toString());
				return urn;
			}
			catch (NoSuchMethodException x)
			{
				// no create method, call the constructor directly
				Constructor<? extends URN> urnConstructor = registeredClass.getConstructor(parameterTypes);
				T urn = (T)( urnConstructor.newInstance(parameters) );
                LOGGER.trace("Creating URN from parameters {}, created [{}] using constructor.", msgIdentifier, urn.toString());
				return urn;
			}
		}
		catch (ClassCastException x)
		{
			String msg = "URNFactory.create(4) --> Unable to cast created URN of class [" + registeredClass.getName() + 
				"] from " + msgIdentifier + ": " + x.getMessage();
			LOGGER.error(msg);
			throw new URNFormatException(msg, x);
		}
		catch (NoSuchMethodException x)
		{
			String msg = "URNFactory.create(4) --> Registered URN class [" + registeredClass.getName() + 
				"] does not implement a constructor in the form [" + registeredClass.getSimpleName() + 
				createClassnameString(parameterTypes) + "]";
			LOGGER.error(msg);
			throw new URNFormatException(msg, x);
		}
		catch (SecurityException sX)
		{
			String msg = "URNFactory.create(4) --> Registered URN class [" + registeredClass.getName() + 
				"] has the required constructor but it is inaccessible.";
			LOGGER.error(msg);
			throw new URNFormatException(msg, sX);
		}
		catch (InvocationTargetException itX)
		{
			String msg = 
				"URNFactory.create(4) --> Registered URN class [" + registeredClass.getName() + 
				"] has the required constructor but invoking it failed.";
			LOGGER.error(msg);
			if(itX.getCause() instanceof URNFormatException)
				throw (URNFormatException)itX.getCause();
			else
				throw new URNFormatException(msg, itX );
		}
		catch (Exception x)
		{
			String msg = "URNFactory.create(4) --> Registered URN class [" + registeredClass.getName() + 
					"] has the required constructor but invoking it failed with exception [" + x.getClass().getSimpleName() + "]";
			LOGGER.error(msg);
			throw new URNFormatException(msg, x);
		}
	}

	/**
	 * @param parameterTypes
	 * @return
	 */
	private static String createClassnameString(Class<?>[] parameterTypes)
	{
		StringBuilder sb = new StringBuilder();
		
		for(int i = 0; parameterTypes != null && i<parameterTypes.length; ++i)
			sb.append( i > 0 ? "," + parameterTypes[i].getSimpleName() : parameterTypes[i].getSimpleName() );
		
		return sb.toString();
	}

	/**
	 * Build a string to use in error reporting
	 * 
	 * @param parameterTypes
	 * @param parameters
	 * @return
	 */
	private static String buildMessageIdentifier(Class<?>[] parameterTypes, Object[] parameters)
	{
		// build a string to use in error reporting
		StringBuilder sbMsgIdentifier = new StringBuilder();
		
		for(int index = 0; index < parameterTypes.length; ++index)
		{
			if(index != 0)
				sbMsgIdentifier.append(",");
			sbMsgIdentifier.append("[");
			sbMsgIdentifier.append(parameterTypes[index] == null ? "<null>" : parameterTypes[index].getSimpleName());
			sbMsgIdentifier.append("]='");
			sbMsgIdentifier.append(parameterTypes[index] == null ? "<null>" : parameterTypes[index].toString());
			sbMsgIdentifier.append("]");
		}
		
		return sbMsgIdentifier.toString();
	}
	
	/**
	 * Returns true if the class is registered as a URN class with the URNFactory.
	 * 
	 * @param clazz
	 * @return
	 */
	public static boolean isRegisteredUrnClass(Class<? extends URN> clazz)
	{
		return urnClasses.containsValue(clazz);
	}
	
	/**
	 * 
	 * @param namespaceIdentifier
	 * @return
	 */
	private static Class<? extends URN> getRegisteredUrnClass(NamespaceIdentifier namespaceIdentifier)
	{
		return namespaceIdentifier == null ? null : urnClasses.get(namespaceIdentifier);
	}
}
