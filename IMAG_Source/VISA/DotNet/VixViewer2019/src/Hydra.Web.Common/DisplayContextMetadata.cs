using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public class DisplayContextMetadata
    {
        public Hydra.Entities.Patient Patient { get; set; }
        public ImageGroupMetadata[] ImageGroups { get; set; }
        public int TotalImageCount { get; set; }
        public bool CanDelete { get; set; }
        public bool CanEdit { get; set; }
        public bool CanPrint { get; set; }
    }
}
