using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class StudyItemGroup
    {
        public string SiteNumber { get; set; }
        public IEnumerable<StudyItem> Studies { get; set; }
        public bool? IsBulkStudyQuerySupported { get; set; }
        public bool? IsServerAvailable { get; set; }
    }
}
