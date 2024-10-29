using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon.formattedvalues;

namespace VISAHealthMonitorCommon.monitorederror
{
    public class MonitoredError
    {
        public string ErrorContains { get; private set; }
        public FormattedNumber Count { get; private set; }
        public FormattedDate LastOccurrence { get; private set; }

        public MonitoredError(string errorContains, 
            FormattedNumber count, FormattedDate lastOccurrence)
        {
            this.ErrorContains = errorContains;
            this.Count = count;
            this.LastOccurrence = lastOccurrence;
        }

    }
}
