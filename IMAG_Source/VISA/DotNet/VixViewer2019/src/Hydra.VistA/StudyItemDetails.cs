using Hydra.Web.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class StudyItemDetails : AbstractStudyItem
    {
        //public string ContextId { get; set; }
        //public int ImageCount { get; set; }

        //public string StudyDescription { get; set; }
        //public string StudyDate { get; set; }
        //public string AcquisitionDate { get; set; }
        //public string StudyId { get; set; }
        public string ReportUrl { get; set; }

        public SeriesItemDetails[] Series { get; set; } 
    }
}
