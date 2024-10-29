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
package gov.va.med.imaging.exchange.siteservice.webservices;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.exchange.business.Region;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;
import gov.va.med.imaging.exchange.siteservice.translator.ExchangeSiteServiceTranslator;

import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * Implementation of the Exchange Site Service
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ExchangeSiteServiceWebservice 
implements gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteServiceSoap, ApplicationContextAware
{	
	private static ApplicationContext appContext;
	private final static Logger LOGGER = Logger.getLogger(ExchangeSiteServiceWebservice.class);
	
	/* (non-Javadoc)
	 * @see org.springframework.context.ApplicationContextAware#setApplicationContext(org.springframework.context.ApplicationContext)
	 */
	@Override
	public void setApplicationContext(ApplicationContext context)
	throws BeansException 
	{
		appContext = context;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteServiceSoap#getImagingExchangeSites()
	 */
	@Override
	public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO getImagingExchangeSites()
	throws RemoteException 
	{
		LOGGER.debug("ExchangeSiteServiceWebservice.getImagingExchangeSites() --> Retrieving all VA sites....");
		
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		
		if(router == null)
			throw new RemoteException("ExchangeSiteServiceWebservice.getImagingExchangeSites() --> Error getting reference to facade router.");
		
		try 
		{
			List<Region> regions = router.getRegionList();
			gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO result = 
				ExchangeSiteServiceTranslator.convertRegionsToSites(regions);
			return result;					
		}
		catch(MethodException mX)
		{
			String msg = "ExchangeSiteServiceWebservice.getImagingExchangeSites() --> Error retrieving all sites: " + mX.getMessage();
			LOGGER.error(msg);
			throw new RemoteException(msg);
		}
		catch(ConnectionException cX)
		{
			String msg = "ExchangeSiteServiceWebservice.getImagingExchangeSites() --> Error retrieving all sites: " + cX.getMessage();
			LOGGER.error(msg);
			throw new RemoteException(msg);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteServiceSoap#getSite(java.lang.String)
	 */
	@Override
	public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO getSite(String siteID) 
	throws RemoteException 
	{
        LOGGER.debug("ExchangeSiteServiceWebservice.getSite() --> Retrieving Site [{}]", siteID);
		try
		{
			return getSiteInternal(siteID);
		}
		catch(MethodException mX)
		{
			String msg = "ExchangeSiteServiceWebservice.getSite() --> Error retrieving site [" + siteID + "]: " + mX.getMessage();
			LOGGER.error(msg);
			throw new RemoteException(msg);
		}
		catch(ConnectionException cX)
		{
			String msg = "ExchangeSiteServiceWebservice.getSite() --> Error retrieving site [" + siteID + "]: " + cX.getMessage();
			LOGGER.error(msg);
			throw new RemoteException(msg);
		}
	}
	
	/**
	 * Internal function to retrieve a site 
	 * @param siteID
	 * @return
	 * @throws MethodException Occurs if the ViX core throws an exception getting the site
	 */
	private gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO getSiteInternal(String siteID)
	throws MethodException, ConnectionException
	{
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		if(router == null)
			throw new ConnectionException("ExchangeSiteServiceWebservice.getSiteInternal() --> Error getting reference to facade router.");
		
		Site site = router.getSite(siteID);
		
		gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO result = 
			ExchangeSiteServiceTranslator.convertSite(site, siteID);
		return result;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteServiceSoap#getSites(java.lang.String)
	 */
	@Override
	public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO getSites(String siteIDs)
	throws RemoteException 
	{
        LOGGER.debug("ExchangeSiteServiceWebservice.getSites() --> Retrieving sites [{}]", siteIDs);
		List<gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO> sitesTo = new 
			ArrayList<gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO>();
		
		String[] siteNumbers = ExchangeSiteServiceTranslator.convertDelimitedStringsIntoSiteNumbers(siteIDs);
		for(String siteNumber : siteNumbers)
		{
			try
			{
				sitesTo.add(getSiteInternal(siteNumber));
			}
			catch(MethodException mX)
			{
                LOGGER.warn("ExchangeSiteServiceWebservice.getSites() --> Error retrieving site [{}] from vix core: {}", siteNumber, mX.getMessage());
				//throw new RemoteException(mX.getMessage());
			}
			catch(ConnectionException cX)
			{
                LOGGER.error("ExchangeSiteServiceWebservice.getSites() --> Error retrieving site [{}] from vix core: {}", siteNumber, cX.getMessage());
				//throw new RemoteException(mX.getMessage());
			}
		}
		gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO result = 
			new gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO(
				sitesTo.toArray(new gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO[sitesTo.size()]));			
		return result;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteServiceSoap#getVISN(java.lang.String)
	 */
	@Override
	public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeRegionTO getVISN(String regionID)
	throws RemoteException 
	{
        LOGGER.debug("ExchangeSiteServiceWebservice.getVISN() --> Retrieving VISN [{}]", regionID);
		
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		if(router == null)
			throw new RemoteException("ExchangeSiteServiceWebservice.getVISN() --> Error getting reference to facade router.");
		
		gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeRegionTO region = null;
		
		try 
		{
			region = ExchangeSiteServiceTranslator.convertRegion(router.getRegion(regionID), regionID);			
		}
		catch(MethodException mX)
		{
			String msg = "ExchangeSiteServiceWebservice.getVISN() --> Error retrieving site [" + regionID + "] from vix core: " + mX.getMessage();
			LOGGER.error(msg);
			throw new RemoteException(msg);
		}		
		catch(ConnectionException cX)
		{
			String msg = "ExchangeSiteServiceWebservice.getVISN() --> Error retrieving site [" + regionID + "] from vix core: " + cX.getMessage();
			LOGGER.error(msg);
			throw new RemoteException(msg);
		}		
		return region;
	}
}
