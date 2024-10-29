/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 18, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.exchange.siteservice.web;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;
import gov.va.med.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * This servlet projects the contents of the site service as the VIX currently stores it.
 * 
 * This is implemented as a Servlet rather than a JSP page because of the configuration of the SiteServiceWebApp - 
 * the web app defines most URLs to the AxisServlet and it was difficult to get it to redirect to a JSP page. Also
 * this keeps the specific functionality out of the SiteServiceWebApp so it can continue to redirect to the child JAR
 * files for functionality.
 * 
 * @author vhaiswwerfej
 *
 */
public class ExchangeSiteServiceServlet
extends HttpServlet
{
	private static final long serialVersionUID = -8094991270505056475L;
	private final static Logger LOGGER = Logger.getLogger(ExchangeSiteServiceServlet.class);
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		
		if(router == null) 
		{
			throw new IOException("ExchangeSiteServiceServlet.doGet() --> Error getting reference to facade router.");
		}
		
		try(PrintWriter writer = response.getWriter();)
		{
			List<Region> regions = router.getRegionList();
			Collections.sort(regions, new RegionComparator());
			response.setContentType("text/html");
			writeRegions(regions, writer);
			writer.flush();
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ExchangeSiteServiceServlet.doGet() --> Error: {}", cX.getMessage());
			throw new IOException("ExchangeSiteServiceServlet.doGet() --> Error: " + cX.getMessage(), cX);			
		}
		catch(MethodException mX)
		{
            LOGGER.error("ExchangeSiteServiceServlet.doGet() --> Error: {}", mX.getMessage());
			throw new ServletException("ExchangeSiteServiceServlet.doGet() --> Error: " + mX.getMessage(), mX);			
		}		
	}
	
	private void writeRegions(List<Region> regions, PrintWriter writer)
	{
		writer.write("<html>");
		writer.write("<head>");
		writer.write("<title>Exchange Site Service</title>");
		writer.write("</head>");
		writer.write("<body>");
		
		for(Region region : regions)
		{
			writeRegion(region, writer);
		}

		writer.write("</body>");
		writer.write("</html>");
	}
	
	private void writeRegion(Region region, PrintWriter writer)
	{
		writer.write("<h2>" + region.getRegionName() + " [" + region.getRegionNumber() + "]</h2>");
		writer.write("<table border='1'>");
		//writer.write("<tr><th>Site Name</th><th>#</th><th>Abbr</th><th>VistA Server</th><th>VistA Port</th><th>VIX Server</th><th>VIX Port</th><th>Patient Lookup Enabled</th><th>User Authentication Enabled</th></tr>");
		writer.write("<tr>"
				+ "<th>Site Name</th>"
				+ "<th>#</th>"
				+ "<th>Abbr</th>"
				+ "<th><div style='width: 60px'>Patient Lookup Enabled</div></th>"
				+ "<th><div style='width: 110px'>User Authentication Enabled</div></th>"
				+ "<th>Protocol</th>"
				+ "<th>Server</th>"
				+ "<th>Port</th>"
				+ "</tr>");

		List<Site> sites = region.getSites();
		Collections.sort(sites, new SiteComparator());
		
		for(Site site : sites)
		{
			writeSite(site, writer);
		}
		writer.write("</table>");
	}
	
	private void writeSite(Site site, PrintWriter writer)
	{
		
		Map<String, SiteConnection> siteMap = site.getSiteConnections();
		Boolean first = true;
		
		for(Map.Entry<String, SiteConnection> entry : siteMap.entrySet())
		{
			writer.write("<tr>");
			if (first)
			{
				writer.write("<td bgcolor='gray'><font color='white'>" + site.getSiteName() + "</td>");
				writer.write("<td bgcolor='gray'><font color='white'>" + site.getSiteNumber() + "</td>");
				writer.write("<td bgcolor='gray'><font color='white'>" + site.getSiteAbbr() + "</td>");
				writer.write("<td bgcolor='gray' align='center'><font color='white'>" + site.isSitePatientLookupable() + "</td>");
				writer.write("<td bgcolor='gray' align='center'><font color='white'>" + site.isSiteUserAuthenticatable() + "</td>");
				first = false;
			}
			else
			{
				writer.write("<td>&nbsp;</td>");
				writer.write("<td>&nbsp;</td>");
				writer.write("<td>&nbsp;</td>");
				writer.write("<td>&nbsp;</td>");
				writer.write("<td>&nbsp;</td>");
			}
			
			SiteConnection siteConnection = entry.getValue();
		
			writer.write("<td>" + siteConnection.getProtocol() + "</td>");
			writer.write("<td>" + siteConnection.getServer() +  "</td>");
			writer.write("<td>" + siteConnection.getPort() +  "</td>");
			writer.write("</tr>");
		}
	}
		
		
//		writer.write("<tr>");
//		writer.write("<td>" + site.getSiteName() + "</td>");
//		writer.write("<td>" + site.getSiteNumber() + "</td>");
//		writer.write("<td>" + site.getSiteAbbr() + "</td>");
//		writer.write("<td>" + site.getVistaServer() + "</td>");
//		writer.write("<td>" + site.getVistaPort() + "</td>");
//		writer.write("<td>" + ((site.getAcceleratorServer() == null || site.getAcceleratorServer().length() <= 0) ? "&nbsp;" : site.getAcceleratorServer()) + "</td>");
//		writer.write("<td>" + site.getAcceleratorPort() + "</td>");
//		writer.write("<td>" + site.isSitePatientLookupable() + "</td>");
//		writer.write("<td>" + site.isSiteUserAuthenticatable() + "</td>");
//		writer.write("</tr>");
}
