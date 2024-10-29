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
    using System.Windows;
    using DicomImporter.Common.Model;
    using DicomImporter.ViewModels;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// Interaction logic for StudyListView.xaml
    /// </summary>
    public partial class StudyListView
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="StudyListView"/> class.
        /// </summary>
        public StudyListView()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="StudyListView"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public StudyListView(StudyListViewModel viewModel)
        {
            this.InitializeComponent();
            this.DataContext = viewModel;
            viewModel.UIDispatcher = this.Dispatcher;
            ((StudyListViewModel)this.DataContext).ShowStudyDetails += this.ShowStudyDetails;
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
            if (this.dgStudyList.SelectedItem != null)
            {
                this.dgStudyList.ScrollIntoView(this.dgStudyList.SelectedItem);
            }
        }

        /// <summary>
        /// The show study details.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void ShowStudyDetails(object sender, EventArgs e)
        {
            Study selectedStudy = ((StudyListViewModel)this.DataContext).WorkItemDetails.CurrentStudy;
            var window = ServiceLocator.Current.GetInstance<DicomViewerLauncherWindow>("DicomViewerLauncherWindow");
            window.ViewModel.SelectedStudy = selectedStudy;
            window.ViewModel.OwningWindow = window;
            window.ViewModel.WorkItem = ((StudyListViewModel)this.DataContext).WorkItem;
            window.ViewModel.UIDispatcher = this.Dispatcher;
            window.Owner = Window.GetWindow(this);
            window.SubscribeToNewUserLogin();
            window.ShowDialog();
        }

        #endregion
    }
}