using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Microsoft.Win32;
using System.Diagnostics;
using System.Xml;
using System.Runtime.InteropServices;
using log4net;
using System.Threading;
using System.Security.AccessControl;
using System.Security.Principal;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{

    public static class TomcatFacade
    {
        /// <summary>
        /// Retrieve a logger for this class.
        /// </summary>
        /// <returns>A logger as a ILog interface.</returns>
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(TomcatFacade).Name);
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
        private class MEMORYSTATUSEX
        {
            public uint dwLength;
            public uint dwMemoryLoad;
            public ulong ullTotalPhys;
            public ulong ullAvailPhys;
            public ulong ullTotalPageFile;
            public ulong ullAvailPageFile;
            public ulong ullTotalVirtual;
            public ulong ullAvailVirtual;
            public ulong ullAvailExtendedVirtual;
            public MEMORYSTATUSEX()
            {
                this.dwLength = (uint)Marshal.SizeOf(typeof(MEMORYSTATUSEX));
            }
        }

        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        static extern bool GlobalMemoryStatusEx([In, Out] MEMORYSTATUSEX lpBuffer);

        private static readonly String TOMCAT_SERVICE_ACCOUNT_NAME = "apachetomcat";
        private static readonly String TOMCAT_ADMIN_ACCOUNT_NAME = "admin";
        private static readonly String TOMCAT_CONFIGURATION_FOLDER = "conf";
        private static readonly String TOMCAT_EXECUTABLE_FOLDER = "bin";
        private static readonly String TOMCAT_LIB_FOLDER = "lib";
        private static readonly String TOMCAT_LOG_FOLDER = "logs";
        private static readonly String TOMCAT_LOG_FOLDER_ENCRYPTED = @"logs\secure";
        private static readonly String TOMCAT_WEBAPP_FOLDER = "webapps";
        private static readonly String TOMCAT_AXIS2_WEBAPP_FOLDER = @"webapps\axis2\WEB-INF\services";
        private static readonly String TOMCAT_USERS_FILENAME = @"tomcat-users.xml";

        #region properties
        private static string _TomcatServiceAccountName = TOMCAT_SERVICE_ACCOUNT_NAME; 
        public static string TomcatServiceAccountName {
            get { return _TomcatServiceAccountName; }
            set { _TomcatServiceAccountName = value; }
        }

        private static string _ServiceAccountUsername =  TOMCAT_SERVICE_ACCOUNT_NAME;
        public static string ServiceAccountUsername {
            get { return _ServiceAccountUsername; }
            set { _ServiceAccountUsername = value; }
        }
        
        public static string TomcatAdminAccountName { get { return TOMCAT_ADMIN_ACCOUNT_NAME; } }
        public static VixManifest Manifest { get; set; }
        public static string TomcatConfigurationFolder { get { return Path.Combine(TomcatFacade.TomcatInstallationFolder, TOMCAT_CONFIGURATION_FOLDER); } }
        public static string TomcatExecutableFolder { get { return Path.Combine(TomcatFacade.TomcatInstallationFolder, TOMCAT_EXECUTABLE_FOLDER); } }
        public static string TomcatLibFolder { get { return Path.Combine(TomcatFacade.TomcatInstallationFolder, TOMCAT_LIB_FOLDER); } }
        public static string TomcatLogFolder { get { return Path.Combine(TomcatFacade.TomcatInstallationFolder, TOMCAT_LOG_FOLDER); } }
        public static string TomcatLogFolderEncrypted { get { return Path.Combine(TomcatFacade.TomcatInstallationFolder, TOMCAT_LOG_FOLDER_ENCRYPTED); } }
        public static string TomcatWebApplicationFolder { get { return Path.Combine(TomcatFacade.TomcatInstallationFolder, TOMCAT_WEBAPP_FOLDER); } }
        public static string TomcatAxis2WebApplicationFolder { get { return Path.Combine(TomcatFacade.TomcatInstallationFolder, TOMCAT_AXIS2_WEBAPP_FOLDER); } }
        public static string ActiveTomcatVersion { get { return Manifest.ActiveTomcatPrerequisite.Version; } }
        public static string InstallerFilespec { get { return Manifest.ActiveTomcatPrerequisite.InstallerFilespec; } }

        /// <summary>
        /// Gets the Tomcat Windows service name.
        /// </summary>
        public static string TomcatServiceName
        {
            get
            {
                string serviceName = null;
                Debug.Assert(TomcatFacade.IsTomcatInstalled() == true);
                string key = null;
                RegistryView regView = RegistryView.Registry64;
                if (BusinessFacade.Is64BitOperatingSystem())
                {
                    // Procrun key will be installed under Wow6432Node key - even if Tomcat 6.0.35 is installed natively
                    key = @"SOFTWARE\Wow6432Node\Apache Software Foundation\Procrun 2.0";
                }
                else
                {
                    key = @"SOFTWARE\Apache Software Foundation\Procrun 2.0";
                }
                using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
                {
                    using (RegistryKey procrun = regKey.OpenSubKey(key, true))
                    {
                        Debug.Assert(procrun != null);
                        Debug.Assert(procrun.SubKeyCount > 0);
                        string[] subkeys = procrun.GetSubKeyNames();
                        foreach(string subkey in subkeys)
                        {
                            if (subkey.ToLower().StartsWith("tomcat"))
                            {
                                serviceName = subkey;
                            }
                        }
                        //serviceName = subkeys[0];
                    }
                    return serviceName;
                }
            }
        }

        /// <summary>
        /// Gets the tomcat installation folder.
        /// </summary>
        public static string TomcatInstallationFolder
        {
            get
            {
                string installationFolder = GetTomcatInstallationFolder(@"SOFTWARE\Apache Software Foundation\Tomcat");
                Logger().Info("Installation Folder outside of IF Statement: " + installationFolder);
                if (installationFolder == null)
                {
                    Debug.Assert(BusinessFacade.Is64BitOperatingSystem() == true);
                    installationFolder = GetTomcatInstallationFolder(@"SOFTWARE\Wow6432Node\Apache Software Foundation\Tomcat");
                    Logger().Info("Installation Folder inside of IF Statement: " + installationFolder);
                }
                return installationFolder;
            }
        }

        /// <summary>
        /// Gets the installed deprecated tomcat version.
        /// </summary>
        /// <remarks>Can return null.</remarks>
        public static string DeprecatedTomcatVersion
        {
            get
            {
                TomcatPrerequisite prerequisite = GetInstalledDeprecatedTomcatPrerequsite();
                return prerequisite == null ? null : prerequisite.Version;
            }
        }

        /// <summary>
        /// Gets the installed tomcat version as a string.
        /// </summary>
        /// <remarks>Could return null if Tomcat is not installed.</remarks>
        public static string InstalledTomcatVersion
        {
            get
            {
                string installedVersion = GetInstalledTomcatVersion(@"SOFTWARE\Apache Software Foundation\Tomcat");
                if (installedVersion == null)
                {
                    Debug.Assert(BusinessFacade.Is64BitOperatingSystem() == true);
                    installedVersion = GetInstalledTomcatVersion(@"SOFTWARE\Wow6432Node\Apache Software Foundation\Tomcat");
                }
                return installedVersion;
            }
        }

        #endregion

        #region public methods


        /// <summary>
        /// Disables the tomcat monitor (tomcat6w.exe) from running when logging in under the user credentials where Tomcat was installed.
        /// </summary>
        /// <remarks>On Windows 2008 systems with UAC cranked up, an error dialog is being displayed because the tomcat monitor needs to be started as Administrator. Also note
        /// that this method is tied to Tomcat 6.</remarks>
        public static void DisableTomcatMonitor()
        {
            string key = @"Software\Microsoft\Windows\CurrentVersion\Run";
            RegistryView regView = RegistryView.Registry64;
            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.CurrentUser, regView))
            {
                using (RegistryKey run = regKey.OpenSubKey(key, true))
                {
                    if (run != null)
                    {
                        if (run.GetValue("ApacheTomcatMonitor6.0_Tomcat6") != null)
                        {
                            run.DeleteValue("ApacheTomcatMonitor6.0_Tomcat6");
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Check to see if any version of Tomcat is installed without caring if the current installation is active or deprecated.
        /// </summary>
        /// <returns><c>true</c> if Tomcat is installed; otherwise <c>false</c></returns>
        public static bool IsTomcatInstalled()
        {
            Logger().Info("Entered IsTomcatInstalled() method.");
            // strategy change - check for existance of the "Procrun 2.0" subkey since sometime after Tomcat 6.0.20 there was an additional level of
            // subkey added under the Tomcat subkey which complicates testing for installation.
            // The inherient assumption is that  Tomcat will be installed using the windows service installer which installs Procrun. - DKB 10/5/2011
            bool isInstalled = false;
            string key = null;
            RegistryView regView = RegistryView.Registry64;
            if (BusinessFacade.Is64BitOperatingSystem())
            {
                // Procrun key will be installed under Wow6432Node key - even if Tomcat 6.0.35 is installed natively
                // TODO: This must be checked for each version of Tomcat that we support
                key = @"SOFTWARE\Wow6432Node\Apache Software Foundation";
            }
            else
            {
                key = @"SOFTWARE\Apache Software Foundation";
            }
            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
            {
                using (RegistryKey apache = regKey.OpenSubKey(key, true))
                {
                    if (apache != null)
                    {
                        if (apache.SubKeyCount > 0) // Tomcat key hangs around after an uninstall
                        {
                            string[] subkeys = apache.GetSubKeyNames();
                            foreach (string subkey in subkeys)
                            {
                                if (subkey.ToLower().StartsWith("procrun"))
                                {
                                    string procrunKey = key + @"\" + subkey;

                                    using (RegistryKey procrun = regKey.OpenSubKey(procrunKey, true))
                                    {
                                        if (procrun != null)
                                        {
                                            if (procrun.SubKeyCount > 0)
                                            {
                                                string[] procrunSubkeys = procrun.GetSubKeyNames();
                                                foreach (string procrunSubkey in procrunSubkeys)
                                                {
                                                    if (procrunSubkey.ToLower().StartsWith("tomcat"))
                                                    {
                                                        isInstalled = true;
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Logger().Info("Tomcat is installed: " + isInstalled);
            return isInstalled;
        }

        /// <summary>
        /// Disable stdout logging for Tomcat
        /// </summary>
        public static void DisableStdOutLogging()
        {
            string key = null;
            RegistryView regView = RegistryView.Registry64;
            if (BusinessFacade.Is64BitOperatingSystem())
            {
                // Procrun key will be installed under Wow6432Node key - even if Tomcat 6.0.33 is installed natively
                key = @"SOFTWARE\Wow6432Node\Apache Software Foundation\Procrun 2.0\" + TomcatFacade.TomcatServiceName + @"\Parameters\Log";
            }
            else
            {
                key = @"SOFTWARE\Apache Software Foundation\Procrun 2.0\" + TomcatFacade.TomcatServiceName + @"\Parameters\Log";
            }

            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
            {
                using (RegistryKey tomcat = regKey.OpenSubKey(key, true))
                {
                    if (tomcat != null)
                    {
                        tomcat.DeleteValue("StdOutput", false);
                        tomcat.DeleteValue("StdError", false);
                    }
                }
            }
        }

        /// <summary>
        /// Returns true if the Tomcat service is installed
        /// </summary>
        /// <returns><c>true</c>if Tomcat service is installed; otherwise <c>false</c>.</returns>
        /// <remarks>Used to check to see if Tomcat was uninstalled sucessfully.</remarks>
        public static bool IsDeprecatedTomcatServiceInstalled()
        {
            bool isInstalled = false;
            foreach (TomcatPrerequisite prerequisite in Manifest.DeprecatedTomcatPrerequisites)
            {
                if (ServiceUtilities.IsNonDriverServiceInstalled(prerequisite.ServiceName) == true)
                {
                    isInstalled = true;
                    break;
                }
            }
            return isInstalled;
        }

        /// <summary>
        /// Determines if the required version (as indicated by the active prerequisite entry in the manifest) of Apache Tomcat is installed.
        /// </summary>
        /// <returns><c>true</c> if the required version Apache Tomcat is installed; otherwise <c>false</c>.</returns>
        public static bool IsActiveTomcatVersionInstalled()
        {
            Logger().Info("Entered IsActiveTomcatVersionInstalled() method.");
            bool isInstalled = false;

            if (TomcatFacade.IsTomcatInstalled())
            {
                if (IsPrerequisiteInstalled(Manifest.ActiveTomcatPrerequisite))
                {
                    isInstalled = true;
                }
            }
            Logger().Info("Tomcat is installed: " + isInstalled);
            return isInstalled;
        }

        /// <summary>
        /// Determines if a deprecated version (as indicated by the deprecated prerequisite entry in the manifest) of Apache Tomcat is installed.
        /// </summary>
        /// <returns><c>true</c> if the deprecated version Apache Tomcat is installed; otherwise <c>false</c>.</returns>
        public static bool IsDeprecatedTomcatVersionInstalled()
        {
            bool isInstalled = false;

            if (TomcatFacade.IsTomcatInstalled())
            {
                if (GetInstalledDeprecatedTomcatPrerequsite() != null)
                {
                    isInstalled = true;
                }
            }
            return isInstalled;
        }

        /// <summary>
        /// Gets the tomcat working folder.
        /// </summary>
        /// <param name="siteNumber">The site number that is part of the owrking folder naming pattern.</param>
        /// <returns>The fully qualified working folder.</returns>
        public static string GetTomcatWorkFolder(string siteNumber)
        {
            String workPath = @"work\Catalina\" + siteNumber + ".med.va.gov";
            return Path.Combine(TomcatFacade.TomcatInstallationFolder, workPath);
        }

        /// <summary>
        /// Parses the existing tomcat admin password out of tomcat-users.xml.
        /// </summary>
        /// <returns>tomcat admin password</returns>
        public static string GetExistingTomcatAdminPassword()
        {
            string tomcatAdminPassword = null;
            String tomcatUsersPath = Path.Combine(TomcatFacade.TomcatConfigurationFolder, TOMCAT_USERS_FILENAME);
            if (File.Exists(tomcatUsersPath))
            {
                XmlDocument users = new XmlDocument();
                users.Load(tomcatUsersPath);
                XmlNode admin = users.SelectSingleNode("tomcat-users/user[@username='admin']");
                if (admin == null)
                {
                    admin = users.SelectSingleNode("tomcat-users/user[@name='admin']"); // bug in previous versions - wrote name attribute instead of username
                }
                Debug.Assert(admin != null);
                tomcatAdminPassword = admin.Attributes["password"].Value.Trim();
                Debug.Assert(tomcatAdminPassword != null);
            }
            return tomcatAdminPassword;
        }

        /// <summary>
        /// Creates the Apache Tomcat configuration file that defines users and roles. As part of this process
        /// creates a user specified account using the passed credentials which will have the admin and manager roles.
        /// </summary>
        /// <param name="username">The username that will be given the admin and manager roles.</param>
        /// <param name="password">The password associated with the username.</param>
        public static void ConfigureTomcatUsers(IVixConfigurationParameters config)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("<tomcat-users>");
            sb.AppendLine("\t<role rolename=\"clinical-display-user\"/>");
            sb.AppendLine("\t<role rolename=\"administrator\"/>");
            sb.AppendLine("\t<role rolename=\"developer\"/>");
            sb.AppendLine("\t<role rolename=\"tomcat\"/>");
            sb.AppendLine("\t<role rolename=\"manager\"/>");
            sb.AppendLine("\t<role rolename=\"peer-vixs\"/>");
            sb.AppendLine("\t<role rolename=\"admin\"/>");
            sb.AppendLine("\t<role rolename=\"vista-user\"/>");
            sb.AppendLine("\t<role rolename=\"tester\"/>");
            sb.AppendLine("\t<user username=\"alexdelarge\" password=\"655321\" roles=\"clinical-display-user,vista-user\"/>");
            sb.AppendLine("\t<user username=\"vixlog\" password=\"tachik0ma\" roles=\"administrator,tester\"/>");
            sb.AppendLine("\t<user username=\"vixs\" password=\"vixs\" roles=\"peer-vixs\"/>");
            sb.AppendLine("\t<user username=\"roiuser\" password=\"asXRo1o1\" roles=\"clinical-display-user\"/>");
            string pw = config.TomcatAdminPassword;
            if (pw == null)
            {
                pw = config.SiteAbbreviation.Trim() + "x14y2";
            }
            sb.AppendFormat("\t<user username=\"{0}\" password=\"{1}\" roles=\"admin,manager\" />", TOMCAT_ADMIN_ACCOUNT_NAME, pw);
            sb.Append(Environment.NewLine);
            sb.AppendLine("</tomcat-users>");

            String tomcatUsersPath = Path.Combine(TomcatFacade.TomcatConfigurationFolder, TOMCAT_USERS_FILENAME);
            using (TextWriter tw = new StreamWriter(tomcatUsersPath))
            {
                tw.Write(sb.ToString());
            }
        }

        /// <summary>
        /// Perform the service setup that would ordinarily be done using tomcat5w.exe. 
        /// Currently this sets memory options for the JVM, and configures service failure actions
        /// </summary>
        public static void ConfigureTomcatService(IVixConfigurationParameters config)
        {
            ConfigureTomcatJvmMemory(config);
            // if running on a HAC node then do not configure recovery options for the Tomcat service.
            if (ClusterFacade.IsServerClusterNode() == false)
            {
                ServiceUtilities.SetServiceFailureActions(TomcatFacade.TomcatServiceName);
            }
        }

        /// <summary>
        /// Set Tomcat JVM memory usage
        /// </summary>
        /// <remarks>This method makes decisions based on the allowed process size on the operating system.</remarks>
        public static void ConfigureTomcatJvmMemory(IVixConfigurationParameters config)
        {
            ulong totalPhysicalMemory = GetPhysicalMemorySizeInBytes();

            int jvmMemoryInMb = (int)(totalPhysicalMemory / (1024 * 1024 * 4)); // convert to MB then take 25% for JVM use
            if (jvmMemoryInMb > 1024 && Manifest.CurrentNativeInstallation == NativeType.x86)
            {
                jvmMemoryInMb = 1024; // dont exceed this for 32 bit process so that sufficient native windows memory exists for Aware and LB
            }

            string key = null;
            RegistryView regView = RegistryView.Registry64;
            if (BusinessFacade.Is64BitOperatingSystem())
            {
                // Procrun key will be installed under Wow6432Node key - even if Tomcat 6.0.33 is installed natively
                key = @"SOFTWARE\Wow6432Node\Apache Software Foundation\Procrun 2.0\" + TomcatFacade.TomcatServiceName + @"\Parameters\Java";
            }
            else
            {
                key = @"SOFTWARE\Apache Software Foundation\Procrun 2.0\" + TomcatFacade.TomcatServiceName + @"\Parameters\Java";
            }
            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
            {
                using (RegistryKey java = regKey.OpenSubKey(key, true))
                {
                    java.SetValue("JvmMs", jvmMemoryInMb, RegistryValueKind.DWord);
                    java.SetValue("JvmMx", jvmMemoryInMb, RegistryValueKind.DWord);
                    java.SetValue("JvmSs", 0, RegistryValueKind.DWord);
                }
            }
        }

        /// <summary>
        /// Creates and/or encrypts the secure log sub directory
        /// </summary>
        /// <param name="config"></param>
        ////public static void ConfigureTomcatEncryptedLogFolder(IVixConfigurationParameters config)
        ////{
        ////    DirectoryInfo encryptedLogDir = new DirectoryInfo(TomcatLogFolderEncrypted);
        ////    if (!encryptedLogDir.Exists)
        ////    {
        ////        encryptedLogDir.Create();
        ////        // recreate the DirectoryInfo object because the old one has cached data before the dir was created
        ////        encryptedLogDir = new DirectoryInfo(TomcatLogFolderEncrypted);
        ////    }
        ////    // check if encrypted flag is set
        ////    if ((encryptedLogDir.Attributes & FileAttributes.Encrypted) == 0) // bitwise AND to check if the Encryped flag is set
        ////    {
        ////        // encrypted flag not set, so set it
        ////        // Setting the DirectoryInfo.Attributes to add the encryption flag doesn't work
        ////        // Instead use the FileInfo.Encrypt method (DirectoryInfo does not have an Encrypt method)
        ////        try
        ////        {
        ////            FileInfo encryptedLogDirFile = new FileInfo(TomcatLogFolderEncrypted);
        ////            encryptedLogDirFile.Encrypt();
        ////        }
        ////        catch (Exception ex)
        ////        {
        ////            Logger().Error(ex.Message);
        ////            Logger().Error("Error encrypting " + TomcatLogFolderEncrypted + ". Install proceding can continue.");
        ////        }
        ////    }
        ////}

        /// <summary>
        /// Fixup the Procrun service to point to the JVM specified in the manifest.
        /// </summary>
        public static void FixupTomcatServiceJvm()
        {
            string key = null;
            RegistryView regView = RegistryView.Registry64;

            string tomcatServiceName = TomcatFacade.TomcatServiceName;
            Logger().Info("TomcatServicename: " + tomcatServiceName);

            if (BusinessFacade.Is64BitOperatingSystem())
            {
                // Procrun key will be installed under Wow6432Node key - even if Tomcat 6.0.33 is installed natively
                key = @"SOFTWARE\Wow6432Node\Apache Software Foundation\Procrun 2.0\" + tomcatServiceName + @"\Parameters\Java";
            }
            else
            {
                key = @"SOFTWARE\Apache Software Foundation\Procrun 2.0\" + tomcatServiceName + @"\Parameters\Java";
            }

            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
            {
                using (RegistryKey java = regKey.OpenSubKey(key, true))
                {
                    string jvm = (string)java.GetValue("Jvm", null);
                    string javaPath = JavaFacade.GetActiveJavaPath(JavaFacade.IsActiveJreInstalled());
                    
                    //Debug.Assert(jvm != null);

                    if ((jvm == null) || (!jvm.ToUpper().Contains(javaPath.ToUpper())))
                    {
                        jvm = Path.Combine(javaPath, @"bin\server\jvm.dll");
                        java.SetValue("Jvm", jvm, RegistryValueKind.String);
                    }
                }
            }
        }

        /// <summary>
        /// Uninstall the current deprecated installation of Tomcat as specifed by the manifest
        /// </summary>
        public static void UninstallDeprecatedTomcat()
        {
            TomcatPrerequisite prerequisite = GetInstalledDeprecatedTomcatPrerequsite();
            if (prerequisite != null)
            {
                string tomcatInstallFolder = TomcatFacade.TomcatInstallationFolder; // get the install folder before the registry key this comes from is wiped out - either by unregister or uninstall

                if (prerequisite.UnregisterFilename != null)
                {
                    UnregisterTomcat(prerequisite, tomcatInstallFolder);
                }

                UninstallTomcat(prerequisite, tomcatInstallFolder);

                if (prerequisite.DeleteUninstallerRegistryKey != null)
                {
                    Registry.LocalMachine.DeleteSubKey(prerequisite.DeleteUninstallerRegistryKey, false); // raise no exception if the subkey does not exist
                }

                //  BT 5/22/2017 Delete remnant left by the tomcat uninstaller
                Logger().Info("TomcatRegistryKey: " + prerequisite.TomcatRegistryKey);
                if (prerequisite.TomcatRegistryKey != null)
                {
                    Registry.LocalMachine.DeleteSubKeyTree(prerequisite.TomcatRegistryKey, true); // raise no exception if the subkey does not exist
                }

                if (prerequisite.DeleteStartMenuFolder != null)
                {
                    try
                    {
                        if (Directory.Exists(prerequisite.DeleteStartMenuFolder))
                        {
                            Directory.Delete(prerequisite.DeleteStartMenuFolder, true); // recurse
                        }
                    }
                    catch (Exception ex)
                    {
                        Logger().Info("Exception while deleting Tomcat Start Menu Group: " + ex.Message);
                    }
                }
            }
        }

        public static bool CheckAndFixTomcatUserAccess()
        {
            if (!TomcatFacade.TestTomcatUserAccess(TOMCAT_SERVICE_ACCOUNT_NAME))
            {
                Logger().Info("Corrupted TomcatUserAccess - deleting user and uninstalling tomcat");
                if (TomcatFacade.DeleteTomcatUser(TOMCAT_SERVICE_ACCOUNT_NAME))
                {
                    Logger().Info("CheckAndFixTomcatUserAccess - user deleted successfully or doesn't exist");

                    TomcatFacade.UninstallCurrentTomcat();

                    if (!JavaFacade.UninstallCurrentJre())
                    {
                        Logger().Info("Unable to uninstall java programmatically, please remove java and tomcat manually and reinstall");
                        return false;
                    }

                    string vixconfig = VixFacade.GetVixConfigurationDirectory();

                    if (vixconfig == null)
                        vixconfig = @"c:\vixconfig";

                    VixConfigurationParameters config = VixConfigurationParameters.FromXml(vixconfig);
                    if (config != null)
                        VixFacade.DeleteLocalCacheRegions(config);

                    return true;
                }
                else
                {
                    Logger().Info("Unable to delete apachetomcat user. Delete apachetomcat user and uninstall java and tomcat manually");
                    return false;
                }
            }
            else
            {
                return true;
            }
        }

        public static bool TestTomcatUserAccess(string user)
        {
            //Nothing is installed - good to go, installer will create user and install tomcat
            if (!AccessContolUtilities.IsUserExist(user) && !IsTomcatInstalled())  return true;

            //it's corrupted if tomcat server is installed but no tomcat user
            if (!AccessContolUtilities.IsUserExist(user)) return false;

            //Check if user has write access to the tomcat log folder
            string tomcatLogsFolder = TomcatFacade.TomcatInstallationFolder + "\\logs"; // get the install folder before the registry key this comes from is wiped out - either by unregister or uninstall
            if (!IsUserTomcatDirectoryAccessControl(user, tomcatLogsFolder)) return false;

            return true;
        }

        private static bool IsUserTomcatDirectoryAccessControl(string user, string tomcatLogsFolder)
        {
            DirectoryInfo di = new DirectoryInfo(tomcatLogsFolder);
            DirectorySecurity acl = di.GetAccessControl(AccessControlSections.All);
            AuthorizationRuleCollection rules = acl.GetAccessRules(true, true, typeof(NTAccount));

            //Go through the rules returned from the DirectorySecurity
            foreach (AuthorizationRule rule in rules)
            {
                //If we find one that matches the identity we are looking for
                if (rule.IdentityReference.Value.Equals(user, StringComparison.CurrentCultureIgnoreCase))
                {
                    var filesystemAccessRule = (FileSystemAccessRule)rule;

                    //Cast to a FileSystemAccessRule to check for access rights
                    if ((filesystemAccessRule.FileSystemRights & FileSystemRights.WriteData) > 0 && filesystemAccessRule.AccessControlType != AccessControlType.Deny)
                    {
                        return true;
                    }
                }
            }

            return false;
        }


        public static bool DeleteTomcatUser(string user)
        {
            if (!AccessContolUtilities.IsUserExist(user)) return true;

            return AccessContolUtilities.DeleteUserAccount(user);
        }

        /// <summary>
        /// Uninstall the current installation of Tomcat as specifed by the manifest
        /// </summary>
        public static bool UninstallCurrentTomcat()
        {
            bool result = false;
            TomcatPrerequisite prerequisite = Manifest.ActiveTomcatPrerequisite;

            if (prerequisite != null)
            {
                string tomcatInstallFolder = TomcatFacade.TomcatInstallationFolder; // get the install folder before the registry key this comes from is wiped out - either by unregister or uninstall

                try
                {
                    //Unregister tomcat service
                    if (prerequisite.UnregisterFilename != null)
                    {
                        UnregisterTomcat(prerequisite, tomcatInstallFolder);
                    }

                }
                catch (Exception e)
                {
                    Logger().Info("Exception while unregistering Tomcat service. Exception: " + e.Message);
                }

                try
                {

                    UninstallTomcat(prerequisite, tomcatInstallFolder);
                    result = true;
                }
                catch (Exception ex)
                {
                    Logger().Info("Exception while installing Tomcat. Exception: " + ex.Message);
                    return false;
                }
            }

            return result;
        }

        public static bool ValidatePassword(string pwd, out string errmsg)
        {

            bool isValid = true;
            errmsg = string.Empty;

            if (string.IsNullOrEmpty(pwd))
            {
                errmsg = "You must provide a password.";
                isValid = false;
            }
            else
            {
                for (int i = 0; i < pwd.Length; i++)
                {
                    if (char.IsLetter(pwd, i) == false && char.IsDigit(pwd, i) == false)
                    {
                        errmsg = "Password may only use alphanumeric characters (a-z, A-Z, and 0-9).";
                        isValid = false;
                        break;
                    }
                }
            }

            return isValid;
        }


        #endregion

        #region private methods


        /// <summary>
        /// Uninstalls Apache Tomcat.
        /// </summary>
        /// <param name="prerequisite">The prerequisite which hold Tomcat uninstall information.</param>
        /// <remarks></remarks>
        private static void UninstallTomcat(TomcatPrerequisite prerequisite, string tomcatInstallFolder)
        {
            string uninstallerFilename = prerequisite.UnInstallerFilename;
            string uninstallerFilespec = Path.Combine(tomcatInstallFolder, uninstallerFilename);

            System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
            externalProcess.StartInfo.FileName = uninstallerFilespec;
            externalProcess.StartInfo.Arguments = prerequisite.UnInstallerArguments;
            externalProcess.StartInfo.UseShellExecute = false;
            externalProcess.StartInfo.CreateNoWindow = true;
            externalProcess.Start();
            do
            {
                Thread.Sleep(500);
                externalProcess.Refresh();
            } while (!externalProcess.HasExited);
            Thread.Sleep(3000); // Allow windows to complete any file deletes
            // unfortunately even through the process is reported as having exited, windows is still catching up on the file deletes
            // this can cause errors in the directory delete operation
            do
            {
                try
                {
                    Directory.Delete(tomcatInstallFolder, true);
                }
                catch (System.IO.IOException) { ; }
                Thread.Sleep(500);
            }
            while (Directory.Exists(tomcatInstallFolder));
        }

        private static void UnregisterTomcat(TomcatPrerequisite prerequisite, string tomcatInstallFolder)
        {
            if (prerequisite.UnregisterFilename != null && prerequisite.UnregisterArguments != null)
            {
                string unregisterFilename = prerequisite.UnregisterFilename;
                string unregisterFilespec = Path.Combine(tomcatInstallFolder, unregisterFilename);

                System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                externalProcess.StartInfo.FileName = unregisterFilespec;
                externalProcess.StartInfo.Arguments = prerequisite.UnregisterArguments;
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.CreateNoWindow = true;
                externalProcess.Start();
                do
                {
                    Thread.Sleep(500);
                    externalProcess.Refresh();
                } while (!externalProcess.HasExited);
                Logger().Info("Manually unregistered Tomcat service: " + prerequisite.UnregisterArguments);
            }
        }

        /// <summary>
        /// Gets the ammount of physical memory installed in bytes.
        /// </summary>
        /// <returns>The ammount of physical memory installed in bytes</returns>
        public static ulong GetPhysicalMemorySizeInBytes()
        {
            ulong physicalMemory = 0;
            MEMORYSTATUSEX memstat = new MEMORYSTATUSEX();
            try
            {
                if (GlobalMemoryStatusEx(memstat))
                {
                    physicalMemory = memstat.ullTotalPhys;
                }
            }
            catch (Exception ex)
            {
                Logger().Error("Error making kernel32 GlobalMemoryStatusEx call");
                Logger().Error(ex.Message);
            }

            if (physicalMemory == 0)
            {
                string errmsg = "Installer was not able to determine the amount of physical memory in the system.";
                Logger().Error(errmsg); // should never happen
                throw new Exception(errmsg);
            }

            return physicalMemory;
        }

        /// <summary>
        /// Gets the installed deprecated Tomcat prerequsite.
        /// </summary>
        /// <returns>The deprecated Tomcat prerequisite if found.</returns>
        /// <remarks>Can return null.</remarks>
        private static TomcatPrerequisite GetInstalledDeprecatedTomcatPrerequsite()
        {
            Debug.Assert(IsTomcatInstalled() == true);
            string installedTomcatVersion = InstalledTomcatVersion;
            TomcatPrerequisite tomcatPrerequisite = null;
            foreach (TomcatPrerequisite prerequisite in Manifest.DeprecatedTomcatPrerequisites)
            {
                if (IsPrerequisiteInstalled(prerequisite))
                {
                    tomcatPrerequisite = prerequisite;
                    break;
                }
            }
            return tomcatPrerequisite;
        }

        
        /// <summary>
        /// Determines whether version Tomcat specified by the provided prerequisite is installed.
        /// </summary>
        /// <param name="prerequisite">The prerequisite specifying the Tomcat version to check for.</param>
        /// <returns><c>true</c> if specified version of Tomcat is installed; otherwise, <c>false</c>.</returns>
        private static bool IsPrerequisiteInstalled(TomcatPrerequisite prerequisite)
        {
            bool isInstalled = false;
            string installedVersion = null;
            string key = null;
            RegistryView regView = RegistryView.Registry64;

            if (BusinessFacade.Is64BitOperatingSystem() && prerequisite.Native == NativeType.x86)
            {
                key = @"SOFTWARE\Wow6432Node\Apache Software Foundation\Tomcat";
            }
            else // native installation - either x86 or x64
            {
                key = @"SOFTWARE\Apache Software Foundation\Tomcat";
            }
            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
            {
                using (RegistryKey tomcat = regKey.OpenSubKey(key, true))
                {
                    if (tomcat != null && tomcat.SubKeyCount > 0)
                    {
                        string[] subkeys = tomcat.GetSubKeyNames(); // try and remain version independent
                        Debug.Assert(subkeys.Length == 1);
                        key += @"\" + subkeys[0];
                        using (RegistryKey tomcatVersion = regKey.OpenSubKey(key, true))
                        {
                            object o = tomcatVersion.GetValue("Version");
                            if (o != null)
                            {
                                installedVersion = o.ToString();
                            }
                        }
                    }
                }
            }
            // later versions of Tomcat (somewhere after 6.0.20) moved the location of the "Version" value down a level
            if (installedVersion == null)
            {
                using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
                {
                    using (RegistryKey tomcat = regKey.OpenSubKey(key, true))
                    {
                        if (tomcat != null && tomcat.SubKeyCount > 0)
                        {
                            string[] subkeys = tomcat.GetSubKeyNames(); // try and remain version independent
                            Debug.Assert(subkeys.Length == 1);
                            key += @"\" + subkeys[0];
                            using (RegistryKey tomcatVersion = regKey.OpenSubKey(key, true))
                            {
                                object o = tomcatVersion.GetValue("Version");
                                if (o != null)
                                {
                                    installedVersion = o.ToString();
                                }
                            }
                        }
                    }
                }
            }

            if (installedVersion != null && installedVersion == prerequisite.Version)
            {
                isInstalled = true;
            }

            return isInstalled;
        }

        /// <summary>
        /// Gets the installed Tomcat version as a string.
        /// </summary>
        /// <param name="baseRegKey">The registry key as a string that is used as the starting point of the Tomcat version search.</param>
        /// <returns>The installed Tomcat version as a string.</returns>
        private static string GetInstalledTomcatVersion(string baseRegKey)
        {
            string installedVersion = null;
            RegistryView regView = RegistryView.Registry64;
            if (RegistryUtilities.DoesRegKeyExist(baseRegKey) == true)
            {
                using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
                {
                    using (RegistryKey tomcat = regKey.OpenSubKey(baseRegKey, true))
                    {
                        if (tomcat != null && tomcat.SubKeyCount > 0)
                        {
                            string[] subkeys = tomcat.GetSubKeyNames(); // try and remain version independent
                            Debug.Assert(subkeys.Length == 1);
                            baseRegKey += @"\" + subkeys[0];
                            using (RegistryKey tomcatVersion = regKey.OpenSubKey(baseRegKey, true))
                            {
                                object o = tomcatVersion.GetValue("Version");
                                if (o != null)
                                {
                                    installedVersion = o.ToString();
                                }
                            }
                        }
                    }
                }
                // later versions of Tomcat (somewhere after 6.0.20) moved the location of the "Version" value down a level
                if (installedVersion == null)
                {
                    using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
                    {
                        using (RegistryKey tomcat = regKey.OpenSubKey(baseRegKey, true))
                        {
                            Debug.Assert(tomcat != null);
                            if (tomcat != null && tomcat.SubKeyCount > 0)
                            {
                                string[] subkeys = tomcat.GetSubKeyNames(); // try and remain version independent
                                Debug.Assert(subkeys.Length == 1);
                                baseRegKey += @"\" + subkeys[0];
                                using (RegistryKey tomcatVersion = regKey.OpenSubKey(baseRegKey, true))
                                {
                                    object o = tomcatVersion.GetValue("Version");
                                    if (o != null)
                                    {
                                        installedVersion = o.ToString();
                                    }
                                }
                            }
                        }
                    }
                }
            }

            return installedVersion;
        }

        /// <summary>
        /// Gets the Tomcat installation dirspec.
        /// </summary>
        /// <param name="baseRegKey">The registry key as a string that is used as the starting point of the installation folder search.</param>
        /// <returns>The Tomcat installation dirspec.</returns>
        private static string GetTomcatInstallationFolder(string baseRegKey)
        {
            string installationFolder = null;
            RegistryView regView = RegistryView.Registry64;

            if (RegistryUtilities.DoesRegKeyExist(baseRegKey))
            {
                Logger().Info("Base Registry Key Exist.");
                Debug.Assert(TomcatFacade.IsTomcatInstalled() == true);
                using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
                {
                    using (RegistryKey tomcat = regKey.OpenSubKey(baseRegKey, true))
                    {
                        Debug.Assert(tomcat.SubKeyCount > 0);
                        string[] subkeys = tomcat.GetSubKeyNames(); // try and remain version independent
                        Debug.Assert(subkeys.Length == 1);
                        if (subkeys.Length > 0)
                        {
                            baseRegKey += @"\" + subkeys[0];
                            Logger().Info("Reg Key with appended Subkey: " + baseRegKey);
                            using (RegistryKey tomcatVersion = regKey.OpenSubKey(baseRegKey, true))
                            {
                                object o = tomcatVersion.GetValue("InstallPath");
                                if (o != null)
                                {
                                    installationFolder = o.ToString();
                                }
                            }
                        }
                    }
                }
                // later versions of Tomcat (somewhere after 6.0.20) moved the location of the "InstallPath" value down a level
                if (installationFolder == null)
                {
                    using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
                    {
                        using (RegistryKey tomcat = regKey.OpenSubKey(baseRegKey, true))
                        // open the last key where we were looking for InstallPath
                        {
                            if (tomcat != null && tomcat.SubKeyCount > 0)
                            {
                                string[] subkeys = tomcat.GetSubKeyNames(); // try and remain version independent
                                Debug.Assert(subkeys.Length == 1);
                                baseRegKey += @"\" + subkeys[0]; // look one subkey deeper
                                Logger().Info("Reg Key with appended Subkey: " + baseRegKey);
                                using (RegistryKey tomcatVersion = regKey.OpenSubKey(baseRegKey, true))
                                {
                                    object o = tomcatVersion.GetValue("InstallPath");
                                    if (o != null)
                                    {
                                        installationFolder = o.ToString();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return installationFolder;
        }

        #endregion

    }
}
