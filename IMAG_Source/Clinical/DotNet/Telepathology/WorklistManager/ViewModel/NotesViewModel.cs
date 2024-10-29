// -----------------------------------------------------------------------
// <copyright file="NotesViewModel.cs" company="Patriot Technologies">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Worklist.ViewModel
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using VistA.Imaging.Telepathology.CCOW;
    using VistA.Imaging.Telepathology.Worklist.DataSource;
    using VistA.Imaging.Telepathology.Common.Model;
    using GalaSoft.MvvmLight.Command;
    using VistA.Imaging.Telepathology.Common.Exceptions;
    using VistA.Imaging.Telepathology.Logging;
    using System.Windows;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class NotesViewModel : WorkspaceViewModel
    {
        private static MagLogger Log = new MagLogger(typeof(NotesViewModel));

        public string PatientID { get; set; }

        public string PatientName { get; set; }

        public string AccessionNr { get; set; }

        public string Details { get; set; }

        public string SavedNotes { get; set; }

        //private string savedContent { get; set; }

        public PatientContextState CCOWContextState { get; set; }

        private Patient Patient { get; set; }

        private string CaseURN { get; set; }

        private string SiteCode { get; set; }

        private IWorkListDataSource DataSource { get; set; }

        public bool IsModified
        {
            get
            {
                if (!string.IsNullOrWhiteSpace(this.Details))
                {
                    return true;
                }

                return false;
            }
        }

        public NotesViewModel(IWorkListDataSource dataSource, string siteCode, string patientICN, string patientID, string accessionNr, string caseURN, bool readOnly = false)
        {
            this.PatientID = patientID;
            this.AccessionNr = accessionNr;
            this.CaseURN = caseURN;
            this.SiteCode = siteCode;
            this.DataSource = dataSource;
            this.IsReadOnly = readOnly;

            // get patient information
            this.Patient = dataSource.GetPatient(siteCode, patientICN);
            if (this.Patient != null)
            {
                this.PatientName = this.Patient.PatientName;

                // CCOW set patient context
                IContextManager contextManager = ViewModelLocator.ContextManager;
                contextManager.SetCurrentPatient(this.Patient);
                this.CCOWContextState = contextManager.GetPatientContextState(this.Patient);

                // get notified of CCOW context state change events
                contextManager.PropertyChanged += new System.ComponentModel.PropertyChangedEventHandler(contextManager_PropertyChanged);
            }

            this.SavedNotes = dataSource.GetNotes(this.CaseURN);
            //this.savedContent = this.Details;
            this.Details = string.Empty;
            this.SaveCommand = new RelayCommand(SaveNotes, () => !this.IsReadOnly);
        }

        void contextManager_PropertyChanged(object sender, System.ComponentModel.PropertyChangedEventArgs e)
        {
            if (e.PropertyName == "ContextState")
            {
                IContextManager contextManager = ViewModelLocator.ContextManager;
                this.CCOWContextState = contextManager.GetPatientContextState(this.Patient);
            }
        }

        #region Commands

        #region Save Command

        public RelayCommand SaveCommand { get; private set; }

        private void SaveNotes()
        {
            try
            {
                this.DataSource.SaveNotes(this.CaseURN, this.Details.Trim());
                //this.savedContent = this.Details.Trim();
                this.Details = string.Empty;
                this.SavedNotes = DataSource.GetNotes(this.CaseURN);


                Log.Info("Saved note changes for case " + this.AccessionNr + " at site " + this.SiteCode);
            }
            catch (MagVixFailureException vfe)
            {
                Log.Error("Failed to save notes.", vfe);
                MessageBox.Show("Failed to save notes to VistA.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public override void Close()
        {
            base.Close();
        }
        #endregion

        #endregion

        public bool IsReadOnly { get; set; }
    }
}
