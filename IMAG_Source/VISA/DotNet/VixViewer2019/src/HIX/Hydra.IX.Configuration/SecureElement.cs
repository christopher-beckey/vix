using Hydra.IX.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Configuration
{
    public class SecureElement : ConfigurationElement
    {
        [ConfigurationProperty("IsEncrypted", IsRequired = true)]
        public bool IsEncrypted 
        {
            get { return (bool)base["IsEncrypted"]; }
        }

        [ConfigurationProperty("Name", IsRequired = true, IsKey = true)]
        public string Name
        {
            get { return (string)base["Name"]; }
        }

        [ConfigurationProperty("Value", IsRequired = true)]
        public string Value
        {
            get 
            {
                if (IsEncrypted)
                    return HixCryptoUtil.DecryptAES((string)base["Value"]);
                else
                    return (string)base["Value"];
            }
        }
    }
}
