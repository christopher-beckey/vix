package gov.va.med.imaging.storage.cache.impl.jmx;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Iterator;

import javax.management.*;

import gov.va.med.logging.Logger;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public abstract class AbstractCacheMBean
implements DynamicMBean
{
	private static final Logger LOGGER = Logger.getLogger(AbstractCacheMBean.class);
	
	private DateFormat dateFormat = new SimpleDateFormat("ddMMMyyyy hh:mm:ss");

	/**
	 * If this constructor is used then the managed object MUST be set
	 * before calling anything else in this class.
	 * If possible it is safer to use the AbstractCacheMBean(Object managedObject)
	 * constructor.
	 */
	protected AbstractCacheMBean() {}

	public abstract MBeanInfo getMBeanInfo();

	protected DateFormat getDateFormat()
	{
		return dateFormat;
	}
	
	/**
	 * 
	 */
	public Object getAttribute(String attribute) 
	throws AttributeNotFoundException, MBeanException, ReflectionException
	{
		if(attribute == null)
			throw new AttributeNotFoundException("AbstractCacheMBean.getAttribute(1) --> <null> attribute name not allowed.");
		
		MBeanAttributeInfo attributeInfo = getAttributeInfo(attribute);
		
		if(attributeInfo == null)
			throw new AttributeNotFoundException("AbstractCacheMBean.getAttribute(1) --> Attribute [" + attribute + "] is not defined in [" + this.getClass().getName() + "]");
		
		String getterName = createGetterName(attributeInfo.getName(), attributeInfo.isIs());
		
		return getAttribute(getterName, attributeInfo.getType(), this, this.getClass(), attributeInfo.isIs()); 
	}

	/**
	 * @param attributeInfo
	 * @param targetInstance
	 * @param targetClass
	 * @throws MBeanException 
	 */
	private Object getAttribute(String getterName, String returnClass, Object targetInstance, Class targetClass, boolean isIs) 
	throws MBeanException
	{
		Object retValue = null;
		try
		{
			Method getterMethod = targetClass.getMethod( getterName, (Class[])null);
			Object result = getterMethod.invoke(targetInstance, (Object[])null);
			
			Class returnType = Class.forName(returnClass);
			try
			{
				retValue = returnType.cast(result);
			} 
			catch (ClassCastException e)
			{
				if(returnType.equals(String.class))
					retValue = result.toString();
			}
			
			return retValue;
		} 
		catch(Exception e)
		{
            LOGGER.error("AbstractCacheMBean.getAttribute(2) --> Invoking attribute getter method [{}] on class [{}] resulted in error: {}", getterName, targetClass.getName(), e.getMessage());
			throw new MBeanException(e);
		}
		
	}

	/**
	 * 
	 */
	public AttributeList getAttributes(String[] attributes)
	{
		AttributeList attributeList = new AttributeList();
		
		for(String attribute: attributes)
		{
			try
			{
				attributeList.add(new Attribute(attribute, getAttribute(attribute)));
			} 
			catch (Exception e)
			{
                LOGGER.warn("AbstractCacheMBean.getAttributes() --> Encountered a problem: {}", e.getMessage());
			} 
		}
		return attributeList;
	}

	// ===========================================================================================
	// MBean setAttribute() Methods
	// ===========================================================================================
	/**
	 * 
	 */
	public void setAttribute(Attribute attribute) 
	throws AttributeNotFoundException, InvalidAttributeValueException, MBeanException, ReflectionException
	{
		if(attribute == null || attribute.getName() == null)
			throw new AttributeNotFoundException("AbstractCacheMBean.setAttribute(1) --> <null> attribute name not allowed.");
		
		String attributeName = attribute.getName();
		MBeanAttributeInfo attributeInfo = getAttributeInfo(attributeName);
		
		if(attributeInfo == null)
			throw new AttributeNotFoundException("AbstractCacheMBean.setAttribute(1) --> Attribute [" + attributeName + "] is not defined in [" + this.getClass().getName() + "]");
		
		String setterName = createSetterName(attributeInfo.getName());
        LOGGER.debug("AbstractCacheMBean.setAttribute(1) --> Setting attribute [{}] to value [{}]", attribute.getName(), attribute.getValue());
		setAttribute(setterName, attributeInfo.getType(), attribute.getValue(), this, this.getClass());
	}

	/**
	 * 
	 * @param setterName
	 * @param targetInstance
	 * @param targetClass
	 * @throws MBeanException
	 */
	private void setAttribute(String setterName, String attributeTypeName, Object value, Object targetInstance, Class targetClass) 
	throws MBeanException
	{
		try
		{
			Class attributeType = Class.forName(attributeTypeName); 
			Method setterMethod = targetClass.getMethod( setterName, new Class[]{attributeType});
			
			setterMethod.invoke(targetInstance, new Object[]{value});
		} 
		catch(Exception e)
		{
            LOGGER.error("AbstractCacheMBean.setAttribute(2) --> Invoking attribute getter method [{}] on class [{}] resulted in error: {}", setterName, targetClass.getName(), e.getMessage());
			throw new MBeanException(e);
		}	
	}
	
	/**
	 * 
	 */
	public AttributeList setAttributes(AttributeList attributes)
	{
		AttributeList resultingAttributes = new AttributeList();
		for(Iterator iter = attributes.iterator(); iter.hasNext(); )
		{
			try
			{
				Attribute attribute = (Attribute)iter.next(); 
				setAttribute( attribute );
				resultingAttributes.add(attribute);
			} 
			catch (Exception e)
			{
                LOGGER.warn("AbstractCacheMBean.setAttributes() --> Encountered a problem: {}", e.getMessage());
			} 
		}
		return resultingAttributes;
	}

	// ===========================================================================================
	// MBean Operations Methods
	// ===========================================================================================
	/**
	 * 
	 */
	public Object invoke(String actionName, Object[] params, String[] signature) 
	throws MBeanException, ReflectionException
	{
		MBeanOperationInfo operationInfo = getOperationInfo(actionName, params);
		if(operationInfo != null)
		{
			Class[] methodParameters = getParameterTypes(operationInfo);
			try
			{
				Method method = this.getClass().getMethod(operationInfo.getName(), methodParameters);
				Object retVal = method.invoke(this, params);
				
				return retVal;
			} 
			catch (SecurityException x)
			{
                LOGGER.warn("AbstractCacheMBean.invoke() --> Encountered security exception while attempting to call [{}]", actionName);
			} 
			catch (NoSuchMethodException x)
			{
                LOGGER.warn("AbstractCacheMBean.invoke() --> Encountered no such method exception while attempting to call [{}]", actionName);
			} 
			catch (IllegalArgumentException x)
			{
                LOGGER.warn("AbstractCacheMBean.invoke() --> Encountered illegal argument exception while attempting to call [{}]", actionName);
			} 
			catch (IllegalAccessException x)
			{
                LOGGER.warn("AbstractCacheMBean.invoke() --> Encountered illegal access exception while attempting to call [{}]", actionName);
			} 
			catch (InvocationTargetException x)
			{
                LOGGER.warn("AbstractCacheMBean.invoke() --> Encountered invocation target exception while attempting to call [{}]", actionName);
			}
		}
		return null;
	}

	// ===========================================================================================
	// Helper Methods
	// ===========================================================================================
	private String createGetterName(String attributeName, boolean isIs)
	{
		if(attributeName == null || attributeName.length() < 1)
			return null;
		
		return (isIs ? "is" : "get") + 
				Character.toUpperCase(attributeName.charAt(0)) + 
				attributeName.substring(1);
	}
	
	private String createSetterName(String attributeName)
	{
		if(attributeName == null || attributeName.length() < 1)
			return null;
		
		return "set" + Character.toUpperCase(attributeName.charAt(0)) + attributeName.substring(1);
	}
	
	private MBeanAttributeInfo getAttributeInfo(String attribute)
	{
		if(attribute == null)
			return null;
		
		for(MBeanAttributeInfo attributeInfo:getMBeanInfo().getAttributes())
		{
			if( attributeInfo.getName().equals(attribute) )
			{
                LOGGER.debug("AbstractCacheMBean.getAttributeInfo() --> Requested attribute [{}] found in managed list.", attribute);
				return attributeInfo;
			}
		}

        LOGGER.debug("AbstractCacheMBean.getAttributeInfo() --> Requested attribute [{}] NOT found in managed list.", attribute);
		return null;
	}
	
	private MBeanOperationInfo getOperationInfo(String operation, Object[] parameters)
	{
		if(operation == null)
			return null;
		
		for(MBeanOperationInfo operationInfo:getMBeanInfo().getOperations())
		{
			if( operationInfo.getName().equals(operation) )
			{
				MBeanParameterInfo[] parametersInfo = operationInfo.getSignature();
				int parametersIndex = 0;
				for(MBeanParameterInfo parameterInfo: parametersInfo)
				{
					if( ! parameterInfo.getClass().isAssignableFrom(parameters[parametersIndex].getClass()) )
						break;
					++parametersIndex;
				}
				
				if(parametersIndex >= operationInfo.getSignature().length )
				{
                    LOGGER.debug("AbstractCacheMBean.getOperationInfo() --> Requested operation [{}] found in managed list.", operation);
					return operationInfo;
				}
			}
		}

        LOGGER.debug("AbstractCacheMBean.getOperationInfo() --> Requested operation [{}] NOT found in managed list.", operation);
		return null;
	}
	
	/**
	 * Extract the parameter types (classes) from an MBeanOperationInfo instance
	 * to use in finding the actual method to call.
	 * 
	 * @param operationInfo
	 * @return
	 */
	private Class[] getParameterTypes(MBeanOperationInfo operationInfo)
	{
		Class[] retVal = new Class[operationInfo.getSignature().length];
		int parameterIndex = 0;
		for(MBeanParameterInfo parameter: operationInfo.getSignature() )
			retVal[parameterIndex++] = parameter.getClass();
		
		return retVal;
	}
}
