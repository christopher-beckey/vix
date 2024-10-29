/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */

namespace ImagingClient.Infrastructure.Configuration
{
    using System;
    using System.Configuration;
    using System.IO;
    using ImagingClient.Infrastructure.Utilities;

    /// <summary>
    /// Utility class for manipulating tha application configuration file
    /// </summary>
    public class ConfigUtils
    {
        /// <summary>
        /// Adds or replaces an entry in the AppSettings section of the config file and saves the changes.
        /// </summary>
        /// <param name="key">The AppSetting key</param>
        /// <param name="value">The AppSetting value</param>
        public static void AddOrReplaceAppSetting(string key, string value)
        {
            string exePath = GetExePath();

            // Get the configuration file. The file name has
            // this format appname.exe.config.
            System.Configuration.Configuration config = ConfigurationManager.OpenExeConfiguration(exePath);
            config.AppSettings.Settings.Remove(key);
            config.AppSettings.Settings.Add(key, value);
            config.Save(ConfigurationSaveMode.Modified);
            ConfigurationManager.RefreshSection("appSettings");
        }

        /// <summary>
        /// Gets the app setting from the application's config file
        /// </summary>
        /// <param name="key">The key of the app setting</param>
        /// <returns>The value of the app setting</returns>
        public static string GetAppSetting(string key)
        {
            string exePath = GetExePath();
            string value = String.Empty;

            // Get the configuration file. The file name has
            // this format appname.exe.config.
            System.Configuration.Configuration config = ConfigurationManager.OpenExeConfiguration(exePath);

            if (config.AppSettings.Settings[key] != null)
            {
                value = config.AppSettings.Settings[key].Value;
            }

            return value;
        }

        /// <summary>
        /// Gets the path of the execuatable.
        /// </summary>
        /// <returns>The path of the executable</returns>
        private static string GetExePath()
        {
            // Get the application path needed to obtain
            // the application configuration file.
#if DEBUG
            string applicationName = Environment.GetCommandLineArgs()[0];
#else
                string applicationName = Environment.GetCommandLineArgs()[0]+ ".exe";
#endif

            return PathUtilities.CombinePath(Environment.CurrentDirectory, applicationName);
        }
    }
}
