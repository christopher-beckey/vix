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
    using System.Runtime.InteropServices;

    /// <summary>
    /// The net resource.
    /// </summary>
    [StructLayout(LayoutKind.Sequential)]
    public class NetResource
    {
        /// <summary>
        /// Gets or sets Scope.
        /// </summary>
        public ResourceScope Scope { get; set; }

        /// <summary>
        /// Gets or sets ResourceType.
        /// </summary>
        public ResourceType ResourceType { get; set; }

        /// <summary>
        /// Gets or sets DisplayType.
        /// </summary>
        public ResourceDisplaytype DisplayType { get; set; }

        /// <summary>
        /// Gets or sets Usage.
        /// </summary>
        public int Usage { get; set; }

        /// <summary>
        /// Gets or sets LocalName.
        /// </summary>
        public string LocalName { get; set; }

        /// <summary>
        /// Gets or sets RemoteName.
        /// </summary>
        public string RemoteName { get; set; }

        /// <summary>
        /// Gets or sets Comment.
        /// </summary>
        public string Comment { get; set; }

        /// <summary>
        /// Gets or sets Provider.
        /// </summary>
        public string Provider { get; set; }
    }
}