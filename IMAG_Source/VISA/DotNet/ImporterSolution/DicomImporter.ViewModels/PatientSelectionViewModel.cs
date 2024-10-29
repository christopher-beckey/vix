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
    using System.Security;
    using System.Runtime.InteropServices;
    using System.Collections.Generic;

    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Views;
    using DicomImporter.Common.ViewModels;

    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Model;

    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;
   
   
    /// <summary>
    /// The patient selection view model.
    /// </summary>
    public class PatientSelectionViewModel : ImporterReconciliationViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The change patient.
        /// </summary>
        private const string ChangePatient = "Change Patient";

        private const string PatientMessage = "Please select a patient.";
        /// <summary>
        /// The select patient.
        /// </summary>
        private const string SelectPatient = "Select Patient";

        /// <summary>
        /// The warn patient from previous reconcilation.
        /// </summary>
        private const string WarnPatientFromPreviousReconcilation =
            "Please verify that the patient below (selected in another reconciliation) is correct.";

        /// <summary>
        /// The warn patient from staging.
        /// </summary>
        private const string WarnPatientFromStaging =
            "Please verify that the patient below (selected during staging) is correct.";

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="PatientSelectionViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public PatientSelectionViewModel(IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;

            this.NavigateForward = new DelegateCommand<object>(
                o =>
                    {
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
                o => this.SelectedPatient != null);

            this.NavigateBack = new DelegateCommand<object>(
                o =>
                    {
                        if (!this.CurrentReconciliation.IsReconciliationComplete)
                        {
                            // If they haven't made it through a full reconciliation, then delete
                            // the in-progress stuff when navigating back to the study list
                            this.CancelReconciliation();
                        }
                        else
                        {
                            // Since the reconciliation was fully completed, keep it.
                            this.NavigateWorkItem(ImporterViewNames.StudyListView);
                        }
                    });

            this.CancelReconciliationCommand = new DelegateCommand<object>(
                o => this.CancelReconciliation());
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets a value indicating whether DisplayWarning.
        /// </summary>
        public bool DisplayWarning { get; set; }

        /// <summary>
        /// Gets or sets NavigateBack.
        /// </summary>
        public DelegateCommand<object> NavigateBack { get; set; }

        /// <summary>
        /// Gets or sets NavigateForward.
        /// </summary>
        public DelegateCommand<object> NavigateForward { get; set; }

        /// <summary>
        /// Gets or sets PatientSelectionButtonText.
        /// </summary>
        public string PatientSelectionButtonText { get; set; }

        /// <summary>
        /// Gets or sets SelectedPatient.
        /// </summary>
        public Patient SelectedPatient
        {
            get
            {
                return this.WorkItemDetails.CurrentStudy.Reconciliation.Patient;
            }

            set
            {
                // Get the current patient
                Patient currentPatient = this.WorkItemDetails.CurrentStudy.Reconciliation.Patient;

                // If the current patient is different from the new patient, clear out Orders so they'll be reloaded in
                // the next step.
                if (currentPatient == null || currentPatient.Dfn != value.Dfn)
                {
                    this.WorkItemDetails.CurrentStudy.Reconciliation.Orders = null;
                    this.CurrentReconciliation.UseExistingOrder = false;
                    this.CurrentReconciliation.CreateRadiologyOrder = false;
                }

                this.WorkItemDetails.CurrentStudy.Reconciliation.Patient = value;
                this.CurrentReconciliation.IsPatientFromStaging = false;
                this.CurrentReconciliation.IsPatientPreviouslyResolved = false;
                this.DisplayWarning = false;
                StudyPatientToVaPatientCache.AddOrReplaceMapping(this.WorkItemDetails.CurrentStudy.Patient, value);
                this.PatientSelectionButtonText = "Change Patient";
                this.NavigateForward.RaiseCanExecuteChanged();
                this.RaisePropertyChanged("SelectedPatient");
                this.ShowOrHidePatientMessage();
            }
        }

        /// <summary>
        /// Gets or sets WarningMessage.
        /// </summary>
        public string WarningMessage { get; set; }

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

            // Get the DICOM patient information from the study
            this.PrepopulatePatientIfPossible();

            this.ShowOrHidePatientMessage();
        }

        #endregion

        #region Methods

        /// <summary>
        /// The prepopulate patient if possible.
        /// </summary>
        private void PrepopulatePatientIfPossible()
        {
            if (this.CurrentReconciliation.Patient != null)
            {
                // There's already a patient present. Set the button text to Change Patient so they 
                // can change it if they want to.
                this.PatientSelectionButtonText = ChangePatient;

                if (this.CurrentReconciliation.IsPatientFromStaging)
                {
                    this.WarningMessage = WarnPatientFromStaging;
                    this.DisplayWarning = true;
                }
                else if (this.CurrentReconciliation.IsPatientPreviouslyResolved)
                {
                    this.WarningMessage = WarnPatientFromPreviousReconcilation;
                    this.DisplayWarning = true;
                }
            }
            else
            {
                // No patient yet. See if we can find one for the user...

                // Attempt to get a previously resolved VA Patient using DICOM-derived patient 
                // information from the study
                Patient studyPatient = this.WorkItemDetails.CurrentStudy.Patient;
                Patient previouslyResolvedPatient = StudyPatientToVaPatientCache.GetResolvedPatient(studyPatient);

                if (previouslyResolvedPatient != null)
                {
                    // This patient has been resolved in a previous reconciliation. Use that one and display
                    // the warning
                    this.WorkItemDetails.CurrentStudy.Reconciliation.Patient = previouslyResolvedPatient;
                    this.CurrentReconciliation.IsPatientPreviouslyResolved = true;
                    this.WarningMessage = WarnPatientFromPreviousReconcilation;
                    this.PatientSelectionButtonText = ChangePatient;
                    this.DisplayWarning = true;
                }
                else if (this.WorkItemDetails.VaPatientFromStaging != null)
                {
                    // The user has not yet directly selected a patient or previously reconciled one for this study info, 
                    // but we have one that was specified during staging. Use that one, show the warning, and allow them 
                    // to change the patient if they want to...
                    this.WorkItemDetails.CurrentStudy.Reconciliation.Patient = this.WorkItemDetails.VaPatientFromStaging;
                    this.CurrentReconciliation.IsPatientFromStaging = true;
                    this.PatientSelectionButtonText = ChangePatient;
                    this.WarningMessage = WarnPatientFromStaging;
                    this.DisplayWarning = true;
                }
                else
                {
                    // No way to resolve a patient for the user. Force them to select one.
                    this.PatientSelectionButtonText = SelectPatient;
                }
            }
        }

        /// <summary>
        /// Shows or hides the patient message.
        /// </summary>
        private void ShowOrHidePatientMessage()
        {
            if (this.SelectedPatient != null)
            {
                this.RemoveMessage(PatientMessage);
            }
            else
            {
                this.AddMessage(MessageTypes.Info, PatientMessage);
            }
        }
        #endregion

        /// <summary>
        /// The study patient to va patient cache.
        /// </summary>
        public class StudyPatientToVaPatientCache
        {
            #region Constants and Fields

            /// <summary>
            /// The resolved patients.
            /// </summary>
            private static readonly Dictionary<string, Patient> resolvedPatients = new Dictionary<string, Patient>();

            #endregion

            #region Public Methods

            /// <summary>
            /// The add or replace mapping.
            /// </summary>
            /// <param name="studyPatient">
            /// The study patient.
            /// </param>
            /// <param name="matchedVaPatient">
            /// The va patient.
            /// </param>
            public static void AddOrReplaceMapping(Patient studyPatient, Patient matchedVaPatient)
            {
               //P237 - High  fix - Information Exposure weakness (CWE-200).                
                if (resolvedPatients.ContainsKey(studyPatient.PatientName + "_" + studyPatient.Ssn + "_" + studyPatient.PatientSex + "_" + studyPatient.Dob))
                {
                    resolvedPatients.Remove(studyPatient.PatientName + "_" + studyPatient.Ssn + "_" + studyPatient.PatientSex + "_" + studyPatient.Dob);
                }
                resolvedPatients.Add(studyPatient.PatientName + "_" + studyPatient.Ssn + "_" + studyPatient.PatientSex + "_" + studyPatient.Dob, matchedVaPatient);

            }

            /// <summary>
            /// Gets the resolved patient.
            /// </summary>
            /// <param name="studyPatient">The study patient.</param>
            /// <returns>The patient if we have already seen that patient before</returns>
            public static Patient GetResolvedPatient(Patient studyPatient)
            {
                //P237 - High  fix - Information Exposure weakness (CWE-200).                
                if (resolvedPatients.ContainsKey(studyPatient.PatientName + "_" + studyPatient.Ssn + "_" + studyPatient.PatientSex + "_" + studyPatient.Dob))
                {
                    return resolvedPatients[studyPatient.PatientName + "_" + studyPatient.Ssn + "_" + studyPatient.PatientSex + "_" + studyPatient.Dob];
                }
                // Don't have a mapping yet...
                return null;
            }

            #endregion

            #region Methods

            ///// <summary>
            ///// Gets the study patient key.
            ///// Convert string output to securestring for P237 - High  fix - Information Exposure weakness (CWE-200).
            ///// </summary>
            ///// <param name="studyPatient">The study patient.</param>
            ///// <returns>A key representing the patient info from the DICOM header.</returns>
            //private static SecureString GetStudyPatientKey(Patient studyPatient)
            //{
            //    //return studyPatient.PatientName + "_" + studyPatient.Ssn + "_" + studyPatient.PatientSex + "_" + studyPatient.Dob;            
            //}      

            #endregion
        }
    }
}