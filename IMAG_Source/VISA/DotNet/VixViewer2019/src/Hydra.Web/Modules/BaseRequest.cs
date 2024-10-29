using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Modules
{
    public class BaseRequest
    {
        public string Broker { get; set; }

        public string SiteId { get; set; }

        public string RequestId { get; set; }
    }
}
