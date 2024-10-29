using Hydra.IX.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class VixServiceElement : ConfigurationElement
    {
        [ConfigurationProperty("Environment", DefaultValue = "")]
        public string Environment
        {
            get { return (string)base["Environment"]; }
        }

        [ConfigurationProperty("RootUrl", IsRequired = true)]
        public string RootUrl 
        {
            get { return (string)base["RootUrl"]; }
        }

        [ConfigurationProperty("TrustedClientRootUrl", DefaultValue = "")]
        public string TrustedClientRootUrl
        {
            get { return (string)base["TrustedClientRootUrl"]; }
        }

        [ConfigurationProperty("PublicHostName", DefaultValue = "")]
        public string PublicHostName
        {
            get { return (string)base["PublicHostName"]; }
        }

        [ConfigurationProperty("ServiceType", IsRequired = true, IsKey = true)]
        public VixServiceType ServiceType
        {
            get { return (VixServiceType)base["ServiceType"]; }
        }

        [ConfigurationProperty("Flavor", DefaultValue = VixFlavor.Vix)]
        public VixFlavor Flavor
        {
            get { return (VixFlavor)base["Flavor"]; }
        }

        [ConfigurationProperty("SiteServiceProtocol", DefaultValue = "VVS")]
        public string SiteServiceProtocol
        {
            get { return (string)base["SiteServiceProtocol"]; }
        }

        [ConfigurationProperty("SecureSiteServiceProtocol", DefaultValue = "VVSS")]
        public string SecureSiteServiceProtocol
        {
            get { return (string)base["SecureSiteServiceProtocol"]; }
        }

        [ConfigurationProperty("UserName", DefaultValue = "alexdelarge")]
        public string UserName
        {
            get { return (string)base["UserName"]; }
        }

        [ConfigurationProperty("Password", DefaultValue = "655321")]
        public string Password
        {
            get { return (string)base["Password"]; }
        }

        [ConfigurationProperty("SecureElements")]
        public SecureElementCollection SecureElements
        {
            get
            {
                return ((SecureElementCollection)(base["SecureElements"]));
            }

            set
            {
                base["SecureElements"] = value;
            }
        }
    }
}
