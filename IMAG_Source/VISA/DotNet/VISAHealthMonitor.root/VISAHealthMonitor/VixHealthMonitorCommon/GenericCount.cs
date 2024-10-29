using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon.formattedvalues;

namespace VixHealthMonitorCommon
{
    public class GenericCount
    {
        public string Name { get; private set; }
        public FormattedNumber Count { get; private set; }
        public string ToolTip { get; private set; }

        public GenericCount(string name, FormattedNumber count)
            : this(name, count, "")
        {

        }

        public GenericCount(string name, FormattedNumber count, string toolTip)
        {
            this.Name = name;
            this.Count = count;
            this.ToolTip = toolTip;
        }
    }
}
