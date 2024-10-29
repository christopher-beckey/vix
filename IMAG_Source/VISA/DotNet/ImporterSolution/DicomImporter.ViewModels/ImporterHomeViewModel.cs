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
   using System.ComponentModel;
   using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;
    using DicomImporter.Common.Views;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Views;
    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// The importer home view model.
    /// </summary>
    public class ImporterHomeViewModel : ImporterViewModel
    {
      /*
      P346 - Gary Pham (oitlonphamg)
      // An event to update UI of the view importerhome.
      */
      //Begin P346
      public class PropertyChangedEventArgsGeneric  : PropertyChangedEventArgs
      {
         public PropertyChangedEventArgsGeneric(string propertyName) : base(propertyName)

         {
            m_Status = null;
         }

         public object m_Status;
      }
      //End P346
        #region Constants and Fields

      /// <summary>
      /// The no reports caption.
      /// </summary>
      private const string NoReportsCaption = "No Report Data";

        /// <summary>
        /// The no reports message.
        /// </summary>
        private const string NoReportsMessage = "No data is currently available for reports.";

        /// <summary>
        /// The name of the imaging client home view in the unity config
        /// </summary>
        private const string ImagingClientHomeView = "ImagingClientHomeView";

      #endregion

      public event PropertyChangedEventHandler m_PropertyChanged;

      #region Constructors and Destructors

      /// <summary>
      /// Initializes a new instance of the <see cref="ImporterHomeViewModel"/> class.
      /// </summary>
      /// <param name="dialogService">
      /// The dialog service.
      /// </param>
      /// <param name="dicomImporterDataSource">
      /// The dicom importer data source.
      /// </param>
      public ImporterHomeViewModel(IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
      {
         try
            {
                this.DialogService = dialogService;
                this.DicomImporterDataSource = dicomImporterDataSource;

                this.ShowVixIncompatibilityError = false;
               this.ShowVistaIncompatibilityError = false;
                this.ShowImporterControlPanel = false;

                if (!this.IsVixCompatible())
                {
                    this.ShowVixIncompatibilityError = true;
               }
                else if (!this.IsVistaCompatible())
                {
                    this.ShowVistaIncompatibilityError = true;
               }
                else
                {
                    this.InitializeCommands();
                    this.ShowImporterControlPanel = true;
                }

                this.NavigateToImagingHomeView = 
                    new DelegateCommand<object>(
                        o => this.NavigateMainRegionTo(ImagingClientHomeView), o => this.HasAdministratorKey);
            }
            catch (Exception e)
            {
                var exceptionWindow = new ExceptionWindow(e);
                exceptionWindow.SubscribeToNewUserLogin();
                exceptionWindow.ShowDialog();
            }
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets NavigateToAdministrationHomeView.
        /// </summary>
        public DelegateCommand<object> NavigateToAdministrationHomeView { get; set; }

        /// <summary>
        /// Gets or sets NavigateToDirectImportHomeView.
        /// </summary>
        public DelegateCommand<object> NavigateToDirectImportHomeView { get; set; }

        /// <summary>
        /// Gets or sets NavigateToMediaStagingView.
        /// </summary>
        public DelegateCommand<object> NavigateToMediaStagingView { get; set; }

        /// <summary>
        /// Gets or sets NavigateToReportsHomeView.
        /// </summary>
        public DelegateCommand<object> NavigateToReportsHomeView { get; set; }

        /// <summary>
        /// Gets or sets NavigateToWorkListView.
        /// </summary>
        public DelegateCommand<object> NavigateToWorkListView { get; set; }

        /// <summary>
        /// Gets or sets NavigateToImporterHomeView.
        /// </summary>
        public DelegateCommand<object> NavigateToImagingHomeView { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether a Vix incompatibility exists.
        /// </summary>
        public bool ShowVixIncompatibilityError { get; set; }
        
        /// <summary>
        /// Gets or sets a value indicating whether a Vista incompatibility exists.
        /// </summary>
        public bool ShowVistaIncompatibilityError { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether to show the importer control panel.
        /// </summary>
        public bool ShowImporterControlPanel { get; set; }

        #endregion

        #region Methods

        /// <summary>
        /// Determines whether any report data is available.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if report data is available; otherwise, <c>false</c>.
        /// </returns>
        private bool IsAnyReportDataAvailable()
        {
            var parameters = new ReportParameters { ReportTypeCode = "0" };

            Report result = this.DicomImporterDataSource.GetReport(parameters);

            return !result.ReportText.Equals("-1");
        }

        /// <summary>
        /// The navigate to reports.
        /// </summary>
        private void NavigateToReports()
        {
            if (this.IsAnyReportDataAvailable())
            {
                this.NavigateMainRegionTo(ImporterViewNames.ReportsHomeView);
            }
            else
            {
                this.DialogService.ShowAlertBox(
                    this.UIDispatcher, NoReportsMessage, NoReportsCaption, MessageTypes.Info);
            }
        }

        /// <summary>
        /// Determines whether the VIX is compatible with this client.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if VIX is compatible; otherwise, <c>false</c>.
        /// </returns>
        private bool IsVixCompatible()
        {
            return DicomImporterDataSource.IsVixCompatible();
        }

        /// <summary>
        /// Determines whether Vista is compatible with this client.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if Vista is compatible; otherwise, <c>false</c>.
        /// </returns>
        private bool IsVistaCompatible()
        {
            return DicomImporterDataSource.IsVistaCompatible();
        }

        /// <summary>
        /// Initializes the commands for the DICOM Importer functionality.
        /// </summary>
        private void InitializeCommands()
        {
            // Initialize Origin Index list
            this.DicomImporterDataSource.GetOriginIndexList();

            // Initialize the UIDActionList if necessary
            if (!UIDActionList.IsInitialized)
            {
                UIDActionList.UidActionConfigs = this.DicomImporterDataSource.GetUIDActionConfigEntries();
            }

            this.NavigateToMediaStagingView =
                new DelegateCommand<object>(
                    o => this.NavigateMainRegionTo(ImporterViewNames.SelectMediaCategoryView + "?IsForMediaStaging=true"),
                    o =>
                    this.HasStagingKey || this.HasAdvancedStagingKey || this.HasContractedStudiesKey || this.HasAdministratorKey);

            this.NavigateToWorkListView = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.WorkListView+ "?IsFirstWorkListLoading=true"),
                o => this.HasContractedStudiesKey || this.HasAdministratorKey);

            this.NavigateToDirectImportHomeView =
                new DelegateCommand<object>(
                    o => this.NavigateMainRegionTo(ImporterViewNames.SelectMediaCategoryView + "?IsForMediaStaging=false"),
                    o => this.HasContractedStudiesKey || this.HasAdministratorKey);

            this.NavigateToReportsHomeView = new DelegateCommand<object>(
                o => this.NavigateToReports(), o => this.HasReportsKey || this.HasAdministratorKey);

            this.NavigateToAdministrationHomeView =
                new DelegateCommand<object>(
                    o => this.NavigateMainRegionTo(ImporterViewNames.AdministrationHomeView), o => this.HasAdministratorKey);
        }

      #endregion

      /// <summary>
      /// P346 - Gary Pham (oitlonphamg)
      /// Signal an event to update UI of the view importerhome.
      /// </summary>
      //Begin P346
      public void UpdatePropertyChangeCompatability()
      {
         PropertyChangedEventArgsGeneric eaGeneric = new PropertyChangedEventArgsGeneric("UpdatePropertyChangeCompatability");
         eaGeneric.m_Status = new bool[] {ShowVixIncompatibilityError,
                                          ShowVistaIncompatibilityError};
         m_PropertyChanged(this, eaGeneric);
      }
      //End P346
   }   
}