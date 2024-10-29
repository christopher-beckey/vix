/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 05/29/2013
 * Site Name:  Washington OI Field Office, Columbia, MD
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

using Microsoft.Practices.ServiceLocation;

namespace DicomImporter.Views
{
    using System.Windows;
    using DicomImporter.ViewModels;

    /// <summary>
    /// Interaction logic for NonDicomListView.xaml
    /// </summary>
    public partial class NonDicomListView
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="NonDicomListView"/> class.
        /// </summary>
        public NonDicomListView()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="NonDicomListView"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public NonDicomListView(NonDicomListViewModel viewModel)
        {
            this.InitializeComponent();
            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;
        }

        #endregion

        #region Properties

        public NonDicomListViewModel ViewModel { get { return (NonDicomListViewModel) this.DataContext; } }

        #endregion

        #region Methods

        /// <summary>
        /// The btn change patient_ click.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void ChangePatient_Click(object sender, RoutedEventArgs e)
        {
            var window = ServiceLocator.Current.GetInstance<PatientLookupWindow>();
            window.Owner = Window.GetWindow(this);
            window.SubscribeToNewUserLogin();
            window.ShowDialog();

            if (window.DialogResult.HasValue && window.DialogResult.Value)
            {
                this.ViewModel.SelectedPatient = window.ViewModel.SelectedPatient;
            }
        }

        #endregion
    }
}