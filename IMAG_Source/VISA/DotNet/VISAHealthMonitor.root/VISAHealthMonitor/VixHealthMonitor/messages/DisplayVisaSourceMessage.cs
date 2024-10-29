using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon.messages;
using VISACommon;

namespace VixHealthMonitor.messages
{
    /// <summary>
    /// Display a VisaSource, this differs slightly from DisplayVisaHealthMessage in that this message is to display a site. 
    /// In reality the DisplayVisaHealthMessage might be sent after this message is received but that is up to the receiver
    /// </summary>
    public class DisplayVisaSourceMessage : BaseVisaHealthMessage
    {
        public DisplayVisaSourceMessage(VisaSource visaSource)
            : base(visaSource)
        {
        }
    }
}
