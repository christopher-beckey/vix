package gov.va.med.cache.rest;

import gov.va.med.cache.gui.server.ImagingCacheManagementServiceImpl;
import gov.va.med.cache.gui.shared.CACHE_POPULATION_DEPTH;
import gov.va.med.cache.gui.shared.CacheItemPath;
import gov.va.med.cache.gui.shared.CacheVO;
import gov.va.med.cache.gui.shared.GroupVO;
import gov.va.med.cache.gui.shared.InstanceVO;
import gov.va.med.cache.gui.shared.RegionVO;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class DumpCacheServlet 
extends HttpMethodHackServlet 
{
	private static final long serialVersionUID = 1L;
	private ImagingCacheManagementServiceImpl imagingCache = null;
	//private final Logger logger = Logger.getLogger(this.getClass());
	
	/**
	 * Constructor of the object.
	 */
	public DumpCacheServlet() 
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
		//CacheItemPath startPath = CacheItemPath.buildCacheItemPath(request);
		String myPath = request.getServletPath();
		
		CACHE_POPULATION_DEPTH depth = CACHE_POPULATION_DEPTH.INSTANCE;
		String requestedMaxDepth = request.getParameter("level");
		if(requestedMaxDepth != null)
			depth = CACHE_POPULATION_DEPTH.valueOf(requestedMaxDepth);

		response.addHeader("Cache-Control", "no-cache");
		response.addHeader("Pragma", "no-cache");
		
		PrintWriter out = response.getWriter();
		
		CacheWriter cacheWriter = new CacheItemHtmlWriter(out, myPath);
		response.setContentType(cacheWriter.getMediaType());
		
		cacheWriter.writeStartTag();
		dumpCaches(cacheWriter, depth);
		cacheWriter.writeEndTag();
		
		out.flush();
		out.close();
	}

	/**
	 * 
	 */
	@Override
	protected void doDelete(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException 
	{
		CacheItemPath itemPath = IdentifierUtility.create(request);
		
		PrintWriter out = response.getWriter();
		
		if(itemPath.getCacheName() == null)
			throw new ServletException("The cache name must be included to delete an item");
		if(itemPath.getRegionName() == null)
			throw new ServletException("The region name must be included to delete an item");
		if(itemPath.getGroupNames() == null || itemPath.getGroupNames().length < 1)
			throw new ServletException("The group name(s) must be included to delete an item");
		
		CacheItemPath deletedPath = null;
		if(itemPath.getInstanceName() != null)
			deletedPath = deleteInstance(itemPath.getCacheName(), itemPath.getRegionName(), itemPath.getGroupNames(), itemPath.getInstanceName());
		else
			deletedPath = deleteGroup(itemPath.getCacheName(), itemPath.getRegionName(), itemPath.getGroupNames());
		
		if(deletedPath != null)
			out.println("Deleted " + deletedPath.toString());

		response.setStatus(303);		// response can be found at the given URI
		URL redirectUrl = new URL(request.getScheme(), request.getServerName(), request.getServerPort(), request.getContextPath() + request.getServletPath());
		response.setHeader("Location", redirectUrl.toExternalForm());		// redirect back to ourselves
	}

	/**
	 * 
	 * @param out
	 * @param maxDepth 
	 */
	private void dumpCaches(CacheWriter writer, CACHE_POPULATION_DEPTH maxDepth) 
	{
		List<CacheVO> caches = imagingCache.getCacheList(CACHE_POPULATION_DEPTH.INSTANCE, CACHE_POPULATION_DEPTH.CACHE);
		
		for(Iterator<CacheVO> itr = caches.iterator(); itr.hasNext(); )
		{
			CacheVO cache = itr.next();
			dumpCache(writer, cache, maxDepth);
		}
	}
	
	/**
	 * 
	 * @param writer
	 * @param cache
	 * @param maxDepth
	 */
	private void dumpCache(CacheWriter writer, CacheVO cache, CACHE_POPULATION_DEPTH maxDepth) 
	{
		writer.writeStartTag(cache);
		
		if(CACHE_POPULATION_DEPTH.REGION.compareTo(maxDepth) <= 0)
			for(RegionVO region : cache.getRegions())
				dumpRegion(writer, cache, region, maxDepth);
		writer.writeEndTag(cache);
	}

	/**
	 * 
	 * @param writer
	 * @param cache
	 * @param region
	 * @param maxDepth
	 */
	private void dumpRegion(CacheWriter writer, CacheVO cache, RegionVO region, CACHE_POPULATION_DEPTH maxDepth) 
	{
		writer.writeStartTag(cache, region);
		if(CACHE_POPULATION_DEPTH.GROUP0.compareTo(maxDepth) <= 0)
			for(GroupVO group : region.getChildren())
				dumpGroup(writer, cache, region, new GroupVO[]{group}, maxDepth, CACHE_POPULATION_DEPTH.GROUP0);
		writer.writeEndTag(cache, region);
	}

	/**
	 * 
	 * @param writer
	 * @param cache
	 * @param region
	 * @param groups
	 * @param maxDepth
	 * @param currentDepth
	 */
	private void dumpGroup(CacheWriter writer, CacheVO cache, RegionVO region, GroupVO[] groups, CACHE_POPULATION_DEPTH maxDepth, CACHE_POPULATION_DEPTH currentDepth) 
	{
		writer.writeStartTag(cache, region, groups);
		
		GroupVO subjectGroup = groups[groups.length - 1];
		
		if(CACHE_POPULATION_DEPTH.INSTANCE.compareTo(maxDepth) <= 0)
			for(InstanceVO instance : subjectGroup.getInstances())
			{
				writer.writeStartTag(cache, region, groups, instance);
				writer.writeEndTag(cache, region, groups, instance);
			}
		
		if(currentDepth.compareTo(maxDepth) <= 0)
			for(GroupVO childGroup : subjectGroup.getGroups())
			{
				GroupVO[] ancestryGroups = append(groups, childGroup);
				dumpGroup(writer, cache, region, ancestryGroups, maxDepth, CACHE_POPULATION_DEPTH.GROUP0);
			}
		writer.writeEndTag(cache, region, groups);
	}
	
	private GroupVO[] append(GroupVO[] groups, GroupVO group)
	{
		// build an array that includes childGroup as the last group
		// then make a call to dumpGroup(), which calls this method again,
		// making these recursive calls
		GroupVO[] childGroupAncestry = new GroupVO[groups.length + 1];
		System.arraycopy(groups, 0, childGroupAncestry, 0, groups.length);
		childGroupAncestry[childGroupAncestry.length-1] = group;
		
		return childGroupAncestry;
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
