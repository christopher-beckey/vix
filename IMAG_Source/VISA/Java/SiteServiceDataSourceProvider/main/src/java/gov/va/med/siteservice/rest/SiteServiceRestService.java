package gov.va.med.siteservice.rest;

import gov.va.med.imaging.exchange.business.Region;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.siteservice.RegionMapLoadException;
import gov.va.med.siteservice.SiteMapLoadException;
import gov.va.med.siteservice.SiteService;
import gov.va.med.logging.Logger;

import java.net.URI;
import java.util.List;

public class SiteServiceRestService {
    private static Logger logger = Logger.getLogger(SiteService.class);
    private final URI siteServiceUri;

    public SiteServiceRestService(URI siteServiceUri){
        this.siteServiceUri = siteServiceUri;

    }

    public List<Site> fetchSites()
            throws SiteMapLoadException
    {
        logger.info("Loading SiteService sites cache from V2 interface");
        String siteServiceV2Url = getSiteServiceV2Url();
        logger.debug("siteService REST URL: {}", siteServiceV2Url);
        try
        {
            List<Site> newSites = SiteServiceRestProxy.getSites(siteServiceV2Url);

            if( newSites == null || newSites.size() == 0 )
                throw new SiteMapLoadException("Null or zero length site list returned from translator, has format changed?", true);

            return newSites;
        }
        catch (Exception e)
        {
            logger.error(e);
            throw new SiteMapLoadException(e, true);
        }
    }

    public List<Region> fetchRegions()
            throws RegionMapLoadException
    {
        logger.info("Loading SiteService regions cache from V2 interface");
        String siteServiceV2Url = getSiteServiceV2Url();
        try
        {
            List<Region> newRegions = SiteServiceRestProxy.getRegions(siteServiceV2Url);
            if( newRegions == null || newRegions.size() == 0 )
                throw new RegionMapLoadException("Null or zero length region list returned from translator, has format changed?", true);
            return newRegions;
        }
        catch (Exception e)
        {
            logger.error(e);
            throw new RegionMapLoadException(e, true);
        }
    }

    private String getSiteServiceV2Url()
    {
        return siteServiceUri.toString().replace("ImagingExchangeSiteService.asmx", "restservices/siteservice/sites");
    }

}
