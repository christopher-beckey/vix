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
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Linq;

    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;

    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Events;

    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// The ordering location lookup view model.
    /// </summary>
    public class OrderingLocationLookupViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The location.
        /// </summary>
        private OrderingLocation location;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="OrderingLocationLookupViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public OrderingLocationLookupViewModel(
            IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;

            this.PerformSearchCommand = new DelegateCommand<object>(o => this.PeformFilter());

            this.OkCommand = new DelegateCommand<object>(o => this.PeformOk(), o => this.IsOkButtonEnabled());

            this.CancelCommand = new DelegateCommand<object>(o => this.PeformCancel());
        }

        #endregion

        #region Delegates

        /// <summary>
        /// The window action event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public delegate void WindowActionEventHandler(object sender, WindowActionEventArgs e);

        #endregion

        #region Public Events

        /// <summary>
        /// The window action.
        /// </summary>
        public event WindowActionEventHandler WindowAction;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets AllLocations.
        /// </summary>
        public ObservableCollection<OrderingLocation> AllLocations { get; set; }

        /// <summary>
        /// Gets or sets CancelCommand.
        /// </summary>
        public DelegateCommand<object> CancelCommand { get; set; }


        //Commented since binding element {NotifyPropertyWeaverMsBuildTask} is no longer available in VS 2015 and above versions. (p289-OITCOPondiS)  /// <summary>
        /// Gets or sets MatchingLocations.
        /// </summary>
        //public ObservableCollection<OrderingLocation> MatchingLocations { get; set; }

        //BEGIN-Modified RequestedStatus MatchingLocations to bind Textbox. Earlier binding made through imlementing library {NotifyPropertyWeaverMsBuildTask}.(p289-OITCOPondiS)  
        private ObservableCollection<OrderingLocation> _MatchingLocations { get; set; }

        public ObservableCollection<OrderingLocation> MatchingLocations
        {
            get { return _MatchingLocations; }
            set
            {

                _MatchingLocations = value;
                this.RaisePropertyChanged("MatchingLocations");
            }
        }
        //END




        /// <summary>
        /// Gets or sets OkCommand.
        /// </summary>
        public DelegateCommand<object> OkCommand { get; set; }

        /// <summary>
        /// Gets or sets PerformSearchCommand.
        /// </summary>
        public DelegateCommand<object> PerformSearchCommand { get; set; }

        /// <summary>
        /// Gets or sets SearchCriteria.
        /// </summary>
        public string SearchCriteria { get; set; }

        /// <summary>
        /// Gets or sets SelectedLocation.
        /// </summary>
        public OrderingLocation SelectedLocation
        {
            get
            {
                return this.location;
            }

            set
            {
                this.location = value;
                //Added RaisePropertyChanged event handler to retain file path in text box.Earlier raising events are handled through imlementing library {NotifyPropertyWeaverMsBuildTask}(p289-OITCOPondiS)
                this.RaisePropertyChanged("SelectedLocation");
                this.OkCommand.RaiseCanExecuteChanged();
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// The peform filter.
        /// </summary>
        public void PeformFilter()
        {
            if (this.SearchCriteria == null)
            {
                this.SearchCriteria = string.Empty;
            }

            this.MatchingLocations =
                new ObservableCollection<OrderingLocation>(
                    from matchingLocation in this.AllLocations
                    where matchingLocation.Name.ToLower().Contains(this.SearchCriteria.ToLowerInvariant())
                    select matchingLocation);

            IEnumerable<OrderingLocation> containsKeyword = from matchingLocation in this.AllLocations
                                                            where
                                                                matchingLocation.Name.ToLower().Contains(
                                                                    this.SearchCriteria.ToLowerInvariant())
                                                                && !this.MatchingLocations.Contains(matchingLocation)
                                                            select matchingLocation;

            foreach (OrderingLocation matchingLocation in containsKeyword)
            {
                this.MatchingLocations.Add(matchingLocation);
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Determines whether if ok button is enabled.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if ok button is enabled; otherwise, <c>false</c>.
        /// </returns>
        private bool IsOkButtonEnabled()
        {
            return this.SelectedLocation != null;
        }

        /// <summary>
        /// The peform cancel.
        /// </summary>
        private void PeformCancel()
        {
            this.WindowAction(this, new WindowActionEventArgs(false));
        }

        /// <summary>
        /// The peform ok.
        /// </summary>
        private void PeformOk()
        {
            this.WindowAction(this, new WindowActionEventArgs(true));
        }

        #endregion
    }
}