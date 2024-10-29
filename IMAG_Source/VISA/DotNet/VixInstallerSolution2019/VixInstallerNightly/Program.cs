using System;
using System.Collections.Generic;
using System.Text;
using log4net;
using gov.va.med.imaging.exchange.VixInstaller.business;
using System.Diagnostics;
using System.Linq;
using System.IO;
using System.ServiceProcess;
using System.Threading;
using System.Xml;
using Vix.Viewer.Install;

namespace VixInstallerNightly
{
    class Program
    {
        //set to false to force Viewer and Render and Listener to be removed fully always
        private static readonly bool flagRemoveDeprecatedVVVR = false;

        static void Main(string[] args)
        {
            if (args.Length < 1)
            {
                usage();
                System.Environment.ExitCode = 1;
                return;
            }

            //VAI-356 Install .NET Framework 4.8 if 4.8 or greater is not installed
            double versionDotNet = BusinessFacade.GetNET48PlusFromRegistry();
            if (versionDotNet >= 4.8)
            {
                Console.WriteLine(".NET Framework 4.8 or greater is installed");
            }
            else
            {
                try
                {
                    BusinessFacade.InstallNETFramework(Environment.CurrentDirectory, 2);
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message, "Unable to install required .NET Framework 4.8");
                    System.Environment.ExitCode = 1;
                    return;
                }
            }

            string installerConfigFile = args[0];

            if (File.Exists(installerConfigFile))
            {
                try
                {
                    log4net.Config.XmlConfigurator.Configure(new System.IO.FileInfo(installerConfigFile));
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    System.Environment.ExitCode = 1;
                    return;
                }
            }

            string installLogFile = @"vix-install-log.txt";
            //if the prior install log exists use temp folder to save for the install log backup
            if (File.Exists(installLogFile))
            {
                try
                {
                    string dirPathVIXBackupTemp = @"C:\VIXBackup\temp";
                    var installLogFileTemp = dirPathVIXBackupTemp + @"\" + installLogFile;
                    if (!Directory.Exists(dirPathVIXBackupTemp))
                    {
                        Directory.CreateDirectory(dirPathVIXBackupTemp);
                    }
                    System.IO.File.Move(installLogFile, installLogFileTemp);
                }
                catch (Exception)
                {
                    // Do nothing, install log backup will show not created in PreUninstallConfigBackups.ps1
                }
                finally
                {
                    File.Delete(installLogFile);
                }
            }
            log4net.Config.XmlConfigurator.Configure(new System.IO.FileInfo("VixInstallerLog.xml"));

            VixManifest manifest = new VixManifest(Environment.CurrentDirectory);
            VixFacade.Manifest = manifest;
            TomcatFacade.Manifest = manifest;
            JavaFacade.Manifest = manifest;
            LaurelBridgeFacade.Manifest = manifest;
            BusinessFacade.Manifest = manifest;
            ZFViewerFacade.Manifest = manifest;
            ListenerFacade.Manifest = manifest;
            VixFacade.InfoDelegate = ConsoleLogInfo;
            JavaFacade.InfoDelegate = ConsoleLogInfo;
            LaurelBridgeFacade.InfoDelegate = ConsoleLogInfo;
            ZFViewerFacade.InfoDelegate = ConsoleLogInfo;
            ListenerFacade.InfoDelegate = ConsoleLogInfo;

            System.Environment.ExitCode = 0;

            LogInfo("Running nightly installer...");

            // unzip the VIX distribution payload (force overwrite if files exist)
            LogInfo("Payload path in manifest: " + manifest.PayloadPath);
            String unzipPath = Path.Combine(Environment.CurrentDirectory, "VIX");
            String vixZipFile = BusinessFacade.GetPayloadZipPath(Environment.CurrentDirectory);
            try
            {
                LogInfo("unzipping " + vixZipFile + " to " + unzipPath);
                ZipUtilities.ImprovedExtractToDirectory(vixZipFile, unzipPath, ZipUtilities.Overwrite.Always);
                LogInfo(vixZipFile + " unzipped successfully");
            }
            catch (Exception ex)
            {
                LogError(ex.Message);
                System.Environment.ExitCode = 1;
                return;
            }
            
            // check against the ViX distribution zip file being built incorrectly
            if (System.Environment.ExitCode == 0)
            {
                String payloadJar = Path.Combine(manifest.PayloadPath, @"server\jars");
                if (!Directory.Exists(payloadJar))
                {
                    string message = "The VIX distribution files contained in the VixDistribution.zip file cannot be installed.";
                    LogError(message);
                    System.Environment.ExitCode = 1;
                    return;
                }
                else
                {
                    try
                    {
                        // Uninstall the VIX/CVIX
                        LogInfo("Starting to uninstall C/VIX...");
                        UnDeployVix(args, manifest);
                    }
                    catch (Exception ex)
                    {
                        LogError(ex.Message);
                        System.Environment.ExitCode = 1;
                        return;
                    }
                }
            }

            // check against the uninstall being incorrect
            if (System.Environment.ExitCode == 0)
            {
                try
                {
                    // check the account running is an administrator
                    if (BusinessFacade.IsLoggedInUserAnAdministrator())
                    {
                        LogInfo(BusinessFacade.GetLoggedInUserName() + " is an Administrator.");
                    }
                    else
                    { 
                        LogError(BusinessFacade.GetLoggedInUserName() + " does not have Administrator role.");
                        System.Environment.ExitCode = 1;
                        return;
                    }

                    // check the Operating System for a supported version
                    bool osCheck = CheckOS(args);
                    if (osCheck == true)
                    {
                        LogInfo("Operating System is supported.");
                    }
                    else
                    {
                        LogError("Operating System not supported.");
                        System.Environment.ExitCode = 1;
                        return;
                    }

                    // check the disk space to ensure enough available
                    bool diskCheck = CheckDiskSpace(); ;
                    if (diskCheck == true)
                    {
                        LogInfo("Enough free disk space available.");
                    }
                    else 
                    { 
                        LogError("Not enough free disk space available.");
                        System.Environment.ExitCode = 1;
                        return;
                    }

                    // Install the VIX/CVIX
                    LogInfo("Starting to install C/VIX...");
                    DeployVix(args);

                    // verify that the services started up after install
                    LogInfo("Verifying service status...");
                    bool servicesRunningCheck = CheckServiceStatus();
                    if (servicesRunningCheck == true)
                    {
                        LogInfo("Services are running.");
                    }
                    else
                    {
                        LogError("Services are not all running...");
                        System.Environment.ExitCode = 1;
                        return;
                    }
                }
                catch (Exception ex)
                {
                    LogError(ex.Message);
                    System.Environment.ExitCode = 1;
                    return;
                }
                finally
                {
                    if (Directory.Exists(manifest.PayloadPath))
                    {
                        Directory.Delete(manifest.PayloadPath, true); // uninstall will clean up the zip file
                    }
                }       
            }
        }

