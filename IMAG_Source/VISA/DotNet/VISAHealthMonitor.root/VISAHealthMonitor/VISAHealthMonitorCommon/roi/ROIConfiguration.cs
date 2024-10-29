using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon.formattedvalues;

namespace VISAHealthMonitorCommon.roi
{
    public class ROIConfiguration
    {
        public FormattedNumber ExpireCompletedItemsAfterDays { get; set; }
        public bool ExpireCompletedItemsEnabled { get; set; }
        public bool PeriodicProcessingEnabled { get; set; }
        public bool ProcessWorkItemsImmediately { get; set; }
        public FormattedNumber ProcessingWorkItemWaitTime { get; set; }

        public ROIConfiguration(FormattedNumber expireCompletedItemsAfterDays, bool expireCompletedItemsEnabled, 
            bool periodicProcessingEnabled, bool processWorkItemsImmediately, FormattedNumber processingWorkItemWaitTime)
        {
            this.ExpireCompletedItemsAfterDays = expireCompletedItemsAfterDays;
            this.ExpireCompletedItemsEnabled = expireCompletedItemsEnabled;
            this.PeriodicProcessingEnabled = periodicProcessingEnabled;
            this.ProcessingWorkItemWaitTime = processingWorkItemWaitTime;
            this.ProcessWorkItemsImmediately = processWorkItemsImmediately;
        }
    }
}
