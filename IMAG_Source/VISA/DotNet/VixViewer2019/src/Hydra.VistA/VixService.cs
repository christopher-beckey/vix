using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public enum VixServiceType
    {
        Local,
        SiteService,
        Viewer,
        Render
    }

    public enum VixFlavor
    {
        Vix,
        Isix
    }

    public class VixService
    {
        public string RootUrl { get; set; }
        public string TrustedClientRootUrl { get; set; }
        public string PublicHostName { get; set; }
        public VixServiceType ServiceType { get; set; }
        public VixFlavor Flavor { get; set; }
        public string SiteServiceProtocol { get; set; }
        public string SecureSiteServiceProtocol { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
    }
}
