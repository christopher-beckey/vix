using System;
using System.Collections.Generic;
using System.Text;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public class ServiceUtilityException : ApplicationException
    {
        public ServiceUtilityException()
        {
        }
        
        public ServiceUtilityException(String message) : base(message)
        {
        }

        public ServiceUtilityException(String message, Exception ex) : base(message, ex)
        {
        }
    }
}
