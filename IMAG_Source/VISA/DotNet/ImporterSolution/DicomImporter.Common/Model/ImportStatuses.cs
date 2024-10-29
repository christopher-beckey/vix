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
namespace DicomImporter.Common.Model
{
    /// <summary>
    /// The import statuses.
    /// </summary>
    public class ImportStatuses
    {
        #region Constants and Fields

        /// <summary>
        /// The "complete" status. Indicates that all of the images in the study are
        /// already on VistA
        /// </summary>
        public const string Complete = "Complete";

        /// <summary>
        /// The "none" status. Indicates that none of the images in the study are
        /// already on VistA
        /// </summary>
        public const string None = "None";

        /// <summary>
        /// The "partial" status. Indicates that some of the images in the study are
        /// already on VistA
        /// </summary>
        public const string Partial = "Partial";

        #endregion
    }
}