using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Threading.Tasks;
using Microsoft.Win32;
using System.Diagnostics;


namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    class RegistryUtilities
    {

        /// <summary>
        /// Retrieve a logger for this class.
        /// </summary>
        /// <returns>A logger as a ILog interface.</returns>
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(RegistryUtilities).Name);
        }

        //WFP-Not ready for prime time.
        private static string GetRegistryString(string key, string value, NativeType native)
        {
            string installationPath = null;
            RegistryKey javasoft = null;
            try
            {
                if (native == NativeType.x86)
                {
                    using (RegistryKey localMachine32 = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry32))
                    {
                        javasoft = localMachine32.OpenSubKey(key, false);
                    }
                }
                else
                {
                    using (RegistryKey localMachine64 = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry64))
                    {
                        javasoft = localMachine64.OpenSubKey(key, false);
                    }
                }
                if (javasoft != null)
                {
                    installationPath = javasoft.GetValue(value) as string;
                    Logger().Info("Registry key: " + javasoft as string);
                }
                return installationPath;
            }
            finally
            {
                javasoft.Dispose();
            }
        }

        /// <summary>
        /// Checks the registry to see if the specified key exists.
        /// </summary>
        /// <param name="key">A keypath rooted on one of the top level registry hives.</param>
        /// <returns>true if the registry key exists, false otherwise.</returns>
        public static bool DoesRegKeyExist(string key)
        {
            bool exist = false;
            RegistryView regView = RegistryView.Registry64;

            if (key != null && key != "")
            {
                using (RegistryKey reg = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
                {
                    using (RegistryKey regKey = reg.OpenSubKey(key)) // read only access
                    {
                        if (regKey != null)
                        {
                            exist = true;
                        }
                    }
                }
            }

            return exist;
        }


    }
}
