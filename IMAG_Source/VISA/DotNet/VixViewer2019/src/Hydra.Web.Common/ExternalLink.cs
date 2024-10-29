using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public class ExternalLink
    {
        public string Name { get; set; }
        public string Path { get; set; }
        public ExternalLinkType Type { get; set; }
        public string Display { get; set; }
    }
}
