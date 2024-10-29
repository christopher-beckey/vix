package gov.va.med.cache.gui.server;

import gov.va.med.cache.gui.shared.CacheItemPath;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class DeleteCacheItem 
extends HttpServlet 
{
	private static final long serialVersionUID = 1L;
	private ImagingCacheManagementServiceImpl imagingCache = null;
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	/**
	 * Constructor of the object.
	 */
	public DeleteCacheItem() 
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
		imagingCache = new ImagingCacheManagementServiceImpl();
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException 
	{

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println("  <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println("  <BODY>");

		deleteItem(request, response);
		
		out.println("  </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
	}

	/**
	 * 
	 * @param request
	 * @throws ServletException 
	 * @throws IOException 
	 */
	private void deleteItem(HttpServletRequest request, HttpServletResponse response) 
	throws ServletException, IOException 
	{
		String cacheName = request.getParameter("cache");
		String regionName = request.getParameter("region");
		String groupsNameValue = request.getParameter("groups");
		String instanceName = request.getParameter("instance");
		
		PrintWriter out = response.getWriter();
		
		if(cacheName == null)
			throw new ServletException("The cache name must be included to delete an item");
		if(regionName == null)
			throw new ServletException("The region name must be included to delete an item");
		if(groupsNameValue == null)
			throw new ServletException("The group name(s) must be included to delete an item");
		
		String[] groupsName = groupsNameValue.split(",");
		
		CacheItemPath deletedPath = null;
		if(instanceName != null)
			deletedPath = deleteInstance(cacheName, regionName, groupsName, request.getParameter("instance"));
		else
			deletedPath = deleteGroup(cacheName, regionName, groupsName);
		
		if(deletedPath != null)
			out.println("Deleted " + deletedPath.toString());
	}

	private CacheItemPath deleteGroup(String cacheName, String regionName, String[] groupsName) 
	{
		CacheItemPath groupPath = new CacheItemPath(cacheName, regionName, groupsName);
		
		return imagingCache.deleteGroup(groupPath);
	}

	private CacheItemPath deleteInstance(String cacheName, String regionName, String[] groupsName, String instanceName) 
	{
		CacheItemPath instancePath = new CacheItemPath(cacheName, regionName, groupsName, instanceName);
		
		return imagingCache.deleteInstance(instancePath);
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() 
	{
		super.destroy(); 
	}
}
