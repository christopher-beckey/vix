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
    using System.IO;
    using System.Linq;
    using System.Net;
   using System.Text.RegularExpressions;
   using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.Services;
    using DicomImporter.Common.User;
    using DicomImporter.Common.Views;
    using ImagingClient.Infrastructure;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.PatientDataSource;
    using ImagingClient.Infrastructure.Storage.Model;
    using ImagingClient.Infrastructure.StorageDataSource;
    using ImagingClient.Infrastructure.User.Model;
    using ImagingClient.Infrastructure.Utilities;
    using ImagingClient.Infrastructure.ViewModels;
    using log4net;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The importer view model.
    /// </summary>
    public class ImporterViewModel : ImagingViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The importer messages view model
        /// </summary>
        //public  ImporterMessagesViewModel ImporterMessagesViewModel = new ImporterMessagesViewModel();

        /// <summary>
        /// The importer server root directory.
        /// </summary>
        protected const string ImporterServerRootDirectory = "ImporterStaging";

        /// <summary>
        /// The work item in invalid state caption.
        /// </summary>
        protected const string WorkItemInInvalidStateCaption = "Work Item in Invalid Status";

        /// <summary>
        /// The work item not found caption.
        /// </summary>
        protected const string WorkItemNotFoundErrorCaption = "Work Item Not Found";

        /// <summary>
        /// The work item not found message.
        /// </summary>
        protected const string WorkItemNotFoundErrorMessage =
            "The selected work item was not found on the server. It may have been deleted.";

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(ImporterViewModel));

        #endregion

        #region Public Properties

        public IDialogServiceImporter m_dlgServiceImporter { get; set; }

        /// <summary>
        /// Gets or sets CancelReconciliationCommand.
        /// </summary>
        public DelegateCommand<object> CancelReconciliationCommand { get; set; }

        /// <summary>
        /// Gets CurrentReconciliation.
        /// </summary>
        public Reconciliation CurrentReconciliation
        {
            get
            {
                if (this.CurrentStudy != null)
                {
                    return this.CurrentStudy.Reconciliation;
                }

                return null;
            }
        }

        /// <summary>
        /// Gets CurrentStudy.
        /// </summary>
        public Study CurrentStudy
        {
            get
            {
                if (this.WorkItemDetails != null)
                {
                    return this.WorkItemDetails.CurrentStudy;
                }

                return null;
            }
        }

        /// <summary>
        /// Gets or sets DicomImporterDataSource.
        /// </summary>
        public IDicomImporterDataSource DicomImporterDataSource { get; set; }

        /// <summary>
        /// Gets a value indicating whether HasAdministratorKey.
        /// </summary>
        public bool HasAdministratorKey
        {
            get
            {
                return UserContext.UserHasKey(ImporterSecurityKeys.Administrator);
            }
        }

        /// <summary>
        /// Gets a value indicating whether HasAdvancedStagingKey.
        /// </summary>
        public bool HasAdvancedStagingKey
        {
            get
            {
                return UserContext.UserHasKey(ImporterSecurityKeys.AdvancedStaging);
            }
        }

        /// <summary>
        /// Gets a value indicating whether HasContractedStudiesKey.
        /// </summary>
        public bool HasContractedStudiesKey
        {
            get
            {
                return UserContext.UserHasKey(ImporterSecurityKeys.ContractedStudies);
            }
        }

        /// <summary>
        /// Gets a value indicating whether HasReportsKey.
        /// </summary>
        public bool HasReportsKey
        {
            get
            {
                return UserContext.UserHasKey(ImporterSecurityKeys.Reports);
            }
        }

        /// <summary>
        /// Gets a value indicating whether HasStagingKey.
        /// </summary>
        public bool HasStagingKey
        {
            get
            {
                return UserContext.UserHasKey(ImporterSecurityKeys.Staging);
            }
        }

        /// <summary>
        /// Gets or sets the media category.
        /// </summary>
        public MediaCategory MediaCategory { get; set; }

        /// <summary>
        /// Gets or sets the Service.
        /// </summary>
        public Service WorkItemService { get; set; }

        /// <summary>
        /// Gets or sets PatientDataSource.
        /// </summary>
        public IPatientDataSource PatientDataSource { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [show only one message].
        /// </summary>
        public bool ShowOnlyOneMessage 
        {
            set
            {
                this.ImporterMessagesViewModel.ShowOnlyOneMessage = value;
            }
        }
        /// <summary>
        /// Gets or sets StorageDataSource.
        /// </summary>
        public IStorageDataSource StorageDataSource { get; set; }

        /// <summary>
        /// Gets or sets DialogService.
        /// </summary>
        public IImporterDialogService ImporterDialogService { get; set; }

        /// <summary>
        /// Gets or sets WorkItem.
        /// </summary>
        public ImporterWorkItem WorkItem { get; set; }

        public string SelectedWorkItemKey { get; set; }
        public string CurrentModalities { get; set; }

        public bool IsFirstWorkListLoading { get; set; }

        /// <summary>
        /// Gets WorkItemDetails.
        /// </summary>
        public ImporterWorkItemDetails WorkItemDetails
        {
            get
            {
                if (this.WorkItem != null)
                {
                    return this.WorkItem.WorkItemDetails;
                }

                return null;
            }
        }

        public bool IsMediaBundleStaged
        {
            get
            {
                bool isStaged = false;
                if (this.WorkItemDetails != null)
                {
                    isStaged = this.WorkItemDetails.IsMediaBundleStaged;
                }
                return isStaged;
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Adds the message to the list.
        /// </summary>
        /// <param name="messageType">Type of the message.</param>
        /// <param name="message">The message.</param>
        public void AddMessage(MessageTypes messageType, string message)
        {
            if (this.ImporterMessagesViewModel == null)
            {
                this.ImporterMessagesViewModel = new ImporterMessagesViewModel();
            }

            this.ImporterMessagesViewModel.AddMessage(messageType, message);
        }

        /// <summary>
        /// Calls to cancel the reconciliation, specifying that confirmation should be requested.
        /// </summary>
        public void CancelReconciliation()
        {
            this.CancelReconciliation(true);
        }

        public void CancelReconciliation(IDialogServiceImporter dlgServiceImporter)
        {
            m_dlgServiceImporter = dlgServiceImporter;
            this.CancelReconciliation(true);
        }


        /// <summary>
        /// Cancels the reconciliation.
        /// 
        /// This method is the "first level" of cancellation. It clears out the
        /// Reconciliation that is currently being worked, if any, and returns the user
        /// to the study list page.
        /// </summary>
        /// <param name="askForConfirmation">if set to <c>true</c> [ask for confirmation].</param>
        public void CancelReconciliation(bool askForConfirmation)
        {
            // Start by assuming we will delete the reconciliation
            bool cancelReconciliation = true;

            // if we need to ask for confirmation, double check with the user
            if (askForConfirmation)
            {
                cancelReconciliation = this.DialogService.ShowYesNoBox(
                    this.UIDispatcher,
                    "Are you sure you want to cancel this reconciliation?",
                    "Cancel Reconciliation",
                    MessageTypes.Question);
            }

            // If we still need to cancel the reconciliation, continue
            if (cancelReconciliation)
            {
                // Remove the reconciliation from the ImporterWorkItem
                if (this.CurrentStudy != null)
                {
                    Reconciliation reconciliation = this.CurrentStudy.Reconciliation;
                    if (reconciliation != null)
                    {
                        this.WorkItemDetails.Reconciliations.Remove(reconciliation);
                        reconciliation.Patient = null;
                        reconciliation.Order = null;
                        this.CurrentStudy.Reconciliation = null;
                        this.CurrentStudy.ReconciledForImport = false;
                    }
                }

                // Return to the study list or non-DICOM file list
                if (IsDicomWorkItem)
                {
                    this.NavigateWorkItem(ImporterViewNames.StudyListView);
                }
                else
                {
                    this.NavigateWorkItem(ImporterViewNames.NonDicomListView);
                }
            }
        }

        /// <summary>
        /// Clears the messages.
        /// </summary>
        public void ClearMessages()
        {
            if (this.ImporterMessagesViewModel == null)
            {
                this.ImporterMessagesViewModel = new ImporterMessagesViewModel();
            }
            else
            {
                this.ImporterMessagesViewModel.ClearMessages();
            }
        }

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
            // By default, just say "yes" to navigation. This can be more complex in subclasses
            continuationCallback(true);
        }

        /// <summary>
        /// Gets the full path of a SOP Instance, depending on whether or not it is staged or local.
        /// </summary>
        /// <param name="sopInstance">
        /// The sop instance.
        /// </param>
        /// <returns>
        /// The full path of the instance.
        /// </returns>
        public string GetFullPath(SopInstance sopInstance)
        {
            string fullPath;
            if (this.WorkItemDetails.IsMediaBundleStaged)
            {
                // If the media bundle is staged, the full path is in three pieces:
                // Network Location:Media Bundle Root at that Location:File Path from SOP Instance
                NetworkLocationInfo networkLocationInfo =
                    this.StorageDataSource.GetNetworkLocationDetails(this.WorkItemDetails.NetworkLocationIen);
                fullPath = PathUtilities.CombinePath(
                    networkLocationInfo.PhysicalPath, this.WorkItemDetails.MediaBundleStagingRootDirectory);
                fullPath = PathUtilities.CombinePath(fullPath, sopInstance.FilePath);
            }
            else
            {
                // We are reading from a local drive. The full path is just the local source path followed by the SopInstance
                // file Path
                fullPath = PathUtilities.CombinePath(this.WorkItemDetails.LocalSourcePath, sopInstance.FilePath);
            }

            return fullPath;
        }

        /// <summary>
        /// Gets or sets the importer messages view model.
        /// </summary>
        public ImporterMessagesViewModel ImporterMessagesViewModel { get; set; }

        /// <summary>
        /// Navigates to the next view with a media category as a paramter.
        /// </summary>
        /// <param name="nextView">The next view.</param>
        public void NavigateMediaCategory(string nextView)
        {
            this.NavigateMainRegionTo(nextView + "?MediaCategory=" + this.MediaCategory.Category +
                                      "&WorkItemService=" + this.WorkItemService.Value);
        }

        /// <summary>
        /// Navigates to the next view with a  media category and work item as a parameter. 
        /// </summary>
        /// <param name="nextView">The next view.</param>
        public void NavigateMediaCategoryAndWorkItem(string nextView)
        {
            this.NavigateMainRegionTo(nextView + "?WorkItemKey=" + this.WorkItem.Key +
                                      "&MediaCategory=" + this.MediaCategory.Category +
                                      "&Modalities=" + this.CurrentModalities);
        }
        /// <summary>
        /// The navigate work item.
        /// </summary>
        /// <param name="nextView">
        /// The next view.
        /// </param>
        public void NavigateWorkItem(string nextView)
        {
            this.NavigateMainRegionTo(nextView + "?WorkItemKey=" + this.WorkItem.Key +
                "&Modalities=" + this.CurrentModalities);
        }

          /// <summary>
        /// The on navigated from.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        public override void OnNavigatedFrom(NavigationContext navigationContext)
        {
            base.OnNavigatedFrom(navigationContext);

            if (this.ImporterMessagesViewModel != null)
            {
                this.ImporterMessagesViewModel.ClearMessages();
            }
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

            this.ImporterMessagesViewModel = new ImporterMessagesViewModel();

            string workItemKey = navigationContext.Parameters["WorkItemKey"];
            string mediaCategory = navigationContext.Parameters["MediaCategory"];
            string isForMediaStaging = navigationContext.Parameters["IsForMediaStaging"];
            string workItemService = navigationContext.Parameters["WorkItemService"];
            string isFirstWorkListLoading = navigationContext.Parameters["IsFirstWorkListLoading"];
            string modalities = navigationContext.Parameters["Modalities"];

            if (workItemKey != null)
            {
                this.WorkItem = this.DicomImporterDataSource.GetImporterWorkItemByKey(workItemKey);
                this.SelectedWorkItemKey = workItemKey;
            }
            
            if (mediaCategory != null)
            {
                if (this.MediaCategory == null)
                {
                    this.MediaCategory = new MediaCategory();
                }

                this.MediaCategory.Category = mediaCategory;
            }

            if (workItemService != null)
            {
                if (this.WorkItemService == null)
                {
                    this.WorkItemService = new Service();
                }

                this.WorkItemService.Value = workItemService;
            }

            if (isForMediaStaging != null)
            {
                if (this.MediaCategory == null)
                {
                    this.MediaCategory = new MediaCategory();
                }

                this.MediaCategory.IsForMediaStaging = Convert.ToBoolean(isForMediaStaging);
            }

            this.IsFirstWorkListLoading = true;
            if (!string.IsNullOrEmpty(isFirstWorkListLoading))
            {
                this.IsFirstWorkListLoading = Convert.ToBoolean(isFirstWorkListLoading);
            }

            if (modalities != null)
            {
                this.CurrentModalities = modalities;
            }
        }

        /// <summary>
        /// Removes the message.
        /// </summary>
        /// <param name="message">The message.</param>
        public void RemoveMessage(string message)
        {
            if (this.ImporterMessagesViewModel == null)
            {
                this.ImporterMessagesViewModel = new ImporterMessagesViewModel();
            }

            this.ImporterMessagesViewModel.RemoveMessage(message);
        }

        #endregion

        #region Methods

        /// <summary>
        /// Deletes a work item from M, as well as all staged media associated with the work item.
        /// </summary>
        /// <param name="importerWorkItem">
        /// The importer work item to delete.
        /// </param>
        protected bool DeleteImporterWorkItem(ImporterWorkItem importerWorkItem)
        {
            NetworkLocationInfo networkLocationInfo = this.StorageDataSource.GetNetworkLocationDetails(importerWorkItem.WorkItemDetailsReference.NetworkLocationIen);

            // Open a network connection
            NetworkConnection conn = null;
            try
            {
                conn = NetworkConnection.GetNetworkConnection(networkLocationInfo.PhysicalPath, new NetworkCredential(networkLocationInfo.Username, networkLocationInfo.Password));

                if (conn == null)
                {
                    throw new NetworkLocationConnectionException("Could not connect to the current write location at '" + networkLocationInfo.PhysicalPath + "'");
                }

                // Get the fully qualified path to the staging root directory
                String stagingRootDirectory = PathUtilities.CombinePath(networkLocationInfo.PhysicalPath, importerWorkItem.WorkItemDetailsReference.MediaBundleStagingRootDirectory);

                // Get the list of files under the staging root, stripping out the ImporterWorkItemDetails.xml file
                var fileList = new List<string>();
                PathUtilities.AddFiles(stagingRootDirectory, "*", fileList);

                var filteredList = (from filePath in fileList
                            where !filePath.Contains("ImporterWorkItemDetails.xml")
                            select filePath).ToList();

                if (ImporterDialogService.ConfirmWorkItemDelete(this.UIDispatcher, filteredList.Count, stagingRootDirectory))
                {
                    // Get the full item in order to transition it to cancelled staging in the process. 
                    // This will cause it to get purged right away on the HDIG.
                    this.DicomImporterDataSource.GetAndTranstionImporterWorkItem(importerWorkItem, importerWorkItem.Status, ImporterWorkItemStatuses.CancelledStaging);

                    return true;

                }
                else
                {
                    return false;
                }
            }
            catch (Exception e)
            {
               Logger.Error(e.Message, e);
            }
            finally
            {
                if (conn != null)
                {
                    conn.Dispose();
                }
            }

            return false;
        }

        /// <summary>
        /// Updates work item service from M
        /// </summary>
        /// <param name="importerWorkItem">
        /// The importer work item to update
        /// </param>
        protected bool UpdateWorkItemService(ImporterWorkItem selectedWorkItem, out string service, out string errMsg)
        {
            service = string.Empty;
            errMsg = string.Empty;
            try
            {
                if (ImporterDialogService.SelectService(this.UIDispatcher, out service))
                {
                    if (this.DicomImporterDataSource.UpdateWorkItemService(
                        selectedWorkItem.Service, selectedWorkItem.Modality,
                        selectedWorkItem.Procedure, service, out errMsg))
                    {
                        return true;
                    }
                    else
                    {
                        Logger.Error("Calling RPC error: " + errMsg);
                        return false;
                    }
                }
                else
                {
                    return false;
                }
            }
            catch (Exception e)
            {
                Logger.Error(e.Message, e);
                errMsg = "Exception error: " + e.Message;
                return false;
            }

        }

        /// <summary>
        /// The confirm cancellation.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        /// <param name="reason">
        /// The reason.
        /// </param>
        protected void ConfirmCancellation(CancelEventArgs args, string reason)
        {
            if (this.DialogService.ShowYesNoBox(
                this.UIDispatcher, 
                "Are you sure you want to " + reason + "? Work on your current reconciliations will be lost.", 
                "Leave Reconciliation", 
                MessageTypes.Warning))
            {
                if (m_dlgServiceImporter == null)
                {
                    this.DicomImporterDataSource.CancelImporterWorkItem(this.WorkItem);
                }
                else
                {
                    List<object> listParameter = new List<object> {
                        this,
                        this.WorkItem,
                        m_dlgServiceImporter,
                        null};

                    BackgroundWorker threadCancelReconciliation = new BackgroundWorker();
                    threadCancelReconciliation.DoWork += new DoWorkEventHandler(CancelReconciliationThread);
                    threadCancelReconciliation.RunWorkerCompleted += new RunWorkerCompletedEventHandler(CancelReconciliationThreadCompleted);
                    threadCancelReconciliation.RunWorkerAsync(listParameter);
                    m_dlgServiceImporter.ShowDialog();
                }
            }
            else
            {
                args.Cancel = true;
            }
        }

        private void CancelReconciliationThread(object sender, DoWorkEventArgs e)
        {
            if (e.Argument != null && ((List<object>)e.Argument).Count == 4)
            {
                try
                {
                    var viewModel = (ImporterViewModel)((List<object>)e.Argument)[0];
                    var workItem = (ImporterWorkItem)((List<object>)e.Argument)[1];
                    this.DicomImporterDataSource.CancelImporterWorkItem(workItem);
                }
                catch (Exception exception)
                {
                    ((List<object>)e.Argument)[3] = exception;
                }
                e.Result = e.Argument;
            }
        }

        private void CancelReconciliationThreadCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            ((IDialogServiceImporter)((List<object>)e.Result)[2]).CloseDialog();
        }

        /// <summary>
        /// The confirm navigation from active reconciliation.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        /// <param name="continuationCallback">
        /// The continuation callback.
        /// </param>
        protected void ConfirmNavigationFromActiveReconciliation(
            NavigationContext navigationContext, Action<bool> continuationCallback)
        {
            if (LoginManager.IsAttemptingLogout)
            {
                // If the reason we're trying to navigate away is because the user
                // was attempting logout, just continue. The user has already confirmed their intention
                // to leave in the Logout Flow, so we don't need to ask them again.
                continuationCallback(true);
            }
            else if (ImporterViewNames.IsReconciliationView(navigationContext.Uri.OriginalString))
            {
                // We're just moving to another reconciliation view. Continue...
                continuationCallback(true);
            }
            else if (this.WorkItem == null)
            {
                // We are no longer dealing with a work item (i.e import request has just been sent.) Continue...
                continuationCallback(true);
            }
            else
            {
                // There's a current WorkItem, and we're trying to leave the reconcilation flow. Build the confirmation
                // message and title and launch a dialog to confirm navigation.
                var cancelEventArgs = new CancelEventArgs();

                if (this.WorkItem.Subtype == ImporterWorkItemSubtype.DirectImport.Code)
                {
                    this.ConfirmCancellation(cancelEventArgs, "cancel this direct import");
                }
                else
                {
                    this.ConfirmCancellation(cancelEventArgs, "release this work item");
                }

                continuationCallback(!cancelEventArgs.Cancel);
            }
        }

        /// <summary>
        /// Determines whether [is non dicom media category].
        /// </summary>
        /// <returns>
        ///   <c>true</c> if [is non dicom media category]; otherwise, <c>false</c>.
        /// </returns>
        protected bool IsNonDicomMediaCategory()
        {
            if (this.MediaCategory == null)
            {
                return false;
            }
            
            if (!this.MediaCategory.Category.Equals(MediaCategories.NonDICOM))
            {
                return false;
            }
            
            return true;
        }

        protected void LaunchPDFViewer(string filePath)
        {
            if (this.WorkItem != null && this.WorkItem.WorkItemDetails.IsMediaBundleStaged)
            {
                // The media bundle is staged, so we have to open a connection to the network share
                // before we open the item.
                NetworkLocationInfo networkLocationInfo = this.StorageDataSource.GetNetworkLocationDetails(this.WorkItemDetails.NetworkLocationIen);
                string serverAndShare = networkLocationInfo.PhysicalPath;

                NetworkConnection conn = null;
                try
                {
                    conn = NetworkConnection.GetNetworkConnection(
                        serverAndShare, new NetworkCredential(networkLocationInfo.Username, networkLocationInfo.Password));

                    FileLauncherUtilities.ViewPDF(this.UIDispatcher, filePath, "PDF File");

                }
                catch (Exception e)
                {
                    string message = "Error viewing file: " + e.Message;
                    string caption = "Error Viewing File";
                    this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);

                    // Log the exception
                    Logger.Error(message, e);
                }
                finally
                {
                    if (conn != null)
                    {
                        conn.Dispose();
                    }
                }
            }
            else
            {
                // Media is not staged, so just view without opening a network connection
                FileLauncherUtilities.ViewPDF(this.UIDispatcher, filePath, "PDF File");
            }
        }

        /// <summary>
        /// Builds the destination path.
        /// </summary>
        /// <param name="serverAndShare">The server and share.</param>
        /// <param name="rootDir">The root dir.</param>
        /// <param name="filePath">The file path.</param>
        /// <returns>The destination path</returns>
        protected string BuildDestinationPath(string serverAndShare, string rootDir, string filePath)
        {
            string fullPath = PathUtilities.CombinePath(serverAndShare, rootDir);
            fullPath = PathUtilities.CombinePath(fullPath, filePath);

            return fullPath;
        }

        /// <summary>
        /// Builds the source path.
        /// </summary>
        /// <param name="rootDir">The root dir.</param>
        /// <param name="filePath">The file path.</param>
        /// <returns>The source path</returns>
        protected string BuildSourcePath(string rootDir, string filePath)
        {
            string fullPath = PathUtilities.CombinePath(rootDir, filePath);
            return fullPath;
        }

        /// <summary>
        /// The erase and copy file.
        /// </summary>
        /// <param name="sourcePath">
        /// The source path.
        /// </param>
        /// <param name="destinationPath">
        /// The destination path.
        /// </param>
        protected void EraseAndCopyFile(string sourcePath, string destinationPath)
        {
            // Since this may be a retry, attempt to delete any partially completed copies before continuing
            try
            {
                if (File.Exists(destinationPath))
                {
                    File.SetAttributes(destinationPath, FileAttributes.Normal);
                    File.Delete(destinationPath);
                }
            }
            catch (Exception e)
            {
                Logger.Info("Unable to delete previously staged file: " + destinationPath, e);
            }

            File.Copy(sourcePath, destinationPath, true);
        }

        /*
        /// <summary>
        /// Stages the non dicom file.
        /// </summary>
        /// <param name="serverAndShare">The server and share.</param>
        /// <param name="sourceNonDicomFile">The source non dicom file.</param>
        /// <param name="nonDicomRootDir">The non dicom root dir.</param>
        /// <returns></returns>
        protected FileInfo StageNonDicomFile(string serverAndShare, NonDicomFile sourceNonDicomFile, string nonDicomRootDir)
        {
            string fileGuid = Guid.NewGuid() + ".pdf";
            string sourcePath = sourceNonDicomFile.FilePath;
            string destinationPath = this.BuildDestinationPath(serverAndShare, nonDicomRootDir, fileGuid);

            FileInfo destNonDicomFile = new FileInfo(destinationPath);

            if (destNonDicomFile.Directory != null && !destNonDicomFile.Directory.Exists)
            {
                destNonDicomFile.Directory.Create();
            }

            // Copy the file using the default number of retries
            RetryUtility.RetryAction(() => this.EraseAndCopyFile(sourcePath, destinationPath));
            return destNonDicomFile;
        }
        */


        /// <summary>
        /// Stages the non dicom file.
        /// </summary>
        /// <param name="serverAndShare">The server and share.</param>
        /// <param name="sourceNonDicomFile">The source non dicom file.</param>
        /// <param name="nonDicomRootDir">The non dicom root dir.</param>
        /// <returns></returns>
        protected FileInfo StageNonDicomFile(string serverAndShare, NonDicomFile sourceNonDicomFile, string nonDicomRootDir)
        {
            //Fortify Mitigation recommendation for Path manipulation. Added this bool variable to validate the Well-formed logic.(p289-OITCOPondiS)
            bool isValidate = false;
            FileInfo destNonDicomFile =  null;
            string fileGuid = Guid.NewGuid() + ".pdf";
            string sourcePath = sourceNonDicomFile.FilePath;
            string destinationPath = this.BuildDestinationPath(serverAndShare, nonDicomRootDir, fileGuid);

            //Fortify Mitigation recommendation for Path manipulation. Add code to santize the path variable string to be  well-formed  before utilizing FileInfo.(p289-OITCOPondiS)            
            isValidate = PathUtilities.SantizeFilePathStatus(destinationPath);
            //Process the code logic only when path is santized.(p289-OITCOPondiS)            
            if (isValidate)
            {
            /*
            Gary Pham (oitlonphamg)
            P332
            Validate string for nonprintable characters based on Fortify software recommendation.
            */
            //Old code commented by Gary Pham
            //if (Regex.IsMatch(destinationPath, "^[A-Za-z0-9 _.,\\\\!'/$;:%-]+$"))
            //Begin - New code added by Gary Pham
            //Logger.Info("Before regexvalidfilepath:  " + destinationPath);
            if (StringUtilities.IsRegexValidFilePath(destinationPath))
            //End - New code added by Gary Pham
            {
               //Logger.Info("After regexvalidfilepath:  " + destinationPath);
               destNonDicomFile = new FileInfo(destinationPath);
	
	            if (destNonDicomFile.Directory != null && !destNonDicomFile.Directory.Exists)
	            {
	               destNonDicomFile.Directory.Create();
	            }
	            // Copy the file using the default number of retries
	            RetryUtility.RetryAction(() => this.EraseAndCopyFile(sourcePath, destinationPath));
				   }
					
                return destNonDicomFile;
            }

            return destNonDicomFile;
        }
        protected bool IsDicomWorkItem
        {
            get
            {
                if (this.WorkItem.MediaCategory != null &&
                    !this.WorkItem.MediaCategory.Category.Equals(MediaCategories.NonDICOM))
                {
                    return true;
                }

                return false;
            }
        }



        #endregion
    }
}