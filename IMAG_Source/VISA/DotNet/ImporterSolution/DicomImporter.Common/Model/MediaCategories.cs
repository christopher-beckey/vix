/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 05/20/2013
 * Site Name:  Washington OI Field Office, Columbia, MD
 * Developer:  Lenard Williams
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
    using System;

    /// <summary>
    /// Contains the different media categories allowed in the
    /// DICOM Importer.
    /// </summary>
    public static class MediaCategories
    {
        #region Constants and Fields

        public const string DICOM = "DICOM";

        public const string Mixed = "Mixed";

        public const string NonDICOM = "NonDICOM";

        #endregion

        #region Public Methods

        /// <summary>
        /// Determines whether [is media category] [the specified media category].
        /// </summary>
        /// <param name="mediaCategory">The media category.</param>
        /// <returns>
        ///   <c>true</c> if [is media category] [the specified media category]; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsMediaCategory(string mediaCategory)
        {
            switch (mediaCategory)
            {
                case DICOM:
                case Mixed:
                case NonDICOM:
                    return true;
            }

            return false;
        }

        #endregion
    }
}
