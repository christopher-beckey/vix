/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 06/25/2013
 * Site Name:  Washington OI Field Office, Silver Spring, MD
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
namespace DicomImporter.Views
{
    using DicomImporter.Common.Model;
    using DicomImporter.ViewModels;
    using ImagingClient.Infrastructure.Events;

    /// <summary>
    /// Interaction logic for ScanDocumentWindow.xaml
    /// </summary>
    public partial class ScanDocumentWindow
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ScanDocumentWindow"/> class.
        /// </summary>
        public ScanDocumentWindow() : base()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ScanDocumentWindow"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public ScanDocumentWindow(ScanDocumentViewModel viewModel) : base()
        {
            this.InitializeComponent();
            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;

            this.ViewModel.WindowAction += this.HandleWindowAction;
        }

        #endregion
        
        #region Public Methods

        /// <summary>
        /// Gets the scanned file.
        /// </summary>
        /// <returns></returns>
        public NonDicomFile GetScannedFile()
        {
            return this.ViewModel.GetScannedFile();
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets ViewModel.
        /// </summary>
        public ScanDocumentViewModel ViewModel
        {
            get
            {
                return (ScanDocumentViewModel)this.DataContext;
            }
        }

        #endregion
        
        #region Events

        /// <summary>
        /// Handles the TextChanged event of the FileName control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.Controls.TextChangedEventArgs" /> instance containing the event data.</param>
        private void FileName_TextChanged(object sender, System.Windows.Controls.TextChangedEventArgs e)
        {
            // Did not use binding because I need to notify the viewmodel prior to the setter running when binding.
            this.ViewModel.FileName = tbFileName.Text;
        }

        /// <summary>
        /// The handle window action.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The e.</param>
        private void HandleWindowAction(object sender, WindowActionEventArgs e)
        {
            if (!e.IsOk)
            {
                this.Close(null);
            }
        }

        /// <summary>
        /// Raises the <see cref="E:System.Windows.Window.Closing" /> event.
        /// </summary>
        /// <param name="e">A <see cref="T:System.ComponentModel.CancelEventArgs" /> that contains the event data.</param>
        protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            this.ViewModel.CloseTwainSource();
            base.OnClosing(e);
        }

        #endregion

    }
}