using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;
using System.ComponentModel;

namespace VISAHealthMonitorCommon
{
    public class VisaHealthSource : INotifyPropertyChanged
    {
        private readonly VisaSource mVisaSource;
        private readonly VisaHealth mVisaHealth;

        public VisaSource VisaSource
        {
            get { return mVisaSource; }
        }

        public VisaHealth VisaHealth
        {
            get { return mVisaHealth; }
        }

        public VisaHealthSource(VisaSource visaSource, VisaHealth visaHealth)
        {
            this.mVisaSource = visaSource;
            this.mVisaHealth = visaHealth;
        }

        public string HealthImage
        {
            get
            {
                switch (mVisaHealth.LoadStatus)
                {
                    case VixHealthLoadStatus.loaded:
                        return "images/Passed.ico";
                    default:
                        return "images/question.ico";;
                }

            }
        }

        public void UpdateIcon()
        {

        }

        public event PropertyChangedEventHandler PropertyChanged;
    }
}
