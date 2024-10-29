using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public class ImageDeleteRequest
    {
        public string Reason { get; set; }
        public string[] ImageIds { get; set; }
    }
}
