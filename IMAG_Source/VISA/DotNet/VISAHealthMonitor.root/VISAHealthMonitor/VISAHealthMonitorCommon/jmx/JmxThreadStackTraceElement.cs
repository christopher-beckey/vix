using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.jmx
{
    public class JmxThreadStackTraceElement
    {
        public string ClassName { get; set; }
        public string MethodName { get; set; }
        public string FileName { get; set; }
        public int LineNumber { get; set; }

        public JmxThreadStackTraceElement()
        {
        }

        public JmxThreadStackTraceElement(string className, string methodName,
            string filename, int lineNumber)
        {
            this.ClassName = className;
            this.MethodName = methodName;
            this.FileName = filename;
            this.LineNumber = lineNumber;
        }
    }
}
