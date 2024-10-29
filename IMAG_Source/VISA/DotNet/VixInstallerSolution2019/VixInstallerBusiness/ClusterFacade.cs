using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Microsoft.Win32;
using System.Diagnostics;


namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public static class ClusterFacade
    {
        private static readonly string CLUSTER_SERVICE_NAME = "ClusSvc";

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static bool IsServerClusterNode()
        {
            bool isCluster = false;
            if (BusinessFacade.IsWindowsServer2003() || BusinessFacade.IsWindowsServer2008())
            {
                string key = @"Cluster";
                isCluster = RegistryUtilities.DoesRegKeyExist(key);
            }
            return isCluster;
        }


        public static bool IsServerClusterServiceRunning()
        {
            bool isRunning = false;
            System.ServiceProcess.ServiceControllerStatus status = ServiceUtilities.GetLocalServiceStatus(ClusterFacade.CLUSTER_SERVICE_NAME);
            if (status == System.ServiceProcess.ServiceControllerStatus.Running)
            {
                isRunning = true;
            }
            return isRunning;
        }


        /// <summary>
        /// Per Ron Paulin, we dont need any special handling to filter out the QUORUM logical drive. Keeping the code around just in case.
        /// </summary>
        /// <param name="drive">The drive to test.</param>
        /// <returns>true if the passed drive is the QUORUM drive, false otherwise</returns>
        public static bool IsClusterQuorumDrive(DriveInfo drive)
        {
            bool isClusterQuorumDrive = false;
            string key = @"Cluster\Quorum";
            RegistryView regView = RegistryView.Registry64;
            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
            {
                using (RegistryKey quorum = regKey.OpenSubKey(key, false))
                {
                    if (quorum != null)
                    {
                        string path = quorum.GetValue("Path").ToString();
                        Debug.Assert(path != null);
                        string pathRoot = Path.GetPathRoot(path).ToUpper();
                        if (drive.Name.ToUpper() == pathRoot)
                        {
                            isClusterQuorumDrive = true;
                        }
                    }
                }
            }
            return isClusterQuorumDrive;
        }
    }
}
