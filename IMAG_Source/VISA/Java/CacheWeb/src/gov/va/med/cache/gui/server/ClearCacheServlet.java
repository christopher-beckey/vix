/**
 * 
 */
package gov.va.med.cache.gui.server;

import gov.va.med.imaging.storage.cache.Cache;
import gov.va.med.imaging.storage.cache.CacheManager;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
import gov.va.med.imaging.storage.cache.impl.CacheManagerImpl;

import java.io.IOException;

import javax.management.MBeanException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * @author VHAISWBECKEC
 *
 */
public class ClearCacheServlet 
extends HttpServlet 
{
	private static final long serialVersionUID = 1L;
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	private static final String CACHE_ERROR_MESSAGE = 
		"I can feel my mind going Keith ... would you like to hear a song?";
	private final static String GENERIC_PISSY_MESSAGE = 
		"An exception occurred 'cause you didn't provide a cache name."
		+ "... and if you think I'm telling you how to specify the cache name then you've just "
		+ "got another thing comin' there bubba.  This is highly technical stuff here and not for "
		+ "mere casual users.  So, if you don't know to put the cache name as the extra path info "
		+ "then that is just too bad.   Oh yeah, the capitalization better be right too!";
	
	private final static String LESS_GENERIC_PISSY_MESSAGE = 
		"You're getting warmer ..."
		+ "... try something like http://localhost:8080/CacheWeb/ClearCache/ImagingExchangeCache "
		+ " and then maybe I'll help you out.";

	private final static String SPECIFIC_PISSY_MESSAGE = 
		" is not a real cache name"
		+ "... try something like http://localhost:8080/CacheWeb/ClearCache/ImagingExchangeCache "
		+ " and then maybe I'll help you out.";

	/**
	 * 
	 */
	public ClearCacheServlet() { }

	/**
	 * Get the CacheManager implementation.  Log the hashCode of the cache manager so that we can assure that the
	 * instance used by this web app is the same instance as used by the applications.
	 * 
	 * @return
	 * @throws CacheException 
	 * @throws MBeanException 
	 */
	private CacheManager getCacheManager() 
	throws MBeanException, CacheException
	{
		CacheManager cacheManager = CacheManagerImpl.getSingleton();
		
		logger.info("CacheManager instance is "
			+ (cacheManager == null ? "NULL" : (cacheManager.getClass().getSimpleName() + "[" + cacheManager.hashCode() + "]")) 
		);
		
		return cacheManager;
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException 
	{
		String cacheName = req.getPathInfo();
		if(cacheName == null || cacheName.length() <= 1)
			throw new ServletException(GENERIC_PISSY_MESSAGE);
		cacheName = cacheName.substring(1);
		
		try 
		{
			Cache cache = getCacheManager().getCache(cacheName);
			if(cache == null)
				throw new ServletException(cacheName + SPECIFIC_PISSY_MESSAGE);
			cache.clear();
			RequestDispatcher rd = req.getRequestDispatcher("/ClearCacheSuccessful.jsp");
			rd.include(req, resp);
		} 
		catch(CacheException cX)
		{
			throw new ServletException(CACHE_ERROR_MESSAGE, cX);
		}
		catch (Exception e) 
		{
			throw new ServletException(LESS_GENERIC_PISSY_MESSAGE, e);
		}
	}
}
