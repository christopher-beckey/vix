using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class ClientAuthenticationElement : ConfigurationElement
    {
        [ConfigurationProperty("StoreName", DefaultValue = StoreName.My)]
        public StoreName StoreName
        {
            get { return (StoreName)base["StoreName"]; }
        }

        [ConfigurationProperty("StoreLocation", DefaultValue = StoreLocation.CurrentUser)]
        public StoreLocation StoreLocation
        {
            get { return (StoreLocation)base["StoreLocation"]; }
        }

        [ConfigurationProperty("CertificateThumbprints", DefaultValue = "")]
        public string CertificateThumbprints
        {
            get { return (string)base["CertificateThumbprints"]; }
        }

        [ConfigurationProperty("IncludeVixSecurityToken", DefaultValue = true)]
        public bool IncludeVixSecurityToken
        {
            get { return (bool)base["IncludeVixSecurityToken"]; }
        }

        [ConfigurationProperty("SecureElements")]
        public Hydra.IX.Common.SecureElementCollection SecureElements
        {
            get
            {
                return ((Hydra.IX.Common.SecureElementCollection)(base["SecureElements"]));
            }

            set
            {
                base["SecureElements"] = value;
            }
        }
    }
}
