using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class ROIStatusItem
    {
        public string PatientName { get; set; }
        public string SLast4 { get; set; }
        public string PatientId { get; set; }
        public string Status { get; set; }
        public string LastUpdated { get; set; }
        public string DICOMRouting { get; set; }
        public string ErrorMessage { get; set; }
        public string Id { get; set; }
        public string ResultUri { get; set; }
        public string[] StudyIds { get; set; }
        public string ExportQueue { get; set; }
    }
}
