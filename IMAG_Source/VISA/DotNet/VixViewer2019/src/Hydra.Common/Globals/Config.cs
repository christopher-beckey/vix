using System;
using System.Configuration;

namespace Hydra.Globals
{
    /// <summary>
    /// Define global config settings
    /// </summary>
    /// <remarks>Introduced in VAI-707</remarks>
    public static class Config
    {
        /// <summary>
        /// Password to VIX Encrypt/Decrypt Utility
        /// </summary>
        public static string VixUtilPassword { get; set; }

        /// <summary>
        /// Get a configuration section.
        /// </summary>
        /// <typeparam name="T">Type of section</typeparam>
        /// <param name="filePath">full path of config file</param>
        /// <param name="sectionName">name of the section in the config file</param>
        /// <returns>the section (type T)</returns>
        public static T GetSection<T>(string filePath, string sectionName) where T : ConfigurationSection
        {
            System.Configuration.Configuration config =
                ConfigurationManager.OpenMappedExeConfiguration(new ExeConfigurationFileMap { ExeConfigFilename = filePath },
                                                                (ConfigurationUserLevel.None));

            return config.GetSection(sectionName) as T;
        }

        #region External Process Timeouts

        //Introduced in VAI-903

        /// <summary>
        /// Get the max duration to wait when running a process before timing out based on file size. 
        /// Larger than 20 MB means to use long timeout. Otherwise, use short.
        /// </summary>
        /// <param name="filePath">The path to the file</param>
        /// <returns>The timeout per the file size</returns>
        public static int ExternalProcessTimeoutMillisecondsSized(string filePath)
        {
            long length = new System.IO.FileInfo(filePath).Length;
            if (length > 20000000)
                return ExternalLongProcessTimeoutMilliseconds;
            return ExternalShortProcessTimeoutMilliseconds;
        }

        /// <summary>
        /// Get the max duration, 2 * 15000 milliseconds = 2 * 15 seconds = 30 seconds, to wait when running a process before timing out
        /// </summary>
        /// <remarks>java -jar to decrypt a string takes less than a second.
        ///          soffice 10 page RTF (1.7 MB) to PDF takes 1 second.
        ///          soffice 100 page RTF (17 MB) to PDF takes 7 seconds
        /// First estimate was 15 seconds, then doubled it for slow systems to make 30 seconds</remarks>
        public static int ExternalShortProcessTimeoutMilliseconds { get { return 2 * 15 * 1000; } }

        /// <summary>
        /// Get the max duration, 2 * 180000 milliseconds = 2 * 180 seconds = 6 minutes, to wait when running a process before timing out
        /// </summary>
        /// <remarks>soffice 1,000 page RTF (170 MB) to PDF takes 90 seconds.
        /// First estimate of 180 seconds, then doubled it for slow systems to make 360 seconds (6 minutes)</remarks>
        public static int ExternalLongProcessTimeoutMilliseconds { get { return 2 * 3 * 60 * 1000; } }

        #endregion External Process Timeouts
    }
}
