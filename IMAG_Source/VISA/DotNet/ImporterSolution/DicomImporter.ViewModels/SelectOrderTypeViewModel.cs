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

    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.Views;

    using ImagingClient.Infrastructure.DialogService;

    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;
    using System.Threading;

    /// <summary>
    /// The select order type view model.
    /// </summary>
    public class SelectOrderTypeViewModel : ImporterReconciliationViewModel
    {
         #region Constants and Field

        /// <summary>
        /// The imaging location message
        /// </summary>
        private const string ImagingLocationMessage = "Please select an Imaging Location.";

        /// <summary>
        /// The order message
        /// </summary>
        private const string OrderMessage = "Please select an order target.";

        /// <summary>
        /// The study date message
        /// </summary>
        private const string StudyDateMessage = "Please enter a valid study date.";

        /// <summary>
        /// The study origin message
        /// </summary>
        private const string StudyOriginMessage = "Please select a study origin.";

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="SelectOrderTypeViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public SelectOrderTypeViewModel(IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;

            this.NavigateForward = new DelegateCommand<object>(
                o =>
                    {
                        if (this.ShowStudyDateControl && !this.IsValidStudyDate(this.UserSuppliedStudyDate))
                        {
                            string message =
                                "A valid study date is required. Please enter a date on or before today, in DICOM (YYYYMMDD) format.";
                            string caption = "Valid Study Date Required";
                            this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);
                        }
                        else
                        {
                            if (this.ShowStudyDateControl)
                            {
                                this.CurrentStudy.StudyDate = this.UserSuppliedStudyDate;
                            }

                            if (this.UseExistingOrder)
                            {
                                this.NavigateWorkItem(ImporterViewNames.ChooseExistingOrderView);
                            }
                            else
                            {
                                this.NavigateWorkItem(ImporterViewNames.CreateNewRadiologyOrderView);
                            }
                        }
                    }, 
                o => this.ValidateForm());

            this.NavigateBack = new DelegateCommand<object>(
                o =>
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
                );

            this.CancelReconciliationCommand = new DelegateCommand<object>(
                o => this.CancelReconciliation());
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets a value indicating whether CreateRadiologyOrder.
        /// </summary>
        public bool CreateRadiologyOrder
        {
            get
            {
                return this.CurrentReconciliation.CreateRadiologyOrder;
            }

            set
            {
                this.CurrentReconciliation.Order = null;
                this.CurrentReconciliation.CreateRadiologyOrder = value;
                this.CurrentReconciliation.UseExistingOrder = !value;
                this.ShowOrHideOrderMessage();
                this.ShowOrHideImagingLocationMessage();
                this.RaisePropertyChanged("ShowStudyDateControl");
                this.RaisePropertyChanged("ShowImagingLocationsControl");
                this.NavigateForward.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets the imaging location list.
        /// </summary>
        public ObservableCollection<ImagingLocation> ImagingLocationList
        {
            get
            {
                return this.DicomImporterDataSource.GetImagingLocationList();
            }
        }

        /// <summary>
        /// Gets or sets NavigateBack.
        /// </summary>
        public DelegateCommand<object> NavigateBack { get; set; }

        /// <summary>
        /// Gets or sets NavigateForward.
        /// </summary>
        public DelegateCommand<object> NavigateForward { get; set; }

        /// <summary>
        /// Gets OriginIndexList.
        /// </summary>
        public ObservableCollection<OriginIndex> OriginIndexList
        {
            get
            {
                return this.DicomImporterDataSource.GetOriginIndexList();
            }
        }

        /// <summary>
        /// Gets or sets the selected imaging location.
        /// </summary>
        public ImagingLocation SelectedImagingLocation
        {
            get
            {
                return this.CurrentReconciliation.ImagingLocation;
            }

            set
            {
                Thread.Sleep(500);

                this.CurrentReconciliation.ImagingLocation = value;
                this.ShowOrHideImagingLocationMessage();
                this.NavigateForward.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets or sets SelectedOriginIndex.
        /// </summary>
        public OriginIndex SelectedOriginIndex
        {
            get
            {
                return OriginIndex.GetOriginIndexByCode(this.CurrentStudy.OriginIndex);
            }

            set
            {
                this.CurrentStudy.OriginIndex = value.Code;
                this.ShowOrHideStudyOriginMessage();
                this.NavigateForward.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets a value indicating whether the Imaging Locations
        /// Control should be displayed or not.
        /// </summary>
        /// <returns></returns>
        public bool ShowImagingLocationsControl
        {
            get
            {
                return this.CreateRadiologyOrder;
            }
        }

        /// <summary>
        /// Gets a value indicating whether ShowStudyDateControl.
        /// </summary>
        public bool ShowStudyDateControl
        {
            get
            {
                // Only continue to check if we're creating a radiology order. If we're using an existing
                // order this doesn't matter...
                if (this.CreateRadiologyOrder)
                {
                    // There are two cases where we show the field. The first is if the study date in the study
                    // is empty (which happens the first time through the wizard
                    string studyDateFromStudy = this.CurrentStudy.StudyDate + string.Empty;
                    studyDateFromStudy = studyDateFromStudy.Trim();

                    if (string.IsNullOrEmpty(studyDateFromStudy))
                    {
                        return true;
                    }

                    // The second case is if the UserSuppliedStudyDate was entered at some point earlier.
                    if (!string.IsNullOrEmpty(this.CurrentStudy.UserSuppliedStudyDate))
                    {
                        return true;
                    }
                }

                return false;
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether UseExistingOrder.
        /// </summary>
        public bool UseExistingOrder
        {
            get
            {
                return this.CurrentReconciliation.UseExistingOrder;
            }

            set
            {
                this.CurrentReconciliation.Order = null;
                this.CurrentReconciliation.ImagingLocation = null;
                this.CurrentReconciliation.UseExistingOrder = value;
                this.CurrentReconciliation.CreateRadiologyOrder = !value;
                this.ShowOrHideOrderMessage();
                this.ShowOrHideImagingLocationMessage();
                this.RaisePropertyChanged("ShowStudyDateControl");
                this.RaisePropertyChanged("SelectedImagingLocation");
                this.RaisePropertyChanged("ShowImagingLocationsControl");
                this.NavigateForward.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets or sets UserSuppliedStudyDate.
        /// </summary>
        public string UserSuppliedStudyDate
        {
            get
            {
                return this.CurrentStudy.UserSuppliedStudyDate;
            }

            set
            {
                this.CurrentStudy.UserSuppliedStudyDate = value;
            }
        }

        #endregion

        #region Events

        /// <summary>
        /// The on navigated to.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        public override void OnNavigatedTo(NavigationContext navigationContext)
        {
            base.OnNavigatedTo(navigationContext);
            
            this.ShowOrHideStudyDateMessage();
            this.ShowOrHideOrderMessage();
            this.ShowOrHideStudyOriginMessage();
            this.ShowOrHideImagingLocationMessage();
        }

        #endregion

        #region Methods

        /// <summary>
        /// Determines whether the user supplied study date is valid.
        /// </summary>
        /// <param name="userSuppliedStudyDate">The user supplied study date.</param>
        /// <returns>
        ///   <c>true</c> if the user supplied study date is valid; otherwise, <c>false</c>.
        /// </returns>
        private bool IsValidStudyDate(string userSuppliedStudyDate)
        {
            userSuppliedStudyDate = userSuppliedStudyDate + string.Empty;

            // If the string is empty return false
            if (string.IsNullOrEmpty(userSuppliedStudyDate.Trim()))
            {
                return false;
            }

            // If the date can't be parsed in yyyyMMdd format, return false
            DateTime studyDate;
            if (
                !DateTime.TryParseExact(
                    userSuppliedStudyDate, 
                    "yyyyMMdd", 
                    DateTimeFormatInfo.InvariantInfo, 
                    DateTimeStyles.None, 
                    out studyDate))
            {
                return false;
            }

            // If the date is later than today, return false
            if (studyDate.Date > DateTime.Now.Date)
            {
                return false;
            }

            // All checks passed, so return true
            return true;
        }

        /// <summary>
        /// Shows or hides the order message.
        /// </summary>
        private void ShowOrHideOrderMessage()
        {
            if (this.UseExistingOrder || this.CreateRadiologyOrder)
            {
                this.RemoveMessage(OrderMessage);
            }
            else
            {
                this.AddMessage(MessageTypes.Info, OrderMessage);
            }
        }

        /// <summary>
        ///Shows or hides the study date message.
        /// </summary>
        private void ShowOrHideStudyDateMessage()
        {
            if (this.IsValidStudyDate(this.UserSuppliedStudyDate))
            {
                this.RemoveMessage(StudyDateMessage);
            }
            else if (this.ShowStudyDateControl)
            {
                this.AddMessage(MessageTypes.Info, StudyDateMessage);
            }
        }

        /// <summary>
        /// Shows or hides the study origin message.
        /// </summary>
        private void ShowOrHideStudyOriginMessage()
        {
            if (!string.IsNullOrEmpty(this.CurrentStudy.OriginIndex))
            {
                this.RemoveMessage(StudyOriginMessage);
            }
            else
            {
                this.AddMessage(MessageTypes.Info, StudyOriginMessage);
            }
        }

        /// <summary>
        /// Shows or hides imaging location message.
        /// </summary>
        private void ShowOrHideImagingLocationMessage()
        {
            if (this.CreateRadiologyOrder && this.SelectedImagingLocation == null)
            {
                this.AddMessage(MessageTypes.Info, ImagingLocationMessage);
            }
            else
            {
                this.RemoveMessage(ImagingLocationMessage);
            }
        }

        /// <summary>
        /// Validates the form.
        /// </summary>
        /// <returns><c>true</c> if the form is valid and the user can continue; otherwise <c>false</c></returns>
        private bool ValidateForm()
        {
            // Have to have selected an option to either use an existing order or create a new one...
            bool orderTypeSelected = this.UseExistingOrder || this.CreateRadiologyOrder;
            bool originIndexSelected = !string.IsNullOrEmpty(this.CurrentStudy.OriginIndex);
            
            // Have to have selected an imaging location if creating a new order
            bool imagingLocationSelected = this.CreateRadiologyOrder && this.SelectedImagingLocation != null;

            return orderTypeSelected && originIndexSelected && (imagingLocationSelected || this.UseExistingOrder);
        }

        #endregion
    }
}