/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 28, 2008
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
package gov.va.med.imaging.url.vftp;

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
		inStream = ClassLoader.getSystemResourceAsStream(handlerFactoryProperties);
		try {

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
