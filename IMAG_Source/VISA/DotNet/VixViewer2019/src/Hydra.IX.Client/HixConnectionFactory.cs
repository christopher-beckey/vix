using Hydra.IX.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Client
{
    public static class HixConnectionFactory
    {
        public static string HixUrl { get; set; }
        public static IHixAuthentication HixAuthentication { get; set; }
        public static HixConnection Create()
        {
            if (string.IsNullOrEmpty(HixUrl))
                throw new InvalidOperationException("Hix Url is not valid");

            return new HixConnection(HixUrl, HixAuthentication);
        }

        public static HixConnection Create(string hixUrl, IHixAuthentication hixAuthentication = null)
        {
            if (string.IsNullOrEmpty(hixUrl))
                throw new InvalidOperationException("Hix Url is not valid");

            return new HixConnection(hixUrl, hixAuthentication);
        }
    }
}
