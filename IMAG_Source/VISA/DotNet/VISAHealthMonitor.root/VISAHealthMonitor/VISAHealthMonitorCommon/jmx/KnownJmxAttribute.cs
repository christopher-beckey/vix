using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.jmx
{
    public class KnownJmxAttribute
    {
        public string Name { get; private set; }
        public string ObjectName { get; private set; }
        public string Attribute { get; private set; }

        public KnownJmxAttribute(string name, string objectName, string attribute)
        {
            this.Name = name;
            this.ObjectName = objectName;
            this.Attribute = attribute;
        }

        public static KnownJmxAttribute SystemProperties = new KnownJmxAttribute("System Properties", 
            "java.lang:type=Runtime", "SystemProperties");
        public static KnownJmxAttribute TomcatServerInfo = new KnownJmxAttribute("Tomcat Server Info", 
            "Catalina:type=Server", "serverInfo");
    }
}
