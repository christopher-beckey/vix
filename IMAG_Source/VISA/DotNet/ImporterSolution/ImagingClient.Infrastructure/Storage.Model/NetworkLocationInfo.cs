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
namespace ImagingClient.Infrastructure.Storage.Model
{
    /// <summary>
    /// The network location info.
    /// </summary>
    public class NetworkLocationInfo
    {
        #region Public Properties

        /// <summary>
        /// Gets or sets Id.
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets Password.
        /// </summary>
        public string Password { get; set; }

        /// <summary>
        /// Gets or sets PhysicalPath.
        /// </summary>
        public string PhysicalPath { get; set; }

        /// <summary>
        /// Gets or sets PlaceId.
        /// </summary>
        public int PlaceId { get; set; }

        /// <summary>
        /// Gets or sets Username.
        /// </summary>
        public string Username { get; set; }

        /// <summary>
        /// Gets or sets WriteLocationIEN.
        /// </summary>
        public string WriteLocationIEN { get; set; }

        #endregion
    }
}