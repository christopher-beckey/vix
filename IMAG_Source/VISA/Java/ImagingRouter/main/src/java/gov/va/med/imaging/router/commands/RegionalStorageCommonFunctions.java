/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Nov 8, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.router.commands;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.CommandContext;
import gov.va.med.imaging.exchange.business.Site;

/**
 * @author Administrator
 *
 */
public class RegionalStorageCommonFunctions
{
	
	private final static Logger logger = Logger.getLogger(RegionalStorageCommonFunctions.class);
	private static Logger getLogger()
	{
		return logger;
	}
	
	public static Site getRegionalSite(String siteNumber, CommandContext commandContext)
	{
		try
		{
            getLogger().debug("Searching for regional site for site [{}]", siteNumber);
			// this is the site the image is owned by
			Site site = commandContext.getSiteResolver().getSite(siteNumber);
			// now return the site for the region id
			if(site.getRegionStorageId() != null)
			{
                getLogger().debug("Returning site [{}]", site.getRegionStorageId());
				return commandContext.getSiteResolver().getSite(site.getRegionStorageId());
			}
		}
		catch(ConnectionException cX)
		{
            getLogger().warn("ConnectionException finding regional storage site for site '{}', {}", siteNumber, cX.getMessage(), cX);
		}
		catch(MethodException mX)
		{
            getLogger().warn("MethodException finding regional storage site for site '{}', {}", siteNumber, mX.getMessage(), mX);
		}
		return null;
	}
	
	private static List<Site> getSitesAssociatedWithUrn(ImageURN imageUrn, CommandContext commandContext)
	{
		List<Site> result = new ArrayList<Site>();
		
		try
		{
			// site for URN
			Site imageSite = commandContext.getSiteResolver().getSite(imageUrn.getOriginatingSiteId());
			if(imageSite == null) // shouldn't happen...
				return result;			
			
			if(imageSite.getRegionStorageId() == null || imageSite.getRegionStorageId().length() <= 0)
			{
				// the image is on regional storage, need to find children to search in the cache for
				
				// JMW 12/10/2014 ISI 1.1 - change to this method to not return all children of the regional site because that makes too many 
				// sites to check (10 in Jordan)
				// change to only include the current ISIX site. This will work in most cases. The only time it won't work is if the 
				// image is from another site and it was cached before it was moved to regional storage... oh well
				
				result.add(commandContext.getLocalSite().getSite());
				
				/*				
				Region region = getRegion(imageSite.getRegionId(), commandContext);
				if(region == null) // also shouldn't happen
					return result; 
				for(Site site : region.getSites())
				{
					// only include sites that have a region storage ID of this site (just to be safe)
					if(imageSite.getSiteNumber().equals(site.getRegionStorageId()))
						result.add(site);
				}*/
			}
			else
			{
				// the imageSite is a child, just need its parent site
				Site regionSite = commandContext.getSiteResolver().getSite(imageSite.getRegionStorageId());
				if(regionSite != null)
					result.add(regionSite);
			}			
		}
		catch(ConnectionException cX)
		{
            getLogger().warn("ConnectionException finding associated sites to find image for site '{}', {}", imageUrn.getOriginatingSiteId(), cX.getMessage(), cX);
		}
		catch(MethodException mX)
		{
            getLogger().warn("MethodException finding associated sites to find image for site '{}', {}", imageUrn.getOriginatingSiteId(), mX.getMessage(), mX);
		}
		
		return result;
	}
	
	public static List<ImageURN> getUrnsToSearchCacheFor(ImageURN imageUrn, CommandContext commandContext)
	{
		List<ImageURN> result = new ArrayList<ImageURN>();
		result.add(imageUrn);
		if(searchForImageByRegionalStorageId())
		{
			List<Site> associatedSites = getSitesAssociatedWithUrn(imageUrn, commandContext);
			if(associatedSites != null)				
			{
				for(Site site : associatedSites)
				{
					try
					{
						ImageURN newUrn = imageUrn.cloneWithNewSite(site.getSiteNumber());
						result.add(newUrn);
					} 
					catch (CloneNotSupportedException cnsX)
					{
                        logger.warn("Error cloning URN with new regional site number, {}", cnsX.getMessage());
					}
				}
			}				
		}
		return result;
	}
	
	private static boolean searchForImageByRegionalStorageId()
	{
		return true;
	}
}
