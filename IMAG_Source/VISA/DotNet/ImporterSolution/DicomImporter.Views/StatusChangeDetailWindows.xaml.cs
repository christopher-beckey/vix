/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/20/2013
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
    using System;
    using System.Windows;
    using System.Collections.ObjectModel;
    using DicomImporter.Common.Model;
    using DicomImporter.ViewModels;
    using ImagingClient.Infrastructure.Events;

    /// <summary>
    /// Interaction logic for StatusChangeDetailsWindow.xaml
    /// </summary>
    public partial class StatusChangeDetailsWindow
    {
        #region Constants and Fields

        /// <summary>
        /// True if the window has been opened
        /// </summary>
        private bool isWindowOpened;

        /// <summary>
        /// True if the window is currently opening
        /// </summary>
        private bool windowOpening;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="StatusChangeDetailsWindow"/> class.
        /// </summary>
        public StatusChangeDetailsWindow() : base()
        {
            this.InitializeComponent();

            this.windowOpening = false;
            this.isWindowOpened = false;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="StatusChangeDetailsWindow"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public StatusChangeDetailsWindow(StatusChangeDetailsViewModel viewModel) : base()
        {
            this.InitializeComponent();
            lbMessageText.Visibility = Visibility.Hidden;

            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;

            this.windowOpening = false;
            this.isWindowOpened = false;

            this.ViewModel.WindowAction += this.HandleWindowAction;
            this.ViewModel.ReadingImageTimer.Tick += Timer_Tick;
            this.ViewModel.ReadingImageTimerStopped += Timer_Stopped;

        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets ViewModel.
        /// </summary>
        public StatusChangeDetailsViewModel ViewModel
        {
            get
            {
                return (StatusChangeDetailsViewModel)this.DataContext;
            }
        }

        #endregion

        #region Events

        /// <summary>
        /// Handles the SelectionChanged event of the comboBoxDiagnosticCodes control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.Controls.SelectionChangedEventArgs" /> instance containing the event data.</param>
        private void DiagnosticCodes_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            if (this.comboBoxDiagnosticCodes.SelectedItem != null)
            {
                this.listBoxSecondaryDiagnosticCodes.IsEnabled = true;
            }
            else
            {
                this.listBoxSecondaryDiagnosticCodes.IsEnabled = false;
            }

            listBoxSecondaryDiagnosticCodes.SelectedItems.Clear();
        }

        /// <summary>
        /// The handle window action.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The e.</param>
        private void HandleWindowAction(object sender, WindowActionEventArgs e)
        {
            if (e.IsOk)
            {
                this.DialogResult = true;
            }
            else
            {
                this.Close(null);
            }
        }

        /// <summary>
        /// Handles the SelectionChanged event of the ExamStatuses control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.Controls.SelectionChangedEventArgs" /> instance containing the event data.</param>
        private void ExamStatuses_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            if (this.comboBoxExamStatuses.SelectedItem != null)
            {
                //Commented for possible null reference(p289-OITCOPondiS)
                //string status = (this.comboBoxExamStatuses.SelectedItem as ExamStatus).Status;

                //BEGIN-Fortify Mitigation recommendation for Null Dereference.Modified logic to handle chances of raisng null exception.(p289-OITCOPondiS)
                string status = string.Empty;
                ExamStatus oExamStatus = new ExamStatus();
                oExamStatus = this.comboBoxExamStatuses.SelectedItem as ExamStatus;
                if (oExamStatus != new ExamStatus() && oExamStatus != null  && !string.IsNullOrEmpty(oExamStatus.Status))
                {
                    status = oExamStatus.Status;
                }                
                //END

                if (ExamStatuses.IsCompletedStatus(status))
                {
                    this.comboBoxDiagnosticCodes.IsEnabled = true;
                    this.comboBoxStandardReports.IsEnabled = true;
              //      this.listBoxSecondaryDiagnosticCodes.IsEnabled = true;

                    this.labelExamStatusNotification.Visibility = System.Windows.Visibility.Collapsed;
                    this.textBoxStandardReportText.IsReadOnly = false;
                    this.textBoxStandardReportImpression.IsReadOnly = false;
                    this.ViewModel.ManuallyEnteredText = "1";
                }
                else
                {
                    this.comboBoxDiagnosticCodes.SelectedItem = null;
                    this.comboBoxStandardReports.SelectedItem = null;
                    listBoxSecondaryDiagnosticCodes.SelectedItems.Clear();

                    this.comboBoxDiagnosticCodes.IsEnabled = false;
                    this.comboBoxStandardReports.IsEnabled = false;
                    this.listBoxSecondaryDiagnosticCodes.IsEnabled = false;

                    this.labelExamStatusNotification.Visibility = System.Windows.Visibility.Visible;
                    this.textBoxStandardReportText.IsReadOnly = true;
                    this.textBoxStandardReportImpression.IsReadOnly = true;
                    this.ViewModel.ManuallyEnteredText = string.Empty;
                }
            }
        }

        /// <summary>
        /// Handles the SelectionChanged event of the SecondaryDiagnosticCodes control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.Controls.SelectionChangedEventArgs" /> instance containing the event data.</param>
        private void SecondaryDiagnosticCodes_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            if (!this.windowOpening)
            {
                var selectedCodes = new ObservableCollection<DiagnosticCode>();

                foreach (DiagnosticCode code in this.listBoxSecondaryDiagnosticCodes.SelectedItems)
                {
                    selectedCodes.Add(code);
                }

                this.ViewModel.SelectedSecondaryDiagnosticCodes = selectedCodes;
            }
        }

        /// <summary>
        /// Handles the Activated event of the Window control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs" /> instance containing the event data.</param>
        private void Window_Activated(object sender, System.EventArgs e)
        {
            var secondaryDiagnosticCodes = this.ViewModel.SelectedSecondaryDiagnosticCodes;
            this.windowOpening = true;

            if (!isWindowOpened && secondaryDiagnosticCodes != null)
            {
                foreach (DiagnosticCode code in secondaryDiagnosticCodes)
                {
                    this.listBoxSecondaryDiagnosticCodes.SelectedItems.Add(code);
                }

                this.isWindowOpened = true;
            }

            this.windowOpening = false;
        }

        private void Timer_Tick(object sender, EventArgs e)
        {
            lbMessageText.Visibility = lbMessageText.Visibility == Visibility.Visible
               ? Visibility.Hidden : Visibility.Visible;
        }

        private void Timer_Stopped(object sender, EventArgs e)
        {
            lbMessageText.Visibility = Visibility.Hidden;
        }
        #endregion
    }
}