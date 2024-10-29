using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.messages
{
    /// <summary>
    /// This message is used to indicate testing of all sources should be started. The main component should listen to this message and initiate a refresh also including
    /// the options to use when refreshing the health. This message should be used in the code where it doesn't know what options are supposed to be included. This message
    /// should only be received in one place throughout the application
    /// </summary>
    public class TestAllSourcesMessage
    {
        public bool Async {get; private set;}
        public bool OnlyTestFailed {get; private set;}

        public TestAllSourcesMessage(bool async, bool onlyTestFailed)
        {
            this.Async = async;
            this.OnlyTestFailed = onlyTestFailed;
        }
    }
}
