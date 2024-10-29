using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    //todo: consider moving to a new assembly - Hydra.VistA.Web.Common
    public class DisplayContext
    {
        public string ContextId { get; set; }
        public string PatientICN { get; set; }
        public string PatientDFN { get; set; }
        public string SiteNumber { get; set; }
        public DisplayContextImage[] Images { get; set; }
    }
}
