using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.messages
{
    /// <summary>
    /// This message indicates the health of all sources is being updated (started or completed)
    /// </summary>
    public class AllSourcesHealthUpdateMessage
    {
        /// <summary>
        /// Determines if the operation is complete - if false then it is likely just starting
        /// </summary>
        public bool Completed { get; private set; }

        public AllSourcesHealthUpdateMessage(bool completed)
        {
            this.Completed = completed;
        }

    }
}
