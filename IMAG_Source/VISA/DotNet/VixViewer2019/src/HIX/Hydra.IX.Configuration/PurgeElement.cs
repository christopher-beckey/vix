using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Configuration
{
    public class PurgeElement : ConfigurationElement
    {
        [ConfigurationProperty("PurgeTimes", IsRequired = false, DefaultValue = "")]
        public string PurgeTimes
        {
            get { return (string)base["PurgeTimes"]; }
        }

        [ConfigurationProperty("Enabled", IsRequired = false, DefaultValue = true)]
        public bool Enabled 
        {
            get { return (bool)base["Enabled"]; }
        }

        [ConfigurationProperty("MaxAgeDays", IsRequired = false, DefaultValue = 0)]
        public int MaxAgeDays
        {
            get { return (int)base["MaxAgeDays"]; }
        }

        [ConfigurationProperty("MaxCacheSizeMB", IsRequired = false, DefaultValue = 10480.0)]
        public double MaxCacheSizeMB
        {
            get { return (double)base["MaxCacheSizeMB"]; }
        }

        [ConfigurationProperty("ImageGroupPurgeBlockSize", IsRequired = false, DefaultValue = 200)]
        public int ImageGroupPurgeBlockSize
        {
            get { return (int)base["ImageGroupPurgeBlockSize"]; }
        }

        [ConfigurationProperty("ImagePurgeBlockSize", IsRequired = false, DefaultValue = 1000)]
        public int ImagePurgeBlockSize
        {
            get { return (int)base["ImagePurgeBlockSize"]; }
        }

        [ConfigurationProperty("EnableCacheCleanup", IsRequired = false, DefaultValue = true)]
        public bool EnableCacheCleanup
        {
            get { return (bool)base["EnableCacheCleanup"]; }
        }

        [ConfigurationProperty("MaxEventLogAgeDays", IsRequired = false, DefaultValue = 30)]
        public int MaxEventLogAgeDays
        {
            get { return (int)base["MaxEventLogAgeDays"]; }
        }
    }
}
