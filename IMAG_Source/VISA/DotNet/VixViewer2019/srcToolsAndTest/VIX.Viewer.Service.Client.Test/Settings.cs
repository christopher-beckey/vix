using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VIX.Viewer.Service.Client.Test
{
    class Settings
    {
        [DisplayName("Host Name"), Category("Server")]
        public string HostName { get; set; }

        [DisplayName("Port Number"), Category("Server")]
        public int PortNumber { get; set; }

        [DisplayName("User")]
        [TypeConverter(typeof(ExpandableObjectConverter))]
        public UserCredentials UserCredentials { get; set; }

        [DisplayName("AETitle"), Category("Client")]
        public string AETitle { get; set; }

        [Browsable(false)]
        public string Url
        {
            get
            {
                return string.Format("http://{0}:{1}", HostName, PortNumber);
            }
        }
    }
}
