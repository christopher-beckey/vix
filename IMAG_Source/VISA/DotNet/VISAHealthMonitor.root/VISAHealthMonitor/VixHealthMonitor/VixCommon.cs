using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;
using VISAHealthMonitorCommon;
using VixHealthMonitorCommon;

namespace VixHealthMonitor
{
    public class VixCommon
    {
    }

    public delegate void ShowThreadDetailsDialogDelegate(VisaSource visaSource, VisaHealth visaHealth,
        ThreadProcessingTime threadProcessingTime);
}
