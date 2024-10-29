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
namespace ImagingClient.Infrastructure.StorageDataSource
{
    using ImagingClient.Infrastructure.Rest;
    using ImagingClient.Infrastructure.Storage.Model;
    using ImagingClient.Infrastructure.User.Model;

    /// <summary>
    /// The storage data source.
    /// </summary>
    public class StorageDataSource : IStorageDataSource
    {
        #region Constants and Fields

        /// <summary>
        /// The storage service url.
        /// </summary>
        private string storageServiceUrl = "StorageWebApp";

        #endregion

        #region Public Methods

        /// <summary>
        /// Gets the current write location.
        /// </summary>
        /// <returns>
        /// The current write location for the division
        /// </returns>
        public NetworkLocationInfo GetCurrentWriteLocation()
        {
            string resourcePath = string.Format(
                "networkLocationInfo/getCurrentWriteLocation?siteNumber={0}", UserContext.UserCredentials.SiteNumber);
            return RestUtils.DoGetObject<NetworkLocationInfo>(this.storageServiceUrl, resourcePath);
        }

        /// <summary>
        /// Get network location details given an ien.
        /// </summary>
        /// <param name="ien">The ien.</param>
        /// <returns>
        /// The network location info for the specified ien
        /// </returns>
        public NetworkLocationInfo GetNetworkLocationDetails(string ien)
        {
            string resourcePath = string.Format(
                "networkLocationInfo/getNetworkLocationDetails?networkLocationIen={0}", ien);
            return RestUtils.DoGetObject<NetworkLocationInfo>(this.storageServiceUrl, resourcePath);
        }

        #endregion
    }
}