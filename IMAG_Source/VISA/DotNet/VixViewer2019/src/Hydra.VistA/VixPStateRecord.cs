using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class VixPStateRecord
    {
        public string StudyId { get; set; }
        public string PStateUid { get; set; }
        public string Name { get; set; }
        public string Source { get; set; }
        public string Data { get; set; }
        public string DUZ { get; set; }
        public string TimeStamp { get; set; }
        public bool IncludeDeleted { get; set; }
        public bool IncludeOtherUsers { get; set; }
        public bool IncludeDetails { get; set; }
    }
}
