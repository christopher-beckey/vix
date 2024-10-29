using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;

namespace VixHealthMonitorCommon.monitoredproperty
{
    public class MonitoredProperty
    {
        public VisaSource VisaSource { get; private set; }
        public string Name { get; private set; }
        public SortedList<DateTime, MonitoredPropertyHistory> MonitoredPropertyHistory { get; private set; }
//        public string Value { get; private set; }
//        public DateTime DateUpdated { get; private set; }

        public MonitoredProperty(VisaSource visaSource, string name)
        {
            this.Name = name;
            this.VisaSource = visaSource;
            MonitoredPropertyHistory = new SortedList<DateTime, MonitoredPropertyHistory>();
        }

        public MonitoredPropertyHistory MostRecentHistory
        {
            get
            {
                if (this.MonitoredPropertyHistory.Count > 0)
                {
                    // the newest one is at the end
                    return this.MonitoredPropertyHistory.Values[this.MonitoredPropertyHistory.Count - 1];
                }
                return null;
            }
        }

        public bool IsValueDifferentFromMostRecentValue(string value)
        {
            MonitoredPropertyHistory mostRecentValue = MostRecentHistory;
            if (mostRecentValue == null)
                return true;

            return (mostRecentValue.Value != value);
        }
    }

    public class MonitoredPropertyHistory
    {
        public string Value { get; private set; }
        public DateTime DateUpdated { get; private set; }

        public MonitoredPropertyHistory(string value, DateTime dateUpdated)
        {
            this.Value = value;
            this.DateUpdated = dateUpdated;
        }
    }

    public class MonitoredPropertyComparer : IComparer<MonitoredProperty>
    {

        public int Compare(MonitoredProperty x, MonitoredProperty y)
        {
            MonitoredPropertyHistory mphX = x.MostRecentHistory;
            MonitoredPropertyHistory mphY = y.MostRecentHistory;
            if (mphX == null)
            {
                if (mphY == null)
                    return 0;
                return -1;
            }
            else
            {
                if (mphY == null)
                    return 1;
                return mphX.DateUpdated.CompareTo(mphY.DateUpdated);
            }
        }
    }
}
