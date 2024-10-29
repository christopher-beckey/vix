using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public static class LoggerExtensions
    {
        public static string ToJsonLog(this object value)
        {
            return JsonConvert.SerializeObject(value, Formatting.None);
        }

        public static string ToJsonLogLine(this object value)
        {
            string text = JsonConvert.SerializeObject(value, Formatting.None);
            return Regex.Replace(text, @"\s+", " ");
        }
    }
}
