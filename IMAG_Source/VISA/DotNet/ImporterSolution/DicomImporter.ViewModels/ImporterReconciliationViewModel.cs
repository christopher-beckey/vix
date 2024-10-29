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

    using DicomImporter.Common.Model;
    using DicomImporter.Common.Views;

    using ImagingClient.Infrastructure.DialogService;

    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The importer reconciliation view model.
    /// </summary>
    public class ImporterReconciliationViewModel : ImporterViewModel
    {
        /// <summary>
        /// Message text for the message box displayed when the Outside Imaging Locations are not set up
        /// </summary>
        protected const string OutsideLocationMisconfigurationErrorText =
            "The Procedure List could not be loaded. The most likely cause is that no Outside Imaging Locations\n "
            + "have been configured. Until this configuration issue is corrected, you will not be able to complete\n "
            + "any reconciliations.\n\n"
            + "Please contact an administrator for assistance.\n ";

        /// <summary>
        /// Caption for the message box displayed when the Outside Imaging Locations are not set up
        /// </summary>
        protected const string OutsideLocationMisconfigurationErrorCaption = "Outside Locations Not Configured";

        #region Public Properties

        /// <summary>
        /// Gets a value indicating whether IsDicomCorrect.
        /// </summary>
        public bool IsDicomCorrect
        {
            get
            {
                return this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.DicomCorrect.Code) ||
                    this.WorkItem.Subtype.Equals(ImporterWorkItemSubtype.CommunityCare.Code);
            }
        }

        /// <summary>
        /// Gets a value indicating whether this subtype allows for update of exam status.
        /// </summary>
        public bool CanUpdateExamStatusForWorkItemSubtype
        {
            get
            {
                return !this.IsDicomCorrect;
            }
        }

        #endregion 

        #region Public Methods

        /// <summary>
        /// The confirm navigation request.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        /// <param name="continuationCallback">
        /// The continuation callback.
        /// </param>
        public override void ConfirmNavigationRequest(
            NavigationContext navigationContext, Action<bool> continuationCallback)
        {
            this.ConfirmNavigationFromActiveReconciliation(navigationContext, continuationCallback);
        }

        #endregion

        #region Methods

        /// <summary>
        /// Gets the order matching the one images were previously imported under.
        /// </summary>
        /// <param name="previouslyReconciledOrder">
        /// The previously reconciled order.
        /// </param>
        /// <param name="ordersForPatient">
        /// The orders for patient.
        /// </param>
        /// <returns>
        /// An order from the list of orders for the patient that matches the previously reconciled order, 
        /// or null if a match is not found.
        /// </returns>
        protected Order GetMatchingOrder(Order previouslyReconciledOrder, ObservableCollection<Order> ordersForPatient)
        {
            Order matchingOrder = null;
            foreach (Order order in ordersForPatient)
            {
                if (order.Equals(previouslyReconciledOrder))
                {
                    matchingOrder = order;
                }
            }

            return matchingOrder;
        }

        /// <summary>
        /// The on logout.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        protected override void OnLogout(CancelEventArgs args)
        {
            base.OnLogout(args);

            if (!args.Cancel)
            {
                this.ConfirmCancellation(args, "log out");
            }
        }

        /// <summary>
        /// The on shutdown.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        protected override void OnShutdown(CancelEventArgs args)
        {
            base.OnShutdown(args);

            if (!args.Cancel)
            {
                this.ConfirmCancellation(args, "exit");
            }
        }

        /// <summary>
        /// The on timeout cleanup.
        /// </summary>
        /// <param name="args">The args.</param>
        protected override void OnTimeoutCleanup(CancelEventArgs args)
        {
            if (!args.Cancel)
            {
                // Remove this reconciliation
                DicomImporterDataSource.CancelImporterWorkItem(WorkItem);

                // Delete the Work Item
                WorkItem = null;    
            }

            base.OnTimeoutCleanup(args);
        }


        /// <summary>
        /// Shows the outside location error and cancels work item.
        /// </summary>
        protected void ShowOutsideLocationErrorAndCancelWorkItem()
        {
            DialogService.ShowAlertBox(
                this.UIDispatcher,
                OutsideLocationMisconfigurationErrorText,
                OutsideLocationMisconfigurationErrorCaption,
                MessageTypes.Error);

            // Remove this reconciliation
            DicomImporterDataSource.CancelImporterWorkItem(WorkItem);

            // Delete the Work Item
            WorkItem = null;

            // Navigate back to the Importer Home View
            this.NavigateMainRegionTo(ImporterViewNames.ImporterHomeView);
        }

        protected void CancelWorkItem(IDialogServiceImporter dlg, ImporterWorkItem workItem)
        {
            this.m_dlgServiceImporter = dlg;
            CancelWorkItem(workItem);
        }



        /// <summary>
        /// The cancel work item.
        /// </summary>
        /// <param name="workItem">
        /// The work item.
        /// </param>
        protected void CancelWorkItem(ImporterWorkItem workItem)
        {
            if (!IsDicomWorkItem)
            {
                // This is a non-DICOM work item, so delete the dummy study we created
                this.WorkItemDetails.Studies.Clear();
            }

            if (workItem.Subtype == ImporterWorkItemSubtype.DirectImport.Code)
            {
                // This was a direct import. Return to Direct Import Media Category view
                this.NavigateMainRegionTo(ImporterViewNames.SelectMediaCategoryView + "?IsForMediaStaging=false");
            }
            else
            {
                // This was an item from the worklist, so return to the worklist
                this.NavigateMainRegionTo(ImporterViewNames.WorkListView + "?IsFirstWorkListLoading=false");
            }
        }

        #endregion
    }
}