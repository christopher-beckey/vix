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
namespace DicomImporter.Common.User
{
    /// <summary>
    /// The importer security keys.
    /// </summary>
    public class ImporterSecurityKeys
    {
        #region Constants and Fields

        /// <summary>
        /// The administrator key.
        /// </summary>
        public const string Administrator = "MAGV IMPORT RECON ARTIFACT";

        /// <summary>
        /// The advanced staging key.
        /// </summary>
        public const string AdvancedStaging = "MAGV IMPORT STAGE MEDIA ADV";

        /// <summary>
        /// The contracted studies key.
        /// </summary>
        public const string ContractedStudies = "MAGV IMPORT RECON CONTRACT";

        /// <summary>
        /// The reports key.
        /// </summary>
        public const string Reports = "MAGV IMPORT REPORTS";

        /// <summary>
        /// The staging key.
        /// </summary>
        public const string Staging = "MAGV IMPORT MEDIA STAGER";

        #endregion
    }
}