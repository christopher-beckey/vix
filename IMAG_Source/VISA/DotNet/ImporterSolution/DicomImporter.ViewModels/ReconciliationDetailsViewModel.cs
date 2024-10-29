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

    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;

    using ImagingClient.Infrastructure.Model;

    /// <summary>
    /// The reconciliation details view model.
    /// </summary>
    public class ReconciliationDetailsViewModel : ImporterViewModel
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ReconciliationDetailsViewModel"/> class.
        /// </summary>
        /// <param name="study">
        /// The study.
        /// </param>
        public ReconciliationDetailsViewModel(Study study, ImporterWorkItem workItem)
            : this(study, 0, workItem)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ReconciliationDetailsViewModel"/> class.
        /// </summary>
        /// <param name="study">
        /// The study.
        /// </param>
        /// <param name="displayIndex">
        /// The display index.
        /// </param>
        public ReconciliationDetailsViewModel(Study study, int displayIndex, ImporterWorkItem workItem)
        {
            this.Study = study;
            this.DisplayIndex = displayIndex;
            this.WorkItem = workItem;
            this.BuildProperties();
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets LineItems.
        /// </summary>
        public ObservableCollection<ReconciliationLineItem> LineItems { get; set; }

        /// <summary>
        /// Gets or sets OrderAccessionNumber.
        /// </summary>
        public string OrderAccessionNumber { get; set; }

        /// <summary>
        /// Gets or sets OrderDateOfBirth.
        /// </summary>
        public string OrderDateOfBirth { get; set; }

        /// <summary>
        /// Gets or sets the order exam status.
        /// </summary>
        public string OrderExamStatus { get; set; } 

        /// <summary>
        /// Gets or sets OrderPatientId.
        /// </summary>
        public string OrderPatientId { get; set; }

        /// <summary>
        /// Gets or sets OrderPatientName.
        /// </summary>
        public string OrderPatientName { get; set; }

        /// <summary>
        /// Gets or sets OrderPatientSex.
        /// </summary>
        public string OrderPatientSex { get; set; }

        /// <summary>
        /// Gets or sets the order primary diagnostic code.
        /// </summary>
        public string OrderPrimaryDiagnosticCode { get; set; }

        /// <summary>
        /// Gets or sets OrderProcedure.
        /// </summary>
        public string OrderProcedure { get; set; }

        /// <summary>
        /// Gets or sets OrderProcedureModifiers.
        /// </summary>
        public string OrderProcedureModifiers { get; set; }

        /// <summary>
        /// Gets or sets the order standard report.
        /// </summary>
        public string OrderStandardReport { get; set; }

        /// <summary>
        /// Gets or sets the order secondary diagnostic codes.
        /// </summary>

        public string OrderSecondaryDiagnosticCodes { get; set; }

        /// <summary>
        /// Gets or sets OrderStudyDate.
        /// </summary>
        public string OrderStudyDate { get; set; }

        /// <summary>
        /// Gets ReconciliationHeader.
        /// </summary>
        public string ReconciliationHeader
        {
            get
            {
                return this.DisplayIndex + ") Study #" + this.Study.IdInMediaBundle;
            }
        }

        /// <summary>
        /// Gets or sets StudyAccessionNumber.
        /// </summary>
        public string StudyAccessionNumber { get; set; }

        /// <summary>
        /// Gets or sets StudyDate.
        /// </summary>
        public string StudyDate { get; set; }

        /// <summary>
        /// Gets or sets StudyDateOfBirth.
        /// </summary>
        public string StudyDateOfBirth { get; set; }

        /// <summary>
        /// Gets or sets StudyPatientId.
        /// </summary>
        public string StudyPatientId { get; set; }

        /// <summary>
        /// Gets or sets StudyPatientName.
        /// </summary>
        public string StudyPatientName { get; set; }

        /// <summary>
        /// Gets or sets StudyPatientSex.
        /// </summary>
        public string StudyPatientSex { get; set; }

        /// <summary>
        /// Gets or sets StudyProcedure.
        /// </summary>
        public string StudyProcedure { get; set; }

        /// <summary>
        /// Gets or sets StudyProcedureModifiers.
        /// </summary>
        public string StudyProcedureModifiers { get; set; }

        #endregion

        #region Properties

        /// <summary>
        /// Gets or sets DisplayIndex.
        /// </summary>
        private int DisplayIndex { get; set; }

        /// <summary>
        /// Gets Order.
        /// </summary>
        private Order Order
        {
            get
            {
                // If there's a reconciliation, return the order from the reconciliation
                if (this.Reconciliation != null)
                {
                    return this.Reconciliation.Order;
                }

                // If there's a "previously reconciled order", fall back to that
                if (this.Study.PreviouslyReconciledOrder != null)
                {
                    return this.Study.PreviouslyReconciledOrder;
                }

                // If we have neither, then return null
                return null;
            }
        }

        /// <summary>
        /// Gets Patient.
        /// </summary>
        private Patient Patient
        {
            get
            {
                // If there's a reconciliation, return the patient from the reconciliation
                if (this.Reconciliation != null)
                {
                    return this.Reconciliation.Patient;
                }

                // If there's a "previously reconciled patient", fall back to that
                if (this.Study.PreviouslyReconciledPatient != null)
                {
                    return this.Study.PreviouslyReconciledPatient;
                }

                // If we have neither, then return null
                return null;
            }
        }

        /// <summary>
        /// Gets Reconciliation.
        /// </summary>
        private Reconciliation Reconciliation
        {
            get
            {
                return this.Study.Reconciliation;
            }
        }

        /// <summary>
        /// Gets or sets Study.
        /// </summary>
        private Study Study { get; set; }

        #endregion

        #region Methods

        /// <summary>
        /// The build properties.
        /// </summary>
        private void BuildProperties()
        {
            this.StudyPatientName = this.IsDicomWorkItem ? this.Study.Patient.PatientName : "N/A";
            this.OrderPatientName = this.Patient != null ? this.Patient.PatientName : string.Empty;

            this.StudyPatientId = this.IsDicomWorkItem ? this.Study.Patient.Ssn : "N/A";
            this.OrderPatientId = this.Patient != null ? this.Patient.Ssn : string.Empty;

            this.StudyDateOfBirth = this.IsDicomWorkItem ? this.Study.Patient.FormattedBirthDate : "N/A";
            this.OrderDateOfBirth = this.Patient != null ? this.Patient.FormattedBirthDate : string.Empty;

            this.StudyPatientSex = this.IsDicomWorkItem ? this.Study.Patient.PatientSex : "N/A";
            this.OrderPatientSex = this.Patient != null ? this.Patient.PatientSex : string.Empty;

            this.StudyAccessionNumber = this.IsDicomWorkItem ? this.Study.AccessionNumber : "N/A";
            this.OrderAccessionNumber = this.GetOrderAccessionNumber();

            this.StudyDate = GetStudyDate();
            this.OrderStudyDate = this.GetOrderStudyDate();

            this.StudyProcedure = this.Study.Procedure;
            this.OrderProcedure = this.GetOrderProcedure();

            this.StudyProcedureModifiers = this.IsDicomWorkItem ? string.Empty : "N/A";
            this.OrderProcedureModifiers = this.GetOrderProcedureModifiers();

            this.OrderExamStatus = this.GetOrderExamStatus();
            this.OrderPrimaryDiagnosticCode = this.GetOrderPrimaryDiagnosticCode();
            this.OrderStandardReport = this.GetOrderStandardReport();
            this.OrderSecondaryDiagnosticCodes = this.GetOrderSecondaryDiagnosticCodes();

            this.UpdateWorkItemFilters();
        }

        private void UpdateWorkItemFilters()
        {
            if (!String.IsNullOrEmpty(this.Study.Procedure))
            {
                this.WorkItem.Procedure = this.Study.Procedure;
            }
            if (!String.IsNullOrEmpty(this.Study.ModalityCodes))
            {
                this.WorkItem.Modality = this.Study.ModalityCodes;
            }
        }

        /// <summary>
        /// Gets the order accession number.
        /// </summary>
        /// <returns>The order accession number or a message indicating it will be created</returns>
        private string GetOrderAccessionNumber()
        {
            string accessionNumber = string.Empty;

            if (this.Order != null)
            {
                accessionNumber = this.Order.IsToBeCreated
                                      ? "(Will be automatically generated)"
                                      : this.Order.AccessionNumber;
            }

            return accessionNumber;
        }

        /// <summary>
        /// Gets the order exam status.
        /// </summary>
        /// <returns>The order exam status</returns>
        private string GetOrderExamStatus()
        {
            if (this.Order != null)
            {
                return this.Order.StatusChangeDetails != null ? this.Order.StatusChangeDetails.RequestedStatus : string.Empty;
            }

            return string.Empty;
        }

        /// <summary>
        /// Gets the order primary diagnostic code.
        /// </summary>
        /// <returns>The primary diagnostic code</returns>
        private string GetOrderPrimaryDiagnosticCode()
        {
            if (this.Order != null && this.Order.StatusChangeDetails != null)
            {
                return this.Order.StatusChangeDetails.PrimaryDiagnosticCode != null ? this.Order.StatusChangeDetails.PrimaryDiagnosticCode.DisplayName : string.Empty;
            }

            return string.Empty;
        }

        /// <summary>
        /// Gets the order procedure.
        /// </summary>
        /// <returns>The order procedure</returns>
        private string GetOrderProcedure()
        {
            if (this.Order != null)
            {
                return this.Order.Procedure != null ? this.Order.Procedure.Name : string.Empty;
            }

            return string.Empty;
        }

        /// <summary>
        /// Gets the order procedure modifiers.
        /// </summary>
        /// <returns>A line-separated list of procedure modifiers</returns>
        private string GetOrderProcedureModifiers()
        {
            string modifiers = string.Empty;
            if (this.Order != null && this.Order.ProcedureModifiers != null)
            {
                int count = 0;
                foreach (ProcedureModifier modifier in this.Order.ProcedureModifiers)
                {
                    if (count != 0)
                    {
                        modifiers += "\n";
                    }

                    modifiers += modifier.Name;
                    count++;
                }
            }

            return modifiers;
        }

        /// <summary>
        /// Gets the order standard report.
        /// </summary>
        /// <returns>The order standard report</returns>
        private string GetOrderStandardReport()
        {
            if (this.Order != null)
            {
                return this.Order.StatusChangeDetails != null ? this.Order.StatusChangeDetails.StandardReportName : string.Empty;
            }

            return string.Empty;
        }

        /// <summary>
        /// Gets the order secondary diagnostic codes.
        /// </summary>
        /// <returns>
        /// A string consisting of the secondary diagnostic codes. </returns>
        private string GetOrderSecondaryDiagnosticCodes()
        {
            string codeNames = string.Empty;

            if (this.Order != null && this.Order.StatusChangeDetails != null && 
                this.Order.StatusChangeDetails.SecondaryDiagnosticCodes != null)
            {
                bool isFirstCode = true;

                foreach (DiagnosticCode code in this.Order.StatusChangeDetails.SecondaryDiagnosticCodes)
                {
                    if (isFirstCode)
                    {
                        codeNames = code.DisplayName;
                        isFirstCode = false;
                    }
                    else
                    {
                        codeNames = codeNames + ", " + code.DisplayName;
                    }
                }
            }

            return codeNames;
        }

        /// <summary>
        /// Gets the study date.
        /// </summary>
        /// <returns>
        /// Study date of the study, or a message indicating it is N/A
        /// </returns>
        private string GetStudyDate()
        {
            string studyDate = this.Study.FormattedStudyDate;

            if (!IsDicomWorkItem && !this.Order.IsToBeCreated)
            {
                studyDate = "N/A";
            }

            return studyDate;
        }

        /// <summary>
        /// Gets the order study date.
        /// </summary>
        /// <returns>
        /// Study date of the order, or a message indicating it will be set
        /// to the same date as the order
        /// </returns>
        private string GetOrderStudyDate()
        {
            string studyDate = string.Empty;

            if (this.Order != null)
            {

                studyDate = this.Order.IsToBeCreated
                                ? "(Will be set to same date)"
                                : this.Order.OrderDateAsDateTime.ToString();
            }

            return studyDate;
        }

        #endregion

        /// <summary>
        /// The reconciliation line item.
        /// </summary>
        public class ReconciliationLineItem
        {
            #region Public Properties

            /// <summary>
            /// Gets or sets Header.
            /// </summary>
            public string Header { get; set; }

            /// <summary>
            /// Gets or sets OrderValue.
            /// </summary>
            public string OrderValue { get; set; }

            /// <summary>
            /// Gets or sets StudyValue.
            /// </summary>
            public string StudyValue { get; set; }

            #endregion
        }
    }
}