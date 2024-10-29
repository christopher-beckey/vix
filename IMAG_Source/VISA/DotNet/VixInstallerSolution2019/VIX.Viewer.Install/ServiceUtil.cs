using System;
using System.Collections.Generic;
using System.Configuration.Install;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Management;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace Vix.Viewer.Install
{
    enum ServiceState
    {
        NotInstalled,
        Running,
        Stopped,
        Intermediate
    }

    enum VixService
    {
        Viewer,
        Render
    }

    class ServiceUtil
    {
        private static double DefaultWaitTimeoutInSeconds = 30.0;

        public static event Action<string> EventHandleError;

        private static void HandleError(string message)
        {
            if (EventHandleError != null)
                EventHandleError(message);
        }

        public static ServiceState GetServiceState(string serviceName)
        {
            if (ServiceController.GetServices().FirstOrDefault(x => (x.ServiceName == serviceName)) == null)
                return ServiceState.NotInstalled;

            var sc = new ServiceController(serviceName);
            return (sc.Status == ServiceControllerStatus.Stopped)? ServiceState.Stopped : 
                (sc.Status == ServiceControllerStatus.Running)? ServiceState.Running : ServiceState.Intermediate;
        }

        private static string GetServiceInstallPath(string serviceName)
        {
            WqlObjectQuery wqlObjectQuery = new WqlObjectQuery(string.Format("SELECT * FROM Win32_Service WHERE Name = '{0}'", serviceName));
            ManagementObjectSearcher managementObjectSearcher = new ManagementObjectSearcher(wqlObjectQuery);
            ManagementObjectCollection managementObjectCollection = managementObjectSearcher.Get();

            foreach (ManagementObject managementObject in managementObjectCollection)
            {
                return managementObject.GetPropertyValue("PathName").ToString();
            }

            return null;
        }

        public static void StartService(string serviceName)
        {
            try
            {
                var sc = new ServiceController(serviceName);
                if (sc.Status != ServiceControllerStatus.Stopped)
                {
                    try
                    {
                        sc.WaitForStatus(ServiceControllerStatus.Stopped, TimeSpan.FromSeconds(DefaultWaitTimeoutInSeconds));
                    }
                    catch (System.ServiceProcess.TimeoutException)
                    {
                        HandleError("Timed out waiting for the service to stop.");
                    }
                    catch (Exception ex)
                    {
                        HandleError("Error waiting for the service to stop. " + ex.ToString());
                    }
                }

                sc.Start();

                try
                {
                    sc.WaitForStatus(ServiceControllerStatus.Running, TimeSpan.FromSeconds(DefaultWaitTimeoutInSeconds));
                }
                catch (System.ServiceProcess.TimeoutException)
                {
                    HandleError("Timed out waiting for the service to run.");
                }
                catch (Exception ex)
                {
                    HandleError("Error waiting for the service to run. " + ex.ToString());
                }
            }
            catch (Exception ex)
            {
                HandleError("Error starting the service. " + ex.ToString());
            }
        }

        public static void StopService(string serviceName)
        {
            try
            {
                var sc = new ServiceController(serviceName);
                if (sc.Status != ServiceControllerStatus.Running)
                {
                    try
                    {
                        sc.WaitForStatus(ServiceControllerStatus.Running, TimeSpan.FromSeconds(DefaultWaitTimeoutInSeconds));
                    }
                    catch (System.ServiceProcess.TimeoutException)
                    {
                        HandleError("Timed out waiting for the service to run.");
                    }
                    catch (Exception ex)
                    {
                        HandleError("Error waiting for the service to run. " + ex.ToString());
                    }
                }

                sc.Stop();

                try
                {
                    sc.WaitForStatus(ServiceControllerStatus.Stopped, TimeSpan.FromSeconds(DefaultWaitTimeoutInSeconds));
                }
                catch (System.ServiceProcess.TimeoutException)
                {
                    HandleError("Timed out waiting for the service to stop.");
                }
                catch (Exception ex)
                {
                    HandleError("Error waiting for the service to stop. " + ex.ToString());
                }
            }
            catch (Exception ex)
            {
                HandleError("Error stopping the service. " + ex.ToString());
            }
        }

        public static void InstallService(string serviceFilePath)
        {
            RunProcess(serviceFilePath, "-install");
        }

        public static void UninstallService(string serviceName)
        {
            try
            {
                ServiceState serviceState = GetServiceState(serviceName);
                if (serviceState == ServiceState.NotInstalled)
                {
                    HandleError("Service not installed.");
                    return;
                }

                string serviceInstallPath = GetServiceInstallPath(serviceName);
                if (string.IsNullOrEmpty(serviceInstallPath))
                    throw new Exception("Error finding service install path");

                RunProcess(serviceInstallPath, "-uninstall");
            }
            catch (Exception ex)
            {
                HandleError("Error installing service. " + ex.ToString());
            }
        }

        private static void RunProcess(string fileName, string commandLine)
        {
            try
            {
                ProcessStartInfo startInfo = new ProcessStartInfo();
                startInfo.CreateNoWindow = true;
                startInfo.WindowStyle = ProcessWindowStyle.Hidden;
                startInfo.UseShellExecute = false;
                startInfo.RedirectStandardOutput = true;
                startInfo.RedirectStandardError = true;
                startInfo.FileName = fileName;
                startInfo.Arguments = commandLine;
                Process process = new Process();
                process.StartInfo = startInfo;
                process.OutputDataReceived += CaptureOutput;
                process.ErrorDataReceived += CaptureError;
                process.Start();
                process.BeginOutputReadLine();
                process.BeginErrorReadLine();
                process.WaitForExit();
            }
            catch (Exception ex)
            {
            }
        }

        static void CaptureOutput(object sender, DataReceivedEventArgs e)
        {
        }

        static void CaptureError(object sender, DataReceivedEventArgs e)
        {
        }
    }
}
