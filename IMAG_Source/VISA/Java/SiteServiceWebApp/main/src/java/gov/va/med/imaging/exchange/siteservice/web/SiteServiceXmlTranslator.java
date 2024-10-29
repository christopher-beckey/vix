/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 24, 2011
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
package gov.va.med.imaging.exchange.siteservice.web;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exchange.business.Region;
import gov.va.med.imaging.exchange.business.RegionComparator;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;
import gov.va.med.imaging.exchange.siteservice.translator.ExchangeSiteServiceTranslator;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class SiteServiceXmlTranslator
{
	
	private final static Logger logger = 
		Logger.getLogger(SiteServiceXmlTranslator.class);

	
	public static void outputVha(HttpServletRequest request, 
			HttpServletResponse response, boolean exchangeSiteService)
	throws ServletException, IOException
	{
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		PrintWriter writer = response.getWriter();
		outputXmlHeader(writer);
		try
		{
			if(exchangeSiteService)
			{
				writer.write("<ArrayOfImagingExchangeSiteTO xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService\">\n");
			}
			else
			{
				writer.write("<ArrayOfRegionTO xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://vistaweb.med.va.gov/WebServices/SiteService\">\n");
			}
			
			
			List<Region> regions = router.getRegionList();
			Collections.sort(regions, new RegionComparator());
			for(Region region : regions)
			{
				if(exchangeSiteService)
				{
					for(Site site : region.getSites())
					{
						outputSite(site, writer, false, exchangeSiteService);
					}
				}
				else
				{
					outputRegion(region, writer, false, exchangeSiteService);
				}
			}
			if(exchangeSiteService)
			{
				writer.write("</ArrayOfImagingExchangeSiteTO>\n");
			}
			else
			{
				writer.write("</ArrayOfRegionTO>\n");
			}
		}
		catch(Exception ex)
		{
			logger.error(ex);
		}
	}
	
	public static void outputVisn(HttpServletRequest request, 
			HttpServletResponse response, boolean exchangeSiteService)
	throws ServletException, IOException
	{
		String regionId = request.getParameter("regionID");
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		PrintWriter writer = response.getWriter();
		outputXmlHeader(writer);
		try
		{
			Region region = router.getRegion(regionId);
			outputRegion(region, writer, true, exchangeSiteService);
		}
		catch (Exception ex)
		{
			outputRegionException(writer, regionId, 
					true, exchangeSiteService, ex);
		}		
		writer.flush();
		writer.close();
	}
	
	private static void outputRegion(Region region, PrintWriter writer, 
			boolean includeNamespaces, boolean exchangeSiteService)
	{
		outputRegionStartTag(writer, includeNamespaces, exchangeSiteService);
		writer.write("<name>" + escapeIllegalCharacters(region.getRegionName()) + "</name>\n");
		writer.write("<ID>" + region.getRegionNumber() +"</ID>\n");
		writer.write("<sites>\n");
		
		// the IIS site service returns the sites in the VISN in site number order. This is probably because of the
		// order in the VhaSites.xml file but to mimick that I am sorting by the site number and hoping for the best
		List<Site> sites = region.getSites();
		Collections.sort(sites, new SiteNumberComparator());
		
		for(Site site : sites)
		{
			outputSite(site, writer, false, exchangeSiteService);
		}
		writer.write("</sites>\n");
		outputRegionEndTag(writer, exchangeSiteService);
	}
	
	private static void outputRegionException(PrintWriter writer, String regionNumber, 
			boolean includeNamespaces, boolean exchangeSiteService, Exception ex)
	{
		outputRegionStartTag(writer, includeNamespaces, exchangeSiteService);
		
		writer.write("<ID>" + StringUtil.cleanString(regionNumber) + "</ID>\n");
		writer.write("<faultTO>\n");
		writer.write("<type>" + ex.getClass().getName() + "</type>\n");
		writer.write("<message>" + StringUtil.cleanString(ex.getMessage()) + "</message>\n");
		writer.write("<suggestion>Invalid VISN number?</suggestion>\n");
		writer.write("</faultTO>\n");
		
		outputRegionEndTag(writer, exchangeSiteService);
		
	}
	
	private static void outputRegionStartTag(PrintWriter writer, boolean includeNamespaces, boolean exchangeSiteService)
	{
		if(exchangeSiteService)
		{
			writer.write("<ImagingExchangeRegionTO");
			if(includeNamespaces)
				writer.write(" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService\"");
			writer.write(">\n");
		}
		else
		{
			writer.write("<RegionTO");
			if(includeNamespaces)
				writer.write(" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://vistaweb.med.va.gov/WebServices/SiteService\"");
			writer.write(">\n");
		}
	}
	
	private static void outputRegionEndTag(PrintWriter writer, boolean exchangeSiteService)
	{
		if(exchangeSiteService)
		{
			writer.write("</ImagingExchangeRegionTO>\n");
		}
		else
		{
			writer.write("</RegionTO>\n");
		}
	}
	
	public static void outputSites(HttpServletRequest request, 
			HttpServletResponse response, boolean exchangeSiteService)
	throws ServletException, IOException
	{
		String siteIDs = request.getParameter("siteIDs");
		String[] siteNumbers = ExchangeSiteServiceTranslator.convertDelimitedStringsIntoSiteNumbers(siteIDs);
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		PrintWriter writer = response.getWriter();
		outputXmlHeader(writer);
		if(exchangeSiteService)
		{
			writer.write("<ArrayOfImagingExchangeSiteTO xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService\">\n");
		}
		else
		{
			writer.write("<ArrayOfSiteTO xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://vistaweb.med.va.gov/WebServices/SiteService\">\n");
		}
		
		for(String siteNumber : siteNumbers)
		{
			try
			{
				Site site = router.getSite(siteNumber);
				if(site == null)
					throw new NullPointerException();
				outputSite(site, writer, false, exchangeSiteService);
			}
			catch (Exception ex)
			{
				outputSiteException(writer, siteNumber, false, exchangeSiteService, ex);
			}
		}
		if(exchangeSiteService)
		{
			writer.write("</ArrayOfImagingExchangeSiteTO>\n");
		}
		else
		{
			writer.write("</ArrayOfSiteTO>\n");
		}
		
		writer.flush();
		writer.close();
		
	}
	
	private static void outputSiteException(PrintWriter writer, String siteNumber, 
			boolean includeNamespaces, boolean exchangeSiteService, Exception ex)
	{
		outputSiteStartTag(writer, includeNamespaces, exchangeSiteService);
		
		if(exchangeSiteService)
		{
			writer.write("<siteNumber>" + StringUtil.cleanString(siteNumber) + "</siteNumber>\n");
		}
		else
		{
			writer.write("<sitecode>" + StringUtil.cleanString(siteNumber) + "</sitecode>\n");
		}
		writer.write("<faultTO>\n");
		writer.write("<type>" + ex.getClass().getName() + "</type>\n");
		writer.write("<message>" + StringUtil.cleanString(ex.getMessage()) + "</message>\n");
		writer.write("<suggestion>Invalid site code?</suggestion>\n");
		writer.write("</faultTO>\n");
		
		outputSiteEndTag(writer, exchangeSiteService);
		
	}
	
	private static void outputSiteStartTag(PrintWriter writer, 
			boolean includeNamespaces, boolean exchangeSiteService)
	{
		if(exchangeSiteService)
		{
			writer.write("<ImagingExchangeSiteTO");// xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService\">");
			if(includeNamespaces)
				writer.write(" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService\"");
			writer.write(">\n");
		}
		else
		{			
			writer.write("<SiteTO");
			if(includeNamespaces)
				writer.write(" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://vistaweb.med.va.gov/WebServices/SiteService\"");
			writer.write(">\n");
		}
	}
	
	private static void outputSiteEndTag(PrintWriter writer, 
			boolean exchangeSiteService)
	{
		if(exchangeSiteService)
		{
			writer.write("</ImagingExchangeSiteTO>\n");
		}
		else
		{			
			writer.write("</SiteTO>\n");			
		}
	}
	
	public static void outputSite(HttpServletRequest request, 
			HttpServletResponse response, boolean exchangeSiteService)
	throws ServletException, IOException
	{
		String siteId = request.getParameter("siteID");
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		PrintWriter writer = response.getWriter();
		outputXmlHeader(writer);
		try
		{
			Site site = router.getSite(siteId);			
			outputSite(site, writer, true, exchangeSiteService);			
		}
		catch(Exception ex)
		{
			logger.debug(ex);
			outputSiteException(writer, siteId, true, exchangeSiteService, ex);			
		}
		writer.flush();
		writer.close();
	}
	
	private static void outputSite(Site site, PrintWriter writer, 
			boolean includeNamespaces, boolean exchangeSiteService)
	{
		if(exchangeSiteService)
		{
			outputSiteStartTag(writer, includeNamespaces, exchangeSiteService);
			writer.write("<siteNumber>" + site.getSiteNumber() + "</siteNumber>\n");
			writer.write("<siteName>" + escapeIllegalCharacters(site.getSiteName()) + "</siteName>\n");
			writer.write("<regionID>" + site.getRegionId() + "</regionID>\n");
			writer.write("<siteAbbr>" + site.getSiteAbbr() + "</siteAbbr>\n");			
			writer.write("<vistaServer>" + site.getVistaServer() + "</vistaServer>\n");
			writer.write("<vistaPort>" + site.getVistaPort() + "</vistaPort>\n");
			if(site.getAcceleratorServer() == null || site.getAcceleratorServer().length() <= 0)
				writer.write("<acceleratorServer />\n");
			else
				writer.write("<acceleratorServer>" + site.getAcceleratorServer() + "</acceleratorServer>\n");
			writer.write("<acceleratorPort>" + site.getAcceleratorPort() + "</acceleratorPort>\n");
			outputSiteEndTag(writer, exchangeSiteService);
		}
		else
		{			
			outputSiteStartTag(writer, includeNamespaces, exchangeSiteService);
			writer.write("<sitecode>" + site.getSiteNumber() + "</sitecode>\n");
			writer.write("<name>" + escapeIllegalCharacters(site.getSiteName()) + "</name>\n");
			writer.write("<displayName>" + escapeIllegalCharacters(site.getSiteName()) + "</displayName>\n");
			writer.write("<moniker>" + site.getSiteAbbr() + "</moniker>\n");
			writer.write("<regionID>" + site.getRegionId() + "</regionID>\n");
			writer.write("<hostname>" + site.getVistaServer() + "</hostname>\n");
			writer.write("<port>" + site.getVistaPort() + "</port>\n");
			writer.write("<status>active</status>\n");
			outputSiteEndTag(writer, exchangeSiteService);			
		}
	}

	private static void outputXmlHeader(PrintWriter writer)
	{
		writer.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
	}
	
	private static ReplacementCharacters [] replacementCharacters = 
		new ReplacementCharacters [] 
   {
		new SiteServiceXmlTranslator.ReplacementCharacters(
				new String("&"),new String("&amp;")),
		new SiteServiceXmlTranslator.ReplacementCharacters(
				new String("<"),new String("&lt;")),
		new SiteServiceXmlTranslator.ReplacementCharacters(
				new String(">"),new String("&gt;"))
   };
	
	private static String escapeIllegalCharacters(String value)
	{
		if(value == null)
			return null;
		for(ReplacementCharacters replacementCharacter : replacementCharacters)
		{
			value = value.replace(replacementCharacter.oldChar, replacementCharacter.newChar);
		}
		return value;
	}
	
	static class ReplacementCharacters
	{
		CharSequence oldChar;
		CharSequence newChar;
		
		ReplacementCharacters(CharSequence oldChar, CharSequence newChar)
		{
			this.oldChar = oldChar;
			this.newChar = newChar;
		}
	}
}
