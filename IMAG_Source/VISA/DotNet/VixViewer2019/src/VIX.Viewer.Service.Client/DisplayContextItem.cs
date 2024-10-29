using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VIX.Viewer.Service.Client
{
    public class DisplayContextItem
    {
        // AbtractStudyItem classes
        public string ContextId { get; set; }
        public int ImageCount { get; set; }

        public string StudyDescription { get; set; }
        public string StudyDate { get; set; } // procedure date
        public string AcquisitionDate { get; set; }
        public string StudyId { get; set; }

        public string SiteName { get; set; }
        public string Event { get; set; }
        public string Package { get; set; }
        public string Type { get; set; }
        public string Origin { get; set; }
        public string StudyType { get; set; }
        public string ProcedureDescription { get; set; }
        public string SpecialtyDescription { get; set; }
        public string StudyClass { get; set; }
        public bool IsSensitive { get; set; }

        // StudyItem class members
        public string ExternalContextId { get; set; }
        public string GroupIEN { get; set; }
        public string PatientICN { get; set; }
        public string PatientDFN { get; set; }
        public string SiteNumber { get; set; }
        public string DetailsUrl { get; set; }
        public string ViewerUrl { get; set; }
        public string ThumbnailUrl { get; set; }
        public string StatusCode { get; set; }
        public string Status { get; set; }
    }
}
