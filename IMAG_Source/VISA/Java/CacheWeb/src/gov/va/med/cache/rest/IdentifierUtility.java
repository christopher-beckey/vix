package gov.va.med.cache.rest;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;

import gov.va.med.cache.gui.shared.CacheItemPath;

public class IdentifierUtility 
{
	/**
	 * Using the URL from the HttpRequest, build a path to a cache item.
	 * The identifiers may be specified either as the path info of the URL or as 
	 * query parameters.  If the request contains path info, then that will
	 * be used and parameters will be ignored.
	 * When using the path info, the last item in the path could be either a group or an instance, 
	 * to differentiate these two cases a '.' preceding the last element will cause it to be 
	 * interpreted as an instance, otherwise it will be interpreted as a group.   
	 * 
	 * @param request
	 * @return
	 */
	public static CacheItemPath create(HttpServletRequest request) 
	{
		String cacheName = null;
		String regionName = null;
		String[] groupsName = null;
		String instanceName = null;
		
		String pathInfo = request.getPathInfo();		// must start with a slash
		if(pathInfo == null)
		{
			cacheName = request.getParameter("cache");
			regionName = request.getParameter("region");
			String groupsParameter = request.getParameter("groups");
			groupsName = groupsParameter == null ? null : groupsParameter.split(",");
			instanceName = request.getParameter("instance");
			
			return
				instanceName != null && groupsName != null && groupsName.length > 0 ? new CacheItemPath(cacheName, regionName, groupsName, instanceName) : 
				groupsName != null && groupsName.length > 0 ? new CacheItemPath(cacheName, regionName, groupsName) :
				regionName != null ? new CacheItemPath(cacheName, regionName) :
				cacheName != null ? new CacheItemPath(cacheName) : 
				new CacheItemPath();
		}
		else
			return create(pathInfo);
	}
	
	/**
	 * 
	 * @param pathInfo
	 * @return
	 */
	public static CacheItemPath create(String pathInfo) 
	{
		String cacheName = null;
		String regionName = null;
		String[] groupsName = null;
		String instanceName = null;

		if(pathInfo == null)
			return null;
		
		// if there is a path info and it starts with a slash
		if(pathInfo.length() > 0 && pathInfo.charAt(0) == '/')
		{
			pathInfo = pathInfo.substring(1);			// removes the starting slash
			String[] pathElements = pathInfo.split("/");
			
			cacheName = pathElements.length > CacheItemPath.CACHE_INDEX ? pathElements[CacheItemPath.CACHE_INDEX] : null; 
			regionName = pathElements.length > CacheItemPath.REGION_INDEX ? pathElements[CacheItemPath.REGION_INDEX] : null;
			groupsName = null;
			instanceName = null;
			
			if(pathElements.length >= 3)
			{
				String lastElement = pathElements[pathElements.length-1];
				if( lastElement.charAt(0) == CacheItemPath.INSTANCE_INDICATOR )
				{
					groupsName = new String[pathElements.length-3];		// 1 for cache name, 1 for region name, 1 for instance name
					System.arraycopy(pathElements, 2, groupsName, 0, groupsName.length);
					instanceName = lastElement.substring(1);		// rid ourselves of the preceeding '.'
				}
				else
				{
					groupsName = new String[pathElements.length-2];		// 1 for cache name, 1 for region name
					System.arraycopy(pathElements, 2, groupsName, 0, groupsName.length);
				}
			}
		}		
		return
			instanceName != null && groupsName != null && groupsName.length > 0 ? new CacheItemPath(cacheName, regionName, groupsName, instanceName) : 
			groupsName != null && groupsName.length > 0 ? new CacheItemPath(cacheName, regionName, groupsName) :
			regionName != null ? new CacheItemPath(cacheName, regionName) :
			cacheName != null ? new CacheItemPath(cacheName) : 
			new CacheItemPath();
	}
	
	/**
	 * Returns a String compatible with the PathInfo as defined by the HttpServletRequest:
	 * @see http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletRequest.html
	 * "Returns any extra path information associated with the URL the client sent when it made this request. 
	 * The extra path information follows the servlet path but precedes the query string and will 
	 * start with a "/" character."
	 * 
	 * This is the opposite of CacheItemPath create(HttpServletRequest) when the
	 * HttpServletRequest has the cache item identifiers in the URL path.
	 * 
	 * @return
	 */
	public static String createPathInfo(CacheItemPath path)
			throws UnsupportedEncodingException {
		StringBuilder sb = new StringBuilder();

		if (path == null)
			return null;

		if (path.getCacheName() != null)
			sb.append("/" + path.getCacheName());

		if (path.getRegionName() != null)
			sb.append("/" + path.getRegionName());

		if (path.getGroupNames() != null)
			for (String group : path.getGroupNames())
				sb.append("/" + group);

		if (path.getInstanceName() != null)
			sb.append("/." + URLEncoder.encode(path.getInstanceName(), "UTF8"));

		return sb.toString();
	}
}
