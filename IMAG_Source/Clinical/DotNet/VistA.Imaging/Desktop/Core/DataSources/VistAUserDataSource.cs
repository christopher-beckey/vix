// -----------------------------------------------------------------------
// <copyright file="VistAUserDataSource.cs" company="Department of Veterans Affairs">
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
    using RestSharp;
    using VistA.Imaging.Models;
    using VistA.Imaging.Security.Principal;

    /// <summary>
    /// Data source for VistA Users
    /// </summary>
    public class VistAUserDataSource : IVistAUserDataSource
    {
        /// <summary>
        /// The path to the service
        /// </summary>
        private static string serviceRoot = "UserWebApp";

        /// <summary>
        /// The path to the getDivisionList service
        /// </summary>
        private static string divisionResourcePath = "user/getDivisionList";

        /// <summary>
        /// Initializes a new instance of the <see cref="VistAUserDataSource"/> class.
        /// </summary>
        /// <param name="siteConnectionInfoDataSource">The site connection info data source.</param>
        public VistAUserDataSource(ISiteConnectionInfoDataSource siteConnectionInfoDataSource)
        {
            this.SiteConnectionInfoDataSource = siteConnectionInfoDataSource;
        }

        /// <summary>
        /// Gets or sets the site connection info data source.
        /// </summary>
        private ISiteConnectionInfoDataSource SiteConnectionInfoDataSource { get; set; }

        /// <summary>
        /// Gets the division list.
        /// </summary>
        /// <param name="credential">The credential.</param>
        /// <returns>
        /// The list of divisions for the user
        /// </returns>
        public IEnumerable<Institution> GetDivisionList(VistAAccessVerifyCredential credential)
        {
            SiteConnectionInfo site = this.SiteConnectionInfoDataSource.GetById(credential.Institution.Id);
            UriBuilder uriBuilder = new UriBuilder(site.VixUri);
            uriBuilder.Path = serviceRoot;
            RestClient client = new RestClient(uriBuilder.Uri.ToString());
            RestRequest request = new RestRequest(divisionResourcePath);
            throw new NotImplementedException();
        }
    }
}
