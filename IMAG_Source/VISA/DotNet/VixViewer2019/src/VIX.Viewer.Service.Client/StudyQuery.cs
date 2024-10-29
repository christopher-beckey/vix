using Hydra.Web.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VIX.Viewer.Service.Client
{
    public class StudyQuery
    {
        public string PatientICN { get; set; }
        public string PatientDFN { get; set; }
        public string SiteNumber { get; set; }
        public DisplayContext[] Studies { get; set; }
    }
}