        static void Instance_MessageEventHandler(object sender, string e)
        {
            LogInfo("Viewer installer: " + e);
        }

        #region private methods
        private static bool CheckOS(String[] args)
        {
            string info = null;
            string vixInstallerConfigFileSpec = Path.Combine(args[0], @"VixInstallerConfig.xml");
            IVixConfigurationParameters config = VixConfigurationParameters.FromXmlFile(vixInstallerConfigFileSpec);
            bool devMode = false;
            return BusinessFacade.IsOperatingSystemApproved(ref info, config, devMode);
        }

        private static bool CheckDiskSpace()
        {
            bool isEnoughSpace = false;
            int neededDiskSpaceGB = 2;
            int freeDiskSpaceGB = BusinessFacade.GetTotalFreeSpace();

            if (freeDiskSpaceGB >= neededDiskSpaceGB)
            {
                isEnoughSpace = true;
            }

            return isEnoughSpace;
        }

        private static void UnDeployVix(String[] args, VixManifest manifest)
        {
            string vixInstallerConfigFileSpec = Path.Combine(args[0], @"VixInstallerConfig.xml");
            IVixConfigurationParameters config = VixConfigurationParameters.FromXmlFile(vixInstallerConfigFileSpec);

            //These config value depended on VixServerName, refresh the values after loading
            config.VixServerNameProp = Environment.MachineName;
            config.ProductVersionProp = manifest.FullyQualifiedPatchNumber;
            config.PreviousProductVersionProp = config.PreviousProductVersion1;
            config.ApacheTomcatPassword = config.ApacheTomcatPassword1;

            LogInfo("Replace properties with arguments");
            ReplaceConfigDefault(args, config);

            string errmsg = string.Empty;
            if (!ValidatePassword(config, out errmsg))
            {
                LogError("Password Validation Error: " + errmsg);
                System.Environment.ExitCode = 1;
                return;
            }

            //determine patch number
            string fullVersionCurrent = config.ProductVersionProp;
            string[] versionPassArray = fullVersionCurrent.Split('.');
            string versionPassCurrent = versionPassArray[1];
            //determine prior patch number
            string fullVersionPrior;
            string versionPassPrior;
            if (config.PreviousProductVersionProp != null)
            {
                fullVersionPrior = config.PreviousProductVersionProp;
                string[] versionPassPriorArray = fullVersionPrior.Split('.');
                versionPassPrior = versionPassPriorArray[1];
            }
            else
            {
                fullVersionPrior = null;
                versionPassPrior = null;
            }

            ZFViewerFacade.InstallZFViewerScriptsOnly();

            BusinessFacade.DeleteCache(config.LocalCacheDir);

            bool serviceStopOk = ServiceStop();

            if (serviceStopOk)
            {
                //1 used for start of install process 2 used for end of install process
                int installPassCase = 1;
                //determine if for CVIX install or VIX
                string vixRoleTypePass;
                if (config.VixRole == VixRoleType.EnterpriseGateway)
                {
                    vixRoleTypePass = "CVIX";
                }
                else
                {
                    vixRoleTypePass = "VIX";
                }

                //Run process to create zip file of latest VIXBackup folder
                BusinessFacade.VIXBackupZip(versionPassPrior);

                //Run process to create single line history of install process to track each install
                BusinessFacade.VIXBackupInstallHistory(fullVersionCurrent, fullVersionPrior, installPassCase);

                //Run start of uninstall process - use to backup config files
                BusinessFacade.RunStartOrEndOfInstallProcess(versionPassCurrent, versionPassPrior, installPassCase, vixRoleTypePass, config.ConfigCheck);

                //Run process to delete old VIXBackup folders
                BusinessFacade.VIXBackupDeleteOldDirs();

                VixFacade.UndeployVixWebApplications(config);

                if (JavaFacade.IsJavaInstalled(false) == false)
                {
                    if (JavaFacade.IsDeprecatedJreInstalled())
                    {
                        JavaFacade.UninstallDeprecatedJre();
                    }
                }

                if (TomcatFacade.IsTomcatInstalled())
                {
                    if (TomcatFacade.IsDeprecatedTomcatVersionInstalled() == true)
                    {
                        TomcatFacade.UninstallDeprecatedTomcat();
                    }
                }

                LogInfo("IsLaurelBridgeRequired: " + config.IsLaurelBridgeRequired);
                LogInfo("IsLaurelBridgeLicensed: " + LaurelBridgeFacade.IsLaurelBridgeLicensed());

                if ((config.IsLaurelBridgeRequired) && (!LaurelBridgeFacade.IsLaurelBridgeLicensed()))
                {
                    LogError("Laurel Bridge License is invalid");
                }

                // Removes the deprecated renamed Laurel Bridge folder if exists and the current Laurel Bridge is installed
                if ((config.IsLaurelBridgeRequired) && LaurelBridgeFacade.IsLaurelBridgeInstalled())
                {
                    LogInfo("Removing prior Laurel Bridge DCF toolkit folder " + LaurelBridgeFacade.GetDeprecatedLaurelBridgeVersion());
                    string dcfRenamedRoot = LaurelBridgeFacade.GetDeprecatedRenamedRootDirspec(LaurelBridgeFacade.GetActiveDcfRootFromManifest());
                    LaurelBridgeFacade.DeleteDeprecatedDcfRoot(dcfRenamedRoot);
                }

                // Removes the deprecated Laurel Bridge toolkit by renaming the installation directory, deleting environment
                // variables, and removing relevant directories from the path environment variable
                if ((config.IsLaurelBridgeRequired) && LaurelBridgeFacade.IsDeprecatedLaurelBridgeInstalled())
                {
                    LogInfo("Removing existing prior Laurel Bridge DCF toolkit version " + LaurelBridgeFacade.GetDeprecatedLaurelBridgeVersion());
                    LaurelBridgeFacade.RemoveLaurelBridgeInstallation(config);
                    LaurelBridgeFacade.DeleteOldDeprecatedDcfRoot(config.RenamedDeprecatedDcfRoot);
                    LaurelBridgeFacade.SaveRenamedDeprecatedDcfRoot(config.RenamedDeprecatedDcfRoot); // save only the deprecated root to disk so we dont lose it
                }

                //1 used for prior LibreOffice uninstall
                if (IsOfficeInstalled(1))
                {
                    LogInfo("Prior LibreOffice already installed, uninstalling");
                    UninstallLibreOffice(1);
                }

                //1 used for prior PowerShell uninstall
                if (IsPowerShellInstalled(1))
                {
                    LogInfo("Prior PowerShell already installed, uninstalling");
                    UninstallPowerShell(1);
                }

                LogInfo("Uninstall previous version of VIX Viewer");
                UninstallViewer(config);
            }
        }

