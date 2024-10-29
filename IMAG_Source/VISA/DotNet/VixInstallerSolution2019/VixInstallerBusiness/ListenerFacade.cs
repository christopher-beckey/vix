using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Diagnostics;
using System.ServiceProcess;
using log4net;
using System.IO;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public static class ListenerFacade
    {
        public static VixManifest Manifest { get; set; }
        public static InfoDelegate InfoDelegate { get; set; }
        public static AppEventsDelegate AppEventsDelegate { get; set; }
        public static string ListenerPayloadFilespec { get { return Manifest.ActiveListenerPrerequisite.PayloadFilespec; } }
        public static string ListenerInstallPath { get { return Manifest.ActiveListenerPrerequisite.InstallPath; } }
        public static string ListenerExe { get { return Path.Combine(Manifest.ActiveListenerPrerequisite.InstallPath, @"ListenerTool.exe"); } }
        public static string LISTENER_SERVICE_NAME { get { return @"ListenerTool"; } }

        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(ListenerFacade).Name);
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
        
        public static string GetDeprecatedListenerVersion()
        {
            string version = null;
            ListenerPrerequisite prerequisite = GetInstalledDeprecatedListenerPrerequsite();
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
        
        public static bool IsListenerInstalled()
        {
            bool isInstalled = false;

            if (Directory.Exists(ListenerFacade.ListenerInstallPath))
            {
                isInstalled = true;
            }
            return isInstalled;
        }
 
        public static bool IsDeprecatedListenerInstalled()
        {
            bool isInstalled = false;
              
            try
            {
                if (IsListenerInstalled())
                {
                    string installedVersion = GetInstalledListenerVersion();
                    if (installedVersion != Manifest.ActiveListenerPrerequisite.Version)
                    {
                        isInstalled = true;
                    }
                }
                else
                {
                    isInstalled = false; // nothing is installed - safety net
                }
            }
            catch (Exception)
            {
                isInstalled = false; 
            }

            return isInstalled;

        }
        
        public static bool InstallListener()
        {
            ZipUtilities.ImprovedExtractToDirectory(ListenerFacade.ListenerPayloadFilespec, ListenerFacade.ListenerInstallPath, ZipUtilities.Overwrite.Always);
            return IsListenerInstalled();
        }
    
        public static bool UninstallListener()
        {
            try
            {
                string listenerRoot = ListenerFacade.ListenerInstallPath;
                if (!Directory.Exists(listenerRoot))
                {
                    Info("Cannot remove existing Listener installation - (directory: " + listenerRoot + " not found)");
                    listenerRoot = null;
                }

                if (listenerRoot != null)
                {
                    Directory.Delete(listenerRoot, true);
                }
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public static bool CreateListenerWindowsService()
        {
            string exePath = ListenerFacade.ListenerExe;

            System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
            externalProcess.StartInfo.FileName = exePath;
            externalProcess.StartInfo.Arguments = " -i";
            externalProcess.StartInfo.UseShellExecute = false;
            externalProcess.StartInfo.CreateNoWindow = true;
            externalProcess.Start();
            do
            {
                Thread.Sleep(500);
                externalProcess.Refresh();
            } while (!externalProcess.HasExited);


            return true;
        }

        public static void ChangeListenerServiceType()
        {
            System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
            try
            {
                externalProcess.StartInfo.FileName = "cmd.exe";
                externalProcess.StartInfo.Arguments = string.Format("/C sc {0} {1} {2}", "config", "ListenerTool", "start=demand");
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.CreateNoWindow = true;
                externalProcess.Start();
                do
                {
                    Thread.Sleep(500);
                    externalProcess.Refresh();
                } while (!externalProcess.HasExited);
            }
            catch (Exception ex)
            {
                Logger().Error("Exception while setting ListenerTool to manual startup: " + ex.Message);
            }
        }

        public static bool StartListenerService()
        {
            Info("Starting Listener Tool service.");
            ServiceControllerStatus status = ServiceUtilities.GetLocalServiceStatus(ListenerFacade.LISTENER_SERVICE_NAME);

            if (status != ServiceControllerStatus.Running)
            {
                ServiceUtilities.StartLocalService(ListenerFacade.LISTENER_SERVICE_NAME);
                do
                {
                    DoEvents();
                    Thread.Sleep(500);
                    status = ServiceUtilities.GetLocalServiceStatus(ListenerFacade.LISTENER_SERVICE_NAME);
                }
                while (status == System.ServiceProcess.ServiceControllerStatus.StartPending);
                status = ServiceUtilities.GetLocalServiceStatus(ListenerFacade.LISTENER_SERVICE_NAME);
                Info("The Listener Tool service is " + status.ToString("g"));
                if (status != ServiceControllerStatus.Running)
                {
                    return false;
                }
            }

            return true;
        }

        public static bool StopListenerService()
        {
            Info("Stopping Listener Tool service.");
            // attempt to stop the service
            try
            {
                ServiceControllerStatus status = ServiceUtilities.GetLocalServiceStatus(ListenerFacade.LISTENER_SERVICE_NAME);
                if (status == ServiceControllerStatus.Running)
                {
                    ServiceUtilities.StopLocalService(ListenerFacade.LISTENER_SERVICE_NAME);
                    do
                    {
                        DoEvents();
                        Thread.Sleep(500);
                        status = ServiceUtilities.GetLocalServiceStatus(ListenerFacade.LISTENER_SERVICE_NAME);
                    }
                    while (status == System.ServiceProcess.ServiceControllerStatus.StopPending);
                    status = ServiceUtilities.GetLocalServiceStatus(ListenerFacade.LISTENER_SERVICE_NAME);
                    Info("The Listener Tool service is " + status.ToString("g"));
                    if (status != ServiceControllerStatus.Stopped)
                    {
                        return false;
                    }
                }
            }
            catch
            {
                //continue
                Info("Continuing after attemping Listener Tool service stop.");
            }

            return true;
        }

        public static bool DestroyListenerWindowsService()
        {
            try
            {
                string exePath = ListenerFacade.ListenerExe;

                System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                externalProcess.StartInfo.FileName = exePath;
                externalProcess.StartInfo.Arguments = " -u";
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.CreateNoWindow = true;
                externalProcess.Start();
                do
                {
                    Thread.Sleep(500);
                    externalProcess.Refresh();
                } while (!externalProcess.HasExited);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }



        #region Private methods

        private static string GetInstalledListenerVersion()
        {
            string version = null;
            FileVersionInfo versInfo = FileVersionInfo.GetVersionInfo(ListenerFacade.ListenerExe);
            version = versInfo.FileVersion;

            return version;
        }

        private static bool IsPrerequisiteInstalled(ListenerPrerequisite prerequisite)
        {
            bool isInstalled = false;
            string installedVersion = GetInstalledListenerVersion().ToLower();
            
            if (installedVersion != null && installedVersion == prerequisite.Version)
            {
                isInstalled = true;
            }

            return isInstalled;
        }

        private static ListenerPrerequisite GetInstalledDeprecatedListenerPrerequsite()
        {
            Debug.Assert(IsListenerInstalled() == true);
            string installedListenerVersion = GetInstalledListenerVersion();
            ListenerPrerequisite listenerPrerequisite = null;

            foreach (ListenerPrerequisite prerequisite in Manifest.DeprecatedListenerPrerequisites)
            {
                if (IsPrerequisiteInstalled(prerequisite))
                {
                    listenerPrerequisite = prerequisite;
                    break;
                }
            }
            return listenerPrerequisite;
        }

        #endregion
    }
}
