using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VixHealthMonitorDailyStatus
{
    public class SiteInformation
    {
        public string SiteNumber { get; private set; }
        public string LastLoaded { get; set; }
        public long HealthRequestCount { get; set; }
        public long SuccessfulHealthRequestCount { get; set; }

        public SiteInformation(string siteNumber)
        {
            this.SiteNumber = siteNumber;
        }

        public SiteInformation(string siteNumber, string lastLoaded, long healthRequestCount, long successfulHealthRequestCount)
        {
            this.SiteNumber = siteNumber;
            this.LastLoaded = lastLoaded;
            this.HealthRequestCount = healthRequestCount;
            this.SuccessfulHealthRequestCount = successfulHealthRequestCount;
        }
    }
}
