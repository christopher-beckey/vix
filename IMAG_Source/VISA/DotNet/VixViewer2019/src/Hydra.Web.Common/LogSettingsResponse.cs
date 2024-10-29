using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public class LogSettingsResponse
    {
        public string Application { get; set; }
        public string LogLevel { get; set; }
        public LogFileItem[] LogFileItems { get; set; }
    }
}
