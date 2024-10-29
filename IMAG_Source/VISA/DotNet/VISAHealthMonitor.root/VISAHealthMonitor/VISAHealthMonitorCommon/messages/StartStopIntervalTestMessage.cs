using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.messages
{
    public class StartStopIntervalTestMessage
    {
        public object Sender { get; private set; }

        public StartStopIntervalTestMessage(object sender)
        {
            this.Sender = sender;
        }
    }
}
