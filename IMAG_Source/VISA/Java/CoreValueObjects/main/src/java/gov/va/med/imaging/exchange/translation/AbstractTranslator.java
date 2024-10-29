/**
 * 
 */
package gov.va.med.imaging.exchange.translation;

import gov.va.med.imaging.core.ObjectVocabulary;
import gov.va.med.imaging.exchange.translation.exceptions.MultipleTranslatorFoundException;
import gov.va.med.imaging.exchange.translation.exceptions.NoTranslatorFoundException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.regex.Pattern;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswbeckec
 *
 */
public class AbstractTranslator
{
	private static final String TRANSLATE_METHOD_REGEX = "translate[A-Za-z0-9]*";
	private static Pattern TRANSLATE_METHOD_PATTERN;
	
	private final static Logger LOGGER = Logger.getLogger(AbstractTranslator.class);
	
	static
	{
		TRANSLATE_METHOD_PATTERN = Pattern.compile(TRANSLATE_METHOD_REGEX);
	}
	
	/**
	 * The list of available translator classes
	 */
	private static List<Class<? extends AbstractTranslator>> translatorClasses = 
		new ArrayList<Class<? extends AbstractTranslator>>();
	
	protected static Logger getLogger()
	{
		return LOGGER;
	}
	
	public static void registerTranslatorClass( Class<? extends AbstractTranslator> translator)
	{
		synchronized (translatorClasses)
		{
			if( !validateTranslator(translator) )
				return;
			
			translatorClasses.add(translator);
		}
	}
	
	public static void deRegisterTranslatorClass( Class<? extends AbstractTranslator> translator)
	{
		translatorClasses.remove(translator);
	}

	/**
	 * 
	 * @return
	 */
	public static Iterator<Class<? extends AbstractTranslator>> registeredTranslatorsIterator()
	{
		return Collections.unmodifiableList(translatorClasses).iterator();
	}
	
	/**
	 * validate that the translator does not contain any member methods that may be confused
	 * with methods in the currently known translators
	 * 
	 * @param translator
	 * @return
	 */
	private static boolean validateTranslator(Class<? extends AbstractTranslator> translator)
	{
		for(Method method : translator.getMethods())
		{
			Class<?> returnType = method.getReturnType();
			Class<?>[] parameterTypes = method.getParameterTypes();
			if(returnType != Void.class && returnType != void.class && parameterTypes != null && parameterTypes.length == 1)
			{
				try
				{
					findTranslationMethod(returnType, parameterTypes);
					return false;
				}
				catch (NoTranslatorFoundException ntX)
				{
					// this is what should happen
				}
				catch (MultipleTranslatorFoundException mtX)
				{
                    LOGGER.warn("AbstractTranslator.validateTranslator(1) --> Return false. Exception: {}", mtX.getMessage());
					return false;
				}
				catch (TranslationException x)
				{
                    LOGGER.warn("AbstractTranslator.validateTranslator(2) --> Return false. Exception: {}", x.getMessage());
					return false;
				}
			}
		}
		
		return true;
	}

	/**
	 * By default, any method name that begins with "translate" will be considered
	 * when searching for a translation method. 
	 * @return
	 */
	protected static Pattern getMethodNamePattern()
	{
		return TRANSLATE_METHOD_PATTERN;
	}
	
