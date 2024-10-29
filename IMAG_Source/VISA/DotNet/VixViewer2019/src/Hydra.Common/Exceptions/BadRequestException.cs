using System;
using System.Net;

namespace Hydra.Common.Exceptions
{
    public class BadRequestException : Exception
    {
        public BadRequestException(string format, params object[] args)
            : base(string.Format(format, args))
        {
        }
    }

    public class HydraWebException : Exception
    {
        public HttpStatusCode HttpStatusCode { get; private set; }

        public HydraWebException(HttpStatusCode statusCode, string format, params object[] args)
            : base(string.Format(format, args))
        {
            HttpStatusCode = statusCode;
        }
    }
}