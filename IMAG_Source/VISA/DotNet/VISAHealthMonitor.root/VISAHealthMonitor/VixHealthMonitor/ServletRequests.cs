using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon.formattedvalues;

namespace VixHealthMonitor
{
    public class ServletRequests
    {
        public string ServletName { get; set; }
        public FormattedNumber RequestCount { get; set; }
        public string Description { get; set; }

        public ServletRequests(string servletName, long requestCount, string description)
        {
            this.ServletName = servletName;
            this.RequestCount = new FormattedNumber(requestCount);
            this.Description = description;
        }

        public ServletRequests(string servletName, string description, long requestCount)
            : this(servletName, requestCount, description)
        {

        }

        public ServletRequests(string servletName, long requestCount)
            : this(servletName, requestCount, "")
        {

        }
    }
}
