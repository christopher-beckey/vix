/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 05/21/2013
 * Site Name:  Washington OI Field Office,Columbia, MD
 * Developer:  Lenard Williams
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

using System.Windows;
using System.Windows.Controls;

namespace DicomImporter.Views
{
    using System.Collections.ObjectModel;
    using DicomImporter.Common.Model;
    using DicomImporter.ViewModels;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Extensions;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// Interaction logic for NonDicomMediaView.xaml
    /// </summary>
    public partial class NonDicomMediaView
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ChooseExistingOrderView"/> class.
        /// </summary>
        public NonDicomMediaView()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChooseExistingOrderView"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public NonDicomMediaView(NonDicomMediaViewModel viewModel)
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
        public NonDicomMediaViewModel ViewModel
        {
            get
            {
                return (NonDicomMediaViewModel)this.DataContext;
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Handles the Click event of the btnAdd control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedEventArgs" /> instance containing the event data.</param>
        private void btnAdd_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            // string fileFilter = "Images (*.BMP;*.JPG;*.GIF;*.TIFF;*.PNG) |*.BMP;*.JPG;*.GIF;*.TIFF;*.PNG|" + "PDF's (*.PDF)|*.PDF|" + "All Files (*.*)|*.*";
            string fileFilter = "PDF Only (*.PDF)|*.PDF";

            DialogService dialogService = new DialogService();

            string[] selectedFiles = dialogService.ShowFileBrowserDialog(fileFilter, System.Windows.Application.Current.MainWindow.GetIWin32Window());

            // add selected files
            if (selectedFiles != null)
            {
                var files = new ObservableCollection<NonDicomFile>();

                foreach (string filePath in selectedFiles)
                {
                   files.Add(new NonDicomFile(filePath));
                }

                this.ViewModel.AddFiles(files);
            }
        }

        /// <summary>
        /// Handles the SelectionChanged event of the SelectedFiles control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.Controls.SelectionChangedEventArgs" /> instance containing the event data.</param>
        private void SelectedFiles_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            var selectedFiles = new ObservableCollection<NonDicomFile>();

            foreach (NonDicomFile file in this.dgNonDicomMedia.SelectedItems)
            {
                selectedFiles.Add(file);
            }

            this.ViewModel.SelectedFiles = selectedFiles;
        }

        /// <summary>
        /// Shows the scan document window.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The <see cref="RoutedEventArgs" /> instance containing the event data.</param>
        private void ShowScanDocumentWindow(object sender, RoutedEventArgs e)
        {
            var window = ServiceLocator.Current.GetInstance<ScanDocumentWindow>();
            window.ViewModel.UIDispatcher = this.Dispatcher;
            window.ViewModel.OwningWindow = window;
            window.Owner = Window.GetWindow(this);
            window.SubscribeToNewUserLogin();
            window.ShowDialog();

            // retrieves the location and name of the scanned in file
            NonDicomFile nonDicomFile = window.GetScannedFile();

            // add the scanned Non DICOM file to the rest of the list.
            if (nonDicomFile != null)
            {
                var nonDicomFiles = new ObservableCollection<NonDicomFile>();
                nonDicomFiles.Add(nonDicomFile);
                this.ViewModel.AddFiles(nonDicomFiles);
            }
        }

        /// <summary>
        /// Handles the Loaded event of the UserControl control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="RoutedEventArgs"/> instance containing the event data.</param>
        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            bool isMediaBundleStaged = false;

            if (this.ViewModel != null && this.ViewModel.WorkItemDetails != null)
            {
                // We have a work item details object, so query it for the staging status.
                isMediaBundleStaged = ViewModel.WorkItemDetails.IsMediaBundleStaged;
            }

            if (isMediaBundleStaged)
            {
                dgNonDicomMedia.Columns[1].Visibility = Visibility.Hidden;
            }
            else
            {
                dgNonDicomMedia.Columns[0].Width = DataGridLength.Auto;
            }
        }

        #endregion
    }
}