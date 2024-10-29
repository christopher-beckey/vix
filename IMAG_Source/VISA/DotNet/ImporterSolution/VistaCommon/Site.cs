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
    /// The site.
    /// </summary>
    public class Site
    {
        #region Constructors and Destructors

        public Site() { }

        /// <summary>
        /// Initializes a new instance of the <see cref="Site"/> class.
        /// </summary>
        /// <param name="siteNumber">
        /// The site number.
        /// </param>
        /// <param name="siteName">
        /// The site name.
        /// </param>
        /// <param name="siteAbbreviation">
        /// The site abbreviation.
        /// </param>
        /// <param name="vistaHost">
        /// The vista host.
        /// </param>
        /// <param name="vistaPort">
        /// The vista port.
        /// </param>
        /// <param name="vixHost">
        /// The vix host.
        /// </param>
        /// <param name="vixPort">
        /// The vix port.
        /// </param>
        public Site(
            string siteNumber, 
            string siteName, 
            string siteAbbreviation, 
            string vistaHost, 
            int vistaPort, 
            string vixHost, 
            int vixPort)
        {
            this.SiteName = siteName;
            this.SiteNumber = siteNumber;
            this.VistaHost = vistaHost;
            this.VixHost = vixHost;
            this.VistaPort = vistaPort;
            this.VixPort = vixPort;
            this.SiteAbbreviation = siteAbbreviation;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Site"/> class.
        /// </summary>
        /// <param name="siteNumber">
        /// The site number.
        /// </param>
        /// <param name="siteName">
        /// The site name.
        /// </param>
        /// <param name="siteAbbreviation">
        /// The site abbreviation.
        /// </param>
        public Site(string siteNumber, string siteName, string siteAbbreviation)
            : this(siteNumber, siteName, siteAbbreviation, string.Empty, 0, string.Empty, 0)
        {
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets SiteAbbreviation.
        /// </summary>
        public string SiteAbbreviation { get; set; }

        /// <summary>
        /// Gets SiteName.
        /// </summary>
        public string SiteName { get; set; }

        /// <summary>
        /// Gets SiteNumber.
        /// </summary>
        public string SiteNumber { get; set; }

        /// <summary>
        /// Gets PrimarySiteNumber.
        /// </summary>
        public string PrimarySiteNumber { get; set; }

        /// <summary>
        /// Gets or sets VistaHost.
        /// </summary>
        public string VistaHost { get; set; }

        /// <summary>
        /// Gets or sets VistaPort.
        /// </summary>
        public int VistaPort { get; set; }

        /// <summary>
        /// Gets or sets VixHost.
        /// </summary>
        public string VixHost { get; set; }

        /// <summary>
        /// Gets or sets VixPort.
        /// </summary>
        public int VixPort { get; set; }

        /// <summary>
        /// Gets or sets IsProductionAccount.
        /// </summary>
        public bool IsProductionAccount { get; set; }

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
            return this.SiteName;
        }

        #endregion
    }
}