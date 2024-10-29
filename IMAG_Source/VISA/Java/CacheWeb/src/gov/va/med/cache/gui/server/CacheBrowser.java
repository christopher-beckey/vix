package gov.va.med.cache.gui.server;

import gov.va.med.cache.gui.shared.CACHE_POPULATION_DEPTH;
import gov.va.med.cache.gui.shared.CacheVO;
import gov.va.med.cache.gui.shared.GroupVO;
import gov.va.med.cache.gui.shared.InstanceVO;
import gov.va.med.cache.gui.shared.RegionVO;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class CacheBrowser 
extends HttpServlet 
{
	private static final long serialVersionUID = 1L;
	private ImagingCacheManagementServiceImpl imagingCache = null;
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	/**
	 * Constructor of the object.
	 */
	public CacheBrowser() 
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
		
		dumpCache(out);
		
		out.println("  </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
	}

	private String currentCacheName = null;
	private String currentRegionName = null;
	private String[] currentGroupNames = new String[10];
	private String currentInstanceName = null;
	
	private void dumpCache(PrintWriter out) 
	{
		List<CacheVO> caches = imagingCache.getCacheList(CACHE_POPULATION_DEPTH.INSTANCE, CACHE_POPULATION_DEPTH.CACHE);
		
		for(Iterator<CacheVO> itr = caches.iterator(); itr.hasNext(); )
		{
			CacheVO cache = itr.next();
			currentCacheName = cache.getName();
			
			out.println("<H1>Cache " + currentCacheName + "</H1>");
			for(RegionVO region : cache.getRegions())
			{
				currentRegionName = region.getName();
				
				out.println("<H2>Region " + currentRegionName + "</H2>");
				dumpGroups(out, 0, region.getGroups());
			}
		}
	}

	private void dumpGroups(PrintWriter out, int level, SortedSet<GroupVO> groups) 
	{
		for(Iterator<GroupVO> itr = groups.iterator(); itr.hasNext(); )
		{
			GroupVO group = itr.next();
			currentGroupNames[level] = group.getName();
			
			logger.info("currentGroupName[" + level + "]" + currentGroupNames[level]);
			
			out.println("<H" + level+3 + ">Group " + currentGroupNames[level] + "</H" + level + ">");
			out.print(
				"<a href=\"deleteCacheItem?cache="
				+ currentCacheName 
				+ "&region=" 
				+ currentRegionName
				+ "&groups="
			);
			for(int i=0; i <= level; ++i)
				out.print(i > 0 ? ("," + currentGroupNames[i]) : currentGroupNames[i]);
			
			out.println("\">");
			out.println("delete");
			out.println("</a>");
			
			out.println("<br/>");
			for(InstanceVO instance : group.getInstances())
			{
				currentInstanceName = instance.getName();
				out.println("Instance " + currentInstanceName + "<br/>");
				out.println("<p>" + "Instance " + currentInstanceName + "</p>");
				out.print(
					"<a href=\"deleteCacheItem?cache="
					+ currentCacheName 
					+ "&region=" 
					+ currentRegionName
					+ "&groups="
				);
				for(int i=0; i <= level; ++i)
					if(i > 0)
						out.print(currentGroupNames[0]);
					else
						out.print("," + currentGroupNames[i]);
				out.print("&instance=");
				out.print(currentInstanceName);
				out.println(">");
				out.println("delete\"");
				out.println("</a>");
			}
			dumpGroups(out, level + 1, group.getGroups());
		}
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() 
	{
		super.destroy(); 
	}
}
