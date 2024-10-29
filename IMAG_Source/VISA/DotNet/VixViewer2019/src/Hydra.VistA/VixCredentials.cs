using System;

namespace Hydra.VistA
{
    public class VixCredentials
    {
        public string AccessCode { get; set; }
        public string VerifyCode { get; set; }
        public string UserFullName { get; set; }
        public string UserDuz { get; set; }       
        public string UserSSN { get; set; }
        public string SiteName { get; set; }
        public string SiteNumber { get; set; }
        public string SecurityToken { get; set; }
        public string AppName { get; set; }
        
        public VixCredentials()
        { 
        }
    }
}
