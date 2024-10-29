// -----------------------------------------------------------------------
// <copyright file="AssemblyConfigurationManager.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 11/30/2011
//   Site Name:  Washington OI Field Office, Silver Spring, MD
//   Developer: vhaiswgraver
//   Description: 
//         ;; +--------------------------------------------------------------------+
//         ;; Property of the US Government.
//         ;; No permission to copy or redistribute this software is given.
//         ;; Use of unreleased versions of this software requires the user
//         ;;  to execute a written test agreement with the VistA Imaging
//         ;;  Development Office of the Department of Veterans Affairs,
//         ;;  telephone (301) 734-0100.
//         ;;
//         ;; The Food and Drug Administration classifies this software as
//         ;; a Class II medical device.  As such, it may not be changed
//         ;; in any way.  Modifications to this software may result in an
//         ;; adulterated medical device under 21CFR820, the use of which
//         ;; is considered to be a violation of US Federal Statutes.
//         ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.Configuration
{
    using System;
    using System.Configuration;
    using System.IO;
    using System.Reflection;

    /// <summary>
    /// Configuration manager for assemblies
    /// </summary>
    public class AssemblyConfigurationManager
    {
        /// <summary>
        /// Gets the configuration for the assembly containing the specified type.
        /// </summary>
        /// <param name="type">A type within the target assembly.</param>
        /// <returns>The Configuration for the assumbly</returns>
        public static System.Configuration.Configuration GetConfiguration(Type type)
        {
            return GetConfiguration(type.Assembly);
        }

        /// <summary>
        /// Gets the configuration for the specified assembly.
        /// </summary>
        /// <param name="assembly">The target assembly.</param>
        /// <returns>The Configuration for the assumbly</returns>
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
