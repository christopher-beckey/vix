using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class DisplayObjectCollection
    {
        public string StudyId { get; set; }
        public string StudyDescription { get; set; }
        public string StudyDateTime { get; set; }
        public string PatientDescription { get; set; }
        public List<DisplayObject> Items { get; set; }
    }
}
