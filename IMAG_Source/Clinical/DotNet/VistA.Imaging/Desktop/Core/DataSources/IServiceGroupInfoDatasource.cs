// -----------------------------------------------------------------------
// <copyright file="IServiceGroupInfoDatasource.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataSources
{
    using System;
    using System.Collections.Generic;
    using VistA.Imaging.ComponentModel;
    using VistA.Imaging.Models;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public interface IServiceGroupInfoDatasource
    {
        /// <summary>
        /// Occurs when GetBySiteConnectionInfo completed.
        /// </summary>
        event EventHandler<AsyncCompletedEventArgs<IEnumerable<ServiceGroupInfo>>> GetBySiteConnectionInfoCompleted;

        /// <summary>
        /// Gets the ServiceTypeInfo by site connection info asynchronously.
        /// </summary>
        /// <param name="siteConnectionInfo">The site connection info.</param>
        /// <param name="userState">State of the user.</param>
        void GetBySiteConnectionInfoAsync(VistA.Imaging.Models.SiteConnectionInfo siteConnectionInfo, object userState = null);
    }
}
