package gov.va.med.cache.rest;

import gov.va.med.cache.CacheManagementService;
import gov.va.med.cache.gui.server.ImagingCacheManagementServiceImpl;
import gov.va.med.cache.gui.shared.CACHE_POPULATION_DEPTH;
import gov.va.med.cache.gui.shared.CacheItemPath;
import gov.va.med.imaging.storage.cache.Cache;
import gov.va.med.imaging.storage.cache.Group;
import gov.va.med.imaging.storage.cache.Instance;
import gov.va.med.imaging.storage.cache.Region;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;

import java.io.IOException;

import javax.management.MBeanException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class CacheItemServlet 
extends HttpMethodHackServlet 
{
	private static final long serialVersionUID = 1L;
	private ImagingCacheManagementServiceImpl cacheManagement = null;
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	/**
	 * Constructor of the object.
	 */
	public CacheItemServlet() 
	{
		super();
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() 
	throws ServletException 
	{
		cacheManagement = new ImagingCacheManagementServiceImpl();
	}

	/**
	 * @see http://www.ietf.org/rfc/rfc2616.txt
	 * 
	 * "The HEAD method is identical to GET except that the server MUST NOT
	 * return a message-body in the response. The metainformation contained
	 * in the HTTP headers in response to a HEAD request SHOULD be identical
	 * to the information sent in response to a GET request. This method can
	 * be used for obtaining metainformation about the entity implied by the
	 * request without transferring the entity-body itself. This method is
	 * often used for testing hypertext links for validity, accessibility,
	 * and recent modification."
	 */
	@Override
	protected void doHead(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException 
	{
		CacheItemPath path = IdentifierUtility.create(req);
		
		try 
		{
			Cache cache = CacheManagementService.getCache(path.getCacheName());
			switch(path.getEndpointDepth())
			{
			case CACHE:
				resp.setContentType("application/xml");
				resp.addDateHeader("Last-Modified", System.currentTimeMillis());
				break;
			case REGION:
				resp.setContentType("application/xml");
				Region region = cache.getRegion(path.getRegionName());
				resp.addDateHeader("Last-Modified", System.currentTimeMillis());
				resp.addHeader("Content-Length", Long.toString(region.getUsedSpace()));
				break;
			case GROUP0:
			case GROUP1:
			case GROUP2:
			case GROUP3:
			case GROUP4:
			case GROUP5:
			case GROUP6:
			case GROUP7:
			case GROUP8:
			case GROUP9:
				resp.setContentType("application/xml");
				Group group = cache.getGroup(path.getRegionName(), path.getGroupNames());
				resp.addDateHeader("Last-Modified", group.getLastAccessed().getTime());
				resp.addHeader("Content-Length", Long.toString(group.getSize()));
				break;
			case INSTANCE:
				Instance instance = cache.getInstance(path.getRegionName(), path.getGroupNames(), path.getInstanceName());
				resp.addDateHeader("Last-Modified", instance.getLastAccessed().getTime());
				resp.addHeader("Content-Length", Long.toString(instance.getSize()));
				resp.addHeader("x-checksum", instance.getChecksumValue());
				resp.addHeader("x-persistent", Boolean.toString(instance.isPersistent()));
				resp.addHeader("Content-type", instance.getMediaType());
				break;
			}
		} 
		catch (MBeanException e) 
		{
			e.printStackTrace();
		} 
		catch (CacheException e) 
		{
			e.printStackTrace();
		}
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException 
	{
		CacheItemPath path = IdentifierUtility.create(req);
		
		try 
		{
			Cache cache = CacheManagementService.getCache(path.getCacheName());
		} 
		catch (MBeanException e) 
		{
			e.printStackTrace();
		} 
		catch (CacheException e) 
		{
			e.printStackTrace();
		}
	}

	/**
	 * The doDelete method of the servlet. <br>
	 *
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	@Override
	public void doDelete(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException 
	{
		CacheItemPath cacheItemPath = IdentifierUtility.create(request);
		
		logger.info("DeleteCacheItemServlet.doGet() enter");
		response.setContentType("text/html");
		response.addHeader("Cache-Control", "no-cache");
		response.addHeader("Pragma", "no-cache");
		
		if( cacheItemPath.getEndpointDepth().ordinal() < CACHE_POPULATION_DEPTH.GROUP0.ordinal() )
			throw new ServletException("Cache, region and at least one Group name must be specified to delete a cache item.");
		
		if(cacheItemPath.getInstanceName() != null)
			cacheManagement.deleteInstance(cacheItemPath);
		else
			cacheManagement.deleteGroup(cacheItemPath);

		response.setStatus(202);
		response.getWriter().write(CacheManagementService.buildQueryString(cacheItemPath.createParentPath()));
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() 
	{
		super.destroy(); 
	}
}
