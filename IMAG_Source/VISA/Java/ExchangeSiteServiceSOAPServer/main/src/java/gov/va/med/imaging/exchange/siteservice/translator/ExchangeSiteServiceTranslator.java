/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 20, 2008
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
package gov.va.med.imaging.exchange.siteservice.translator;


import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exchange.business.Region;
import gov.va.med.imaging.exchange.business.Site;
/**
 * Exchange site service translator
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ExchangeSiteServiceTranslator 
{
	private final static Logger LOGGER = Logger.getLogger(ExchangeSiteServiceTranslator.class);
	private final static String siteNumberDelimiter = "^";
	
	/**
	 * Convert a site object. This will always return an ImagingExchangeSiteTO object which will 
	 * either contain the converted values or a FaultTO containing error information
	 * @param site
	 * @param siteNumber
	 * @return
	 */
	public static gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO convertSite(
		Site site, 
		String siteNumber)
	{
		gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO siteTo = 
			new gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO();
		try 
		{
			siteTo.setAcceleratorPort(site.getAcceleratorPort());
			siteTo.setAcceleratorServer(site.getAcceleratorServer());
			siteTo.setRegionID(site.getRegionId());
			siteTo.setSiteAbbr(site.getSiteAbbr());
			siteTo.setSiteName(site.getSiteName());
			siteTo.setSiteNumber(site.getSiteNumber());
			siteTo.setVistaPort(site.getVistaPort());
			siteTo.setVistaServer(site.getVistaServer());
		}
		catch(Exception ex)
		{
            LOGGER.warn("ExchangeSiteServiceTranslator.convertSite() --> Error translating site [{}]: {}", siteNumber, ex.getMessage());
			siteTo.setSiteNumber(siteNumber);			
			siteTo.setFaultTO(createFault(ex, "Invalid site code?"));
		}
		return siteTo;
	}
	
	/**
	 * Convert a list of site objects. This will always return an array of ImagingExchangeSiteTO objects
	 * which will contain ImagingExchangeSiteTO objects containing either the converted site
	 * or a FaultTO containing error information
	 * @param sites
	 * @return
	 */
	public static gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO [] convertSites(List<Site> sites)
	{
		List<gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO> sitesTo = 
			new ArrayList<gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO>();		
		for(Site site : sites)
		{
			sitesTo.add(convertSite(site, ""));
		}
		return sitesTo.toArray(new gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO[sitesTo.size()]);
	}	
	
	public static gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeRegionTO convertRegion(Region region, String regionId)
	{		
		gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeRegionTO result = 
			new gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeRegionTO();
		try
		{			
			result.setID(region.getRegionNumber());
			result.setName(region.getRegionName());
			
			gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO [] sites = convertSites(region.getSites());
			result.setSites(new gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO(sites));
		}
		catch(Exception ex)
		{
            LOGGER.error("ExchangeSiteServiceTranslator.convertRegion() --> Error translating region [{}]: {}", regionId, ex.getMessage());
			result.setID(regionId);
			result.setFaultTO(createFault(ex, "Invalid VISN number?"));
		}
		return result;		
	}
	
	/**
	 * Create a fault based on an exception
	 * @param ex An exception that occurred
	 * @param suggestion Suggestion for the cause of the problem
	 * @return
	 */
	private static gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.FaultTO createFault(Exception ex, String suggestion)
	{
		gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.FaultTO fault = 
			new gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.FaultTO(ex.getClass().toString(), ex.getMessage(), ex.getStackTrace().toString(), suggestion);
		return fault;
	}
	
	public static gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO convertRegionsToSites(List<Region> regions)
	{
		List<gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO> sites = 
			new ArrayList<gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO>();
			                                                                                 
		for(Region region : regions)
		{			
			List<Site> regionSites = region.getSites();
			for(Site site : regionSites)
			{
				sites.add(convertSite(site, ""));
			}
		}
		gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO [] sitesTo = 
			sites.toArray(new gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO[sites.size()]);
		
		gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO result = 
			new gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO(sitesTo);
		return result;
	}
	
	/**
	 * Converted the delimited string into an array of site numbers
	 * @param delimitedSiteNumbers
	 * @return
	 */
	public static String[] convertDelimitedStringsIntoSiteNumbers(String delimitedSiteNumbers)
	{
		return StringUtil.split(delimitedSiteNumbers, siteNumberDelimiter);
	}
}
