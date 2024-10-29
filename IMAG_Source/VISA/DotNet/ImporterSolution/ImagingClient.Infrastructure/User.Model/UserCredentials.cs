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
    using System.Collections.Generic;

    /// <summary>
    /// The user credentials.
    /// </summary>
    public class UserCredentials
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="UserCredentials"/> class.
        /// </summary>
        public UserCredentials()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="UserCredentials"/> class.
        /// </summary>
        /// <param name="accessCode">
        /// The access code.
        /// </param>
        /// <param name="verifyCode">
        /// The verify code.
        /// </param>
        public UserCredentials(string accessCode, string verifyCode)
        {
            this.AccessCode = accessCode;
            this.VerifyCode = verifyCode;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets AccessCode.
        /// </summary>
        public string AccessCode { get; set; }

        /// <summary>
        /// Gets or sets CurrentDivision.
        /// </summary>
        public Division CurrentDivision { get; set; }

        /// <summary>
        /// Gets or sets Duz.
        /// </summary>
        public string Duz { get; set; }

        /// <summary>
        /// Gets or sets Fullname.
        /// </summary>
        public string Fullname { get; set; }

        public string Initials { get; set; }

        public string SecurityToken { get; set; }

        /// <summary>
        /// Gets or sets SecurityKeys.
        /// </summary>
        public List<string> SecurityKeys { get; set; }

        /// <summary>
        /// Gets or sets SiteName.
        /// </summary>
        public string SiteName { get; set; }

        /// <summary>
        /// Gets or sets SiteNumber.
        /// </summary>
        public string SiteNumber { get; set; }

        /// <summary>
        /// Gets or sets Ssn.
        /// </summary>
        public string Ssn { get; set; }

        /// <summary>
        /// Gets or sets VerifyCode.
        /// </summary>
        public string VerifyCode { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// Determines whether or not a user has a key.
        /// </summary>
        /// <param name="key">The key.</param>
        /// <returns><c>true</c> if the user has the specified key; otherwise <c>false</c></returns>
        public bool UserHasKey(string key)
        {
            if (this.SecurityKeys == null)
                return false;
            return this.SecurityKeys.Contains(key);
        }

        #endregion
    }
}