        private static void DeployVix(String[] args)
        {
            string vixInstallerConfigFileSpec = Path.Combine(args[0], @"VixInstallerConfig.xml");
            IVixConfigurationParameters config = VixConfigurationParameters.FromXmlFile(vixInstallerConfigFileSpec);
            //Now that uninstall is complete begin the install process

            if (!JavaFacade.IsJavaInstalled(false))
            {
                InstallJava();
            }

            if (!TomcatFacade.IsTomcatInstalled())
            {
                InstallTomcat(config);
            }

            if (LaurelBridgeFacade.IsLaurelBridgeInstalled() == false)
            {
                InstallAndLicenseLaurelBridgeToolkit(LaurelBridgeFacade.GetActiveDcfRootFromManifest());
            }

            LogInfo("Recreate apachetomcat service account *******");
            ConfigureServiceAccount(config);

            //2 used for current LibreOffice install 
            if (!IsOfficeInstalled(2))
            {
                LogInfo("Current LibreOffice not installed, installing");
                InstallOffice();
            }

            //2 used for current PowerShell install 
            if (!IsPowerShellInstalled(2))
            {
                LogInfo("Current PowerShell not installed, installing");
                InstallPowerShell();
            }

            //Create VixCache dir, required to give tomcatuser access right
            if (!Directory.Exists(config.LocalCacheDir))
            {
                Directory.CreateDirectory(config.LocalCacheDir);
            }

            //Create VixRenderCache dir, required to give tomcatuser access right
            if (!Directory.Exists(config.VixRenderCache))
            {
                Directory.CreateDirectory(config.VixRenderCache);
            }

            //Create VixConfig dir, required to give tomcatuser access right
            if (!Directory.Exists(config.ConfigDir))
            {
                Directory.CreateDirectory(config.ConfigDir);
            }

            //Create VixCache dir, required to give tomcatuser access right
            if (!Directory.Exists(config.LocalCacheDir))
            {
                Directory.CreateDirectory(config.LocalCacheDir);
            }

            //Create VixCertStore dir, required to give tomcatuser access right
            string certificateStoreDir = VixFacade.GetVixCertificateStoreDir();
            LogInfo("certificateStoreDir: " + certificateStoreDir);
            if (!Directory.Exists(certificateStoreDir))
            {
                Directory.CreateDirectory(certificateStoreDir);
            }

            //Copy certificates if not present in the used certificate store directory
            if (!string.IsNullOrEmpty(config.VixCertStoreDir) && (!certificateStoreDir.Equals(config.VixCertStoreDir)))
            {
                LogInfo("Copy Certificates from: " + config.VixCertStoreDir);
                VixFacade.CopyCertificates(certificateStoreDir, config.VixCertStoreDir);
            }

            //Create Tomcat Archived logs dir and symbolic link
            if (Directory.Exists(config.TomcatArchiveDir) == false)
            {
                Directory.CreateDirectory(config.TomcatArchiveDir);
            }
            if (Directory.Exists(GetTomcatArchivedLogsLinkPath()))
            {
                Directory.Delete(GetTomcatArchivedLogsLinkPath());
            }
            VixFacade.CreateSymbolicLink(GetTomcatArchivedLogsLinkPath(), config.TomcatArchiveDir, 0x1);

            LogInfo("Installing Viewer and Render Services");
            InstallViewer(config);

            //Create PDF files symbolic link
            string pdfFilesPath = ZFViewerFacade.ViewerInstallPath + "\\VIX.Viewer.Service\\Viewer\\Files";
            string renderCacheFilesPath = config.VixRenderCache + "\\Files";
            if (Directory.Exists(pdfFilesPath))
            {
                Directory.Delete(pdfFilesPath);
            }
            VixFacade.CreateSymbolicLink(pdfFilesPath, renderCacheFilesPath, 0x1);

            LogInfo("Installing C/VIX");
            VixFacade.InstallVix(config);  
        }

        private static void InstallJava()
        {
            LogInfo("Installing Java version " + JavaFacade.ActiveJavaVersion);

            String exe = JavaFacade.GetInstallerFilespec();
            LogInfo("Installer Filespec: " + exe);

            var externalProcess = new System.Diagnostics.Process();
            externalProcess.StartInfo.FileName = exe;

            //JRE
            externalProcess.StartInfo.Arguments = "/s INSTALLDIR=\\\"" + JavaFacade.GetActiveJavaPath(true) + "\\\" AUTO_UPDATE=Disable";

            LogInfo("Arguments: " + externalProcess.StartInfo.Arguments);
            externalProcess.Start();
            externalProcess.WaitForExit();

            // append to the path
            String javaPath = JavaFacade.GetActiveJavaPath(JavaFacade.IsActiveJreInstalled());
            String path = Environment.GetEnvironmentVariable("path", EnvironmentVariableTarget.Machine);
            if (path == null)
            {
                Environment.SetEnvironmentVariable("path", javaPath, EnvironmentVariableTarget.Machine);
            }
            else // prepend to path to get so that this java is found before MS java in the Windows\system32 dir
            {
                if (!path.Contains(javaPath))
                {
                    path = javaPath + @"\bin;" + path;
                    path = path.Replace(";;", ";"); // case sensisitive
                    LogInfo("Adding " + path + " to the Windows PATH environment variable");
                    Environment.SetEnvironmentVariable("path", path, EnvironmentVariableTarget.Machine);
                }
            }
        }

        private static void InstallTomcat(IVixConfigurationParameters config)
        {
            LogInfo("Installing Apache Tomcat version " + TomcatFacade.ActiveTomcatVersion);

            String exe = TomcatFacade.InstallerFilespec;
            LogInfo("Tomcat Installer: " + exe);

            var externalProcess = new System.Diagnostics.Process();
            externalProcess.StartInfo.FileName = exe;
            externalProcess.StartInfo.Arguments = "/S";
            externalProcess.Start();
            externalProcess.WaitForExit();

            ConfigureTomcatUsers(config);
            TomcatFacade.ConfigureTomcatService(config);
        }

        private static bool ConfigureServiceAccount(IVixConfigurationParameters config)
        {
            String username = TomcatFacade.ServiceAccountUsername;
            String password = config.ApacheTomcatPassword;

            if (WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName))
            {
                LogInfo("Updating service account password for " + username + ".");
                if (WindowsUserUtilities.UpdateServiceAccountPassword(username, password))
                {
                    LogInfo("Setting service account " + username + " privileges.");
                    LsaUtilities.SetServiceAccountPrivleges(username);
                }
                else
                {
                    LogError("Error updating service account password. The password that you supplied does not meet the complexity requirements of this computer. Please try again.");
                    config.ApacheTomcatPassword = null;
                    return false;
                }
            }

