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
    /// Status codes representing the results of DICOM media validation.
    /// </summary>
    public class DicomMediaValidationStatusCodes
    {
        #region Constants and Fields

        /// <summary>
        /// The media has a DICOMDIR directory and the DICOMDIR file is valid.
        /// </summary>
        public const int MediaValid = 0;

        /// <summary>
        /// The media has no DICOMDIR file.
        /// </summary>
        public const int DicomDirMissing = -1;

        /// <summary>
        /// The media has a DICOMDIR file, but it does not match the SOP Instances found
        /// on the media. For example, some of the files specified in the DICOMDIR file
        /// do not exist on the media, etc.
        /// </summary>
        public const int InvalidDicomDir = -2;

        #endregion
    }
}