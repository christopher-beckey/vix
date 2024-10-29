using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;

namespace SiteService
{
    public class SiteServiceHelper
    {
        private static ExchangeSiteService.ImagingExchangeSiteService exchangeSiteService =
            new ExchangeSiteService.ImagingExchangeSiteService();

        public static List<VaSite> getVaSites(string siteServiceUrl, bool onlyIncludeVixSites)
        {
            exchangeSiteService.Url = siteServiceUrl;
            List<VaSite> result = new List<VaSite>();

            ExchangeSiteService.ImagingExchangeSiteTO[] sites = exchangeSiteService.getImagingExchangeSites();
            foreach (ExchangeSiteService.ImagingExchangeSiteTO site in sites)
            {
                VaSite r = translate(site);
                if (onlyIncludeVixSites)
                {
                    if (r.HasVix)
                        result.Add(r);
                }
                else
                {
                    result.Add(r);
                }
            }
            return result;
        }

        private static VaSite translate(ExchangeSiteService.ImagingExchangeSiteTO site)
        {
            return new VaSite(site.siteName, site.siteNumber, site.siteAbbr, 
                site.regionID, site.vistaServer, site.vistaPort, site.acceleratorServer, site.acceleratorPort);
        }

        public static List<VaSite> GetSites(string siteServiceUrl, string[] siteNumbers)
        {
            exchangeSiteService.Url = siteServiceUrl;
            List<VaSite> result = new List<VaSite>();

            string sitesQuery = "";
            string prefix = "";
            foreach (string siteNumber in siteNumbers)
            {
                sitesQuery = sitesQuery + prefix + siteNumber;
                prefix = "^";
            }

            ExchangeSiteService.ImagingExchangeSiteTO[] sites = exchangeSiteService.getSites(sitesQuery);
            foreach (ExchangeSiteService.ImagingExchangeSiteTO site in sites)
            {
                VaSite r = translate(site);
                result.Add(r);
            }
            return result;
        }

        public static VaSite GetSite(string siteServiceUrl, string siteNumber)
        {
            exchangeSiteService.Url = siteServiceUrl;
            ExchangeSiteService.ImagingExchangeSiteTO site = exchangeSiteService.getSite(siteNumber);

            VaSite result = translate(site);
            return result;
        }

    }
}
