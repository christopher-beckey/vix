using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Core
{
    public sealed class Referencer
    {
        private Type[] types = new[] 
        {
            typeof (Hydra.IX.Core.Modules.DefaultHixRequestHandler)
        };

        // This is the only constructor. So you can't instantiate this type.
        private Referencer()
        {
        }
    }
}
