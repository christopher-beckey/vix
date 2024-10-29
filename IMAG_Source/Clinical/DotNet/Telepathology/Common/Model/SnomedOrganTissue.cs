// -----------------------------------------------------------------------
// <copyright file="SnomedOrganTissue.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Jul 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: A list contains all the snomed information about organ/tissue for a case
//        ;; +--------------------------------------------------------------------+
//        ;; Property of the US Government.
//        ;; No permission to copy or redistribute this software is given.
//        ;; Use of unreleased versions of this software requires the user
//        ;;  to execute a written test agreement with the VistA Imaging
//        ;;  Development Office of the Department of Veterans Affairs,
//        ;;  telephone (301) 734-0100.
//        ;;
//        ;; The Food and Drug Administration classifies this software as
//        ;; a Class II medical device.  As such, it may not be changed
//        ;; in any way.  Modifications to this software may result in an
//        ;; adulterated medical device under 21CFR820, the use of which
//        ;; is considered to be a violation of US Federal Statutes.
//        ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Common.Model
{
    using System;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Linq;

    public class SnomedFunction : INotifyPropertyChanged
    {
        /// <remarks>
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
        /// <summary>
        /// Event to be raised when a property is changed
        /// </summary>
#pragma warning disable 0067
        // Warning disabled because the event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        public string OrganID { get; set; }
        public string FunctionID { get; set; }
        public string FunctionCode { get; set; }
        public string FunctionName { get; set; }
        public string Display
        {
            get
            {
                return String.Format("{0} {1}", this.FunctionName, this.FunctionCode);
            }
        }
    }

    public class SnomedProcedure : INotifyPropertyChanged
    {
        /// <remarks>
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
        /// <summary>
        /// Event to be raised when a property is changed
        /// </summary>
#pragma warning disable 0067
        // Warning disabled because the event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        public string OrganID { get; set; }
        public string ProcedureID { get; set; }
        public string ProcedureCode { get; set; }
        public string ProcedureName { get; set; }
        public string Display
        {
            get
            {
                return String.Format("{0} {1}", this.ProcedureName, this.ProcedureCode);
            }
        }
    }

    public class SnomedDisease : INotifyPropertyChanged
    {
        /// <remarks>
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
        /// <summary>
        /// Event to be raised when a property is changed
        /// </summary>
#pragma warning disable 0067
        // Warning disabled because the event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        public string OrganID { get; set; }
        public string DiseaseID { get; set; }
        public string DiseaseCode { get; set; }
        public string DiseaseName { get; set; }
        public string Display
        {
            get
            {
                return String.Format("{0} {1}", this.DiseaseName, this.DiseaseCode);
            }
        }
    }

    public class SnomedOrganTissue : INotifyPropertyChanged
    {
        public SnomedOrganTissue()
        {
            this.OrganID = string.Empty;
            this.OrganName = string.Empty;

            this.Morphologies = new ObservableCollection<SnomedMorphology>();
            this.Functions = new ObservableCollection<SnomedFunction>();
            this.Procedures = new ObservableCollection<SnomedProcedure>();
            this.Diseases = new ObservableCollection<SnomedDisease>();
        }

        /// <remarks>
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
        /// <summary>
        /// Event to be raised when a property is changed
        /// </summary>
#pragma warning disable 0067
        // Warning disabled because the event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        public string OrganID { get; set; }
        public string OrganCode { get; set; }
        public string OrganName { get; set; }
        public string Display
        {
            get
            {
                return String.Format("{0} {1}", this.OrganName, this.OrganCode);
            }
        }

        public ObservableCollection<SnomedFunction> Functions { get; set; }

        public ObservableCollection<SnomedProcedure> Procedures { get; set; }

        public ObservableCollection<SnomedDisease> Diseases { get; set; }

        public ObservableCollection<SnomedMorphology> Morphologies { get; set; }

        public void AddMorphology(string morphologyName, string morphologyCode, string morphologyID = null)
        {
            if (string.IsNullOrEmpty(morphologyName))
            {
                return;
            }

            string morhID = (morphologyID == null) ? string.Empty : morphologyID;

            if (this.Morphologies == null)
            {
                this.Morphologies = new ObservableCollection<SnomedMorphology>();
            }

            // check to see if the morphology is already in the list
            var morphology = this.Morphologies.Where(morph => morph.MorphologyName == morphologyName).FirstOrDefault();

            // only add new if there isn't one
            if (morphology == null)
            {
                this.Morphologies.Add(new SnomedMorphology(this.OrganID, morhID, morphologyName, morphologyCode));
            }
        }

        public void AddFunction(string functionName, string functionCode, string functionID = null)
        {
            if (string.IsNullOrEmpty(functionName))
            {
                return;
            }

            string funcCode = (functionCode == null) ? string.Empty : functionCode;

            string funcID = (functionID == null) ? string.Empty : functionID;

            if (this.Functions == null)
            {
                this.Functions = new ObservableCollection<SnomedFunction>();
            }

            // check to see if the function is already in the list
            var function = this.Functions.Where(func => func.FunctionName == functionName).FirstOrDefault();

            // only add new if there isn't one
            if (function == null)
            {
                this.Functions.Add(new SnomedFunction() { FunctionCode = funcCode, FunctionName = functionName, FunctionID = funcID, OrganID = this.OrganID });
            }
        }

        public void AddProcedure(string procedureName, string procedureCode, string procedureID = null)
        {
            if (string.IsNullOrEmpty(procedureName))
            {
                return;
            }

            string procCode = (procedureCode == null) ? string.Empty : procedureCode;

            string procID = (procedureID == null) ? string.Empty : procedureID;

            if (this.Procedures == null)
            {
                this.Procedures = new ObservableCollection<SnomedProcedure>();
            }

            // check to see if the procedure is already in the list
            var procedure = this.Procedures.Where(proc => proc.ProcedureName == procedureName).FirstOrDefault();

            // only add new if there isn't one
            if (procedure == null)
            {
                this.Procedures.Add(new SnomedProcedure() { ProcedureCode = procCode, ProcedureName = procedureName, ProcedureID = procID, OrganID = this.OrganID });
            }
        }

        public void AddDisease(string diseaseName, string diseaseCode, string diseaseID = null)
        {
            if (string.IsNullOrEmpty(diseaseName))
            {
                return;
            }

            string diseaCode = (diseaseCode == null) ? string.Empty : diseaseCode;

            string diseaID = (diseaseID == null) ? string.Empty : diseaseID;

            if (this.Diseases == null)
            {
                this.Diseases = new ObservableCollection<SnomedDisease>();
            }

            // check to see if the procedure is already in the list
            var disease = this.Diseases.Where(dis => dis.DiseaseName == diseaseName).FirstOrDefault();

            // only add new if there isn't one
            if (disease == null)
            {
                this.Diseases.Add(new SnomedDisease() { DiseaseCode = diseaCode, DiseaseName = diseaseName, DiseaseID = diseaID, OrganID = this.OrganID });
            }
        }
    }
}