            if (!WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName))
            {
                LogInfo("Creating service account " + username + " on this machine: " + Environment.MachineName);
                if (WindowsUserUtilities.CreateServiceAccount(username, password, "VIX service account"))
                {
                    LogInfo("Setting service account " + username + " privileges.");
                    LsaUtilities.SetServiceAccountPrivleges(username);
                }
                else
                {
                    LogError("Error creating service account. The password that you supplied does not meet the complexity requirements of this computer. Please try again.");
                    config.ApacheTomcatPassword = null;
                    return false;
                }
            }

            if (WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName))
            {
                LogInfo("Setting " + TomcatFacade.TomcatServiceName + " service to run under " + username + " account.");
                ServiceUtilities.SetServiceCredentials(TomcatFacade.TomcatServiceName, username, password, ClusterFacade.IsServerClusterNode());
            }

            return true;
        }
        private static bool IsOfficeInstalled(int librePassCase)
        {
            if (BusinessFacade.IsOfficeRegKeyPresent(librePassCase))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private static bool IsPowerShellInstalled(int powershellPassCase)
        {
            if (BusinessFacade.IsPowerShellRegKeyPresent(powershellPassCase))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private static void UninstallLibreOffice(int librePassCase)
        {
            // uninstall LibreOffice
            LogInfo("Checking LibreOffice");
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode OfficeNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']");
            XmlNode OfficeNodeUninstall;
            if (OfficeNode != null)
            {
                string appPath = OfficeNode.Attributes["appRootRelativeFolder"].Value.Trim();

                if (BusinessFacade.IsOfficeRegKeyPresent(librePassCase))
                {
                    OfficeNodeUninstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']/UninstallCommand");
                    string UninstallCommand = null;
                    if (OfficeNodeUninstall != null)
                    {
                        UninstallCommand = OfficeNodeUninstall.InnerXml.Trim();
                        if (UninstallCommand.ToLower() != "no_upgrade")
                        {
                            System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                            externalProcess.StartInfo.UseShellExecute = false;
                            externalProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                            externalProcess.StartInfo.FileName = "msiexec.exe";
                            externalProcess.StartInfo.Arguments = UninstallCommand;
                            bool Completed = false;
                            try
                            {
                                externalProcess.Start();
                                Completed = externalProcess.WaitForExit(600000);
                            }
                            catch (Exception EX)
                            {
                                LogInfo("LibreOffice Uninstall recieved error " + EX.ToString());
                            }
                            if (Completed)
                            {
                                //Remove LibreOffice from PATH environment variable - only if prior version of LibreOffice uninstalled
                                string appPath2 = appPath.Replace(@"\\", @"\");
                                string librePath = $@"C:{appPath2}\program";
                                string librePathOld = $@"C:\{appPath2}\\program";
                                string workPath = Environment.GetEnvironmentVariable("Path", EnvironmentVariableTarget.Machine);
                                IEnumerable<string> filteredList = workPath.Split(';').Where(x => string.Compare(x, librePath, true) != 0 && string.Compare(x, librePathOld, true) != 0);
                                workPath = string.Join(";", filteredList);
                                Environment.SetEnvironmentVariable("Path", workPath, EnvironmentVariableTarget.Machine);
                                LogInfo("Uninstalling LibreOffice Completed");
                            }
                            else
                            {
                                LogInfo("LibreOffice Uninstall Did Not Complete");
                            }
                        }
                        else
                        {
                            LogInfo("No Uninstall for LibreOffice required");
                        }
                    }
                    else
                    {
                        LogInfo("LibreOffice Uninstall Did Not Complete No Uninstall Entry");
                    }
                }
                else
                {
                    LogInfo("Prior LibreOffice version is not installed on this machine");
                }
            }
            else
            {
                LogInfo("LibreOffice Uninstall Did Not Complete No Manifest Entry");
            }
        }

        private static void UninstallPowerShell(int powerShellPassCase)
        {
            LogInfo("Checking PowerShell");
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode PowerShellNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']");
            XmlNode PowerShellNodeUninstall;
            if (PowerShellNode != null)
            {
                //1 used for prior PowerShell uninstall, 2 used for current PowerShell uninstall 
                if (BusinessFacade.IsPowerShellRegKeyPresent(powerShellPassCase))
                {
                    PowerShellNodeUninstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']/UninstallCommand");
                    string UninstallCommand = null;
                    if (PowerShellNodeUninstall != null)
                    {
                        UninstallCommand = PowerShellNodeUninstall.InnerXml.Trim();
                        if (UninstallCommand.ToLower() != "no_upgrade")
                        {
                            System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                            externalProcess.StartInfo.UseShellExecute = false;
                            externalProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                            externalProcess.StartInfo.FileName = "msiexec.exe";
                            externalProcess.StartInfo.Arguments = UninstallCommand;
                            bool Completed = false;
                            try
                            {
                                externalProcess.Start();
                                Completed = externalProcess.WaitForExit(600000);
                            }
                            catch (Exception EX)
                            {
                                LogError("PowerShell Uninstall recieved error " + EX.ToString());
                            }
                            if (Completed)
                            {
                                LogInfo("Uninstalling PowerShell Completed");
                            }
                            else
                            {
                                LogError("PowerShell Uninstall Did Not Complete");
                            }
                        }
                        else
                        {
                            LogInfo("No Uninstall for PowerShell required");
                        }
                    }
                    else
                    {
                        LogError("PowerShell Uninstall Did Not Complete No Uninstall Entry");
                    }
                }
                else
                {
                    LogInfo("Prior PowerShell version is not installed on this machine");
                }
            }
            else
            {
                LogError("PowerShell Uninstall Did Not Complete No Manifest Entry");
            }
        }

        private static bool ValidatePassword(IVixConfigurationParameters config, out string errmsg)
        {
            errmsg = string.Empty;
            bool isValid = true;
            if (!TomcatFacade.ValidatePassword(config.TomcatAdminPassword, out errmsg) ||
                !TomcatFacade.ValidatePassword(config.FederationKeystorePassword, out errmsg) ||
                !TomcatFacade.ValidatePassword(config.FederationTruststorePassword, out errmsg))
            {
                isValid = false;
            }
            return isValid;
        }

        private static void InstallOffice()
        {
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode OfficeNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']");
            XmlNode OfficeNodeInstall;
            string appPath = "";
            string ManPath = "";
            if (OfficeNode != null)
            {
                OfficeNodeInstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']/InstallCommand");
                String RelativePath = OfficeNode.Attributes["payloadRelativeFolder"].Value.Trim();
                ManPath = Path.Combine(WorkManifest.PayloadPath, RelativePath);
                appPath = OfficeNode.Attributes["appRootRelativeFolder"].Value.Trim();

                System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                externalProcess.StartInfo.UseShellExecute = false;
                if (Directory.Exists(ManPath))
                {
                    externalProcess.StartInfo.WorkingDirectory = ManPath;
                    externalProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                    externalProcess.StartInfo.FileName = "msiexec.exe";
                    externalProcess.StartInfo.Arguments = OfficeNodeInstall.InnerXml.Trim();
                    externalProcess.Start();

                    bool Completed = externalProcess.WaitForExit(600000);
                    if (Completed)
                    {
                        LogInfo("Installing LibreOffice Install Completed");
                        //Remove LibreOffice from PATH environment variable - added to avoid duplicate entry of LibreOffice in PATH             
                        string appPath2 = appPath.Replace(@"\\", @"\");
                        string librePath = $@"C:{appPath2}\program";
                        string librePathOld = $@"C:\{appPath2}\\program";
                        string workPath = Environment.GetEnvironmentVariable("Path", EnvironmentVariableTarget.Machine);
                        IEnumerable<string> filteredList = workPath.Split(';').Where(x => string.Compare(x, librePath, true) != 0 && string.Compare(x, librePathOld, true) != 0);
                        workPath = string.Join(";", filteredList);
                        Environment.SetEnvironmentVariable("Path", workPath, EnvironmentVariableTarget.Machine);
                        //Add LibreOffice to PATH environment variable
                        string workPathNew = Environment.GetEnvironmentVariable("Path", EnvironmentVariableTarget.Machine);
                        workPathNew = workPathNew + ";" + librePath;
                        Environment.SetEnvironmentVariable("Path", workPathNew, EnvironmentVariableTarget.Machine);
                    }
                    else
                    {
                        LogError("LibreOffice Install Did Not Complete");
                    }
                }
                else
                {
                    LogError("LibreOffice working directory missing " + ManPath);
                }
            }
            else
            {
                LogError("LibreOffice not in manifest file.");
            }
        }

        private static void InstallPowerShell()
        {
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode PSNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']");
            XmlNode PSNodeInstall;
            if (PSNode != null)
            {
                PSNodeInstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']/InstallCommand");
                String PSRelativePath = PSNode.Attributes["payloadRelativeFolder"].Value.Trim();
                string PSManPath = Path.Combine(WorkManifest.PayloadPath, PSRelativePath);

                System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                externalProcess.StartInfo.UseShellExecute = false;
                if (Directory.Exists(PSManPath))
                {
                    externalProcess.StartInfo.WorkingDirectory = PSManPath;
                    externalProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                    externalProcess.StartInfo.FileName = "msiexec.exe";
                    externalProcess.StartInfo.Arguments = PSNodeInstall.InnerXml.Trim();
                    externalProcess.Start();

                    bool Completed = externalProcess.WaitForExit(600000);
                    if (Completed)
                    {
                        LogInfo("Installing PowerShell Install Completed");
                    }
                    else
                    {
                        LogError("PowerShell Install Did Not Complete");
                    }
                }
                else 
                {
                    LogError("PowerShell working directory Missing " + PSManPath);
                }
            }
            else
            {
                LogError("PowerShell Not in Manifest File.");
            }
         }

        private static void InstallAndLicenseLaurelBridgeToolkit(string dcfPath)
        { 
            try
            { 
                if (LaurelBridgeFacade.IsLaurelBridgeInstalled() == false)
                {
                    //import Laurel Bridge certificate into Java cacerts
                    BusinessFacade.ImportLaurelBridgeCertIntoCacerts();

                    string errorMessage = "";
                    if (LaurelBridgeFacade.InstallLaurelBridgeDcfToolkit(dcfPath, ref errorMessage) == false)
                    {
                        string message = @"The Laurel Bridge DCF toolkit could not be installed due to the following error: " + errorMessage;
                        LogInfo(message + "Error installing DCF toolkit");
                    }
                }

                if (LaurelBridgeFacade.IsLaurelBridgeInstalled() == true && LaurelBridgeFacade.IsLaurelBridgeLicensed() == false)
                {
                    //import Laurel Bridge certificate into Java cacerts
                    BusinessFacade.ImportLaurelBridgeCertIntoCacerts();

                    // License toolkit with a VA enterprise license. The UI will provide feedback about errors.
                    string deprecatedDcfRoot = LaurelBridgeFacade.GetDeprecatedRenamedRootDirspec(dcfPath);
                    if (Directory.Exists(deprecatedDcfRoot))
                    {
                        string deprecatedDcfCfg = "";
                        try
                        {
                            deprecatedDcfCfg = Path.Combine(deprecatedDcfRoot, @"cfg\");
                            string dcfCfg = Path.Combine(dcfPath, @"cfg\");
                            string lbSystemInfo = "systeminfo";
                            if (File.Exists(Path.Combine(deprecatedDcfCfg, lbSystemInfo)))
                            {
                                File.Copy(Path.Combine(deprecatedDcfCfg, lbSystemInfo), Path.Combine(dcfCfg, lbSystemInfo), true);

                                // For an upgraded verson of Laurel Bridge once the license is copied into the installation folder the
                                // deprecated renamed Laurel Bridge folder can be deleted.
                                LaurelBridgeFacade.DeleteDeprecatedDcfRoot(deprecatedDcfRoot);
                            }
                            else
                            {
                                string message = "Cannot restore Laurel Bridge license file from " + deprecatedDcfCfg + " as file did not exist";
                                LogInfo(message);
                            }
                        }
                        catch (Exception ex)
                        {
                            string message = "Cannot restore Laurel Bridge license file from " + deprecatedDcfCfg + "\nException message is\n" + ex.Message;
                            LogInfo(message);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogError("Laurel Bridge Install recieved error " + ex.ToString());
            }
        }

        private static void InstallViewer(IVixConfigurationParameters config)
        {
            LogInfo("ViewerInstallPath in manifest: " + ZFViewerFacade.ViewerInstallPath);
            if (!Directory.Exists(ZFViewerFacade.ViewerInstallPath))
            {
                Directory.CreateDirectory(ZFViewerFacade.ViewerInstallPath);
            }

            string vixRenderCache = config.VixRenderCache;
            string vixRenderCache2 = vixRenderCache.Replace(@"/", @"\");

            if (ZFViewerFacade.IsZFViewerInstalled())
            {
                //reinstall ZFViewer
                LogInfo("Re-Installing Viewer");
                ZFViewerFacade.StopZFViewerServices();

                bool isBackedUp = ZFViewerFacade.BackupZFViewerCfgFiles();
                if (!isBackedUp)
                {
                    LogInfo("Failed to backup Image Viewer/Render Configuration files");
                }

                bool isServicesRemoved = DestroySilentZFViewerWindowsServices();
                if (!isServicesRemoved)
                {
                    LogInfo("Failed to remove Image Viewer and/or Image Render Windows Services.");
                }

                if (!ZFViewerFacade.DeleteViewerPaths())
                {
                    LogInfo("Failed to remove existing Listener installation");
                }

                if (!ZFViewerFacade.PurgeZFViewerRenderDatabase())
                {
                    LogInfo("Failed to purge existing Image Render Database.");
                    LogInfo("Please manually purge ViewRender database");
                }

                if (!ZFViewerFacade.PurgeZFViewerCache())
                {
                    LogInfo("Failed to purge Viewer Cache.");
                }

                ZFViewerFacade.InstallZFViewer();

                if (ZFViewerFacade.isZFViewerCfgBackupFilesExist())
                {
                    ZFViewerFacade.RestoreZFViewerCfgFiles();
                }

                LogInfo("Setting MessageEventHandler in the viewer interop");
                ConfigManager.Instance.MessageEventHandler += Instance_MessageEventHandler;

                LogInfo("Setting InstallPath in the viewer interop");
                ConfigManager.Instance.InstallPath = ZFViewerFacade.ViewerInstallPath;

                LogInfo("Setting VixVersion in the viewer interop");
                ConfigManager.Instance.ViewerProperties.VixServiceProperties.VixVersion = ZFViewerFacade.Manifest.MajorPatchNumber.ToString();

                LogInfo("Execute ResetSecurityConfiguration");
                ConfigManager.Instance.ResetSecurityConfigurationCommand.Execute(null);

                LogInfo("Setting ImageCacheDirectory in the viewer interop");
                ConfigManager.Instance.ViewerProperties.StorageProperties.ImageCacheDirectory = vixRenderCache2;

                LogInfo("Updating Render configuration file");
                ZFViewerFacade.UpdateCacheVixRenderConfig(vixRenderCache2);

                LogInfo("Saving Viewer/Render configuration files");
                ZFViewerFacade.SaveConfiguration();

                LogInfo("Create Viewer/Render Services");
                string viewerServicePath = Path.Combine(ZFViewerFacade.ViewerInstallPath, "VIX.Viewer.Service");
                string viewerServiceFile = "VIX.Viewer.Service.exe";
                if (!File.Exists(Path.Combine(viewerServicePath, viewerServiceFile)))
                {
                    LogError("Viewer service not found");
                }
                else
                {
                    InstallProcess(viewerServicePath, viewerServiceFile);
                }
                string renderServicePath = Path.Combine(ZFViewerFacade.ViewerInstallPath, "VIX.Render.Service");
                string renderServiceFile = "VIX.Render.Service.exe";
                if (!File.Exists(Path.Combine(renderServicePath, renderServiceFile)))
                {
                    LogError("Render service not found");
                }
                else
                {
                    InstallProcess(renderServicePath, renderServiceFile);
                }
            }
            else
            {
                LogInfo("Installing Viewer");
                ZFViewerFacade.InstallZFViewer();

                if (ZFViewerFacade.isZFViewerCfgBackupFilesExist())
                {
                    ZFViewerFacade.RestoreZFViewerCfgFiles();
                }

                LogInfo("Setting MessageEventHandler in the viewer interop");
                ConfigManager.Instance.MessageEventHandler += Instance_MessageEventHandler;

                LogInfo("Setting InstallPath in the viewer interop");
                ConfigManager.Instance.InstallPath = ZFViewerFacade.ViewerInstallPath;

                LogInfo("Setting VixVersion in the viewer interop");
                ConfigManager.Instance.ViewerProperties.VixServiceProperties.VixVersion = ZFViewerFacade.Manifest.MajorPatchNumber.ToString();

                LogInfo("Execute ResetSecurityConfiguration");
                ConfigManager.Instance.ResetSecurityConfigurationCommand.Execute(null);

                LogInfo("Setting ImageCacheDirectory in the viewer interop");
                ConfigManager.Instance.ViewerProperties.StorageProperties.ImageCacheDirectory = vixRenderCache2;

                LogInfo("Updating Render configuration file");
                ZFViewerFacade.UpdateCacheVixRenderConfig(vixRenderCache2);

                LogInfo("Saving Viewer/Render configuration files");
                ZFViewerFacade.SaveConfiguration();

                LogInfo("Create Viewer/Render Services");
                string viewerServicePath = Path.Combine(ZFViewerFacade.ViewerInstallPath, "VIX.Viewer.Service");
                string viewerServiceFile = "VIX.Viewer.Service.exe";
                if (!File.Exists(Path.Combine(viewerServicePath, viewerServiceFile)))
                {
                    LogError("Viewer service not found");
                }
                else
                {
                    InstallProcess(viewerServicePath, viewerServiceFile);
                }
                string renderServicePath = Path.Combine(ZFViewerFacade.ViewerInstallPath, "VIX.Render.Service");
                string renderServiceFile = "VIX.Render.Service.exe";
                if (!File.Exists(Path.Combine(renderServicePath, renderServiceFile)))
                {
                    LogError("Render service not found");
                }
                else
                {
                    InstallProcess(renderServicePath, renderServiceFile);
                }
            }

            if (ListenerFacade.IsListenerInstalled())
            {
                LogInfo("Listener already installed, attempting reinstall");
                
                string listenerServicePath = ListenerFacade.ListenerInstallPath;
                string listenerServiceFile = "ListenerTool.exe";
                if (!File.Exists(Path.Combine(listenerServicePath, listenerServiceFile)))
                {
                    LogError("Listener service not found");
                }
                else
                {
                    InstallProcess(listenerServicePath, listenerServiceFile);
                }
            }
            else
            {
                LogInfo("Installing Listener");
                if (!ListenerFacade.InstallListener())
                {
                    LogError("Listener Tool failed to install.  But the Installation process will continue.");
                }
                else
                {
                    LogInfo("Creating Listener service");
                    //ListenerFacade.CreateListenerWindowsService();

                    string listenerServicePath = ListenerFacade.ListenerInstallPath;
                    string listenerServiceFile = "ListenerTool.exe";
                    if (!File.Exists(Path.Combine(listenerServicePath, listenerServiceFile)))
                    {
                        LogError("Listener service not found");
                    }
                    else
                    {
                        InstallProcess(listenerServicePath, listenerServiceFile);
                    }
                }
            }
        }

        private static bool InstallProcess(string filePath, string fileName)
        {
            System.Diagnostics.Process process = new System.Diagnostics.Process();
            process.StartInfo.FileName = @"C:\Windows\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe";
            process.StartInfo.WorkingDirectory = filePath;
            process.StartInfo.Arguments = fileName;
            process.StartInfo.UseShellExecute = false;
            process.StartInfo.CreateNoWindow = true;
            process.Start();
            process.WaitForExit();

            if (process.ExitCode != 0)
            {
                LogError("There was a problem with the install of " + fileName);
                return false;  //Return false if process ended unsuccessfully
            }
            LogInfo(fileName + " installed successfully.");
            return true; //Return true if process ended successfully
           
        }

        private static bool UninstallProcess(string filePath, string fileName)
        {
            System.Diagnostics.Process process = new System.Diagnostics.Process();
            process.StartInfo.FileName = @"C:\Windows\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe";
            process.StartInfo.WorkingDirectory = filePath;
            process.StartInfo.Arguments = "/u "+ fileName;
            process.StartInfo.UseShellExecute = false;
            process.StartInfo.CreateNoWindow = true;
            process.Start();
            process.WaitForExit();

            if (process.ExitCode != 0)
            {
                LogError("There was a problem with the uninstall of " + fileName);
                return false;  //Return false if process ended unsuccessfully
            }
            LogInfo(fileName + " uninstalled successfully.");
            return true; //Return true if process ended successfully          
        }

        public static bool DestroySilentZFViewerWindowsServices()
        {
            bool isDeleted = false;
            bool isViewerDeleted = false;
            bool isRenderDeleted = false;

            LogInfo("Uninstalling VIX.Viewer.Service");
            string viewerServicePath = Path.Combine(ZFViewerFacade.ViewerInstallPath, "VIX.Viewer.Service");
            string viewerServiceFile = "VIX.Viewer.Service.exe";
            if (!File.Exists(Path.Combine(viewerServicePath, viewerServiceFile)))
            {
                LogError("Viewer service not found");
            }
            else
            {
                bool isSilentZFViewerWindowsServicesRemoved = UninstallProcess(viewerServicePath, viewerServiceFile);
                if (isSilentZFViewerWindowsServicesRemoved)
                {
                    isViewerDeleted = true;
                }
            }
   
            LogInfo("Uninstalling VIX.Render.Service");
            string renderServicePath = Path.Combine(ZFViewerFacade.ViewerInstallPath, "VIX.Render.Service");
            string renderServiceFile = "VIX.Render.Service.exe";
            if (!File.Exists(Path.Combine(renderServicePath, renderServiceFile)))
            {
                LogError("Render service not found");
            }
            else
            {
                bool isSilentZFRenderWindowsServicesRemoved = UninstallProcess(renderServicePath, renderServiceFile);
                if (isSilentZFRenderWindowsServicesRemoved)
                {
                    isRenderDeleted = true;
                }
            }

            if (isViewerDeleted && isRenderDeleted)
            {
                isDeleted = true;
            }
            return isDeleted;
        }

        private static void UninstallViewer(IVixConfigurationParameters config)
        {
            if (ZFViewerFacade.IsZFViewerInstalled())
            {
                bool isBackedUp = ZFViewerFacade.BackupZFViewerCfgFiles();
                if (!isBackedUp)
                {
                    LogInfo("Failed to backup Image Viewer/Render Configuration files");
                }

                if (!ZFViewerFacade.PurgeZFViewerCache())
                {
                    LogInfo("Failed to purge Viewer Cache.");
                }

                if ((flagRemoveDeprecatedVVVR == false) || ZFViewerFacade.IsDeprecatedZFViewerInstalled(config.PreviousProductVersionProp))
                {
                    bool isServicesRemoved = DestroySilentZFViewerWindowsServices();
                    if (!isServicesRemoved)
                    {
                        LogInfo("Failed to remove Image Viewer and/or Image Render Windows Services.");
                    }

                    bool isZFViewerUninstalled = ZFViewerFacade.UninstallZFViewer();
                    if (!isZFViewerUninstalled)
                    {
                        LogInfo("Failed to uninstall Image Viewer version " + ZFViewerFacade.GetDeprecatedZFViewerVersion(config.PreviousProductVersionProp));
                    }
                }

                if (!ZFViewerFacade.PurgeZFViewerRenderDatabase(config.PreviousProductVersionProp))
                {
                    LogInfo("Failed to purge existing Image Render Database.");
                    LogInfo("Please manually purge ViewRender database");
                }
            }

            if (ListenerFacade.IsListenerInstalled())
            {
                if ((flagRemoveDeprecatedVVVR == false) || ListenerFacade.IsDeprecatedListenerInstalled())
                {
                    string listenerServicePath = ListenerFacade.ListenerInstallPath;
                    string listenerServiceFile = "ListenerTool.exe";
                    bool isListenerServiceRemoved = UninstallProcess(listenerServicePath, listenerServiceFile);
                    if (!isListenerServiceRemoved)
                    {
                        LogInfo("Failed to remove Listener Tool Windows Services.");
                    }

                    bool isListenerUninstalled = ListenerFacade.UninstallListener();
                    if (!isListenerUninstalled)
                    {
                        LogInfo("Failed to uninstall the Listener Tool version " + ListenerFacade.GetDeprecatedListenerVersion());
                    }
                }
            }
        }

        private static bool ServiceStop()
        {
            if (TomcatFacade.IsTomcatInstalled())
            {
                ServiceControllerStatus status = ServiceUtilities.GetLocalServiceStatus(TomcatFacade.TomcatServiceName);
                LogInfo("The ApacheTomcat service is " + status.ToString("g"));
                if (status != ServiceControllerStatus.Stopped)
                {
                    LogInfo("Stopping ApacheTomcat service.");
                    // attempt to stop the service
                    ServiceUtilities.StopLocalService(TomcatFacade.TomcatServiceName);
                    do
                    {
                        Thread.Sleep(500);
                        status = ServiceUtilities.GetLocalServiceStatus(TomcatFacade.TomcatServiceName);
                    }
                    while (status == System.ServiceProcess.ServiceControllerStatus.StopPending);
                    status = ServiceUtilities.GetLocalServiceStatus(TomcatFacade.TomcatServiceName);
                    LogInfo("The ApacheTomcat service is " + status.ToString("g"));
                    if (status != ServiceControllerStatus.Stopped)
                    {
                        string message = "Cannot stop the ApacheTomcat service";
                        LogError(message);
                        return false;
                    }
                }
            }

            if (ZFViewerFacade.IsZFViewerInstalled())
            {
                LogInfo("Stopping VIX Viewer service.");
                bool viewerStopStatus = ZFViewerFacade.StopZFViewerServices();
                if (!viewerStopStatus)
                {
                    string message = "Cannot stop the VIX Viewer and/or Render service";
                    LogError(message);
                    return false;
                }
            }

            if (ListenerFacade.IsListenerInstalled())
            {
                LogInfo("Stopping Listener service.");
                bool listenerStopStatus = ListenerFacade.StopListenerService();
                if (!listenerStopStatus)
                {
                    string message = "Cannot stop the ListenerTool service";
                    LogError(message);
                    return false;
                }
            }
            
            return true;
        }

        private static bool CheckServiceStatus()
        {
            bool isRunning = false; 
            bool isTomcatRunning = false;
            bool isViewerRunning = false;
            bool isRenderRunning = false;
            bool isListenerRunning = false;

            string VIEWER_SERVICE_ACCOUNT_NAME = "VIX Viewer Service";
            string RENDER_SERVICE_ACCOUNT_NAME = "VIX Render Service";

            ServiceControllerStatus tomcatStatus = ServiceUtilities.GetLocalServiceStatus(TomcatFacade.TomcatServiceName);
            if (tomcatStatus != ServiceControllerStatus.Stopped)
            {
                 isTomcatRunning = true;
            }

            ServiceControllerStatus viewerStatus = ServiceUtilities.GetLocalServiceStatus(VIEWER_SERVICE_ACCOUNT_NAME);
            if (viewerStatus != ServiceControllerStatus.Stopped)
            {
                isViewerRunning = true;
            }

            ServiceControllerStatus renderStatus = ServiceUtilities.GetLocalServiceStatus(RENDER_SERVICE_ACCOUNT_NAME);
            if (renderStatus != ServiceControllerStatus.Stopped)
            {
                isRenderRunning = true;
            }

            // VAI-480 - Turn off Listener
            //ServiceControllerStatus listenerStatus = ServiceUtilities.GetLocalServiceStatus(ListenerFacade.LISTENER_SERVICE_NAME);
            //if (listenerStatus != ServiceControllerStatus.Stopped)
            //{
            //    isListenerRunning = true;
            //}

            //if (isTomcatRunning && isViewerRunning && isRenderRunning && isListenerRunning)
            if (isTomcatRunning && isViewerRunning && isRenderRunning)
            {
                isRunning = true;
            }

            return isRunning;
        }

            private static string GetTomcatArchivedLogsLinkPath()
        {
            string tomcatArchiveLogsLinkPath = TomcatFacade.TomcatInstallationFolder + "\\logs\\ImagingArchivedLogsLink";
            return tomcatArchiveLogsLinkPath;
        }

        private static void ReplaceConfigDefault(String[] args, IVixConfigurationParameters config)
        {
            for (var i = 1; i < args.Length; i++)
            {
                String[] nameValue = args[i].Split('=');

                //Get the value from <field>=<value> pair -  works with value contains = char
                String val = nameValue[1];
                for (var vindx = 2; vindx < nameValue.Length; vindx++)
                {
                    val += "=" + nameValue[vindx];
                }
                switch (nameValue[0].ToLower())
                {
                    case "apachetomcatpassword":
                        config.ApacheTomcatPassword = val;
                        break;
                    case "configdir":
                        config.ConfigDir = val;
                        break;
                    case "configcheck":
                        bool ConfigCheck;
                        if (Boolean.TryParse(val, out ConfigCheck))
                        {
                            config.ConfigCheck = ConfigCheck;
                        }
                        break;
                    case "cvixhttpconnectorport":
                        config.CvixHttpConnectorPort = Int32.Parse(val);
                        break;
                    case "cvixhttpsconnectorport":
                        config.CvixHttpsConnectorPort = Int32.Parse(val);
                        break;
                    case "dodconnectorhost":
                        config.DoDConnectorHost = val;
                        break;
                    case "dodconnectorport":
                        config.DoDConnectorPort = Int32.Parse(val);
                        break;
                    case "dodconnectorloinc":
                        config.DoDConnectorLoinc = val;
                        break;
                    case "dodconnectorrequestsource":
                        config.DoDConnectorRequestSource = val;
                        break;
                    case "dodconnectorprovider":
                        config.DoDConnectorProvider = val;
                        break;
                    case "federationkeystorepassword":
                        config.FederationKeystorePassword = val;
                        break;
                    case "federationtruststorepassword":
                        config.FederationTruststorePassword = val;
                        break;
                    case "islaurelbridgerequired":
                        bool isRequired;
                        if (Boolean.TryParse(val, out isRequired))
                        {
                            config.IsLaurelBridgeRequired = isRequired;
                        }
                        break;
                    case "localcachedir":
                        config.LocalCacheDir = val;
                        break;
                    case "museEnabled":
                        bool MuseEnabledBool;
                        if (Boolean.TryParse(val, out MuseEnabledBool))
                        {
                            config.MuseEnabled = MuseEnabledBool;
                        }
                        break;
                    case "museSiteNum":
                        config.MuseSiteNum = val;
                        break;
                    case "museHostname":
                        config.MuseHostname = val;
                        break;
                    case "museUsername":
                        config.MuseUsername = val;
                        break;
                    case "musePassword":
                        config.MusePassword = val;
                        break;
                    case "musePort":
                        config.MusePort = val;
                        break;
                    case "museProtocol":
                        config.MuseProtocol = val;
                        break;
                    case "previousproductversion":
                        config.PreviousProductVersionProp = val;
                        break;
                    case "productversion":
                        config.ProductVersionProp = val;
                        break;
                    case "sitesfile":
                        config.SitesFile = val;
                        break;
                    case "sitename":
                        config.SiteName = val;
                        break;
                    case "siteabbreviation":
                        config.SiteAbbreviation = val;
                        break;
                    case "station200username":
                        config.Station200UserName = val;
                        break;
                    case "tomcatadminpassword":
                        config.TomcatAdminPassword = val;
                        break;
                    case "vistaservername":
                        config.VistaServerName = val;
                        break;
                    case "vistaserverport":
                        config.VistaServerPort = val;
                        break;
                    case "vixcertstoredir":
                        config.VixCertStoreDir = val;
                        break;
                    case "vixrendercache":
                        ConfigManager.Instance.ViewerProperties.StorageProperties.ImageCacheDirectory = val;
                        config.VixRenderCache = val;
                        break;
                    case "vixtxdb":
                        config.VixTxDbDir = val;
                        break;

                    default:
                        break;
                }
            }
        }

        private static ILog Logger()
        {
            return LogManager.GetLogger("VixInstallerNightly");
        }

        private static String LogError(String infoMessage)
        {
            Console.WriteLine(infoMessage);
            Logger().Error(infoMessage);
            return infoMessage;
        }

        private static String ConsoleLogInfo(String infoMessage)
        {
            Console.WriteLine(infoMessage);
            return infoMessage;
        }

        private static String LogInfo(String infoMessage)
        {
            Console.WriteLine(infoMessage);
            Logger().Info(infoMessage);
            return infoMessage;
        }

        private static void usage()
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("VixInstallerNightly - the VIX nightly installation utility");
            sb.AppendLine("Usage:");
            sb.AppendLine("VixInstallerNightly");
            sb.AppendLine("\tdisplays this help information");
            sb.AppendLine("VixInstallerNightly \"application dirspec\"");
            sb.AppendLine("\tinstalls the nightly build using the specified application dirspec.");
            Console.Write(sb.ToString());
        }

        private static void ConfigureTomcatUsers(IVixConfigurationParameters config)
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
            sb.AppendFormat("\t<user username=\"{0}\" password=\"{1}\" roles=\"admin,manager\" />", "admin", config.TomcatAdminPassword);
            sb.Append(Environment.NewLine);
            sb.AppendLine("</tomcat-users>");
            String tomcatUsersPath = Path.Combine(TomcatFacade.TomcatConfigurationFolder, @"tomcat-users.xml");
            using (TextWriter tw = new StreamWriter(tomcatUsersPath))
            {
                tw.Write(sb.ToString());
            }
        }

        #endregion

    }
}
