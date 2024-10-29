using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class StudyDetails
    {
        public string ViewerUrl { get; set; }
        public string ExportUrl { get; set; }
        public int TotalImageCount { get; set; }
        public bool IsSensitive { get; set; }
        public StudyItemDetails[] Studies { get; set; }
    }
}
