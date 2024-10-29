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
    /// <summary>
    /// The user.
    /// </summary>
    public class User
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="User"/> class.
        /// </summary>
        /// <param name="fullname">
        /// The fullname.
        /// </param>
        /// <param name="duz">
        /// The duz.
        /// </param>
        /// <param name="ssn">
        /// The ssn.
        /// </param>
        /// <param name="site">
        /// The site.
        /// </param>
        public User(string fullname, string duz, string ssn, Site site)
        {
            this.Fullname = fullname;
            this.Duz = duz;
            this.Ssn = ssn;
            this.Site = site;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets Duz.
        /// </summary>
        public string Duz { get; private set; }

        /// <summary>
        /// Gets Fullname.
        /// </summary>
        public string Fullname { get; private set; }

        /// <summary>
        /// Gets Site.
        /// </summary>
        public Site Site { get; private set; }

        /// <summary>
        /// Gets Ssn.
        /// </summary>
        public string Ssn { get; private set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// Returns a <see cref="System.String"/> that represents this instance.
        /// </summary>
        /// <returns>
        /// A <see cref="System.String"/> that represents this instance.
        /// </returns>
        public override string ToString()
        {
            return this.Fullname;
        }

        #endregion
    }
}