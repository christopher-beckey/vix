using System;
using System.Configuration;
using System.IO;
using System.Reflection;

namespace Hydra.IX.Common
{
    public class ConfigurationLocator
    {
        /// <summary>
        /// Ensure the full path of the configuration file exists
        /// </summary>
        /// <param name="configFilePath">The given full path</param>
        /// <returns>The full path</returns>
        /// <remarks>Simplified in VAI-780</remarks>
        public static string ResolveConfigFilePath(string configFilePath)
        {
            //VAI-780
            if (File.Exists(configFilePath))
                return configFilePath;
            throw new ArgumentException(string.Format("Config file {0} does not exist", configFilePath));
        }

        public static ConfigurationSection GetConfigurationSection(string configFilePath, string sectionName)
        {
            System.Configuration.Configuration config =
                ConfigurationManager.OpenMappedExeConfiguration(new ExeConfigurationFileMap { ExeConfigFilename = configFilePath },
                                                                (ConfigurationUserLevel.None));
            var configurationSection = config.GetSection(sectionName);

            return configurationSection;
        }
    }
}