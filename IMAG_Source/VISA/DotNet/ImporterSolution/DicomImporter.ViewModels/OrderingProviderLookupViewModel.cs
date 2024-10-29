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
    using System;
    using System.Collections.ObjectModel;

    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;

    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Events;

    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// The ordering provider lookup view model.
    /// </summary>
    public class OrderingProviderLookupViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The provider.
        /// </summary>
        private OrderingProvider provider;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="OrderingProviderLookupViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public OrderingProviderLookupViewModel(
            IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;

            this.PerformSearchCommand = new DelegateCommand<object>(o => this.PeformSearch());

            this.OkCommand = new DelegateCommand<object>(o => this.PeformOk(), o => this.IsOkButtonEnabled());

            this.CancelCommand = new DelegateCommand<object>(o => this.PeformCancel());
        }

        #endregion

        #region Delegates

        /// <summary>
        /// The no results action event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public delegate void NoResultsActionEventHandler(object sender, EventArgs e);

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
        /// The no results action.
        /// </summary>
        public event NoResultsActionEventHandler NoResultsAction;

        /// <summary>
        /// The window action.
        /// </summary>
        public event WindowActionEventHandler WindowAction;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets CancelCommand.
        /// </summary>
        public DelegateCommand<object> CancelCommand { get; set; }

        //Commented since binding element {NotifyPropertyWeaverMsBuildTask} is no longer available in VS 2015 and above versions. (p289-OITCOPondiS) 
        ///// <summary>
        ///// Gets or sets MatchingProviders.
        ///// </summary>
        //public ObservableCollection<OrderingProvider> MatchingProviders { get; set; }

        //BEGIN-Modified MatchingProviders property to bind control. Earlier binding made through imlementing library {NotifyPropertyWeaverMsBuildTask}.(p289-OITCOPondiS) 
        /// <summary>
        /// Gets or sets MatchingProviders.
        /// </summary>
        private ObservableCollection<OrderingProvider> _MatchingProviders { get; set; }

        public ObservableCollection<OrderingProvider> MatchingProviders
        {
            get { return _MatchingProviders; }
            set
            {

                _MatchingProviders = value;
                this.RaisePropertyChanged("MatchingProviders");
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
        /// Gets or sets SelectedProvider.
        /// </summary>
        public OrderingProvider SelectedProvider
        {
            get
            {
                return this.provider;
            }

            set
            {
                this.provider = value;
                this.OkCommand.RaiseCanExecuteChanged();
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Determines whether the ok button is enabled.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if the ok button is enabled; otherwise, <c>false</c>.
        /// </returns>
        private bool IsOkButtonEnabled()
        {
            return this.SelectedProvider != null;
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

        /// <summary>
        /// The peform search.
        /// </summary>
        private void PeformSearch()
        {
            if (this.SearchCriteria == null)
            {
                this.SearchCriteria = string.Empty;
            }

            if (this.SearchCriteria.Trim().Length == 0)
            {
                string message = "Please enter at least one character to search on.";
                string caption = "Invalid search criteria";
                this.DialogService.ShowAlertBox(OwningWindow, this.UIDispatcher, message, caption, MessageTypes.Warning);
            }
            else
            {
                this.MatchingProviders = this.DicomImporterDataSource.GetOrderingProviderList(this.SearchCriteria);
                if (this.MatchingProviders.Count == 0)
                {
                    this.NoResultsAction(this, null);
                }
            }
        }

        #endregion
    }
}