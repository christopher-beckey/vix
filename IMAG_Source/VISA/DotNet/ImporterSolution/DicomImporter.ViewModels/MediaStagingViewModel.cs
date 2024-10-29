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
    using System.Windows.Threading;
    using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.Views;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Model;
    using ImagingClient.Infrastructure.PatientDataSource;
    using ImagingClient.Infrastructure.StorageDataSource;
    using ImagingClient.Infrastructure.Utilities;
    using log4net;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The media staging view model.
    /// </summary>
    public class MediaStagingViewModel : MediaReadingViewModel
    {
        #region Constants and Fields
        //Get and Set property notification for all private  variables-OITCOPondiS
        /// <summary>
        /// The advanced staging message
        /// </summary>
        private const string AdvancedStagingMessage = "Advanced Staging Selected: Please select atleast one study to stage.";
       
        /// <summary>
        /// The drive message
        /// </summary>
        private const string DriveMessage = "Please select a drive.";
        
        /// <summary>
        /// The change patient.
        /// </summary>
        private const string ChangePatient = "Change Patient";

        /// <summary>
        /// The hide advanced options text.
        /// </summary>
        private const string HideAdvancedOptionsText = "Disable Advanced Options";

        /// <summary>
        /// The non dicom file message
        /// </summary>
        private const string NonDicomFileMessage = "Please select at least one Non-DICOM file.";

        /// <summary>
        /// The select patient.
        /// </summary>
        private const string SelectPatient = "Select Patient";

        /// <summary>
        /// The show advanced options text.
        /// </summary>
        private const string ShowAdvancedOptionsText = "Enable Advanced Options";

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(MediaStagingViewModel));


        //Begin-Get and set property notification in MediaStagingView screen-OITCOPondiS
        /// <summary>
        /// The drive letter.
        /// </summary>
        private string driveLetter { get; set; }
        //private string driveLetter;
        
        /// <summary>
        /// The is patient known.
        /// </summary>
        //private bool isPatientKnown;
        private bool isPatientKnown { get; set; }


        //new private varaibles-OITCOPondiS
        private string _AdvancedOptionsText { get; set; }
        private string _PatientSelectionButtonText { get; set; }
        private bool _PreppingAdvancedOptions { get; set; }
        private bool _ShowAdvancedOptions { get; set; }
        private bool _ShowAdvancedOptionsControls { get; set; }
        
        /// <summary>
        /// The patient.
        /// </summary>
        //private Patient patient;
        private Patient patient { get; set; }
        //End-OITCOPondiS

        /// <summary>
        /// The selected origin index.
        /// </summary>
        //private OriginIndex selectedOriginIndex;
        private OriginIndex selectedOriginIndex { get; set; }

        //End-OITCOPondiS

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="MediaStagingViewModel"/> class.
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
        /// <param name="patientDataSource">
        /// The patient data source.
        /// </param>
        public MediaStagingViewModel(
            IDialogService dialogService, 
            IDicomImporterDataSource dicomImporterDataSource, 
            IStorageDataSource storageDataSource, 
            IPatientDataSource patientDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;
            this.StorageDataSource = storageDataSource;
            this.PatientDataSource = patientDataSource;

            this.ProgressViewModel.IsWorkInProgress = false;

            this.AdvancedOptionsText = ShowAdvancedOptionsText;
            this.ShowAdvancedOptions = false;
            this.ToggleAdvancedOptions = new DelegateCommand<object>(
                o => this.OnToggleAdvancedOptions(), o => this.CanSelectAdvancedOptions());

            this.PerformActionCommand = new DelegateCommand<object>(
                o => this.BuildWorkItemAndCopyMediaToShare(), o => this.CanStage());

            this.ShowStudyDetailsWindow = new DelegateCommand<object>(
                o => this.ShowStudyDetails(this, null), 
                o => (this.SelectedStudies != null && this.SelectedStudies.Count == 1));

            this.NavigateBackCommand = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.SelectMediaCategoryView + 
                                                   "?IsForMediaStaging=true&MediaCategory=" + this.MediaCategory.Category),
                o => !this.ProgressViewModel.IsWorkInProgress);

            this.CancelActionCommand = new DelegateCommand<object>(
                o =>
                    {
                        if (this.PreppingAdvancedOptions)
                        {
                            this.CancelAdvancedOptionsAction();
                        }
                        else
                        {
                            this.CancelAction();
                        }
                    }, 
                o => this.CanCancel());

            this.WorkItem = new ImporterWorkItem();

            this.NonDicomFilesChangedCommand = new DelegateCommand<CancelEventArgs>(this.onNonDicomFilesChanged);
            NonDicomMediaViewModel.NonDicomFilesUpdatedCommand.RegisterCommand(this.NonDicomFilesChangedCommand);
        }

        #endregion

        #region Delegates

        /// <summary>
        /// The show study details window event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public delegate void ShowStudyDetailsWindowEventHandler(object sender, EventArgs e);

        #endregion

        #region Public Events

        /// <summary>
        /// The show study details.
        /// </summary>
        public event ShowStudyDetailsWindowEventHandler ShowStudyDetails;

        #endregion

        #region Public Properties
        //Get and set property notification for all public variables-OITCOPondiS

        /// <summary>
        /// Gets or sets AdvancedOptionsText.
        /// </summary>
        //public string AdvancedOptionsText { get; set; }
        
        public string AdvancedOptionsText
        {
            get { return _AdvancedOptionsText; }
            set
            {
                _AdvancedOptionsText = value;
                this.RaisePropertyChanged("AdvancedOptionsText");
            }
        }
        //p289-OITCOPondiS-End




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
                // If the value is changing, and it's not being cleared....
                if ((this.driveLetter != value) && (value != null))
                {
                    // Clear everything in memory related to the work item
                    this.WorkItem = null;
                    this.SelectedStudies = null;
                    this.StudyListBuiltSuccessfully = false;

                    // if we're already in the advanced options view, reload studies from disk
                    if (this.ShowAdvancedOptions)
                    {
                        this.ShowAdvancedOptions = false;
                        this.InitializeAndShowAdvancedOptions();
                    }

                    // removes the drive message from display
                    this.RemoveMessage(DriveMessage);
                }

                this.driveLetter = value;
                this.PerformActionCommand.RaiseCanExecuteChanged();
                this.ToggleAdvancedOptions.RaiseCanExecuteChanged();
                this.NavigateBackCommand.RaiseCanExecuteChanged();
                //Property notification-OITCOPondiS
                this.RaisePropertyChanged("DriveLetter");
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether IsPatientKnown.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is patient known; otherwise, <c>false</c>.
        /// </value>
        public bool IsPatientKnown
        {
            get
            {
                return this.isPatientKnown;
            }

            set
            {
                this.isPatientKnown = value;

                if (this.isPatientKnown)
                {
                    this.ShowPatientKnownMessage();

                }
                else
                {
                    this.RemoveMessage(this.GeneratePatientKnownMessage());
                }


                this.PerformActionCommand.RaiseCanExecuteChanged();
                this.NavigateBackCommand.RaiseCanExecuteChanged();
                //Fix property notification in MediaStagingView screen-OITCOPondiS
                this.RaisePropertyChanged("IsPatientKnown");
            }
        }

        // Commands

        /// <summary>
        /// Gets or sets NavigateBack.
        /// </summary>
        public DelegateCommand<object> NavigateBackCommand { get; set; }

        /// <summary>
        /// Gets OriginIndexList.
        /// </summary>
        public ObservableCollection<OriginIndex> OriginIndexList
        {
            get
            {
                return this.DicomImporterDataSource.GetOriginIndexList();
            }
        }

        /// <summary>
        /// Gets or sets Patient.
        /// </summary>
        public Patient Patient
        {
            get
            {
                return this.patient;
            }

            set
            {
                this.PatientSelectionButtonText = value == null ? SelectPatient : ChangePatient;

                if (value != null)
                {
                    this.RemoveMessage(this.GeneratePatientKnownMessage());
                }

                this.patient = value;
                this.PerformActionCommand.RaiseCanExecuteChanged();
                this.NavigateBackCommand.RaiseCanExecuteChanged();
                //Begin-Fix property notification in MediaStagingView screen-OITCOPondiS
                this.RaisePropertyChanged("Patient");
                //End-OITCOPondiS
            }
        }

        //Begin-Get and Set  public property and notification-OITCOPondiS
        /// <summary>
        /// Gets or sets PatientSelectionButtonText.
        /// </summary>
        //public string PatientSelectionButtonText { get; set; }
        public string PatientSelectionButtonText
        {
            get { return _PatientSelectionButtonText; }
            set
            {
                _PatientSelectionButtonText = value;
                this.RaisePropertyChanged("PatientSelectionButtonText");
            }
        }
        //End

        /// <summary>
        /// Gets or sets a value indicating whether PreppingAdvancedOptions.
        /// </summary>
        //public bool PreppingAdvancedOptions { get; set; }
        public bool PreppingAdvancedOptions
        {
            get { return _PreppingAdvancedOptions; }
            set
            {
                _PreppingAdvancedOptions = value;
                this.RaisePropertyChanged("PreppingAdvancedOptions");
            }
        }


        /// <summary>
        /// Gets or sets the reconciler notes.
        /// </summary>
        public string ReconcilerNotes 
        {
            get
            {
                if (this.WorkItemDetails != null)
                {
                    return this.WorkItemDetails.ReconcilerNotes;
                }

                return null;
            }

            set
            {
                if (this.WorkItem == null)
                {
                    this.WorkItem = new ImporterWorkItem();
                }

                if (this.WorkItem.WorkItemDetails == null)
                {
                    this.WorkItem.WorkItemDetails = new ImporterWorkItemDetails();
                }

                this.WorkItem.WorkItemDetails.ReconcilerNotes = value;
                //Property notification-OITCOPondiS
                //this.RaisePropertyChanged("ReconcilerNotes");

            }
        }

        /// <summary>
        /// Gets or sets SelectedOriginIndex.
        /// </summary>
        public OriginIndex SelectedOriginIndex
        {
            get
            {
                return this.selectedOriginIndex;
            }

            set
            {
                this.selectedOriginIndex = value;
                this.PerformActionCommand.RaiseCanExecuteChanged();
                this.NavigateBackCommand.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether ShowAdvancedOptions.
        /// </summary>
        //public bool ShowAdvancedOptions { get; set; }
        public bool ShowAdvancedOptions
        {
            get { return _ShowAdvancedOptions; }
            set
            {
                _ShowAdvancedOptions = value;
                this.RaisePropertyChanged("ShowAdvancedOptions");
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether ShowAdvancedOptionsControls.
        /// </summary>
       // public bool ShowAdvancedOptionsControls { get; set; }

        public bool ShowAdvancedOptionsControls
        {
            get { return _ShowAdvancedOptionsControls; }
            set
            {
                _ShowAdvancedOptionsControls = value;
                this.RaisePropertyChanged("ShowAdvancedOptionsControls");
            }
        }

        /// <summary>
        /// Gets or sets ToggleAdvancedOptions.
        /// </summary>
        public DelegateCommand<object> ToggleAdvancedOptions { get; set; }

        #endregion

        #region Public Methods
       
        /// <summary>
        /// The do initialize advanced options.
        /// </summary>
        /// <param name="o">
        /// The o.
        /// </param>
        /// <param name="args">
        /// The args.
        /// </param>
        public void DoInitializeAdvancedOptions(object o, DoWorkEventArgs args)
        {
            if (!this.StudyListBuiltSuccessfully)
            {
                this.ProgressViewModel.Text = "Reading Studies from Drive...";

                if (this.ReadDicomStudiesFromPath(this.DriveLetter, true, this.SelectedOriginIndex.Code))
                {
                    if (this.StudiesOnMedia.Count != 0)
                    {
                        // Attach the the temporary study list to the workitem details
                        this.UIDispatcher.Invoke(
                            DispatcherPriority.Normal,
                            (Action)(() => this.WorkItem.WorkItemDetails.Studies = new ObservableCollection<Study>(this.StudiesOnMedia)));

                        this.StudyListBuiltSuccessfully = true;
                        this.RaisePropertyChanged("StudiesOnMedia");
                    }
                    else
                    {
                        this.ProgressViewModel.Text = "NO DICOM media found...";
                        string message = "No DICOM media was found on the drive. There is nothing to import.";
                        string caption = "No DICOM media found";
                        this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Warning);
                    }
                }
            }
        }

        /// <summary>
        /// The initialize advanced options completed.
        /// </summary>
        /// <param name="o">
        /// The o.
        /// </param>
        /// <param name="args">
        /// The args.
        /// </param>
        public void InitializeAdvancedOptionsCompleted(object o, RunWorkerCompletedEventArgs args)
        {
            this.ProgressViewModel.IsWorkInProgress = false;
            this.NonDicomMediaViewModel.IsWorkInProgress = false;
            this.PreppingAdvancedOptions = false;

            if (this.StudyListBuiltSuccessfully)
            {
                this.ShowAdvancedOptions = true;
                this.AdvancedOptionsText = HideAdvancedOptionsText;
            }
            else
            {
                this.PreppingAdvancedOptions = false;
                this.ShowAdvancedOptions = false;
                this.AdvancedOptionsText = ShowAdvancedOptionsText;
            }

            // if its mixed and the patient is known we need to minimize the amount of messages shown
            // to preserve space.
            if (IsPatientKnown && (this.IsMixedorDicomMedia && this.IsMixedorNonDicomMedia))
            {
                this.ShowOnlyOneMessage = true;
            }

            this.ShowHideAdvancedStagingMessage();

            this.PerformActionCommand.RaiseCanExecuteChanged();
            this.CancelActionCommand.RaiseCanExecuteChanged();
            this.ToggleAdvancedOptions.RaiseCanExecuteChanged();
            this.NavigateBackCommand.RaiseCanExecuteChanged();

            this.RaisePropertyChanged("AdvancedOptionsText");
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
            this.PopulateDriveList();
            this.SelectedOriginIndex = this.OriginIndexList[0];
            this.IsPatientKnown = true;

            this.NonDicomMediaViewModel = new NonDicomMediaViewModel(this.UIDispatcher);
            this.PatientSelectionButtonText = this.Patient == null ? SelectPatient : ChangePatient;

            this.SetMediaCategoryProperties();
            this.ShowMessages();
        }

        /// <summary>
        /// On the non dicom files changed.
        /// </summary>
        /// <param name="args">The <see cref="CancelEventArgs" /> instance containing the event data.</param>
        public void onNonDicomFilesChanged(CancelEventArgs args)
        {
            if (this.NonDicomMediaViewModel.NonDicomFiles.Count > 0)
            {
                this.RemoveMessage(NonDicomFileMessage);
            }
            else
            {
                this.ShowNonDicomFileMessage();
            }

            PerformActionCommand.RaiseCanExecuteChanged();
        }


        /// <summary>
        /// The perform staging operation.
        /// </summary>
        /// <param name="o">The o.</param>
        /// <param name="args">The args.</param>
        public void PerformStagingOperation(object o, DoWorkEventArgs args)
        {
            Logger.Debug("Preparing to perform staging operation.");

            // No advanced options... Just stage the entire media
            this.ProgressViewModel.IsWorkInProgress = true;
            this.ProgressViewModel.Text = "Reading Studies...";

            this.NonDicomMediaViewModel.IsWorkInProgress = true;

            this.PerformActionCommand.RaiseCanExecuteChanged();
            this.CancelActionCommand.RaiseCanExecuteChanged();
            this.ToggleAdvancedOptions.RaiseCanExecuteChanged();
            this.NavigateBackCommand.RaiseCanExecuteChanged();

            if (!this.ShowAdvancedOptions && this.IsMixedorDicomMedia)
            {
                if (this.ReadDicomStudiesFromPath(this.DriveLetter, true, this.SelectedOriginIndex.Code))
                {
                    this.SetOriginIndexDataForStudies(this.StudiesOnMedia, this.SelectedOriginIndex.Code);

                    // Attach the the temporary study list to the workitem details
                    this.UIDispatcher.Invoke(
                        DispatcherPriority.Normal, 
                        (Action)delegate { this.WorkItemDetails.Studies = new ObservableCollection<Study>(this.StudiesOnMedia); });

                    // If there were no studies able to be resolved, tell the user and halt progress
                    if (this.WorkItemDetails.Studies == null || this.WorkItemDetails.Studies.Count == 0)
                    {
                        this.ProgressViewModel.Text = "NO DICOM media found...";
                        string message = "No DICOM media was found on the drive. There is nothing to import.";
                        string caption = "No DICOM media found";
                        this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Warning);
                        return;
                    }

                    // Strip any unsupported files, and if the user doesn't want to continue, halt processing
                    if (!this.StripUnsupportedSopInstances(this.DriveLetter, this.WorkItemDetails.Studies))
                    {
                        return;
                    }
                }
                else
                {
                    return;
                }
            }
            else if (this.IsMixedorDicomMedia)
            {
                // Copy the selected studies into a local list
                var studiesToStage = new ObservableCollection<Study>();
                foreach (Study study in this.SelectedStudies)
                {
                    studiesToStage.Add(study);
                }

                // Now that the selected studies have been copied to a temporary collection, strip any unsupported files, and 
                // if the user doesn't want to continue, halt processing
                if (!this.StripUnsupportedSopInstances(this.DriveLetter, studiesToStage))
                {
                    return;
                }

                // There are studies left after removing any unsupported instances, and the user wants to continue... 
                // Set the origin index
                this.SetOriginIndexDataForStudies(studiesToStage, this.SelectedOriginIndex.Code);

                // Advanced options were selected. Check to see that they haven't swapped the CD out from under us!
                // Get a "signature" for the media by hashing all the filenames
                var allFiles = new List<string>();
                PathUtilities.AddFiles(this.DriveLetter, "*", allFiles);
                string latestMediaSignature = StringUtilities.GetHashForStringArray(allFiles.ToArray());

                if (!this.WorkItemDetails.MediaBundleSignature.Equals(latestMediaSignature))
                {
                    string message = "Something is wrong with CD/DVD disk.  The disk does not appear to be the\n"
                                     + "same one that was used at the start of the Importer session.  Could the\n"
                                     + "original disk have been removed and another one inserted into the drive?";
                    string caption = "Media Has Changed";
                    this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);
                    this.StudyListBuiltSuccessfully = false;
                    return;
                }
                else
                {
                    // Only stage the selected studies
                    this.ProgressViewModel.IsWorkInProgress = true;
                    this.NonDicomMediaViewModel.IsWorkInProgress = true;

                    // Attach the selected studies list to the workitem details
                    this.UIDispatcher.Invoke(
                        DispatcherPriority.Normal,
                        (Action)(() => { this.WorkItemDetails.Studies = new ObservableCollection<Study>(studiesToStage); }));
                }
            }
            else
            {
                string notes = String.Empty;

                if (this.WorkItemDetails != null)
                {
                    notes = this.WorkItemDetails.ReconcilerNotes;
                }

                // Initialize the work item
                this.InitializeWorkItem("", true, notes);
            }

            // Attach the Non-DICOM files to the workitem details
            if (this.IsMixedorNonDicomMedia)
            { 
                this.UIDispatcher.Invoke(
                    DispatcherPriority.Normal,
                    (Action)(() => { this.WorkItemDetails.NonDicomFiles = this.NonDicomMediaViewModel.NonDicomFiles; }));
            }

            // Cancel if requested
            if (this.Worker.CancellationPending)
            {
                args.Cancel = true;
                return;
            }

            // Copy the files to the staging area
            this.ProgressViewModel.Text = "Copying files to staging area";

            Exception fileCopyingException = null;
            try
            {
                this.CopyFilesToServer();
            }
            catch (Exception e)
            {
                fileCopyingException = e;
            }

            this.FinalizeStaging(fileCopyingException);
        }

        /// <summary>
        /// Shows the hide advanced staging message.
        /// </summary>
        public void ShowHideAdvancedStagingMessage()
        {
            if (!this.ShowAdvancedOptions || (this.SelectedStudies != null && this.SelectedStudies.Count > 0))
            {
                this.RemoveMessage(AdvancedStagingMessage);
            }
            else if (this.ShowAdvancedOptions && (this.SelectedStudies == null || this.SelectedStudies.Count == 0))
            {
                this.AddMessage(MessageTypes.Info, AdvancedStagingMessage);
            }
        }
        

        /// <summary>
        /// Finalizes staging.
        /// </summary>
        /// <param name="fileCopyingException">The exception thrown during processing, if any.</param>
        private void FinalizeStaging(Exception fileCopyingException)
        {
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
                        this.NonDicomMediaViewModel.IsWorkInProgress = false;
                        this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);
                    }
                    else if (fileCopyingException is NetworkLocationConnectionException)
                    {
                        string caption = "Invalid Network Location Credentials";
                        string message = "The current write location has an invalid username/password configured.\n";
                        message += "Please contact an administrator.\n";

                        this.ProgressViewModel.IsWorkInProgress = false;
                        this.NonDicomMediaViewModel.IsWorkInProgress = false;
                        this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);
                    }
                    else
                    {
                        // Create the WorkItem in a failed status, for later cleanup
                        this.WorkItem.Status = ImporterWorkItemStatuses.FailedStaging;
                        ProgressViewModel.Text = "Updating work item...";
                        RetryUtility.RetryAction(this.CreateImporterWorkItem, 3);
                        this.ProgressViewModel.IsWorkInProgress = false;
                        this.NonDicomMediaViewModel.IsWorkInProgress = false;
                        this.DialogService.ShowExceptionWindow(UIDispatcher, fileCopyingException);
                    }
                }
                else if (this.Worker.CancellationPending)
                {
                    // Create the WorkItem in a cancelled status, for later cleanup
                    this.WorkItem.Status = ImporterWorkItemStatuses.CancelledStaging;
                    ProgressViewModel.Text = "Updating work item...";
                    RetryUtility.RetryAction(this.CreateImporterWorkItem, 3);

                    // Display the Success notification
                    this.ProgressViewModel.IsWorkInProgress = false;
                    this.NonDicomMediaViewModel.IsWorkInProgress = false;
                    this.DialogService.ShowAlertBox(
                        this.UIDispatcher,
                        "The staging operation was cancelled.",
                        "Staging Cancelled",
                        MessageTypes.Info);
                }
                else
                {
                    // Save the WorkItem to the database and display the alert if the media was staged successfully
                    this.WorkItem.WorkItemDetails.VaPatientFromStaging = Patient;
                    this.WorkItem.WorkItemDetails.IsMediaBundleStaged = true;
                    ProgressViewModel.Text = "Updating work item...";
                    RetryUtility.RetryAction(this.CreateImporterWorkItem, 3);

                    // Display the Success notification
                    this.ProgressViewModel.IsWorkInProgress = false;
                    this.NonDicomMediaViewModel.IsWorkInProgress = false;

                    if (this.IsMixedorDicomMedia)
                    {
                        this.DialogService.ShowAlertBox(
                            this.UIDispatcher,
                            "Staging completed successfully. Please remove the media from the drive",
                            "Staging Complete",
                             MessageTypes.Info);
                    }
                    else
                    {
                        this.DialogService.ShowAlertBox(
                            this.UIDispatcher,
                            "Staging completed successfully.", "Staging Complete",
                            MessageTypes.Info);
                    }

                }
            }
            catch (Exception e)
            {
                this.ProgressViewModel.IsWorkInProgress = false;
                this.NonDicomMediaViewModel.IsWorkInProgress = false;
                this.DialogService.ShowAlertBox(
                    this.UIDispatcher, "Error during Media Staging: " + e.Message, "Staging Error", MessageTypes.Error);

                Logger.Error("Error staging media: " + e.Message, e);
            }
        }

        /// <summary>
        /// The perform staging operation completed.
        /// </summary>
        /// <param name="o">
        /// The o.
        /// </param>
        /// <param name="args">
        /// The args.
        /// </param>
        private void PerformStagingOperationCompleted(object o, RunWorkerCompletedEventArgs args)
        {
            this.ProgressViewModel.IsWorkInProgress = false;
            this.NonDicomMediaViewModel.IsWorkInProgress = false;

            // Unsubscribes from the New User Login Event
            this.eventAggregator.GetEvent<NewUserLoginEvent>().Unsubscribe(this.SetNewUserLoginAlert);

            if (!this.isNewUserLogin)
            {
                // Renavigate to this select media category view to reset everything...
                this.NavigateMainRegionTo(ImporterViewNames.SelectMediaCategoryView + "?IsForMediaStaging=true");
            }
            else
            {
                this.isNewUserLogin = false;
            }
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
        /// The cancel advanced options action.
        /// </summary>
        protected void CancelAdvancedOptionsAction()
        {
            this.Worker.CancelAsync();
        }

        /// <summary>
        /// The build work item and copy media to share.
        /// </summary>
        private void BuildWorkItemAndCopyMediaToShare()
        {
            if (this.IsReadyToStage())
            {
                // Subscribes to the New User Login Event
                this.eventAggregator.GetEvent<NewUserLoginEvent>().Subscribe(this.SetNewUserLoginAlert);

                // Create and spawn a new backround worker to actually read the drive.
                // This lets us cancel if necessary, etc.
                this.Worker = new BackgroundWorker { WorkerSupportsCancellation = true };
                this.Worker.DoWork += this.PerformStagingOperation;
                this.Worker.RunWorkerCompleted += this.PerformStagingOperationCompleted;
                this.Worker.RunWorkerAsync();
            }
        }

        /// <summary>
        /// Determines whether the user can cancel the staging operation.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if the user can cancel the staging operation; otherwise, <c>false</c>.
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
        /// Determines whether this instance [can perform dicom media action].
        /// </summary>
        /// <returns>
        ///   <c>true</c> if this instance [can perform dicom media action]; otherwise, <c>false</c>.
        /// </returns>
        bool CanPerformDicomMediaAction()
        {
            // If it's a known patient, they have to provide a patient
            if (this.IsPatientKnown && this.Patient == null)
            {
                return false;
            }

            // If they haven't selected a drive or there's already work in progress, 
            // can't stage.
            if (string.IsNullOrEmpty(this.DriveLetter) || this.ProgressViewModel.IsWorkInProgress)
            {
                return false;
            }

            // If they've showed advanced options, but no studies are selected, can't stage
            if (this.ShowAdvancedOptions && (this.SelectedStudies == null || this.SelectedStudies.Count == 0))
            {
                return false;
            }

            // If we've gotten, here, we can stage
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
            bool nonDicomNoPatient = false;

            // handles the case where a patient is required for NonDICOM staging
            if (this.MediaCategory.Category == MediaCategories.NonDICOM && this.Patient == null)
            {
                nonDicomNoPatient = true;
            }

            // atleast one non dicom file needs to be added in order to continue
            if (this.NonDicomMediaViewModel == null ||
                this.NonDicomMediaViewModel.NonDicomFiles.Count == 0 ||
                nonDicomNoPatient)
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Determines whether the user can select advanced options. Used to enable and disable the
        /// button
        /// </summary>
        /// <returns>
        ///   <c>true</c> if the user can select advanced options; otherwise, <c>false</c>.
        /// </returns>
        private bool CanSelectAdvancedOptions()
        {
            bool hasRights = this.HasAdvancedStagingKey || this.HasContractedStudiesKey || this.HasAdministratorKey;
            bool driveSelected = !string.IsNullOrEmpty(this.DriveLetter);

            return hasRights && driveSelected && !this.ProgressViewModel.IsWorkInProgress;
        }

        /// <summary>
        /// Determines whether the user can stage. Used to enable or disable the button
        /// </summary>
        /// <returns>
        ///   <c>true</c> if the user can stage; otherwise, <c>false</c>.
        /// </returns>
        private bool CanStage()
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
        /// The create importer work item.
        /// </summary>
        private void CreateImporterWorkItem()
        {
            if (WorkItemDetails.Studies != null)
            {
                foreach(var study in WorkItemDetails.Studies)
                {
                    if (!String.IsNullOrEmpty(study.ModalityCodes))
                    {
                        this.WorkItem.Modality = study.ModalityCodes;
                    }
                    if (!String.IsNullOrEmpty(study.Procedure))
                    {
                        this.WorkItem.Procedure = study.Procedure;
                    }
                    if (!String.IsNullOrEmpty(this.WorkItem.Procedure) && !String.IsNullOrEmpty(this.WorkItem.Modality))
                    {
                        break;
                    }
                }
            }

            this.DicomImporterDataSource.CreateImporterWorkItem(this.WorkItem, false);
        }

        /// <summary>
        /// Generates the patient known message.
        /// </summary>
        private string GeneratePatientKnownMessage()
        {
            if (this.IsNonDicomMediaCategory())
            {
                return "Please select a patient.";
            }

            return "Patient is Known Selected: Please select a patient.";
        }

        /// <summary>
        /// The initialize and show advanced options.
        /// </summary>
        private void InitializeAndShowAdvancedOptions()
        {
            var driveInfo = new DriveInfo(this.DriveLetter);

            if (driveInfo.IsReady)
            {
                this.ProgressViewModel.IsWorkInProgress = true;
                this.NonDicomMediaViewModel.IsWorkInProgress = true;

                this.PerformActionCommand.RaiseCanExecuteChanged();
                this.CancelActionCommand.RaiseCanExecuteChanged();
                this.ToggleAdvancedOptions.RaiseCanExecuteChanged();
                this.NavigateBackCommand.RaiseCanExecuteChanged();

                // Create and spawn a new backround worker to actually read the drive.
                // This lets us cancel if necessary, etc.
                this.Worker = new BackgroundWorker { WorkerSupportsCancellation = true };
                this.Worker.DoWork += this.DoInitializeAdvancedOptions;
                this.Worker.RunWorkerCompleted += this.InitializeAdvancedOptionsCompleted;
                this.Worker.RunWorkerAsync();
            }
            else
            {
                this.ShowDriveNotReadyAlert();
            }
        }

        /// <summary>
        /// Determines whether [is ready to stage].
        /// </summary>
        /// <returns>
        ///   <c>true</c> if [is ready to stage]; otherwise, <c>false</c>.
        /// </returns>
        private bool IsReadyToStage()
        {
            if (this.IsNonDicomMediaCategory() && this.NonDicomMediaViewModel.NonDicomFiles.Count > 0)
            {
                return true;
            }

            var driveInfo = new DriveInfo(this.DriveLetter);
            if (driveInfo != null && driveInfo.IsReady)
            {
                return true;
            }
            else
            {
                this.ShowDriveNotReadyAlert();
            }

            return false;
        }

        /// <summary>
        /// The on toggle advanced options.
        /// </summary>
        private void OnToggleAdvancedOptions()
        {
            if (this.ShowAdvancedOptions)
            {
                this.ShowAdvancedOptions = false;
                this.StudyListBuiltSuccessfully = false;
                this.ShowAdvancedOptionsControls = false;
                this.AdvancedOptionsText = ShowAdvancedOptionsText;
                this.PerformActionCommand.RaiseCanExecuteChanged();
                this.ToggleAdvancedOptions.RaiseCanExecuteChanged();
                this.NavigateBackCommand.RaiseCanExecuteChanged();

                this.ShowOnlyOneMessage = false;
                this.ShowHideAdvancedStagingMessage();
            }
            else
            {         
                this.PreppingAdvancedOptions = true;
                this.ShowAdvancedOptionsControls = true;
                this.InitializeAndShowAdvancedOptions();
            }

            this.RaisePropertyChanged("ShowAdvancedOptionsControls");
            this.RaisePropertyChanged("AdvancedOptionsText");
            this.RaisePropertyChanged("StudiesOnMedia");
        }

        /// <summary>
        /// The show drive not ready alert.
        /// </summary>
        private void ShowDriveNotReadyAlert()
        {
            this.DialogService.ShowAlertBox(
                this.UIDispatcher, 
                "Drive " + this.DriveLetter + " cannot be read from at this time. Staging cannot continue.", 
                "Drive not Ready", 
                MessageTypes.Error);
        }

        /// <summary>
        /// Shows the messages.
        /// </summary>
        private void ShowMessages()
        {
            this.ShowNonDicomFileMessage();

            this.ShowHideAdvancedStagingMessage();

            if (String.IsNullOrEmpty(this.DriveLetter) && !this.IsNonDicomMediaCategory())
            {
                this.AddMessage(MessageTypes.Info, DriveMessage);
            }
        }

        /// <summary>
        /// Shows the non dicom file message.
        /// </summary>
        private void ShowNonDicomFileMessage()
        {
            if (this.IsMixedorNonDicomMedia && this.NonDicomMediaViewModel.NonDicomFiles.Count == 0)
            {
                this.AddMessage(MessageTypes.Info, NonDicomFileMessage);
            }
        }

        /// <summary>
        /// Shows the patient known message.
        /// </summary>
        private void ShowPatientKnownMessage()
        {
           
            if (this.IsPatientKnown && this.Patient == null)
            {
                this.AddMessage(MessageTypes.Info, this.GeneratePatientKnownMessage());
            }
        }

        #endregion
    }
}