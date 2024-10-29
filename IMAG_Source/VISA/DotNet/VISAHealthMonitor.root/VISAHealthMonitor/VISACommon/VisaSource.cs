using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;

namespace VISACommon
{
    public class VisaSource : INotifyPropertyChanged
    {
        public string ID { get; set; }
        public string Name { get; set; }
        public string VisaHost { get; set; }
        public int VisaPort { get; set; }

        public string DisplayName
        {
            get
            {
                return Name;
            }
        }

        public VisaSource(string id, string name, string visaHost, int visaPort)
        {
            this.ID = id;
            this.Name = name;
            this.VisaHost = visaHost;
            this.VisaPort = visaPort;
        }

        public VisaSource(string id, string name)
        {
            this.ID = id;
            this.Name = name;
            this.VisaHost = null;
            this.VisaPort = 0;
        }

        public override int GetHashCode()
        {
            return VisaHost.GetHashCode() ^ VisaPort.GetHashCode();
        }

        public override bool Equals(object obj)
        {
            if (obj is VisaSource)
            {
                VisaSource that = (VisaSource)obj;
                return this.VisaHost.Equals(that.VisaHost) && this.VisaPort.Equals(that.VisaPort);
            }
            return false;
        }

        public override string ToString()
        {
            return DisplayName;
        }


        public event PropertyChangedEventHandler PropertyChanged;
    }
}
