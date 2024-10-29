using Hydra.IX.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Configuration
{
    public class HixConfigurationSection : ConfigurationSection
    {
        private static HixConfigurationSection _instance = null;
        private static object _syncLock = new object();

        [ConfigurationProperty("ImageStores")]
        public ImageStoreCollection ImageStores
        {
            get 
            { 
                return ((ImageStoreCollection)(base["ImageStores"])); 
            }

            set 
            { 
                base["ImageStores"] = value; 
            }
        }

        [ConfigurationProperty("Database")]
        public DatabaseElement Database
        {
            get
            {
                return ((DatabaseElement)(base["Database"]));
            }

            set
            {
                base["Database"] = value;
            }
        }

        [ConfigurationProperty("Processor")]
        public ProcessorElement Processor
        {
            get
            {
                return ((ProcessorElement)(base["Processor"]));
            }

            set
            {
                base["Processor"] = value;
            }
        }

        [ConfigurationProperty("Purge")]
        public PurgeElement Purge
        {
            get
            {
                return ((PurgeElement)(base["Purge"]));
            }

            set
            {
                base["Purge"] = value;
            }
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

        [ConfigurationProperty("Encrypt", IsRequired = false, DefaultValue = true)]
        public bool Encrypt
        {
            get { return (bool)base["Encrypt"]; }
        }

        public static HixConfigurationSection Instance
        {
            get
            {
                lock (_syncLock)
                {
                    return _instance;
                }
            }

            set
            {
                lock (_syncLock)
                {
                    _instance = value;
                }
            }
        }

        public string ConfigFilePath { get; set; }
    }
}
