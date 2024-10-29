using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public static class HttpRequestExtensions
    {
        private static string TimeoutPropertyKey = "RequestTimeout";

        public static void SetTimeout(this HttpRequestMessage request,
            TimeSpan? timeout)
        {
            if (request == null)
                throw new ArgumentNullException("request");

            request.Properties[TimeoutPropertyKey] = timeout;
        }

        public static TimeSpan? GetTimeout(this HttpRequestMessage request)
        {
            if (request == null)
                throw new ArgumentNullException("request");
 
            object value = null;
            if (request.Properties.TryGetValue(TimeoutPropertyKey, out value)
                && value is TimeSpan)
            {
                return (TimeSpan) value;
            }

            return null;
        }
    }
}
