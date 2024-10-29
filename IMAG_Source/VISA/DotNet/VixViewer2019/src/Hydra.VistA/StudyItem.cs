using Hydra.Web.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class StudyItem : AbstractStudyItem
    {
        public string ExternalContextId { get; set; }
        public string GroupIEN { get; set; }
        public string PatientICN { get; set; }
        public string PatientDFN { get; set; }
        public string SiteNumber { get; set; }
        public string DetailsUrl { get; set; }
        public string ReportUrl { get; set; }
        public string ViewerUrl { get; set; }
        public string ManageUrl { get; set; }
        public string ThumbnailUrl { get; set; }
        [JsonIgnore]
        public string ThumbnailUri { get; set; }
        public string StatusCode { get; set; }
        public string Status { get; set; }
        public string SecurityToken { get; set; }
    }
}
