using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public class MuseFacade
    {
        public MuseFacade(bool enabled, string sitenum, string hostname, string username, string password, string port, string protocol)
        {
            MuseEnabled = enabled;
            MuseSiteNum = sitenum;
            MuseHostname = hostname;
            MuseUsername = username;
            MusePassword = password;
            MusePort = port;
            MuseProtocol = protocol;
        }

        public MuseFacade()
        {
        }

        public bool MuseEnabled { get; set; }
        public string MuseSiteNum { get; set; }
        public string MuseHostname { get; set; }
        public string MuseUsername { get; set; }
        public string MusePassword { get; set; }
        public string MusePort { get; set; }
        public string MuseProtocol { get; set; }
    }
}
