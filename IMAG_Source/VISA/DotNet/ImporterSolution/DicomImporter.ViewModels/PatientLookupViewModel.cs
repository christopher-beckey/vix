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

namespace DicomImporter.ViewModels
{
    using System;
    using System.Collections.ObjectModel;

    using DicomImporter.Common.ViewModels;

    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Model;
    using ImagingClient.Infrastructure.PatientDataSource;

    using log4net;

    using Microsoft.Practices.Prism.Commands;


    /// <summary>
    /// The patient lookup view model.
    /// </summary>
    public class PatientLookupViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(PatientLookupViewModel));

        /// <summary>
        /// The patient.
        /// </summary>
        private Patient patient;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="PatientLookupViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="patientDataSource">
        /// The patient data source.
        /// </param>
        public PatientLookupViewModel(IDialogService dialogService, IPatientDataSource patientDataSource)
        {
            this.DialogService = dialogService;
            this.PatientDataSource = patientDataSource;

            this.PerformSearchCommand = new DelegateCommand<object>(o => this.PeformSearch());

            this.OkCommand = new DelegateCommand<object>(o => this.PeformOk(), o => this.IsOkButtonEnabled());

            this.CancelCommand = new DelegateCommand<object>(o => this.PeformCancel());
        }

        #endregion

        #region Delegates

        /// <summary>
        /// The no results action event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public delegate void NoResultsActionEventHandler(object sender, EventArgs e);

        /// <summary>
        /// The patient sensitivity event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public delegate void PatientSensitivityEventHandler(object sender, PatientSensitivityEventArgs e);

        /// <summary>
        /// The window action event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public delegate void WindowActionEventHandler(object sender, WindowActionEventArgs e);

        #endregion

        #region Public Events

        /// <summary>
        /// The no results action.
        /// </summary>
        public event NoResultsActionEventHandler NoResultsAction;

        /// <summary>
        /// The patient sensitivity handler.
        /// </summary>
        public event PatientSensitivityEventHandler PatientSensitivityHandler;

        /// <summary>
        /// The window action.
        /// </summary>
        public event WindowActionEventHandler WindowAction;

        #endregion


        #region Public Properties

        /// <summary>
        /// Gets or sets CancelCommand.
        /// </summary>
        public DelegateCommand<object> CancelCommand { get; set; }





        //Commented since binding element {NotifyPropertyWeaverMsBuildTask} is no longer available in VS 2015 and above versions. (p289-OITCOPondiS)
        ///// <summary>
        ///// Gets or sets MatchingPatients.
        ///// </summary>
        //public ObservableCollection<Patient> MatchingPatients { get; set; }

        //BEGIN-Modified MatchingPatients property to bind control. Earlier binding made through imlementing library {NotifyPropertyWeaverMsBuildTask}.(p289-OITCOPondiS) 
        private ObservableCollection<Patient> _MatchingPatients { get; set; }

        /// <summary>
        /// Gets or sets MatchingPatients.
        /// </summary>
        public ObservableCollection<Patient> MatchingPatients
        {
            get { return _MatchingPatients; }
            set {

                _MatchingPatients = value;
                this.RaisePropertyChanged("MatchingPatients");               
            }
        }
        //END


        /// <summary>
        /// Gets or sets OkCommand.
        /// </summary>
        public DelegateCommand<object> OkCommand { get; set; }

        /// <summary>
        /// Gets or sets PerformSearchCommand.
        /// </summary>
        public DelegateCommand<object> PerformSearchCommand { get; set; }

        /// <summary>
        /// Gets or sets SearchCriteria.
        /// </summary>
        public string SearchCriteria { get; set; }

        /// <summary>
        /// Gets or sets SelectedPatient.
        /// </summary>
        public Patient SelectedPatient
        {
            get
            {
                return this.patient;
            }

            set
            {
                this.patient = value;
                this.OkCommand.RaiseCanExecuteChanged();
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Logs sensitive patient access.
        /// </summary>
        public void LogSensitivePatientAccess()
        {
            PatientDataSource.LogSensitivePatientAccess(this.SelectedPatient.Dfn);
        }

        /// <summary>
        /// Determines whether the OK button is enabled.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if the OK button is enabled; otherwise, <c>false</c>.
        /// </returns>
        private bool IsOkButtonEnabled()
        {
            return this.SelectedPatient != null;
        }

        /// <summary>
        /// The peform cancel.
        /// </summary>
        private void PeformCancel()
        {
            this.WindowAction(this, new WindowActionEventArgs(false));
        }

        /// <summary>
        /// The peform ok.
        /// </summary>
        private void PeformOk()
        {
            try
            {
                // Get the patient sensitivity level and let the view handle the interaction
                PatientSensitiveLevel level = this.PatientDataSource.GetPatientSensitivityLevel(this.SelectedPatient.Dfn);
                this.PatientSensitivityHandler(this, new PatientSensitivityEventArgs(level));
            }
            catch (Exception e)
            {
                string message = "Unable to perform patient sensitivity processing. " + e.Message;
                Logger.Error(message);
                this.DialogService.ShowAlertBox(
                    this.UIDispatcher, message, "Patient Sensitivity Check Failed", MessageTypes.Warning);
                this.WindowAction(this, new WindowActionEventArgs(false));
            }
        }

        /// <summary>
        /// The peform search.
        /// </summary>
        private void PeformSearch()
        {
            this.MatchingPatients = this.PatientDataSource.GetPatientList(this.SearchCriteria);
            if (this.MatchingPatients.Count == 0)
            {
                this.NoResultsAction(this, null);
            }
        }

        #endregion
    }
}