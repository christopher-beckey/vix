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
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;
    using DicomImporter.Common.Views;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.StorageDataSource;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The direct import home view model.
    /// </summary>
    public class DirectImportHomeViewModel : MediaReadingViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The drive message
        /// </summary>
        private const string DriveAndFolderMessage = "Please select a drive or folder.";

        /// <summary>
        /// The non dicom file message
        /// </summary>
        private const string NonDicomFileMessage = "Please select at least one Non-Dicom file.";

        /// <summary>
        /// The drive letter.
        /// </summary>
        private string driveLetter;

        /// <summary>
        /// The folder.
        /// </summary>
        private string folder;

        /// <summary>
        /// The use drive.
        /// </summary>
        private bool useDrive;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DirectImportHomeViewModel"/> class.
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
        public DirectImportHomeViewModel(
            IDialogService dialogService, 
            IDicomImporterDataSource dicomImporterDataSource, 
            IStorageDataSource storageDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;
            this.StorageDataSource = storageDataSource;

            this.PerformActionCommand = new DelegateCommand<object>(
                o => this.BuildWorkItemAndNavigateToStudyList(), o => this.CanPerformAction());

            this.CancelActionCommand = new DelegateCommand<object>(o => this.CancelAction(), o => this.CanCancel());

            this.NavigateBackCommand = new DelegateCommand<object>(
                 o => this.NavigateMainRegionTo(ImporterViewNames.SelectMediaCategoryView +
                                                "?IsForMediaStaging=false&MediaCategory=" + this.MediaCategory.Category),
                o => !this.ProgressViewModel.IsWorkInProgress);

            this.ProgressViewModel.IsWorkInProgress = false;

            this.UseDrive = true;
            this.RaisePropertyChanged("DriveControlsEnabled");
            this.RaisePropertyChanged("FolderControlsEnabled");

            this.NonDicomFilesChangedCommand = new DelegateCommand<CancelEventArgs>(this.onNonDicomFilesChanged);
            NonDicomMediaViewModel.NonDicomFilesUpdatedCommand.RegisterCommand(this.NonDicomFilesChangedCommand);

        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets a value indicating whether DriveControlsEnabled.
        /// </summary>
        public bool DriveControlsEnabled
        {
            get
            {
                return !this.ProgressViewModel.IsWorkInProgress && this.UseDrive;
            }
        }

        /// <summary>
        /// Gets or sets DriveLetter.
        /// </summary>
        public string DriveLetter
        {
            get
            {
                return this.driveLetter;
            }

            set
            {
                if (this.driveLetter != value)
                {
                    // If they change the drive path, clear everything in memory related to the work item
                    this.WorkItem = null;
                    this.SelectedStudies = null;
                }

                this.driveLetter = value;
                this.ShowOrHideMediaSourceMessage();
                this.PerformActionCommand.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets or sets Folder.
        /// </summary>
        public string Folder
        {
            get
            {
                return this.folder;
            }

            set
            {
                if (this.folder != value)
                {
                    // If they change the folder, clear everything in memory related to the work item
                    this.WorkItem = null;
                    this.SelectedStudies = null;
                }

                this.folder = value;
                this.ShowOrHideMediaSourceMessage();
                this.PerformActionCommand.RaiseCanExecuteChanged();

                //Added RaisePropertyChanged event handler to retain file path in text box.Earlier raising events are handled through imlementing library {NotifyPropertyWeaverMsBuildTask}.(p289-OITCOPondiS)
                this.RaisePropertyChanged("Folder");
            }
        }

        /// <summary>
        /// Gets a value indicating whether FolderControlsEnabled.
        /// </summary>
        public bool FolderControlsEnabled
        {
            get
            {
                return !this.ProgressViewModel.IsWorkInProgress && !this.UseDrive;
            }
        }

        /// <summary>
        /// Gets or sets NavigateToImporterHomeView.
        /// </summary>
        public DelegateCommand<object> NavigateBackCommand { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether UseDrive.
        /// </summary>
        public bool UseDrive
        {
            get
            {
                return this.useDrive;
            }

            set
            {
                this.useDrive = value;

                this.RemoveMessage(DriveAndFolderMessage);
                
                this.ShowOrHideMediaSourceMessage();
               
                this.PerformActionCommand.RaiseCanExecuteChanged();
                this.RaisePropertyChanged("DriveControlsEnabled");
                this.RaisePropertyChanged("FolderControlsEnabled");
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// The get study list.
        /// </summary>
        /// <param name="o">
        /// The o.
        /// </param>
        /// <param name="args">
        /// The args.
        /// </param>
        public void GetStudyList(object o, DoWorkEventArgs args)
        {
            this.ProgressViewModel.Text = "Reading Studies from Drive...";
            string sourcePath = this.UseDrive ? this.DriveLetter : this.Folder;

            if (this.ReadDicomStudiesFromPath(sourcePath, false, string.Empty))
            {
                // Attach the the temporary study list to the workitem details
                this.WorkItem.WorkItemDetails.Studies = new ObservableCollection<Study>(this.StudiesOnMedia);

                if (this.Worker.CancellationPending)
                {
                    args.Cancel = true;
                    return;
                }

                // We have built the study list. Remove unsupported SOP instances, if any, and see if we should 
                // continue
                if (this.StripUnsupportedSopInstances(sourcePath, this.WorkItem.WorkItemDetails.Studies))
                {
                    this.StudyListBuiltSuccessfully = true;
                }
                else
                {
                    this.StudyListBuiltSuccessfully = false;
                }
            }
            else
            {
                this.StudyListBuiltSuccessfully = false;
            }
        }

        /// <summary>
        /// The get study list completed.
        /// </summary>
        /// <param name="o">
        /// The o.
        /// </param>
        /// <param name="args">
        /// The args.
        /// </param>
        public void GetStudyListCompleted(object o, RunWorkerCompletedEventArgs args)
        {
            this.ProgressViewModel.IsWorkInProgress = false;
            this.NonDicomMediaViewModel.IsWorkInProgress = false;

            if (args.Error == null && !args.Cancelled && this.StudyListBuiltSuccessfully)
            {
                // No errors and not cancelled. If studies were found, continue. Otherwise, notify
                // the user that no media could be found
                // If there were no studies able to be resolved, tell the user and halt progress
                if (this.WorkItemDetails.Studies != null && this.WorkItemDetails.Studies.Count > 0)
                {
                    if (this.MediaCategory != null)
                    {
                        // adds the Non-Dicom files to the work item details 
                        if (this.MediaCategory.Category.Equals(MediaCategories.Mixed))
                        {
                            this.WorkItem.WorkItemDetails.NonDicomFiles = this.NonDicomMediaViewModel.NonDicomFiles;
                        }

                        this.WorkItem.MediaCategory = this.MediaCategory;
                    }

                    ImporterWorkItemCache.Add(this.WorkItem);
                    NavigateMediaCategoryAndWorkItem(ImporterViewNames.StudyListView);
                }
                else
                {
                    this.AddMessage(MessageTypes.Warning, "No DICOM media was found on the drive. There is nothing to import.");

                    this.ResetControls();
                }
            }
            else
            {
                if (args.Error != null)
                {
                    // It was an exception, so display the error window
                    this.DicomImporterDataSource.CreateImporterWorkItem(this.WorkItem, false);
                    this.DialogService.ShowExceptionWindow(UIDispatcher, args.Error);
                }
                else if (args.Cancelled)
                {
                    // Display cancellation notification
                    this.DialogService.ShowAlertBox(
                        this.UIDispatcher, 
                        "Direct Import operation cancelled.", 
                        "Direct Import Cancelled", 
                        MessageTypes.Info);
                }

                this.NavigateMainRegionTo(ImporterViewNames.DirectImportHomeView);
            }
        }

        #endregion

        #region Events

        /// <summary>
        /// The on navigated to.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        public override void OnNavigatedTo(NavigationContext navigationContext)
        {
            base.OnNavigatedTo(navigationContext);
           
            this.PopulateDriveList();
            this.NonDicomMediaViewModel = new NonDicomMediaViewModel(this.UIDispatcher);

            this.SetMediaCategoryProperties();

            this.ShowOrHideNonDicomFileMessage();
            this.ShowOrHideMediaSourceMessage();
        }

        /// <summary>
        /// On the non dicom files changed.
        /// </summary>
        /// <param name="args">The <see cref="CancelEventArgs" /> instance containing the event data.</param>
        public void onNonDicomFilesChanged(CancelEventArgs args)
        {
            this.ShowOrHideNonDicomFileMessage();
            PerformActionCommand.RaiseCanExecuteChanged();
        }
        
        #endregion

        #region Methods

        /// <summary>
        /// The cancel action.
        /// </summary>
        protected void CancelAction()
        {
            this.Worker.CancelAsync();
            this.ProgressViewModel.Text = "Cancellation pending...";
            this.CancelActionCommand.RaiseCanExecuteChanged();
            this.NavigateBackCommand.RaiseCanExecuteChanged();
        }

        /// <summary>
        /// The build work item and navigate to study list.
        /// </summary>
        private void BuildWorkItemAndNavigateToStudyList()
        {
            bool mediaReady = true;

            this.ClearMessages();

            // Adds the Non-Dicom files to the work item details and advances to the next view
            // There is no need to attempt to process DICOM files if we are only dealing with NonDICOM files
            if (this.IsNonDicomMediaCategory())
            {
                this.InitializeWorkItem(MediaCategories.NonDICOM, false, "");
                this.WorkItem.WorkItemDetails.NonDicomFiles = this.NonDicomMediaViewModel.NonDicomFiles;

                ImporterWorkItemCache.Add(this.WorkItem);

                this.NavigateMediaCategoryAndWorkItem(ImporterViewNames.NonDicomListView);

                return;
            }

            if (this.UseDrive)
            {
                // We're using a Drive. Make sure it's ready...
                var driveInfo = new DriveInfo(this.DriveLetter);
                if (!driveInfo.IsReady)
                {
                    this.ShowDriveNotReadyAlert();
                    mediaReady = false;
                }
            }
            else if (!Directory.Exists(this.Folder))
            {
                // We're using a Folder, but it doesn't exist. Someone must
                // have deleted it out from under us. (Probably Lenard...) 
                this.ShowFolderNotFoundAlert();
                mediaReady = false;
            }

            if (mediaReady)
            {
                this.ProgressViewModel.IsWorkInProgress = true;
                this.RaisePropertyChanged("DriveControlsEnabled");
                this.RaisePropertyChanged("FolderControlsEnabled");

                this.PerformActionCommand.RaiseCanExecuteChanged();
                this.NavigateBackCommand.RaiseCanExecuteChanged();
                this.CancelActionCommand.RaiseCanExecuteChanged();

                this.NonDicomMediaViewModel.IsWorkInProgress = true;

                // Create and spawn a new backround worker to actually read the drive.
                // This lets us cancel if necessary, etc.
                this.Worker = new BackgroundWorker { WorkerSupportsCancellation = true };
                this.Worker.DoWork += this.GetStudyList;
                this.Worker.RunWorkerCompleted += this.GetStudyListCompleted;
                this.Worker.RunWorkerAsync();
            }
        }

        /// <summary>
        /// Determines whether the user can cancel the direct import, used to enable or disable
        /// the cancel button.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if this instance can cancel; otherwise, <c>false</c>.
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
        /// Determines whether the user can perform an import at the current time.
        /// Used to enable or disable the button.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if this instance [can perform action]; otherwise, <c>false</c>.
        /// </returns>
        private bool CanPerformAction()
        {
            bool performAction = false;

            // Can't perform action if work is already in progress
            if (this.ProgressViewModel.IsWorkInProgress)
            {
                return performAction;
            }

            switch (this.MediaCategory.Category)
            {
                case MediaCategories.DICOM:
                    performAction = this.CanPerformDicomMediaAction();
                    break;
                case MediaCategories.Mixed:
                    performAction = this.CanPerformDicomMediaAction() && this.CanPerformNonDicomMediaAction();
                    break;
                case MediaCategories.NonDICOM:
                    performAction = this.CanPerformNonDicomMediaAction();
                    break;
            }

            return performAction;
        }

        /// <summary>
        /// Determines whether this instance [can perform dicom media action].
        /// </summary>
        /// <returns>
        ///   <c>true</c> if this instance [can perform dicom media action]; otherwise, <c>false</c>.
        /// </returns>
        bool CanPerformDicomMediaAction()
        {
            // If we're using a drive but no drive is selected, can't do it
            if (this.useDrive && string.IsNullOrEmpty(this.driveLetter))
            {
                return false;
            }

            // If we're using a folder, but no folder selected, can't do it
            if (!this.useDrive && string.IsNullOrEmpty(this.folder))
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Determines whether this instance [can perform non dicom media action].
        /// </summary>
        /// <returns>
        ///   <c>true</c> if this instance [can perform non dicom media action]; otherwise, <c>false</c>.
        /// </returns>
        bool CanPerformNonDicomMediaAction()
        {
            // atleast one non dicom file needs to be added in order to continue
            if (this.NonDicomMediaViewModel == null ||
                this.NonDicomMediaViewModel.NonDicomFiles.Count == 0)
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// The reset controls.
        /// </summary>
        private void ResetControls()
        {
            // There was either an error or cancellation, so we're staying on this
            // screen. Reset controls
            this.RaisePropertyChanged("DriveControlsEnabled");
            this.RaisePropertyChanged("FolderControlsEnabled");
            this.PerformActionCommand.RaiseCanExecuteChanged();
            this.NavigateBackCommand.RaiseCanExecuteChanged();
            this.CancelActionCommand.RaiseCanExecuteChanged();
        }

        /// <summary>
        /// The show drive not ready alert.
        /// </summary>
        private void ShowDriveNotReadyAlert()
        {
            this.AddMessage(MessageTypes.Error,
                                                      "Drive " + this.DriveLetter + " cannot be read from at this time. Direct Import cannot continue.");
        }

        /// <summary>
        /// The show folder not found alert.
        /// </summary>
        private void ShowFolderNotFoundAlert()
        {
            this.AddMessage(MessageTypes.Error,
                                                      "The specified folder does not exist. Please choose another folder.");
        }

        /// <summary>
        /// Shows or hides the media source message.
        /// </summary>
        private void ShowOrHideMediaSourceMessage()
        {
            bool driveSelected = !string.IsNullOrEmpty(this.DriveLetter) && this.UseDrive;
            bool folderSelected = !string.IsNullOrEmpty(this.Folder) && !this.UseDrive;

            if (driveSelected || folderSelected)
            {
                this.RemoveMessage(DriveAndFolderMessage);
            }
            else if (this.IsMixedorDicomMedia && !driveSelected && !folderSelected)
            {
                this.AddMessage(MessageTypes.Info, DriveAndFolderMessage);
            }
        }

        /// <summary>
        /// Shows or hides the non dicom file message.
        /// </summary>
        private void ShowOrHideNonDicomFileMessage()
        {
            if (this.IsMixedorNonDicomMedia && this.NonDicomMediaViewModel.NonDicomFiles.Count > 0)
            {
                this.RemoveMessage(NonDicomFileMessage);
            }
            else if (this.IsMixedorNonDicomMedia && this.NonDicomMediaViewModel.NonDicomFiles.Count == 0)
            {
                this.AddMessage(MessageTypes.Info, NonDicomFileMessage);
            }
        }

        #endregion
    }
}