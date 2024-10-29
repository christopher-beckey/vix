using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Log
{
    public class LogSettings
    {
        public string LogLevel { get; set; }
        public LogFileItem[] LogFileItems { get; set; }
    }
}