	/**
	 * Look through the list of available translation classes for a method that will
	 * translate the source type to the destination type.
	 * The method MUST be a static method, taking one argument of type sourceClass and returning
	 * an instance of destinationClass.
	 * 
	 * @param sourceClass
	 * @param destinationClass
	 * @return
	 */
	public static Method findTranslationMethod(Class<?> destinationClass, Class<?>[] sourceClasses) 
	throws TranslationException
	{
		if(sourceClasses == null || sourceClasses.length == 0 || destinationClass == null)
			throw new NoTranslatorFoundException("AbstractTranslator.findTranslationMethod() --> Cannot translate to/from a null type.");
		
		List<Method> candidateMethods = new ArrayList<Method>();
		
		for(Class<?> translatorClass : translatorClasses)
		{
			int classModifiers = translatorClass.getModifiers();
			if( Modifier.isPublic(classModifiers) && !Modifier.isInterface(classModifiers) )
			{
				try
				{
					for(Method method : translatorClass.getDeclaredMethods())
					{
						Class<?>[] methodParameterTypes = method.getParameterTypes();
						if( isTranslatorMethod(method) && 
							isParameterListCompatible(methodParameterTypes, sourceClasses) )
						{
							Class<?> methodReturnType = method.getReturnType();
							if( methodReturnType.isAssignableFrom(destinationClass) )
								candidateMethods.add(method);
						}
					}
				}
				catch (SecurityException x)
				{
                    LOGGER.warn("AbstractTranslator.findTranslationMethod() --> SecurityException for regEx [" + TRANSLATE_METHOD_REGEX + "], method reference from [{}]", translatorClass.getName());
				}
			}
		}
		
		if(candidateMethods.size() == 0)
			throw new NoTranslatorFoundException(sourceClasses, destinationClass);
		
		if(candidateMethods.size() > 1)
			throw new MultipleTranslatorFoundException(sourceClasses, destinationClass, candidateMethods);
		
		return candidateMethods.get(0);
	}

	/**
	 * Determines if a method meets the following requirements:
	 * 1.) is declared public
	 * 2.) is declared static
	 * 3.) has a return type other than void or Void
	 * 4.) has at least one parameter
	 * 
	 * @param method
	 * @return
	 */
	public static boolean isTranslatorMethod(Method method)
	{
		String methodName = method.getName();
		
		if( getMethodNamePattern().matcher(methodName).matches() )
		{
			int modifiers = method.getModifiers();
			Class<?> returnType = method.getReturnType();
			Class<?>[] parameters = method.getParameterTypes();
			
			if( Modifier.isPublic(modifiers) && 
				Modifier.isStatic(modifiers) &&
				Void.class != returnType && void.class != returnType &&
				parameters.length > 0)
				return true;
		}
		
		return false;
	}
	
	/**
	 * For a Method to be a Business to Interface translator method it
	 * must:
	 * 1.) be a translator method (i.e. isTranslatorMethod(method) returns true)
	 * 2.) take one argument whose class is within a business package according to
	 *     the VIX semantics
	 * 3.) the result is a type that is not within the business packages according
	 *     to the VIX semantics
	 *     
	 * @param method
	 * @return
	 */
	public static boolean isBusinessToInterfaceMethod(Method method)
	{
		if(! isTranslatorMethod(method))
			return false;
		
		Class<?>[] parameterTypes = method.getParameterTypes();
		Class<?> resultType = method.getReturnType();

		int businessObjectsInParameterTypes = 0;
		
		for(Class<?> parameterType : parameterTypes)
			if(ObjectVocabulary.isObjectClass(parameterType))
				businessObjectsInParameterTypes++;
		
		return businessObjectsInParameterTypes > 0 && 
			!ObjectVocabulary.isObjectClass(resultType);
	}
	
	/**
	 * For a Method to be a Interface to Business translator method it
	 * must:
	 * 1.) be a translator method (i.e. isTranslatorMethod(method) returns true)
	 * 2.) take one argument whose class is not within a business package according to
	 *     the VIX semantics
	 * 3.) the result is a type that is within the business packages according
	 *     to the VIX semantics
	 *     
	 * @param method
	 * @return
	 */
	public static boolean isInterfaceToBusinessMethod(Method method)
	{
		if(! isTranslatorMethod(method))
			return false;
		
		Class<?>[] parameters = method.getParameterTypes();
		if( parameters.length != 1 )
			return false;
		
		Class<?> resultClass = method.getReturnType();
		
		return !ObjectVocabulary.isObjectClass(parameters[0]) && 
			ObjectVocabulary.isObjectClass(resultClass);
	}
	
