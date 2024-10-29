/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 05/29/2013
 * Site Name:  Washington OI Field Office, Columbia, MD
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

using System.ComponentModel;
using DicomImporter.Common.Interfaces.DataSources;
using DicomImporter.Common.Model;
using DicomImporter.Common.Services;
using DicomImporter.Common.ViewModels;
using DicomImporter.Common.Views;
using ImagingClient.Infrastructure.Model;
using ImagingClient.Infrastructure.StorageDataSource;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Regions;

namespace DicomImporter.ViewModels
{
    using ImagingClient.Infrastructure.DialogService;

    using log4net;

    /// <summary>
    /// The Non-DICOM files list view model
    /// </summary>
    public class NonDicomListViewModel : ImporterReconciliationViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(AdminFailedImportViewModel));

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="NonDicomListViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">The dialog service.</param>
        /// <param name="importerDialogService">The importer dialog service.</param>
        /// <param name="dicomImporterDataSource">The dicom importer data source.</param>
        /// <param name="storageDataSource">The storage data source.</param>
        public NonDicomListViewModel(
            IDialogService dialogService,
            IImporterDialogService importerDialogService,
            IDicomImporterDataSource dicomImporterDataSource,
            IStorageDataSource storageDataSource)
        {
            this.DialogService = dialogService;
            this.ImporterDialogService = importerDialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;
            this.StorageDataSource = storageDataSource;

            this.NavigateForward = new DelegateCommand<object>(
                o =>
                {
                    CurrentReconciliation.NonDicomFiles = NonDicomMediaViewModel.NonDicomFiles;

                    if (this.HasAdministratorKey)
                    {
                        this.NavigateWorkItem(ImporterViewNames.SelectOrderTypeView);
                    }
                    else
                    {
                        this.CurrentReconciliation.UseExistingOrder = true;
                        this.NavigateWorkItem(ImporterViewNames.ChooseExistingOrderView);
                    }
                },
                o => CanNavigateForward());


            this.CancelReconciliationCommand = new DelegateCommand<object>(
                o => this.CancelWorkItem(this.WorkItem));

        }

        /// <summary>
        /// Determines whether this instance [can navigate forward].
        /// </summary>
        /// <returns>
        ///   <c>true</c> if this instance [can navigate forward]; otherwise, <c>false</c>.
        /// </returns>
        /// <exception cref="System.NotImplementedException"></exception>
        private bool CanNavigateForward()
        {
            // Must have a patient
            bool canNavigate = this.SelectedPatient != null;

            // Must have at least one non-DICOM file
            if (this.NonDicomMediaViewModel.NonDicomFiles == null || this.NonDicomMediaViewModel.NonDicomFiles.Count == 0)
            {
                canNavigate = false;
            }

            return canNavigate;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the patient selection button text.
        /// </summary>
        /// <value>
        /// The patient selection button text.
        /// </value>
        public string PatientSelectionButtonText { get; set; }

        /// <summary>
        /// Gets or sets the non dicom media view model.
        /// </summary>
        /// <value>
        /// The non dicom media view model.
        /// </value>
        public NonDicomMediaViewModel NonDicomMediaViewModel { get; set; }


        /// <summary>
        /// Gets or sets NonDicomFilesChangedCommand.
        /// </summary>
        public DelegateCommand<CancelEventArgs> NonDicomFilesChangedCommand { get; set; }

        /// <summary>
        /// Gets or sets NavigateForward.
        /// </summary>
        public DelegateCommand<object> NavigateForward { get; set; }


        /// <summary>
        /// Gets or sets SelectedPatient.
        /// </summary>
        public Patient SelectedPatient
        {
            get
            {
                if (CurrentReconciliation == null)
                {
                    return null;
                }

                return this.CurrentReconciliation.Patient;
            }

            set
            {
                if (this.CurrentReconciliation != null)
                {
                    // Get the current patient
                    Patient currentPatient = this.CurrentReconciliation.Patient;

                    // If the current patient is different from the new patient, clear out Orders so they'll be reloaded in
                    // the next step.
                    if (currentPatient == null || currentPatient.Dfn != value.Dfn)
                    {
                        this.CurrentReconciliation.Orders = null;
                        this.CurrentReconciliation.UseExistingOrder = false;
                        this.CurrentReconciliation.CreateRadiologyOrder = false;
                    }

                    this.CurrentReconciliation.Patient = value;
                    this.CurrentReconciliation.IsPatientFromStaging = false;
                    this.CurrentReconciliation.IsPatientPreviouslyResolved = false;
                    this.PatientSelectionButtonText = "Change Patient ...";
                    this.NavigateForward.RaiseCanExecuteChanged();
                    this.RaisePropertyChanged("SelectedPatient");
                }
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether to show reconciler notes.
        /// </summary>
        /// <value>
        ///   <c>true</c> if [show reconciler notes]; otherwise, <c>false</c>.
        /// </value>
        public bool ShowReconcilerNotes { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// The on navigated from handler.
        /// </summary>
        /// <param name="navigationContext">The navigation context.</param>
        public override void OnNavigatedFrom(NavigationContext navigationContext)
        {
            base.OnNavigatedFrom(navigationContext);
            NonDicomMediaViewModel.NonDicomFilesUpdatedCommand.UnregisterCommand(this.NonDicomFilesChangedCommand);
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

            // If there are no studies in the work item yet, create a single
            // dummy DICOM study to use with the reconcilation, including dummy
            // DICOM patient and study data.
            if (this.WorkItemDetails.Studies.Count == 0)
            {
                Study study = new Study();
                study.AccessionNumber = "N/A";
                study.Procedure = "N/A";

                Patient patient = new Patient();
                patient.PatientName = "N/A";
                patient.Ssn = "N/A";
                patient.PatientIcn = "N/A";
                patient.Dob = "19000101";
                patient.PatientSex = "N/A";

                study.Patient = patient;
               
                this.WorkItemDetails.Studies.Add(study);
            }

            // Set the current study
            this.WorkItemDetails.CurrentStudy = this.WorkItemDetails.Studies[0];

            // If the reconciliation isn't set up yet, set it up.
            if (this.CurrentReconciliation == null)
            {
                // Create, initialize, and add the reconciliation
                Reconciliation reconciliation = new Reconciliation();
                reconciliation.NonDicomFiles = this.WorkItemDetails.NonDicomFiles;
                reconciliation.Patient = this.WorkItemDetails.VaPatientFromStaging;
                reconciliation.Study = this.WorkItemDetails.CurrentStudy;
                this.WorkItemDetails.CurrentStudy.Reconciliation = reconciliation;

                this.WorkItemDetails.Reconciliations.Add(reconciliation);
            }

            // Set the text of the patient selection button
            if (CurrentReconciliation.Patient == null)
            {
                this.PatientSelectionButtonText = "Select Patient";
            }
            else
            {
                this.PatientSelectionButtonText = "Change Patient";
            }
            this.RaisePropertyChanged("SelectedPatient");

            // Create the non-DICOM file view model.
            this.NonDicomMediaViewModel = new NonDicomMediaViewModel(this.UIDispatcher, this.WorkItemDetails.NonDicomFiles, this.WorkItem, this.StorageDataSource);
            this.NonDicomMediaViewModel.ShowNonDicomMedia = true;


            this.NonDicomFilesChangedCommand = new DelegateCommand<CancelEventArgs>(this.onNonDicomFilesChanged);
            NonDicomMediaViewModel.NonDicomFilesUpdatedCommand.RegisterCommand(this.NonDicomFilesChangedCommand);

            this.RaisePropertyChanged("NonDicomMediaViewModel.ShowFilePathColumn");

            // If contracted studies user but not Admin, set origin index to Fee Basis
            if (this.HasContractedStudiesKey && !this.HasAdministratorKey)
            {
                this.WorkItem.OriginIndex = "F";
            }

            this.NavigateForward.RaiseCanExecuteChanged();

            this.ShowReconcilerNotes = this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.StagedMedia.Code);

        }

        #endregion

        #region Methods
        /// <summary>
        /// On the non dicom files changed.
        /// </summary>
        /// <param name="args">The <see cref="CancelEventArgs" /> instance containing the event data.</param>
        public void onNonDicomFilesChanged(CancelEventArgs args)
        {
            NavigateForward.RaiseCanExecuteChanged();
        }


        #endregion
    }
}
