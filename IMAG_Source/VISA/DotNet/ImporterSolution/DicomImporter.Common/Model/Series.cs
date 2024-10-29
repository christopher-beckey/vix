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
    using System.Collections.ObjectModel;
    using System.ComponentModel;

    /// <summary>
    /// The series.
    /// </summary>
    [Serializable]
    public class Series : INotifyPropertyChanged
    {
        // The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        #region Constants and Fields

        /// <summary>
        /// The institution address.
        /// </summary>
        private string institutionAddress;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="Series"/> class.
        /// </summary>
        public Series()
        {
            this.SopInstances = new ObservableCollection<SopInstance>();
        }

        #endregion

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
                string displayName;
                if (this.SopInstances.Count == 1)
                {
                    displayName = string.Format(
                        "Series {0}: {1} {2} instance.", this.SeriesNumber, this.SopInstances.Count, this.Modality);
                }
                else
                {
                    displayName = string.Format(
                        "Series {0}: {1} {2} instances.", this.SeriesNumber, this.SopInstances.Count, this.Modality);
                }

                return displayName;
            }
        }

        /// <summary>
        /// Gets or sets Facility.
        /// </summary>
        public string Facility { get; set; }

        /// <summary>
        /// Gets or sets InstitutionAddress.
        /// </summary>
        public string InstitutionAddress
        {
            get
            {
                // Replace any carriage returns, etc, with spaces.
                this.institutionAddress += string.Empty;
                this.institutionAddress = this.institutionAddress.Replace("\r\n", " ");
                this.institutionAddress = this.institutionAddress.Replace("\r", " ");
                this.institutionAddress = this.institutionAddress.Replace("\n", " ");
                return this.institutionAddress;
            }

            set
            {
                this.institutionAddress = value;
            }
        }

        /// <summary>
        /// Gets or sets Modality.
        /// </summary>
        public string Modality { get; set; }

        /// <summary>
        /// Gets or sets SeriesDate.
        /// </summary>
        public string SeriesDate { get; set; }

        /// <summary>
        /// Gets or sets SeriesDescription.
        /// </summary>
        public string SeriesDescription { get; set; }

        /// <summary>
        /// Gets or sets SeriesNumber.
        /// </summary>
        public string SeriesNumber { get; set; }

        /// <summary>
        /// Gets or sets SopInstances.
        /// </summary>
        public ObservableCollection<SopInstance> SopInstances { get; set; }

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