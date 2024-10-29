// -----------------------------------------------------------------------
// <copyright file="HealthSummaryViewModel.cs" company="Patriot Technologies">
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

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class HealthSummaryViewModel : WorkspaceViewModel
    {
        public string PatientID { get; set; }

        public string PatientName { get; set; }

        public string SiteName { get; set; }

        public string HealthSummaryType { get; set; }

        public string Details { get; set; }

        public PatientContextState CCOWContextState { get; set; }

        private Patient Patient { get; set; }

        public HealthSummaryViewModel(IWorkListDataSource dataSource, string siteName, string siteCode, string patientICN, string patientID, HealthSummaryType healthSummaryType)
        {
            this.SiteName = healthSummaryType.SiteID;
            this.HealthSummaryType = healthSummaryType.Name;
            this.PatientID = patientID;

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

            this.Details = dataSource.GetHealthSummary(patientICN, healthSummaryType.ID);
        }

        void contextManager_PropertyChanged(object sender, System.ComponentModel.PropertyChangedEventArgs e)
        {
            if (e.PropertyName == "ContextState")
            {
                IContextManager contextManager = ViewModelLocator.ContextManager;
                this.CCOWContextState = contextManager.GetPatientContextState(this.Patient);
            }
        }
    }
}
