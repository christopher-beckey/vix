using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.IO;
using System.ServiceProcess;
using log4net;
using Microsoft.Win32;
using System.Diagnostics;
using Vix.Viewer.Install;
using System.Xml;


namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public static class ZFViewerFacade
    {
        private static readonly String VIEWER_SERVICE_ACCOUNT_NAME = "VIX Viewer Service";
        private static readonly String RENDER_SERVICE_ACCOUNT_NAME = "VIX Render Service";
        
        //These values should be ok for initial install 
        private static readonly String RENDER_DATABASE_USER_ID = "sa";
        private static readonly String RENDER_DATABASE_PASSWORD = "vitelnet123$%%";

        public static VixManifest Manifest { get; set; }
        public static InfoDelegate InfoDelegate { get; set; }
        public static AppEventsDelegate AppEventsDelegate { get; set; }
        public static string ViewerPayloadFilespec { get { return Manifest.ActiveZFViewerPrerequisite.PayloadFilespec; } }
        public static string ViewerInstallPath { get { return Manifest.ActiveZFViewerPrerequisite.InstallPath; } }
        public static string ViewerServiceAccountName { get { return VIEWER_SERVICE_ACCOUNT_NAME; } }
        public static string RenderServiceAccountName { get { return RENDER_SERVICE_ACCOUNT_NAME; } }
        public static string ViewerServiceExe { get { return Path.Combine(ZFViewerFacade.ViewerInstallPath, @"VIX.Viewer.Service\VIX.Viewer.Service.exe");  } }
        public static string RenderServiceExe { get { return Path.Combine(ZFViewerFacade.ViewerInstallPath, @"VIX.Render.Service\VIX.Render.Service.exe");  } }
        public static string ViewerServiceExePath { get { return Path.Combine(ZFViewerFacade.ViewerInstallPath, @"VIX.Viewer.Service"); } }
        public static string RenderServiceExePath { get { return Path.Combine(ZFViewerFacade.ViewerInstallPath, @"VIX.Render.Service"); } }
        public static string ViewerServiceCfgPath { get { return Path.Combine(ZFViewerFacade.ViewerInstallPath, @"VIX.Config"); } }
        public static string ViewerServiceRelPath { get { return Path.Combine(ZFViewerFacade.ViewerInstallPath, @"_rels"); } }
        public static string ViewerServicePackagePath { get { return Path.Combine(ZFViewerFacade.ViewerInstallPath, @"package"); } }
        public static string ViewerServiceInstallerPath { get { return Path.Combine(ZFViewerFacade.ViewerInstallPath, @"VIX.Installer"); } }
        public static string ViewerServiceClientPath { get { return Path.Combine(ZFViewerFacade.ViewerInstallPath, @"VIX.Viewer.Service.Client"); } }
        
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(ZFViewerFacade).Name);
        }

        private static String Info(String infoMessage)
        {
            if (InfoDelegate != null)
            {
                InfoDelegate(infoMessage);
            }
            Logger().Info(infoMessage); // any info provided to the presentation layer will be logged.
            return infoMessage;
        }

        private static void DoEvents()
        {
            if (AppEventsDelegate != null)
            {
                AppEventsDelegate();
            }
        }

        public static bool IsZFViewerInstalled(ref String info)
        {
            info = null;
            bool isInstalled = true;
            if (!IsZFViewerInstalled())
            {
                isInstalled = false;
                info = "The VIX Viewer/Render Services are not installed.";
            }
            else
            {
                info = "The VIX Viewer/Render Services are installed.";
            }
            return isInstalled;
        }

        public static bool IsZFViewerInstalled()
        {
            bool isInstalled = false;

            if (Directory.Exists(ZFViewerFacade.ViewerServiceExePath))
            {
                if (File.Exists(ZFViewerFacade.ViewerServiceExe))
                {
                    isInstalled = true;
                }
            }
            return isInstalled;
        }

        public static bool StartZFViewerServices()
        {
            Info("Starting Image Viewer service.");
            // attempt to stop the service
            ServiceControllerStatus viewerStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.VIEWER_SERVICE_ACCOUNT_NAME);
            if (viewerStatus != ServiceControllerStatus.Running)
            {
                ServiceUtilities.StartLocalService(ZFViewerFacade.VIEWER_SERVICE_ACCOUNT_NAME);
                do
                {
                    DoEvents();
                    Thread.Sleep(500);
                    viewerStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.VIEWER_SERVICE_ACCOUNT_NAME);
                }
                while (viewerStatus == System.ServiceProcess.ServiceControllerStatus.StartPending);
                viewerStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.VIEWER_SERVICE_ACCOUNT_NAME);
                Info("The Image Viewer service is " + viewerStatus.ToString("g"));
                if (viewerStatus != ServiceControllerStatus.Running)
                {
                    return false;
                }
            }

            Info("Starting Image Render service.");
            ServiceControllerStatus renderStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.RENDER_SERVICE_ACCOUNT_NAME);
            if (renderStatus != ServiceControllerStatus.Running)
            {
                ServiceUtilities.StartLocalService(ZFViewerFacade.RENDER_SERVICE_ACCOUNT_NAME);
                do
                {
                    DoEvents();
                    Thread.Sleep(500);
                    renderStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.RENDER_SERVICE_ACCOUNT_NAME);
                }
                while (renderStatus == System.ServiceProcess.ServiceControllerStatus.StartPending);
                renderStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.RENDER_SERVICE_ACCOUNT_NAME);
                Info("The Image Render service is " + renderStatus.ToString("g"));
                if (renderStatus != ServiceControllerStatus.Running)
                {
                    return false;
                }
            }

            return true;

            /**
            bool isStarted = false;
            bool isViewerStarted = false;
            bool isRenderStarted = false;

            if (ConfigManager.Instance.RenderStartServiceCommand.CanExecute(null))
            {
                Logger().Info("attempting to start Render Service.");
                ConfigManager.Instance.RenderStartServiceCommand.Execute(null);
                isRenderStarted = true;
            }

            if (ConfigManager.Instance.ViewerStartServiceCommand.CanExecute(null))
            {
                Logger().Info("attempting to start Viewer Service.");
                ConfigManager.Instance.ViewerStartServiceCommand.Execute(null);
                isViewerStarted = true;
            }

            if (isViewerStarted && isRenderStarted)
            {
                isStarted = true;
            }
            return isStarted;
            **/
        }
        
        public static bool StopZFViewerServices()
        {
            Info("Stopping Image Viewer service.");
           
            // attempt to stop the service

            try
            {
                ServiceControllerStatus viewerStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.VIEWER_SERVICE_ACCOUNT_NAME);

                if (viewerStatus == ServiceControllerStatus.Running)
                {

                    ServiceUtilities.StopLocalService(ZFViewerFacade.VIEWER_SERVICE_ACCOUNT_NAME);
                    do
                    {
                        DoEvents();
                        Thread.Sleep(500);
                        viewerStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.VIEWER_SERVICE_ACCOUNT_NAME);
                    }
                    while (viewerStatus == System.ServiceProcess.ServiceControllerStatus.StopPending);
                    viewerStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.VIEWER_SERVICE_ACCOUNT_NAME);
                    Info("The Image Viewer service is " + viewerStatus.ToString("g"));
                    if (viewerStatus != ServiceControllerStatus.Stopped)
                    {
                        return false;
                    }
                }

            }
            catch
            {
                //continue
            }
            
            Info("Stopping Image Render service.");
            try
            {
                ServiceControllerStatus renderStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.RENDER_SERVICE_ACCOUNT_NAME);

                if (renderStatus == ServiceControllerStatus.Running)
                {
                    ServiceUtilities.StopLocalService(ZFViewerFacade.RENDER_SERVICE_ACCOUNT_NAME);
                    do
                    {
                        DoEvents();
                        Thread.Sleep(500);
                        renderStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.RENDER_SERVICE_ACCOUNT_NAME);
                    }
                    while (renderStatus == System.ServiceProcess.ServiceControllerStatus.StopPending);
                    renderStatus = ServiceUtilities.GetLocalServiceStatus(ZFViewerFacade.RENDER_SERVICE_ACCOUNT_NAME);
                    Info("The Image Render service is " + renderStatus.ToString("g"));
                    if (renderStatus != ServiceControllerStatus.Stopped)
                    {
                        return false;
                    }
                }

            }
            catch
            {
                //continue
            }
            
            return true;
        }

        public static bool InstallZFViewer()
        {
            Info("Unzip " + ZFViewerFacade.ViewerPayloadFilespec + " on " + ZFViewerFacade.ViewerInstallPath);
            ZipUtilities.ImprovedExtractToDirectory(ZFViewerFacade.ViewerPayloadFilespec, ZFViewerFacade.ViewerInstallPath, ZipUtilities.Overwrite.Always);

            return true;
        }

        public static bool InstallZFViewerScriptsOnly()
        {
            Info("Unzip Scripts folder from " + ZFViewerFacade.ViewerPayloadFilespec + " on " + ZFViewerFacade.ViewerInstallPath);
            ZipUtilities.ImprovedExtractSubFolderToDirectory(ZFViewerFacade.ViewerPayloadFilespec, ZFViewerFacade.ViewerInstallPath, "Scripts", ZipUtilities.Overwrite.Always);

            return true;
        }

        public static bool UninstallZFViewer()
        {
            bool isBackedUp = BackupZFViewerCfgFiles();

            if (!isBackedUp)
            {
                Info("Failed to backup Image Viewer/Render Configuration files.");
                return false;
            }

            if (!ZFViewerFacade.DeleteViewerPaths())
            {
                Info("Failed to remove existing Listener installation");
            }

            return true;
        }

        public static bool DeleteViewerPaths()
        {
            Info("Delete " + ZFViewerFacade.ViewerServiceExePath);
            if (Directory.Exists(ZFViewerFacade.ViewerServiceExePath))
                Directory.Delete(ZFViewerFacade.ViewerServiceExePath, true);

            Info("Delete " + ZFViewerFacade.RenderServiceExePath);
            if (Directory.Exists(ZFViewerFacade.RenderServiceExePath))
                Directory.Delete(ZFViewerFacade.RenderServiceExePath, true);

            Info("Delete " + ZFViewerFacade.ViewerServiceCfgPath);
            if (Directory.Exists(ZFViewerFacade.ViewerServiceCfgPath))
                Directory.Delete(ZFViewerFacade.ViewerServiceCfgPath, true);

            Info("Delete " + ZFViewerFacade.ViewerServiceRelPath);
            if (Directory.Exists(ZFViewerFacade.ViewerServiceRelPath))
                Directory.Delete(ZFViewerFacade.ViewerServiceRelPath, true);

            Info("Delete " + ZFViewerFacade.ViewerServicePackagePath);
            if (Directory.Exists(ZFViewerFacade.ViewerServicePackagePath))
                Directory.Delete(ZFViewerFacade.ViewerServicePackagePath, true);

            Info("Delete " + ZFViewerFacade.ViewerServiceInstallerPath);
            if (Directory.Exists(ZFViewerFacade.ViewerServiceInstallerPath))
                Directory.Delete(ZFViewerFacade.ViewerServiceInstallerPath, true);

            Info("Delete " + ZFViewerFacade.ViewerServiceClientPath);
            if (Directory.Exists(ZFViewerFacade.ViewerServiceClientPath))
                Directory.Delete(ZFViewerFacade.ViewerServiceClientPath, true);

            return true;
        }

        public static bool PurgeZFViewerRenderDatabase(string passInPriorVersionNo = "")
        {
            bool isPurged = false;
            string userid = RENDER_DATABASE_USER_ID; // ConfigManager.Instance.ViewerProperties.DatabaseProperties.UserName;
            string pwd = RENDER_DATABASE_PASSWORD; // ConfigManager.Instance.ViewerProperties.DatabaseProperties.Password;

            //string dbInstance = ConfigManager.Instance.ViewerProperties.DatabaseProperties.InstanceName;
            Logger().Info("Purging Render Database");

            try
            {                                                
                isPurged = SQLiteFacade.PurgeRenderDatabase();
            }
            catch(Exception)
            {
                isPurged = false;
            }

            return isPurged;
        }

        public static bool PurgeZFViewerCache()
        {
            try
            {
                string renderCache = ConfigManager.Instance.ViewerProperties.StorageProperties.ImageCacheDirectory;
                if (!Directory.Exists(renderCache))
                {
                    Info("Cannot remove viewer render cache - (directory: " + renderCache + " not found)");
                    renderCache = null;
                }

                if (renderCache != null)
                {
                    Directory.Delete(renderCache, true);
                }   
                return true;

            }
            catch(Exception)
            {
                return false;
            }
            
        }

        public static string GetImageRenderCacheDirectory()
        {
            string renderCache= @"D:\VIXRenderCache";
            try
            {
                renderCache = ConfigManager.Instance.ViewerProperties.StorageProperties.ImageCacheDirectory;        
            }
            catch (Exception ex)
            {
                Logger().Info("Exception while reading VIXRenderCache, setting to drive D:" + ex.Message);
            }
            return renderCache;
        }   
        
        public static bool IsDeprecatedZFViewerInstalled(string passPriorVersionIn)
        {
            bool isInstalled = false;
            if (IsZFViewerInstalled())
            {
                string installedVersion = GetInstalledZFViewerVersion(passPriorVersionIn);
                if (installedVersion != Manifest.ActiveZFViewerPrerequisite.Version)
                {
                    isInstalled = true;
                }
            }
            else
            {
                isInstalled = false; // nothing is installed - safety net
            }
            return isInstalled;
        }

        public static string GetDeprecatedZFViewerVersion(string versionNoPriorPassString)
        {
            string version = null;
            ZFViewerPrerequisite prerequisite = GetInstalledDeprecatedZFViewerPrerequsite(versionNoPriorPassString);
            if (prerequisite != null)
            {
                version = prerequisite.Version;
            }
            else
            {
                version = "0.0.0.0";
            }
            return version;
        }

        public static bool CreateZFViewerWindowsService()
        {
            bool isCreated = false;
            bool isViewerCreated = false;
            bool isRenderCreated = false;

            if (ConfigManager.Instance.ViewerInstallServiceCommand.CanExecute(null))
            {
                ConfigManager.Instance.ViewerInstallServiceCommand.Execute(null);
                isViewerCreated = true;
            }

            if (ConfigManager.Instance.RenderInstallServiceCommand.CanExecute(null))
            {
                ConfigManager.Instance.RenderInstallServiceCommand.Execute(null);
                isRenderCreated = true;
            }

            if (isViewerCreated && isRenderCreated)
            {
                isCreated = true;
            }
            return isCreated;
        }

        public static bool CreateZFViewerSilentWindowsService()
        {
            bool isCreated = false;
            bool isViewerCreated = false;
            bool isRenderCreated = false;

            if (ConfigManager.Instance.ViewerInstallServiceCommand.CanExecute(null))
            {
                ConfigManager.Instance.ViewerInstallServiceCommand.Execute(null);
                isViewerCreated = true;
            }

            if (ConfigManager.Instance.RenderInstallServiceCommand.CanExecute(null))
            {
                ConfigManager.Instance.RenderInstallServiceCommand.Execute(null);
                isRenderCreated = true;
            }

            if (isViewerCreated && isRenderCreated)
            {
                isCreated = true;
            }
            return isCreated;
        }

        public static bool DestroyZFViewerWindowsServices()
        {
            bool isDeleted = false;
            bool isViewerDeleted = false;
            bool isRenderDeleted = false;

            try
            {
                Logger().Info("Uninstalling " + VIEWER_SERVICE_ACCOUNT_NAME);
                ServiceInstaller viewerService = new ServiceInstaller();
                viewerService.Context = new System.Configuration.Install.InstallContext("vixviewer.log", null);
                viewerService.ServiceName = VIEWER_SERVICE_ACCOUNT_NAME;
                viewerService.Uninstall(null);
                isViewerDeleted = true;
            }
            catch (Exception e)
            {
                Logger().Info("Failed uninstalling " + VIEWER_SERVICE_ACCOUNT_NAME);
            }
            
            //if (ConfigManager.Instance.ViewerUninstallServiceCommand.CanExecute(null))
            //{
            //    Logger().Info("Uninstalling Viewer Service");
            //    ConfigManager.Instance.ViewerUninstallServiceCommand.Execute(null);
            //    isViewerDeleted = true;
            //}

            try
            {
                Logger().Info("Uninstalling " + RENDER_SERVICE_ACCOUNT_NAME);
                ServiceInstaller viewerService = new ServiceInstaller();
                viewerService.Context = new System.Configuration.Install.InstallContext("vixrender.log", null);
                viewerService.ServiceName = RENDER_SERVICE_ACCOUNT_NAME;
                viewerService.Uninstall(null);
                isRenderDeleted = true;
            }
            catch (Exception)
            {
                Logger().Info("Failed uninstalling " + RENDER_SERVICE_ACCOUNT_NAME);
            }
            
            //if (ConfigManager.Instance.RenderUninstallServiceCommand.CanExecute(null))
            //{
            //    Logger().Info("Uninstalling Viewer Render Service");
            //    ConfigManager.Instance.RenderUninstallServiceCommand.Execute(null);
            //    isRenderDeleted = true;
            //}

            if (isViewerDeleted && isRenderDeleted)
            {
                isDeleted = true;
            }
            return isDeleted;
        }

        public static bool BackupZFViewerCfgFiles()
        {
            bool isBackedUp = false;

            if (Directory.Exists(ZFViewerFacade.ViewerServiceCfgPath))
            {
                try
                { 
                    //String vixConfigBackup = Path.Combine(ZFViewerFacade.ViewerInstallPath, @"VIX.Config.Backup");
                    //Use C:\TEMP to save Vix Conig for backup. Using ViewerInstallPath causing problem and may 
                    //require changing in the Viewer API
                    String vixConfigBackupPath = @"c:\temp\VIX.Config.Backup";

                    Logger().Info("Directory Delete " + vixConfigBackupPath);
                    if (Directory.Exists(vixConfigBackupPath))
                    {
                        Directory.Delete(vixConfigBackupPath, true);
                    }

                    Logger().Info("Directory Copy from " + ZFViewerFacade.ViewerServiceCfgPath + " to " + vixConfigBackupPath);
                    DirectoryCopy(ZFViewerFacade.ViewerServiceCfgPath, vixConfigBackupPath, false);
                    isBackedUp = true;
                }
                catch (Exception X)
                {
                    Logger().Error("Could not make copy of Viewer Config files. Exception is: " + X.Message);
                    isBackedUp = false;
                }
            }
            else
            {
                Logger().Info(ZFViewerFacade.ViewerServiceCfgPath + " doesn't exist");
            }

            return isBackedUp;
        }

        public static bool RestoreZFViewerCfgFiles()
        {
            bool isRestored = false;
            //string backupPath = Path.Combine(ZFViewerFacade.ViewerInstallPath, @"VIX.Config.Backup"
            string vixConfigBackupPath = @"c:\temp\VIX.Config.Backup";
            if (Directory.Exists(vixConfigBackupPath))
            {
                Logger().Info(vixConfigBackupPath + " exists. Restoring...");
                try
                {
                    Logger().Info("Directory Delete " + ZFViewerFacade.ViewerServiceCfgPath);
                    if (Directory.Exists(ZFViewerFacade.ViewerServiceCfgPath))
                    {
                        Directory.Delete(ZFViewerFacade.ViewerServiceCfgPath, true);
                    }

                    DirectoryCopy(vixConfigBackupPath, ZFViewerFacade.ViewerServiceCfgPath, false);
                    isRestored = true;
                    Logger().Info(vixConfigBackupPath + " Restored");
					
					try
                    {				
					      Logger().Info("Directory Delete " + vixConfigBackupPath);
                          Directory.Delete(vixConfigBackupPath, true);
					}
				    catch (Exception Y)
				    {
					      Logger().Error("Could not delete temporary Viewer Config files. Exception is: " + Y.Message);
					}					
                }
                catch (Exception X)
                {
                    Logger().Error("Could not restore Viewer Config files. Exception is: " + X.Message);
                    isRestored = false;
                }
            }
            return isRestored;
        }

        public static bool isZFViewerCfgBackupFilesExist()
        {
            bool isBackupFilesExist = false;
            string backupPath = @"c:\temp\VIX.Config.Backup";

            if (Directory.Exists(backupPath))
            {
                Logger().Info(backupPath + " exists!");
                string[] files = Directory.GetFiles(backupPath);
                Logger().Info("Number of files: " + files.Length);
                
                if (files.Length < 2)
                {
                    isBackupFilesExist = false;
                }
                else
                {
                    isBackupFilesExist = true;
                }
            }
            return isBackupFilesExist;
        }

        public static bool RequireToSaveConfiguration()
        {
            return (ConfigManager.Instance.SaveConfigurationCommand.CanExecute(null));
        }

        public static void ResetSecurityConfiguration()
        {
            // always reset security config before closing
            if (ConfigManager.Instance.ResetSecurityConfigurationCommand.CanExecute(null))
            {
                Logger().Info("Execute ZFViewerFacade.ResetSecurityConfiguration");
                ConfigManager.Instance.ResetSecurityConfigurationCommand.Execute(null);
            }
            else
            {
                Logger().Info("Unable to execute ZFViewerFacade.ResetSecurityConfiguration");
            }
        }

        public static void UpdateCacheVixRenderConfig(string vixRenderCache)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(vixRenderConfigPath);

            XmlNode xmlNode = doc.DocumentElement.ChildNodes[3].ChildNodes[1];
            xmlNode.Attributes["Path"].Value = vixRenderCache;

            doc.Save(vixRenderConfigPath);
        }

        #region Private methods

        private static string GetInstalledZFViewerVersion(string passPriorInVersion)
        {
            //VAI 300 - Version History update
            string version = passPriorInVersion;           
          
            Info("Installed Image Viewer/Render Version is " + version);
            return version;
        }

        private static bool IsPrerequisiteInstalled(ZFViewerPrerequisite prerequisite, string versionPriorNoPassString)
        {
            bool isInstalled = false;
            string installedVersion = GetInstalledZFViewerVersion(versionPriorNoPassString).ToLower();

            if (installedVersion != null && installedVersion == prerequisite.Version)
            {
                isInstalled = true;
            }

            return isInstalled;
        }

        private static ZFViewerPrerequisite GetInstalledDeprecatedZFViewerPrerequsite(string versionPassedPriorString)
        {
            Debug.Assert(IsZFViewerInstalled() == true);
            string installedZFViewerVersion = GetInstalledZFViewerVersion(versionPassedPriorString);
            ZFViewerPrerequisite zfViewerPrerequisite = null;

            foreach (ZFViewerPrerequisite prerequisite in Manifest.DeprecatedZFViewerPrerequisites)
            {
                if (IsPrerequisiteInstalled(prerequisite, versionPassedPriorString))
                {
                    zfViewerPrerequisite = prerequisite;
                    break;
                }
            }
            return zfViewerPrerequisite;
        }

        private static void DirectoryCopy(string sourceDirName, string destDirName, bool copySubDirs)
        {
            // Get the subdirectories for the specified directory.
            DirectoryInfo dir = new DirectoryInfo(sourceDirName);

            if (!dir.Exists)
            {
                throw new DirectoryNotFoundException(
                    "Source directory does not exist or could not be found: "
                    + sourceDirName);
            }

            DirectoryInfo[] dirs = dir.GetDirectories();
            // If the destination directory doesn't exist, create it.
            if (!Directory.Exists(destDirName))
            {
                Directory.CreateDirectory(destDirName);
            }

            // Get the files in the directory and copy them to the new location.
            FileInfo[] files = dir.GetFiles();
            foreach (FileInfo file in files)
            {
                string temppath = Path.Combine(destDirName, file.Name);
                file.CopyTo(temppath, false);
            }

            // If copying subdirectories, copy them and their contents to new location.
            if (copySubDirs)
            {
                foreach (DirectoryInfo subdir in dirs)
                {
                    string temppath = Path.Combine(destDirName, subdir.Name);
                    DirectoryCopy(subdir.FullName, temppath, copySubDirs);
                }
            }
        }

        #endregion

        public static void SaveConfiguration()
        {
            ConfigManager.Instance.SaveConfigurationCommand.Execute(null);
        }


        static readonly string vixRenderConfigPath = @"C:\Program Files\VistA\Imaging\VIX.Config\Vix.Render.Config";

        private static void GetServer(out string server, out string database)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(vixRenderConfigPath);

            XmlNode xmlNode = doc.DocumentElement.ChildNodes[3].ChildNodes[0];
            server = xmlNode.Attributes["DataSource"].Value;
            database = xmlNode.Attributes["InitialCatalog"].Value;
        }

        private static void UpdateVixRenderConfig(string newpwd)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(vixRenderConfigPath);

            foreach (XmlNode xmlNode in doc.DocumentElement.ChildNodes[3].ChildNodes[0].ChildNodes[0].ChildNodes)
            {
                if (xmlNode.Attributes["Name"].Value.Equals("Password"))
                {
                    xmlNode.Attributes["IsEncrypted"].Value = "false";
                    xmlNode.Attributes["Value"].Value = newpwd;
                }
            }
            doc.Save(vixRenderConfigPath);

        }
    }
}
