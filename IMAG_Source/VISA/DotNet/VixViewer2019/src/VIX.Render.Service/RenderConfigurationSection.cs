using Hydra.IX.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace VIX.Render.Service
{
    public class RenderConfigurationSection : ConfigurationSection
    {
        private static RenderConfigurationSection _instance = null;
        private static object _syncLock = new object();

        [ConfigurationProperty("ServerUrl", IsRequired = true)]
        public string ServerUrl
        {
            get { return (string)base["ServerUrl"]; }
        }

        public static RenderConfigurationSection Instance
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

        public static void Initialize()
        {
            lock (_syncLock)
            {
                string configFilePath = ConfigurationLocator.ResolveConfigFilePath(Globals.ConfigFilePath);
                _instance = ConfigurationLocator.GetConfigurationSection(configFilePath, "Render") as RenderConfigurationSection;
                if (_instance == null)
                    throw new ConfigurationErrorsException("Render configuration section not found");

                if (string.IsNullOrEmpty(_instance.ServerUrl))
                    throw new ConfigurationErrorsException("Render configuration section - Server Url is not valid");
            }
        }
    }
}
