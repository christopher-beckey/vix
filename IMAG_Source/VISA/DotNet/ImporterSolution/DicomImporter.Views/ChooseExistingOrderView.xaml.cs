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
namespace DicomImporter.Views
{
    using DicomImporter.ViewModels;
    using Microsoft.Practices.ServiceLocation;
    using System.Windows;
    using System;

    /// <summary>
    /// Interaction logic for OrderSelectionView.xaml
    /// </summary>
    public partial class ChooseExistingOrderView
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ChooseExistingOrderView"/> class.
        /// </summary>
        public ChooseExistingOrderView()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChooseExistingOrderView"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public ChooseExistingOrderView(ChooseExistingOrderViewModel viewModel)
        {
            this.InitializeComponent();
            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;
            this.ViewModel.ShowStatusChangeDetailsWindow += this.ShowStatusChangeDetailsWindow;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets ViewModel.
        /// </summary>
        public ChooseExistingOrderViewModel ViewModel
        {
            get
            {
                return (ChooseExistingOrderViewModel)this.DataContext;
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Scrolls the selected item into view.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The <see cref="RoutedEventArgs" /> instance containing the event data.</param>
        private void ScrollSelectedItemIntoView(object sender, RoutedEventArgs e)
        {
            if (this.dgExistingOrders.SelectedItem != null)
            {
                this.dgExistingOrders.ScrollIntoView(this.dgExistingOrders.SelectedItem);
            }
        }

        /// <summary>
        /// Shows the status change details window.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The <see cref="EventArgs" /> instance containing the event data.</param>
        private void ShowStatusChangeDetailsWindow(object sender, EventArgs e)
        {
            var window = ServiceLocator.Current.GetInstance<StatusChangeDetailsWindow>();
            window.ViewModel.UIDispatcher = this.Dispatcher;
            window.ViewModel.SetCurrentStatusChangeDetails(this.ViewModel.StatusChangeDetails);
            window.ViewModel.SelectedWorkItemKey = this.ViewModel.SelectedWorkItemKey;
            window.ViewModel.CurrentModalities = this.ViewModel.CurrentModalities;
            window.ViewModel.OwningWindow = window;
            window.Owner = Window.GetWindow(this);
            window.SubscribeToNewUserLogin();
            window.ShowDialog();

            // assigns the status change details to the selected order
            if (window.DialogResult.HasValue && window.DialogResult.Value)
            {
                this.ViewModel.StatusChangeDetails = window.ViewModel.StatusChangeDetails;
            }

            this.btnForward.Focus();
        }

        #endregion
    }
}