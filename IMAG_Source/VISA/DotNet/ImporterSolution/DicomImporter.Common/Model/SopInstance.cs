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
    using System;
    using System.ComponentModel;
    using System.Xml.Serialization;

    /// <summary>
    /// The sop instance.
    /// </summary>
    [Serializable]
    public class SopInstance : INotifyPropertyChanged
    {
        // The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        #region Public Events

        /// <summary>
        /// The property changed.
        /// </summary>
        [field: NonSerialized]//P237 - Critical fix - Avoid  arbitrary code execution vulnerability on or after the deserialization of this class.
        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets DisplayName.
        /// </summary>
        public string DisplayName
        {
            get
            {
                return "Image " + this.ImageNumber;
            }
        }

        /// <summary>
        /// Gets or sets FilePath.
        /// </summary>
        public string FilePath { get; set; }

        /// <summary>
        /// Gets or sets ImageNumber.
        /// </summary>
        public string ImageNumber { get; set; }

        /// <summary>
        /// Gets or sets the import error message.
        /// </summary>
        /// <value>
        /// The import error message.
        /// </value>
        public string ImportErrorMessage { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether IsImportedSuccessfully.
        /// </summary>
        public bool IsImportedSuccessfully { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether IsStaged.
        /// </summary>
        [XmlIgnore]
        public bool IsStaged { get; set; }

        /// <summary>
        /// Gets or sets NumberOfFrames.
        /// </summary>
        public string NumberOfFrames { get; set; }

        /// <summary>
        /// Gets or sets SopClassUid.
        /// </summary>
        public string SopClassUid { get; set; }

        /// <summary>
        /// Gets or sets TransferSyntaxUid.
        /// </summary>
        public string TransferSyntaxUid { get; set; }

        /// <summary>
        /// Gets or sets Uid.
        /// </summary>
        public string Uid { get; set; }

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
            return this.Uid;
        }

        #endregion
    }
}