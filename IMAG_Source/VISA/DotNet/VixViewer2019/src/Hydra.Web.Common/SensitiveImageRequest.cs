using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public class SensitiveImageRequest
    {
        public bool IsSensitive { get; set; }
        public string[] ImageIds { get; set; }
    }
}
