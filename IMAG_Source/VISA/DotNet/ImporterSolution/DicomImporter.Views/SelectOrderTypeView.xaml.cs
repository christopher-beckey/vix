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

namespace DicomImporter.Views
{
    using DicomImporter.ViewModels;

    /// <summary>
    /// Interaction logic for OrderSelectionView.xaml
    /// </summary>
    public partial class SelectOrderTypeView
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="SelectOrderTypeView"/> class.
        /// </summary>
        public SelectOrderTypeView()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="SelectOrderTypeView"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public SelectOrderTypeView(SelectOrderTypeViewModel viewModel)
        {
            this.InitializeComponent();
            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets ViewModel.
        /// </summary>
        public SelectOrderTypeViewModel ViewModel
        {
            get
            {
                return (SelectOrderTypeViewModel)this.DataContext;
            }
        }

        #endregion

        private void dgImagingLocations_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            ImagingLocation reconciledLocation = this.ViewModel.CurrentReconciliation.ImagingLocation;
            ImagingLocation currentlySelectedLocation = (ImagingLocation) dgImagingLocations.SelectedItem;

            if (reconciledLocation == null || (reconciledLocation.Id != currentlySelectedLocation.Id))
            {
                // The selection in the UI is different from the location in the reconciliation. Update the location, 
                // and clear the existing order
                this.ViewModel.CurrentReconciliation.ImagingLocation = (ImagingLocation) dgImagingLocations.SelectedItem;
                this.ViewModel.CurrentReconciliation.Order = null;
                this.ViewModel.CurrentReconciliation.IsReconciliationComplete = false;
            }

            this.ViewModel.NavigateForward.RaiseCanExecuteChanged();

        }

        private void BaseImagingView_Loaded(object sender, System.Windows.RoutedEventArgs e)
        {
            if (ViewModel.CurrentReconciliation.ImagingLocation != null)
            {
                foreach (var item in dgImagingLocations.Items)
                {
                    ImagingLocation location = (ImagingLocation) item;
                    if (ViewModel.CurrentReconciliation.ImagingLocation.Id == location.Id)
                    {
                        dgImagingLocations.SelectedItem = item;
                    }
                }
            }
        }

    }
}