/**
 * 
 */
package gov.va.med.imaging.url.mix;

import gov.va.med.imaging.url.mix.HandlerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLStreamHandler;
import java.net.URLStreamHandlerFactory;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

/**
 * @author VHAISWBECKEC
 *
 */
public class HandlerFactory 
implements URLStreamHandlerFactory
{
    // the configuration mapping
    private final static Map<String, String> handlerClassMapping;
    
    // the loaded (cached) handlers
    private final static Map<String, URLStreamHandler> handlerMap;
    
    static
    {
		handlerClassMapping = new HashMap<String, String>();
		String handlerFactoryProperties = HandlerFactory.class.getName() + ".properties";
		InputStream inStream = null;
		try {
			inStream = ClassLoader.getSystemResourceAsStream(handlerFactoryProperties);

			System.out.println(
					(inStream == null ? "Unable to read " : "Reading ") +
							"protocol handler factory properties from '" +
							handlerFactoryProperties + "'.");

			Properties handlerClassMappingProperties = new Properties();
			assert (inStream != null && handlerClassMappingProperties != null);

			try {
				handlerClassMappingProperties.load(inStream);
				for (Iterator<Map.Entry<Object, Object>> iter = handlerClassMappingProperties.entrySet().iterator();
					 iter.hasNext(); ) {
					Map.Entry<Object, Object> entry = iter.next();
					handlerClassMapping.put(entry.getKey().toString(), entry.getValue().toString());
				}
			} catch (IOException e) {
				e.printStackTrace();
			}

			handlerMap = new HashMap<String, URLStreamHandler>();
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
    
    public HandlerFactory()
    {
	super();
    }

    /* (non-Javadoc)
     * @see java.net.URLStreamHandlerFactory#createURLStreamHandler(java.lang.String)
     */
    @Override
    public URLStreamHandler createURLStreamHandler(String protocol)
    {
	synchronized (handlerMap)
	{
	    URLStreamHandler streamHandler = handlerMap.get(protocol);
	    if(streamHandler == null)
	    {
		String handlerClassName = handlerClassMapping.get(protocol);
		try
		{
		    Class<?> handlerClass = Class.forName(handlerClassName);
		    streamHandler = (URLStreamHandler)handlerClass.newInstance();
		    
		    handlerMap.put(protocol, streamHandler);
		} 
		catch (ClassNotFoundException e)
		{
		    e.printStackTrace();
		} 
		catch (InstantiationException e)
		{
		    e.printStackTrace();
		} 
		catch (IllegalAccessException e)
		{
		    e.printStackTrace();
		}
		catch (ClassCastException e)
		{
		    e.printStackTrace();
		}
	    }
	    
	    return streamHandler;
	}
    }

}
