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
    using System.Collections.ObjectModel;
    using System.Windows;
    using System.Windows.Controls;

    using DicomImporter.Common.Model;
    using DicomImporter.ViewModels;

    using Microsoft.Practices.ServiceLocation;
    using System.Threading;

    /// <summary>
    /// Interaction logic for MediaStagingView.xaml
    /// </summary>
    public partial class MediaStagingView
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="MediaStagingView"/> class.
        /// </summary>
        public MediaStagingView()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MediaStagingView"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public MediaStagingView(MediaStagingViewModel viewModel)
        {
            this.InitializeComponent();
            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;
            this.ViewModel.ShowStudyDetails += this.ShowStudyDetails;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets ViewModel.
        /// </summary>
        public MediaStagingViewModel ViewModel
        {
            get
            {
                return (MediaStagingViewModel)this.DataContext;
            }
        }

        #endregion

        #region Methods

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
            // Study selectedStudy = ViewModel.SelectedStudies[0];
            // StudyDetailsWindow window = ServiceLocator.Current.GetInstance<StudyDetailsWindow>("StudyDetailsWindow");
            // window.ViewModel.Studies = new ObservableCollection<Study> { selectedStudy };
            // window.ViewModel.Patient = ViewModel.Patient;
            // window.ViewModel.WorkItem = ViewModel.WorkItem;
            // window.Owner = Window.GetWindow(this);
            // window.ShowDialog();
            Study selectedStudy = this.ViewModel.SelectedStudies[0];
            var window = ServiceLocator.Current.GetInstance<DicomViewerLauncherWindow>("DicomViewerLauncherWindow");
            window.ViewModel.SelectedStudy = selectedStudy;
            window.ViewModel.WorkItem = this.ViewModel.WorkItem;
            window.ViewModel.UIDispatcher = this.Dispatcher;
            window.ViewModel.OwningWindow = window;
            window.Owner = Window.GetWindow(this);
            window.SubscribeToNewUserLogin();
            window.ShowDialog();
        }

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

            window.SubscribeToNewUserLogin();
            window.ShowDialog();
            
            if (window.DialogResult.HasValue && window.DialogResult.Value)
            {
                this.ViewModel.Patient = window.ViewModel.SelectedPatient;
            }
        }

        /// <summary>
        /// The btn deselect all_ click.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void DeselectAll_Click(object sender, RoutedEventArgs e)
        {
            var selectedStudies = new ObservableCollection<Study>();
            this.studyList.SelectedItems.Clear();
            this.ViewModel.SelectedStudies = selectedStudies;
        }

        /// <summary>
        /// The btn select all_ click.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void SelectAll_Click(object sender, RoutedEventArgs e)
        {
            var selectedStudies = new ObservableCollection<Study>();

            foreach (Study study in this.studyList.Items)
            {
                selectedStudies.Add(study);
            }

            this.studyList.SelectAll();
            this.ViewModel.SelectedStudies = selectedStudies;
        }

        /// <summary>
        /// The study list_ selection changed.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void StudyList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            var selectedStudies = new ObservableCollection<Study>();
            foreach (Study study in this.studyList.SelectedItems)
            {
                selectedStudies.Add(study);
            }

            this.ViewModel.SelectedStudies = selectedStudies;

            // delay needed to prevent the selection of a study from selecting more than one study when displaying 
            // messages and only one study was selected.
            Thread.Sleep(500);
            
            this.ViewModel.ShowHideAdvancedStagingMessage();
        }

        #endregion
    }
}