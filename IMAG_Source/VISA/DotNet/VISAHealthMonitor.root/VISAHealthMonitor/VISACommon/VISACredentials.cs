using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;

namespace VISACommon
{
    public class VISACredentials
    {
        public static string VISAUsername
        {
            get { return "vixlog"; }
        }

        public static string VISAPassword
        {
            get { return "tachik0ma"; }
        }

        public static NetworkCredential GetVISANetworkCredentials()
        {
            return new NetworkCredential(VISAUsername, VISAPassword);
        }
    }
}
