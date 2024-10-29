using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;

namespace VISAHealthMonitorCommon.messages
{
    /// <summary>
    /// This message indicates the associated health was updated. Any listening views should update themselves based on the associated Health object
    /// </summary>
    public class VisaHealthUpdatedMessage
    {
        public VisaSource VisaSource { get; set; }
        public VisaHealth VisaHealth { get; set; }

        public VisaHealthUpdatedMessage(VisaSource visaSource, VisaHealth visaHealth)
        {
            this.VisaSource = visaSource;
            this.VisaHealth = visaHealth;
        }
    }
}
