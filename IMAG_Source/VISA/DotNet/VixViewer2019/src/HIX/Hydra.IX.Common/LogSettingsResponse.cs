using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Common
{
    public class LogSettingsResponse
    {
        public string Application { get; set; }
        public string LogLevel { get; set; }
        public Hydra.Log.LogFileItem[] LogFileItems { get; set; }
        public Hydra.Log.LogEventItem[] LogEventItems { get; set; }
        public bool? More { get; set; }
    }
}
