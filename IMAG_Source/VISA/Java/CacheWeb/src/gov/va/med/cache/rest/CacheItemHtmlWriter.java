package gov.va.med.cache.rest;

import gov.va.med.cache.gui.shared.CacheVO;
import gov.va.med.cache.gui.shared.GroupVO;
import gov.va.med.cache.gui.shared.InstanceVO;
import gov.va.med.cache.gui.shared.RegionVO;

import java.io.PrintWriter;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class CacheItemHtmlWriter 
implements CacheWriter 
{
	private final PrintWriter out;
	private final String servletPath;
	
	public CacheItemHtmlWriter(PrintWriter out, String servletPath) 
	{
		super();
		this.out = out;
		this.servletPath = servletPath.substring(1);	// get rid of the starting slash
	}

	public PrintWriter getOut() {
		return out;
	}

	public String getServletPath() {
		return servletPath;
	}

	@Override
	public String getMediaType(){return "text/html";}
	
	@Override
	public void writeStartTag()
	{
		getOut().println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		getOut().println("<HTML>");
		getOut().println("<HEAD>");
		getOut().println("<TITLE>Cache Dump</TITLE>");
		getOut().println("<link rel=\"stylesheet\" type=\"text/css\" href=\"CacheDump.css\"/>");
		getOut().println("</HEAD>");
		getOut().println("<BODY>");
	}
	
	@Override
	public void writeEndTag()
	{
		getOut().println("</BODY>");
		getOut().println("</HTML>");
	}
	
	/**
	 * @see gov.va.med.cache.http.CacheWriter#writeCacheVO(java.io.PrintWriter, gov.va.med.cache.gui.shared.CacheVO, gov.va.med.cache.gui.shared.CACHE_POPULATION_DEPTH)
	 */
	@Override
	public void writeStartTag(CacheVO cache) 
	{
		out.println("<div class=\"cache\">" + cache.getName() + "</div>");
	}
	@Override
	public void writeEndTag(CacheVO cache) 
	{
		out.println("</div>");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.cache.gui.server.CacheWriter#writeRegionVO(java.io.PrintWriter, gov.va.med.cache.gui.shared.CacheVO, gov.va.med.cache.gui.shared.RegionVO, gov.va.med.cache.gui.shared.CACHE_POPULATION_DEPTH)
	 */
	@Override
	public void writeStartTag(CacheVO cache, RegionVO region) 
	{
		out.println("<div class=\"region\">" + region.getName() + "</div>");
	}
	@Override
	public void writeEndTag(CacheVO cache, RegionVO region) 
	{
		out.println("</div>");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.cache.gui.server.CacheWriter#writeGroupVO(java.io.PrintWriter, gov.va.med.cache.gui.shared.CacheVO, gov.va.med.cache.gui.shared.RegionVO, gov.va.med.cache.gui.shared.GroupVO[], int, gov.va.med.cache.gui.shared.CACHE_POPULATION_DEPTH)
	 */
	@Override
	public void writeStartTag(CacheVO cache, RegionVO region, GroupVO[] groupAncestry) 
	{
		out.println("<div class=\"group" + (groupAncestry.length-1) + "\">");
		out.println(groupAncestry[groupAncestry.length-1].getName());
		
		// deletecacheitem
		out.print(
			"<a class=\"delete\""
			+ "href='" + getServletPath() + "/"
			+ cache.getName() 
			+ "/" 
			+ region.getName()
			+ "/"
		);
		for(int i=0; i < groupAncestry.length; ++i)
			out.print(i > 0 ? ("," + groupAncestry[i].getName()) : groupAncestry[i].getName());
		
		out.println("?method=DELETE'><span class=\"delete\">Delete</span></a>");
	}
	@Override
	public void writeEndTag(CacheVO cache, RegionVO region, GroupVO[] groupAncestry) 
	{
		out.println("</div>");
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.cache.gui.server.CacheWriter#writeInstanceVO(java.io.PrintWriter, gov.va.med.cache.gui.shared.CacheVO, gov.va.med.cache.gui.shared.RegionVO, gov.va.med.cache.gui.shared.GroupVO[], gov.va.med.cache.gui.shared.InstanceVO)
	 */
	@Override
	public void writeStartTag(CacheVO cache, RegionVO region, GroupVO[] groupAncestry, InstanceVO instance) 
	{
		out.println("<div class=\"instance\">" );
		out.println(instance.getName());
		
		out.print(
			"<a class=\"delete\""
			+ "href='" + getServletPath() + "/"
			+ cache.getName() 
			+ "/" 
			+ region.getName()
			+ "/"
		);
		for(int i=0; i < groupAncestry.length; ++i)
			out.print((i > 0 ? "," : "") + groupAncestry[i].getName());
		out.print("/.");
		out.print(instance.getName());
		out.println("?method=DELETE'><span class=\"delete\">Delete</span></a>");
	}
	
	public void writeEndTag(CacheVO cache, RegionVO region, GroupVO[] groupAncestry, InstanceVO instance)
	{
		out.println("</div>");
	}
}
