/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 6, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.clinicaldisplay;

import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

import org.junit.Test;
import static org.junit.Assert.fail;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ValidateRouterCommands 
{
	
	@Test
	public void testCommands()
	{
		try
		{
			GeneratedCodeValidationUtility.validateCommandsExist(ClinicalDisplayRouterTest.class);
		}
		catch(ValidationException vX)
		{
			fail(vX.getMessage());
		}
		/*
	
		Class<?> routerTesterClass = ClinicalDisplayRouterTest.class;				
		Constructor<?> constructor = routerTesterClass.getConstructor(new Class<?> [0]);
		Object routerTesterInstance = constructor.newInstance(new Object[0]);
		
	 	Method [] methods = routerTesterClass.getMethods();
	 	for(Method method : methods)
	 	{
	 		// only test methods from this interface (not methods derived from)
	 		if(method.getDeclaringClass().equals(ClinicalDisplayRouterTest.class))
	 		{
		 		System.out.println("Executing method '" + method.getName() + "'.");
		 		Class<?>[] parameterTypes = method.getParameterTypes();
		 		Object[] parameters = new Object[parameterTypes.length];
		 		for(int i = 0; i < parameterTypes.length; i++)
		 		{
		 			parameters[i] = null;
		 		}
		 		method.invoke(routerTesterInstance, parameters);
	 		}
	 		
	 	}*/
	 	
		
	}

}
