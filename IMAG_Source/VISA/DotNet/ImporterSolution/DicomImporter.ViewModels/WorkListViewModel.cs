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

using DicomImporter.Common.Services;
using ImagingClient.Infrastructure.StorageDataSource;
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace DicomImporter.ViewModels
{
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Linq;

    using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.Views;
    using DicomImporter.Common.ViewModels;

    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Exceptions;
    using ImagingClient.Infrastructure.Views;

    using log4net;

    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;
    using ImagingClient.Infrastructure.Configuration;

    /// <summary>
    /// The work list view model.
    /// </summary>
    public class WorkListViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(WorkListViewModel));

        /// <summary>
        /// The all sources.
        /// </summary>
        private const string AllSources = "All Sources";

        /// <summary>
        /// The all services.
        /// </summary>
        private const string AllServices = "All Services";

        private const string NoService = "[No Service]";

        /// <summary>
        /// The all modalities.
        /// </summary>
        private const string AllModalities = "All Modalities";

        private const string NoModality = "[No Modality]";

        /// <summary>
        /// The all procedures.
        /// </summary>
        private const string AllProcedures = "All Procedures";

        private const string NoProcedure = "[No Procedure]";

        /// <summary>
        /// The Logged in as CSRA message.
        /// </summary>
        private const string LoggedInAsCSRAMessage = "You are currently logged in as a Contracted Studies User. Only Fee Basis work items are available for reconciliation.";

        /// <summary>
        /// The no items available message.
        /// </summary>
        private const string NoItemsAvailableMessage = "No importer items are currently available for reconciliation.";


        /// <summary>
        /// The no search items found message.
        /// </summary>
        private const string NoSearchItemsFoundMessage = "No importer items were found matching your filter criteria.";

        //private int LastWorkItemProcessedId = 0;
        private bool _NewerToOlder = true;
        private bool _OlderToNewer = false;
	    public IDialogServiceImporter m_dlgServiceImporter;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="WorkListViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="importerDialogService">
        /// The importer dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        /// <param name="storageDataSource">
        /// The storage data source.
        /// </param>
        public WorkListViewModel(IDialogService dialogService, 
        IImporterDialogService importerDialogService,
        IDialogServiceImporter dialogServiceImporter, 
        IDicomImporterDataSource dicomImporterDataSource, 
        IStorageDataSource storageDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;
            this.ImporterDialogService = importerDialogService;
            this.StorageDataSource = storageDataSource;
            m_dlgServiceImporter = dialogServiceImporter;
            this._NewerToOlder = true; // Should be pulled from user pref
            this._OlderToNewer = !_NewerToOlder;

            FillMaxRows();
            FillFilters();

            // Navigate to the Study List view, passing in the workitem key
            this.NavigateToListViewCommand = new DelegateCommand<object>(
                o => this.NavigateToListView(), o => (this.SelectedWorkItem != null));

            this.DeleteImportItemCommand = new DelegateCommand<object>(
                o => this.DeleteImportItem(), o => (this.SelectedWorkItem != null));

            this.NavigateToImporterHomeViewCommand =
                new DelegateCommand<object>(o => this.NavigateMainRegionTo(ImporterViewNames.ImporterHomeView));

            this.ApplyFilterCommand = new DelegateCommand<object>(o => this.ApplyFilter());
            this.ResetFilterCommand = new DelegateCommand<object>(o => this.ResetFilter());
            this.SaveFilterCommand = new DelegateCommand<object>(o => this.SaveFilter());
            this.UpdateServiceCommand = new DelegateCommand<object>(
                o => this.UpdateService(), o => (this.SelectedWorkItem != null));
        }

        private void FillFilters()
        {
            this.Services = new ObservableCollection<string>();
            this.Services.Insert(0, AllServices);
            this.Services.Insert(1, NoService);
            this.ServiceFilter = this.Services[0];
            this.Services.Add("Radiology");
            this.Services.Add("Consult");
            this.Services.Add("Lab");

            ObservableCollection<string> procedures = this.DicomImporterDataSource.GetWorkItemProcedures();
            this.Procedures = new ObservableCollection<string>(procedures);
            this.Procedures.Insert(0, AllProcedures);
            this.Procedures.Insert(1, NoProcedure);
            this.ProcedureFilter = this.Procedures[0];

            ObservableCollection<String> sources = this.DicomImporterDataSource.GetWorkItemSources();
            this.Sources = new ObservableCollection<String>(sources);
            this.Sources.Insert(0, AllSources);
            this.SourceFilter = this.Sources[0];

            ObservableCollection<string> modalities = this.DicomImporterDataSource.GetWorkItemModalities();
            this.Modalities = new ObservableCollection<string>(modalities);
            this.Modalities.Insert(0, AllModalities);
            this.Modalities.Insert(1, NoModality);
            this.ModalityFilter = this.Modalities[0];
        }

        public void LoadUserPreferences(bool temp)
        {
            UserPreference pref = null;
            if (this.DicomImporterDataSource.LoadUserPreferences(out pref, temp))
            {
                ModalityFilter = string.IsNullOrEmpty(pref.Modality) ? AllModalities : pref.Modality;
                ProcedureFilter = string.IsNullOrEmpty(pref.Procedure) ? AllProcedures : pref.Procedure;
                ServiceFilter = string.IsNullOrEmpty(pref.Service) ? AllServices : pref.Service;
                SourceFilter = string.IsNullOrEmpty(pref.Source) ? AllSources : pref.Source;
                MaxRowSelected = string.IsNullOrEmpty(pref.MaxRows) ? this.MaxRows[0] : pref.MaxRows;
                NewerToOlder = string.IsNullOrEmpty(pref.RowOrder) ? true : pref.RowOrder.Equals("-1");
                PatientNameFilter = string.IsNullOrEmpty(pref.PatientName) ? string.Empty : pref.PatientName;
                DateTypeFilter = string.IsNullOrEmpty(pref.DateRangeType) ? "d0" : pref.DateRangeType;
                FromDateFilter = string.IsNullOrEmpty(pref.FromDate) ? DateTime.MinValue.ToString() : pref.FromDate;
                ToDateFilter = string.IsNullOrEmpty(pref.ToDate) ? DateTime.MaxValue.ToString() : pref.ToDate;

                if (string.IsNullOrEmpty(pref.WorkItemSubtype))
                {
                    WorkItemSubtypeFilter = ImporterWorkItemSubtype.AllSubtypes;
                }
                else
                {
                    if (ImporterWorkItemSubtype.AllSubtypes.Value.Equals(pref.WorkItemSubtype))
                    {
                        WorkItemSubtypeFilter = ImporterWorkItemSubtype.AllSubtypes;
                    }
                    else if (ImporterWorkItemSubtype.DicomCorrect.Value.Equals(pref.WorkItemSubtype))
                    {
                        WorkItemSubtypeFilter = ImporterWorkItemSubtype.DicomCorrect;
                    }
                    else if (ImporterWorkItemSubtype.DirectImport.Value.Equals(pref.WorkItemSubtype))
                    {
                        WorkItemSubtypeFilter = ImporterWorkItemSubtype.DirectImport;
                    }
                    else if (ImporterWorkItemSubtype.NetworkImport.Value.Equals(pref.WorkItemSubtype))
                    {
                        WorkItemSubtypeFilter = ImporterWorkItemSubtype.NetworkImport;
                    }
                    else if (ImporterWorkItemSubtype.StagedMedia.Value.Equals(pref.WorkItemSubtype))
                    {
                        WorkItemSubtypeFilter = ImporterWorkItemSubtype.StagedMedia;
                    }
                    else if (ImporterWorkItemSubtype.CommunityCare.Value.Equals(pref.WorkItemSubtype))
                    {
                        WorkItemSubtypeFilter = ImporterWorkItemSubtype.CommunityCare;
                    }
                }
            }
        }
        public void SaveUserPreferences(bool temp)
        {
            string pref = "MAXROWS=" + MaxRowSelected;
            if (!ModalityFilter.Equals(AllModalities))
            {
                pref += "^MODALITY=" + ModalityFilter;
            }
            if (!ProcedureFilter.Equals(AllProcedures))
            {
                pref += "^PROCEDURE=" + ProcedureFilter;
            }
            if (!ServiceFilter.Equals(AllServices))
            {
                pref += "^SERVICE=" + ServiceFilter;
            }
            if (!SourceFilter.Equals(AllSources))
            {
                pref += "^SOURCE=" + SourceFilter;
            }
            if (WorkItemSubtypeFilter != ImporterWorkItemSubtype.AllSubtypes)
            {
                pref += "^SUBTYPE=" + WorkItemSubtypeFilter.Value;
            }
            if (!string.IsNullOrEmpty(PatientNameFilter))
            {
                pref += "^PATNAME=" + PatientNameFilter;
            }

            pref += "^DATETYPE=" + (string.IsNullOrEmpty(DateTypeFilter) ? "d0" : DateTypeFilter);
            pref += "^FROMDATE=" + FromDateFilter;
            pref += "^TODATE=" + ToDateFilter;
            pref += "^ROWORDER=" + (NewerToOlder ? "-1" : "1");

            string errMsg = string.Empty;
            if (this.DicomImporterDataSource.SaveUserPreferences(pref, temp, out errMsg))
            {
                if (!temp)
                {
                    this.DialogService.ShowAlertBox(this.UIDispatcher,
                                        "Filters are successfully stored",
                                        "Save Filters", MessageTypes.Info);
                }
            }
            else
            {
                if (!temp)
                {
                    this.DialogService.ShowAlertBox(this.UIDispatcher,
                                    errMsg,
                                    "Save Filters Error", MessageTypes.Error);
                }
            }
        }

        private void FillMaxRows()
        {
            this.MaxRows = new ObservableCollection<string>();
            string maxNumberSelection = ConfigUtils.GetAppSetting("MaximumNumberSelection");
            if (string.IsNullOrEmpty(maxNumberSelection)) {
                maxNumberSelection = "50,100,500,1000,5000,All";
            }
            string[] maxRowsSelection = maxNumberSelection.Split(',');
            for (int i = 0; i < maxRowsSelection.Length; i++)
            {
                this.MaxRows.Add(maxRowsSelection[i]);
            }
            this.MaxRowSelected = this.MaxRows[0];
        }

        #endregion

        #region Private Properties
        private ImporterWorkItemSubtype _WorkItemSubtypeFilter { get; set; }
        private ObservableCollection<ImporterWorkItemSubtype> _WorkItemSubtypes { get; set; }
        private ObservableCollection<string> _Sources { get; set; }
        private ObservableCollection<string> _Services { get; set; }
        private ObservableCollection<string> _Modalities { get; set; }
        private ObservableCollection<string> _Procedures { get; set; }
        private ObservableCollection<string> _MaxRows { get; set; }

        private string _ServiceFilter;
        private string _ModalityFilter;
        private string _ProcedureFilter;
        private string _SourceFilter = string.Empty;
        private string _PatientNameFilter = string.Empty;
        private string _DateTypeFilter = "d1";
        private string _FromDateFilter = DateTime.MinValue.ToString();
        private string _ToDateFilter = DateTime.Today.ToString();

        private string _ProcessOrViewWorkItem;

        //These are used for performance purposes (use static data rather than retrieve the data from the back end)
        private ObservableCollection<ImporterWorkItem> _WorkItems = new ObservableCollection<ImporterWorkItem>();
        private static int processedWorkItem = -1;
        private string _TotalRows;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets ApplyFilterCommand.
        /// </summary>
        public DelegateCommand<object> ApplyFilterCommand { get; set; }

        /// <summary>
        /// Gets or sets GetMoreItemsCommand.
        /// </summary>
        public DelegateCommand<object> GetMoreItemsCommand { get; set; }

        /// <summary>
        /// Gets or sets DeleteImporterItem.
        /// </summary>
        public DelegateCommand<object> DeleteImportItemCommand { get; set; }

        /// <summary>
        /// Gets or sets NavigateToImporterHomeView.
        /// </summary>
        public DelegateCommand<object> NavigateToImporterHomeViewCommand { get; set; }

        /// <summary>
        /// Gets or sets NavigateToListView.
        /// </summary>
        public DelegateCommand<object> NavigateToListViewCommand { get; set; }


        /// <summary>
        /// Gets or sets ResetFilterCommand.
        /// </summary>
        public DelegateCommand<object> ResetFilterCommand { get; set; }

        /// <summary>
        /// Gets or sets SaveFilterCommand.
        /// </summary>
        public DelegateCommand<object> SaveFilterCommand { get; set; }

        /// <summary>
        /// Gets or sets UpdateServiceCommand.
        /// </summary>
        public DelegateCommand<object> UpdateServiceCommand { get; set; }

        /// <summary>
        /// Gets or sets SelectedWorkItem.
        /// </summary>
        public ImporterWorkItem SelectedWorkItem
        {
            get
            {
                return this.WorkItem;
            }

            set
            {
                this.WorkItem = value;
                this.NavigateToListViewCommand.RaiseCanExecuteChanged();
                this.DeleteImportItemCommand.RaiseCanExecuteChanged();
                this.UpdateServiceCommand.RaiseCanExecuteChanged();
                if (value != null)
                {
                    this.SelectedWorkItemKey = value.Key;
                    this.CurrentModalities = value.Modality;
                    UpdateProcessOrViewWorkItemCaption(ImporterWorkItemSubtype.GetImporterWorkItemSubtype(value.Subtype));
                }
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether ShowNewWorkItems.
        /// </summary>
        public bool ShowNewWorkItems { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether to retrieve items from newer to older
        /// </summary>
        public bool NewerToOlder
        {
            get
            {
                return this._NewerToOlder;
            }

            set
            {
                this._NewerToOlder = value;
                this._OlderToNewer = !value;
                //this.LastWorkItemProcessedId = 0;
                //this.MoreItemsExist = false;
                this.RaisePropertyChanged("NewerToOlder");
                this.RaisePropertyChanged("OlderToNewer");
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether to retrieve items from older to newer
        /// </summary>
        public bool OlderToNewer
        {
            get
            {
                return this._OlderToNewer;
            }

            set
            {
                this._OlderToNewer = value;
                this._NewerToOlder = !value;
                //this.LastWorkItemProcessedId = 0;
                //this.MoreItemsExist = false;
                this.RaisePropertyChanged("NewerToOlder");
                this.RaisePropertyChanged("OlderToNewer");
            }
        }

        /// <summary>
        /// Gets or sets SourceFilter.
        /// </summary>
        public string SourceFilter
        {
            get { return _SourceFilter; }
            set
            {
                _SourceFilter = value;
                this.RaisePropertyChanged("SourceFilter");
            }
        }

        /// <summary>
        /// Gets or sets PatientNameFilter.
        /// </summary>
        public string PatientNameFilter
        { 
            get { return _PatientNameFilter; }
            set
            {
                _PatientNameFilter = value;
                this.RaisePropertyChanged("PatientNameFilter");
            }
        }

        /// <summary>
        /// Gets or sets ServiceFilter.
        /// </summary>
        public string ServiceFilter
        {
            get { return _ServiceFilter; }
            set
            {
                _ServiceFilter = value;
                this.RaisePropertyChanged("ServiceFilter");
            }
        }

        /// <summary>
        /// Gets or sets ModalityFilter.
        /// </summary>
        public string ModalityFilter
        {
            get { return _ModalityFilter; }
            set
            {
                _ModalityFilter = value;
                this.RaisePropertyChanged("ModalityFilter");
            }
        }

        /// <summary>
        /// Gets or sets ProcedureFilter.
        /// </summary>
        public string ProcedureFilter
        {
            get { return _ProcedureFilter; }
            set
            {
                _ProcedureFilter = value;
                this.RaisePropertyChanged("ProcedureFilter");
            }
        }

        public string DateTypeFilter
        {
            get { 
                return _DateTypeFilter; 
            }
            set
            {
                _DateTypeFilter = value;
                this.RaisePropertyChanged("DateTypeFilter");
            }
        }

        public string FromDateFilter
        {
            get
            {
                return _FromDateFilter;
            }
            set
            {
                _FromDateFilter = value;
                this.RaisePropertyChanged("FromDateFilter");
            }
        }

        public string ToDateFilter
        {
            get
            {
                return _ToDateFilter;
            }
            set
            {
                _ToDateFilter = value;
                this.RaisePropertyChanged("ToDateFilter");
            }
        }

        /// <summary>
        /// Gets or sets MaxRowSelected.
        /// </summary>
        public string MaxRowSelected { get; set; }

        //BEGIN-OITCOPondiS-P289-Get and set property binding and notification  due to removal of NotifyPropertyWeaverMsBuildTask.dll
        //Commenting below code and add new instead to avoid dropdown showing empty list
        //public ObservableCollection<string> Sources { get; set; }
        public ObservableCollection<string> Sources
        {
            get { return _Sources; }
            set
            {
                _Sources = value;
                this.RaisePropertyChanged("Sources");
            }
        }

        public ObservableCollection<string> Services
        {
            get { return _Services; }
            set
            {
                _Services = value;
                this.RaisePropertyChanged("Services");
            }
        }

        public ObservableCollection<string> Modalities
        {
            get { return _Modalities; }
            set
            {
                _Modalities = value;
                //this.CurrentModalities = value;
                this.RaisePropertyChanged("Modalities");
            }
        }

        public ObservableCollection<string> Procedures
        {
            get { return _Procedures; }
            set
            {
                _Procedures = value;
                this.RaisePropertyChanged("Procedures");
            }
        }

        public ObservableCollection<string> MaxRows
        {
            get { return _MaxRows; }
            set
            {
                _MaxRows = value;
                this.RaisePropertyChanged("MaxRows");
            }
        }
        //END-OITCOPondiS-P289



        //BEGIN-OITCOPondiS-P289-Get and set property binding and notification  due to removal of NotifyPropertyWeaverMsBuildTask.dll
        //Get and Set  property notification for all public fields-OITCOPondiS
        /// <summary>
        /// Gets or sets WorkItemSubtypeFilter.
        /// </summary>
        //public ImporterWorkItemSubtype WorkItemSubtypeFilter { get; set; }
        public ImporterWorkItemSubtype WorkItemSubtypeFilter
        {
            get { return _WorkItemSubtypeFilter; }
            set
            {
                _WorkItemSubtypeFilter = value;
                this.RaisePropertyChanged("WorkItemSubtypeFilter");
                UpdateProcessOrViewWorkItemCaption(value);
            }
        }

        private void UpdateProcessOrViewWorkItemCaption(ImporterWorkItemSubtype value)
        {
            //if (value == ImporterWorkItemSubtype.CommunityCare)
            //{
            //    ProcessOrViewWorkItem = "View Import Item";
            //}
            //else
            //{
                ProcessOrViewWorkItem = "Process Import Item";
            //}
        }

        public string ProcessOrViewWorkItem
        {
            get
            {
                return this._ProcessOrViewWorkItem;
            }

            set
            {
                this._ProcessOrViewWorkItem = value;
                this.RaisePropertyChanged("ProcessOrViewWorkItem");
            }
        }


        /// <summary>
        /// Gets or sets WorkItemSubtypes.
        /// </summary>
        //public ObservableCollection<ImporterWorkItemSubtype> WorkItemSubtypes { get; set; }
        public ObservableCollection<ImporterWorkItemSubtype> WorkItemSubtypes
        {
            get { return _WorkItemSubtypes; }
            set
            {
                _WorkItemSubtypes = value;
                this.RaisePropertyChanged("WorkItemSubtypes");
            }
        }

        /// <summary>
        /// Gets or sets WorkItems.
        /// </summary>
        public ObservableCollection<ImporterWorkItem> WorkItems
        {
            get { return _WorkItems; }
            set
            {
                _WorkItems = value;
                this.RaisePropertyChanged("WorkItems");
                this.TotalRows = WorkItems.Count.ToString();
                this.RaisePropertyChanged("TotalRows");
            }
        }

        public string TotalRows
        {
            get { return _TotalRows; }
            set
            {
                _TotalRows = "Total Rows: " + value;
            }
        }

        //END-OITCOPondiS-P289-Get and set property binding and notification  due to removal of NotifyPropertyWeaverMsBuildTask.dll

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

            try
            {
                // Display an informational message if the user is logged in as a CSRA
                if (HasContractedStudiesKey && !HasAdministratorKey)
                {
                    this.AddMessage(MessageTypes.Warning, LoggedInAsCSRAMessage);
                }

                var filter = new ImporterWorkItemFilter { Status = ImporterWorkItemStatuses.New };

                this.AddFeeOriginFilterIfNecessary(filter);

                this.WorkItemSubtypes = ImporterWorkItemSubtype.GetAllSubtypes();
                this.WorkItemSubtypeFilter = this.WorkItemSubtypes[0];
                
                this.LoadUserPreferences(!this.IsFirstWorkListLoading);

                this.ShowNewWorkItems = true;

                this.ApplyFilter();

                if (this.WorkItems == null || this.WorkItems.Count == 0)
                {
                    this.AddMessage(MessageTypes.Info, NoItemsAvailableMessage);
                }

            }
            catch (Exception e)
            {
                var window = new ExceptionWindow(e);
                window.SubscribeToNewUserLogin();
                window.ShowDialog();
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Navigates to either the Study List or Non-Dicom List view.
        /// </summary>
        private void NavigateToListView()
        {
            string originalStatus = this.SelectedWorkItem.Status;

            // Try to transition the work item if possible
            try
            {
                // Using the id, get the full workItem and transition it to InReconciliation
                this.WorkItem = this.DicomImporterDataSource.GetAndTranstionImporterWorkItem(
                    this.SelectedWorkItem, this.SelectedWorkItem.Status, ImporterWorkItemStatuses.InReconciliation);
            }
            catch (ServerException se)
            {
                // Handle the server exception and then return. Note that if it's not one of the know exceptions we handle, 
                // the exception will be rethrown, to be handled by the general exception handler
                this.HandleServerException(se);
                return;
            }

            // If we get here and neither the work item or the work item details are null, we're successful. Continue on.
            // Otherwise, warn the user that the work item couldn't be retrieved, try to restore the status of the work item,
            // and don't continue to the details.
            if (this.WorkItem != null && this.WorkItem.WorkItemDetails != null)
            {
                // The work item was found and transitioned, so continue
                this.WorkItem.OriginalStatus = originalStatus;

                // Cache the workItem
                ImporterWorkItemCache.Add(this.WorkItem);

                this.MediaCategory = this.WorkItem.MediaCategory;

                // navigates to the appopriate media category view
                switch (this.MediaCategory.Category)
                {
                    case MediaCategories.DICOM:
                    case MediaCategories.Mixed:
                        processedWorkItem = this.WorkItem.Id; //work item to be removed the next grid loading
                        this.SaveUserPreferences(true);
                        this.NavigateMediaCategoryAndWorkItem(ImporterViewNames.StudyListView); 
                        break;

                    case MediaCategories.NonDICOM:
                        processedWorkItem = this.WorkItem.Id; //work item to be removed the next grid loading
                        this.SaveUserPreferences(true);
                        this.NavigateMediaCategoryAndWorkItem(ImporterViewNames.NonDicomListView);
                        break;

                    default:
                        this.DialogService.ShowAlertBox(this.UIDispatcher, 
                                                        "Unable to process work item. This work item has an invalid media type.", 
                                                        "Invalid Media Type", MessageTypes.Warning);
                        this.NavigateMainRegionTo(ImporterViewNames.WorkListView + "?IsFirstWorkListLoading=false");
                        break;
                }

            }
            else
            {
                // Attempt to restore the work item to its original status.
                try
                {
                    this.DicomImporterDataSource.UpdateWorkItem(this.SelectedWorkItem, ImporterWorkItemStatuses.InReconciliation, originalStatus);
                }
                catch (Exception e)
                {
                    Logger.Error("Error restoring work item to it's original status", e);
                    // Reload the work items
                }

                // Display a message to the user indicating the failed retrieval
                string message = "The selected work item was not able to be retrieved successfully. This could be due to a temporary\n"
                    + "network issue, or a corrupted work item.\n\n If the problem persists, please contact an adminstrator.";
                string caption = "Error Retrieving Work Item";

                DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);

                // Reload the work items
                this.ApplyFilter();
            }
        }

        //private void RemoveProcessedWorkItemFromGrid()
        //{
        //    if (processedWorkItem > -1)
        //    { 
        //        IEnumerable<ImporterWorkItem> workItems =
        //            from workItem in this.WorkItems
        //            where
        //                workItem.Id == processedWorkItem
        //            select workItem;

        //        if (workItems != null)
        //        {
        //            if (workItems.ToList().Count > 0)
        //            {
        //                ImporterWorkItem workItemToRemove = workItems.First<ImporterWorkItem>();
        //                this.WorkItems.Remove(workItemToRemove);
        //            }
        //        }
        //        processedWorkItem = -1;
        //    }

        //}

        /// <summary>
        /// Deletes the importer item.
        /// </summary>
        private void DeleteImportItem()
        {
            try
            {
                if (DeleteImporterWorkItem(SelectedWorkItem))
                {
                    // Refresh the list
                    //this.ApplyFilter();
                    this.WorkItems.Remove(SelectedWorkItem);
                }
            }
            catch (ServerException se)
            {
                this.HandleServerException(se);
            }
        }

        /// <summary>
        /// Handles the server exception.
        /// </summary>
        /// <param name="se">The se.</param>
        private void HandleServerException(ServerException se)
        {
            // Check for "expected" exceptions and handle them. Rethrow on unexpected ones...
            if (se.ErrorCode == ImporterErrorCodes.WorkItemNotFoundErrorCode)
            {
                this.DialogService.ShowAlertBox(
                    this.UIDispatcher, WorkItemNotFoundErrorMessage, WorkItemNotFoundErrorCaption, MessageTypes.Error);
            }
            else if (se.ErrorCode == ImporterErrorCodes.InvalidWorkItemStatusErrorCode)
            {
                string message = se.Message;
                this.DialogService.ShowAlertBox(
                    this.UIDispatcher, message, WorkItemInInvalidStateCaption, MessageTypes.Error);
            }
            else
            {
                // Rethrow the error up to the general exception handler
                throw se;
            }

            // Reload the work items
            this.ApplyFilter();
        }

        /// <summary>
        /// The add fee origin filter if necessary.
        /// </summary>
        /// <param name="filter">
        /// The filter.
        /// </param>
        private void AddFeeOriginFilterIfNecessary(ImporterWorkItemFilter filter)
        {
            // If they are a contracted studies user and NOT and adminstrator, only show them FEE stuff.
            if (this.HasContractedStudiesKey && !this.HasAdministratorKey)
            {
                filter.OriginIndex = "F";
            }
        }

        /// <summary>
        /// The apply filter.
        /// </summary>
        private void ApplyFilter()
        {
            var filter = new ImporterWorkItemFilter { Status = ImporterWorkItemStatuses.New };
            
            this.RemoveMessage(NoItemsAvailableMessage);
            this.RemoveMessage(NoSearchItemsFoundMessage);

            // Get the source if something specific is selected
            if (this.SourceFilter != null && this.SourceFilter != AllSources)
            {
                filter.Source = this.SourceFilter;
            }

            // Get the service if something specific is selected
            if (!this.ServiceFilter.Equals(AllServices))
            {
                filter.Service = String.IsNullOrEmpty(this.ServiceFilter) ? String.Empty : this.ServiceFilter;
            }

            // Get the modality if something specific is selected
            if (!this.ModalityFilter.Equals(AllModalities))
            {
                filter.Modality = String.IsNullOrEmpty(this.ModalityFilter) ? String.Empty : this.ModalityFilter;
            }

            // Get the procedure if something specific is selected
            if (!this.ProcedureFilter.Equals(AllProcedures))
            {
                filter.Procedure = String.IsNullOrEmpty(this.ProcedureFilter) ? String.Empty : this.ProcedureFilter;
            }

            // Get the subtype if something is selected
            if (this.WorkItemSubtypeFilter != null && this.WorkItemSubtypeFilter != ImporterWorkItemSubtype.AllSubtypes)
            {
                filter.Subtype = this.WorkItemSubtypeFilter.Code;
            }

            // Sets the user selection of new work items or processed but some remaining to the status
            filter.Status = this.ShowNewWorkItems
                                ? ImporterWorkItemStatuses.New
                                : ImporterWorkItemStatuses.ImportComplete;

            filter.PatientName = this.PatientNameFilter;

            this.SetDateRangeFilter(filter,this.DateTypeFilter, this.FromDateFilter, this.ToDateFilter);

            // Add the fee origin filter if necessary
            this.AddFeeOriginFilterIfNecessary(filter);
            
            this.LoadWorkItems(filter);

            if (this.WorkItems == null || this.WorkItems.Count == 0)
            {
                this.AddMessage(MessageTypes.Warning, NoSearchItemsFoundMessage);
            }

            //this.PerformPatientFilter();

            //this.MoreItemsExist = this.LastWorkItemProcessedId > 0;
            //this.RaisePropertyChanged("MoreItemsExist");

        }


        private void LoadWorkItems(ImporterWorkItemFilter filter)
        {
            filter.RetrievalOrder = _NewerToOlder ? "-1" : "1";
            filter.LastIenProcessed = "0";

            bool allBatches = false;

            if (this.MaxRowSelected.Equals("All"))
            {
                allBatches = true;
                filter.MaximumNumberOfItemsToReturn = ConfigUtils.GetAppSetting("MaximumNumberOfItemsToReturn");
                if (string.IsNullOrEmpty(filter.MaximumNumberOfItemsToReturn))
                {
                    filter.MaximumNumberOfItemsToReturn = this.MaxRows[this.MaxRows.Count - 2];
                }
            }
            else
            {
                filter.MaximumNumberOfItemsToReturn = this.MaxRowSelected;
                //if (string.IsNullOrEmpty(filter.MaximumNumberOfItemsToReturn))
                //{
                //    filter.MaximumNumberOfItemsToReturn = this.MaxRowSelected;
                //}
                //else
                //{
                //    if (int.Parse(filter.MaximumNumberOfItemsToReturn) < int.Parse(this.MaxRowSelected))
                //    {
                //        filter.MaximumNumberOfItemsToReturn = this.MaxRowSelected;
                //    }
                //}
            }

            /*
               P346 - Gary Pham (oitlonphamg)
               Provides a responsive UI dialog while processing vix restapi call.
            */
            //Begin P346
            this.WorkItems.Clear();
            List<object> listParameter = new List<object> { 
                this, 
                filter, 
                this.WorkItems, 
                m_dlgServiceImporter, 
                allBatches,
                null};

            BackgroundWorker threadGetWorkItemList = new BackgroundWorker();
            threadGetWorkItemList.DoWork += new DoWorkEventHandler(GetWorkItemListThread);
            threadGetWorkItemList.RunWorkerCompleted += new RunWorkerCompletedEventHandler(GetWorkItemListThreadCompleted);
            threadGetWorkItemList.RunWorkerAsync(listParameter);
            //threadGetWorkItemList.RunWorkerAsync(null);
            m_dlgServiceImporter.ShowDialog();
            //End P346

        }

        /// P346 - Gary Pham (oitlonphamg)
        /// Thread GetWorkItemList.
        /// </summary>
        //Being P346
        private void GetWorkItemListThread(object sender, DoWorkEventArgs e)
        {
            if (e.Argument != null && ((List<object>)e.Argument).Count == 6)
            {
                try
                {
                    var viewModel = (WorkListViewModel)((List<object>)e.Argument)[0];
                    var filter = (ImporterWorkItemFilter)((List<object>)e.Argument)[1];
                    var allWorkItems = new List<ImporterWorkItem>();
                    var allBatches = (bool)((List<object>)e.Argument)[4];

                    bool nextBatch = true;
                    while (nextBatch)
                    {
                        nextBatch = false;
                        ObservableCollection<ImporterWorkItem> workItems =
                            viewModel.DicomImporterDataSource.GetWorkItemList(filter);
                        foreach (ImporterWorkItem item in workItems)
                        {
                            allWorkItems.Add(item);
                            if (item.LastIenFlag == "*")
                            {
                                nextBatch = true;
                                filter.LastIenProcessed = item.Id.ToString();
                            }
                        }
                        if (!allBatches)
                        {
                            break;
                        }
                    }

                    ((List<object>)e.Argument)[2] = new ObservableCollection<ImporterWorkItem>(allWorkItems);
                }
                catch (Exception exception)
                {
                    ((List<object>)e.Argument)[5] = exception;
                }
                e.Result = e.Argument;
            }
        }
        //End P346

        /// <summary>
        /// P346 - Gary Pham (oitlonphamg)
        /// Callback function on completion of thread GetWorkItemListThread.
        /// </summary>
        //Being P346
        private void GetWorkItemListThreadCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            ((IDialogServiceImporter)((List<object>)e.Result)[3]).CloseDialog();
            this.WorkItems = (ObservableCollection<ImporterWorkItem>)((List<object>)e.Result)[2];
        }
        //End P346


        private void ClearLastIenFlag()
        {
            IEnumerable<ImporterWorkItem> lastWorkItem =
                from workItem in this.WorkItems
                where
                    workItem.LastIenFlag == "*"
                select workItem;

            if (lastWorkItem != null)
            {
                if (lastWorkItem.ToList().Count > 0)
                {
                    lastWorkItem.First<ImporterWorkItem>().LastIenFlag = string.Empty;
                }
            }
        }


        /// <summary>
        /// Gets and binds the sources.
        /// </summary>
        /// <param name="filter">The filter.</param>
        //private void GetAndBindSources(ImporterWorkItemFilter filter)
        //{
        //    var allEligibleWorkItems = new ObservableCollection<ImporterWorkItem>(this.WorkItems);

        //    // Get the completed work items
        //    filter.Status = ImporterWorkItemStatuses.ImportComplete;
        //    // Retrieval Order (Newer To Older or Older To Newer)
        //    filter.RetrievalOrder = _NewerToOlder ? "-1" : "1";
        //    filter.LastIenProcessed = "0";
        //    ObservableCollection<ImporterWorkItem> completedWorkItems =
        //        this.DicomImporterDataSource.GetWorkItemList(filter);

        //    //this.MoreItemsExist = false;
        //    //this.LastWorkItemProcessedId = 0;

        //    List<string> lstSource = new List<String>();
        //    List<string> lstService = new List<String>();
        //    List<string> lstModality = new List<String>();
        //    List<string> lstProcedure = new List<String>();

        //    foreach (ImporterWorkItem item in completedWorkItems)
        //    {
        //        allEligibleWorkItems.Add(item);
        //    }

        //    // Populate the filter dropdowns from current collection of workitems
        //    foreach (ImporterWorkItem item in allEligibleWorkItems)
        //    {
        //        lstSource.Add(item.Source);

        //        if (!String.IsNullOrEmpty(item.Service) && (lstService.IndexOf(item.Service) < 0))
        //        {
        //            lstService.Add(item.Service);
        //        }
        //        if (!String.IsNullOrEmpty(item.Modality) && (lstModality.IndexOf(item.Modality) < 0))
        //        {
        //            lstModality.Add(item.Modality);
        //        }
        //        if (!String.IsNullOrEmpty(item.Procedure) && (lstProcedure.IndexOf(item.Procedure) < 0))
        //        {
        //            lstProcedure.Add(item.Procedure);
        //        }

        //        //if (!string.IsNullOrEmpty(item.LastIenFlag) && item.LastIenFlag.Equals("*"))
        //        //{
        //        //    this.LastWorkItemProcessedId = item.Id;
        //        //    this.MoreItemsExist = true;
        //        //}
        //    }

        //    this.WorkItems = allEligibleWorkItems;

        //    //IEnumerable<string> sources =
        //    //    (from workItem in allEligibleWorkItems select workItem.Source).Distinct().OrderBy(x => x);

        //    this.Sources = new ObservableCollection<string>(lstSource);
        //    this.Sources.Insert(0, AllSources);
        //    this.SourceFilter = this.Sources[0];

        //    //IEnumerable<string> services =
        //    //    (from workItem in allEligibleWorkItems
        //    //     where !String.IsNullOrEmpty(workItem.Service)
        //    //     select workItem.Service).Distinct().OrderBy(x => x);

        //    this.Services = new ObservableCollection<string>(lstService);
        //    this.Services.Insert(0, AllServices);
        //    this.Services.Insert(1, NoService);
        //    this.ServiceFilter = this.Services[0];

        //    //IEnumerable<string> Modalities =
        //    //    (from workItem in allEligibleWorkItems
        //    //     where !String.IsNullOrEmpty(workItem.Modality)
        //    //     select workItem.Modality).Distinct().OrderBy(x => x);

        //    this.Modalities = new ObservableCollection<string>(lstModality);
        //    this.Modalities.Insert(0, AllModalities) ;
        //    this.Modalities.Insert(1, NoModality);
        //    this.ModalityFilter = this.Modalities[0];

        //    //IEnumerable<string> procedures =
        //    //    (from workItem in allEligibleWorkItems
        //    //     where !String.IsNullOrEmpty(workItem.Procedure)
        //    //     select workItem.Procedure).Distinct().OrderBy(x => x);

        //    this.Procedures = new ObservableCollection<string>(lstProcedure);
        //    this.Procedures.Insert(0, AllProcedures);
        //    this.Procedures.Insert(1, NoProcedure);
        //    this.ProcedureFilter = this.Procedures[0];
        //}

        /// <summary>
        /// The perform patient filter.
        /// </summary>
        //private void PerformPatientFilter()
        //{
        //    if (string.IsNullOrEmpty(this.PatientNameFilter)) {
        //        return;
        //    }
        //    this.PatientNameFilter += string.Empty;

        //    List<ImporterWorkItem> filteredItems = new List<ImporterWorkItem>();
        //    foreach (ImporterWorkItem item in this.WorkItems)
        //    {
        //        if (item.PatientName.ToUpper().Contains(
        //                            this.PatientNameFilter.ToUpper()))
        //        {
        //            filteredItems.Add(item);
        //        }
        //    }
        //    this.WorkItems = new ObservableCollection<ImporterWorkItem>(filteredItems);

        //    // Do the patient name filter
        //    //IEnumerable<ImporterWorkItem> filteredItems = from workItem in this.WorkItems
        //    //                                          where
        //    //                                              workItem.PatientName.ToUpper().Contains(
        //    //                                                  this.PatientNameFilter.ToUpper())
        //    //                                          select workItem;

        //}

        /// <summary>
        /// The reset filter.
        /// </summary>
        private void ResetFilter()
        {
            //this.NavigateMainRegionTo(ImporterViewNames.WorkListView);
            this.LoadUserPreferences(false);
            this.ApplyFilter();
        }

        /// <summary>
        /// The Save filter.
        /// </summary>
        private void SaveFilter()
        {
            this.SaveUserPreferences(false);
        }

        /// <summary>
        /// The reset filter.
        /// </summary>
        private void UpdateService()
        {
            try
            {
                string service = string.Empty;
                string errMsg = string.Empty;
                if (UpdateWorkItemService(this.SelectedWorkItem, out service, out errMsg))
                {
                    this.ApplyFilter();
                }
                else
                {
                    if (!string.IsNullOrEmpty(errMsg))
                    {
                        this.DialogService.ShowAlertBox(this.UIDispatcher,
                                errMsg,
                                "Update Service Error", MessageTypes.Error);
                    }
                }
            }
            catch (ServerException se)
            {
                this.HandleServerException(se);
            }
        }

        private void SetDateRangeFilter (ImporterWorkItemFilter filter, 
            string dateType, string fromDateFilter, string toDateFilter)
        {
            DateTime toDay = DateTime.Today;
            DateTime thisWeekBegin = DateTime.Today.AddDays(-(int)toDay.DayOfWeek);

            switch (dateType)
            {
                case "d0":
                    filter.FromDate = fromDateFilter;
                    filter.ToDate = toDateFilter;
                    break;
                case "d1":
                    filter.FromDate = toDay.ToString();
                    filter.ToDate = toDay.ToString();
                    break;
                case "d2":
                    //Yesterday
                    filter.FromDate = toDay.AddDays(-1).ToString();
                    filter.ToDate = toDay.AddDays(-1).ToString();
                    break;
                case "d3":
                    //2 days ago
                    filter.FromDate = toDay.AddDays(-2).ToString();
                    filter.ToDate = toDay.AddDays(-2).ToString();
                    break;
                case "d4":
                    //3 days ago
                    filter.FromDate = toDay.AddDays(-3).ToString();
                    filter.ToDate = toDay.AddDays(-3).ToString();
                    break;
                case "d5":
                    //last 2 days
                    filter.FromDate = toDay.AddDays(-1).ToString();
                    filter.ToDate = toDay.ToString();
                    break;
                case "d6":
                    //last 3 days
                    filter.FromDate = toDay.AddDays(-2).ToString();
                    filter.ToDate = toDay.ToString();
                    break;
                case "d7":
                    //last full week
                    filter.FromDate = thisWeekBegin.AddDays(-7).ToString();
                    filter.ToDate = thisWeekBegin.AddSeconds(-1).ToString();
                    break;
                case "d8":
                    //current week
                    filter.FromDate = thisWeekBegin.ToString();
                    filter.ToDate = thisWeekBegin.AddDays(7).AddSeconds(-1).ToString();
                    break;
                default:
                    break;
            }

            filter.FromDate = FMDate(filter.FromDate);
            filter.ToDate = FMDate(filter.ToDate);
        }

        private string FMDate(string dt)
        {
            var parsedDate = DateTime.Parse(dt);
            string stDt = parsedDate.ToString("yyyyMMdd");
            int fm = Int32.Parse(stDt) - 17000000;
            return fm.ToString();
        }

        #endregion

        //#region Select Service Window

        //private ObservableCollection<string> servicesSource = new ObservableCollection<string>();

        //public ObservableCollection<string> ServicesSource
        //{
        //    get { 
        //        return servicesSource; 
        //    }
        //    set
        //    {
        //        servicesSource = value;
        //        this.RaisePropertyChanged("ServicesSource");
        //    }
        //}

        ///// <summary>
        ///// Gets or sets SelectedService
        ///// </summary>
        //public string SelectedService { get; set; }

        //#endregion
    }
}