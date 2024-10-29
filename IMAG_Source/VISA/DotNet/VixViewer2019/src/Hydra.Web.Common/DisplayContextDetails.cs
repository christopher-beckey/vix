using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public class DisplayContextDetails
    {
        public string Message { get; set; }
        public List<Hydra.Entities.Study> Studies { get; set; }
        public List<Hydra.Entities.Image> Images { get; set; }
        public List<Hydra.Entities.Blob> Blobs { get; set; }
        public string SelectedUid { get; set; }
        public DisplayContextStatus Status { get; set; }
        public Hydra.Entities.Patient Patient { get; set; }
        public string DisplayPref { get; set; }
    }
}
