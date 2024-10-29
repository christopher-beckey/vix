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


using System;
using System.Configuration;
using ImagingClient.Infrastructure.Rest;
using ImagingClient.Infrastructure.Storage.Model;
using ImagingClient.Infrastructure.User.Model;

namespace ImagingClient.Infrastructure.StorageDataSource
{
    public class StorageDataSource : IStorageDataSource
    {
        private String StorageServiceUrl = "StorageWebApp";

        public NetworkLocationInfo GetCurrentWriteLocation()
        {
            String resourcePath = String.Format("networkLocationInfo/getCurrentWriteLocation?siteNumber={0}", UserContext.UserCredentials.PlaceId);
            return RestUtils.DoGetObject<NetworkLocationInfo>(StorageServiceUrl, resourcePath);
        }

        public NetworkLocationInfo GetNetworkLocationDetails(string ien)
        {
            String resourcePath = String.Format("networkLocationInfo/getNetworkLocationDetails?networkLocationIen={0}", ien);
            return RestUtils.DoGetObject<NetworkLocationInfo>(StorageServiceUrl, resourcePath);
        }
    }
}