	/**
	 * Return true iff the actual parameter types are assignment compatible
	 * with the expected parameter types.
	 * 
	 * @param methodParameterTypes
	 * @param sourceClasses
	 * @return
	 */
	private static boolean isParameterListCompatible(Class<?>[] actual, Class<?>[] expected)
	{
		if( (actual == null || actual.length == 0) && (expected == null || expected.length == 0) )
			return false;
		if( (actual == null && expected != null) || (actual != null && expected == null) )
			return false;
		if(actual.length != expected.length)
			return false;
		
		for(int index=0; index < actual.length; ++index)
			if( ! actual[index].isAssignableFrom(expected[index]) )
				return false;
		
		return true;
	}

	/**
	 * @param filter
	 * @return
	 * @throws TranslationException 
	 */
	@SuppressWarnings("unchecked")
	public static <D extends Object> D translate(Class<D> destinationClass, Object... source) 
	throws TranslationException
	{
		if(source == null || source.length == 0)
		{
			LOGGER.debug("AbstractTranslator.translate() --> Given source is null or empty.  Return null");
			return null;
		}
		
		Class<?>[] sourceClasses = new Class<?>[source.length];
		for(int index = 0; index < source.length; ++index)
		{
			if(source[index] == null)
			{
                LOGGER.debug("AbstractTranslator.translate() --> Given source is null at index [{}].  Can't convert to destination [{}].  Return null.", index, destinationClass.getSimpleName().toString());
				return null;
			}
			sourceClasses[index] = source[index].getClass();
		}
		
		Method translationMethod = AbstractTranslator.findTranslationMethod(destinationClass, sourceClasses);
		
		try
		{
			//Class<?> translatorClass = translationMethod.getDeclaringClass();
			return (D)( translationMethod.invoke(null, source) );
		}
		catch(Exception x)
		{
            LOGGER.debug("AbstractTranslator.translate() --> Exception: {}", x.getMessage());
			throw new TranslationException("AbstractTranslator.translate() --> Encountered Exception", x);
		}
	}

	public static TranslationMethods getAllTranslationMethods()
	{
		TranslationMethods translatorMethods = new TranslationMethods();
		
		for( Iterator<Class<? extends AbstractTranslator>> translatorIter = AbstractTranslator.registeredTranslatorsIterator();
			translatorIter.hasNext(); )
		{
			Class<? extends AbstractTranslator> translatorClass = translatorIter.next();
			
			for(Method method : translatorClass.getDeclaredMethods())
				if( AbstractTranslator.isTranslatorMethod(method) )
					translatorMethods.add(method);
		}
		
		return translatorMethods;
	}
	
	public static class TranslationMethods 
	extends HashSet<Method>
	{
		private static final long serialVersionUID = -8971053036829027744L;

		/**
		 * Return an unmodifiable Set of the Method instances within this
		 * Set that meet the criteria for a Business to Interface Translator
		 * method.
		 * 
		 * @return
		 */
		public Set<Method> businessToInterfaceMethods()
		{
			Set<Method> b2iMethods = new HashSet<Method>();
			
			for(Method method : this)
				if(isBusinessToInterfaceMethod(method))
					b2iMethods.add(method);
			
			return Collections.unmodifiableSet( b2iMethods );
		}

		/**
		 * Return an unmodifiable Set of the Method instances within this
		 * Set that meet the criteria for a Interface to Business Translator
		 * method.
		 * 
		 * @return
		 */
		public Set<Method> interfaceToBusinessMethods()
		{
			Set<Method> i2bMethods = new HashSet<Method>();
			
			for(Method method : this)
				if(isInterfaceToBusinessMethod(method))
					i2bMethods.add(method);
			
			return Collections.unmodifiableSet( i2bMethods );
		}
	}
}
