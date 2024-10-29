using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.messages
{
    public class StatusMessage
    {
        public string Message { get; set; }
        public bool Error { get; set; }

        public StatusMessage(string msg, bool error)
        {
            this.Message = msg;
            this.Error = error;
        }

        public StatusMessage(string msg)
        {
            this.Message = msg;
            this.Error = false;
        }
    }
}
