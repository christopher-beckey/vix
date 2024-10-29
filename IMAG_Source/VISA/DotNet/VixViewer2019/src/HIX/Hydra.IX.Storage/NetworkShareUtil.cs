using System;
using System.Runtime.InteropServices;

namespace Hydra.IX.Storage
{
    public class NetworkShareUtil
    {
        private static int MapDrive(string localName, string shareName, string username, string password)
        {
            NETRESOURCE myResource = new NETRESOURCE();
            myResource.dwScope = ResourceScope.RESOURCE_GLOBALNET;// 2;
            myResource.dwType = ResourceType.RESOURCETYPE_ANY;// 1;
            myResource.dwDisplayType = ResourceDisplayType.RESOURCEDISPLAYTYPE_SHARE;// 3;
            myResource.lpLocalName = localName;
            myResource.lpRemoteName = shareName;
            myResource.dwUsage = 0;
            myResource.lpComment = null;
            myResource.lpProvider = null;
            int returnValue = WNetAddConnection2(myResource, password, username, 0);
            return returnValue;
        }

        public static int MapShare(string shareName, string username, string password, string domain)
        {
            return MapDrive(null, shareName, string.Format(@"{0}\{1}", domain, username), password);
        }

        public static int DisconnectShare(string shareName)
        {
            int result = WNetCancelConnection2(shareName, CONNECT_UPDATE_PROFILE, true);
            return result;
        }

        public static int DisconnectMappedDrive(string localName)
        {
            int result = WNetCancelConnection2(localName, CONNECT_UPDATE_PROFILE, true);
            return result;
        }

        public static string GetErrorMsg(int errorCode)
        {
            string msg = new System.ComponentModel.Win32Exception(errorCode).Message;
            return msg;
        }
        // ReSharper disable InconsistentNaming
        public enum ResourceScope
        {

            RESOURCE_CONNECTED = 1,

            RESOURCE_GLOBALNET,
            RESOURCE_REMEMBERED,
            RESOURCE_RECENT,
            RESOURCE_CONTEXT
        };

        public enum ResourceType
        {
            RESOURCETYPE_ANY,
            RESOURCETYPE_DISK,
            RESOURCETYPE_PRINT,
            RESOURCETYPE_RESERVED
        };

        public enum ResourceUsage
        {
            RESOURCEUSAGE_CONNECTABLE = 0x00000001,
            RESOURCEUSAGE_CONTAINER = 0x00000002,
            RESOURCEUSAGE_NOLOCALDEVICE = 0x00000004,
            RESOURCEUSAGE_SIBLING = 0x00000008,
            RESOURCEUSAGE_ATTACHED = 0x00000010,
            RESOURCEUSAGE_ALL = (RESOURCEUSAGE_CONNECTABLE | RESOURCEUSAGE_CONTAINER | RESOURCEUSAGE_ATTACHED),
        };

        public enum ResourceDisplayType
        {
            RESOURCEDISPLAYTYPE_GENERIC,
            RESOURCEDISPLAYTYPE_DOMAIN,
            RESOURCEDISPLAYTYPE_SERVER,
            RESOURCEDISPLAYTYPE_SHARE,
            RESOURCEDISPLAYTYPE_FILE,
            RESOURCEDISPLAYTYPE_GROUP,
            RESOURCEDISPLAYTYPE_NETWORK,
            RESOURCEDISPLAYTYPE_ROOT,
            RESOURCEDISPLAYTYPE_SHAREADMIN,
            RESOURCEDISPLAYTYPE_DIRECTORY,
            RESOURCEDISPLAYTYPE_TREE,
            RESOURCEDISPLAYTYPE_NDSCONTAINER
        };

        [StructLayout(LayoutKind.Sequential)]
        public class NETRESOURCE
        {
            public ResourceScope dwScope = 0;
            public ResourceType dwType = 0;
            public ResourceDisplayType dwDisplayType = 0;
            public ResourceUsage dwUsage = 0;
            public string lpLocalName = null;
            public string lpRemoteName = null;
            public string lpComment = null;
            public string lpProvider = null;
        };

        [DllImport("mpr.dll")]
        public static extern int WNetAddConnection2(ref NETRESOURCE netResource,
           string password, string username, int flags);

        // This must be used if NETRESOURCE is defined as a class
        [DllImport("mpr.dll")]
        public static extern int WNetAddConnection2(NETRESOURCE netResource,
           string password, string username, int flags);

        [DllImport("mpr.dll")]
        public static extern int WNetCancelConnection2(string lpName, Int32 dwFlags, bool fForce);
        private const int CONNECT_UPDATE_PROFILE = 0x1;
        //private const int NO_ERROR = 0;

        // ReSharper restore InconsistentNaming
    }
}
