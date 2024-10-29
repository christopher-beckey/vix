using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using VISACommon;
using VixHealthMonitorCommon;

namespace VixHealthMonitor
{
    public class VixTreeHealthSource : VixHealthSource, INotifyPropertyChanged
    {
        public bool IsSelected { get; set; }

        public VixTreeHealthSource(VisaSource visaSource, BaseVixHealth vixHealth)
            : base(visaSource, vixHealth)
        {

        }

        //public event PropertyChangedEventHandler PropertyChanged;
    }
}
