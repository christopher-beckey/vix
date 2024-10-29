using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class HixDbSpaceUsed
    {
        public string Reserved { get; set; }
        public string Data { get; set; }
        public string IndexSize { get; set; }
        public string Unused { get; set; }
        public string DatabaseSize { get; set; }
        public string UnallocatedSpace { get; set; }
    }
}
