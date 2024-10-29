using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon.formattedvalues;

namespace VISAHealthMonitorCommon.jmx
{
    public class JmxMemoryInformation
    {
        public string Name { get; private set; }
        public FormattedNumber Committed { get; private set; }
        public FormattedNumber Init { get; private set; }
        public FormattedNumber Max { get; private set; }
        public FormattedNumber Used { get; private set; }
        public FormattedDecimal PercentUsed { get; private set; }
        public string Description { get; private set; }

        public JmxMemoryInformation(string name, string description, 
            FormattedNumber committed, FormattedNumber init, FormattedNumber max, FormattedNumber used)
        {
            this.Name = name;
            this.Committed = committed;
            this.Init = init;
            this.Max = max;
            this.Used = used;
            this.Description = description;

            if (used.IsValueSet && max.IsValueSet)
            {
                long usedBytes = used.Number;
                long maxBytes = max.Number;
                double val = (double)usedBytes / (double)maxBytes;
                val *= 100.0f;
                this.PercentUsed = new FormattedDecimal(val);
            }
            else
            {
                this.PercentUsed = FormattedDecimal.UnknownFormattedDecimal;
            }

        }

        public static JmxMemoryInformation ParseMemoryHealthResponse(string name, string description, string value)
        {
            /*
             * 
             javax.management.openmbean.CompositeDataSupport(compositeType=javax.management.openmbean.CompositeType(name=java.lang.management.MemoryUsage,items=((itemName=committed,itemType=javax.management.openmbean.SimpleType(name=java.lang.Long)),(itemName=init,itemType=javax.management.openmbean.SimpleType(name=java.lang.Long)),(itemName=max,itemType=javax.management.openmbean.SimpleType(name=java.lang.Long)),(itemName=used,itemType=javax.management.openmbean.SimpleType(name=java.lang.Long)))),contents={committed=2031616, init=2031616, max=4128768, used=262648}) 
             * 
             * 
             * 
             {committed=2031616, init=2031616, max=4128768, used=262648}
             */

            int contentsStart = value.IndexOf("contents");
            string contents = value.Substring(contentsStart);

            long committed = parseNextValue("committed", contents);
            long init = parseNextValue("init", contents);
            long max = parseNextValue("max", contents);
            long used = parseNextValue("used", contents);
            return new JmxMemoryInformation(name, description, new FormattedNumber(committed), 
                new FormattedNumber(init), new FormattedNumber(max), new FormattedNumber(used));
        }

        private static long parseNextValue(string name, string value)
        {
            int loc = value.IndexOf(name);
            int endLoc = value.IndexOf(",", loc);
            if (endLoc <= 0)
            {
                // last one
                endLoc = value.IndexOf("}", loc);
            }
            int startIndex = loc + name.Length + 1;
            long number = long.Parse(value.Substring(startIndex, endLoc - startIndex));
            return number;
        }
    }
}
