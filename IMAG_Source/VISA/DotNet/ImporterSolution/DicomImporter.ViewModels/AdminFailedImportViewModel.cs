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

using DicomImporter.Common.Services;

namespace DicomImporter.ViewModels
{
    using System;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Text;
    using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.Views;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Exceptions;
    using ImagingClient.Infrastructure.Storage.Model;
    using ImagingClient.Infrastructure.StorageDataSource;
    using ImagingClient.Infrastructure.Utilities;
    using ImagingClient.Infrastructure.ViewModels;
    using ImagingClient.Infrastructure.Views;
    using log4net;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The admin revert work item view model.
    /// </summary>
    public class AdminFailedImportViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(AdminFailedImportViewModel));

        /// <summary>
        /// The no items in reconciliation message.
        /// </summary>
        private const string NoFailedWorkItemsMessage = "There are currently no failed Importer items.";

        /// <summary>
        /// The no items in reconciliation message.
        /// </summary>
        private const string WorkItemDetailsLoadingMessage = "Please wait while the failure information is loaded.";

        /// <summary>
        /// No Importer item selected message
        /// </summary>
        private const string NoImporterItemSelectedMessage = "No Importer item selected.";

        /// <summary>
        /// The progress view model.
        /// </summary>
        private ProgressViewModel progressViewModel = new ProgressViewModel();

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="AdminFailedImportViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">The dialog service.</param>
        /// <param name="importerDialogService">The importer dialog service.</param>
        /// <param name="dicomImporterDataSource">The dicom importer data source.</param>
        /// <param name="storageDataSource">The storage data source.</param>
        public AdminFailedImportViewModel(
            IDialogService dialogService,
            IImporterDialogService importerDialogService,
            IDicomImporterDataSource dicomImporterDataSource,
            IStorageDataSource storageDataSource)
        {
            this.DialogService = dialogService;
            this.ImporterDialogService = importerDialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;
            this.StorageDataSource = storageDataSource;

            this.RefreshList = new DelegateCommand<object>(o => this.LoadWorkItems(), o => !ProgressViewModel.IsWorkInProgress);

            // Clear out errors, and resubmit the work item
            this.ResubmitWorkItem = new DelegateCommand<object>(
                o =>
                    {
                        try
                        {
                            this.ClearMessages();

                            // Confirm resubmit
                            bool resubmitConfirmed = this.DialogService.ShowYesNoBox(
                                this.UIDispatcher,
                                "Are you sure you want to resubmit this importer item at attempt to reprocess it?",
                                "Confirm Resubmit",
                                MessageTypes.Question);

                            // Get the full item but don't transition it yet, so we can delete reconciliations...
                            if (resubmitConfirmed)
                            {
                                // Clear all existing errors in prep for resubmit.
                                foreach (Study study in this.FullyLoadedWorkItem.WorkItemDetails.Studies)
                                {
                                    study.ImportErrorMessage = string.Empty;
                                    foreach (Series series in study.Series)
                                    {
                                        foreach (SopInstance instance in series.SopInstances)
                                        {
                                            instance.ImportErrorMessage = string.Empty;
                                        }
                                    }

                                    ObservableCollection<NonDicomFile> nonDicomFiles = study.Reconciliation.NonDicomFiles;
                                    if (nonDicomFiles != null)
                                    {
                                        foreach (NonDicomFile file in nonDicomFiles)
                                        {
                                            file.ImportErrorMessage = string.Empty;
                                        }
                                    }
                                }

                                // Resubmit the work item for import processing
                                this.DicomImporterDataSource.UpdateWorkItem(
                                    this.FullyLoadedWorkItem,
                                    ImporterWorkItemStatuses.FailedImport,
                                    ImporterWorkItemStatuses.ReadyForImport);

                                // Refresh the list
                                this.LoadWorkItems();
                            }
                        }
                        catch (ServerException se)
                        {
                            this.HandleServerException(se);
                        }
                    },
                o => (this.FullyLoadedWorkItem != null));

            this.DeleteWorkItem = new DelegateCommand<object>(
                o =>
                    {
                        try
                        {
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
                    },
                o => (this.SelectedWorkItem != null));

            this.NavigateToAdministrationHomeView =
                new DelegateCommand<object>(
                    o => this.NavigateMainRegionTo(ImporterViewNames.AdministrationHomeView), o => this.HasAdministratorKey);
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

            // Reload the work items and mark work as completed
            this.LoadWorkItems();
            ProgressViewModel.IsWorkInProgress = false;
            this.RefreshList.RaiseCanExecuteChanged();
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

        #region Public Events

        /// <summary>
        /// The window action.
        /// </summary>
        public event WorkItemDetailsChangedHandler WorkItemDetailsChanged;

        #endregion

        #region Public Properties


        //Begin-Get and set property notification in FailedImportItems screen-OITCOPondiS

        /// <summary>
        /// Gets or sets the importer error summary as HTML.
        /// </summary>
        /// <value>
        /// The importer error summary as HTML.
        /// </value>
        //public string ImporterErrorSummaryText { get; set; }
        private string _ImporterErrorSummaryText { get; set; }

        /// <summary>
        /// Gets the requested status.
        /// </summary>
        public string ImporterErrorSummaryText
        {
            get { return _ImporterErrorSummaryText; }
            set
            {
                _ImporterErrorSummaryText = value;
                this.RaisePropertyChanged("ImporterErrorSummaryText");
            }
        }

        //End-OITCOPondiS


        /// <summary>
        /// Gets or sets NavigateToAdministrationHomeView.
        /// </summary>
        public DelegateCommand<object> NavigateToAdministrationHomeView { get; set; }

        /// <summary>
        /// Gets or sets ProgressViewModel.
        /// </summary>
        public ProgressViewModel ProgressViewModel
        {
            get
            {
                return this.progressViewModel;
            }

            set
            {
                this.progressViewModel = value;
                this.RaisePropertyChanged("ProgressViewModel");
            }
        }

        /// <summary>
        /// Gets or sets the RefreshList Command.
        /// </summary>
        /// <value>
        /// The refresh list.
        /// </value>
        public DelegateCommand<object> RefreshList { get; set; }

        /// <summary>
        /// Gets or sets ResubmitWorkItem.
        /// </summary>
        public DelegateCommand<object> ResubmitWorkItem { get; set; }

        /// <summary>
        /// Gets or sets DeleteWorkItem.
        /// </summary>
        public DelegateCommand<object> DeleteWorkItem { get; set; }

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

                // If the new value is not null, load the full thing...
                if (this.WorkItem != null)
                {
                    // Clear existing fully loaded work item, disable buttons, and set text to loading...
                    this.FullyLoadedWorkItem = null;
                    this.ImporterErrorSummaryText = WorkItemDetailsLoadingMessage;

                    // Show the progress view
                    this.ProgressViewModel.IsWorkInProgress = true;
                    this.ProgressViewModel.IsIndeterminate = true;

                    // Update button statuses
                    this.ResubmitWorkItem.RaiseCanExecuteChanged();
                    this.DeleteWorkItem.RaiseCanExecuteChanged();
                    this.RefreshList.RaiseCanExecuteChanged();

                    // Create and start a background worker to load the full work item
                    var worker = new BackgroundWorker();
                    worker.DoWork += this.LoadFullWorkItem;
                    worker.RunWorkerAsync();
                }
                else
                {
                    this.ImporterErrorSummaryText = NoImporterItemSelectedMessage;
                }



                this.RaisePropertyChanged("SelectedWorkItem");

            }
        }

        /// <summary>
        /// Gets or sets SelectedWorkItemWithDetails.
        /// </summary>
        public ImporterWorkItem SelectedWorkItemWithDetails { get; set; }



        //Commented since binding element {NotifyPropertyWeaverMsBuildTask} is no longer available in VS 2015 and above versions. (p289-OITCOPondiS)  
        ///// <summary>
        ///// Gets or sets WorkItems.
        ///// </summary>
        //public ObservableCollection<ImporterWorkItem> WorkItems { get; set; }

        //BEGIN-Modified WorkItems property binding. Earlier binding made through imlementing library {NotifyPropertyWeaverMsBuildTask}.(p289-OITCOPondiS)  

        
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

        #region Private Properties
        //Get and set private properties-OITCOPondiS
        private ObservableCollection<ImporterWorkItem> _WorkItems { get; set; }
        

        /// <summary>
        /// Gets or sets the fully loaded work item.
        /// </summary>
        /// <value>
        /// The fully loaded work item.
        /// </value>
        private ImporterWorkItem FullyLoadedWorkItem { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// The on navigated from.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        public override void OnNavigatedFrom(NavigationContext navigationContext)
        {
            base.OnNavigatedFrom(navigationContext);
        }

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

                // Clear the selected work item
                this.SelectedWorkItem = null;
                this.FullyLoadedWorkItem = null;

                // Set the no items selected message
                this.ImporterErrorSummaryText = NoImporterItemSelectedMessage;

                // Build the filter
                var filter = new ImporterWorkItemFilter { Status = ImporterWorkItemStatuses.FailedImport };

                // Call the datasource to get the matching work items
                this.WorkItems = this.DicomImporterDataSource.GetWorkItemList(filter);

                // Refresh the button statuses
                this.RefreshList.RaiseCanExecuteChanged();
                this.ResubmitWorkItem.RaiseCanExecuteChanged();
                this.DeleteWorkItem.RaiseCanExecuteChanged();

            }
            catch (Exception ex)
            {
                var window = new ExceptionWindow(ex);
                window.SubscribeToNewUserLogin();
                window.ShowDialog();
            }

            if (this.WorkItems == null || this.WorkItems.Count == 0)
            {
              this.AddMessage(MessageTypes.Info, NoFailedWorkItemsMessage);
            }
        }

        /// <summary>
        /// Loads the full work item.
        /// </summary>
        /// <param name="o">The o.</param>
        /// <param name="args">The <see cref="System.ComponentModel.DoWorkEventArgs"/> instance containing the event data.</param>
        private void LoadFullWorkItem(object o, DoWorkEventArgs args)
        {
            // Get the full item but don't transition it...
            try
            {
                ImporterWorkItem workItem =
                    this.DicomImporterDataSource.GetAndTranstionImporterWorkItem(
                        this.SelectedWorkItem,
                        ImporterWorkItemStatuses.FailedImport,
                        ImporterWorkItemStatuses.FailedImport);
                // If we have the currently selected work item, store it off and generate new error text
                if (workItem.Id == this.SelectedWorkItem.Id)
                {
                    this.FullyLoadedWorkItem = workItem;

                    try
                    {
                        this.ImporterErrorSummaryText =
                            this.GetImportErrorSummaryText(this.FullyLoadedWorkItem.WorkItemDetails);
                    }
                    catch (Exception e)
                    {
                        this.ImporterErrorSummaryText = WorkItemDetailsLoadingMessage;
                        Logger.Debug(
                            "Exception was thrown. Probably caused by someone clicking on the grid and "
                            + "nullifying the fully loaded object before the message could be built. Continue on...",
                            e);
                    }

                    // Only enable stuff and hide the progress bar if we successfully loaded the message
                    if (!this.ImporterErrorSummaryText.Equals(WorkItemDetailsLoadingMessage))
                    {
                        this.ProgressViewModel.IsWorkInProgress = false;
                        this.RefreshList.RaiseCanExecuteChanged();
                        this.ResubmitWorkItem.RaiseCanExecuteChanged();
                        this.DeleteWorkItem.RaiseCanExecuteChanged();
                    }
                }
            }
            catch (ServerException se)
            {
                this.HandleServerException(se);
            }
        }

        /// <summary>
        /// Gets the import error summary as HTML.
        /// </summary>
        /// <param name="workItemDetails">The work item details.</param>
        /// <returns>An HTML string containing the importer error summary</returns>
        private string GetImportErrorSummaryText(ImporterWorkItemDetails workItemDetails)
        {
            // First, get the media bundle root path for later display
            string networkLocationIen = this.FullyLoadedWorkItem.WorkItemDetails.NetworkLocationIen;
            NetworkLocationInfo networkLocationInfo =
                this.StorageDataSource.GetNetworkLocationDetails(networkLocationIen);
            string serverPath = networkLocationInfo.PhysicalPath;
            string mediaBundleRoot = this.FullyLoadedWorkItem.WorkItemDetails.MediaBundleStagingRootDirectory;
            string fullMediaBundlePath = PathUtilities.CombinePath(serverPath, mediaBundleRoot);

            var sb = new StringBuilder();
            this.AppendErrorHeader(sb, fullMediaBundlePath);
            this.AppendStudyAndInstanceLevelErrorInfo(sb, fullMediaBundlePath);
            return sb.ToString();
        }

        /// <summary>
        /// Appends the error header.
        /// </summary>
        /// <param name="sb">The sb.</param>
        /// <param name="fullMediaBundlePath">The full media bundle path.</param>
        private void AppendErrorHeader(StringBuilder sb, string fullMediaBundlePath)
        {
            sb.Append("Importer Item IEN: " + this.FullyLoadedWorkItem.Id + "\n");
            sb.Append("Network Location IEN: " + this.FullyLoadedWorkItem.WorkItemDetails.NetworkLocationIen + "\n");
            sb.Append("Resolved Media Bundle Path: " + fullMediaBundlePath + "\n");
            sb.Append("Submitted By: " + this.FullyLoadedWorkItem.UpdatingUser + "\n");
            sb.Append("Processing HDIG: " + this.FullyLoadedWorkItem.UpdatingApplication + "\n");
            sb.Append("Failure Date/Time: " + this.FullyLoadedWorkItem.LastUpdateDate + "\n");
        }

        /// <summary>
        /// Appends the study and instance level error info.
        /// </summary>
        /// <param name="sb">The sb.</param>
        /// <param name="fullMediaBundlePath">The full media bundle path.</param>
        private void AppendStudyAndInstanceLevelErrorInfo(StringBuilder sb, string fullMediaBundlePath)
        {
            foreach (Study study in this.FullyLoadedWorkItem.WorkItemDetails.Studies)
            {
                sb.Append(
                    "\n\n----------------------------------------------------------------------------------------------\n");
                sb.Append("Study " + study.IdInMediaBundle + ":\n");
                sb.Append(
                    "----------------------------------------------------------------------------------------------\n");
                sb.Append("Study UID: " + study.Uid + "\n");
                sb.Append("Accession Number: " + study.AccessionNumber + "\n");
                sb.Append("Study Date: " + study.FormattedStudyDate + "\n");
                sb.Append("Study Time: " + study.FormattedStudyTime + "\n");
                sb.Append("Procedure: " + study.Procedure + "\n");
                sb.Append("Study Description: " + study.Description + "\n");
                sb.Append("Modality Codes: " + study.ModalityCodes + "\n");
                sb.Append("Origin Index: " + study.OriginIndex + "\n");
                sb.Append("Facility: " + study.Facility + "\n");
                sb.Append("Institution Address: " + study.InstitutionAddress + "\n");
                sb.Append("Referring Physician: " + study.ReferringPhysician + "\n\n");

                // If the study itself failed (i.e. bad order, etc), write out the failure reason
                if (study.FailedImport)
                {
                    sb.Append("Study-level Failure Details: \n" + study.ImportErrorMessage + "\n");
                }

                foreach (Series series in study.Series)
                {
                    foreach (SopInstance instance in series.SopInstances)
                    {
                        if (!instance.IsImportedSuccessfully)
                        {
                            sb.Append(
                                "\n----------------------------------------------------------------------------------------------\n");
                            sb.Append("SOP Instance Failure Information\n");
                            sb.Append(
                                "----------------------------------------------------------------------------------------------\n");
                            sb.Append(
                                "Path: " + PathUtilities.CombinePath(fullMediaBundlePath, instance.FilePath) + "\n");
                            sb.Append("SOP Class UID: " + instance.SopClassUid + "\n");
                            sb.Append("SOP Instance UID: " + instance.Uid + "\n");
                            sb.Append("SOP Instance Failure Details: " + instance.ImportErrorMessage + "\n");
                        }
                    }
                }
                ObservableCollection<NonDicomFile> nonDicomFiles = study.Reconciliation.NonDicomFiles;
                if (nonDicomFiles != null)
                {
                    foreach (NonDicomFile file in nonDicomFiles)
                    {
                        if (!file.IsImportedSuccessfully)
                        {
                            sb.Append(
                                "\n----------------------------------------------------------------------------------------------\n");
                            sb.Append("Non-DICOM File Failure Information\n");
                            sb.Append(
                                "----------------------------------------------------------------------------------------------\n");
                            sb.Append("Path: " + PathUtilities.CombinePath(fullMediaBundlePath, file.FilePath) + "\n");
                            sb.Append("Non-DICOM File Failure Details: " + file.ImportErrorMessage + "\n");
                        }
                        file.ImportErrorMessage = string.Empty;
                    }
                }

            }
        }

        #endregion
    }
}
