/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */
namespace VistaCommon
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;

    using VistaCommon.SiteService;

    using log4net;

    /// <summary>
    /// The site service helper.
    /// </summary>
    public class SiteServiceHelper
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(SiteServiceHelper));


        /// <summary>
        /// The site service ip address.
        /// </summary>
        private static readonly string SiteServiceIpAddress =
            ConfigurationManager.AppSettings.Get("SiteServiceIpAddress");

        /// <summary>
        /// The site service.
        /// </summary>
        private static readonly ImagingExchangeSiteService siteService = new ImagingExchangeSiteService();

        /// <summary>
        /// The site service cache.
        /// </summary>
        private static readonly Dictionary<string, Site> siteServiceCache = new Dictionary<string, Site>();

        #endregion

        #region Public Methods

        /// <summary>
        /// Gets the site.
        /// </summary>
        /// <param name="siteNumber">The site number.</param>
        /// <returns>The site with the specified site number</returns>
        public static Site GetSite(string siteNumber)
        {
            if (!siteServiceCache.ContainsKey(siteNumber))
            {
                siteService.Url = GetSiteServiceUrl();

                try
                {
                    ImagingExchangeSiteTO siteTo = siteService.getSite(siteNumber);

                    if (string.IsNullOrWhiteSpace(siteTo.acceleratorServer))
                    {
                        //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.(p289-OITCOPondiS)
                        Logger.Error("Invalid siteNumber");
                        //Logger.Error("Invalid siteNumber: " + siteNumber);
                        //END
                    }
                    else
                    {
                        // We got valid data back about the site. Add it to the cache
                        siteServiceCache.Add(siteNumber, ConvertSite(siteTo));
                    }
                }
                catch (Exception e)
                {
                    //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.Logged other details without by passing the actual issue reported by tool.(p289-OITCOPondiS)
                    Logger.Error("Invalid siteNumber : " + e.Message);
                    //Logger.Error("Invalid siteNumber: " + siteNumber, e);
                    //END
                }
            }

            if (siteServiceCache.ContainsKey(siteNumber))
            {
                return siteServiceCache[siteNumber];
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Gets all va sites.
        /// </summary>
        /// <returns>
        /// A list of all sites
        /// </returns>
        public static List<Site> GetVASites()
        {
            var sites = new List<Site>();
            siteService.Url = GetSiteServiceUrl();
            ImagingExchangeSiteTO[] siteTo = siteService.getImagingExchangeSites();
            foreach (ImagingExchangeSiteTO s in siteTo)
            {
                if ((s.acceleratorPort > 0) && (s.acceleratorServer.Length > 0))
                {
                    sites.Add(ConvertSite(s));
                }
            }

            return sites;
        }

        #endregion

        #region Methods

        /// <summary>
        /// Converts the site.
        /// </summary>
        /// <param name="siteTo">The site to.</param>
        /// <returns>The converted site</returns>
        private static Site ConvertSite(ImagingExchangeSiteTO siteTo)
        {
            var site = new Site(siteTo.siteNumber, siteTo.siteName, siteTo.siteAbbr)
                {
                    VistaHost = siteTo.vistaServer,
                    VistaPort = siteTo.vistaPort,
                    VixHost = siteTo.acceleratorServer,
                    VixPort = siteTo.acceleratorPort
                };
            return site;
        }

        /// <summary>
        /// Gets the site service URL.
        /// </summary>
        /// <returns>the site service URL</returns>
        private static string GetSiteServiceUrl()
        {
            return "http://" + SiteServiceIpAddress + "/VistaWebSvcs/ImagingExchangeSiteService.asmx";
        }

        #endregion
    }
}