// -----------------------------------------------------------------------
// <copyright file="ISiteConnectionInfoDataSource.cs" company="Department of Veterans Affairs">
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
    using VistA.Imaging.ComponentModel;
    using VistA.Imaging.Models;

    /// <summary>
    /// Site Connection information
    /// </summary>
    public interface ISiteConnectionInfoDataSource
    {
        /// <summary>
        /// Occurs when GetById has completed.
        /// </summary>
        event EventHandler<AsyncCompletedEventArgs<SiteConnectionInfo>> GetByIdCompleted;

        #region Synchronous Methods
#if SILVERLIGHT
#else
        // for non silverlight

        /// <summary>
        /// Gets connection information for all sites
        /// </summary>
        /// <returns>Connection information for all sites</returns>
        IEnumerable<SiteConnectionInfo> GetAll();

        /// <summary>
        /// Gets the connection information for the specified site Id.
        /// </summary>
        /// <param name="id">The id of the site</param>
        /// <returns>The connection information for the specified site.</returns>
        SiteConnectionInfo GetById(string id);

        /// <summary>
        /// Gets the connection information for all sites within the specified VISN.
        /// </summary>
        /// <param name="visnId">The VISN id.</param>
        /// <returns>Connection information for all sites within the specified VISN.</returns>
        IEnumerable<SiteConnectionInfo> GetByVISN(string visnId);
#endif
        #endregion

        #region Asynchronous Methods

        /// <summary>
        /// Gets the SiteConnectionInfo by id asynchronously.
        /// </summary>
        /// <param name="id">The id.</param>
        /// <param name="userState">State of the user.</param>
        void GetByIdAsync(string id, object userState = null);

        #endregion
    }
}
