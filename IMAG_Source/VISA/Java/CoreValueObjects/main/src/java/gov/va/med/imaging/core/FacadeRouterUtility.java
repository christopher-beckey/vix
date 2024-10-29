/**
 * 
 */
package gov.va.med.imaging.core;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Map;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.FacadeRouter;


/**
 * Utility class to provide access to router facades without having to know the
 * router facade implementation name.
 * 
 * @author vhaiswbeckec
 *
 */
public class FacadeRouterUtility
{
	private static final Logger LOGGER = Logger.getLogger(FacadeRouterUtility.class);
	
	private FacadeRouterUtility(){}		// prevent creation
	
	private static Map<Class<?>, Object> routers = new java.util.HashMap<Class<?>, Object>();
	
	@SuppressWarnings("unchecked")
	public static <R extends FacadeRouter> R getFacadeRouter(Class<R> interfaceClass) 
	throws ClassNotFoundException, InstantiationException, IllegalAccessException, IllegalArgumentException, InvocationTargetException
	{
		synchronized(routers)
		{
			FacadeRouter cachedRouter = (FacadeRouter) routers.get(interfaceClass);
			if(cachedRouter != null)
				return (R)cachedRouter;
			
			String interfaceName = interfaceClass.getSimpleName();
			String packageName = interfaceClass.getPackage().getName();
			String implementationName = interfaceName + "Impl";
			String implementationClassName = packageName + "." + implementationName;
	
			// load the implementation class through the interface's class loader
			// else it probably will not find it
			Class<R> implementationClass = (Class<R>) Class.forName(implementationClassName, true, interfaceClass.getClassLoader());
			
			try
			{
				Method singletonAccessor = implementationClass.getMethod("getSingleton", (Class<?>[])null);
				
				// return the singleton accessor result (should be the singleton router facade
				R facadeRouter = (R)singletonAccessor.invoke(null, (Object[])null);
				if(facadeRouter == null)
					return null;
				
				routers.put(interfaceClass, facadeRouter);
				return facadeRouter;
			} 
			catch (SecurityException x)
			{
                LOGGER.error("FacadeRouterUtility.getFacadeRouter() --> The facade router implementation [{}] singleton accessor method is inaccessible.", implementationClassName);
				throw x;
			} 
			catch (NoSuchMethodException x)
			{
                LOGGER.warn("FacadeRouterUtility.getFacadeRouter() --> The facade router implementation [{}] has no singleton accessor method.  Creating an instance...", implementationClassName);
				R facadeRouter = (R)implementationClass.newInstance();
				if(facadeRouter == null)
					return null;
				
				routers.put(interfaceClass, facadeRouter);
				return facadeRouter;
			}
		}
	}
}
