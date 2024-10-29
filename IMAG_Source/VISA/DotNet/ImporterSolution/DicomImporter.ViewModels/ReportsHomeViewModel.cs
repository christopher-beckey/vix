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
    using System.Globalization;
    using System.IO;

    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.Views;

    using ImagingClient.Infrastructure.DialogService;

    using log4net;

    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The reports home view model.
    /// </summary>
    public class ReportsHomeViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(ReportsHomeViewModel));

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ReportsHomeViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public ReportsHomeViewModel(IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;

            this.StartDate = DateTime.Now;
            this.EndDate = DateTime.Now;
            this.SelectedReportType = this.ReportTypes[0];
            this.SelectedReportStyle = this.ReportStyles[0];

            // RaisePropertyChanged("SelectedReportType");
            // RaisePropertyChanged("SelectedReportStyle");

            // Initialize Commands
            this.ViewReportCommand = new DelegateCommand<object>(o => this.DisplayReport());

            this.PrintReportCommand = new DelegateCommand<object>(
                o => this.PrintReport(), o => !string.IsNullOrEmpty(this.ReportText));

            this.SaveReportAsCommand = new DelegateCommand<object>(
                o => this.SaveReport(), o => !string.IsNullOrEmpty(this.ReportText));

            this.NavigateToImporterHome =
                new DelegateCommand<object>(o => this.NavigateMainRegionTo(ImporterViewNames.ImporterHomeView));
        }

        #endregion

        #region Private Properties
        //Get and Set  property notification for all private  variables-OITCOPondiS
        private string _ReportText { get; set; }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets EndDate.
        /// </summary>
        public DateTime EndDate { get; set; }

        // Commands

        /// <summary>
        /// Gets or sets NavigateToImporterHome.
        /// </summary>
        public DelegateCommand<object> NavigateToImporterHome { get; set; }

        /// <summary>
        /// Gets or sets PrintReportCommand.
        /// </summary>
        public DelegateCommand<object> PrintReportCommand { get; set; }

        /// <summary>
        /// Gets ReportStyles.
        /// </summary>
        public ObservableCollection<ReportStyle> ReportStyles
        {
            get
            {
                var styles = new ObservableCollection<ReportStyle>
                    {
                        new ReportStyle("CSV", "CSV"), 
                        new ReportStyle("PrintFormat", "Print Format")
                    };
                return styles;
            }
        }

        //Begin-Get and Set  property notification for all private  variables-OITCOPondiS
        /// <summary>
        /// Gets or sets ReportText.
        /// </summary>
        //public string ReportText { get; set; }
        public string ReportText
        {
            get { return _ReportText; }
            set
            {
                _ReportText = value;
                this.RaisePropertyChanged("ReportText");
            }
        }
        
        //End

        /// <summary>
        /// Gets ReportTypes.
        /// </summary>
        public ObservableCollection<ReportType> ReportTypes
        {
            get
            {
                var types = new ObservableCollection<ReportType>
                    {
                        new ReportType("1", "Import Details"),
                        new ReportType("2", "Totals by Location"),
                        new ReportType("3", "Totals by Modality")
                    };
                return types;
            }
        }

        /// <summary>
        /// Gets or sets SaveReportAsCommand.
        /// </summary>
        public DelegateCommand<object> SaveReportAsCommand { get; set; }

        /// <summary>
        /// Gets or sets SelectedReportStyle.
        /// </summary>
        public ReportStyle SelectedReportStyle { get; set; }

        /// <summary>
        /// Gets or sets SelectedReportType.
        /// </summary>
        public ReportType SelectedReportType { get; set; }

        /// <summary>
        /// Gets or sets StartDate.
        /// </summary>
        public DateTime StartDate { get; set; }

        /// <summary>
        /// Gets or sets ViewReportCommand.
        /// </summary>
        public DelegateCommand<object> ViewReportCommand { get; set; }

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

            // Set the start and end date
            this.StartDate = this.GetStartDate();
            this.EndDate = DateTime.Now;
        }

        #endregion

        #region Methods

        /// <summary>
        /// The display report.
        /// </summary>
        private void DisplayReport()
        {
            this.ClearMessages();
     
            if (this.ValidateReportParameters())
            {
                // No validation message means everything is fine. Build the Report Parameters object 
                var parameters = new ReportParameters(
                    this.SelectedReportType.Code, this.SelectedReportStyle.Code, this.StartDate, this.EndDate);

                // Retrieve the report and display it
                Report report = this.DicomImporterDataSource.GetReport(parameters);
                this.ReportText = report.ReportText;

                // Update execution status of "print" and "save as" buttons
                this.PrintReportCommand.RaiseCanExecuteChanged();
                this.SaveReportAsCommand.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets the start date.
        /// </summary>
        /// <returns>The start date</returns>
        private DateTime GetStartDate()
        {
            var parameters = new ReportParameters { ReportTypeCode = "0" };

            Report result = this.DicomImporterDataSource.GetReport(parameters);
            DateTime startDate = DateTime.Now;

            if (!result.ReportText.StartsWith("-1"))
            {
                try
                {
                    CultureInfo provider = CultureInfo.CurrentCulture;
                    startDate = DateTime.ParseExact(result.ReportText, "yyyyMMdd", provider);
                }
                catch (Exception e)
                {
                    //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.Logged other details without by passing the actual issue reported by tool.(p289-OITCOPondiS)
                    Logger.Warn("Couldn't parse report start date from the Report Text - " + e.Message);
                    //Logger.Warn("Couldn't parse report start date from the Report Text:\n" + result.ReportText);
                    //END
                }
            }

            return startDate;
        }

        /// <summary>
        /// The print report.
        /// </summary>
        private void PrintReport()
        {
            this.DialogService.PrintTextDocument(this.ReportText, "Importer Report");
        }

        /// <summary>
        /// The save report.
        /// </summary>
        private void SaveReport()
        {
            string defaultExtension = this.SelectedReportStyle.Code == "CSV" ? ".csv" : ".txt";
            string defaultFileName = this.SelectedReportType.Code;
            string filter = "Text documents (.txt)|*.txt";

            string fileName = this.DialogService.ShowSaveFileDialog(defaultFileName, defaultExtension, filter);

            if (!string.IsNullOrEmpty(fileName))
            {
                File.WriteAllText(fileName, this.ReportText);
            }
        }

        /// <summary>
        /// Validates the report parameters.
        /// </summary>
        /// <returns>
        /// true if there are no errors and false otherwise
        /// </returns>
        private bool ValidateReportParameters()
        {
            bool hasErrors = false;

            if (this.SelectedReportType == null)
            {
               this.AddMessage(MessageTypes.Error, "You must select a report type.");
               hasErrors = true;
            }

            if (this.SelectedReportStyle == null)
            {
                this.AddMessage(MessageTypes.Error, "You must select a report style.");
                hasErrors = true;
            }

            if (this.StartDate.Date > this.EndDate.Date)
            {
                this.AddMessage(MessageTypes.Error, "The Start Date must be less than or equal to the End Date.");
                hasErrors = true;
            }

            if (this.StartDate.Date > DateTime.Now.Date)
            {
                this.AddMessage(MessageTypes.Error, "The Start Date must be less than or equal to today's date.");
                hasErrors = true;
            }

            return !hasErrors;
        }

        #endregion
    }
}