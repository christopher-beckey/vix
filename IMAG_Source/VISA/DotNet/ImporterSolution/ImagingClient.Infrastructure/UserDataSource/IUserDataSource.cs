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
namespace ImagingClient.Infrastructure.UserDataSource
{
    using System.Collections.ObjectModel;

    using ImagingClient.Infrastructure.User.Model;
    using ImagingClient.Infrastructure.Model;

    /// <summary>
    /// The i user data source.
    /// </summary>
    public interface IUserDataSource
    {
        #region Public Methods

        /// <summary>
        /// Authenticates the user.
        /// </summary>
        /// <param name="accessCode">The access code.</param>
        /// <param name="verifyCode">The verify code.</param>
        void AuthenticateUser(string accessCode, string verifyCode);

        /// <summary>
        /// Authenticates the user.
        /// </summary>
        /// <param name="xmlToken">PIV/PIN XML Token from IAM.</param>
        void AuthenticatePivUser(string xmlToken);

        /// <summary>
        /// Authenticates the user.
        /// </summary>
        void AuthenticateBseUser();

        /// <summary>
        /// Gets the the time, in seconds, that the application can be idle before
        /// the login screen is displayed.
        /// </summary>
        /// <returns>
        ///  The length of time, in seconds before an application timeout can occur.
        /// </returns>
        ApplicationTimeoutParameters GetApplicationTimeout();

        /// <summary>
        /// Gets a collection of divisions accessible by the user.
        /// </summary>
        /// <param name="accessCode">The access code.</param>
        /// <returns>a collection of divisions accessible by the user</returns>
        ObservableCollection<Division> GetDivisionList(string accessCode);

        /// <summary>
        /// Gets the welcome message.
        /// </summary>
        /// <returns>The welcome message string</returns>
        string GetWelcomeMessage();

        #endregion
    }
}