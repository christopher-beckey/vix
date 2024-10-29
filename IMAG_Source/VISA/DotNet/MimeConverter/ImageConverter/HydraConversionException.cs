using System;
using System.Runtime.Serialization;

namespace ImageConverter
{
    [Serializable]
    internal class HydraConversionException : Exception
    {
        public HydraConversionException()
        {
        }

        public HydraConversionException(string message) : base(message)
        {
        }

        public HydraConversionException(string message, Exception innerException) : base(message, innerException)
        {
        }

        protected HydraConversionException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}