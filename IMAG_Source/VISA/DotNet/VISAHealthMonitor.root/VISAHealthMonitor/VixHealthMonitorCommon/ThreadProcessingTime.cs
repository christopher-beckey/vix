using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon.formattedvalues;

namespace VixHealthMonitorCommon
{
    public class ThreadProcessingTime : IComparable<ThreadProcessingTime>
    {
        public string ThreadName { get; private set; }
        public FormattedTime ProcessingTime { get; private set; }


        public ThreadProcessingTime(string threadName, long processingTime)
        {
            this.ThreadName = threadName;
            this.ProcessingTime = new FormattedTime(processingTime, true);
        }

        public int CompareTo(ThreadProcessingTime that)
        {
            return this.ProcessingTime.Ticks.CompareTo(that.ProcessingTime.Ticks);
        }
    }

    public class ThreadProcessingTimeComparer : IComparer<ThreadProcessingTime>
    {

        private bool mbSortAscending;

        public ThreadProcessingTimeComparer(bool sortAscending)
        {
            this.mbSortAscending = sortAscending;
        }

        public int Compare(ThreadProcessingTime x, ThreadProcessingTime y)
        {
            int c = x.ProcessingTime.Ticks.CompareTo(y.ProcessingTime.Ticks);
            if (c == 0)
                return c;
            if (!mbSortAscending)
                return -1 * c;
            return c;
        }
    }
}
