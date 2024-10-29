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
    using System.Text;

    using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.Views;

    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Exceptions;
    using ImagingClient.Infrastructure.Views;

    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The admin revert work item view model.
    /// </summary>
    public class AdminRevertWorkItemViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The no items in reconciliation message.
        /// </summary>
        private const string NoItemsInReconciliationMessage = "No Importer items are currently in reconciliation.";

        /// <summary>
        /// The instruction text.
        /// </summary>
        private string instructionText = string.Empty;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="AdminRevertWorkItemViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public AdminRevertWorkItemViewModel(
            IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;

            // Navigate to the Study List view, passing in the workitem key
            this.RevertWorkItem = new DelegateCommand<object>(
                o =>
                    {
                        this.ClearMessages();

                        // Try to transition the work item if possible
                        try
                        {
                            // Get the full item but don't transition it yet, so we can delete reconciliations...
                            this.WorkItem =
                                this.DicomImporterDataSource.GetAndTranstionImporterWorkItem(
                                    this.SelectedWorkItem, 
                                    ImporterWorkItemStatuses.InReconciliation, 
                                    ImporterWorkItemStatuses.InReconciliation);

                            // Clear any existing Reconciliations out of the WorkItem
                            this.WorkItem.WorkItemDetails.Reconciliations = new ObservableCollection<Reconciliation>();

                            // Now revert it back to New
                            this.WorkItem =
                                this.DicomImporterDataSource.GetAndTranstionImporterWorkItem(
                                    this.SelectedWorkItem, 
                                    ImporterWorkItemStatuses.InReconciliation, 
                                    ImporterWorkItemStatuses.New);
                        }
                        catch (ServerException se)
                        {
                            // Check for "expected" exceptions and handle them. Rethrow on unexpected ones...
                            if (se.ErrorCode == ImporterErrorCodes.WorkItemNotFoundErrorCode)
                            {
                                this.AddMessage(MessageTypes.Error, WorkItemNotFoundErrorMessage); 
                            }
                            else if (se.ErrorCode == ImporterErrorCodes.InvalidWorkItemStatusErrorCode)
                            {
                                this.AddMessage(MessageTypes.Error, se.Message);
                            }
                            else
                            {
                                // Just rethrow it up to the general exception handler
                                throw;
                            }
                        }

                        // Refresh the list
                        this.LoadWorkItems();
                    }, 
                o => (this.SelectedWorkItem != null));

            this.NavigateToAdministrationHomeView =
                new DelegateCommand<object>(
                    o => this.NavigateMainRegionTo(ImporterViewNames.AdministrationHomeView), o => this.HasAdministratorKey);
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets InstructionText.
        /// </summary>
        public string InstructionText
        {
            get
            {
                if (this.instructionText.Equals(string.Empty))
                {
                    var builder = new StringBuilder();
                    builder.Append(
                        "NOTE: This list contains ALL Importer Items currently in reconciliation, even those ");
                    builder.Append("that are not 'stuck'. Please carefully identify the appropriate item to revert ");

                    this.instructionText = builder.ToString();
                }

                return this.instructionText;
            }

            set
            {
                this.instructionText = value;
            }
        }

        /// <summary>
        /// Gets or sets NavigateToAdministrationHomeView.
        /// </summary>
        public DelegateCommand<object> NavigateToAdministrationHomeView { get; set; }

        /// <summary>
        /// Gets or sets RevertWorkItem.
        /// </summary>
        public DelegateCommand<object> RevertWorkItem { get; set; }

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
                this.RevertWorkItem.RaiseCanExecuteChanged();
            }
        }




        //Commented since binding element {NotifyPropertyWeaverMsBuildTask} is no longer available in VS 2015 and above versions. (p289-OITCOPondiS)  
        ///// <summary>
        ///// Gets or sets WorkItems.
        ///// </summary>
        //public ObservableCollection<ImporterWorkItem> WorkItems { get; set; }

        //BEGIN-Modified WorkItems property to bind control. Earlier binding made through imlementing library {NotifyPropertyWeaverMsBuildTask}.(p289-OITCOPondiS)  
        private ObservableCollection<ImporterWorkItem> _WorkItems { get; set; }

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
            }
        }
        //END 

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

            this.LoadWorkItems();
        }

        #endregion

        #region Methods

        /// <summary>
        /// The load work items.
        /// </summary>
        private void LoadWorkItems()
        {
            this.RemoveMessage(NoItemsInReconciliationMessage);

            var filter = new ImporterWorkItemFilter { Status = ImporterWorkItemStatuses.InReconciliation };

            try
            {
                this.WorkItems = this.DicomImporterDataSource.GetWorkItemList(filter);
            }
            catch (Exception ex)
            {
                var window = new ExceptionWindow(ex);
                window.SubscribeToNewUserLogin();
                window.ShowDialog();
            }

            if (this.WorkItems == null || this.WorkItems.Count == 0)
            {
                this.AddMessage(MessageTypes.Info, NoItemsInReconciliationMessage);
            }
        }

        #endregion
    }
}