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
namespace ImagingClient.Infrastructure.User.Model
{
    using System;
    using System.Collections.Generic;
    using VistaCommon;

    /// <summary>
    /// The user context.
    /// </summary>
    public static class UserContext
    {
        static UserContext()
        {
            //UserContext._allSites = new List<Site>();
            UserContext.LocalSite = new Site();
            UserContext.ReportLockDurations = new Dictionary<string, int>();
        }

        #region Public Properties
        public static string ServerName { get; set; }

        public static string ServerPort { get; set; }

        public static string ApplicationContext { get; set; }

        public static string SiteServiceUrl { get; set; }

        public static Site LocalSite { get; set; }

        public static Dictionary<string, int> ReportLockDurations { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether IsLoginSuccessful.
        /// </summary>
        public static bool IsLoginSuccessful { get; set; }

        /// <summary>
        /// Gets or sets the last logged in users DUZ.
        /// </summary>
        public static string LastLoggedInUsersDUZ { get; set; }

        /// <summary>
        /// Gets or sets LoginErrorMessage.
        /// </summary>
        public static string LoginErrorMessage { get; set; }

        /// <summary>
        /// The number of seconds that the application can go without
        /// user interaction before it logs out.
        /// </summary>
        public static int SecondsIdleLogout { get; set; }

        /// <summary>
        /// Gets or sets StationNumber.
        /// </summary>
        public static string StationNumber { get; set; }

        /// <summary>
        /// Gets or sets the value indicating whether an inactive user
        /// input timeout occurred..
        /// </summary>
        public static bool TimeoutOccurred { get; set; }

        /// <summary>
        /// Gets or sets UserCredentials.
        /// </summary>
        public static UserCredentials UserCredentials { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// Determines whether or not a user has a key.
        /// </summary>
        /// <param name="key">The key.</param>
        /// <returns><c>true</c> if the user has the specified key; otherwise <c>false</c></returns>
        public static bool UserHasKey(string key)
        {
            return UserCredentials != null && UserCredentials.UserHasKey(key);
        }

        public static void ResetUserContext()
        {
            ServerName = string.Empty;
            ServerPort = string.Empty;
            IsLoginSuccessful = false;
            LoginErrorMessage = string.Empty;
            UserCredentials = new UserCredentials();
            ApplicationContext = string.Empty;
            SiteServiceUrl = string.Empty;
            LocalSite = new Site();
            ReportLockDurations.Clear();
        }

        #endregion
    }
}