// -----------------------------------------------------------------------
// <copyright file="ISiteConnectionInfoFacade.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Facades
{
    using System;
    using VistA.Imaging.ComponentModel;
    using VistA.Imaging.Models;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public interface ISiteConnectionInfoFacade
    {
        /// <summary>
        /// Occurs when GetById completes.
        /// </summary>
        event EventHandler<AsyncCompletedEventArgs<SiteConnectionInfo>> GetByIdCompleted;

        /// <summary>
        /// Gets the by id async.
        /// </summary>
        /// <param name="id">The id.</param>
        /// <param name="userState">State of the user.</param>
        void GetByIdAsync(string id, object userState = null);
    }
}
