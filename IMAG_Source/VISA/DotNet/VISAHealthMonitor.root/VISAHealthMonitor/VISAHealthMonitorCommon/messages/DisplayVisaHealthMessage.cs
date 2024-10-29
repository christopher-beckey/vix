using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;

namespace VISAHealthMonitorCommon.messages
{
    /// <summary>
    /// Display the details of a specific VisaSource
    /// </summary>
    public class DisplayVisaHealthMessage : BaseVisaHealthMessage
    {
        public DisplayVisaHealthMessage(VisaSource visaSource)
            : base(visaSource)
        {

        }
    }
}
