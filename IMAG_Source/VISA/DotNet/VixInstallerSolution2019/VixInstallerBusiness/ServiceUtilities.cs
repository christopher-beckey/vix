using System;
using System.Collections.Generic;
using System.Text;
using System.ServiceProcess;
using System.Diagnostics;
using System.ComponentModel; // for Win32Exception
using System.Runtime.InteropServices;
using log4net;
using System.Threading;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    [StructLayout(LayoutKind.Sequential)]
    public struct SERVICE_FAILURE_ACTIONS
    {
        public int dwResetPeriod;
        public string lpRebootMsg;
        public string lpCommand;
        public int cActions;
        public IntPtr lpsaActions;
    }

    public enum SC_ACTION_TYPE
    {
        None = 0,
        RestartService = 1,
        RebootComputer = 2,
        Run_Command = 3
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct SC_ACTION
    {
        public SC_ACTION_TYPE Type;
        public uint Delay;
    }

    public enum INFO_LEVEL : int
    {
        SERVICE_CONFIG_DESCRIPTION = 1,
        SERVICE_CONFIG_FAILURE_ACTIONS = 2,
        SERVICE_CONFIG_DELAYED_AUTO_START_INFO = 3,
        SERVICE_CONFIG_FAILURE_ACTIONS_FLAG = 4,
        SERVICE_CONFIG_SERVICE_SID_INFO = 5,
        SERVICE_CONFIG_REQUIRED_PRIVILEGES_INFO = 6,
        SERVICE_CONFIG_PRESHUTDOWN_INFO = 7
    }

    public static class ServiceUtilities
    {
        [DllImport("kernel32.dll")]
        private static extern int GetLastError();

        [DllImport("advapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        private static extern bool ChangeServiceConfig(SafeHandle hService, UInt32 nServiceType, UInt32 nStartType, UInt32 nErrorControl,
            String lpBinaryPathName, String lpLoadOrderGroup, IntPtr lpdwTagId, String lpDependencies, String lpServiceStartName,
            String lpPassword, String lpDisplayName);

        [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool ChangeServiceConfig2(
            SafeHandle hService,
            int dwInfoLevel,
            IntPtr lpInfo);

        private const uint SERVICE_NO_CHANGE = 0xffffffff;
        private const uint SERVICE_AUTO_START = 0x00000002;

        #region private methods
        /// <summary>
        /// Retrieve a logger for this class.
        /// </summary>
        /// <returns>A logger as a ILog interface.</returns>
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(ServiceUtilities).Name);
        }

        #endregion

        /// <summary>
        /// Configure a service to restart after failure.
        /// </summary>
        /// <param name="servicename"></param>
        public static void SetServiceFailureActions(String serviceName)
        {
            Debug.Assert(serviceName != null); // avoid ServiceController InvalidArgument exception
            Debug.Assert(ClusterFacade.IsServerClusterNode() == false); // HAC cluster nodes should not set recovery options.
            ServiceController sc = null;
            IntPtr lpsaActions = IntPtr.Zero;
            IntPtr lpInfo = IntPtr.Zero;
            try
            {
                sc = new ServiceController(serviceName);

                SC_ACTION action = new SC_ACTION();
                action.Type = SC_ACTION_TYPE.RestartService;
                action.Delay = (uint)TimeSpan.FromMinutes(1).TotalMilliseconds;

                lpsaActions = Marshal.AllocHGlobal(Marshal.SizeOf(action) * 3);
                if (lpsaActions == IntPtr.Zero)
                {
                    throw new Exception(String.Format("Unable to allocate memory for service action, error was: 0x{0:X}", Marshal.GetLastWin32Error()));
                }

                Marshal.StructureToPtr(action, lpsaActions, false);
                IntPtr nextAction = (IntPtr)(lpsaActions.ToInt64() + Marshal.SizeOf(action));
                Marshal.StructureToPtr(action, nextAction, false);
                nextAction = (IntPtr)(nextAction.ToInt64() + Marshal.SizeOf(action));
                Marshal.StructureToPtr(action, nextAction, false);

                SERVICE_FAILURE_ACTIONS failureActions = new SERVICE_FAILURE_ACTIONS();
                failureActions.dwResetPeriod = (int)TimeSpan.FromDays(1).TotalSeconds;
                failureActions.lpRebootMsg = null;
                failureActions.lpCommand = null;
                failureActions.cActions = 3;
                failureActions.lpsaActions = lpsaActions;

                lpInfo = Marshal.AllocHGlobal(Marshal.SizeOf(failureActions));
                if (lpInfo == IntPtr.Zero)
                {
                    throw new Exception(String.Format("Unable to allocate memory, error was: 0x{0:X}", Marshal.GetLastWin32Error()));
                }

                Marshal.StructureToPtr(failureActions, lpInfo, false);

                if (!ChangeServiceConfig2(sc.ServiceHandle, (int)INFO_LEVEL.SERVICE_CONFIG_FAILURE_ACTIONS, lpInfo))
                {
                    throw new Exception(String.Format("Error setting service config, error was: 0x{0:X}", Marshal.GetLastWin32Error()));
                }
            }
            catch (Win32Exception ex) // can occur while checking status or starting the service
            {
                throw new ServiceUtilityException("Error while setting Service failure actions.", ex.GetBaseException());
            }
            finally
            {
                if (sc != null)
                {
                    sc.Close();
                }
                if (lpInfo != IntPtr.Zero)
                {
                    Marshal.FreeHGlobal(lpInfo);
                }
                if (lpsaActions != IntPtr.Zero)
                {
                    Marshal.FreeHGlobal(lpsaActions);
                }
            }
        }

        /// <summary>
        /// Set the credentials of the user account that a service will execute under.
        /// </summary>
        /// <param name="serviceName">The service name to be configured.</param>
        /// <param name="userName">The username of the account the service should execute under.</param>
        /// <param name="password">The password of the account the service should execute under.</param>
        public static void SetServiceCredentials(String serviceName, String accountName, String password, bool isCluster)
        {
            Debug.Assert(serviceName != null); // avoid ServiceController InvalidArgument exception
            Debug.Assert(accountName != null);
            Debug.Assert(password != null);
            ServiceController sc = null;
            string fullyQualifiedAccountName = Environment.MachineName + @"\" + accountName;
            //if (accountName != null)
            //{
            //    fullyQualifiedAccountName = Environment.MachineName + @"\" + accountName;
            //}
            long winErrorCode = 0; //contains the last error

            try
            {
                sc = new ServiceController(serviceName);
                // Note: side effect - sets service to auto start
                // 5/18/09 - if running on a HAC then do not configure the service to automatically start
                bool success = ChangeServiceConfig(sc.ServiceHandle, SERVICE_NO_CHANGE,
                    (isCluster == true ? SERVICE_NO_CHANGE : SERVICE_AUTO_START),
                    SERVICE_NO_CHANGE,
                    null, null, IntPtr.Zero, null, fullyQualifiedAccountName, password, null);
                if (!success)
                {
                    winErrorCode = GetLastError();
                    throw new ServiceUtilityException("Changing Service Logon credentials for " + serviceName + " failed. WinErrorCode = " + winErrorCode.ToString());
                }
            }
            catch (Win32Exception ex) // can occur while checking status or starting the service
            {
                throw new ServiceUtilityException("Error while setting Service logon credentials.", ex.GetBaseException());
            }
            finally
            {
                if (sc != null)
                {
                    sc.Close();
                }
            }
        }

        /// <summary>
        /// Checks to see if a service if running on the local machine.
        /// </summary>
        /// <param name="serviceName">the name of the service to check</param>
        /// <returns>true if the service is running, false otherwise</returns>
        /// <exception cref="ServiceUtilityException">Can occur when checking service status</exception>
        public static ServiceControllerStatus GetLocalServiceStatus(String serviceName)
        {
            Debug.Assert(serviceName != null); // avoids ServiceController ArgumentException

            ServiceController sc = null;

            try
            {
                sc = new ServiceController(serviceName);
                return sc.Status;
            }
            catch (Win32Exception ex) // can occur while checking status or starting the service
            {
                throw new ServiceUtilityException("Error while getting Service status.", ex.GetBaseException());
            }
            finally
            {
                if (sc != null)
                {
                    sc.Close();
                }
            }
        }

        /// <summary>
        /// Return a list of installed non-driver windows services.
        /// </summary>
        /// <returns>a list of installed non-driver windows services</returns>
        public static string[] GetNonDriverServiceNames()
        {
            List<string> services = new List<string>();
            ServiceController[] serviceControllers = ServiceController.GetServices();
            foreach (ServiceController serviceController in serviceControllers)
            {
                services.Add(serviceController.ServiceName);
            }
            return services.ToArray();
        }

        /// <summary>
        /// Checks to see if a non driver service is installed.
        /// </summary>
        /// <param name="serviceName">the name of the service to look for</param>
        /// <returns>true if serviceName specifies an installed non-driver service, false otherwise</returns>
        public static bool IsNonDriverServiceInstalled(string serviceName)
        {
            bool isServiceInstalled = false;
            ServiceController[] serviceControllers = ServiceController.GetServices();
            foreach (ServiceController serviceController in serviceControllers)
            {
                if (serviceController.ServiceName == serviceName)
                {
                    isServiceInstalled = true;
                    break;
                }
            }
            return isServiceInstalled;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="serviceName"></param>
        /// <exception cref="ServiceUtilityException"></exception>
        public static void StartLocalService(String serviceName)
        {
            Debug.Assert(serviceName != null); // avoid ServiceController InvalidArgumenr exception
            ServiceController sc = null;

            try
            {
                sc = new ServiceController(serviceName);

                try
                {
                    if (sc.Status == ServiceControllerStatus.StopPending)
                    {
                        sc.WaitForStatus(ServiceControllerStatus.Stopped, new TimeSpan(0, 0, 10)); // wait 10 seconds
                    }

                }
                catch (System.ServiceProcess.TimeoutException)
                {
                    // service did not stop
                }
                sc.Refresh(); // maybe it did stop

                if (sc.Status != ServiceControllerStatus.Stopped)
                {
                    throw new ServiceUtilityException("Cannot start service becuase it is not stopped; Current state is " + sc.Status.ToString());
                }

                sc.Start();

            }
            catch (Win32Exception ex) // can occur while checking status or starting the service
            {
                throw new ServiceUtilityException(ex.GetBaseException().Message, ex.GetBaseException());
            }
            catch (InvalidOperationException ex)
            {
                throw new ServiceUtilityException(ex.GetBaseException().Message, ex.GetBaseException());
            }
            finally
            {
                if (sc != null)
                {
                    sc.Close();
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="serviceName"></param>
        /// <exception cref="ServiceUtilityException"></exception>
        public static void StopLocalService(String serviceName)
        {
            Debug.Assert(serviceName != null); // avoid ServiceController InvalidArgumenr exception
            ServiceController sc = null;

            try
            {
                sc = new ServiceController(serviceName);

                try
                {
                    if (sc.Status == ServiceControllerStatus.StartPending)
                    {
                        sc.WaitForStatus(ServiceControllerStatus.Running, new TimeSpan(0, 0, 10)); // wait 10 seconds
                    }

                }
                catch (System.ServiceProcess.TimeoutException)
                {
                    // service did not finish starting
                }
                sc.Refresh(); // maybe it did start after all

                if (sc.Status != ServiceControllerStatus.Running)
                {
                    throw new ServiceUtilityException("Cannot stop service becuase it is not running; Current state is " + sc.Status.ToString());
                }

                sc.Stop();

            }
            catch (Win32Exception ex) // can occur while checking status or starting the service
            {
                throw new ServiceUtilityException(ex.GetBaseException().Message, ex.GetBaseException());
            }
            catch (InvalidOperationException ex)
            {
                throw new ServiceUtilityException(ex.GetBaseException().Message, ex.GetBaseException());
            }
            finally
            {
                if (sc != null)
                {
                    sc.Close();
                }
            }
        }

        public static void CreateLocalService(string ServiceName, string FileSpec)
        {
            Process externalProcess = new System.Diagnostics.Process();
            try
            {
                //string workingDir = Path.Combine(manifest.PayloadPath, @"common\Misc");
                //string installerFilespec = null;
                externalProcess.StartInfo.FileName = "sc";
                externalProcess.StartInfo.Arguments = " create "+ ServiceName+ " binpath="+FileSpec;
                //externalProcess.StartInfo.WorkingDirectory = ;
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
    }
}
