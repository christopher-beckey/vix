using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    class VistAWorkerUri
    {
        private static int _PortCounter = 0;

        public static string Format(string processUid)
        {
            string serviceName = "VistAWorkerService";

            string baseAddress = VistAConfigurationSection.Instance.WorkerBaseAddress;
            if (VistAConfigurationSection.Instance.WorkerBaseAddress.Contains("net.tcp"))
            {
                int portNumber = VistAConfigurationSection.Instance.WorkerPoolStartingPort + Interlocked.Increment(ref _PortCounter);
                return string.Format("{0}:{1}/{2}", VistAConfigurationSection.Instance.WorkerBaseAddress.TrimEnd('/'), portNumber, serviceName);
            }
            else
            {
                return string.Format("{0}{1}_{2}",
                                     VistAConfigurationSection.Instance.WorkerBaseAddress,
                                     serviceName, processUid);
            }
        }
    }
}
