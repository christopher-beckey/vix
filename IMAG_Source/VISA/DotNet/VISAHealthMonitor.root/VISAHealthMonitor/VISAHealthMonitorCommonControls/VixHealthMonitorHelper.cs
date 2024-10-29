using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace VISAHealthMonitorCommonControls
{
    public class VixHealthMonitorHelper
    {
        public static void LaunchUrl(string url)
        {
            if (url != null)
            {
                Process proc = new Process();
                proc.StartInfo.FileName = url;
                proc.Start();
            }
        }
    }
}
