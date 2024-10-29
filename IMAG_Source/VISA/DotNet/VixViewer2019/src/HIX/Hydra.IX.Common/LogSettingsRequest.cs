using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Common
{
    public class LogSettingsRequest
    {
        public string Application { get; set; }
        public string LogLevel { get; set; }
        public string LogFileName { get; set; }
        public int PageSize { get; set; }
        public int PageIndex { get; set; }
    }

}
