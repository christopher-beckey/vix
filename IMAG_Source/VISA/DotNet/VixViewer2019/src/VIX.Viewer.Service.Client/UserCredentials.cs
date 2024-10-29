using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VIX.Viewer.Service.Client
{
    public class UserCredentials
    {
        public string FullName { get; set; }
        public string DUZ { get; set; }
        public string SSN { get; set; }
        public string SiteName { get; set; }
        public string SiteNumber { get; set; }
        public string SecurityToken { get; set; }
        public string VixSecurityToken { get; set; }

        internal void SetHeaders(System.Net.Http.Headers.HttpRequestHeaders httpRequestHeaders)
        {
            //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
            httpRequestHeaders.Add("xxx-securitytoken", SecurityToken);
            httpRequestHeaders.Add("xxx-fullname", FullName);
            httpRequestHeaders.Add("xxx-duz", DUZ);
            httpRequestHeaders.Add("xxx-ssn", SSN);
            httpRequestHeaders.Add("xxx-sitename", SiteName);
            httpRequestHeaders.Add("xxx-sitenumber", SiteNumber);
        }
    }
}
