using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VixHealthMonitorCommon
{
    public class VixServerUrl
    {
        public string Name { get; private set; }
        public string Url { get; private set; }
        public string Icon { get; private set; }

        public VixServerUrl(string name, string url)
        {
            this.Name = name;
            this.Url = url;
            Icon = Icons.link;// "images/ie-icon.gif";
        }
    
    }
}
