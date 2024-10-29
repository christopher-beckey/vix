using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Core.Remote
{
    class HixWorkerUri
    {
        public static string BaseAddress
        {
            get
            {
                return "net.pipe://localhost/";
            }
        }

        public static string FormatUri(string processUid)
        {
            return string.Format("{0}{1}", HixWorkerUri.BaseAddress, HixWorkerUri.FormatServiceName(processUid));
        }

        private static string FormatServiceName(string processUid)
        {
            return string.Format("HixWorkerService_{0}", processUid);
        }
    }
}
