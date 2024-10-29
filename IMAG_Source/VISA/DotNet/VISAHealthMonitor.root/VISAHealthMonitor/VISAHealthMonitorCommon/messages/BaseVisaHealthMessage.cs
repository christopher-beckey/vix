using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;

namespace VISAHealthMonitorCommon.messages
{
    public abstract class BaseVisaHealthMessage
    {
        public VisaSource VisaSource { get; set; }

        public BaseVisaHealthMessage(VisaSource visaSource)
        {
            this.VisaSource = visaSource;
        }
    }
}
