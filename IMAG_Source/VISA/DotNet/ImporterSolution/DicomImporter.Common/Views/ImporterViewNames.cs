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
namespace DicomImporter.Common.Views
{
    using System.Collections.Generic;

    /// <summary>
    /// The view names.
    /// </summary>
    public class ImporterViewNames
    {
        #region Constants and Fields

        /// <summary>
        /// The work list view.
        /// </summary>
        public const string AddNonDicomFilesToReconciliationView = "AddNonDicomFilesToReconciliationView";

        /// <summary>
        /// The admin failed import view.
        /// </summary>
        public const string AdminFailedImportView = "AdminFailedImportView";

        /// <summary>
        /// The admin failed import view.
        /// </summary>
        public const string AdminInProcessImportsView = "AdminInProcessImportsView";

        /// <summary>
        /// The admin revert work item view.
        /// </summary>
        public const string AdminRevertWorkItemView = "AdminRevertWorkItemView";

        /// <summary>
        /// The administration home view.
        /// </summary>
        public const string AdministrationHomeView = "AdministrationHomeView";

        /// <summary>
        /// The choose existing order view.
        /// </summary>
        public const string ChooseExistingOrderView = "ChooseExistingOrderView";

        /// <summary>
        /// The confirmation view.
        /// </summary>
        public const string ConfirmationView = "ConfirmationView";

        /// <summary>
        /// The create new radiology order view.
        /// </summary>
        public const string CreateNewRadiologyOrderView = "CreateNewRadiologyOrderView";

        /// <summary>
        /// The dicom header view.
        /// </summary>
        public const string DicomHeaderView = "DicomHeaderView";

        /// <summary>
        /// The direct import home view.
        /// </summary>
        public const string DirectImportHomeView = "DirectImportHomeView";

        /// <summary>
        /// The log view.
        /// </summary>
        public const string LogView = "LogView";

        /// <summary>
        /// The imaging client home view
        /// </summary>
        public const string ImagingClientHomeView = "ImagingClientHomeView";

        /// <summary>
        /// The importer home view.
        /// </summary>
        public const string ImporterHomeView = "ImporterHomeView";

        /// <summary>
        /// The importer messages view
        /// </summary>
        public const string ImporterMessagesView = "ImporterMessagesView";

        /// <summary>
        /// The media staging view.
        /// </summary>
        public const string MediaStagingView = "MediaStagingView";

        /// <summary>
        /// The Non-DICOM list view
        /// </summary>
        public const string NonDicomListView = "NonDicomListView";

        /// <summary>
        /// The Non-DICOM media view
        /// </summary>
        public const string NonDicomMediaView = "NonDicomMediaView";

        /// <summary>
        /// The order creation view.
        /// </summary>
        public const string OrderCreationView = "OrderCreationView";

        /// <summary>
        /// The order selection view.
        /// </summary>
        public const string OrderSelectionView = "OrderSelectionView";

        /// <summary>
        /// The patient selection view.
        /// </summary>
        public const string PatientSelectionView = "PatientSelectionView";

        /// <summary>
        /// The reconciliation summary view.
        /// </summary>
        public const string ReconciliationSummaryView = "ReconciliationSummaryView";

        /// <summary>
        /// The reports home view.
        /// </summary>
        public const string ReportsHomeView = "ReportsHomeView";

        /// <summary>
        /// The select media category view
        /// </summary>
        public const string SelectMediaCategoryView = "SelectMediaCategoryView";

        /// <summary>
        /// The select order type view.
        /// </summary>
        public const string SelectOrderTypeView = "SelectOrderTypeView";

        /// <summary>
        /// The study details view.
        /// </summary>
        public const string StudyDetailsView = "StudyDetailsView";

        /// <summary>
        /// The study list view.
        /// </summary>
        public const string StudyListView = "StudyListView";

        /// <summary>
        /// The work list view.
        /// </summary>
        public const string WorkListView = "WorkListView";

        /// <summary>
        /// The reconciliation views.
        /// </summary>
        private static readonly List<string> reconciliationViews = new List<string> 
        {
                ConfirmationView, 
                DicomHeaderView, 
                OrderCreationView, 
                OrderSelectionView, 
                OrderSelectionView, 
                PatientSelectionView, 
                SelectOrderTypeView, 
                ChooseExistingOrderView, 
                CreateNewRadiologyOrderView, 
                ReconciliationSummaryView, 
                StudyListView,
                NonDicomListView,
                AddNonDicomFilesToReconciliationView
        };

        #endregion

        #region Public Methods

        /// <summary>
        /// Indicates whether the view is part of the actual reconciliation workflow,
        /// so we can determine whether navigating away should force a reversion of the workitem
        /// </summary>
        /// <param name="viewName">
        /// The view name.
        /// </param>
        /// <returns>
        /// Whether it is part of the reconciliation workflow.
        /// </returns>
        public static bool IsReconciliationView(string viewName)
        {
            // Get just the view name, if it also has a querystring
            if (viewName.IndexOf("?") > 0)
            {
                viewName = viewName.Substring(0, viewName.IndexOf("?"));
            }

            return reconciliationViews.Contains(viewName);
        }

        #endregion
    }
}