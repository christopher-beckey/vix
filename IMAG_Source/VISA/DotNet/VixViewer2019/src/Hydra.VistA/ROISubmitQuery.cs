using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class ROISubmitQuery : VistAQuery
    {
        public string Type { get; set; }
        public string Target { get; set; }
        public string DownloadReason { get; set; }
        public StudyItem[] Studies { get; set; }
    }
}
