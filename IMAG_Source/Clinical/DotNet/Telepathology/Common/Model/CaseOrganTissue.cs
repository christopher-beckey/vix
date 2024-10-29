// -----------------------------------------------------------------------
// <copyright file="CaseOrganTissue.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: May 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: 
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
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Linq;
    using VistA.Imaging.Telepathology.Common.VixModels;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class CaseOrganTissue : INotifyPropertyChanged
    {
        public CaseOrganTissue()
        {
            this.OrganTissueList = new ObservableCollection<SnomedOrganTissue>();
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

        public ObservableCollection<SnomedOrganTissue> OrganTissueList { get; set; }

        public void InitializeList(PathologySnomedCodesType codeList)
        {
            if ((codeList == null) || (codeList.CodeList == null) || (codeList.CodeList.Count == 0))
            {
                return;
            }

            if (this.OrganTissueList == null)
            {
                this.OrganTissueList = new ObservableCollection<SnomedOrganTissue>();
            }
            this.OrganTissueList.Clear();

            // go through each code in the list and add it to appropriate level of hierarchy
            foreach (PathologySnomedCode code in codeList.CodeList)
            {
                // first search for the organ and tissue, update existing one or create new one
                var organ = this.OrganTissueList.Where(org => org.OrganName == code.OrganName).FirstOrDefault();
                
                if (organ == null)
                {
                    SnomedOrganTissue temp = new SnomedOrganTissue() { OrganID = code.OrganID, OrganName = code.OrganName, OrganCode = code.OrganCode };
                    this.ProcessOrgan(temp, code);
                    this.OrganTissueList.Add(temp);
                }
                else
                {
                    SnomedOrganTissue temp = (SnomedOrganTissue)organ;
                    this.ProcessOrgan(temp, code);
                }
            }
        }

        private void ProcessOrgan(SnomedOrganTissue organ, PathologySnomedCode code)
        {
            if ((organ == null) || (code == null))
            {
                return;
            }

            if (code.FieldType == "function")
            {
                organ.AddFunction(code.SnomedName, code.SnomedCode, code.SnomedID);
            }
            else if (code.FieldType == "procedure")
            {
                organ.AddProcedure(code.SnomedName, code.SnomedCode, code.SnomedID);
            }
            else if (code.FieldType == "disease")
            {
                organ.AddDisease(code.SnomedName, code.SnomedCode, code.SnomedID);
            }
            else if (code.FieldType == "morphology")
            {
                organ.AddMorphology(code.SnomedName, code.SnomedCode, code.SnomedID);

                // check if there's etiology to add
                if (!string.IsNullOrEmpty(code.EtiologySnomedName))
                {
                    var morph = organ.Morphologies.Where(mo => mo.MorphologyName == code.SnomedName).FirstOrDefault();
                    if (morph != null)
                    {
                        ((SnomedMorphology)morph).AddEtiology(code.EtiologySnomedName, code.EtiologySnomedCode, code.EtiologyID);
                    }
                }
            }
        }

        public void AddOrgan(string organName, string organCode, string organID = null)
        {
            if (string.IsNullOrEmpty(organName))
            {
                return;
            }

            string orgID = (organID == null) ? string.Empty : organID;

            if (this.OrganTissueList == null)
            {
                this.OrganTissueList = new ObservableCollection<SnomedOrganTissue>();
            }

            // check to see if the morphology is already in the list
            var organ = this.OrganTissueList.Where(org => org.OrganName == organName).FirstOrDefault();

            // only add new if there isn't one
            if (organ == null)
            {
                this.OrganTissueList.Add(new SnomedOrganTissue() { OrganName = organName, OrganCode = organCode, OrganID = orgID });
            }
        }

        public void RemoveEtiology(SnomedEtiology selectedEtiology)
        {
            if ((this.OrganTissueList != null) && (selectedEtiology != null))
            {
                // find the organ contains the etiology
                var organ = this.OrganTissueList.Where(org => org.OrganID == selectedEtiology.OrganID).FirstOrDefault();
                if (organ != null)
                {
                    // find the morphology contains the etiology
                    if (organ.Morphologies != null)
                    {
                        var morphology = organ.Morphologies.Where(morph => morph.MorphologyID == selectedEtiology.MorphologyID).FirstOrDefault();
                        if (morphology != null)
                        {
                            // find the etiology and remove it
                            if (morphology.Etiologies != null)
                            {
                                //var etiology = morphology.Etiologies.Where(eti => eti.EtiologyID == selectedEtiology.EtiologyID).FirstOrDefault();
                                //if (etiology != null)
                                //{
                                    //morphology.Etiologies.Remove(etiology);
                                    morphology.Etiologies.Remove(selectedEtiology);
                                //}
                            }
                        }
                    }
                }
            }
        }

        public void RemoveMorphology(SnomedMorphology selectedMorphology)
        {
            if ((this.OrganTissueList != null) && (selectedMorphology != null))
            {
                // find the organ contains the etiology
                var organ = this.OrganTissueList.Where(org => org.OrganID == selectedMorphology.OrganID).FirstOrDefault();
                if (organ != null)
                {
                    // find the morphology and remove it
                    if (organ.Morphologies != null)
                    {
                        //var morphology = organ.Morphologies.Where(morph => morph.MorphologyID == selectedMorphology.MorphologyID).FirstOrDefault();
                        //if (morphology != null)
                        //{
                        //    organ.Morphologies.Remove(morphology);
                        //}
                        organ.Morphologies.Remove(selectedMorphology);
                    }
                }
            }
        }

        public void RemoveFunction(SnomedFunction selectedFunction)
        {
            if ((this.OrganTissueList != null) && (selectedFunction != null))
            {
                // find the organ contains the etiology
                var organ = this.OrganTissueList.Where(org => org.OrganID == selectedFunction.OrganID).FirstOrDefault();
                if (organ != null)
                {
                    // find the function and remove it
                    if (organ.Functions != null)
                    {
                        //var function = organ.Functions.Where(func => func.FunctionID == selectedFunction.FunctionID).FirstOrDefault();
                        //if (function != null)
                        //{
                        //    organ.Functions.Remove(function);
                        //}
                        organ.Functions.Remove(selectedFunction);
                    }
                }
            }
        }

        public void RemoveProcedure(SnomedProcedure selectedProcedure)
        {
            if ((this.OrganTissueList != null) && (selectedProcedure != null))
            {
                // find the organ contains the etiology
                var organ = this.OrganTissueList.Where(org => org.OrganID == selectedProcedure.OrganID).FirstOrDefault();
                if (organ != null)
                {
                    // find the morphology and remove it
                    if (organ.Procedures != null)
                    {
                        //var procedure = organ.Procedures.Where(proc => proc.ProcedureID == selectedProcedure.ProcedureID).FirstOrDefault();
                        //if (procedure != null)
                        //{
                        //    organ.Procedures.Remove(procedure);
                        //}
                        organ.Procedures.Remove(selectedProcedure);
                    }
                }
            }
        }

        public void RemoveDisease(SnomedDisease selectedDisease)
        {
            if ((this.OrganTissueList != null) && (selectedDisease != null))
            {
                // find the organ contains the etiology
                var organ = this.OrganTissueList.Where(org => org.OrganID == selectedDisease.OrganID).FirstOrDefault();
                if (organ != null)
                {
                    // find the morphology and remove it
                    if (organ.Diseases != null)
                    {
                        //var disease = organ.Diseases.Where(dis => dis.DiseaseID == selectedDisease.DiseaseID).FirstOrDefault();
                        //if (disease != null)
                        //{
                        //    organ.Diseases.Remove(disease);
                        //}
                        organ.Diseases.Remove(selectedDisease);
                    }
                }
            }
        }

        public void RemoveOrganTissue(SnomedOrganTissue selectedOrgan)
        {
            if ((this.OrganTissueList != null) && (selectedOrgan != null))
            {
                // find the organ contains the etiology
                //var organ = this.OrganTissueList.Where(org => org.OrganID == selectedOrgan.OrganID).FirstOrDefault();
                //if (organ != null)
                //{
                //    this.OrganTissueList.Remove(organ);
                //}
                this.OrganTissueList.Remove(selectedOrgan);
            }
        }
    }
}
