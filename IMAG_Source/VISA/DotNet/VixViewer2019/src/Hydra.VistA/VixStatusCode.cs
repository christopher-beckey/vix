using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class VixStatusCode
    {
        private static string ToString(HttpStatusCode code)
        {
            return ((int) code).ToString();
        }

        public static readonly string OK = ToString(HttpStatusCode.OK);
        public static readonly string NoContent = ToString(HttpStatusCode.NoContent);
        public static readonly string Error = ToString(HttpStatusCode.InternalServerError);
        public static readonly string GatewayTimeout = ToString(HttpStatusCode.GatewayTimeout);
        public static readonly string ServiceUnavailable = ToString(HttpStatusCode.ServiceUnavailable);
    }
}
