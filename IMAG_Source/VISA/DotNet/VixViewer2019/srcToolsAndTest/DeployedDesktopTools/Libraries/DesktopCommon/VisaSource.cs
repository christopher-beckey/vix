using System.ComponentModel;

namespace DesktopCommon
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

        public VisaSource(string id, string name, string visaHost = null, int visaPort = 0)
        {
            this.ID = id;
            this.Name = name;
            this.VisaHost = visaHost;
            this.VisaPort = visaPort;
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

#pragma warning disable 67 // CS0067
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 67
    }
}
