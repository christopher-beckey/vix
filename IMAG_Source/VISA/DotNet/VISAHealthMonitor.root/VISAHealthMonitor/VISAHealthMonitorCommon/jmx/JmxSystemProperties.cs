using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.jmx
{
    public class JmxSystemProperties
    {
        public Dictionary<string, JmxSystemProperty> Values { get; private set; }

        public string JavaHome
        {
            get
            {
                return GetValue("java.home"); 
            }
        }

        public string TimeZone
        {
            get
            {
                return GetValue("user.timezone");
            }
        }

        public string JavaExtDirs
        {
            get
            {
                return GetValue("java.ext.dirs");
            }
        }

        public string JavaVersion
        {
            get
            {
                return GetValue("java.version");
            }
        }

        public string CatalinaHome
        {
            get
            {
                return GetValue("catalina.home");
            }
        }

        public string JavaLibraryPath
        {
            get
            {
                return GetValue("java.library.path");
            }
        }

        private string GetValue(string key)
        {
            if (Values.ContainsKey(key))
                return Values[key].Value;
            return "";
        }

        private JmxSystemProperties(Dictionary<string, JmxSystemProperty> values)
        {
            this.Values = values;
        }

        public static JmxSystemProperties Empty()
        {
            return new JmxSystemProperties(new Dictionary<string, JmxSystemProperty>());
        }

        public static JmxSystemProperties Parse(string value)
        {
            Dictionary<string, JmxSystemProperty> values = new Dictionary<string, JmxSystemProperty>();
            int count = 0;
            int loc = 0;
            loc = value.IndexOf("key=", loc);
            while (loc >= 0)
            {
                
                int startKey = loc + 4;
                int endKey = value.IndexOf(",", startKey);
                int valueStart = value.IndexOf("value=", endKey);
                valueStart = valueStart + 6;
                int valueEnd = value.IndexOf("}", valueStart);
                string key = value.Substring(startKey, (endKey - startKey)).Trim();
                string v = value.Substring(valueStart, (valueEnd - valueStart)).Trim();

                //values.Add(key + "_" + count, v);
                values.Add(key, new JmxSystemProperty(key, v));

                loc = valueEnd;
                loc = value.IndexOf("key=", loc);
                count++;

            }


            return new JmxSystemProperties(values);
        }

    }

    public class JmxSystemProperty
    {
        public string Name { get; private set; }
        public string Value { get; private set; }

        public JmxSystemProperty(string name, string value)
        {
            this.Name = name;
            this.Value = value;
        }
    }
}
