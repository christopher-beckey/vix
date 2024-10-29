// -----------------------------------------------------------------------
// <copyright file="SnomedMorphology.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Aug 2012
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
    using System;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Linq;

    public class SnomedEtiology : INotifyPropertyChanged
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

        public string MorphologyID { get; set; }

        public string EtiologyID { get; set; }

        public string EtiologyCode { get; set; }
        
        public string EtiologyName { get; set; }
        
        public string Display
        {
            get
            {
                return String.Format("{0} {1}", this.EtiologyName, this.EtiologyCode);
            }
        }
    }


    public class SnomedMorphology : INotifyPropertyChanged
    {
        public SnomedMorphology()
        {
            this.OrganID = string.Empty;
            this.MorphologyID = string.Empty;
            this.MorphologyCode = string.Empty;
            this.MorphologyName = string.Empty;
            this.Etiologies = new ObservableCollection<SnomedEtiology>();
        }

        public SnomedMorphology(string organID, string morphologyID, string morphologyName, string morphologyCode)
        {
            this.OrganID = organID;
            this.MorphologyID = morphologyID;
            this.MorphologyCode = morphologyCode;
            this.MorphologyName = morphologyName;
            this.Etiologies = new ObservableCollection<SnomedEtiology>();
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
        public string MorphologyID { get; set; }
        public string MorphologyCode { get; set; }
        public string MorphologyName { get; set; }

        public string Display
        {
            get
            {
                return String.Format("{0} {1}", this.MorphologyName, this.MorphologyCode);
            }
        }

        public ObservableCollection<SnomedEtiology> Etiologies { get; set; }

        public void AddEtiology(string etiologyName, string etiologyCode = null, string etiologyId = null)
        {
            if (string.IsNullOrEmpty(etiologyName))
            {
                return;
            }

            string etiCode = (etiologyCode == null) ? string.Empty : etiologyCode;

            string etiID = (etiologyId == null) ? string.Empty : etiologyId;

            if (this.Etiologies == null)
            {
                this.Etiologies = new ObservableCollection<SnomedEtiology>();
            }

            // check to see if the etiology is already in the list
            var etiology = this.Etiologies.Where(eti => eti.EtiologyID == etiologyId).FirstOrDefault();

            // only add new if there isn't one
            if (etiology == null)
            {
                this.Etiologies.Add(new SnomedEtiology() { EtiologyCode = etiCode, EtiologyName = etiologyName, EtiologyID = etiID, OrganID = this.OrganID, MorphologyID = this.MorphologyID });
            }
        }
    }
}
