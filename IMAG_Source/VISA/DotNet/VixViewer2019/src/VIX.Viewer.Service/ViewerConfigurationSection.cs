using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace VIX.Viewer.Service
{
    public class ViewerConfigurationSection : ConfigurationSection
    {
        private static ViewerConfigurationSection _instance = null;
        private static object _syncLock = new object();

        [ConfigurationProperty("ServerUrl", IsRequired = true)]
        public string ServerUrl
        {
            get { return (string)base["ServerUrl"]; }
        }

        public static ViewerConfigurationSection Instance
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
                string configFilePath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "VistA.config");
                if (!File.Exists(configFilePath))
                    throw new ArgumentException("Config file does not exist");
                System.Configuration.Configuration config =
                    ConfigurationManager.OpenMappedExeConfiguration(new ExeConfigurationFileMap { ExeConfigFilename = configFilePath }, 
                                                                    (ConfigurationUserLevel.None));
                _instance = config.GetSection("Viewer") as ViewerConfigurationSection;
                if (_instance == null)
                    throw new ConfigurationErrorsException("Viewer configuration section not found");

                if (string.IsNullOrEmpty(_instance.ServerUrl))
                    throw new ConfigurationErrorsException("Viewer configuration section - Server Url is not valid");
            }
        }
    }
}
