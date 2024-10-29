using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class VixServer
    {
        public string HostName { get; set; }
        public int Port { get; set; }

        public string RootUrl
        {
            get
            {
                return string.Format("http://{0}:{1}", HostName, Port);
            }
        }
    }
}
