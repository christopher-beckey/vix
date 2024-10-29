using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using log4net;
using System.Threading;
using Microsoft.Win32;
using System.Diagnostics;


namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public static class JavaFacade
    {
        public static InfoDelegate InfoDelegate { get; set; }
        public static VixManifest Manifest { get; set; }

        #region private members
        /// <summary>
        /// A helper method to wrap the infoDelegate member, which if non null provide a way to report status to the 
        /// user interface.
        /// </summary>
        /// <param name="infoMessage">message to display in the user interface.</param>
        /// <returns>the message string passed in the infoMessage parameter to support chaining.</returns>
        private static String Info(String infoMessage)
        {
            if (InfoDelegate != null)
            {
                InfoDelegate(infoMessage);
            }
            Logger().Info(infoMessage); // any info provided to the presentation layer will be logged.
            return infoMessage;
        }

        /// <summary>
        /// Retrieve a logger for this class.
        /// </summary>
        /// <returns>A logger as a ILog interface.</returns>
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(JavaFacade).Name);
        }

        /// <summary>
        /// Copies a file from a source directory to a target directory with logging
        /// </summary>
        /// <param name="sourceDir">the directory to copy from</param>
        /// <param name="sourceFilename">the filename to copy</param>
        /// <param name="targetDir">the target directory to copy to</param>
        private static void CopyHelper(String sourceDir, String sourceFilename, String targetDir)
        {
            String sourcePath = Path.Combine(sourceDir, sourceFilename);
            String targetPath = Path.Combine(targetDir, sourceFilename);
            Info("Copying " + sourcePath + " to " + targetPath);
            File.Copy(sourcePath, targetPath, true);
        }

        #endregion

        #region public members

        /// <summary>
        /// Return the Active Java run time major and minor version as a String.
        /// </summary>
        /// <returns>Java major and minor version as a String</returns>
        public static string ActiveJavaVersion { get { return Manifest.ActiveJavaPrerequisite.Version;}}

        /// <summary>
        /// Return the Deprecated Java run time major and minor version as a String.
        /// </summary>
        /// <returns>Java major and minor version as a string</returns>
        /// <remarks>can be null</remarks>
        public static string DeprecatedJavaVersion
        {
            get
            {
                JavaPrerequisite prerequisite = GetInstalledDeprecatedJavaPrerequsite(true);
                return prerequisite == null ? null : prerequisite.Version;
            }
        }

        /// <summary>
        /// Determines whether the active Java Development Kit specified by the manifest is installed.
        /// </summary>
        /// <returns><c>true</c> if the active JDK is installed; otherwise, <c>false</c>.</returns>
        public static bool IsActiveJdkInstalled()
        {
            JavaPrerequisite prerequisite = Manifest.ActiveJavaPrerequisite;
            return GetJdkInstallationPath(prerequisite.Version, prerequisite.Native) != null ? true : false;
        }

        /// <summary>
        /// Determines whether the active Java Runtime Environment specified by the manifest is installed.
        /// </summary>
        /// <returns><c>true</c> if the active JRE is installed; otherwise, <c>false</c>.</returns>
        public static bool IsActiveJreInstalled()
        {
            JavaPrerequisite prerequisite = Manifest.ActiveJavaPrerequisite;
            return GetJreInstallationPath(prerequisite.Version, prerequisite.Native) != null ? true : false;
        }

        /// <summary>
        /// Return the absolute path to the Active (as specified by the Manifest) JRE or JDK.
        /// </summary>
        /// <param name="isJre">If true, return the JRE path, otherwise return the JDK path.</param>
        /// <returns>The Java installation dirspec.</returns>
        public static String GetActiveJavaPath(bool isJre)
        {
            JavaPrerequisite prerequisite = Manifest.ActiveJavaPrerequisite;
            return isJre ? prerequisite.JrePath : prerequisite.JdkPath;
        }

        /// <summary>
        /// Check to see if Java JRE of the correct version is installed.
        /// </summary>
        /// <returns><c>true</c> if a deprecated JRE is installed; otherwise, <c>false</c>.</returns>
        public static bool IsDeprecatedJreInstalled()
        {
            return GetInstalledDeprecatedJavaPrerequsite(true) != null ? true : false;
        }

        /// <summary>
        /// Examine the list of deprecated Java Prerequsites as specified by the Manifest, and find the one that is installed.
        /// </summary>
        /// <returns>the deprecated Java Prerequsite that is curretnly installed, or null if none are installed</returns>
        public static JavaPrerequisite GetInstalledDeprecatedJavaPrerequsite(bool isJre)
        {
            JavaPrerequisite javaPrerequisite = null;
            foreach (JavaPrerequisite prerequisite in Manifest.DeprecatedJavaPrerequisites)
            {
                string installationPath = isJre ? GetJreInstallationPath(prerequisite.Version, prerequisite.Native) : GetJdkInstallationPath(prerequisite.Version, prerequisite.Native);
                if (installationPath != null)
                {
                    Debug.Assert(installationPath == (isJre ? prerequisite.JrePath : prerequisite.JdkPath));
                    javaPrerequisite = prerequisite;
                    break;
                }
            }
            return javaPrerequisite;
        }

        /// <summary>
        /// Determine if a Java JDK or JRE of the correct version is installed.
        /// </summary>
        /// <param name="allowJDK">true if JDK is permitted (development mode), false if JRE required (production)</param>
        /// <returns><c>true</c> if Java JRE or JDK is installed; otherwise, <c>false</c>.</returns>
        public static bool IsJavaInstalled(bool allowJDK)
        {
            String info = null;
            return IsJavaInstalled(ref info, allowJDK);
        }
        
        /// <summary>
        /// Determine if a Java JDK or JRE of the correct version is installed. Return a status message suitable for
        /// display to a user.
        /// </summary>
        /// <param name="info">The status of the Java installation suitable for display to the user.</param>
        /// <param name="allowJDK">true if JDK is permitted (development mode), false if JRE required (production)</param>
        /// <returns><c>true</c> if Java JRE or JDK is installed; otherwise, <c>false</c>.</returns>
        public static bool IsJavaInstalled(ref String info, bool allowJDK)
        {
            info = null;
            bool isInstalled = true;
            if (!IsActiveJreInstalled())
            {
                if (allowJDK)
                {
                    if (!IsActiveJdkInstalled())
                    {
                        isInstalled = false;
                        info = "The Java Runtime Environment version " + JavaFacade.ActiveJavaVersion + " is not installed.";
                    }
                    else
                    {
                        info = "The Java Development Kit version " + JavaFacade.ActiveJavaVersion + " is installed (Dev Mode).";
                    }
                }
                else
                {
                    isInstalled = false;
                    info = "The Java Runtime Environment version " + JavaFacade.ActiveJavaVersion + " is not installed.";
                }
            }
            else
            {
                info = "The Java Runtime Environment version " + JavaFacade.ActiveJavaVersion + " is installed.";
            }
            return isInstalled;
        }

        /// <summary>
        /// Gets the JRE installer filespec from the manifest.
        /// </summary>
        /// <returns>The JRE installer filespec.</returns>
        public static String GetInstallerFilespec()
        {
            return Manifest.ActiveJavaPrerequisite.JreInstallerFilespec;
        }

        /// <summary>
        /// Uninstalls the deprecated jre as specified by the manifest.
        /// </summary>
        /// <remarks>If a deprecated JRE is not found then do nothing.</remarks>
        public static void UninstallDeprecatedJre()
        {
            JavaPrerequisite prerequisite = GetInstalledDeprecatedJavaPrerequsite(true);

            if (prerequisite != null) // safety net - do nothing
            {
                System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                externalProcess.StartInfo.FileName = @"msiexec.exe";
                externalProcess.StartInfo.Arguments = prerequisite.UninstallArgs;
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.CreateNoWindow = true;
                externalProcess.Start();
                do
                {
                    Thread.Sleep(500);
                    externalProcess.Refresh();
                } while (!externalProcess.HasExited);

                // remove Java from path env variable
                String javaBinPath = prerequisite.JrePath + @"\bin";
                String path = Environment.GetEnvironmentVariable("path", EnvironmentVariableTarget.Machine);
                if (path != null)
                {
                    path = path.Replace(javaBinPath, "");
                    path = path.Replace(";;", ";");
                    Environment.SetEnvironmentVariable("path", path, EnvironmentVariableTarget.Machine);
                }
                Thread.Sleep(3000);
                // unfortunately even through the process is reported as having exited, windows is still catching up on the file deletes
                // this can cause errors in the directory delete operation
                do
                {
                    try
                    {
                        Directory.Delete(prerequisite.JrePath, true); // JAI and JAI Image IO files will remain so take them out
                    }
                    catch (System.IO.IOException) { ; }
                }
                while (Directory.Exists(prerequisite.JrePath));
            }
        }

        /// <summary>
        /// Uninstalls the current jre as specified by the manifest.
        /// </summary>
        /// <remarks>If the current JRE is not found then do nothing.</remarks>
        public static bool UninstallCurrentJre()
        {
            JavaPrerequisite prerequisite = Manifest.ActiveJavaPrerequisite;

            if (prerequisite != null) // safety net - do nothing
            {
				//set the Classes.jsa file to not be read-only so that it can be deleted 
                String javaBinPath = prerequisite.JrePath + @"\bin";
                try
                {
                    string fileNameClassesJsa = javaBinPath + @"\server\Classes.jsa";
                    FileInfo fileClassesJsa = new FileInfo(fileNameClassesJsa);
                    if (fileClassesJsa.Exists)
                    {
                        fileClassesJsa.IsReadOnly = false;
                    }
                }
                catch (System.IO.IOException) { ; }	
				
                System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                externalProcess.StartInfo.FileName = @"msiexec.exe";
                externalProcess.StartInfo.Arguments = prerequisite.UninstallArgs;
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.CreateNoWindow = true;
                externalProcess.Start();
                do
                {
                    Thread.Sleep(500);
                    externalProcess.Refresh();
                } while (!externalProcess.HasExited);

                // remove Java from path env variable
                String path = Environment.GetEnvironmentVariable("path", EnvironmentVariableTarget.Machine);
                if (path != null)
                {
                    path = path.Replace(javaBinPath, "");
                    path = path.Replace(";;", ";");
                    Environment.SetEnvironmentVariable("path", path, EnvironmentVariableTarget.Machine);
                }
                Thread.Sleep(3000);
                // unfortunately even through the process is reported as having exited, windows is still catching up on the file deletes
                // this can cause errors in the directory delete operation
                try
                {
                    Directory.Delete(prerequisite.JrePath, true); // JAI and JAI Image IO files will remain so take them out
                    return true;
                }
                catch (Exception n)
                {
                    return false;
                }
            }

            return true;
        }
        
        /// <summary>
        /// Determines whether Java Imag IO installed via a MSI file.
        /// </summary>
        /// <returns><c>true</c> if Java Image IO has been installed via a MSI file; otherwise, <c>false</c>.</returns>
        /// <remarks>Check performed to accomidate Legacy DICOM gateways. Java Image IO must be uninstalled before uninstalling
        /// Java or the Java uninstall operation will never succeed. This will always be a x86 installation.</remarks>
        public static bool IsJavaImageIOInstalledViaMsi()
        {
            // Note that if this is installed on a 64 bit OS it will be as WOW - no 64 bit support
            string keyspec = BusinessFacade.Is64BitOperatingSystem() ? @"SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\" :
                @"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\";
            keyspec += "{F0877138-6292-4111-A2F4-158F58B8E5A4}"; // version 1.1
            bool isInstalled = RegistryUtilities.DoesRegKeyExist(keyspec);;
            return isInstalled;
        }

        /// <summary>
        /// Determines whether Java Advaned Imaging installed via a MSI file.
        /// </summary>
        /// <returns><c>true</c> if Java Advanced Imaging has been installed via a MSI file; otherwise, <c>false</c>.</returns>
        /// <remarks>Check performed to accomidate Legacy DICOM gateways. Java Advanced Imaging must be uninstalled before uninstalling
        /// Java or the Java uninstall operation will never succeed. This will always be a x86 installation.</remarks>
        public static bool IsJavaAdvancedImagingInstalledViaMsi()
        {
            // Note that if this is installed on a 64 bit OS it will be as WOW - no 64 bit support
            string keyspec = BusinessFacade.Is64BitOperatingSystem() ? @"SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\" :
                @"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\";
            keyspec += "{48FB7C81-0EF5-4857-8849-DD526BAC7A36}"; // version 1.1.3
            // uninstall args
            //
            bool isInstalled = RegistryUtilities.DoesRegKeyExist(keyspec); ;
            return isInstalled;
        }

        /// <summary>
        /// Uninstalls a Java Advanced Imaging IO installation that was made via a MSI package.
        /// </summary>
        /// <remarks>This must be done before uninstalling the JRE or else the JRE uninstall process becomes corrupted. VIX and HDIG installations do not
        /// do this - it is a hang over from the way the JRE was installed for the legacy DICOM gateway.</remarks>
        private static void UninstallAdvancedImageIO()
        {
            if (IsJavaImageIOInstalledViaMsi())
            {
                Info("Uninstalling Java Advanced Imaging IO version 1.1 which was installed via a MSI file");
                System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                externalProcess.StartInfo.FileName = @"msiexec.exe";
                externalProcess.StartInfo.Arguments = "/qn /x {F0877138-6292-4111-A2F4-158F58B8E5A4}";
                externalProcess.Start();
                do
                {
                    Thread.Sleep(500);
                    externalProcess.Refresh();
                } while (!externalProcess.HasExited);
            }
        }

        /// <summary>
        /// Uninstalls a Java Advanced Imaging installation that was made via a MSI package.
        /// </summary>
        /// <remarks>This must be done before uninstalling the JRE or else the JRE uninstall process becomes corrupted. VIX and HDIG installations do not
        /// do this - it is a hang over from the way the JRE was installed for the legacy DICOM gateway.</remarks>
        private static void UninstallAdvancedImageImaging()
        {
            if (IsJavaAdvancedImagingInstalledViaMsi())
            {
                Info("Uninstalling Java Advanced Imaging version 1.1.3 which was installed via a MSI file");
                System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                externalProcess.StartInfo.FileName = @"msiexec.exe";
                externalProcess.StartInfo.Arguments = "/qn /x {48FB7C81-0EF5-4857-8849-DD526BAC7A36}";
                externalProcess.Start();
                do
                {
                    Thread.Sleep(500);
                    externalProcess.Refresh();
                } while (!externalProcess.HasExited);
            }
        }


        /// <summary>
        /// Uninstalls the active Java Runtime Environment as specified by the manifest.
        /// </summary>
        public static void UninstallActiveJre()
        {
            if (IsJavaAdvancedImagingInstalledViaMsi())
            {
                UninstallAdvancedImageImaging();
            }

            if (IsJavaImageIOInstalledViaMsi())
            {
                UninstallAdvancedImageIO();
            }

            String javaPath = JavaFacade.GetActiveJrePathLocationIndependent();
            System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
            externalProcess.StartInfo.FileName = @"msiexec.exe";
            externalProcess.StartInfo.Arguments = Manifest.ActiveJavaPrerequisite.UninstallArgs;
            externalProcess.Start();
            do
            {
                Thread.Sleep(500);
                externalProcess.Refresh();
            } while (!externalProcess.HasExited);

            // remove Java from path env variable
            String javaBinPath = javaPath + @"\bin";
            String path = Environment.GetEnvironmentVariable("path", EnvironmentVariableTarget.Machine);
            if (path != null)
            {
                path = path.Replace(javaBinPath, "");
                path = path.Replace(";;", ";");
                Environment.SetEnvironmentVariable("path", path, EnvironmentVariableTarget.Machine);
            }
            Thread.Sleep(3000);
            // unfortunately even through the process is reported as having exited, windows is still catching up on the file deletes
            // this can cause errors in the directory delete operation
            do
            {
                try
                {
                    Directory.Delete(javaPath, true); // JAI and JAI Image IO files will remain so take them out
                }
                catch (System.IO.IOException) { ; }
            }
            while (Directory.Exists(javaPath));
        }

        /// <summary>
        /// This routine checks for an installed active JRE or JDK that does not conform to the directory naming conventions required by the VIX installer.
        /// </summary>
        /// <returns><c>true</c> if the active JRE or JDK prerequisite has been installed in the improper directory; otherwise, <c>false</c>.</returns>
        public static bool IsJavaInstalledInWrongDirectory(bool isDeveloperMode)
        {
            bool isJavaInstalledInWrongDir = false;

            if (isDeveloperMode && IsActiveJdkInstalledLocationIndependent())
            {
                isJavaInstalledInWrongDir = IsActiveJdkInstalledInWrongDirectory();
            }
            else
            {
                isJavaInstalledInWrongDir = IsActiveJreInstalledInWrongDirectory();
            }

            return isJavaInstalledInWrongDir;
        }

        /// <summary>
        /// This routine checks for an installed active JRE that does not conform to the directory naming conventions that would be implemented if the 
        /// VIX installer installed the JRE.
        /// </summary>
        /// <returns><c>true</c> if the active JRE specified by the manifest has been installed in the improper directory; otherwise, <c>false</c>.</returns>
        /// <remarks>A new JRE installation will be installed in a directory named JREx where x is the major version number. Subsequent concurrent installations of different 
        /// versions of the JRE will installed in a directory named jre1.x.0_y where x is the major version number and y is the minor release number. The VIX installer
        /// depends on and forces the second directory naming convention in all cases.</remarks>
        private static bool IsActiveJreInstalledInWrongDirectory()
        {
            bool isJreInstalledInWrongDir = false;
            JavaPrerequisite prerequisite = Manifest.ActiveJavaPrerequisite;
            string installationPath = GetJreInstallationPath(prerequisite.Version, prerequisite.Native);
            if (installationPath != null && installationPath != prerequisite.JrePath)
            {
                isJreInstalledInWrongDir = true;
            }
            return isJreInstalledInWrongDir;
        }

        /// <summary>
        /// This method checks the registry to see if the active JDK has been installed - independent of any installation directory checks.
        /// </summary>
        /// <returns><c>true</c> if the active JDK specified by the manifest has been installed; otherwise, <c>false</c>.</returns>
        private static bool IsActiveJdkInstalledLocationIndependent()
        {
            JavaPrerequisite prerequisite = Manifest.ActiveJavaPrerequisite;
            return GetJdkInstallationPath(prerequisite.Version, prerequisite.Native) != null ? true : false;
        }

        /// <summary>
        /// This routine checks for an installed active JDK that does not conform to the directory naming conventions that is expected by the Manifest 
        /// </summary>
        /// <returns><c>true</c> if the active JDK specified by the manifest is installed in the wrong directory; otherwise, <c>false</c>.</returns>
        /// <remarks>A new JDK installation will be installed in a directory named jdkx where x is the major version number. Subsequent concurrent installations of different 
        /// versions of the JDK will installed in a directory named jdk1.x.0_y where x is the major version number and y is the minor release number. The VIX installer
        /// depends on and forces the second directory naming convention in all cases.</remarks>
        private static bool IsActiveJdkInstalledInWrongDirectory()
        {
            bool isJdkInstalledInWrongDir = false;
            JavaPrerequisite prerequisite = Manifest.ActiveJavaPrerequisite;
            string installationPath = GetJdkInstallationPath(prerequisite.Version, prerequisite.Native);
            if (installationPath != null)
            {
                if (installationPath != prerequisite.JdkPath)
                {
                    isJdkInstalledInWrongDir = true;
                }
            }
            return isJdkInstalledInWrongDir;
        }

        /// <summary>
        /// This routine checks for an installed active JRE that does not conform to the directory naming conventions that would be implemented if the 
        /// VIX installer installed the JRE.
        /// </summary>
        /// <returns><c>true</c> if the active JRE has been installed in the improper directory; otherwise, <c>false</c>.returns>
        public static string GetActiveJrePathLocationIndependent()
        {
            JavaPrerequisite prerequisite = Manifest.ActiveJavaPrerequisite;
            return GetJreInstallationPath(prerequisite.Version, prerequisite.Native);
        }

        /// <summary>
        /// Gets the JRE installation path.
        /// </summary>
        /// <param name="version">The version of the installed JRE.</param>
        /// <param name="native">The native word size of the OS.</param>
        /// <returns>The fully qualified path to the JRE installation directory.</returns>
        //NOTE-Checked Registry.  This is correct.  This is no problem here for a Windows 2012 R2 server.
        private static string GetJreInstallationPath(string version, NativeType native)
        {
            string installationPath = null;
            string key = null;
            RegistryView regView;
            if (BusinessFacade.Is64BitOperatingSystem() && native == NativeType.x86)
            {
                key = @"SOFTWARE\Wow6432Node\Javasoft\Java Runtime Environment\1." + version;
                regView = RegistryView.Registry64; 
            }
            else
            {
                key = @"SOFTWARE\Javasoft\Java Runtime Environment\1." + version;
                regView = RegistryView.Registry64;
            }
            Logger().Info("key: " + key);
            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
            {
                using (RegistryKey javasoft = regKey.OpenSubKey(key, true))
                {
                    Logger().Info("Registry key: " + javasoft as string);
                    if (javasoft != null)
                    {
                        installationPath = javasoft.GetValue("JavaHome") as string;
                    }
                }
            }
            Logger().Info("Path in Registry: " + installationPath);
            return installationPath;
        }

        public static string GetActiveJrePathLocationIndependent(string version)
        {
            string installationPath = null;
            string key = @"SOFTWARE\Javasoft\Java Runtime Environment\" + version;
            RegistryView regView = RegistryView.Registry64;
            
            Logger().Info("key: " + key);
            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
            {
                using (RegistryKey javasoft = regKey.OpenSubKey(key, true))
                {
                    Logger().Info("Registry key: " + javasoft as string);
                    if (javasoft != null)
                    {
                        installationPath = javasoft.GetValue("JavaHome") as string;
                    }
                }
            }
            Logger().Info("Path in Registry: " + installationPath);
            return installationPath;
        }

        /// <summary>
        /// Gets the Java Development Kit installation path.
        /// </summary>
        /// <param name="version">The version of the installed JDK.</param>
        /// <param name="native">The native word size of the OS.</param>
        /// <returns>The fully qualified path to the JDK installation directory.</returns>
        private static string GetJdkInstallationPath(string version, NativeType native)
        {
            string installationPath = null;
            string key = null;
            RegistryView regView;

            if (BusinessFacade.Is64BitOperatingSystem() && native == NativeType.x86)
            {
                key = @"SOFTWARE\Wow6432Node\Javasoft\Java Development Kit\1." + version;
                regView = RegistryView.Registry64;
            }
            else
            {
                key = @"SOFTWARE\Javasoft\Java Development Kit\1." + version;
                regView = RegistryView.Registry64;
            }
            Logger().Info("key: " + key);

            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
            {
                using (RegistryKey javasoft = regKey.OpenSubKey(key, true))
                {
                    Logger().Info("Registry key: " + javasoft as string);
                    if (javasoft != null)
                    {
                        installationPath = javasoft.GetValue("JavaHome") as string;
                    }
                }
            }
            Logger().Info("Path in Registry: " + installationPath);
            return installationPath;
        }

        #endregion
    }
}
