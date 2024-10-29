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
    using System.Windows;
    using DicomImporter.ViewModels;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Extensions;
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// Interaction logic for DirectImportHome.xaml
    /// </summary>
    public partial class DirectImportHomeView
    {
        #region Constants and Fields

        /// <summary>
        /// The event aggregator
        /// </summary>
        private IEventAggregator eventAggregator;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DirectImportHomeView"/> class.
        /// </summary>
        public DirectImportHomeView()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="DirectImportHomeView"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public DirectImportHomeView(DirectImportHomeViewModel viewModel)
        {
            this.InitializeComponent();
            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;

            eventAggregator = ServiceLocator.Current.GetInstance<IEventAggregator>();
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets ViewModel.
        /// </summary>
        public DirectImportHomeViewModel ViewModel
        {
            get
            {
                return (DirectImportHomeViewModel)this.DataContext;
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// The select folder event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The eevent args.
        /// </param>
        private void SelectFolder_Click(object sender, RoutedEventArgs e)
        {
            DialogService dialogService = new DialogService();

            string selectedPath = dialogService.ShowFolderBrowserDialog(System.Windows.Application.Current.MainWindow.GetIWin32Window());

            if (selectedPath != null)
            {
                this.ViewModel.Folder = selectedPath;
            }
        }

        #endregion
    }
}