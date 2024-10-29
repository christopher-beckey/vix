using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Modules
{
    public class ConfigRequest : BaseRequest
    {
        public string Parameter { get; set; }

        public bool IsValid
        {
            get
            {
                return !(string.IsNullOrEmpty(Parameter));
            }
        }
    }
}
