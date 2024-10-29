/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/21/2013
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Lenard Williams
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
    using System.ComponentModel;
    using System.Diagnostics;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using System.Windows;
    using System.Windows.Threading;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Rest;
    using ImagingClient.Infrastructure.Utilities;
    using ImagingClient.Infrastructure.ViewModels;
    using ImagingClient.Infrastructure.Views;
    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// The status change details view model.
    /// </summary>
    public class StatusChangeDetailsViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The secondary diagnostic codes
        /// </summary>
        private ObservableCollection<DiagnosticCode> secondaryDiagnosticCodes;
        
        /// <summary>
        /// The selected exam status
        /// </summary>
        private ExamStatus selectedExamStatus;

        /// <summary>
        /// The selected diagnostic code
        /// </summary>
        private DiagnosticCode selectedDiagnosticCode;

        /// <summary>
        /// The selected standard report
        /// </summary>
        private StandardReport selectedStandardReport;

        private String _ManuallyEnteredText;
        private String _StandardReportText; 
        private String _StandardReportImpression;
        private String _ProgressText;

        private DispatcherTimer readingImageTimer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(1) };

        private const String SOP_CLASS_UID_DICOM_SR = "1.2.840.10008.5.1.4.1.1.104.1";
        public bool IsReadingMessageVisible = false;

        /// <summary>
        /// The progress view model.
        /// </summary>
        //private ProgressViewModel progressViewModel = new ProgressViewModel();

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="StatusChangeDetailsViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public StatusChangeDetailsViewModel(
            IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;

            this.StatusChangeDetails = new StatusChangeDetails();

            this.PopulateLists();
            this.IsReadingMessageVisible = false;

            this.OkCommand = new DelegateCommand<object>(o => this.PeformOk(), o => this.IsOkButtonEnabled());
            this.GetReportFromImageCommand = new DelegateCommand<object>(o => this.PeformGetReportFromImage(), o => this.IsGetReportButtonEnabled());
            this.CancelCommand = new DelegateCommand<object>(o => this.PeformCancel(), o => !this.IsReadingMessageVisible);
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
        public delegate void WindowActionEventHandler(object sender, WindowActionEventArgs e);

        #endregion

        #region Public Events

        /// <summary>
        /// The window action.
        /// </summary>
        public event WindowActionEventHandler WindowAction;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the diagnostic codes.
        /// </summary>
        public ObservableCollection<DiagnosticCode> DiagnosticCodes { get; set; }

        /// <summary>
        /// Gets or sets the order exam statuses.
        /// </summary>
        public ObservableCollection<ExamStatus> OrderExamStatuses { get; set; }

        /// <summary>
        /// Gets or sets the secondary diagnostic codes.
        /// </summary>
        public ObservableCollection<DiagnosticCode> SecondaryDiagnosticCodes 
        {
            get
            {
                return this.secondaryDiagnosticCodes;
            }

            set
            {
                this.secondaryDiagnosticCodes = value;
                this.StatusChangeDetails.SecondaryDiagnosticCodes = new ObservableCollection<SecondaryDiagnosticCode>();
            }
        }


        /// <summary>
        /// Gets or sets the ProgressText
        /// </summary>
        public String ProgressText
        {
            get
            {
                return _ProgressText;
            }

            set
            {
                _ProgressText = value;
                this.RaisePropertyChanged("ProgressText");

            }
        }

        /// <summary>
        /// Gets or sets the selected exam status.
        /// </summary>
        public ExamStatus SelectedExamStatus
        {
            get
            {
                return this.selectedExamStatus;
            }

            set
            {
                this.selectedExamStatus = value;
                this.StatusChangeDetails.RequestedStatus = value.Status;
                this.OkCommand.RaiseCanExecuteChanged();
                this.GetReportFromImageCommand.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets or sets the selected primary diagnostic code.
        /// </summary>
        /// <value>
        /// The selected primary diagnostic code.
        /// </value>
        public DiagnosticCode SelectedPrimaryDiagnosticCode
        {
            get
            {
                return this.selectedDiagnosticCode;
            }

            set
            {
                this.selectedDiagnosticCode = value;
                this.StatusChangeDetails.PrimaryDiagnosticCode = value;

                // removes the selected primary diagnostic code from the list of secondary diagnostic codes
                ObservableCollection<DiagnosticCode> filteredSecondaryDiagnosticCodes = new ObservableCollection<DiagnosticCode>(this.DiagnosticCodes);
                filteredSecondaryDiagnosticCodes.Remove(value);
                this.SecondaryDiagnosticCodes = filteredSecondaryDiagnosticCodes;
                this.OkCommand.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets or sets the selected secondary diagnostic code.
        /// </summary>
        public ObservableCollection<DiagnosticCode> SelectedSecondaryDiagnosticCodes
        {
            get
            {
                return this.FindSecondaryDiagnosticCodes(this.StatusChangeDetails.SecondaryDiagnosticCodes);
            }

            set
            {
                this.StatusChangeDetails.SecondaryDiagnosticCodes  = new ObservableCollection<SecondaryDiagnosticCode>();
      
                foreach (DiagnosticCode code in value)
                {
                    this.StatusChangeDetails.SecondaryDiagnosticCodes.Add(new SecondaryDiagnosticCode(code));
                }

                this.StatusChangeDetails.SecondaryDiagnosticCodeCount = this.StatusChangeDetails.SecondaryDiagnosticCodes.Count;
                this.OkCommand.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets or sets the selected standard report.
        /// </summary>
        public StandardReport SelectedStandardReport
        {
            get
            {
                return this.selectedStandardReport;
            }

            set
            {
                this.selectedStandardReport = value;

                string reportName = null;
                string reportNumber = null;

                if (value != null)
                {
                    reportName = value.ReportName;
                    reportNumber = value.Id.ToString();
                    this.StandardReportImpression = value.Impression;
                    this.StandardReportText = value.ReportText;
                }

                this.StatusChangeDetails.StandardReportName = reportName;
                this.StatusChangeDetails.StandardReportNumber = reportNumber;

                this.OkCommand.RaiseCanExecuteChanged();
            }
        }

        private Study SelectedStudy;

        private int SelectedWorkItemId;

        /// <summary>
        /// Gets or sets the standard reports.
        /// </summary>
        public ObservableCollection<StandardReport> StandardReports { get; set; }

        /// <summary>
        /// Gets or sets the status change details.
        /// </summary>
        public StatusChangeDetails StatusChangeDetails { get; set; }

        #endregion

        #region Delegate Commands

        /// <summary>
        /// Gets or sets CancelCommand.
        /// </summary>
        public DelegateCommand<object> CancelCommand { get; set; }

        /// <summary>
        /// Gets or sets OkCommand.
        /// </summary>
        public DelegateCommand<object> OkCommand { get; set; }

        /// <summary>
        /// Gets or sets GetReportFromImageCommand.
        /// </summary>
        public DelegateCommand<object> GetReportFromImageCommand { get; set; }

        /// <summary>
        /// Gets or sets ManuallyEnteredText.
        /// </summary>
        public string ManuallyEnteredText
        {
            get { return _ManuallyEnteredText; }
            set
            {
                _ManuallyEnteredText = value;
            }
        }

        /// <summary>
        /// Gets or sets StandardReportText.
        /// </summary>
        public string StandardReportText
        {
            get { return _StandardReportText; }
            set
            {
                _StandardReportText = value;
                this.RaisePropertyChanged("StandardReportText");
            }
        }

        /// <summary>
        /// Gets or sets StandardReportImpression.
        /// </summary>
        public string StandardReportImpression
        {
            get { return _StandardReportImpression; }
            set
            {
                _StandardReportImpression = value;
                this.RaisePropertyChanged("StandardReportImpression");
            }
        }

        public DispatcherTimer ReadingImageTimer {
            get {
                return readingImageTimer;
            }
            set {
                readingImageTimer = value;
            }
        }

        public Action<object, EventArgs> ReadingImageTimerStopped { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// Sets the current status change details.
        /// </summary>
        /// <param name="details">The details.</param>
        public void SetCurrentStatusChangeDetails(StatusChangeDetails details)
        {
            if (details != null)
            {
                this.PopulateOrderExamStatuses(details);
                this.SelectedExamStatus = this.FindOrderExamStatus(details.RequestedStatus);
                this.SelectedPrimaryDiagnosticCode = this.FindDiagnosticCode(details.PrimaryDiagnosticCode, this.DiagnosticCodes);
                this.SelectedSecondaryDiagnosticCodes = this.FindSecondaryDiagnosticCodes(details.SecondaryDiagnosticCodes);
                this.SelectedStandardReport = this.FindStandardReport(details.StandardReportNumber);
                this.SelectedStudy = details.CurrentStudy;
                this.SelectedWorkItemId = details.WorkItemId;
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Finds the diagnostic code.
        /// </summary>
        /// <param name="code">The code.</param>
        /// <returns></returns>
        private DiagnosticCode FindDiagnosticCode(DiagnosticCode code, ObservableCollection<DiagnosticCode> codes)
        {
            if (codes != null && code != null)
            {
                foreach (DiagnosticCode diagnosticCode in this.DiagnosticCodes)
                {
                    if (diagnosticCode.Name.Equals(code.Name))
                    {
                        return diagnosticCode;
                    }
                }
            }

            return null;
        }

        /// <summary>
        /// Finds the order exam status.
        /// </summary>
        /// <param name="statusName">Name of the status.</param>
        /// <returns></returns>
        private ExamStatus FindOrderExamStatus(string statusName)
        {
            if (this.OrderExamStatuses != null)
            {
                foreach (ExamStatus status in this.OrderExamStatuses)
                {
                    if (status.Status.Equals(statusName))
                    {
                        return status;
                    }
                }
            }

            return null;
        }

        /// <summary>
        /// Finds the secondary diagnostic codes.
        /// </summary>
        /// <param name="codes">The codes.</param>
        /// <returns></returns>
        private ObservableCollection<DiagnosticCode> FindSecondaryDiagnosticCodes(ObservableCollection<SecondaryDiagnosticCode> codes)
        {
            ObservableCollection<DiagnosticCode> secondaryCodes = new ObservableCollection<DiagnosticCode>();

            if (this.SecondaryDiagnosticCodes != null && codes != null)
            {
                foreach (DiagnosticCode code in codes)
                {
                    secondaryCodes.Add(this.FindDiagnosticCode(code, this.SecondaryDiagnosticCodes));
                }
            }

            return secondaryCodes;
        }

        /// <summary>
        /// Finds the standard report.
        /// </summary>
        /// <param name="id">The report number.</param>
        /// <returns></returns>
        private StandardReport FindStandardReport(string id)
        {
            if (string.IsNullOrWhiteSpace(id))
            {
                return null;
            }

            if (this.StandardReports != null)
            {
                int reportId = Convert.ToInt32(id);

                foreach (StandardReport report in this.StandardReports)
                {
                    if (report.Id == reportId)
                    {
                        return report;
                    }
                }
            }

            return null;
        }

        /// <summary>
        /// Determines whether if ok button is enabled.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if ok button is enabled; otherwise, <c>false</c>.
        /// </returns>
        private bool IsOkButtonEnabled()
        {
            return (this.SelectedExamStatus != null) && !this.IsReadingMessageVisible;
        }

        private bool IsGetReportButtonEnabled()
        {
            return (this.SelectedExamStatus != null)
                && this.SelectedExamStatus.Status.Equals(ExamStatuses.Complete)
                && !this.IsReadingMessageVisible
                && this.CurrentModalities.Contains("SR");
            //&& (this.SelectedWorkItemId > 0)
            //&& (this.SelectedStudy != null)
            //&& (this.SelectedStudy.ModalityCodes != null);
            //&& (this.SelectedStudy.ModalityCodes.Equals("SR"));
        }

        /// <summary>
        /// The peform cancel.
        /// </summary>
        private void PeformCancel()
        {
            this.WindowAction(this, new WindowActionEventArgs(false));
        }

        /// <summary>
        /// The peform ok.
        /// </summary>
        private void PeformOk()
        {
            if (this.selectedStandardReport == null)
            {
                this.selectedStandardReport = new StandardReport();
                this.StatusChangeDetails.StandardReportName = String.Empty;
                this.StatusChangeDetails.StandardReportNumber = String.Empty;
            }
            this.selectedStandardReport.ReportText = this.StandardReportText;
            this.selectedStandardReport.Impression = this.StandardReportImpression;

            this.StatusChangeDetails.ManuallyEnteredText = this.ManuallyEnteredText; 
            this.StatusChangeDetails.ReportText = this.selectedStandardReport.ReportText;
            this.StatusChangeDetails.Impression = this.selectedStandardReport.Impression;

            this.WindowAction(this, new WindowActionEventArgs(true));
        }

        /// <summary>
        /// The PeformGetReportFromImage.
        /// </summary>
        private void PeformGetReportFromImage()
        {
            // Create and spawn a new backround worker to actually read the drive.
            // This lets us cancel if necessary, etc.
            this.Worker = new BackgroundWorker { WorkerSupportsCancellation = true };
            this.Worker.DoWork += this.GetReportFromImage;
            this.Worker.RunWorkerCompleted += this.GetReportFromImageCompleted;
            this.Worker.RunWorkerAsync();
        }

        public void GetReportFromImage(object o, DoWorkEventArgs args)
        {
            this.ReadingImageTimer.Start();

            //Artifical long task (for testing)
            //var sw = Stopwatch.StartNew();
            //while (sw.ElapsedMilliseconds < 12000)
            //    Thread.SpinWait(1000);
            //String reportText = "Radiology Report Text^Impression Text";

            //TESTING
            //String reportText = this.DicomImporterDataSource.ReadImageText(100, "Blah");
            //String[] txt = reportText.Split('^');
            //this.StandardReportImpression = txt[1];
            //this.StandardReportText = txt[2];

            //try
            //{
            //    this.SelectedWorkItemId
            //    // Using the id, get the full workItem and transition it to InReconciliation
            //    this.WorkItem = this.DicomImporterDataSource.GetAndTranstionImporterWorkItem(
            //        this.Sl SelectedWorkItem, this.SelectedWorkItem.Status, ImporterWorkItemStatuses.InReconciliation);
            //}
            //catch (ServerException se)
            //{
            //    // Handle the server exception and then return. Note that if it's not one of the know exceptions we handle, 
            //    // the exception will be rethrown, to be handled by the general exception handler
            //    this.HandleServerException(se);
            //    return;
            //}

            int selectedWorkItemId = int.Parse(this.SelectedWorkItemKey);
            string reportText = this.DicomImporterDataSource.ReadImageText(selectedWorkItemId);
            if (!string.IsNullOrEmpty(reportText))
            {
                string[] txt = reportText.Split('^');
                if (txt[0].Equals("0"))
                {
                    reportText = string.Join("^", txt, 1, txt.Length - 1);
                    string[] rptImp = reportText.Split(new string[] { "[IMPRESSION SECTION]" }, StringSplitOptions.None);
                    this.StandardReportText = rptImp[0];
                    this.StandardReportImpression = (rptImp.Length > 1 ? rptImp[1] : rptImp[0]);
                }
                else
                {
                    this.DialogService.ShowAlertBox(this.UIDispatcher, "Unable to find Report or Impression Text",
                    "Reading DICOM Text Error", MessageTypes.Error);
                }
            }
            else
            {
                this.DialogService.ShowAlertBox(this.UIDispatcher, "DICOM has No Report or Impression Text", "Reading DICOM Text", MessageTypes.Error);
                this.StandardReportImpression = String.Empty;
                this.StandardReportText = String.Empty;
            }

            //if (this.SelectedStudy != null)
            ////&& (this.SelectedStudy.Series.Count == 1)
            ////&& (this.SelectedStudy.Series[0].SopInstances.Count == 1))
            //{
            //    string standardReportImpression = String.Empty;
            //    string standardReportText = String.Empty;
            //    bool anyDICOMSR = false;
            //    for (var seriesIdx = 0; seriesIdx < this.SelectedStudy.Series.Count; seriesIdx++)
            //    {
            //        for (var instanceIdx = 0;
            //            instanceIdx < this.SelectedStudy.Series[seriesIdx].SopInstances.Count; instanceIdx++)
            //        {
            //            SopInstance instance = this.SelectedStudy.Series[seriesIdx].SopInstances[instanceIdx];
            //            if ((instance.SopClassUid != null) && instance.SopClassUid.Equals(SOP_CLASS_UID_DICOM_SR))
            //            {
            //                anyDICOMSR = true;
            //                string reportText = this.DicomImporterDataSource.ReadImageText(this.SelectedWorkItemId, instance.FilePath);

            //                if (!string.IsNullOrEmpty(reportText))
            //                {
            //                    string[] txt = reportText.Split('^');
            //                    if (txt[0].Equals("0"))
            //                    {
            //                        standardReportImpression += txt[1];
            //                        standardReportText += (txt.Length > 2 ? txt[2] : string.Empty);
            //                    }
            //                    //else
            //                    //{
            //                    //    this.DialogService.ShowAlertBox(this.UIDispatcher, txt[1],
            //                    //    "Reading DICOM Text Error", MessageTypes.Error);
            //                    //}
            //                }
            //            }
            //        }
            //    }

            //    if (!anyDICOMSR)
            //    {
            //        this.DialogService.ShowAlertBox(this.UIDispatcher, "No DICOM SR found in this Study.", 
            //            "Reading DICOM Text", MessageTypes.Info);
            //    }
            //    else if (string.IsNullOrEmpty(standardReportImpression) && string.IsNullOrEmpty(standardReportText))
            //    {
            //        this.DialogService.ShowAlertBox(this.UIDispatcher, "NO DICOM Text found.", 
            //            "Reading DICOM Text", MessageTypes.Info);
            //    }
            //    else
            //    {
            //        this.StandardReportImpression = standardReportImpression;
            //        this.StandardReportText = standardReportText;
            //    }
            //}
            //else
            //{
            //    this.DialogService.ShowAlertBox(this.UIDispatcher, "Unable to find DICOM file", "Reading DICOM Text Error", MessageTypes.Error);
            //    this.StandardReportImpression = String.Empty;
            //    this.StandardReportText = String.Empty;
            //}
        }

        private void GetReportFromImageCompleted(object o, RunWorkerCompletedEventArgs args)
        {
            this.ReadingImageTimer.Stop();
            this.IsReadingMessageVisible = false;
            ReadingImageTimerStopped(this, null);
        }

        /// <summary>
        /// Populates the lists from the database.
        /// </summary>
        private void PopulateLists()
        {
            try
            {
                this.PopulateOrderExamStatuses(null);

                if (this.DiagnosticCodes == null)
                {
                    this.DiagnosticCodes = this.DicomImporterDataSource.GetDiagnosticCodesList();
                    this.SecondaryDiagnosticCodes = DiagnosticCodes;
                }

                if (this.StandardReports == null)
                {
                    this.StandardReports = this.DicomImporterDataSource.GetStandardReportsList();
                }
            }
            catch (Exception ex)
            {
                var window = new ExceptionWindow(ex);
                window.SubscribeToNewUserLogin();
                window.ShowDialog();
            }
        }

        /// <summary>
        /// Populates the order exam statuses.
        /// </summary>
        private void PopulateOrderExamStatuses(StatusChangeDetails details)
        {
            ExamStatus examStatus = new ExamStatus();
            this.OrderExamStatuses = new ObservableCollection<ExamStatus>();

            if (details != null && !string.IsNullOrEmpty(details.RequestedStatus))
            {
               // add the current order status as an option
                examStatus = new ExamStatus();
                examStatus.Id = 1;
                examStatus.Status = details.RequestedStatus;
                this.OrderExamStatuses.Add(examStatus);

                // adds the completed exam status if it isnt the current order status
                if (!ExamStatuses.IsCompletedStatus(details.RequestedStatus))
                {
                    examStatus = new ExamStatus();
                    examStatus.Id = 2;
                    examStatus.Status = ExamStatuses.Complete;
                    this.OrderExamStatuses.Add(examStatus);
                }
            }
            else 
            {
                // adds the default Patch 118 statuses
                examStatus = new ExamStatus();
                examStatus.Id = 1;
                examStatus.Status = ExamStatuses.Examined;
                this.OrderExamStatuses.Add(examStatus);

                examStatus = new ExamStatus();
                examStatus.Id = 2;
                examStatus.Status = ExamStatuses.Complete;
                this.OrderExamStatuses.Add(examStatus);
            }
        }

        #endregion
    }
}