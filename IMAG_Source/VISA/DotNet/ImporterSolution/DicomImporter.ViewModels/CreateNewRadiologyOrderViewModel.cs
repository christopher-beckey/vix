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
    using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;
    using DicomImporter.Common.Views;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Exceptions;
    using ImagingClient.Infrastructure.Views;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;
    using System.Windows;

    /// <summary>
    /// The create new radiology order view model.
    /// </summary>
    public class CreateNewRadiologyOrderViewModel : ImporterReconciliationViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The cached ordering location.
        /// </summary>
        private static OrderingLocation cachedOrderingLocation;

        /// <summary>
        /// The cached ordering provider.
        /// </summary>
        private static OrderingProvider cachedOrderingProvider;

        /// <summary>
        /// The no procedures caption
        /// </summary>
        private const string NoProceduresCaption = "No Procedures Available";

        /// <summary>
        /// The no procedures message
        /// </summary>
        private const string NoProceduresMessage = "The selected Imaging Location does not have any procedures. " +
                                                   " Please select another Imaging Location or have an Administrator " + 
                                                   " add procedures to the location.";

        private const string OrderingLocationMessage = "Please select an ordering location.";
        private const string OrderingProviderMessage = "Please select an ordering provider.";
        private const string ProcedureMessage = "Please select a procedure.";

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="CreateNewRadiologyOrderViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public CreateNewRadiologyOrderViewModel(
            IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;

            this.DisplayExistingOrderControls = true;

            this.NavigateForward = new DelegateCommand<object>(
                o =>
                {
                    if (this.CurrentReconciliation.Order == null)
                    {
                        string message = "You must select or create an order before proceeding.";
                        string caption = "No Order Selected or Created";
                        this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);
                    }
                    else
                    {
                        UpdateWorkItemFilters();

                        if (IsDicomWorkItem)
                        {
                            this.NavigateWorkItem(ImporterViewNames.AddNonDicomFilesToReconciliationView);
                        }
                        else
                        {
                            this.NavigateWorkItem(ImporterViewNames.ConfirmationView);
                        }
                    }
                },
                o => this.ValidateForm());

            this.NavigateBack =
                new DelegateCommand<object>(
                    o =>
                        {
                            if (this.HasAdministratorKey)
                            {
                                this.NavigateWorkItem(ImporterViewNames.SelectOrderTypeView);
                            }
                            else
                            {
                                if (IsDicomWorkItem)
                                {
                                    this.NavigateWorkItem(ImporterViewNames.PatientSelectionView);
                                }
                                else
                                {
                                    this.NavigateWorkItem(ImporterViewNames.NonDicomListView);
                                }

                            }
                        });

            this.CancelReconciliationCommand = new DelegateCommand<object>(
                o => this.CancelReconciliation());
        }

        private void UpdateWorkItemFilters()
        {
            if (this.CurrentStudy != null)
            {
                if (this.CurrentStudy.Procedure != null)
                {
                    this.WorkItem.Procedure = this.CurrentStudy.Procedure;
                }
                if (this.CurrentStudy.ModalityCodes != null)
                {
                    this.WorkItem.Modality = this.CurrentStudy.ModalityCodes;
                }
            }
        }

        #endregion

        #region Delegates

        /// <summary>
        /// The initialize procedure modifiers event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public delegate void InitializeProcedureModifiersEventHandler(object sender, EventArgs e);

        /// <summary>
        /// The refresh selected procedure modifiers event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public delegate void RefreshSelectedProcedureModifiersEventHandler(object sender, EventArgs e);

        #endregion

        #region Public Events

        /// <summary>
        /// The initialize procedure modifiers.
        /// </summary>
        public event InitializeProcedureModifiersEventHandler InitializeProcedureModifiers;

        /// <summary>
        /// The refresh selected procedure modifiers.
        /// </summary>
        public event RefreshSelectedProcedureModifiersEventHandler RefreshSelectedProcedureModifiers;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets a value indicating whether AnyProcedureModifiersAvailable.
        /// </summary>
        public bool AnyProcedureModifiersAvailable
        {
            get
            {
                Order order = this.CurrentReconciliation.Order;
                if (order != null && order.IsToBeCreated)
                {
                    if (order.ProcedureModifiers != null &&
                        order.ProcedureModifiers.Count > 0)
                    {
                        return true;
                    }

                    if (order.Procedure != null &&
                        order.Procedure.ProcedureModifiers != null &&
                        order.Procedure.ProcedureModifiers.Count > 0)
                    {
                        return true;
                    }
                }

                return false;
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether DisplayExistingOrderControls.
        /// </summary>
        public bool DisplayExistingOrderControls { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether DisplayOrderCreationControls.
        /// </summary>
        public bool DisplayOrderCreationControls { get; set; }

        /// <summary>
        /// Gets or sets NavigateBack.
        /// </summary>
        public DelegateCommand<object> NavigateBack { get; set; }

        /// <summary>
        /// Gets or sets NavigateForward.
        /// </summary>
        public DelegateCommand<object> NavigateForward { get; set; }

        /// <summary>
        /// Gets or sets ProcedureModifiers.
        /// </summary>
        public ObservableCollection<ProcedureModifier> ProcedureModifiers { get; set; }

        /// <summary>
        /// Gets or sets Procedures.
        /// </summary>
        public ObservableCollection<Procedure> Procedures { get; set; }

        /// <summary>
        /// Gets or sets SelectedOrderingLocation.
        /// </summary>
        public OrderingLocation SelectedOrderingLocation
        {
            get
            {
                if (this.CurrentReconciliation.Order != null && this.CurrentReconciliation.Order.IsToBeCreated)
                {
                    return this.CurrentReconciliation.Order.OrderingLocation;
                }

                return null;
            }

            set
            {
                if (this.CurrentReconciliation.Order != null && this.CurrentReconciliation.Order.IsToBeCreated)
                {
                    this.CurrentReconciliation.Order.OrderingLocation = value;
                    this.CurrentReconciliation.Order.OrderingLocationIen = value.Id;
                    this.RaisePropertyChanged("SelectedOrderingLocation");
                    this.ShowOrHideOrderingLocationMessage();
                    this.NavigateForward.RaiseCanExecuteChanged();

                    // Save the value to app config for next time...
                    cachedOrderingLocation = value;
                }
            }
        }

        /// <summary>
        /// Gets or sets SelectedOrderingProvider.
        /// </summary>
        public OrderingProvider SelectedOrderingProvider
        {
            get
            {
                if (this.CurrentReconciliation.Order != null && this.CurrentReconciliation.Order.IsToBeCreated)
                {
                    return this.CurrentReconciliation.Order.OrderingProvider;
                }

                return null;
            }

            set
            {
                if (this.CurrentReconciliation.Order != null && this.CurrentReconciliation.Order.IsToBeCreated)
                {
                    this.CurrentReconciliation.Order.OrderingProvider = value;
                    this.RaisePropertyChanged("SelectedOrderingProvider");
                    this.ShowOrHideOrderingProvider();
                    this.NavigateForward.RaiseCanExecuteChanged();

                    // Save the value to app config for next time...
                    if (value != null)
                    {
                        cachedOrderingProvider = value;
                    }
                }
            }
        }

        /// <summary>
        /// Gets or sets SelectedProcedure.
        /// </summary>
        public Procedure SelectedProcedure
        {
            get
            {
                if (this.CurrentReconciliation.Order != null && this.CurrentReconciliation.Order.IsToBeCreated)
                {
                    return this.CurrentReconciliation.Order.Procedure;
                }

                return null;
            }

            set
            {
                if (this.CurrentReconciliation.Order != null && this.CurrentReconciliation.Order.IsToBeCreated)
                {
                    this.CurrentReconciliation.Order.Procedure = value;
                    this.SelectedProcedureModifiers = null;
                    this.InitializeProcedureModifiers(this, null);
                    this.RaisePropertyChanged("AnyProcedureModifiersAvailable");
                    //Added RaisePropertyChanged event handler to retrieve Selected Procedure.Earlier raising events are handled through imlementing library {NotifyPropertyWeaverMsBuildTask}(p289-OITCOPondiS)
                    this.RaisePropertyChanged("SelectedProcedure");
                    this.ShowOrHideProcedureMessage();
                    this.NavigateForward.RaiseCanExecuteChanged();
                }

            }
        }

        /// <summary>
        /// Gets or sets SelectedProcedureModifiers.
        /// </summary>
        public ObservableCollection<ProcedureModifier> SelectedProcedureModifiers
        {
            get
            {
                if (this.CurrentReconciliation.Order != null && this.CurrentReconciliation.Order.IsToBeCreated)
                {
                    return this.CurrentReconciliation.Order.ProcedureModifiers;
                }

                return null;
            }

            set
            {
                if (this.CurrentReconciliation.Order != null && this.CurrentReconciliation.Order.IsToBeCreated)
                {
                    this.CurrentReconciliation.Order.ProcedureModifiers = value;
                    this.RaisePropertyChanged("SelectedProcedureModifiers");
                    this.RaisePropertyChanged("AnyProcedureModifiersAvailable");
                }
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether to show original study info.
        /// </summary>
        public bool ShowOriginalStudyInfo { get; set; }

        /// <summary>
        /// Gets or sets the status change details.
        /// </summary>
        public StatusChangeDetails StatusChangeDetails
        {
            get
            {
                if (this.CurrentReconciliation.Order == null)
                {
                    return null;
                }

                return this.CurrentReconciliation.Order.StatusChangeDetails;
            }

            set
            {
                this.CurrentReconciliation.Order.StatusChangeDetails = value;
            }
        }

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
            bool appClosing = false;

            try
            {
                base.OnNavigatedTo(navigationContext);

                try
                {
                    // Load the lookup tables
                    this.Procedures = this.DicomImporterDataSource.GetProcedureList(CurrentReconciliation.ImagingLocation.Id);

                    // Sends the user back to the previous page if there are no procedures for the selected Imaging Location
                    if (this.Procedures.Count < 1)
                    {
                        MessageBoxResult result = this.DialogService.ShowAlertBox(this.UIDispatcher, NoProceduresMessage,
                                                                                  NoProceduresCaption, MessageTypes.Warning);

                        if (result == MessageBoxResult.OK)
                        {
                            this.NavigateBack.Execute(0);
                        }
                        else
                        {
                            appClosing = true;
                        }
                    }
                }
                catch (ServerException se)
                {
                    if (se.ErrorCode.Equals(ImporterErrorCodes.OutsideLocationConfigurationErrorCode))
                    {
                        // Show the error, cancel the work Item, and navigate back to the Home view
                        this.ShowOutsideLocationErrorAndCancelWorkItem();

                        // Return from OnNavigatedTo
                        return;
                    }
                    else
                    {
                        throw;
                    }
                }

                // If a timeout occurs and the user decides to close the application or login as a new user
                // while the no procedures message is displayed, we dont want to configure the Create Radiology
                // Order page.
                if (!appClosing)
                {
                    // If we are toggling here from the Existing orders screen, we need to intialize
                    // with a new order. 
                    if (this.CurrentReconciliation.Order == null || !this.CurrentReconciliation.Order.IsToBeCreated)
                    {
                        this.CurrentReconciliation.Order = new Order { Specialty = "RAD", IsToBeCreated = true, ExamStatus = string.Empty };

                        // Try to set the ordering location and provider if we have default values for them
                        this.SetDefaultOrderingLocation();
                        this.SetDefaultOrderingProvider();

                        // Clear out the SelectedProcedure
                        this.SelectedProcedure = null;

                        // Reset to "read by VA radiologist" as the default
                        this.CurrentReconciliation.IsStudyToBeReadByVaRadiologist = true;

                        // Reinitialize Procedure Modifiers
                        this.RefreshSelectedProcedureModifiers(this, null);

                        // Set the initial change status details state for the order.
                        StatusChangeDetails details = new StatusChangeDetails();
                        details.RequestedStatus = StatusChangeDetails.CalculateNextStatus("");
                        details.SecondaryDiagnosticCodeCount = 0;
                        details.CurrentStudy = this.CurrentStudy;
                        this.StatusChangeDetails = details;
                    }

                    this.RefreshSelectedProcedureModifiers(this, null);

                    this.ShowOrHideProcedureMessage();
                    this.ShowOrHideOrderingLocationMessage();
                    this.ShowOrHideOrderingProvider();

                    ShowOriginalStudyInfo = IsDicomWorkItem;
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

        #region Private Methods

        /// <summary>
        /// The set default ordering location.
        /// </summary>
        private void SetDefaultOrderingLocation()
        {
            if (cachedOrderingLocation != null)
            {
                this.SelectedOrderingLocation = cachedOrderingLocation;
            }
        }

        /// <summary>
        /// The set default ordering provider.
        /// </summary>
        private void SetDefaultOrderingProvider()
        {
            if (cachedOrderingProvider != null)
            {
                this.SelectedOrderingProvider = cachedOrderingProvider;
            }
        }

        /// <summary>
        /// Shows or hides the ordering location message.
        /// </summary>
        private void ShowOrHideOrderingLocationMessage()
        {
            if (this.CurrentReconciliation == null ||
                this.CurrentReconciliation.Order == null ||
                this.CurrentReconciliation.Order.OrderingLocation == null)
            {
                this.AddMessage(MessageTypes.Info, OrderingLocationMessage);
            }
            else
            {
                this.RemoveMessage(OrderingLocationMessage);
            }
        }

        /// <summary>
        /// Shows or hides the ordering provider.
        /// </summary>
        private void ShowOrHideOrderingProvider()
        {
            if (this.CurrentReconciliation == null ||
                this.CurrentReconciliation.Order == null ||
                this.CurrentReconciliation.Order.OrderingProvider == null)
            {
                this.AddMessage(MessageTypes.Info, OrderingProviderMessage);
            }
            else
            {
                this.RemoveMessage(OrderingProviderMessage);
            }
        }

        /// <summary>
        /// Shows or hides the procedure message.
        /// </summary>
        private void ShowOrHideProcedureMessage()
        {
            if (this.CurrentReconciliation == null ||
                this.CurrentReconciliation.Order == null ||
                this.CurrentReconciliation.Order.Procedure == null)
            {
                this.AddMessage(MessageTypes.Info, ProcedureMessage);
            }
            else
            {
                this.RemoveMessage(ProcedureMessage);
            }
        }

        /// <summary>
        /// Validates the form.
        /// </summary>
        /// <returns>
        /// Returns <c>true</c> if the form is valid, otherwise false.
        /// </returns>
        private bool ValidateForm()
        {
            // Have to have a reconciliation ...
            if (this.CurrentReconciliation == null)
            {
                return false;
            }

            Order order = this.CurrentReconciliation.Order;

            // Have to have an order...
            if (order == null)
            {
                return false;
            }

            // Have to have an Ordering Provider
            if (order.OrderingProvider == null)
            {
                return false;
            }

            // Have to have an Ordering Location
            if (order.OrderingLocation == null)
            {
                return false;
            }

            // Have to have a Procedure
            if (order.Procedure == null)
            {
                return false;
            }

            return true;
        }

        #endregion
    }
}

