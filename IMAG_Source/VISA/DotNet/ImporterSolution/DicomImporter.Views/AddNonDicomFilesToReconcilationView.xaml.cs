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
    using System.Collections.ObjectModel;
    using System.Windows;
    using DicomImporter.Common.Model;
    using DicomImporter.ViewModels;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Extensions;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// Interaction logic for PatientSelectionView.xaml
    /// </summary>
    public partial class AddNonDicomFilesToReconciliationView
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="PatientSelectionView"/> class.
        /// </summary>
        public AddNonDicomFilesToReconciliationView()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="PatientSelectionView"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public AddNonDicomFilesToReconciliationView(AddNonDicomFilesToReconciliationViewModel viewModel)
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
        public AddNonDicomFilesToReconciliationViewModel ViewModel
        {
            get
            {
                return (AddNonDicomFilesToReconciliationViewModel)this.DataContext;
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// BTNs the add existing non dicom file click.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The <see cref="RoutedEventArgs" /> instance containing the event data.</param>
        private void BtnAddExistingNonDicomFileClick(object sender, RoutedEventArgs e)
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
        /// Scans in Non DICOM files
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The <see cref="RoutedEventArgs" /> instance containing the event data.</param>
        private void BtnScanNewNonDicomFileClick(object sender, RoutedEventArgs e)
        {
            var window = ServiceLocator.Current.GetInstance<ScanDocumentWindow>();
            window.ViewModel.UIDispatcher = this.Dispatcher;
            window.ViewModel.OwningWindow = window;
            window.Owner = Window.GetWindow(this);
            window.SubscribeToNewUserLogin();
            window.ShowDialog();

            // retrieves the location and name of the scanned in file
            NonDicomFile nonDicomFile = window.GetScannedFile();

            // add the scanned Non DICOM file to the reconciled files list.
            if (nonDicomFile != null)
            {
                var nonDicomFiles = new ObservableCollection<NonDicomFile>();
                this.ViewModel.ReconciledNonDicomFiles.Add(nonDicomFile);
            }
        }

        #endregion

    }
}