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
    using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.Services;
    using DicomImporter.Common.Views;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Exceptions;
    using ImagingClient.Infrastructure.StorageDataSource;
    using ImagingClient.Infrastructure.Views;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The admin revert work item view model.
    /// </summary>
    public class AdminInProcessImportsViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The no items in reconciliation message.
        /// </summary>
        private const string NoInProcessWorkItemsMessage = "There are currently no Importer items being processed by an HDIG.";

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="AdminInProcessImportsViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">The dialog service.</param>
        /// <param name="importerDialogService">The importer dialog service.</param>
        /// <param name="dicomImporterDataSource">The dicom importer data source.</param>
        /// <param name="storageDataSource">The storage data source.</param>
        public AdminInProcessImportsViewModel(
            IDialogService dialogService,
            IImporterDialogService importerDialogService,
            IDicomImporterDataSource dicomImporterDataSource,
            IStorageDataSource storageDataSource)
        {
            this.DialogService = dialogService;
            this.ImporterDialogService = importerDialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;
            this.StorageDataSource = storageDataSource;

            this.RefreshList = new DelegateCommand<object>(o => this.LoadWorkItems());

            this.NavigateToAdministrationHomeView =
                new DelegateCommand<object>(
                    o => this.NavigateMainRegionTo(ImporterViewNames.AdministrationHomeView), o => this.HasAdministratorKey);

            this.DeleteImportItemCommand = new DelegateCommand<object>(
                o => this.DeleteImportItem(), o => (this.SelectedWorkItem != null));
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
        public delegate void WorkItemDetailsChangedHandler(object sender, EventArgs e);

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets SelectedWorkItem.
        /// </summary>
        public ImporterWorkItem SelectedWorkItem
        {
            get
            {
                return this.WorkItem;
            }

            set
            {
                this.WorkItem = value;
                this.DeleteImportItemCommand.RaiseCanExecuteChanged();
            }
        }


        /// <summary>
        /// Gets or sets the importer error summary as HTML.
        /// </summary>
        /// <value>
        /// The importer error summary as HTML.
        /// </value>
        public string ImporterErrorSummaryText { get; set; }

        /// <summary>
        /// Gets or sets NavigateToAdministrationHomeView.
        /// </summary>
        public DelegateCommand<object> NavigateToAdministrationHomeView { get; set; }

        /// <summary>
        /// Gets or sets NavigateToAdministrationHomeView.
        /// </summary>
        public DelegateCommand<object> DeleteImportItemCommand { get; set; }

        /// <summary>
        /// Gets or sets the RefreshList Command.
        /// </summary>
        /// <value>
        /// The refresh list.
        /// </value>
        public DelegateCommand<object> RefreshList { get; set; }

        //Commented since binding element {NotifyPropertyWeaverMsBuildTask} is no longer available in VS 2015 and above versions. (p289-OITCOPondiS)  
        ///// <summary>
        ///// Gets or sets WorkItems.
        ///// </summary>
        //public ObservableCollection<ImporterWorkItem> WorkItems { get; set; }


        //BEGIN-Modified WorkItems property to bind to the control. Earlier binding made through imlementing library {NotifyPropertyWeaverMsBuildTask}.(p289-OITCOPondiS)  
        private ObservableCollection<ImporterWorkItem> _WorkItems { get; set; }

        /// <summary>
        /// Gets or sets WorkItems.
        /// </summary>
        public ObservableCollection<ImporterWorkItem> WorkItems
        {
            get { return _WorkItems; }
            set
            {

                _WorkItems = value;
                this.RaisePropertyChanged("WorkItems");
            }

        }
        //END-(p289-OITCOPondiS)   

        #endregion

        #region Public Methods

        /// <summary>
        /// The on navigated to.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        public override void OnNavigatedTo(NavigationContext navigationContext)
        {
            base.OnNavigatedTo(navigationContext);

            this.LoadWorkItems();
        }

        #endregion

        #region Methods

        /// <summary>
        /// The load work items.
        /// </summary>
        private void LoadWorkItems()
        {
            try
            {
                this.ClearMessages();

                // Build the filter
                var filter = new ImporterWorkItemFilter { Status = ImporterWorkItemStatuses.Importing };

                // Call the datasource to get the matching work items
                this.WorkItems = this.DicomImporterDataSource.GetWorkItemList(filter);
            }
            catch (Exception ex)
            {
                var window = new ExceptionWindow(ex);
                window.SubscribeToNewUserLogin();
                window.ShowDialog();
            }

            if (this.WorkItems == null || this.WorkItems.Count == 0)
            {
                this.AddMessage(MessageTypes.Info, NoInProcessWorkItemsMessage);
            }
        }

        /// <summary>
        /// Deletes the importer item.
        /// </summary>
        private void DeleteImportItem()
        {
            try
            {
                this.ClearMessages();

                if (DeleteImporterWorkItem(SelectedWorkItem))
                {
                    // Refresh the list
                    this.LoadWorkItems();
                }
            }
            catch (ServerException se)
            {
                this.HandleServerException(se);
            }
        }

        /// <summary>
        /// Handles the server exception.
        /// </summary>
        /// <param name="se">The se.</param>
        private void HandleServerException(ServerException se)
        {
            // Check for "expected" exceptions and handle them. Rethrow on unexpected ones...
            if (se.ErrorCode == ImporterErrorCodes.WorkItemNotFoundErrorCode)
            {
                this.AddMessage(MessageTypes.Error, WorkItemNotFoundErrorMessage);
            }
            else if (se.ErrorCode == ImporterErrorCodes.InvalidWorkItemStatusErrorCode)
            {
                this.AddMessage(MessageTypes.Error, se.Message);
            }
            else
            {
                // Rethrow the error up to the general exception handler
                throw se;
            }

            // Reload the work items
            this.LoadWorkItems();
        }


        #endregion
    }
}