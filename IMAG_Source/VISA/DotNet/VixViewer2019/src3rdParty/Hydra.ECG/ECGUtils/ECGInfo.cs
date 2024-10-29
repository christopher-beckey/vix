using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.ECG
{
    public class ECGInfo
    {
        public string VentRate { get; set; }
        public string PRInt { get; set; }
        public string QRSDur { get; set; }
        public string QTQTc { get; set; }
        public string PRTAxes { get; set; }
        public string DiagnosticText { get; set; }
        public string PatientName { get; set; }
        public string PatientAge { get; set; }
        public string PatientGender { get; set; }
        public string PatientId { get; set; }
        public string AcquisitionDateTime { get; set; }
        public string ReferringPhysician { get; set; }
        public string ConfirmedPhysician { get; set; }
        public string[] LeadTypes { get; set; }
        public bool IsMedian { get; set; }
    }
}
