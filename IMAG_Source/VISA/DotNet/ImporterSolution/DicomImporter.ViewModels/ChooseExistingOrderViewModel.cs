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
    using System.Linq;
    using System.Threading;
    using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.Views;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Exceptions;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The choose existing order view model.
    /// </summary>
    public class ChooseExistingOrderViewModel : ImporterReconciliationViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The message to display when the seleted exam is already complete.
        /// </summary>
        private const string ExamAlreadyCompleteMessage = "The exam status for the selected order is already completed. Images can be appended to the order but the order details will not be changed.";

        /// <summary>
        /// The existing order message
        /// </summary>
        private const string ExistingOrderMessage = "Please select an existing order.";

        /// <summary>
        /// The last order completed
        /// </summary>
        private bool lastOrderCompleted;

        /// <summary>
        /// The no orders message
        /// </summary>
        private string noOrdersMessage;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ChooseExistingOrderViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public ChooseExistingOrderViewModel(
            IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;

            this.NavigateForward = new DelegateCommand<object>(
                o =>
                {
                    bool navigateWorkItem = true;

                    if (this.CurrentReconciliation.Order == null)
                    {
                        string message = "You must select or create an order before proceeding.";
                        string caption = "No Order Selected or Created";
                        this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);
                    }
                    else
                    {
                        // Alerts the user that no notifications will be sent out when appending to a completed order
                        if (ExamStatuses.IsCompletedStatus(this.CurrentReconciliation.Order.ExamStatus))
                        {
                            string message = "The exam status for the selected order is already completed with a credit method of \"No Credit\". " +
                                             "As a result, images will be appended without any notifications being sent out. \n";
                            string caption = "Appending Images To A Completed Order";
                            navigateWorkItem = this.DialogService.ShowOkCancelBox(this.UIDispatcher, message, caption, MessageTypes.Info);
                        }

                        UpdateWorkItemFilters();

                        if (navigateWorkItem)
                        {
                            if (IsDicomWorkItem)
                            {
                                this.NavigateWorkItem(ImporterViewNames.AddNonDicomFilesToReconciliationView);
                            }
                            else
                            {
                                this.NavigateWorkItem(ImporterViewNames.ConfirmationView);
                            }
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
            
            this.ChangeDetailsCommand = new DelegateCommand<object>(
                o => this.ShowStatusChangeDetailsWindow(this, null),
                o => (this.SelectedOrder != null && !this.SelectedOrderCompleted()));

            this.RefreshOrdersCommand = new DelegateCommand<object>(o => this.RefreshOrders());
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

        #region Delegates and Commands

        /// <summary>
        /// The show status change details window event handler.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The <see cref="EventArgs" /> instance containing the event data.</param>
        public delegate void ShowStatusChangeDetailsWindowEventHandler(object sender, EventArgs e);
        
        /// <summary>
        /// Gets or sets the change details command.
        /// </summary>
        /// <value>
        /// The change details command.
        /// </value>
        public DelegateCommand<object> ChangeDetailsCommand { get; set; }

        /// <summary>
        /// Gets or sets the Exam Status Message.
        /// </summary>
        public string ExamStatusMessage { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether IsStudyReadByVaRadiologistEnabled.
        /// </summary>
        public bool IsStudyReadByVaRadiologistEnabled { get; set; }

        /// <summary>
        /// Gets or sets NavigateBack.
        /// </summary>
        public DelegateCommand<object> NavigateBack { get; set; }

        /// <summary>
        /// Gets or sets NavigateForward.
        /// </summary>
        public DelegateCommand<object> NavigateForward { get; set; }

        /// <summary>
        /// Gets or sets RefreshOrdersCommand.
        /// </summary>
        public DelegateCommand<object> RefreshOrdersCommand { get; set; }

        #endregion

        #region Public Events

        /// <summary>
        ///  Used by the view to show the StatusChangeDetails window
        /// </summary>
        public event ShowStatusChangeDetailsWindowEventHandler ShowStatusChangeDetailsWindow;

        #endregion

        #region Private Properties
        //Get and set property notification -OITCOPondiS
        //BEGIN-Modified RequestedStatus property to bind Textbox. Earlier binding made through imlementing library {NotifyPropertyWeaverMsBuildTask}.(p289-OITCOPondiS)
        private string _StandardReportName { get; set; }
        private int _NumOfSecondaryDiagnosticCodes { get; set; }
        private string _PrimaryDiagnosticCode { get; set; }        
        private string _RequestedStatus { get; set; }

        //END

        #endregion


        #region Public Properties
        //Get and set property notification in MediaStagingView screen-OITCOPondiS
        /// <summary>
        /// Gets the num of secondary diagnostic codes.
        /// </summary>
        //public int NumOfSecondaryDiagnosticCodes { get; private set; }

        public int NumOfSecondaryDiagnosticCodes
        {
            get { return _NumOfSecondaryDiagnosticCodes; }
            set
            {
                _NumOfSecondaryDiagnosticCodes = value;
                this.RaisePropertyChanged("NumOfSecondaryDiagnosticCodes");
            }
        }

        /// <summary>
        /// Gets the primary diagnostic code.
        /// </summary>
        //public string PrimaryDiagnosticCode { get; private set; }

        public string PrimaryDiagnosticCode
        {
            get { return _PrimaryDiagnosticCode; }
            set
            {
                _PrimaryDiagnosticCode = value;
                this.RaisePropertyChanged("PrimaryDiagnosticCode");
            }
        }



        //Commented since binding element {NotifyPropertyWeaverMsBuildTask} is no longer available in VS 2015 and above versions. (p289-OITCOPondiS) 
        ///// <summary>
        ///// Gets the requested status.
        ///// </summary>
        //public string RequestedStatus { get; private set; }


        /// <summary>
        /// Gets the requested status.
        /// </summary>
        public string RequestedStatus
        {
            get { return _RequestedStatus; }
            set
            {
                _RequestedStatus = value;
                this.RaisePropertyChanged("RequestedStatus");
            }
        }
        //END



        /// <summary>
        /// Gets or sets a value indicating whether to show original study info.
        /// </summary>
        public bool ShowOriginalStudyInfo { get; set; }

        /// <summary>
        /// Gets or sets SelectedOrder.
        /// </summary>
        public Order SelectedOrder
        {
            get
            {
                return (this.CurrentReconciliation != null) ? this.CurrentReconciliation.Order : null;
            }

            set
            {
                Thread.Sleep(500);

                if (this.CurrentReconciliation != null)
                {
                    this.CurrentReconciliation.Order = value;

                    // sets the initial change status details state for the order.
                    StatusChangeDetails details = new StatusChangeDetails();
                    details.RequestedStatus = StatusChangeDetails.CalculateNextStatus(CurrentReconciliation.Order.ExamStatus);
                    //Add to assign selected order's ExamStatus field value to local property {RequestedStatus} to show status in Textbox. (p289-OITCOPondiS)   
                    RequestedStatus = details.RequestedStatus;
                    details.SecondaryDiagnosticCodeCount = 0;
                    details.CurrentStudy = this.CurrentStudy;
                    details.WorkItemId = this.WorkItem.Id;
                    this.StatusChangeDetails = details;
                }

                this.SetVaRadiologistEnabledStatus();
                this.ShoworHideCompletedExamMessage();
                this.ShowOrHideExistingOrderMessage();

                if (this.CurrentReconciliation != null)
                {
                    this.lastOrderCompleted = this.SelectedOrderCompleted();
                }

                this.RaisePropertyChanged("SelectedOrder");
                this.NavigateForward.RaiseCanExecuteChanged();
                this.ChangeDetailsCommand.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets the name of the standard report.
        /// </summary>
        //public string StandardReportName { get; private set; }
       

        /// <summary>
        /// Gets the requested status.
        /// </summary>
        public string StandardReportName
        {
            get { return _StandardReportName; }
            set
            {
                _StandardReportName = value;
                this.RaisePropertyChanged("StandardReportName");
            }
        }

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
                //Add to assign changed status value from StatusChange screen to local property {RequestedStatus} in order to show changed status in Textbox. (p289-OITCOPondiS)   
                RequestedStatus = !string.IsNullOrEmpty(this.CurrentReconciliation.Order.StatusChangeDetails.RequestedStatus) ? this.CurrentReconciliation.Order.StatusChangeDetails.RequestedStatus : string.Empty;
                StandardReportName = !string.IsNullOrEmpty(this.CurrentReconciliation.Order.StatusChangeDetails.StandardReportName) ? this.CurrentReconciliation.Order.StatusChangeDetails.StandardReportName : string.Empty;
                PrimaryDiagnosticCode = (this.CurrentReconciliation.Order.StatusChangeDetails.PrimaryDiagnosticCode != null &&
                    !string.IsNullOrEmpty(this.CurrentReconciliation.Order.StatusChangeDetails.PrimaryDiagnosticCode.DisplayName)) ? 
                    this.CurrentReconciliation.Order.StatusChangeDetails.PrimaryDiagnosticCode.DisplayName : string.Empty;
               NumOfSecondaryDiagnosticCodes = this.CurrentReconciliation.Order.StatusChangeDetails.SecondaryDiagnosticCodeCount;
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
            base.OnNavigatedTo(navigationContext);

            try
            {
                // Refresh the orders for the patient.
                if (this.CurrentReconciliation.Orders == null)
                {
                    this.RefreshOrders();
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

            ShowOriginalStudyInfo = IsDicomWorkItem;

            this.SetVaRadiologistEnabledStatus();
            this.ShoworHideCompletedExamMessage();
            this.ShowOrHideExistingOrderMessage();
        }

        #endregion

        #region Methods

        /// <summary>
        /// The refresh orders.
        /// </summary>
        private void RefreshOrders()
        {
            this.CurrentReconciliation.Order = null;

            // Get all the orders for the patient
            this.CurrentReconciliation.Orders = this.DicomImporterDataSource.GetOrdersForPatient(this.CurrentReconciliation.Patient.Dfn);

            // P217 - The user must not be able to see any unregistered NON DICOM orders on the existing order list - Pramod Kumar Chikkappaiah - VHAISHCHIKKP 2018-07-24
            if (!this.IsDicomWorkItem)
            {
                var unregisteredOrders = new ObservableCollection<Order>();
                foreach (Order order in this.CurrentReconciliation.Orders)
                {

                    if (!String.IsNullOrEmpty(order.ExamStatus.Trim()))
                        unregisteredOrders.Add(order);
                }

                this.CurrentReconciliation.Orders = unregisteredOrders;
            }
                        
            // First, add previously reconciled order if necessary
            this.AddPreviouslyReconciledOrderIfNecessary();

            // Display a popup if no orders were found after the searching and filtering...
            if (this.CurrentReconciliation.Orders == null || this.CurrentReconciliation.Orders.Count == 0)
            {
                this.ClearMessages();
                this.noOrdersMessage = "No orders were found for " + this.CurrentReconciliation.Patient.PatientName +
                                       " in a status that allows for image attachment.";

                this.AddMessage(MessageTypes.Warning, this.noOrdersMessage);
            }

            this.RaisePropertyChanged("SelectedOrder");
            this.NavigateForward.RaiseCanExecuteChanged();
            this.ChangeDetailsCommand.RaiseCanExecuteChanged();
        }

        /// <summary>
        /// Adds the previously reconciled order if necessary.
        /// </summary>
        private void AddPreviouslyReconciledOrderIfNecessary()
        {
            // if the current patient does not match the previously reconciled patient, exit, since we don't
            // want to add an order for another patient to the list...
            if (this.CurrentReconciliation.Patient != this.CurrentStudy.PreviouslyReconciledPatient)
            {
                return;
            }

            // If we're still here, check to see if there is a previously reconciled order 
            // and if it's not in the list, add it
            if (this.CurrentStudy.PreviouslyReconciledOrder != null)
            {
                // Attempt to find a match
                Order previouslyReconciledOrder = this.GetMatchingOrder(
                    this.CurrentStudy.PreviouslyReconciledOrder, this.CurrentReconciliation.Orders);

                // If we didn't find a match, add it to the list and resort the list
                if (previouslyReconciledOrder == null)
                {
                    this.CurrentReconciliation.Orders.Add(this.CurrentStudy.PreviouslyReconciledOrder);
                    this.CurrentReconciliation.Orders =
                        new ObservableCollection<Order>(
                            this.CurrentReconciliation.Orders.OrderByDescending(o => o.OrderDateAsDateTime));
                }
            }
        }

        /// <summary>
        /// The set va radiologist enabled status.
        /// </summary>
        private void SetVaRadiologistEnabledStatus()
        {
            if (this.SelectedOrder != null &&
                this.SelectedOrder.Specialty.Equals("RAD") &&
                !ExamStatuses.IsCompletedStatus(this.SelectedOrder.ExamStatus))
            {
                this.IsStudyReadByVaRadiologistEnabled = true;                
            }
            else
            {
                this.IsStudyReadByVaRadiologistEnabled = false;
                if (this.CurrentReconciliation != null)
                {
                    this.CurrentReconciliation.IsStudyToBeReadByVaRadiologist = true;
                }
            }
            //p289-OITCOPondiS-Begin-Assign local propertynames
            if (this.SelectedOrder != null)
            {
                //Examination Status Property assignment from list
                if (!string.IsNullOrEmpty(this.SelectedOrder.ExamStatus))
                    RequestedStatus = this.SelectedOrder.ExamStatus;

                //Examination Status Property assignment if status value is already changed in StatusChange Details screen
                if (this.CurrentReconciliation != null && this.CurrentReconciliation.Order != null && this.CurrentReconciliation.Order.StatusChangeDetails != null)
                {
                    if (this.CurrentReconciliation.Order.CaseNumber.Equals(this.SelectedOrder.CaseNumber))
                    {
                        RequestedStatus = this.CurrentReconciliation.Order.StatusChangeDetails.RequestedStatus;
                    }
                }
            }
            //p289-OITCOPondiS-End
        }

        /// <summary>
        /// Returns true if the selected order is completed and false otherwise.
        /// </summary>
        private bool SelectedOrderCompleted()
        {
            // Does not check for "No Credit" since the only Completed Exam being returned back to the UI are "No Credit"
            if (this.SelectedOrder != null && ExamStatuses.IsCompletedStatus(this.SelectedOrder.ExamStatus))
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// Shows or hides the "completed exam" message.
        /// </summary>
        private void ShoworHideCompletedExamMessage()
        {
            bool orderCompleted = this.SelectedOrderCompleted();

            if (orderCompleted && !this.lastOrderCompleted)
            {
                this.AddMessage(MessageTypes.Warning, ExamAlreadyCompleteMessage);
            }
            else if(!orderCompleted)
            {
                this.RemoveMessage(ExamAlreadyCompleteMessage);
            }
        }

        /// <summary>
        /// Shows or hides the existing order message.
        /// </summary>
        private void ShowOrHideExistingOrderMessage()
        {
            if (this.SelectedOrder != null)
            {
                this.RemoveMessage(ExistingOrderMessage);
            }
            else if (this.CurrentStudy.Reconciliation != null && this.CurrentStudy.Reconciliation.Orders.Count > 0)
            {
                this.AddMessage(MessageTypes.Info, ExistingOrderMessage);
            }
        }

        /// <summary>
        /// Validates the form.
        /// </summary>
        /// <returns>
        /// Whether or not the form is valid.
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

            return true;
        }

        #endregion
    }
}

