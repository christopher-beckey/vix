// -----------------------------------------------------------------------
// <copyright file="SiteConnectionInfoDataSource.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 11/30/2011
//   Site Name:  Washington OI Field Office, Silver Spring, MD
//   Developer: vhaiswgraver
//   Description: 
//         ;; +--------------------------------------------------------------------+
//         ;; Property of the US Government.
//         ;; No permission to copy or redistribute this software is given.
//         ;; Use of unreleased versions of this software requires the user
//         ;;  to execute a written test agreement with the VistA Imaging
//         ;;  Development Office of the Department of Veterans Affairs,
//         ;;  telephone (301) 734-0100.
//         ;;
//         ;; The Food and Drug Administration classifies this software as
//         ;; a Class II medical device.  As such, it may not be changed
//         ;; in any way.  Modifications to this software may result in an
//         ;; adulterated medical device under 21CFR820, the use of which
//         ;; is considered to be a violation of US Federal Statutes.
//         ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataSources
{
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Linq;
    using NLog;
    using VistA.Imaging.ComponentModel;
    using VistA.Imaging.Models;
    using VistA.Imaging.Services.SiteService.ImagingExchange;

    /// <summary>
    /// Data access component for loading site connection information
    /// </summary>
    public class SiteConnectionInfoDataSource : CachingDataSource<SiteConnectionInfo, string>, ISiteConnectionInfoDataSource
    {
        /// <summary>
        /// The logger
        /// </summary>
        private readonly Logger logger = LogManager.GetCurrentClassLogger();

        /// <summary>
        /// Imageing Exchange Site Service
        /// </summary>
        private ImagingExchangeSiteServiceSoapClient imageingExchangeSiteServiceClient;

        /// <summary>
        /// Initializes a new instance of the <see cref="SiteConnectionInfoDataSource"/> class.
        /// </summary>
        /// <param name="imageingExchangeSiteServiceClient">The ie site service.</param>
        public SiteConnectionInfoDataSource(ImagingExchangeSiteServiceSoapClient imageingExchangeSiteServiceClient)
        {
            this.imageingExchangeSiteServiceClient = imageingExchangeSiteServiceClient;
            this.imageingExchangeSiteServiceClient.getSiteCompleted += new EventHandler<getSiteCompletedEventArgs>(this.ImageingExchangeSiteServiceClient_GetSiteCompleted);
        }

        /// <summary>
        /// Occurs when GetById has completed.
        /// </summary>
        public event EventHandler<AsyncCompletedEventArgs<SiteConnectionInfo>> GetByIdCompleted;

        #region Synchronous Public Methods

#if SILVERLIGHT
#else
        /// <summary>
        /// Gets the connection information for the specified site Id.
        /// </summary>
        /// <param name="id">The id of the site</param>
        /// <returns>The connection information for the specified site.</returns>
        public override SiteConnectionInfo GetById(string id)
        {
            if (this.Cache.Keys.Contains(id))
            {
                return this.Cache[id] as SiteConnectionInfo;
            }

            ImagingExchangeSiteTO response = this.imageingExchangeSiteServiceClient.getSite(id);
            SiteConnectionInfo site = this.Convert(response);
            this.Cache.Add(id, site);
            return site;
        }

        /// <summary>
        /// Gets connection information for all sites
        /// </summary>
        /// <returns>Connection information for all sites</returns>
        public IEnumerable<SiteConnectionInfo> GetAll()
        {
            ObservableCollection<ImagingExchangeSiteTO> response = this.imageingExchangeSiteServiceClient.getImagingExchangeSites();
            foreach (ImagingExchangeSiteTO siteTo in response)
            {
                yield return this.Convert(siteTo);
            }
        }

        /// <summary>
        /// Gets the connection information for all sites within the specified VISN.
        /// </summary>
        /// <param name="visnId">The VISN id.</param>
        /// <returns>Connection information for all sites within the specified VISN.</returns>
        public IEnumerable<SiteConnectionInfo> GetByVISN(string visnId)
        {
            ImagingExchangeRegionTO response = this.imageingExchangeSiteServiceClient.getVISN(visnId);
            foreach (ImagingExchangeSiteTO siteTo in response.sites)
            {
                yield return this.Convert(siteTo);
            }
        }

#endif

        #endregion

        #region Asynchronous Public Methods

        /// <summary>
        /// Gets the SiteConnectionInfo by id asynchronously.
        /// </summary>
        /// <param name="id">The id.</param>
        /// <param name="userState">State of the user.</param>
        public void GetByIdAsync(string id, object userState = null)
        {
            if (this.Cache.ContainsKey(id))
            {
                this.GetByIdCompleted.SafelyRaise(this, new AsyncCompletedEventArgs<SiteConnectionInfo>(this.Cache[id] as SiteConnectionInfo, null, false, userState));
            }
            else
            {
                this.imageingExchangeSiteServiceClient.getSiteAsync(id, userState);
            }
        }

        #endregion

        /// <summary>
        /// Handles the getSiteCompleted event of ImageingExchangeSiteServiceClient.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="VistA.Imaging.Services.SiteService.ImagingExchange.getSiteCompletedEventArgs"/> instance containing the event data.</param>
        private void ImageingExchangeSiteServiceClient_GetSiteCompleted(object sender, getSiteCompletedEventArgs e)
        {
            SiteConnectionInfo result = null;
            if (e.Error != null)
            {
                this.logger.ErrorException(e.Error.Message, e.Error);
            }
            else if (e.Result != null)
            {
                result = this.Convert(e.Result);
            }

            this.GetByIdCompleted.SafelyRaise(this, new AsyncCompletedEventArgs<SiteConnectionInfo>(result, e.Error, e.Cancelled, e.UserState));
        }

        /// <summary>
        /// Converts the DTO to a local instance.
        /// </summary>
        /// <param name="siteTo">The DTO.</param>
        /// <returns>The local instance.</returns>
        private SiteConnectionInfo Convert(ImagingExchangeSiteTO siteTo)
        {
            SiteConnectionInfo site = new SiteConnectionInfo()
            {
                Abreviation = siteTo.siteAbbr,
                Name = siteTo.siteName,
                Id = siteTo.siteNumber
            };
            site.VistAUri = new Uri("vista://" + siteTo.vistaServer + ":" + siteTo.vistaPort.ToString());
            site.VixUri = new Uri("http://" + siteTo.acceleratorServer + ":" + siteTo.acceleratorPort.ToString());
            return site;
        }
    }
}
