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
    using System.Xml.Serialization;

    /// <summary>
    /// Contains a media category which is allowed in the DICOM Importer
    /// </summary>
    [Serializable]
    public class MediaCategory
    {
        #region Constants and Fields

        /// <summary>
        /// The media category
        /// </summary>
        private string mediaCategory; 

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="MediaCategory" /> class.
        /// </summary>
        public MediaCategory()
        {
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the category.
        /// </summary>
        public string Category
        {
            get
            {
                return this.mediaCategory;
            }

            set
            {
                // only allows a category to be set if it is in the list of media categories
                if (!MediaCategories.IsMediaCategory(value))
                {
                    throw new Exception("The Media Category \"" + value + "\" is not a valid Media Category.");
                }

                this.mediaCategory = value;
            }
        }

        /// <summary>
        /// Determines whether [is for media staging].
        /// </summary>
        [XmlIgnore]
        public bool IsForMediaStaging { get; set; }

        #endregion
    }
}
