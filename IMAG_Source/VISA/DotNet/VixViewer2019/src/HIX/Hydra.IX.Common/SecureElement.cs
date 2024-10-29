using Hydra.Security;
using System.Configuration;

namespace Hydra.IX.Common
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
                    return CryptoUtil.DecryptAES((string)base["Value"]);
                else
                    return (string)base["Value"];
            }
        }
    }
}
