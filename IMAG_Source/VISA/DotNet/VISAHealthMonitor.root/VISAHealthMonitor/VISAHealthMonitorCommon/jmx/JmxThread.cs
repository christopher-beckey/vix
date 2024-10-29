using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.jmx
{
    public class JmxThread
    {
        public int LockOwnerId { get; set; }
        public string LockOwnerName { get; set; }
        public string LockName { get; set; }
        public int ThreadId { get; set; }
        public string ThreadName { get; set; }
        public string ThreadState { get; set; }

        public JmxThread()
        {
        }

        public JmxThread(int threadId, string threadName, string threadState, 
            int lockOwnerId, string lockOwnerName, string lockName)
        {
            this.ThreadId = threadId;
            this.ThreadName = threadName;
            this.ThreadState = threadState;
            this.LockName = lockName;
            this.LockOwnerId = lockOwnerId;
            this.LockOwnerName = lockOwnerName;
        }

    }
}
