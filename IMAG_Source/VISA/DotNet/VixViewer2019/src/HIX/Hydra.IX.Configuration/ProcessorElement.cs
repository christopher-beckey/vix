using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Configuration
{
    public class ProcessorElement : ConfigurationElement
    {
        [ConfigurationProperty("WorkerPoolSize", IsRequired = false, DefaultValue = 10)]
        public int WorkerPoolSize
        {
            get { return (int)base["WorkerPoolSize"]; }
        }

        [ConfigurationProperty("UseSeparateProcess", IsRequired = false, DefaultValue = true)]
        public bool UseSeparateProcess
        {
            get { return (bool)base["UseSeparateProcess"]; }
        }

        [ConfigurationProperty("CacheStudyMetadata", IsRequired = false, DefaultValue = false)]
        public bool CacheStudyMetadata
        {
            get { return (bool)base["CacheStudyMetadata"]; }
        }

        [ConfigurationProperty("ReprocessFailedImages", IsRequired = false, DefaultValue = false)]
        public bool ReprocessFailedImages
        {
            get { return (bool)base["ReprocessFailedImages"]; }
        }

        [ConfigurationProperty("Enable3D", IsRequired = false, DefaultValue = false)]
        public bool Enable3D
        {
            get { return (bool)base["Enable3D"]; }
        }

        [ConfigurationProperty("OpTimeOutMins", IsRequired = false, DefaultValue = 1)]
        public int OpTimeOutMins
        {
            get { return (int)base["OpTimeOutMins"]; }
        }
    }
}
