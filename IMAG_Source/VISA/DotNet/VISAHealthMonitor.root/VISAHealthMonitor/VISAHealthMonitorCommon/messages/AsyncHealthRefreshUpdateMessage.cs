using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.messages
{
    public class AsyncHealthRefreshUpdateMessage
    {
        public int Completed { get; private set; }
        public int Total { get; private set; }

        public bool IsComplete
        {
            get
            {
                return Completed >= Total;
            }
        }

        public AsyncHealthRefreshUpdateMessage(int completed, int total)
        {
            this.Completed = completed;
            this.Total = total;
        }
    }
}
