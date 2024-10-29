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
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Windows.Threading;
    using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;
    using DicomImporter.Common.Views;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Exceptions;
    using ImagingClient.Infrastructure.StorageDataSource;
    using ImagingClient.Infrastructure.User.Model;
    using ImagingClient.Infrastructure.Utilities;
    using log4net;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The confirmation view model.
    /// </summary>
    public class ConfirmationViewModel : MediaReadingViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The dicom compliance caption.
        /// </summary>
        private const string DicomComplianceCaption = "Non-Compliant DICOM Media";

        /// <summary>
        /// The invalid dicom dir message.
        /// </summary>
        private const string InvalidDicomDirMessage =
            "This media was not DICOM compliant and had an invalid DICOMDIR file.\n\n{0}"
            + "\n\nAre you sure you want to continue?";

        /// <summary>
        /// The no dicom dir message.
        /// </summary>
        private const string NoDicomDirMessage =
            "This media was not DICOM compliant and had no DICOMDIR file to cross check "
            + "that all images are present. \n\nAre you sure you want to continue?";

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(ConfirmationViewModel));

        /// <summary>
        /// The staged import in progress.
        /// </summary>
        private bool stagedImportInProgress;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ConfirmationViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        /// <param name="storageDataSource">
        /// The storage data source.
        /// </param>
        public ConfirmationViewModel(
            IDialogService dialogService, 
            IDicomImporterDataSource dicomImporterDataSource, 
            IStorageDataSource storageDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;
            this.StorageDataSource = storageDataSource;

            this.ImportCommand = new DelegateCommand<object>(
                o => this.PerformImport(), o => this.AllowPerformImport());

            this.NavigateBack = new DelegateCommand<object>(
                o =>
                    {
                        if (IsDicomWorkItem)
                        {
                            this.NavigateWorkItem(ImporterViewNames.StudyListView);
                        }
                        else
                        {
                            if (WorkItemDetails.Reconciliations[0].Order.IsToBeCreated)
                            {
                                this.NavigateWorkItem(ImporterViewNames.CreateNewRadiologyOrderView);                                  
                            }
                            else
                            {
                                this.NavigateWorkItem(ImporterViewNames.ChooseExistingOrderView);                                  
                            }
                        }
                    }, 
                o => !this.ProgressViewModel.IsWorkInProgress && !this.stagedImportInProgress);

            this.CancelImportCommand = new DelegateCommand<object>(o => this.CancelImport(), o => this.CanCancel());
        }

        #endregion

        #region Public Properties

        private string backButtonText;
        public string BackButtonText
        {
            get
            {
                backButtonText = IsDicomWorkItem ? "< Return to Study List" : "< Back";
                return backButtonText;
            }
            set { backButtonText = value; }
        }

        /// <summary>
        /// Gets or sets CancelImportCommand.
        /// </summary>
        public DelegateCommand<object> CancelImportCommand { get; set; }

        /// <summary>
        /// Gets or sets ImportCommand.
        /// </summary>
        public DelegateCommand<object> ImportCommand { get; set; }

        /// <summary>
        /// Gets or sets NavigateBack.
        /// </summary>
        public DelegateCommand<object> NavigateBack { get; set; }

        /// <summary>
        /// Gets or sets ReconciliationDetailsViewModels.
        /// </summary>
        public ObservableCollection<ReconciliationDetailsViewModel> ReconciliationDetailsViewModels { get; set; }

        #endregion

        #region Properties

        /// <summary>
        /// Gets a value indicating whether this instance is non compliant media.
        /// </summary>
        /// <value>
        ///     <c>true</c> if the media is not DICOM compliant; otherwise, <c>false</c>.
        /// </value>
        private bool IsNonCompliantMedia
        {
            get
            {
                return this.WorkItemDetails.MediaValidationStatusCode == DicomMediaValidationStatusCodes.InvalidDicomDir
                       ||
                       this.WorkItemDetails.MediaValidationStatusCode == DicomMediaValidationStatusCodes.DicomDirMissing;
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// The confirm navigation request.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        /// <param name="continuationCallback">
        /// The continuation callback.
        /// </param>
        public override void ConfirmNavigationRequest(
            NavigationContext navigationContext, Action<bool> continuationCallback)
        {
            this.ConfirmNavigationFromActiveReconciliation(navigationContext, continuationCallback);
        }

        /// <summary>
        /// The create direct import work item.
        /// </summary>
        public void CreateDirectImportWorkItem()
        {
            this.DicomImporterDataSource.CreateImporterWorkItem(this.WorkItem, false);
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

            this.ReconciliationDetailsViewModels = new ObservableCollection<ReconciliationDetailsViewModel>();
            for (int i = 0; i <= this.WorkItemDetails.Reconciliations.Count - 1; i++)
            {
                Reconciliation reconciliation = this.WorkItemDetails.Reconciliations[i];
                if (reconciliation.Study != null && !reconciliation.Study.ToBeDeletedOnly)
                {
                    this.ReconciliationDetailsViewModels.Add(
                        new ReconciliationDetailsViewModel(reconciliation.Study, i + 1, this.WorkItem));
                }
            }
    
            this.SetMediaCategoryProperties();
        }

        #endregion

        #region Methods

        /// <summary>
        /// The cancel import.
        /// </summary>
        protected void CancelImport()
        {
            this.Worker.CancelAsync();
            this.ProgressViewModel.Text = "Cancellation pending...";

            this.NavigateBack.RaiseCanExecuteChanged();
            this.ImportCommand.RaiseCanExecuteChanged();
            this.CancelImportCommand.RaiseCanExecuteChanged();
        }

        /// <summary>
        /// The on logout.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        protected override void OnLogout(CancelEventArgs args)
        {
            base.OnLogout(args);

            if (!args.Cancel)
            {
                this.ConfirmCancellation(args, "log out");
            }
        }

        /// <summary>
        /// The on shutdown.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        protected override void OnShutdown(CancelEventArgs args)
        {
            base.OnShutdown(args);
            
            if (!args.Cancel)
            {
                this.ConfirmCancellation(args, "exit");
            }
        }

        /// <summary>
        /// The on timeout cleanup.
        /// </summary>
        /// <param name="args">The args.</param>
        protected override void OnTimeoutCleanup(CancelEventArgs args)
        {
            if (!args.Cancel && WorkItem != null)
            {
                // WorkitemDetails will be null if the workitem has already been safely stored
                if (WorkItem.WorkItemDetails != null)
                {
                    // Remove this reconciliation
                    DicomImporterDataSource.CancelImporterWorkItem(WorkItem);
                }

                // Deletes the Work Item
                WorkItem = null;
            }

            base.OnTimeoutCleanup(args);
        }

        /// <summary>
        /// Determines whether this instance can cancel.
        /// </summary>
        /// <returns>
        /// <c>true</c> if this instance can cancel; otherwise, <c>false</c>.
        /// </returns>
        private bool CanCancel()
        {
            // Check to see if a worker is active and cancellation is pending...
            bool cancellationPending = false;
            if (this.Worker != null && this.Worker.CancellationPending)
            {
                cancellationPending = true;
            }

            // We can only cancel if work is in progress, but cancellation has not already
            // been requested...
            return this.ProgressViewModel.IsWorkInProgress && !cancellationPending;
        }

        /// <summary>
        /// Resolves the correct media validation message
        /// </summary>
        /// <returns>
        /// The invalid media message.
        /// </returns>
        private string GetInvalidMediaMessage()
        {
            if (this.WorkItemDetails.MediaValidationStatusCode == DicomMediaValidationStatusCodes.DicomDirMissing)
            {
                return NoDicomDirMessage;
            }

            if (this.WorkItemDetails.MediaValidationStatusCode == DicomMediaValidationStatusCodes.InvalidDicomDir)
            {
                return string.Format(InvalidDicomDirMessage, this.WorkItemDetails.MediaValidationMessage);
            }

            return string.Empty;
        }

        /// <summary>
        /// The perform direct import.
        /// </summary>
        private void PerformDirectImport()
        {
            // If this workitem has DICOM files, get a "signature" for the media by hashing all the filenames 
            // so that we can check to see if the DICOM media has changed.
            string signature = "";
           
            if (!WorkItem.MediaCategory.Category.Equals(MediaCategories.NonDICOM))
            {
                var fileList = new List<string>();
                PathUtilities.AddFiles(this.WorkItemDetails.LocalSourcePath, "*", fileList);
                signature = StringUtilities.GetHashForStringArray(fileList.ToArray());
            }

            if (WorkItem.MediaCategory.Category.Equals(MediaCategories.NonDICOM) || signature.Equals(this.WorkItemDetails.MediaBundleSignature))
            {
                // If invalid or missing DICOMDIR, verify before continuing
                if (!WorkItem.MediaCategory.Category.Equals(MediaCategories.NonDICOM) && this.IsNonCompliantMedia)
                {
                    if (
                        !this.DialogService.ShowOkCancelBox(
                            this.UIDispatcher, 
                            this.GetInvalidMediaMessage(), 
                            DicomComplianceCaption, 
                            MessageTypes.Question))
                    {
                        return;
                    }
                }

                // Subscribes to the New User Login Event
                this.eventAggregator.GetEvent<NewUserLoginEvent>().Subscribe(this.SetNewUserLoginAlert);

                // Create and spawn a new backround worker to actually copy the files.
                // This lets us cancel if necessary, etc.
                this.Worker = new BackgroundWorker();
                this.Worker.WorkerSupportsCancellation = true;
                this.Worker.DoWork += this.StageDirectImport;
                this.Worker.RunWorkerCompleted += this.StageDirectImportComplete;
                this.Worker.RunWorkerAsync();
            }
            else
            {
                // The user has changed the media since it was initially read. 
                // Warn them and don't actually do the import
                string message = "Something is wrong with CD/DVD disk.  The disk does not appear to be the\n"
                                 + "same one that was used at the start of the Importer session.  Could the\n"
                                 + "original disk have been removed and another one inserted into the drive?";
                string caption = "Media Has Changed";

                this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);
            }
        }

        /// <summary>
        /// The perform import.
        /// </summary>
        private void PerformImport()
        {
            // Set the DUZ of the reconciling technician for future use in Statusing the order,
            // if necessary, as well as the workstation name...
            this.WorkItemDetails.ReconcilingTechnicianDuz = UserContext.UserCredentials.Duz;
            this.WorkItemDetails.WorkstationName = Environment.MachineName;

            // Renumber the series and instances in each of the studies to a sequential value
            foreach (Study study in this.WorkItemDetails.Studies)
            {
                study.RenumberSeriesAndInstances();
            }

            if (this.WorkItem.Subtype != ImporterWorkItemSubtype.DirectImport.Code)
            {
                this.PerformStagedImport();
            }
            else
            {
                this.PerformDirectImport();
            }
        }

        /// <summary>
        /// The perform staged import.
        /// </summary>
        private void PerformStagedImport()
        {
            this.stagedImportInProgress = true;

            this.NavigateBack.RaiseCanExecuteChanged();
            this.ImportCommand.RaiseCanExecuteChanged();
            this.CancelImportCommand.RaiseCanExecuteChanged();

            // Subscribes to the New User Login Event
            this.eventAggregator.GetEvent<NewUserLoginEvent>().Subscribe(this.SetNewUserLoginAlert);
            
            // If noncompliant media, verify before continuing if it's not DicomCorrect or Network Import
            if (this.IsNonCompliantMedia && !this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.DicomCorrect.Code)
                && !this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.CommunityCare.Code)
                && !this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.NetworkImport.Code))
            {
                if (
                    !this.DialogService.ShowOkCancelBox(
                        this.UIDispatcher, this.GetInvalidMediaMessage(), DicomComplianceCaption, MessageTypes.Question))
                {
                    this.stagedImportInProgress = false;

                    this.NavigateBack.RaiseCanExecuteChanged();
                    this.ImportCommand.RaiseCanExecuteChanged();
                    this.CancelImportCommand.RaiseCanExecuteChanged();

                    return;
                }
            }

            // Create a null server exception so we can report on it later if necessary
            Exception exception = null;

            // Try to transition the work item if possible
            try
            {
                // Transition the work item to ReadyForImport
                RetryUtility.RetryAction(this.UpdateStagedWorkItemStatus);
            }
            catch (ServerException se)
            {
                // Check for "expected" exceptions and handle them. Rethrow on unexpected ones...
                if (se.ErrorCode == ImporterErrorCodes.WorkItemNotFoundErrorCode)
                {
                    string message = "The selected work item was not found on the server. It may have been deleted.\n";
                    message += "Your reconciliations cannot be imported.";
                    string caption = "Work Item Not Found";

                    this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);

                    // Log the error
                    Logger.Error(message, se);

                    exception = se;
                }
                else if (se.ErrorCode == ImporterErrorCodes.InvalidWorkItemStatusErrorCode)
                {
                    string message = se.Message + "\n";
                    message += "Your reconciliations cannot be imported.";
                    string caption = "Work Item in Invalid Status";

                    this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);

                    // Log the error
                    Logger.Error(message, se);

                    exception = se;
                }
                else
                {
                    string message = se.Message + "\n";
                    message += "Your reconciliations cannot be imported.";
                    string caption = "Import Error";

                    this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);

                    // Log the error
                    Logger.Error(message, se);

                    exception = se;
                }
            }
            catch (Exception e)
            {
                string message = e.Message + "\n";
                message += "Your reconciliations cannot be imported.";
                string caption = "Import Error";

                this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);

                // Log the error
                Logger.Error(message, e);

                exception = e;
            }
            finally
            {
                // Regardless of success or failure in submitting import, remove item from the cache, and 
                // Navigate back to the worklist...
                ImporterWorkItemCache.Remove(this.WorkItem);

                // Set the workitem to null so we aren't prompted for confirmation on returning to the 
                // import list
                this.WorkItem = null;

                // If we made it here with no server exception, let the user know import was successful.
                if (exception == null)
                {
                    // Show information message
                    this.DialogService.ShowAlertBox(
                        this.UIDispatcher,
                        "The current work item has been queued for import processing.",
                        "Queued for Import",
                        MessageTypes.Info);
                }

                if (!this.isNewUserLogin)
                {
                    this.NavigateMainRegionTo(ImporterViewNames.WorkListView + "?IsFirstWorkListLoading=false");
                }
                else
                {
                    this.isNewUserLogin = false;
                }
            }

            // Unsubscribes from the New User Login Event
            this.eventAggregator.GetEvent<NewUserLoginEvent>().Unsubscribe(this.SetNewUserLoginAlert);
        }

        /// <summary>
        /// The stage direct import.
        /// </summary>
        /// <param name="o">
        /// The o.
        /// </param>
        /// <param name="args">
        /// The args.
        /// </param>
        private void StageDirectImport(object o, DoWorkEventArgs args)
        {
            // Show the progress bar
            this.ProgressViewModel.IsWorkInProgress = true;

            this.NavigateBack.RaiseCanExecuteChanged();
            this.ImportCommand.RaiseCanExecuteChanged();
            this.CancelImportCommand.RaiseCanExecuteChanged();

            // Trim down the WorkItemDetails to only include studies to be imported
            var studiesIterator = new ObservableCollection<Study>(this.WorkItemDetails.Studies);

            foreach (Study study in studiesIterator)
            {
                if (study.Reconciliation == null)
                {
                    // This study has no reconciliation. Remove it from the list
                    this.UIDispatcher.Invoke(
                        DispatcherPriority.Normal, (Action)(() => this.WorkItemDetails.Studies.Remove(study)));
                }
            }

            // Stage the remaining studies
            Exception fileCopyingException = null;
            try
            {
                this.CopyFilesToServer();
            }
            catch (Exception e)
            {
                fileCopyingException = e;
            }

            this.FinalizeDirectImport(fileCopyingException);
        }

        /// <summary>
        /// Finalizes the direct import.
        /// </summary>
        /// <param name="exception">The exception thrown during processing, if any.</param>
        private void FinalizeDirectImport(Exception fileCopyingException)
        {
            ProgressViewModel.IsIndeterminate = true;
            try
            {
                if (fileCopyingException != null)
                {
                    if (fileCopyingException is InvalidNetworkLocationException)
                    {
                        InvalidNetworkLocationException e = (InvalidNetworkLocationException)fileCopyingException;
                        string caption = "Invalid Network Location Entry";
                        string message = "The current write location has an invalid \\\\server\\share value of:  \"" + e.ServerAndShare + "\".\n";
                        message += "Please contact an administrator.\n";

                        this.ProgressViewModel.IsWorkInProgress = false;
                        this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);
                    }
                    else if (fileCopyingException is NetworkLocationConnectionException)
                    {
                        string caption = "Invalid Network Location Credentials";
                        string message = "The current write location has an invalid username/password configured.\n";
                        message += "Please contact an administrator.\n";

                        this.ProgressViewModel.IsWorkInProgress = false;
                        this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);
                    }
                    else
                    {
                        // Show the error coming back from the File Copy
                        this.DialogService.ShowExceptionWindow(UIDispatcher, fileCopyingException);

                        // Create the WorkItem in a failed status, for later cleanup
                        this.WorkItem.Status = ImporterWorkItemStatuses.FailedDirectImportStaging;

                        ProgressViewModel.Text = "Updating work item...";
                        RetryUtility.RetryAction(this.CreateDirectImportWorkItem, 3);
                    }

                    // Remove workitem from the cache
                    ImporterWorkItemCache.Remove(this.WorkItem);
                }
                else if (this.Worker.CancellationPending)
                {
                    // Create the WorkItem in a cancelled status, for later cleanup
                    this.WorkItem.Status = ImporterWorkItemStatuses.CancelledDirectImportStaging;
                    ProgressViewModel.Text = "Updating work item...";
                    RetryUtility.RetryAction(this.CreateDirectImportWorkItem, 3);

                    // Remove workitem from the cache
                    ImporterWorkItemCache.Remove(this.WorkItem);

                    // Display the Cancellation notification
                    this.ProgressViewModel.IsWorkInProgress = false;

                    this.DialogService.ShowAlertBox(
                        this.UIDispatcher,
                        "The direct import operation was cancelled.",
                        "Direct Import Cancelled",
                        MessageTypes.Info);
                }
                else
                {
                    // Upate the status to ReadyForImport
                    this.WorkItem.Status = ImporterWorkItemStatuses.ReadyForImport;

                    // Save the workitem to Vista but don't cache it - it's already there...
                    ProgressViewModel.Text = "Updating work item...";
                    RetryUtility.RetryAction(this.CreateDirectImportWorkItem, 3);

                    // Show information message
                    this.ProgressViewModel.IsWorkInProgress = false;

                    // Remove workitem from the cache
                    ImporterWorkItemCache.Remove(this.WorkItem);

                    this.DialogService.ShowAlertBox(
                        this.UIDispatcher,
                        "Media has been staged and the work item is queued for import processing.",
                        "Queued for Import",
                        MessageTypes.Info);
                }
            }
            catch (Exception ex)
            {
                this.ProgressViewModel.IsWorkInProgress = false;

                this.DialogService.ShowAlertBox(
                    this.UIDispatcher,
                    "An error occurred during direct import: " + ex.Message,
                    "Direct Import Staging Failed",
                    MessageTypes.Error);

                Logger.Error("Direct Import failed: " + ex.Message, ex);
            }
        }

        /// <summary>
        /// The stage direct import complete.
        /// </summary>
        /// <param name="o">
        /// The o.
        /// </param>
        /// <param name="args">
        /// The args.
        /// </param>
        private void StageDirectImportComplete(object o, RunWorkerCompletedEventArgs args)
        {
            this.ProgressViewModel.IsWorkInProgress = false;

            // Unsubscribes from the New User Login Event
            this.eventAggregator.GetEvent<NewUserLoginEvent>().Unsubscribe(this.SetNewUserLoginAlert);

            // Set the workitem to null so we aren't prompted for confirmation on returning to direct import
            // home
            this.WorkItem = null;

            if (!this.isNewUserLogin)
            {
                // Return to Direct Import Home
                this.NavigateMainRegionTo(ImporterViewNames.SelectMediaCategoryView + "?IsForMediaStaging=false");
            }
            else
            {
                this.isNewUserLogin = false;
            }
        }


        /// <summary>
        /// The update staged work item status.
        /// </summary>
        private void UpdateStagedWorkItemStatus()
        {
            this.DicomImporterDataSource.UpdateWorkItem(
                this.WorkItem, ImporterWorkItemStatuses.InReconciliation, ImporterWorkItemStatuses.ReadyForImport);
        }

        private bool AllowPerformImport()
        {
            return !this.ProgressViewModel.IsWorkInProgress && !this.stagedImportInProgress;

            //bool isCommunityCare = this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.CommunityCare.Code);
            //bool isCommunityCareValidated = this.WorkItemDetails.DicomCorrectReason.StartsWith("Community Care");
            //return (isCommunityCare && isCommunityCareValidated) ||
            //         (!this.ProgressViewModel.IsWorkInProgress && !this.stagedImportInProgress);
        }

        #endregion
    }
}