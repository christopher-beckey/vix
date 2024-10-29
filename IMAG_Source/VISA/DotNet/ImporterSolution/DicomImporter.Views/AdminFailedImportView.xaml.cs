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
    using System;
    using System.ComponentModel;
    using System.Windows.Controls;

    using DicomImporter.ViewModels;

    /// <summary>
    /// Interaction logic for ImporterWorkListView.xaml
    /// </summary>
    public partial class AdminFailedImportView
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="AdminFailedImportView"/> class.
        /// </summary>
        public AdminFailedImportView()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AdminFailedImportView"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public AdminFailedImportView(AdminFailedImportViewModel viewModel)
        {
            this.InitializeComponent();
            this.ViewModel = viewModel;
            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;
        }

        #endregion

        /// <summary>
        /// Gets or sets the view model.
        /// </summary>
        /// <value>
        /// The view model.
        /// </value>
        protected AdminFailedImportViewModel ViewModel { get; set; }

//        public void ViewModelPropertyChangedListener(object sender, PropertyChangedEventArgs e)
//        {
//            if (e.PropertyName.Equals("ImporterErrorSummaryText"))
//            {
//                string tempString = this.ViewModel.ImporterErrorSummaryText;
//                this.webBrowser.NavigateToString(tempString);
//            }
//        }
    }
}