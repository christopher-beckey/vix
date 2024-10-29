using log4net;
using Microsoft.Win32;
using System;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Runtime.InteropServices;
using System.Security;
using System.Security.Principal;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Xml;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{

    public static class BusinessFacade
    {
        private static readonly String PRODUCTION_BIA_USERNAME = "vavix660prod";
        private static readonly String PRODUCTION_BIA_PASSWORD = "rewRat7ekU";
        private static readonly String SMTP_SERVER_URI = "smtp.va.gov";
        private static readonly String VISTA_DOD_USERNAME = "bhieuser1";
        public static readonly String dirPathVIXBackup = @"C:\VIXbackup";

        /// <summary>
        /// Retrieve a logger for this class.
        /// </summary>
        /// <returns>A logger as a ILog interface.</returns>
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(BusinessFacade).Name);
        }

        private static InfoDelegate infoDelegate = null; // used to display a line of text to any WizardPage that has registered
        public static InfoDelegate InfoDelegate
        {
            get { return BusinessFacade.infoDelegate; }
            set { BusinessFacade.infoDelegate = value; }
        }

        private static VixManifest manifest = null; // the installation manifest
        public static VixManifest Manifest
        {
            get { return BusinessFacade.manifest; }
            set { BusinessFacade.manifest = value; }
        }

        public static String GetSmtpServerUri() { return SMTP_SERVER_URI; }

        public static String GetVistaDodUsername() { return VISTA_DOD_USERNAME; }

        public static String GetProductionBiaUsername() { return PRODUCTION_BIA_USERNAME; }

        public static String GetProductionBiaPassword() { return PRODUCTION_BIA_PASSWORD; }

        public static String GetPayloadZipPath(String startupPath)
        {
            // this may get more complicated, so its worth encapsulating
            return Path.Combine(startupPath, @"VIX\" + "VixDistribution.zip");
        }
        
        public static String GetPayloadPath(String applicationVersion, String startupPath)
        {
            // this may get more complicated, so its worth encapsulating
            return Path.Combine(startupPath, @"VIX\" + applicationVersion);
        }

        /// <summary>
        /// Checks to see if the current user has the Administrator role.
        /// </summary>
        /// <returns>true if the current user is an administrator, false otherwise</returns>
        /// <exception cref="ArgumentNullException"></exception>
        public static bool IsLoggedInUserAnAdministrator()
        {
            bool isAdmin = false;
            try
            {
                WindowsIdentity wi = WindowsIdentity.GetCurrent(); // SecurityException may be thrown
                WindowsPrincipal principal = new WindowsPrincipal(wi); // ArgumentNullException may be thrown
                if (principal.IsInRole(WindowsBuiltInRole.Administrator))
                {
                    isAdmin = true;
                }
            }
            catch (SecurityException ex)
            {
                // user does not have permissions to check so they are probably not a administrator
                Logger().Error("Windows Identity could not be retrieved : " + Environment.NewLine + ex.InnerException.Message);
            }
            catch (ArgumentNullException ex)
            {
                // windows identity came back null
                Logger().Error("Windows Identity is null : " + Environment.NewLine + ex.InnerException.Message);
            }
            return isAdmin;
       }

        public static String GetLoggedInUserName()
        {
            String userName = "Current user";
            try
            {
                WindowsIdentity wi = WindowsIdentity.GetCurrent(); // SecurityException may be thrown
                WindowsPrincipal principal = new WindowsPrincipal(wi); // ArgumentNullException may be thrown
                userName = wi.Name;
            }
            catch (SecurityException ex)
            {
                // user does not have permissions to check so they are probably not a administrator
                Logger().Error("Windows Identity could not be retrieved : " + Environment.NewLine + ex.InnerException.Message);
            }
            catch (ArgumentNullException ex)
            {
                // windows identity came back null
                Logger().Error("Windows Identity is null : " + Environment.NewLine + ex.InnerException.Message);
            }
            return userName;
        }
        
        //TODO remove 
        public static bool IsWindowsXP()
        {
            bool isXP = false;
            if (Environment.OSVersion.Platform == PlatformID.Win32NT)
            {
                if (Environment.OSVersion.Version.Major == 5 && Environment.OSVersion.Version.Minor == 1)
                {
                    isXP = true;
                }
            }
            return isXP;
        }

        //TODO remove 
        public static bool IsWindowsServer2003()
        {
            bool is2003 = false;
            if (Environment.OSVersion.Platform == PlatformID.Win32NT)
            {
                if (Environment.OSVersion.Version.Major == 5 && Environment.OSVersion.Version.Minor == 2)
                {
                    is2003 = true;
                }
            }
            return is2003;
        }

        //TODO remove 
        public static bool IsWindowsServer2008()
        {
            bool is2008 = false;
            if (Environment.OSVersion.Platform == PlatformID.Win32NT)
            {
                if (Environment.OSVersion.Version.Major == 6 && Environment.OSVersion.Version.Minor == 1)
                {
                    is2008 = true;
                }
            }
            return is2008;
        }

        [SecurityCritical]
        [DllImport("ntdll.dll", SetLastError = true, CharSet = CharSet.Unicode)]
        internal static extern int RtlGetVersion(ref OSVERSIONINFOEX versionInfo);
        [StructLayout(LayoutKind.Sequential)]
        internal struct OSVERSIONINFOEX
        {           
            internal int OSVersionInfoSize;
            internal int MajorVersion;
            internal int MinorVersion;
            internal int BuildNumber;
            internal int PlatformId;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)]
            internal string CSDVersion;
            internal ushort ServicePackMajor;
            internal ushort ServicePackMinor;
            internal short SuiteMask;
            internal byte ProductType;
            internal byte Reserved;
        }

        public static bool IsOperatingSystemApproved(IVixConfigurationParameters config, bool devMode)
        {
            String info = null;
            return IsOperatingSystemApproved(ref info, config, devMode);
        }

        public static bool IsOperatingSystemApproved(ref String info, IVixConfigurationParameters config, bool devMode)
        {
            var osVersionInfo = new OSVERSIONINFOEX { OSVersionInfoSize = Marshal.SizeOf(typeof(OSVERSIONINFOEX)) };
            info = "Current operating system is not approved for the VIX service.";
            bool isApproved = false;
            if (RtlGetVersion(ref osVersionInfo) != 0)
            {
                info = "Cannot determine operating system version.";
				Logger().Info(info);				
                return isApproved;
            }			
            if (osVersionInfo.MajorVersion == 10 && osVersionInfo.MinorVersion == 0)
            {
                info = "Current operating system is Windows 2016/2019.";
                isApproved = true;
            }
            else if (osVersionInfo.MajorVersion == 6 && osVersionInfo.MinorVersion == 3)
            {
                info = "Current operating system is Windows 2012 R2.";
                isApproved = true;
            }
            else if (osVersionInfo.MajorVersion == 6 && osVersionInfo.MinorVersion == 2)
            {
                info = "Current operating system is Windows 2012.";
                isApproved = true;
            }       
            return isApproved;
        }

        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool IsWow64Process(IntPtr hProcess, out bool wow64Process);

        [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
        static extern IntPtr GetModuleHandle(string moduleName);

        [DllImport("kernel32.dll")]
        static extern IntPtr GetCurrentProcess();

        [DllImport("kernel32", CharSet = CharSet.Auto, SetLastError = true)]
        static extern IntPtr GetProcAddress(IntPtr hModule,
            [MarshalAs(UnmanagedType.LPStr)]string procName);

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static bool Is64BitOperatingSystem()
        {
            if (IntPtr.Size == 8)  // 64-bit programs run only on Win64
            {
                return true;
            }
            else  // 32-bit programs run on both 32-bit and 64-bit Windows
            {
                // Detect whether the current process is a 32-bit process 
                // running on a 64-bit system.
                bool flag = false;
                if (DoesWin32MethodExist("kernel32.dll", "IsWow64Process"))
                {
                    if (IsWow64Process(GetCurrentProcess(), out flag))
                    {
                        if (flag)
                        {
                            return true;
                        }
                    }
                }
                return false;
            }
        }

        //public static bool Is64BitOperatingSystem(out bool isWow64)
        //{
        //    Logger().Info("Is64BitOperatingSystem:");
        //    isWow64 = false;
        //    if (IntPtr.Size == 8)  // 64-bit programs run only on Win64
        //    {
        //        Logger().Info("IntPtr.Size == 8");
        //        return true;
        //    }
        //    else  // 32-bit programs run on both 32-bit and 64-bit Windows
        //    {
        //        // Detect whether the current process is a 32-bit process 
        //        // running on a 64-bit system.
        //        bool flag = false;
        //        if (DoesWin32MethodExist("kernel32.dll", "IsWow64Process"))
        //        {
        //            Logger().Info("DoesWin32MethodExist = true");
        //            if (IsWow64Process(GetCurrentProcess(), out flag))
        //            {
        //                Logger().Info("IsWow64Process = true");
        //                if (flag)
        //                {
        //                    Logger().Info("isWow64 = true");
        //                    isWow64 = true;
        //                    return true;
        //                }
        //            }
        //        }
        //        return false;
        //    }
        //}
        
        /// <summary>
        /// The function determins whether a method exists in the export 
        /// table of a certain module.
        /// </summary>
        /// <param name="moduleName">The name of the module</param>
        /// <param name="methodName">The name of the method</param>
        /// <returns>
        /// The function returns true if the method specified by methodName 
        /// exists in the export table of the module specified by moduleName.
        /// </returns>
        static bool DoesWin32MethodExist(string moduleName, string methodName)
        {
            IntPtr moduleHandle = GetModuleHandle(moduleName);
            if (moduleHandle == IntPtr.Zero)
            {
                return false;
            }
            return (GetProcAddress(moduleHandle, methodName) != IntPtr.Zero);
        }


        /// <summary>
        /// Check to see if any flavor of Visual VC++ 2008 Redistributable is installed.
        /// </summary>
        /// <returns>true if the runtime is installed, false otherwise</returns>
        //WFP-Do some checking on this.
        public static bool IsVCPlusPlus2008RedistributableInstalled()
        {
            bool isInstalled = false;
            string basekey = null;
            RegistryView regView = RegistryView.Registry32;
            Logger().Info("64 bits OS ?" + BusinessFacade.Is64BitOperatingSystem());
            Logger().Info("Enable 64 bits installation: " + Manifest.Enable64BitInstallation);
            if (BusinessFacade.Is64BitOperatingSystem() && Manifest.Enable64BitInstallation == false)
            {
                basekey = @"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\";
            }
            else // native installation - either x86 or x64
            {
                basekey = @"SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\";
            }

            string[] subkeys = Registry.LocalMachine.OpenSubKey(basekey).GetSubKeyNames();
            
            foreach (string subkey in subkeys)
            {
                RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView);
                RegistryKey key = regKey.OpenSubKey(basekey + subkey);
                
                if ((key != null) && (key.GetValue("DisplayName") != null))
                {
                    string displayname = key.GetValue("DisplayName") as string;
                    Logger().Info("displayname: " + displayname);
                    if (displayname != null && displayname.Contains("Microsoft Visual C++ 2008 Redistributable"))
                    {
                        isInstalled = true;
                    }
                }
            }

            return isInstalled;
        }


        /// <summary>
        /// Check to see if x64 version of Visual VC++ 2015-2022 Redistributable is installed.
        /// </summary>
        /// <returns>true if the runtime is installed, false otherwise</returns>
        public static bool IsVCPlusPlus2015to2022x64RedistributableInstalled()
        {
            bool isInstalled = false;
            string dependenciesPath = @"Installer\Dependencies";
            bool isUninstallAvailable = false;
            string basekey = @"SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\"; 
            RegistryView regView = RegistryView.Registry32;

            using (RegistryKey dependencies = Registry.ClassesRoot.OpenSubKey(dependenciesPath))
            {
                if (dependencies != null)
                { 
                    foreach (string subKeyName in dependencies.GetSubKeyNames())
                    {                     
                        if (subKeyName != null && Regex.IsMatch(subKeyName, @"VC,redist\.x64,amd64,14\.(3[6-9]|[4-9][0-9]|1[0-9]{2}),bundle"))
                        {
                            isInstalled = true;
                            Logger().Info("VC++ 2015-22 Install check subKeyName: " + subKeyName);
                        }
                    }
                }
            }

            using (RegistryKey dependencies = Registry.LocalMachine.OpenSubKey(basekey))
            {
                if (dependencies != null)
                {
                    foreach (string subKeyName in dependencies.GetSubKeyNames())
                    {
                        RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView);
                        RegistryKey key = regKey.OpenSubKey(basekey + subKeyName);
                        if (key != null)
                        {
                            string displayname = key.GetValue("DisplayName") as string;                     
                            if (displayname != null && displayname.Contains("Microsoft Visual C++ 2015-2022"))
                            {
                                isUninstallAvailable = true;
                                Logger().Info("VC++ 2015-22 Uninstall check displayname: " + displayname);
                            }
                        }
                    }
                }
            }
            return isInstalled && isUninstallAvailable;
        }
    
    /// <summary>
    /// Install the Visual Studio 2015-2022 VC++ runtime necessary for the Laurel Bridge toolkit
    /// </summary>
    /// <returns></returns>
    public static bool InstallVCPlusPlusRedistributableForLaurelBridge(string installerDirectory)
        {
              if (IsVCPlusPlus2015to2022x64RedistributableInstalled() == false)
              {
                Process externalProcess = new System.Diagnostics.Process();
                try
                {
                    string installerFilespec = null;
                    if (manifest.Enable64BitInstallation)
                    {
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            installerFilespec = Path.Combine(installerDirectory, @"vcredist_x64.exe");
                        }
                        else
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }

                    externalProcess.StartInfo.FileName = installerFilespec;
                    externalProcess.StartInfo.Arguments = "/install /quiet /norestart";
                    externalProcess.StartInfo.WorkingDirectory = installerDirectory;
                    externalProcess.StartInfo.UseShellExecute = false;
                    //externalProcess.StartInfo.RedirectStandardError = true;
                    //externalProcess.StartInfo.RedirectStandardOutput = true;
                    externalProcess.StartInfo.CreateNoWindow = true;
                    externalProcess.Start();
                    do
                    {
                        Thread.Sleep(500);
                        externalProcess.Refresh();
                    } while (!externalProcess.HasExited);
                }
                finally
                {
                    externalProcess.Close();
                    externalProcess = null;
                }
            }
            
              return IsVCPlusPlus2015to2022x64RedistributableInstalled();
        }

        /// <summary>
        /// Install the Visual Studio 2008 VC++ runtime required by the CVIX OpenSSL FIPS 140-2 compliant runtime
        /// </summary>
        /// <returns></returns>
        public static bool InstallVCPlusPlus2008Redistributable()
        {
            if (IsVCPlusPlus2008RedistributableInstalled() == false) // safety net
            {
                Process externalProcess = new System.Diagnostics.Process();
                try
                {
                    string workingDir = Path.Combine(manifest.PayloadPath, @"common\Misc");
                    string installerFilespec = null;
                    if (manifest.Enable64BitInstallation)
                    {
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            installerFilespec = Path.Combine(workingDir, @"vcredist_x64.exe");
                        }
                        else
                        {
                            installerFilespec = Path.Combine(workingDir, @"vcredist_x86.exe");
                        }
                    }
                    else
                    {
                        installerFilespec = Path.Combine(workingDir, @"vcredist_x86.exe");
                    }

                    externalProcess.StartInfo.FileName = installerFilespec;
                    externalProcess.StartInfo.Arguments = " /Q";
                    externalProcess.StartInfo.WorkingDirectory = workingDir;
                    externalProcess.StartInfo.UseShellExecute = false;
                    //externalProcess.StartInfo.RedirectStandardError = true;
                    //externalProcess.StartInfo.RedirectStandardOutput = true;
                    externalProcess.StartInfo.CreateNoWindow = true;
                    externalProcess.Start();
                    do
                    {
                        Thread.Sleep(500);
                        externalProcess.Refresh();
                    } while (!externalProcess.HasExited);
                }
                finally
                {
                    externalProcess.Close();
                    externalProcess = null;
                }
            }
            return IsVCPlusPlus2008RedistributableInstalled();
        }

        /// <summary>
        /// A helper method to wrap the infoDelegate member, which if non null provide a way to report status to the 
        /// user interface.
        /// </summary>
        /// <param name="infoMessage">message to display in the user interface.</param>
        /// <returns>the message string passed in the infoMessage parameter to support chaining.</returns>
        private static String Info(String infoMessage)
        {
            if (infoDelegate != null)
            {
                infoDelegate(infoMessage);
            }
            Logger().Info(infoMessage); // any info provided to the presentation layer will be logged.
            return infoMessage;
        }

        public static bool DoesEnvironmentVariableExist(string envVariableName)
        {
            // append to the path
            String envVariable = Environment.GetEnvironmentVariable("envVariableName", EnvironmentVariableTarget.Machine);
            return envVariable == null ? false : true;

        }

        //Gets the available free disk space on the C drive
        public static int GetTotalFreeSpace()
        {
            string driveName = "C:\\";
            DriveInfo drive = new DriveInfo(driveName);
            double BytesInGB = 1073741824; // (1024 * 1024 * 1024)
            if (drive.IsReady && drive.Name == driveName)
            {
                //round up available disk space in GB
                return (int)Math.Ceiling((double)drive.AvailableFreeSpace / BytesInGB);
            }
            return -1;
        }

        //Use VIXBackupDeleteOldDirs to delete old backed-up folders in VIXBackup older than 1 year
        public static void VIXBackupDeleteOldDirs()
        {
            string[] dirsVIXbackupP = Directory.GetDirectories(dirPathVIXBackup, "P*", SearchOption.TopDirectoryOnly);
            if (dirsVIXbackupP.Length == 0)
            {
                return;
            }

            foreach (var dirVIXbackupP in dirsVIXbackupP)
            {
                string[] subdirectoriesDirVIXbackupP = Directory.GetDirectories(dirVIXbackupP);
                foreach (var subdirectoryDirVIXbackupP in subdirectoriesDirVIXbackupP)
                {
                    string nameSubdirectoryDirVIXbackupP = new DirectoryInfo(subdirectoryDirVIXbackupP).Name;
                    DateTime dateSubdirectoryDirVIXbackupP;
                    //attempt to parse the time from the name of the subfolder in each VIXBackup PNNN folder
                    if (DateTime.TryParseExact(nameSubdirectoryDirVIXbackupP, "yyyyMMddHHmmss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dateSubdirectoryDirVIXbackupP))
                    {
                        TimeSpan ageOfSubdirectoryDirVIXbackupP = DateTime.Now - dateSubdirectoryDirVIXbackupP;
                        //if the time of the VIXBackup subfolder is older than 1 year attempt to delete
                        if (ageOfSubdirectoryDirVIXbackupP > TimeSpan.FromDays(365))
                        {
                            try
                            {
                                Directory.Delete(subdirectoryDirVIXbackupP, true);
                            }
                            catch (Exception ex)
                            {
                                Logger().Info("Unable to delete VIXBackup subfolder" + subdirectoryDirVIXbackupP  + ".");
                                Logger().Info(ex.Message);
                            }
                        }
                    }
                }
                //if the VIXBackup PNNN folder no longer contains any backed-up subfolders, attempt to delete
                string[] directoriesSubPatchVixBackupPost = Directory.GetDirectories(dirVIXbackupP);
                if (directoriesSubPatchVixBackupPost.Length == 0)
                {
                    try
                    {
                        Directory.Delete(dirVIXbackupP, true);
                    }
                    catch (Exception ex)
                    {
                        Logger().Info("Unable to delete patch level VIXBackup folder" + dirVIXbackupP + ".");
                        Logger().Info(ex.Message);
                    }
                }     
            }           
        }

        //Run VIXBackupZip to create zip file of latest VIXBackup folder
        public static void VIXBackupZip(string passInPriorVersionNo) 
        {
            string vixBackupPath = dirPathVIXBackup + @"\P" + passInPriorVersionNo;
        
            if (Directory.Exists(vixBackupPath))
            {
                try
                {
                    string[] directoriesVixBackup = Directory.GetDirectories(vixBackupPath);
                    string lastVixBackupFullDirectory = string.Empty;

                    if (directoriesVixBackup.Length > 0)
                    {
                        Array.Sort(directoriesVixBackup);
                        lastVixBackupFullDirectory = directoriesVixBackup[directoriesVixBackup.Length - 1];

                        string lastVixBackupNameDirectory = new DirectoryInfo(lastVixBackupFullDirectory).Name;

                        //To create unique file name with date and time with nanoseconds.  
                        var zipFileNamePart = @"\P" + passInPriorVersionNo + "_" + lastVixBackupNameDirectory + ".zip";

                        var zipFileName = vixBackupPath + zipFileNamePart;

                        var ZipFileDestinationPath = lastVixBackupFullDirectory + zipFileNamePart;

                        if (!File.Exists(ZipFileDestinationPath))
                        {
                            //create zip file
                            //ZipUtilities.CreateZipFile(zipFileName, lastVixBackupFullDirectory, false, null);

                            //create zip file
                            ZipUtilities.CreateNewZipFile(lastVixBackupFullDirectory, zipFileName);

                            //delete old configuration files and folder
                            System.IO.DirectoryInfo latestBackupPath = new DirectoryInfo(lastVixBackupFullDirectory);

                            foreach (FileInfo file in latestBackupPath.GetFiles())
                            {
                                file.Delete();
                            }
                            foreach (DirectoryInfo dir in latestBackupPath.GetDirectories())
                            {
                                dir.Delete(true);
                            }
                            System.IO.File.Move(zipFileName, ZipFileDestinationPath);
                        }
                    }
                }
                catch (Exception ex)
                {
                    Logger().Info("Unable to create zip file of latest VIXBackup");
                    Logger().Info(ex.Message);
                }
            }
        }

        //Run VIXBackupDeleteTemp to delete the C:\VIXbackup\temp folder if exists (used for install log backup)
        public static void VIXBackupDeleteTemp()
        {
            var dirPathVIXBackupTemp = dirPathVIXBackup + @"\temp";
            if (Directory.Exists(dirPathVIXBackupTemp))
            {
                try
                {
                    Directory.Delete(dirPathVIXBackupTemp, true);
                }
                catch (Exception ex)
                {
                    Logger().Info("Unable to delete temp VIXBackup folder" + dirPathVIXBackupTemp + ".");
                    Logger().Info(ex.Message);
                }
            }
        }

            //Run VIXBackupInstallHistory to create single line history of install process to track each install
            public static void VIXBackupInstallHistory(string passInFullVersionNo, string passInFullPriorVersionNo, int passInstallerCase)
        {
            try
            {
                string filePathInstallHistory = Path.Combine(dirPathVIXBackup, "InstallHistory.txt");
                if (!Directory.Exists(Path.GetDirectoryName(filePathInstallHistory)))
                    Directory.CreateDirectory(Path.GetDirectoryName(filePathInstallHistory));

                string installHistoryText = "";

                switch (passInstallerCase)
                {
                    case 1:
                        if (passInFullPriorVersionNo != null)
                        {
                            installHistoryText = @"Uninstall " + passInFullPriorVersionNo;
                        }
                        break;

                    case 2:
                        if (passInFullPriorVersionNo != null)
                        {
                            installHistoryText = @"Uninstalled " + passInFullPriorVersionNo + " Completed. Upgrade Install of " + passInFullVersionNo;
                        }
                        else
                        {
                            installHistoryText = @"New Install " + passInFullVersionNo;
                        }
                        break;
                }
                StreamWriter sw = (!File.Exists(filePathInstallHistory)) ? File.CreateText(filePathInstallHistory) : File.AppendText(filePathInstallHistory);
                sw.WriteLine("{0}|{1}|{2}", DateTime.Now.ToString("MM/dd/yyyy HH:mm"), System.Security.Principal.WindowsIdentity.GetCurrent().Name, installHistoryText);
                sw.Close();
            }
            catch (Exception ex)
            {
                Logger().Info("Unable to update InstallHistory.txt in VIXBackup");
                Logger().Info(ex.Message);
            }
        }

        /// <summary>
        /// Run the following based on the passInstallerCase parameter:
        /// 1 = StartOfUnInstallProcess.bat to backup config files
        /// 2 = EndOfInstallProcess.bat to fix config files, ssl binding, and other tasks including run patch specific scripts
        /// </summary>
        /// <returns></returns>
        public static void RunStartOrEndOfInstallProcess(string passInVersionNo, string passInPriorVersionNo, int passInstallerCase, string vixRoleTypeIn, bool configCheckBool)
        {
            Process externalProcess = new System.Diagnostics.Process();
            try
            {
                string workingDir = "";
                string startOrEndOfInstallProcessFileSpec = "";
                string processArguments = "";
                int configCheckInt = Convert.ToInt32(configCheckBool);

                switch (passInstallerCase)
                {
                    case 1:
                        workingDir = Path.Combine(manifest.PayloadPath, @"common\Misc");
                        startOrEndOfInstallProcessFileSpec = Path.Combine(workingDir, @"StartOfUnInstallProcess.bat");
                        if (passInPriorVersionNo != null)
                        {
                            //used for upgrade install
                            processArguments = passInVersionNo + " " + vixRoleTypeIn + " " + passInPriorVersionNo;
                        }
                        else
                        {
                            //used for new install
                            processArguments = passInVersionNo + " " + vixRoleTypeIn + " " + "0";
                        }
                        if (!File.Exists(startOrEndOfInstallProcessFileSpec))
                        {
                            Logger().Info("No Start of Install Process to run");
                            return;
                        }
                        break;
                    case 2:
                        workingDir = Path.Combine(manifest.PayloadPath, @"common\Misc");
                        startOrEndOfInstallProcessFileSpec = Path.Combine(workingDir, @"EndOfInstallProcess.bat");
                        if (passInPriorVersionNo != null)
                        {
                            //used for upgrade install
                            processArguments = passInVersionNo + " " + vixRoleTypeIn + " " + passInPriorVersionNo + " " + configCheckInt;
                        }
                        else
                        {
                            //used for new install
                            processArguments = passInVersionNo + " " + vixRoleTypeIn + " " + "0" + " " + configCheckInt;
                        }
                        if (!File.Exists(startOrEndOfInstallProcessFileSpec))
                        {
                            Logger().Info("No End of Install Process to run");
                            return;
                        }
                        break;
                }

                externalProcess.StartInfo.FileName = startOrEndOfInstallProcessFileSpec;
                externalProcess.StartInfo.WorkingDirectory = workingDir;
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.Arguments = processArguments;
                externalProcess.StartInfo.CreateNoWindow = true;
                externalProcess.Start();
                do
                {
                    Thread.Sleep(500);
                    externalProcess.Refresh();
                } while (!externalProcess.HasExited);
            }
            finally
            {
                externalProcess.Close();
                externalProcess = null;
            }
        }

        //Run permission_fixer.ps1 (silently - no PowerShell pop up) to set directory access control permissions for apachetomact user
        public static void RunSilentPSProcess(string vixRoleTypeIn, string cacheDirPath, string vixTxLogsDbPath)
        {
            Process externalSProcess = new System.Diagnostics.Process();

            try
            {
                cacheDirPath = cacheDirPath.Replace("/", @"\");
                vixTxLogsDbPath = vixTxLogsDbPath.Replace("/", @"\");

                string psFileName = @"permission_fixer.ps1";
                string workingSDir = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles).ToString(), @"VistA\Imaging\Scripts");
                externalSProcess.StartInfo.FileName = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles).ToString(), @"PowerShell\7\pwsh.exe");
                externalSProcess.StartInfo.WorkingDirectory = workingSDir;
                externalSProcess.StartInfo.UseShellExecute = false;
                externalSProcess.StartInfo.CreateNoWindow = true;
                externalSProcess.StartInfo.Arguments = psFileName + " " + cacheDirPath + " " + vixTxLogsDbPath + " " + vixRoleTypeIn;
                externalSProcess.StartInfo.Verb = "runas";
                externalSProcess.Start();

                do
                {
                    Thread.Sleep(500);
                    externalSProcess.Refresh();
                } while (!externalSProcess.HasExited);
            }
            finally
            {
                externalSProcess.Close();
                externalSProcess = null;
            }
        }

        public static async void DeleteCache(string cacheDirPath)
        {
            Logger().Info("Attempting to delete the contents of the vixcache folder: " + cacheDirPath);
            var res = await BusinessFacade.RunAsyncPSProcess(cacheDirPath);
        }

        /// <summary>
        /// VAI-1059 Run a powershell (pwsh) process asynchronously to delete the contents of the vixcache
        /// </summary>
        /// <param name="cacheDirPath">The path of the VixCache folder</param>
        /// <param name="vixRoleTypeIn">The role type (i.e. VIX or CVIX)</param>
        public static async Task<string> RunAsyncPSProcess(string cacheDirPath)
        {
            Process externalSProcess = new System.Diagnostics.Process();

            try
            {            
                string psFileName = @"delete_vixcache.ps1";
                string workingSDir = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles).ToString(), @"VistA\Imaging\Scripts");
                externalSProcess.StartInfo.WorkingDirectory = workingSDir;
                externalSProcess.StartInfo.UseShellExecute = false;
                externalSProcess.StartInfo.RedirectStandardOutput = true;
                externalSProcess.StartInfo.CreateNoWindow = true;
                externalSProcess.StartInfo.Verb = "runas";
                externalSProcess.StartInfo.FileName = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles).ToString(), @"PowerShell\7\pwsh.exe");
                externalSProcess.StartInfo.Arguments = psFileName + " " + cacheDirPath;
                externalSProcess.Start();

                string _output = await externalSProcess.StandardOutput.ReadToEndAsync();
                await externalSProcess.WaitForExitAsync();

                return _output.ToString().Trim();
            }

            catch (Exception ex)
            {
                Logger().Info("Error deleting the vixcache: " + ex.ToString());
                return "Error: " + ex.Message;
            }
        }

        public static async Task WaitForExitAsync(this Process process, CancellationToken cancellationToken = default)
        {
            var tcs = new TaskCompletionSource<bool>(TaskCreationOptions.RunContinuationsAsynchronously);

            void Process_Exited(object sender, EventArgs e)
            {
                tcs.TrySetResult(true);
            }

            process.EnableRaisingEvents = true;
            process.Exited += Process_Exited;

            try
            {
                if (process.HasExited)
                {
                    return;
                }

                using (cancellationToken.Register(() => tcs.TrySetCanceled()))
                {
                    await tcs.Task.ConfigureAwait(false);
                }
            }
            finally
            {
                process.Exited -= Process_Exited;
            }
        }

        public static void ImportLaurelBridgeCertIntoCacerts()
        {
            string javaCacertsFile = JavaFacade.GetActiveJrePathLocationIndependent() + @"\lib\security\cacerts";
            string workingLaurelBridgeDir = Path.Combine(manifest.PayloadPath, @"common\LaurelBridge\");
            string laurelBridgeAliasName = "VA-Internal-S2-RCA1-v1";
            string laurelBridgeCertFile = "VA-Internal-S2-RCA1-v1.crt";
            string keytoolName = JavaFacade.GetActiveJrePathLocationIndependent() + @"\bin\keytool.exe";
            string importCacertsArgs = @"-keystore " + "\"" + javaCacertsFile + "\"" + " -importcert -alias " + laurelBridgeAliasName + " -file " + laurelBridgeCertFile + " -keypass changeit -storepass changeit -noprompt";
            try
            {
                KeytoolFacade.RunCmdProcess(keytoolName, importCacertsArgs, workingLaurelBridgeDir);
            }
            catch (Exception ex)
            {
                Logger().Info("Import Laurel Bridge certificate Error: " + ex.ToString());
            }
        }

        public static bool IsOfficeRegKeyPresent(int passLibreCase)
        {
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode OfficeNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']");
            XmlNode OfficeNodeUninstall;
            if (OfficeNode != null)
            {
                switch (passLibreCase)
                {
                    case 1:
                        //prior LibreOffice version Uninstall Command
                        OfficeNodeUninstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']/UninstallCommand");
                        break;
                    case 2:
                        //current LibreOffice version Uninstall Command
                        OfficeNodeUninstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']/CurrentUninstallCommand");
                        break;
                    default:
                        //current LibreOffice version Uninstall Command
                        OfficeNodeUninstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']/CurrentUninstallCommand");
                        break;
                }

                if (OfficeNodeUninstall != null)               
                {
                    string CurrentUninstallCommand = OfficeNodeUninstall.InnerXml.Trim();
                    if (CurrentUninstallCommand.ToLower() != "no_upgrade")
                    {
                        string[] separatingStrings = { "{", "}" };
                        string[] seperateGuid = CurrentUninstallCommand.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries);
                        string extractGuid = "{" + seperateGuid[1] + "}";

                        string key = @"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" + extractGuid;
                        var keycheck = Registry.LocalMachine.OpenSubKey(key);
                        if (keycheck == null)
                        {
                            Logger().Info("LibreOffice Registry Check Did Not Find Current LibreOffice Installed");
                            return false; // Key does not exist
                        }
                        else
                        {
                            Logger().Info("LibreOffice Registry Check Found Current LibreOffice Installed");
                            return true; // Key exists proceed 
                        }
                    }
                    else
                    {                       
                        Logger().Info("LibreOffice Registry Check Did Not Complete No Upgrade");
                        return false;                      
                    }
                }
                else
                {
                    Logger().Info("LibreOffice Registry Check Did Not Complete No Uninstall Entry");
                    return false;
                }             
            }
            else
            {
                Logger().Info("LibreOffice Registry Check Did Not Complete No Manifest Entry");
                return false;
            }          
        }

        public static bool IsPowerShellRegKeyPresent(int passPSCase)
        {
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode PowerShellNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']");
            XmlNode PowerShellNodeUninstall;
            if (PowerShellNode != null)
            {
                switch (passPSCase)
                {
                    case 1:
                        //prior PowerShell version Uninstall Command
                        PowerShellNodeUninstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']/UninstallCommand");
                        break;
                    case 2:
                        //current PowerShell version Uninstall Command
                        PowerShellNodeUninstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']/CurrentUninstallCommand");
                        break;
                    default:
                        //current PowerShell version Uninstall Command
                        PowerShellNodeUninstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']/CurrentUninstallCommand");
                        break;
                }

                if (PowerShellNodeUninstall != null)
                {
                    string CurrentUninstallCommand = PowerShellNodeUninstall.InnerXml.Trim();
                    if (CurrentUninstallCommand.ToLower() != "no_upgrade")
                    {
                        string[] separatingStrings = { "{", "}" };
                        string[] seperateGuid = CurrentUninstallCommand.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries);
                        string extractGuid = "{" + seperateGuid[1] + "}";

                        string key = @"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" + extractGuid;
                        var keycheck = Registry.LocalMachine.OpenSubKey(key);
                        if (keycheck == null)
                        {
                            Logger().Info("PowerShell Registry Check Did Not Find Current PowerShell Installed");
                            return false; // Key does not exist
                        }
                        else
                        {
                            Logger().Info("PowerShell Registry Check Found Current PowerShell Installed");
                            return true; // Key exists proceed 
                        }
                    }
                    else
                    {
                        Logger().Info("PowerShell Registry Check Did Not Complete No Upgrade");
                        return false;
                    }
                }
                else
                {
                    Logger().Info("PowerShell Registry Check Did Not Complete No Uninstall Entry");
                    return false;
                }
            }
            else
            {
                Logger().Info("PowerShell Registry Check Did Not Complete No Manifest Entry");
                return false;
            }
        }

        // Determine if .NET Framework 4.8 or higher is installed from Registry
        public static double GetNET48PlusFromRegistry()
        {
            const string subkey = @"SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\";
            //A non-zero release key should mean that 4.8 or later is installed.
            double parsedversion = 0;

            using (RegistryKey ndpKey = Registry.LocalMachine.OpenSubKey(subkey))
            {
                if (ndpKey != null && ndpKey.GetValue("Release") != null)
                {
                    if ((int)ndpKey.GetValue("Release") >= 528040)
                    {
                        parsedversion = 4.8;
                    }
                }
            }

            return parsedversion;
        }

        // Install .NET Framework 4.8
        public static void InstallNETFramework(string vixInstallerPath, int passInstallerCase)
        {
            Process externalProcess = new System.Diagnostics.Process();

            try
            {
                externalProcess.StartInfo.FileName = Path.Combine(vixInstallerPath, @"ndp48-x86-x64-allos-enu.exe");
                externalProcess.StartInfo.WorkingDirectory = vixInstallerPath;
                // 1 for GUI installer and 2 for nightly installer
                switch(passInstallerCase)
                {
                    case 1:
                        // requires user selecting finish and restart in prompts for GUI installer
                        externalProcess.StartInfo.Arguments = "/promptrestart /passive /showfinalerror";
                        break;
                    case 2:
                        //automatically reboots for nightly installer
                        externalProcess.StartInfo.Arguments = "/q";
                        break;
                    default:
                        externalProcess.StartInfo.Arguments = "/promptrestart /passive";
                        break;
                 }
                externalProcess.StartInfo.Verb = "runas";
                externalProcess.Start();
                externalProcess.WaitForExit();
            }
            catch (Exception ex)
            {
                Logger().Error("Error installing .NET Framework 4.8: " + ex.ToString());
            }
        }
    }
}
