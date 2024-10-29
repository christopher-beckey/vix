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

using DicomImporter.Common.Model;

namespace DicomImporter.ViewModels
{
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Views;
    using DicomImporter.Common.ViewModels;

    using ImagingClient.Infrastructure.DialogService;

    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The reconciliation summary view model.
    /// </summary>
    public class ReconciliationSummaryViewModel : ImporterReconciliationViewModel
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ReconciliationSummaryViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public ReconciliationSummaryViewModel(
            IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;

            this.NavigateForward = new DelegateCommand<object>(
                o =>
                    {
                        this.WorkItemDetails.CurrentStudy.Reconciliation.IsReconciliationComplete = true;
                        this.NavigateWorkItem(ImporterViewNames.StudyListView);
                    });

            this.NavigateBack = new DelegateCommand<object>(
                o =>
                    {


                        if (WorkItem.MediaCategory.Category.Equals(MediaCategories.NonDICOM))
                        {
                            // This is a non-DICOM reconciliation, so go back to the appropriate order
                            // selection screen.
                            if (this.CurrentReconciliation.UseExistingOrder)
                            {
                                this.NavigateWorkItem(ImporterViewNames.ChooseExistingOrderView);
                            }
                            else
                            {
                                this.NavigateWorkItem(ImporterViewNames.CreateNewRadiologyOrderView);
                            }
                        }
                        else
                        {
                            // This is either DICOM or mixed, so go to the NonDicomFile screen.
                            this.NavigateWorkItem(ImporterViewNames.AddNonDicomFilesToReconciliationView);
                        }





                    });

            this.CancelReconciliationCommand = new DelegateCommand<object>(
                o => this.CancelReconciliation());
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets NavigateBack.
        /// </summary>
        public DelegateCommand<object> NavigateBack { get; set; }

        /// <summary>
        /// Gets or sets NavigateForward.
        /// </summary>
        public DelegateCommand<object> NavigateForward { get; set; }

        /// <summary>
        /// Gets or sets ReconciliationDetailsViewModel.
        /// </summary>
        public ReconciliationDetailsViewModel ReconciliationDetailsViewModel { get; set; }

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
            this.ReconciliationDetailsViewModel = new ReconciliationDetailsViewModel(this.WorkItemDetails.CurrentStudy, this.WorkItem);
        }

        #endregion
    }
}