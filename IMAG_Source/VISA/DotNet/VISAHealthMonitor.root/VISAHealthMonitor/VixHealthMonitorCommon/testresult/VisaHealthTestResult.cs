using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;
using System.ComponentModel;
using System.Xml;
using System.IO;

namespace VixHealthMonitorCommon.testresult
{
    public class VisaHealthTestResult : INotifyPropertyChanged
    {
        public DateTime TestDate { get; private set; }
        public bool TestFailed { get; private set; }
        public string TestFailureReason { get; private set; }
        public VisaSource VisaSource { get; private set; }

        public VisaHealthTestResult(VisaSource visaSource, DateTime testDate, bool testFailed, string testFailureReason)
        {
            this.VisaSource = visaSource;
            this.TestDate = testDate;
            this.TestFailed = testFailed;
            this.TestFailureReason = testFailureReason;
        }

        public event PropertyChangedEventHandler PropertyChanged;

        public static List<VisaHealthTestResult> GetVisaSourceTestResults(VaSite vaSite)
        {
            List<VisaHealthTestResult> result = new List<VisaHealthTestResult>();

            return result;
        }

        
    }
}
