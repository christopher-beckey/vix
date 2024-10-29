using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public abstract class AbstractStudyItem
    {
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
    }
}
