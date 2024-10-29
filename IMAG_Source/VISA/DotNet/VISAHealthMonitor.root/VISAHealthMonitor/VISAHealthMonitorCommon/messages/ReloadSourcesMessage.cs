using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.messages
{
    /// <summary>
    /// This message is sent when the view should reload the list of sources (not actually retrieve a new list of sources)
    /// </summary>
    public class ReloadSourcesMessage
    {
        public ReloadSourcesMessage()
        {
        }
    }
}
