using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.Diagnostics;
using log4net;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{

#region interop_data
    [Flags]
    public enum SERVICE_TYPES : int
    {
        SERVICE_KERNEL_DRIVER = 0x00000001,
        SERVICE_FILE_SYSTEM_DRIVER = 0x00000002,
        SERVICE_ADAPTER = 0x00000004,
        SERVICE_RECOGNIZER_DRIVER = 0x00000008,
        SERVICE_DRIVER = SERVICE_KERNEL_DRIVER |
            SERVICE_FILE_SYSTEM_DRIVER |
            SERVICE_RECOGNIZER_DRIVER,

        SERVICE_WIN32_OWN_PROCESS = 0x00000010,
        SERVICE_WIN32_SHARE_PROCESS = 0x00000020,
        SERVICE_WIN32 = SERVICE_WIN32_OWN_PROCESS |
            SERVICE_WIN32_SHARE_PROCESS,
    }

    [Flags]
    enum ACCESS_MASK : uint
    {
        DELETE = 0x00010000,
        READ_CONTROL = 0x00020000,
        WRITE_DAC = 0x00040000,
        WRITE_OWNER = 0x00080000,
        SYNCHRONIZE = 0x00100000,

        STANDARD_RIGHTS_REQUIRED = 0x000f0000,

        STANDARD_RIGHTS_READ = 0x00020000,
        STANDARD_RIGHTS_WRITE = 0x00020000,
        STANDARD_RIGHTS_EXECUTE = 0x00020000,

        STANDARD_RIGHTS_ALL = 0x001f0000,

        SPECIFIC_RIGHTS_ALL = 0x0000ffff,

        ACCESS_SYSTEM_SECURITY = 0x01000000,

        MAXIMUM_ALLOWED = 0x02000000,

        GENERIC_READ = 0x80000000,
        GENERIC_WRITE = 0x40000000,
        GENERIC_EXECUTE = 0x20000000,
        GENERIC_ALL = 0x10000000,

        DESKTOP_READOBJECTS = 0x00000001,
        DESKTOP_CREATEWINDOW = 0x00000002,
        DESKTOP_CREATEMENU = 0x00000004,
        DESKTOP_HOOKCONTROL = 0x00000008,
        DESKTOP_JOURNALRECORD = 0x00000010,
        DESKTOP_JOURNALPLAYBACK = 0x00000020,
        DESKTOP_ENUMERATE = 0x00000040,
        DESKTOP_WRITEOBJECTS = 0x00000080,
        DESKTOP_SWITCHDESKTOP = 0x00000100,

        WINSTA_ENUMDESKTOPS = 0x00000001,
        WINSTA_READATTRIBUTES = 0x00000002,
        WINSTA_ACCESSCLIPBOARD = 0x00000004,
        WINSTA_CREATEDESKTOP = 0x00000008,
        WINSTA_WRITEATTRIBUTES = 0x00000010,
        WINSTA_ACCESSGLOBALATOMS = 0x00000020,
        WINSTA_EXITWINDOWS = 0x00000040,
        WINSTA_ENUMERATE = 0x00000100,
        WINSTA_READSCREEN = 0x00000200,

        WINSTA_ALL_ACCESS = 0x0000037f
    }

    public enum SERVICE_STATE : uint
    {
        SERVICE_STOPPED = 0x00000001,
        SERVICE_START_PENDING = 0x00000002,
        SERVICE_STOP_PENDING = 0x00000003,
        SERVICE_RUNNING = 0x00000004,
        SERVICE_CONTINUE_PENDING = 0x00000005,
        SERVICE_PAUSE_PENDING = 0x00000006,
        SERVICE_PAUSED = 0x00000007
    }

    [Flags]
    public enum SCM_ACCESS : uint
    {
        /// <summary>
        /// Required to connect to the service control manager.
        /// </summary>
        SC_MANAGER_CONNECT = 0x00001,

        /// <summary>
        /// Required to call the CreateService function to create a service
        /// object and add it to the database.
        /// </summary>
        SC_MANAGER_CREATE_SERVICE = 0x00002,

        /// <summary>
        /// Required to call the EnumServicesStatusEx function to list the
        /// services that are in the database.
        /// </summary>
        SC_MANAGER_ENUMERATE_SERVICE = 0x00004,

        /// <summary>
        /// Required to call the LockServiceDatabase function to acquire a
        /// lock on the database.
        /// </summary>
        SC_MANAGER_LOCK = 0x00008,

        /// <summary>
        /// Required to call the QueryServiceLockStatus function to retrieve
        /// the lock status information for the database.
        /// </summary>
        SC_MANAGER_QUERY_LOCK_STATUS = 0x00010,

        /// <summary>
        /// Required to call the NotifyBootConfigStatus function.
        /// </summary>
        SC_MANAGER_MODIFY_BOOT_CONFIG = 0x00020,

        /// <summary>
        /// Includes STANDARD_RIGHTS_REQUIRED, in addition to all access
        /// rights in this table.
        /// </summary>
        SC_MANAGER_ALL_ACCESS = ACCESS_MASK.STANDARD_RIGHTS_REQUIRED |
            SC_MANAGER_CONNECT |
            SC_MANAGER_CREATE_SERVICE |
            SC_MANAGER_ENUMERATE_SERVICE |
            SC_MANAGER_LOCK |
            SC_MANAGER_QUERY_LOCK_STATUS |
            SC_MANAGER_MODIFY_BOOT_CONFIG,

        GENERIC_READ = ACCESS_MASK.STANDARD_RIGHTS_READ |
            SC_MANAGER_ENUMERATE_SERVICE |
            SC_MANAGER_QUERY_LOCK_STATUS,

        GENERIC_WRITE = ACCESS_MASK.STANDARD_RIGHTS_WRITE |
            SC_MANAGER_CREATE_SERVICE |
            SC_MANAGER_MODIFY_BOOT_CONFIG,

        GENERIC_EXECUTE = ACCESS_MASK.STANDARD_RIGHTS_EXECUTE |
            SC_MANAGER_CONNECT | SC_MANAGER_LOCK,

        GENERIC_ALL = SC_MANAGER_ALL_ACCESS,
    }

    [Flags]
    public enum SERVICE_ACCESS : uint
    {
        STANDARD_RIGHTS_REQUIRED = 0xF0000,
        SERVICE_QUERY_CONFIG = 0x00001,
        SERVICE_CHANGE_CONFIG = 0x00002,
        SERVICE_QUERY_STATUS = 0x00004,
        SERVICE_ENUMERATE_DEPENDENTS = 0x00008,
        SERVICE_START = 0x00010,
        SERVICE_STOP = 0x00020,
        SERVICE_PAUSE_CONTINUE = 0x00040,
        SERVICE_INTERROGATE = 0x00080,
        SERVICE_USER_DEFINED_CONTROL = 0x00100,
        SERVICE_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED |
                          SERVICE_QUERY_CONFIG |
                          SERVICE_CHANGE_CONFIG |
                          SERVICE_QUERY_STATUS |
                          SERVICE_ENUMERATE_DEPENDENTS |
                          SERVICE_START |
                          SERVICE_STOP |
                          SERVICE_PAUSE_CONTINUE |
                          SERVICE_INTERROGATE |
                          SERVICE_USER_DEFINED_CONTROL)
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct SERVICE_STATUS
    {
        public static readonly int SizeOf = Marshal.SizeOf(typeof(SERVICE_STATUS));
        public SERVICE_TYPES dwServiceType;
        public SERVICE_STATE dwCurrentState;
        public uint dwControlsAccepted;
        public uint dwWin32ExitCode;
        public uint dwServiceSpecificExitCode;
        public uint dwCheckPoint;
        public uint dwWaitHint;
    }

    [Flags]
    public enum SERVICE_CONTROL : uint
    {
        STOP = 0x00000001,
        PAUSE = 0x00000002,
        CONTINUE = 0x00000003,
        INTERROGATE = 0x00000004,
        SHUTDOWN = 0x00000005,
        PARAMCHANGE = 0x00000006,
        NETBINDADD = 0x00000007,
        NETBINDREMOVE = 0x00000008,
        NETBINDENABLE = 0x00000009,
        NETBINDDISABLE = 0x0000000A,
        DEVICEEVENT = 0x0000000B,
        HARDWAREPROFILECHANGE = 0x0000000C,
        POWEREVENT = 0x0000000D,
        SESSIONCHANGE = 0x0000000E
    }

#endregion

    public static class Win32ServiceUtilities
    {
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(Win32ServiceUtilities).Name);
        }

        #region interop_methods
        [DllImport("advapi32.dll", EntryPoint = "OpenSCManagerW", ExactSpelling = true, CharSet = CharSet.Unicode, SetLastError = true)]
        public static extern IntPtr OpenSCManager(string machineName, string databaseName, uint dwAccess);

        [DllImport("advapi32.dll", EntryPoint = "QueryServiceStatus", CharSet = CharSet.Auto, SetLastError = true)] // added SetLastError
        public static extern bool QueryServiceStatus(IntPtr hService, ref SERVICE_STATUS dwServiceStatus);

        [DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        static extern IntPtr OpenService(IntPtr hSCManager, string lpServiceName, uint dwDesiredAccess);

        [DllImport("advapi32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CloseServiceHandle(IntPtr hSCObject);

        [DllImport("advapi32", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool StartService(IntPtr hService, int dwNumServiceArgs, string[] lpServiceArgVectors);

        [DllImport("advapi32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool ControlService(IntPtr hService, SERVICE_CONTROL dwControl, ref SERVICE_STATUS lpServiceStatus);
        #endregion interop_methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="serviceName"></param>
        /// <returns></returns>
        public static bool IsLocalServiceRunning(String serviceName)
        {
            Debug.Assert(serviceName != null);

            bool serviceRunning = false;
            IntPtr scm = IntPtr.Zero;
            IntPtr service = IntPtr.Zero;

            try
            {
                scm = OpenSCManager(null, null, (uint)SCM_ACCESS.SC_MANAGER_ALL_ACCESS);
                if (scm == IntPtr.Zero)
                {
                    // TODO: better exception
                    int win32ErrorCode = Marshal.GetLastWin32Error();
                    throw new Exception("Error: cannot open the Service Control Mananger; the Win32 error code is " + win32ErrorCode.ToString());
                }
                service = OpenService(scm, serviceName, (uint)SERVICE_ACCESS.SERVICE_ALL_ACCESS);
                if (service == IntPtr.Zero)
                {
                    // TODO: better exception
                    int win32ErrorCode = Marshal.GetLastWin32Error();
                    throw new Exception("Error: cannot open Service " + serviceName + "; the Win32 error code is " + win32ErrorCode.ToString());
                }

                SERVICE_STATUS status = new SERVICE_STATUS();
                if (QueryServiceStatus(service, ref status) == false)
                {
                    // TODO: better exception
                    int win32ErrorCode = Marshal.GetLastWin32Error();
                    throw new Exception("Error: cannot query status of Service " + serviceName + "; the Win32 error code is " + win32ErrorCode.ToString());
                }

                // TODO: simplistic test - handle the other states
                if (status.dwCurrentState != SERVICE_STATE.SERVICE_STOPPED)
                {
                    serviceRunning = true;
                }
            }
            finally
            {
                if (service != IntPtr.Zero)
                {
                    CloseServiceHandle(service);
                }

                if (scm != IntPtr.Zero)
                {
                    CloseServiceHandle(scm);
                }
            }

            return serviceRunning;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="serviceName"></param>
        public static void StartLocalService(String serviceName)
        {
            IntPtr scm = IntPtr.Zero;
            IntPtr service = IntPtr.Zero;

            try
            {
                scm = OpenSCManager(null, null, (uint)SCM_ACCESS.SC_MANAGER_ALL_ACCESS);
                if (scm == IntPtr.Zero)
                {
                    // TODO: better exception
                    int win32ErrorCode = Marshal.GetLastWin32Error();
                    throw new Exception("Error: cannot open the Service Control Mananger; the Win32 error code is " + win32ErrorCode.ToString());
                }
                service = OpenService(scm, serviceName, (uint)SERVICE_ACCESS.SERVICE_ALL_ACCESS);
                if (service == IntPtr.Zero)
                {
                    // TODO: better exception
                    int win32ErrorCode = Marshal.GetLastWin32Error();
                    throw new Exception("Error: cannot open Service " + serviceName + "; the Win32 error code is " + win32ErrorCode.ToString());
                }

                SERVICE_STATUS status = new SERVICE_STATUS();
                if (QueryServiceStatus(service, ref status) == false)
                {
                    // TODO: better exception
                    int win32ErrorCode = Marshal.GetLastWin32Error();
                    throw new Exception("Error: cannot query status of Service " + serviceName + "; the Win32 error code is " + win32ErrorCode.ToString());
                }

                // Don't try and start the service if it isn't stopped
                if (status.dwCurrentState != SERVICE_STATE.SERVICE_STOPPED)
                {
                    throw new Exception("Error: cannot start service " + serviceName + "because the service is not in a SERVICE_STOPPED state; current state is " + status.dwCurrentState.ToString());
                }

                if (StartService(service, 0, null) == false)
                {
                    int win32ErrorCode = Marshal.GetLastWin32Error();
                    throw new Exception("Error: cannot start service " + serviceName + "; the Win32 error code is " + win32ErrorCode.ToString());
                }
            }
            finally
            {
                if (service != IntPtr.Zero)
                {
                    CloseServiceHandle(service);
                }

                if (scm != IntPtr.Zero)
                {
                    CloseServiceHandle(scm);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="serviceName"></param>
        public static void StopLocalService(String serviceName)
        {
            IntPtr scm = IntPtr.Zero;
            IntPtr service = IntPtr.Zero;

            try
            {
                scm = OpenSCManager(null, null, (uint)SCM_ACCESS.SC_MANAGER_ALL_ACCESS);
                if (scm == IntPtr.Zero)
                {
                    // TODO: better exception
                    int win32ErrorCode = Marshal.GetLastWin32Error();
                    throw new Exception("Error: cannot open the Service Control Mananger; the Win32 error code is " + win32ErrorCode.ToString());
                }
                service = OpenService(scm, serviceName, (uint)SERVICE_ACCESS.SERVICE_ALL_ACCESS);
                if (service == IntPtr.Zero)
                {
                    // TODO: better exception
                    int win32ErrorCode = Marshal.GetLastWin32Error();
                    throw new Exception("Error: cannot open Service " + serviceName + "; the Win32 error code is " + win32ErrorCode.ToString());
                }

                SERVICE_STATUS status = new SERVICE_STATUS();
                if (QueryServiceStatus(service, ref status) == false)
                {
                    // TODO: better exception
                    int win32ErrorCode = Marshal.GetLastWin32Error();
                    throw new Exception("Error: cannot query status of Service " + serviceName + "; the Win32 error code is " + win32ErrorCode.ToString());
                }

                // Don't try and start the service if it isn't stopped
                if (status.dwCurrentState != SERVICE_STATE.SERVICE_RUNNING)
                {
                    throw new Exception("Error: cannot stop service " + serviceName + "because the service is not in a SERVICE_RUNNING state; current state is " + status.dwCurrentState.ToString());
                }

                if (ControlService(service, SERVICE_CONTROL.STOP, ref status) == false)
                {
                    int win32ErrorCode = Marshal.GetLastWin32Error();
                    throw new Exception("Error: cannot stop service " + serviceName + "; the Win32 error code is " + win32ErrorCode.ToString());
                }
            }
            finally
            {
                if (service != IntPtr.Zero)
                {
                    CloseServiceHandle(service);
                }

                if (scm != IntPtr.Zero)
                {
                    CloseServiceHandle(scm);
                }
            }
        }
    }
}
