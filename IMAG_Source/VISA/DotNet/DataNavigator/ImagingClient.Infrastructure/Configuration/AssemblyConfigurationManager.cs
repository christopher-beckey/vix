// -----------------------------------------------------------------------
// <copyright file="AssemblyConfigurationManager.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace ImagingClient.Infrastructure.Configuration
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Text;
    using System.IO;
    using System.Reflection;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class AssemblyConfigurationManager
    {
        public static System.Configuration.Configuration GetConfiguration(Type type)
        {
            return GetConfiguration(type.Assembly);
        }

        public static System.Configuration.Configuration GetConfiguration(Assembly assembly)
        {
            FileInfo configFile = new FileInfo(assembly.Location + ".config");
            Configuration config = null;
            if (configFile.Exists)
            {
                ExeConfigurationFileMap fileMap = new ExeConfigurationFileMap { ExeConfigFilename = configFile.FullName };
                config = ConfigurationManager.OpenMappedExeConfiguration(fileMap, ConfigurationUserLevel.None);
            }

            return config;
        }
    }
}
