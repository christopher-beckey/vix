using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VixHealthMonitor
{
    public class VixHealthProperty
    {
        public string Name { get; set; }
        public string Value { get; set; }

        public VixHealthProperty()
        {
        }

        public VixHealthProperty(string name, string value)
        {
            this.Name = name;
            this.Value = value;
        }
    }
}
