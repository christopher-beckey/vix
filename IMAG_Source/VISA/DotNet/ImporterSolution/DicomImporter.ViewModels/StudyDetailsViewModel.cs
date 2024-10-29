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
namespace DicomImporter.ViewModels
{
    using System.Collections.ObjectModel;

    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;

    using ImagingClient.Infrastructure.Model;
    using ImagingClient.Infrastructure.Storage.Model;
    using ImagingClient.Infrastructure.StorageDataSource;

    /// <summary>
    /// The study details view model.
    /// </summary>
    public class StudyDetailsViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The selected item.
        /// </summary>
        private object selectedItem;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="StudyDetailsViewModel"/> class.
        /// </summary>
        /// <param name="storageDataSource">
        /// The storage data source.
        /// </param>
        public StudyDetailsViewModel(IStorageDataSource storageDataSource)
        {
            this.StorageDataSource = storageDataSource;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets FilePath.
        /// </summary>
        public string FilePath { get; set; }

        /// <summary>
        /// Gets a value indicating whether ImageLoaded.
        /// </summary>
        public bool ImageLoaded
        {
            get
            {
                return !string.IsNullOrEmpty(this.FilePath);
            }
        }

        /// <summary>
        /// Gets or sets ImageText.
        /// </summary>
        public string ImageText { get; set; }

        /// <summary>
        /// Gets NetworkLocationInfo.
        /// </summary>
        public NetworkLocationInfo NetworkLocationInfo
        {
            get
            {
                return this.StorageDataSource.GetNetworkLocationDetails(this.WorkItemDetails.NetworkLocationIen);
            }
        }

        /// <summary>
        /// Gets or sets Patient.
        /// </summary>
        public Patient Patient { get; set; }

        /// <summary>
        /// Gets or sets SelectedItem.
        /// </summary>
        public object SelectedItem
        {
            get
            {
                return this.selectedItem;
            }

            set
            {
                if (this.selectedItem == value)
                {
                    return;
                }

                this.selectedItem = value;

                if (this.selectedItem is Study)
                {
                    this.ImageText = ((Study)value).Uid;
                    this.FilePath = string.Empty;
                }

                if (this.selectedItem is Series)
                {
                    this.ImageText = ((Series)value).Uid;
                    this.FilePath = string.Empty;
                }

                if (this.selectedItem is SopInstance)
                {
                    var sopInstance = (SopInstance)value;
                    this.ImageText = sopInstance.Uid;
                    this.FilePath = sopInstance.FilePath;
                }

                this.RaisePropertyChanged("ImageLoaded");
            }
        }

        /// <summary>
        /// Gets or sets Studies.
        /// </summary>
        public ObservableCollection<Study> Studies { get; set; }

        #endregion
    }
}