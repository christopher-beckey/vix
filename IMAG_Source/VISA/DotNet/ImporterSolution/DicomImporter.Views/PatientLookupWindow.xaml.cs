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
    using DicomImporter.ViewModels;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Model;

    /// <summary>
    /// Interaction logic for StudyDetailsView.xaml
    /// </summary>
    public partial class PatientLookupWindow
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="PatientLookupWindow"/> class.
        /// </summary>
        public PatientLookupWindow()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="PatientLookupWindow"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public PatientLookupWindow(PatientLookupViewModel viewModel) : base()
        {
            this.InitializeComponent();
            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;
            this.ViewModel.WindowAction += this.HandleWindowAction;
            this.ViewModel.NoResultsAction += this.OnNoResults;
            this.ViewModel.PatientSensitivityHandler += this.OnPatientSensitivity;

            TxtSearchCriteria.Focus();
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets ViewModel.
        /// </summary>
        public PatientLookupViewModel ViewModel
        {
            get
            {
                return (PatientLookupViewModel)this.DataContext;
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// The on no results.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public void OnNoResults(object sender, EventArgs e)
        {
            MessageBox.Show(
                this, 
                "No patients were found that matched your search criteria.", 
                "No Patients Found", 
                MessageBoxButton.OK, 
                MessageBoxImage.Information);
        }

        /// <summary>
        /// The on patient sensitivity.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="args">
        /// The args.
        /// </param>
        public void OnPatientSensitivity(object sender, PatientSensitivityEventArgs args)
        {
            string level = args.PatientSensitiveLevel.SensitiveLevel;

            if (level.Equals(PatientSensitiveLevels.NoActionRequired))
            {
                // No action necessary, just accept their choice
                this.DialogResult = true;
            }

            if (level.Equals(PatientSensitiveLevels.DisplayWarning))
            {
                // Display a warning but then go ahead and accept the choice with no
                // further action
                this.ShowWarning(args);
                this.ViewModel.LogSensitivePatientAccess();
                this.DialogResult = true;
            }

            if (level.Equals(PatientSensitiveLevels.DisplayWarningRequireOk))
            {
                // Display a warning. If the user says OK, accept the choice. If the user says Cancel,
                // stay on the search screen and do not accept the choice.
                PatientSensitivityWarningWindow warningWindow = new PatientSensitivityWarningWindow(args.PatientSensitiveLevel.WarningMessage);
                warningWindow.Owner = this;
                warningWindow.SubscribeToNewUserLogin();
                warningWindow.ShowDialog();

                if (warningWindow.WarningAccepted)
                {
                    this.ViewModel.LogSensitivePatientAccess();
                    this.DialogResult = true;
                }
            }

            if (level.Equals(PatientSensitiveLevels.DisplayWarningCannotContinue)
                || level.Equals(PatientSensitiveLevels.AccessDenied)
                || level.Equals(PatientSensitiveLevels.DataSourceFailure))
            {
                // Display the error message, and stay on the search screen. Do not accept the user's choice.
                this.ShowError(args);
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// The handle window action.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
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
        /// The show error.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        private void ShowError(PatientSensitivityEventArgs args)
        {
            MessageBox.Show(
                args.PatientSensitiveLevel.WarningMessage, 
                "Patient Sensitivity", 
                MessageBoxButton.OK, 
                MessageBoxImage.Error);
        }

        /// <summary>
        /// The show warning.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        private void ShowWarning(PatientSensitivityEventArgs args)
        {
            MessageBox.Show(
                args.PatientSensitiveLevel.WarningMessage, 
                "Patient Sensitivity", 
                MessageBoxButton.OK, 
                MessageBoxImage.Warning);
        }

        #endregion
    }
}