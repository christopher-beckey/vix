using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;

namespace VixHealthMonitor.messages
{
    /// <summary>
    /// This message indicates the desire to watch a site has changed (either want to or no longer want to watch a site)
    /// </summary>
    public class ChangeWatchedSiteMessage
    {
        public bool Watch { get; set; }
        public VisaSource VisaSource { get; set; }

        public ChangeWatchedSiteMessage(bool watch, VisaSource visaSource)
        {
            this.Watch = watch;
            this.VisaSource = visaSource;
        }
    }
}
