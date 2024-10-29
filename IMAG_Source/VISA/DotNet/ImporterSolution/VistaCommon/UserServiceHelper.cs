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
    using System.Net;

    using VistaCommon.UserService;

    /// <summary>
    /// The user service helper.
    /// </summary>
    public class UserServiceHelper
    {
        #region Constants and Fields

        /// <summary>
        /// The user service.
        /// </summary>
        private static readonly ImageUserService userService = new ImageUserService();

        #endregion

        #region Public Methods

        /// <summary>
        /// Logins the specified site.
        /// </summary>
        /// <param name="site">The site.</param>
        /// <param name="access">The access.</param>
        /// <param name="verify">The verify.</param>
        /// <returns>The user object</returns>
        public static User Login(Site site, string access, string verify)
        {
            userService.Url = "http://" + site.VixHost + ":" + site.VixPort
                              + "/ImagingWebApp/user-ws/ImageUserSoapBinding";
            string transactionId = Guid.NewGuid().ToString();
            string duz;
            string ssn;
            string siteName;
            string siteNumber;

            userService.Credentials = new NetworkCredential(access, verify);
            string fullname = userService.authenticateUser(transactionId, out duz, out ssn, out siteName, out siteNumber);

            var user = new User(fullname, duz, ssn, site);
            return user;
        }

        #endregion
    }
}