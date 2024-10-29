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
    using System.ComponentModel;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.Views;

    using ImagingClient.Infrastructure.ViewModels;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Exceptions;
    using ImagingClient.Infrastructure.Utilities;

    using log4net;

    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;
    using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.ViewModels;
    using ImagingClient.Infrastructure.PatientDataSource;
    using System.Collections.Generic;

    /// <summary>
    /// The study list view model.
    /// </summary>
    public class StudyListViewModel : ImporterReconciliationViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(StudyListViewModel));

        /// <summary>
        /// The progress view model.
        /// </summary>
        private ProgressViewModel progressViewModel = new ProgressViewModel();

        #endregion

        #region Constructors and Destructors

        public IDialogServiceImporter m_dlgServiceImporter;

        /// <summary>
        /// Initializes a new instance of the <see cref="StudyListViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public StudyListViewModel(
            IDialogService dialogService, 
            IDicomImporterDataSource dicomImporterDataSource,
            IDialogServiceImporter dialogServiceImporter,
            IPatientDataSource patientDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;
            this.PatientDataSource = patientDataSource;
            this.m_dlgServiceImporter = dialogServiceImporter;

            // Navigate to the Study List view, passing in the workitem key
            this.NavigateToPatientSelectionView =
                new DelegateCommand<object>(
                    o => this.CreateReconciliationAndNavigate(),
                    o => this.CanReconcile());
                         //&& !this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.CommunityCare.Code));

            this.NavigateToConfirmationView =
                new DelegateCommand<object>(
                    o => SubmitImportRequest(), o => this.CanSubmitImportRequest());

            this.ShowStudyDetailsWindow = new DelegateCommand<object>(
                o => this.ShowStudyDetails(this, null), 
                o => (this.WorkItemDetails.CurrentStudy != null && !this.ProgressViewModel.IsWorkInProgress));

            this.CancelReconciliationCommand = new DelegateCommand<object>(
                o => this.CancelWorkItemReconciliation(this.WorkItem), o => !this.ProgressViewModel.IsWorkInProgress);

            this.ClearReconciliation = new DelegateCommand<object>(
                o => this.CancelReconciliation(), 
                o => this.CanClearReconciliation() && !this.ProgressViewModel.IsWorkInProgress);

            this.ToggleDeletionStatusCommand = new DelegateCommand<object>(
                o => this.ToggleDeletionStatus(),
                o =>
                this.SelectedStudy != null && !this.ProgressViewModel.IsWorkInProgress
                && !this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.DirectImport.Code));
                //&& !this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.CommunityCare.Code));
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

        /// <summary>
        /// Gets or sets ClearReconciliation.
        /// </summary>
        public DelegateCommand<object> ClearReconciliation { get; set; }

        /// <summary>
        /// Gets DeletionStatusText.
        /// </summary>
        public string DeletionStatusText
        {
            get
            {
                if (this.SelectedStudy == null || !this.SelectedStudy.ToBeDeletedOnly)
                {
                    return "Delete";
                }
                else
                {
                    return "Don't Delete";
                }
            }
        }

        /// <summary>
        /// Gets the reconcile study text.
        /// </summary>
        public string ReconcileStudyText
        {
            get
            {
                if (this.IsDicomCorrect)
                {
                    return "Correct Study";
                }
                else
                {
                    return "Reconcile Study";
                }
            }
        }

        /// <summary>
        /// Gets a value indicating whether IsStudySelected.
        /// </summary>
        public bool IsStudySelected
        {
            get
            {
                return this.SelectedStudy != null;
            }
        }

        /// <summary>
        /// Gets or sets NavigateToConfirmationView.
        /// </summary>
        public DelegateCommand<object> NavigateToConfirmationView { get; set; }

        /// <summary>
        /// Gets or sets NavigateToPatientSelectionView.
        /// </summary>
        public DelegateCommand<object> NavigateToPatientSelectionView { get; set; }

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
            }
        }

        /// <summary>
        /// Gets or sets ReconciliationDetailsViewModel.
        /// </summary>
        public ReconciliationDetailsViewModel ReconciliationDetailsViewModel { get; set; }

        /// <summary>
        /// Gets or sets SelectedStudy.
        /// </summary>
        public Study SelectedStudy
        {
            get
            {
                if (this.WorkItemDetails == null)
                {
                    return null;
                }
                else
                {
                    return this.WorkItemDetails.CurrentStudy;
                }
            }

            set
            {
                // Set the value
                this.WorkItemDetails.CurrentStudy = value;

                // Tell the buttons to refresh their execution status
                this.NavigateToPatientSelectionView.RaiseCanExecuteChanged();
                this.ShowStudyDetailsWindow.RaiseCanExecuteChanged();
                this.ToggleDeletionStatusCommand.RaiseCanExecuteChanged();
                this.ClearReconciliation.RaiseCanExecuteChanged();
                this.NavigateToConfirmationView.RaiseCanExecuteChanged();

                this.ShowOrHideStudyMessage();

                if (value != null)
                {
                    // Create a reconciliation details view model
                    this.ReconciliationDetailsViewModel = new ReconciliationDetailsViewModel(value, this.WorkItem);
                    this.RaisePropertyChanged("ReconciliationDetailsViewModel");
                }

                // Raise the property change notification for the delete button text
                this.RaisePropertyChanged("DeletionStatusText");
                this.RaisePropertyChanged("IsStudySelected");
            }
        }

        /// <summary>
        /// Gets or sets ShowStudyDetailsWindow.
        /// </summary>
        public DelegateCommand<object> ShowStudyDetailsWindow { get; set; }

        /// <summary>
        /// Gets StudyHeaderText.
        /// </summary>
        public string StudyHeaderText
        {
            get
            {
                // Check for no study selected
                if (this.SelectedStudy == null)
                {
                    string studyType = "reconcile";

                    if (this.IsDicomCorrect)
                    {
                        studyType = "correct";
                    }

                    return "Please " + studyType + " at least one study in order to submit for importing.";
                }

                // Check for completely imported study
                if (this.SelectedStudy.ImportStatus.Equals(ImportStatuses.Complete))
                {
                    if (this.SelectedStudy.ToBeDeletedOnly)
                    {
                        return
                            "This study has been completely imported, and was reconciled as shown below. The study has been marked for deletion from this work item.";
                    }
                    else
                    {
                        return "This study has been completely imported, and was reconciled as shown below.";
                    }
                }

                // Check for partially imported study
                if (this.SelectedStudy.ImportStatus.Equals(ImportStatuses.Partial))
                {
                    // Check to see whether it has been marked for deletion. 
                    if (this.SelectedStudy.ToBeDeletedOnly)
                    {
                        string message = this.SelectedStudy.NumberOfImagesAlreadyImported + " of the "
                                         + this.SelectedStudy.TotalNumberOfImagesInStudy;
                        message +=
                            " images in this study are already present on VistA, and were originally reconciled as shown below. The study has been marked for deletion from this work item.";
                        return message;
                    }

                    // It's not going to be deleted. Check to see whether it's reconciled or not...
                    if (this.SelectedStudy.Reconciliation == null)
                    {
                        string message = this.SelectedStudy.NumberOfImagesAlreadyImported + " of the "
                                         + this.SelectedStudy.TotalNumberOfImagesInStudy;
                        message +=
                            " images in this study are already present on VistA, and were originally reconciled as shown below.";
                        return message;
                    }
                    else
                    {
                        // It's partially imported, but we have a new reconciliation for the remaining images
                        string message = this.SelectedStudy.NumberOfImagesAlreadyImported + " of the "
                                         + this.SelectedStudy.TotalNumberOfImagesInStudy;
                        message +=
                            " images in this study are already present on VistA, and the remaining images have been reconciled for import as shown below.";
                        return message;
                    }
                }

                // Check to see whether it has been marked for deletion. 
                if (this.SelectedStudy.ToBeDeletedOnly)
                {
                    return "This study has been marked for deletion from this work item.";
                }

                // Check for newly reconciled study
                if (this.SelectedStudy.Reconciliation != null)
                {
                    return "This study has been selected for import and reconciled as shown below.";
                }

                // If we got here, this is a new study that has not yet been reconciled and is not marked for deletion
                return "This study has not yet been reconciled for import.";
            }
        }

        /// <summary>
        /// Gets or sets ToggleDeletionStatusCommand.
        /// </summary>
        public DelegateCommand<object> ToggleDeletionStatusCommand { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// The initialization complete.
        /// </summary>
        /// <param name="o">
        /// The o.
        /// </param>
        /// <param name="args">
        /// The args.
        /// </param>
        public void InitializationComplete(object o, RunWorkerCompletedEventArgs args)
        {
            this.ProgressViewModel.IsWorkInProgress = false;

            this.NavigateToPatientSelectionView.RaiseCanExecuteChanged();
            this.NavigateToConfirmationView.RaiseCanExecuteChanged();
            this.ShowStudyDetailsWindow.RaiseCanExecuteChanged();
            this.CancelReconciliationCommand.RaiseCanExecuteChanged();
            this.ClearReconciliation.RaiseCanExecuteChanged();

            if (args.Error == null)
            {
                this.WorkItemDetails.ImportStatusChecked = true;
            }
            else
            {
                // Create the WorkItem in a failed status, for later cleanup
                this.WorkItemDetails.ImportStatusChecked = false;
                this.DialogService.ShowExceptionWindow(UIDispatcher, args.Error);
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

            this.NavigateToConfirmationView.RaiseCanExecuteChanged();

            this.RaisePropertyChanged("ReconcileStudyText");

            if (this.SelectedStudy != null)
            {
                this.ReconciliationDetailsViewModel = new ReconciliationDetailsViewModel(this.SelectedStudy, this.WorkItem);
            }

            if (!this.WorkItemDetails.ImportStatusChecked)
            {
                // Check Import Statuses
                this.CheckImportStatuses();
            }

            // If contracted studies user but not Admin, set origin index to Fee Basis
            if (this.HasContractedStudiesKey && !this.HasAdministratorKey)
            {
                this.WorkItem.OriginIndex = "F";
                foreach (Study study in this.WorkItemDetails.Studies)
                {
                    study.OriginIndex = "F";
                }
            }

            this.ShowOrHideStudyMessage();
        }

        /// <summary>
        /// The perform import status checks.
        /// </summary>
        /// <param name="o">
        /// The o.
        /// </param>
        /// <param name="args">
        /// The args.
        /// </param>
        public void PerformImportStatusChecks(object o, DoWorkEventArgs args)
        {
            this.ProgressViewModel.Maximum = this.WorkItemDetails.Studies.Count;
            this.ProgressViewModel.Value = 1;
            foreach (Study study in this.WorkItemDetails.Studies)
            {
                this.ProgressViewModel.Text = "Checking import status for Study " + study.IdInMediaBundle + " ...";
                Study checkedStudy = this.DicomImporterDataSource.GetStudyImportStatus(study);

                // Replace the series and instance information with the checked data from the server
                study.Series.Clear();
                foreach (Series series in checkedStudy.Series)
                {
                    study.Series.Add(series);
                }

                // Copy in previous reconciliation information
                study.PreviouslyReconciledPatient = checkedStudy.PreviouslyReconciledPatient;
                study.PreviouslyReconciledOrder = checkedStudy.PreviouslyReconciledOrder;

                study.RefreshImportStatus();

                // Renumber the series and instances in each of the studies for display
                study.RenumberSeriesAndInstances();

                this.ProgressViewModel.Value++;
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Determines whether the user can clear reconciliation.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if the user can clear reconciliation; otherwise, <c>false</c>.
        /// </returns>
        private bool CanClearReconciliation()
        {
            if (this.CurrentStudy == null)
            {
                return false;
            }

            if (this.CurrentStudy.ToBeDeletedOnly)
            {
                return false;
            }

            if (this.CurrentReconciliation == null)
            {
                return false;
            }

            if (!this.CurrentReconciliation.IsReconciliationComplete)
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Determines whether the user can submit import request
        /// </summary>
        /// <returns>
        ///   <c>true</c> if the user can submit import request; otherwise, <c>false</c>.
        /// </returns>
        private bool CanSubmitImportRequest()
        {
            bool anyReconciliations = this.WorkItemDetails.Reconciliations.Count > 0;
            bool anyStudiesToDelete = this.WorkItemDetails.AnyStudiesToDelete;

            bool isCommunityCare = this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.CommunityCare.Code);
            bool isCommunityCareValidated = this.WorkItemDetails.DicomCorrectReason.StartsWith("Community Care");

            bool canImport = false;
            if (isCommunityCare && isCommunityCareValidated && (this.WorkItemDetails.CurrentStudy != null)
                && !this.ProgressViewModel.IsWorkInProgress)
            {
                canImport = true;
            }
            else if ((anyReconciliations || anyStudiesToDelete) && !this.ProgressViewModel.IsWorkInProgress)
            {
                canImport = true;
            }

            return canImport;

            //return (anyReconciliations || anyStudiesToDelete) && !this.ProgressViewModel.IsWorkInProgress;
        }

        /// <summary>
        /// Determines whether the user can reconcile the current study.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if the user can reconcile the current study; otherwise, <c>false</c>.
        /// </returns>
        private bool CanReconcile()
        {
            // Assume we can reconcile
            bool canReconcile = true;

            if (this.SelectedStudy == null)
            {
                // No study selected, so can't reconcile
                canReconcile = false;
            }
            else
            {
                if (this.SelectedStudy.ImportStatus == ImportStatuses.Complete)
                {
                    // Study is selected, but it is already completely imported
                    // Can't reconcile
                    canReconcile = false;
                }

                if (this.SelectedStudy.ToBeDeletedOnly)
                {
                    // Study is selected, but it is marked for deletion. Can't reconcile
                    canReconcile = false;
                }
            }

            // Already have work in progress. Have to wait to reconcile.
            if (this.ProgressViewModel.IsWorkInProgress)
            {
                canReconcile = false;
            }

            return canReconcile;
        }

        public void SubmitImportRequest()
        {
            bool isCommunityCare = this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.CommunityCare.Code);
            bool isCommunityCareValidated = this.WorkItemDetails.DicomCorrectReason.StartsWith("Community Care");
            if (isCommunityCare && isCommunityCareValidated)
            {
                this.ImportWorkItem();
            }
            else
            {
                this.NavigateWorkItem(ImporterViewNames.ConfirmationView);
            }
        }
        private void CancelWorkItemReconciliation(ImporterWorkItem workItem)
        {
            CancelWorkItem(this.m_dlgServiceImporter, workItem);
        }

        private void ImportWorkItem()
        {
            List<object> listParameter = new List<object> {
                this,
                SelectedStudy,
                PatientDataSource,
                m_dlgServiceImporter,
                CurrentStudy,
                WorkItemDetails,
                DicomImporterDataSource,
                WorkItem,
                null};

            BackgroundWorker threadUpdateStatus = new BackgroundWorker();
            threadUpdateStatus.DoWork += new DoWorkEventHandler(UpdateStagedWorkItemStatusThread);
            threadUpdateStatus.RunWorkerCompleted += new RunWorkerCompletedEventHandler(UpdateStagedWorkItemStatusThreadCompleted);
            threadUpdateStatus.RunWorkerAsync(listParameter);
            m_dlgServiceImporter.ShowDialog();
        }

        private void UpdateStagedWorkItemStatusThread(object sender, DoWorkEventArgs e)
        {
            // Transition the work item to ReadyForImport
            try
            {
                var viewModel = (StudyListViewModel)((List<object>)e.Argument)[0];
                var selectedStudy = (Study)((List<object>)e.Argument)[1];
                var patientDataSource = (IPatientDataSource)((List<object>)e.Argument)[2];
                var m_dlgServiceImporter = (IDialogServiceImporter)((List<object>)e.Argument)[3];
                var currentStudy = (Study)((List<object>)e.Argument)[4];
                var workItemDetails = (ImporterWorkItemDetails)((List<object>)e.Argument)[5];
                var dicomImporterDataSource = (IDicomImporterDataSource)((List<object>)e.Argument)[6];
                var workItem = (ImporterWorkItem)((List<object>)e.Argument)[7];

                //Create Reconcilation info programmatically
                var reconciliation = new Reconciliation(selectedStudy);
                //this.SelectedStudy.Reconciliation = reconciliation;

                var patients = patientDataSource.GetPatientList(currentStudy.Patient.Ssn.Replace("-", ""));
                if (patients.Count == 0)
                {
                    var noPatientMessage = currentStudy.Patient.PatientName +
                                           " not found.";
                    ((List<object>)e.Argument)[8] = noPatientMessage;
                }

                var patient = patients[0];

                reconciliation.Patient = patient;

                workItemDetails.VaPatientFromStaging = patient;
                workItemDetails.CurrentStudy.Reconciliation = reconciliation;
                
                reconciliation.CreateRadiologyOrder = false;
                reconciliation.IsPatientFromStaging = true;
                reconciliation.IsPatientPreviouslyResolved = true;
                reconciliation.IsStudyToBeReadByVaRadiologist = true;
                reconciliation.IsReconciliationComplete = true;
                reconciliation.UseExistingOrder = true;

                workItemDetails.Reconciliations.Clear();
                workItemDetails.Reconciliations.Add(reconciliation);

                // Handle the order: First get all orders for the selected patient
                var orders =
                    dicomImporterDataSource.GetOrdersForPatient(patient.Dfn);

                Order matchingOrder = null;
                foreach (Order ord in orders)
                {
                    if (ord.AccessionNumber.Equals(selectedStudy.AccessionNumber))
                    {
                        matchingOrder = ord;
                        break;
                    }
                }

                if (matchingOrder == null)
                {
                    var noOrdersMessage = "No orders were found for " + patient.PatientName +
                                           " in a status that allows for image attachment.";
                    ((List<object>)e.Argument)[8] = noOrdersMessage;
                }
                else
                {
                    //reconciliation.Orders.Add(matchingOrder);
                    reconciliation.Order = matchingOrder;
                    reconciliation.Order.IsToBeCreated = false;

                    dicomImporterDataSource.UpdateWorkItem(
                        workItem, ImporterWorkItemStatuses.InReconciliation, ImporterWorkItemStatuses.ReadyForImport);
                    ((List<object>)e.Argument)[8] = string.Empty;
                }
            }
            //catch (ServerException se)
            //{
            //    // Check for "expected" exceptions and handle them. Rethrow on unexpected ones...
            //    if (se.ErrorCode == ImporterErrorCodes.WorkItemNotFoundErrorCode)
            //    {
            //        string message = "The selected work item was not found on the server. It may have been deleted.";
            //        ((List<object>)e.Argument)[8] = message;

            //    }
            //    else if (se.ErrorCode == ImporterErrorCodes.InvalidWorkItemStatusErrorCode)
            //    {
            //        string message = se.Message + "\n";
            //        message += "Importing request failed!.";
            //        ((List<object>)e.Argument)[8] = message;
            //    }
            //    else
            //    {
            //        string message = se.Message + "\n";
            //        message += "Importing request failed!.";
            //        ((List<object>)e.Argument)[8] = message;
            //    }
            //}
            catch (Exception ex)
            {
                string message = ex.Message + "\n";
                message += "Importing request failed!.";
                ((List<object>)e.Argument)[8] = message;
            }

            e.Result = e.Argument;
        }

        //private void UpdateStagedWorkItemStatus()
        //{ 
        //    try
        //    {
        //        //Create Reconcilation info programmatically
        //        // Create the simple base reconciliation creation
        //        var reconciliation = new Reconciliation(this.SelectedStudy);
        //        //this.SelectedStudy.Reconciliation = reconciliation;

        //        var patients = this.PatientDataSource.GetPatientList(this.CurrentStudy.Patient.Ssn.Replace("-", ""));
        //        if (patients.Count == 0)
        //        {
        //            var noPatientMessage = this.CurrentStudy.Patient.PatientName +
        //                                   " not found.";
        //            throw new Exception(noPatientMessage);
        //        }

        //        var patient = patients[0];

        //        reconciliation.Patient = patient;

        //        this.WorkItemDetails.VaPatientFromStaging = patient;
        //        this.WorkItemDetails.CurrentStudy.Reconciliation = reconciliation; //.Patient = this.WorkItemDetails.VaPatientFromStaging;

        //        reconciliation.CreateRadiologyOrder = false;
        //        reconciliation.IsPatientFromStaging = true;
        //        reconciliation.IsPatientPreviouslyResolved = true;
        //        reconciliation.IsStudyToBeReadByVaRadiologist = true;
        //        reconciliation.IsReconciliationComplete = true;
        //        reconciliation.UseExistingOrder = true;

        //        this.WorkItemDetails.Reconciliations.Clear();
        //        this.WorkItemDetails.Reconciliations.Add(reconciliation);

        //        // Handle the order: First get all orders for the selected patient
        //        var orders =
        //            this.DicomImporterDataSource.GetOrdersForPatient(patient.Dfn);

        //        Order matchingOrder = null;
        //        foreach (Order ord in orders)
        //        {
        //            if (ord.AccessionNumber.Equals(this.SelectedStudy.AccessionNumber))
        //            {
        //                matchingOrder = ord;
        //                break;
        //            }
        //        }

        //        if (matchingOrder == null)
        //        {
        //            var noOrdersMessage = "No orders were found for " + patient.PatientName +
        //                                   " in a status that allows for image attachment.";
        //            throw new Exception(noOrdersMessage);
        //        }
        //        else
        //        {
        //            //reconciliation.Orders.Add(matchingOrder);
        //            reconciliation.Order = matchingOrder;
        //            reconciliation.Order.IsToBeCreated = false;

        //            this.DicomImporterDataSource.UpdateWorkItem(
        //                this.WorkItem, ImporterWorkItemStatuses.InReconciliation, ImporterWorkItemStatuses.ReadyForImport);
        //        }

        //    }
        //    catch (Exception e)
        //    {
        //        throw new Exception(e.Message);
        //    }
        //}

        private void UpdateStagedWorkItemStatusThreadCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            ((IDialogServiceImporter)((List<object>)e.Result)[3]).CloseDialog();

            var msg = (string)((List<object>)e.Result)[8];

            // Regardless of success or failure in submitting import, remove item from the cache, and 
            // Navigate back to the worklist...
            ImporterWorkItemCache.Remove(this.WorkItem);

            // Set the workitem to null so we aren't prompted for confirmation on returning to the 
            // import list
            this.WorkItem = null;

            // If we made it here with no server exception, let the user know import was successful.
            if (msg.Equals(string.Empty))
            {
                // Show information message
                this.DialogService.ShowAlertBox(
                    this.UIDispatcher,
                    "The current work item has been queued for import processing.",
                    "Queued for Import",
                    MessageTypes.Info);
            }
            else
            {
                // Show information message
                this.DialogService.ShowAlertBox(
                    this.UIDispatcher,
                    msg,
                    "Importing Work Item",
                    MessageTypes.Error);
            }

            if (!this.isNewUserLogin)
            {
                this.NavigateMainRegionTo(ImporterViewNames.WorkListView + "?IsFirstWorkListLoading=false");
            }
            else
            {
                this.isNewUserLogin = false;
            }
            this.eventAggregator.GetEvent<NewUserLoginEvent>().Unsubscribe(this.SetNewUserLoginAlert);
        }


        /// <summary>
        /// The check import statuses.
        /// </summary>
        private void CheckImportStatuses()
        {
            this.ProgressViewModel.IsWorkInProgress = true;

            this.NavigateToPatientSelectionView.RaiseCanExecuteChanged();
            this.NavigateToConfirmationView.RaiseCanExecuteChanged();
            this.ShowStudyDetailsWindow.RaiseCanExecuteChanged();
            this.CancelReconciliationCommand.RaiseCanExecuteChanged();
            this.ClearReconciliation.RaiseCanExecuteChanged();

            // Create and spawn a new backround worker to actually read the drive.
            // This lets us cancel if necessary, etc.
            this.Worker = new BackgroundWorker();
            this.Worker.DoWork += this.PerformImportStatusChecks;
            this.Worker.RunWorkerCompleted += this.InitializationComplete;
            this.Worker.RunWorkerAsync();
        }

        /// <summary>
        /// The create reconciliation and navigate.
        /// </summary>
        private void CreateReconciliationAndNavigate()
        {
            if (this.SelectedStudy.ImportStatus == ImportStatuses.Complete)
            {
                string message = "This study is already completely imported. It cannot be imported again.";
                string caption = "Study already imported";
                this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Info);
            }
            else
            {
                bool performQuickPartialImport = false;
                if (this.SelectedStudy.Reconciliation == null)
                {
                    // If this is a partial import, go ahead and add the previously reconciled information
                    // as a starting point if possible
                    if (this.SelectedStudy.ImportStatus == ImportStatuses.Partial)
                    {
                        if (this.SelectedStudy.PreviouslyReconciledOrder != null
                            && this.SelectedStudy.PreviouslyReconciledPatient != null)
                        {
                            performQuickPartialImport = this.InitializePartialStudy();
                        }
                        else
                        {
                            // Previous data was unavialable. Warn that the full reconciliation must be performed
                            string message =
                                "This study is partially imported, but the previously reconciled patient and/or \n"
                                + "order information was unavailable. A full reconciliation is required.\n";
                            string caption = "Partially Imported Study";

                            this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Warning);

                            // Create the simple base reconciliation creation
                            var reconciliation = new Reconciliation(this.SelectedStudy);
                            this.SelectedStudy.Reconciliation = reconciliation;

                            // Default the reconciliation to being read by a VA Radiologist, i.e. only attempt 
                            // to set the status to EXAMINED
                            reconciliation.IsStudyToBeReadByVaRadiologist = true;

                            this.WorkItemDetails.Reconciliations.Add(reconciliation);
                        }
                    }
                    else
                    {
                        // No partially imported. Just do the simple base reconciliation creation
                        var reconciliation = new Reconciliation(this.SelectedStudy);

                        // Default the reconciliation to being read by a VA Radiologist, i.e. only attempt 
                        // to set the status to EXAMINED
                        reconciliation.IsStudyToBeReadByVaRadiologist = true;

                        // Attach the reconciliation to the study and workitemdetails
                        this.SelectedStudy.Reconciliation = reconciliation;
                        this.WorkItemDetails.Reconciliations.Add(reconciliation);
                    }
                }

                // If the elected to do a "quick" partial import reconciliation, we're almost done.
                // Just mark the reconciliation as complete and refresh the buttons.
                // Otherwise, navigate on to the reconciliation workflow...
                if (performQuickPartialImport)
                {
                    this.CurrentReconciliation.IsReconciliationComplete = true;
                    this.ClearReconciliation.RaiseCanExecuteChanged();
                    this.NavigateToConfirmationView.RaiseCanExecuteChanged();
                    this.ShowOrHideStudyMessage();
                }
                else
                {
                    this.NavigateWorkItem(ImporterViewNames.PatientSelectionView);
                }
            }
        }

        /// <summary>
        /// Initializes the partial study.
        /// </summary>
        /// <returns><c>true</c> if the user wants to perform a quick partial import; otherwise <c>false</c></returns>
        private bool InitializePartialStudy()
        {
            bool performQuickPartialImport = false;
            try
            {
                string message =
                    "This study is partially imported. Would you like to import the remaining instances to the same patient and order?\n"
                    + " * Choose 'Yes' to import the remaining instances to the same patient and order.\n"
                    + " * Choose 'No' to reconcile the remaining instances to a different patient and/or order.\n";
                string caption = "Partially Imported Study";

                performQuickPartialImport = this.DialogService.ShowYesNoBox(
                    this.UIDispatcher, message, caption, MessageTypes.Question);

                // Create the base reconciliation
                var reconciliation = new Reconciliation(this.SelectedStudy);
                this.SelectedStudy.Reconciliation = reconciliation;
                this.WorkItemDetails.Reconciliations.Add(reconciliation);

                // Set the patient
                this.SelectedStudy.Reconciliation.Patient = this.SelectedStudy.PreviouslyReconciledPatient;

                // Handle the order: First get all orders for the selected patient
                this.SelectedStudy.Reconciliation.Orders =
                    this.DicomImporterDataSource.GetOrdersForPatient(this.CurrentReconciliation.Patient.Dfn);
                Order matchingOrder = this.GetMatchingOrder(
                    this.SelectedStudy.PreviouslyReconciledOrder, this.SelectedStudy.Reconciliation.Orders);

                if (matchingOrder != null)
                {
                    // We found the order in the list that came back for the patient (i.e. it was not filtered out
                    // due to status, etc. All we have to do is set the selected order to the one we matched
                    this.SelectedStudy.Reconciliation.Order = matchingOrder;
                }
                else
                {
                    // The order the other images was imported into is not in the current list. Possibly it was filtered out
                    // due to status, etc. Add the partially imported order to the list of orders, and select it
                    this.SelectedStudy.Reconciliation.Orders.Add(this.SelectedStudy.PreviouslyReconciledOrder);
                    this.SelectedStudy.Reconciliation.Order = this.SelectedStudy.PreviouslyReconciledOrder;
                }

                // Set the other Reconciliation and Order attributes
                this.SelectedStudy.Reconciliation.Order.IsToBeCreated = false;
                this.SelectedStudy.Reconciliation.UseExistingOrder = true;
                this.SelectedStudy.Reconciliation.CreateRadiologyOrder = false;
                this.SelectedStudy.Reconciliation.IsStudyToBeReadByVaRadiologist = true;

                Order order = this.SelectedStudy.Reconciliation.Order;
                if (order.Specialty.Equals("RAD", StringComparison.CurrentCultureIgnoreCase))
                {
                    Procedure procedure = this.DicomImporterDataSource.GetProcedureById(order.ProcedureId);

                    if (procedure != null)
                    {
                        order.Procedure = procedure;
                    }
                }
            }
            catch (Exception e)
            {
                Logger.Error("Unable to initialize partial study data.", e);
            }

            return performQuickPartialImport;
        }

        /// <summary>
        /// Shows study message.
        /// </summary>
        private void ShowOrHideStudyMessage()
        {
            this.ClearMessages();
            this.AddMessage(MessageTypes.Info, this.StudyHeaderText);
        }

        /// <summary>
        /// The toggle deletion status.
        /// </summary>
        private void ToggleDeletionStatus()
        {
            // Toggle the status
            this.SelectedStudy.ToBeDeletedOnly = !this.SelectedStudy.ToBeDeletedOnly;

            // Raise the property change notification for the button text and description
            this.RaisePropertyChanged("DeletionStatusText");

            // Show the appropriate study message.
            this.ShowOrHideStudyMessage();

            // Tell the other buttons to reevaluate their execution status
            this.NavigateToPatientSelectionView.RaiseCanExecuteChanged();
            this.NavigateToConfirmationView.RaiseCanExecuteChanged();
            this.ShowStudyDetailsWindow.RaiseCanExecuteChanged();
            this.ClearReconciliation.RaiseCanExecuteChanged();
        }

        #endregion
    }
}