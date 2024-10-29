/**
 * 
 */
package gov.va.med.imaging.url.vista;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLStreamHandler;

/**
 * @author VHAISWBECKEC
 * 
 * This class is the protocol handler for the "vista" protocol.
 * 
 * "There is a single, stateless protocol handler object for each unique
 * protocol string ("http ","ftp ","file ","mailto ","cvs ", and so forth.) A
 * particular handler is delegated all responsibility for resource resolution of
 * all URLs with the corresponding protocol string. That is, all "http:"URL
 * objects are resolved using the HTTP protocol handler object, all "ftp:"URL
 * objects are resolved by the FTP protocol handler and so forth.
 * 
 * Physically, a protocol handler is a concrete subclass of the
 * java.net.URLStreamHandler class. The URL object stores a reference to its
 * corresponding URLStreamHandler internally during construction. The URL object
 * uses a cached factory object known as the URLStreamHandlerFactory to obtain
 * the reference to the appropriate URLStreamHandler. Figure 2 illustrates how a
 * URL object gets an initial reference to its URLStreamHandler during
 * construction.
 * 
 * One somewhat unconventional requirement of URLStreamHandler classes is that
 * the class name and even the package name have certain restrictions. You must
 * name the handler class Handler, as in the previous example. The package name
 * must include the protocol name as the last dot-separated token.
 * 
 * The java.protocol.handler.pkgs system property is a list of package name
 * prefixes used by the URLStreamHandlerFactory to resolve protocol names into
 * actual handler class names. For example, imagine this property has the value
 * com.develop.protocols. When asked to find a handler class for the
 * win32-registry: protocol, the URLStreamHandlerFactory concatenates the system
 * property value (com.develop.protocols) with the protocol name
 * (win32-registry") and the expected class name "Handler". The resultant
 * fully-qualified class name is com.develop.protocols.win32-registry.Handler,
 * and that's the class name the factory looks for on the classpath."
 * 
 * Quoted comments in this code are copied from:
 * @see http://java.sun.com/developer/onlineTraining/protocolhandlers/
 */
public class Handler extends URLStreamHandler
{
	public static final String protocolScheme = "vista";

	/**
	 * "The URL object delegates all implementation of resource resolution to
	 * the URLStreamHandler and its helper classes and objects. The
	 * URLStreamHandler is stateless. An executing application may ask it to
	 * resolve several URLs into resource streams, possibly even simultaneously.
	 * 
	 * The URLStreamHandler actually creates a secondary object, known as the
	 * URLConnection, to perform an individual resource resolution. So, if a
	 * URLStreamHandler is asked to simultaneously resource 20 different URL
	 * objects into stream, all the URLStreamHandler does is create 20 different
	 * URLConnection objects, one to handle each of the 20 requests."
	 * 
	 * @see java.net.URLStreamHandler#openConnection(java.net.URL)
	 */
	@Override
	protected URLConnection openConnection(URL url) 
	throws IOException
	{
		if (url == null)
			throw new MalformedURLException("Null URL passed to VistaStreamHandler.openConnection()");

		if (url.getProtocol() == null)
			throw new MalformedURLException(url.toExternalForm() + "is not a valid URL, no protocol was specified");

		if (url.getHost() == null)
			throw new MalformedURLException(url.toExternalForm() + "is not a valid URL, no host was specified");

		if (!protocolScheme.equals(url.getProtocol()))
			throw new MalformedURLException(
				url.toExternalForm() + "is not a valid URL, protocol '" + url.getProtocol() + 
				"' is not supported by the vista protocol handler.");

		return new VistaConnection(url);
	}

	@Override
	protected int getDefaultPort()
	{
		return VistaConnection.DEFAULT_PORT;
	}
}
