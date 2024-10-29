using Hydra.Common.Exceptions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class TokenExpiredException : Exception
    {
        public static int HttpStatusCode { get { return 600; } }
    }

    public class VixTimeoutException : Exception
    {
        public static int HttpStatusCode { get { return (int) System.Net.HttpStatusCode.GatewayTimeout; } }
    }
}
