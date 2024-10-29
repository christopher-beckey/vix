using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VIX.Viewer.Service.Client
{
    public class DisplayContextItemCollection
    {
        public DisplayContextItem[] Studies { get; set; }
        public string PatientICN { get; set; }
        public string SiteNumber { get; set; }
        public string AuthSiteNumber { get; set; }
    }
}
