using DesktopCommon;
using System.Collections.Generic;

namespace SiteService
{
    public class SiteServiceHelper
    {
        private static ExchangeSiteService.ImagingExchangeSiteService exchangeSiteService = new ExchangeSiteService.ImagingExchangeSiteService();
        private readonly string vaRadiologyOid = "1.3.6.1.4.1.3768";
        private readonly string bhieRadiologyOid = "2.16.840.1.113883.3.42.10012.100001.207";
        private Dictionary<string, VaSite> sites = null;

        public SiteServiceHelper(string url)
        {
            exchangeSiteService.Url = url; //run-time change
        }

        public List<VaSite> GetVaSites(bool onlyIncludeVixSites)
        {
            List<VaSite> result = new List<VaSite>();
            ExchangeSiteService.ImagingExchangeSiteTO[] sites = exchangeSiteService.getImagingExchangeSites();
            foreach (ExchangeSiteService.ImagingExchangeSiteTO site in sites)
            {
                VaSite s = translate(site);
                if (onlyIncludeVixSites)
                {
                    if (s.SiteNumber != "2001" && s.SiteNumber != "2002" && s.SiteNumber != "2003" && s.SiteNumber != "2004")
                    {
                        if (s.HasVix)
                            result.Add(s);
                    }
                }
            }
            return result;
        }

        private VaSite translate(ExchangeSiteService.ImagingExchangeSiteTO site)
        {
            //siteName, siteNumber, siteAbbreviation, region, vistaServer, vistaPort, vixServer, vixPort
            VaSite newSite = new VaSite(site.siteName, site.siteNumber, site.siteAbbr, site.regionID, site.vistaServer, site.vistaPort, site.acceleratorServer, site.acceleratorPort);
            return newSite;
        }

        public List<VaSite> GetSites(string[] siteNumbers)
        {
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

        public VaSite GetSite(string siteServiceUrl, string siteNumber)
        {
            exchangeSiteService.Url = siteServiceUrl;
            ExchangeSiteService.ImagingExchangeSiteTO site = exchangeSiteService.getSite(siteNumber);

            VaSite result = translate(site);
            return result;
        }

        public VaSite GetVixSiteSite(string siteNumber, string serverName = null)
        {
            if (sites == null)
            {
                GetVaSites(false);
            }

            string sNumber = siteNumber;
            if (siteNumber.StartsWith(vaRadiologyOid))
            {
                // VA Radiology
                sNumber = siteNumber.Substring(vaRadiologyOid.Length + 1);
            }
            else if (siteNumber.StartsWith(bhieRadiologyOid))
            {
                // BHIE radiology
                //sNumber = siteNumber.Substring(bhieRadiologyOid.Length + 1);
                // need to get data from CVIX
                sNumber = "2001";
            }

            if (serverName != null)
            {
                foreach (string key in sites.Keys)
                {
                    VaSite site = sites[key];
                    if (site.HasVix && site.VistaHost.ToLower().StartsWith(serverName.ToLower()))
                        return site;
                }
            }
            return sites[sNumber];
        }
    }
}
