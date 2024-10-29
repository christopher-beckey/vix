using System;
using System.Collections.Generic;
using System.Linq;

namespace Hydra.VistA
{
    /// <summary>
    /// Define the already-known/base header names
    /// </summary>
    public class VixHeaderName
    {
        ///***NOTE 1*** VAI-582: Header names must be lowercase when sending and case-insensitive when reading, so keep these lowercase
        ///***NOTE 2*** When changing these, also change VixCredentials, IsValid, and IsKnown below
        public static string ApiToken { get { return "apitoken"; } }
        public static string AppName { get { return "xxx-appname"; } }
        public static string DUZ { get { return "xxx-duz"; } }
        public static string FullName { get { return "xxx-fullname"; } }
        public static string SecurityToken { get { return "xxx-securitytoken"; } }
        public static string SiteName { get { return "xxx-sitename"; } }
        public static string SiteNumber { get { return "xxx-sitenumber"; } }
        public static string SSN { get { return "xxx-ssn"; } }
    }

    /// <summary>
    /// Support already-known headers and any new headers
    /// </summary>
    /// <remarks>VAI-582: Rewrote method to be more maintainable by removing unnecessary arrays and logic with the public VixHeaderName class above.</remarks>
    public class VixHeaders
    {
        private IDictionary<string, IEnumerable<string>> _Headers = null;

        /// <summary>
        /// Constructor to save the key names for the provided parameter
        /// </summary>
        /// <param name="headers">A dictionary of headers, most likely from a request</param>
        /// <remarks>VAI-582: We use owercase key names for case-insensitive comparisons needed for Windows 2016 HTTPS and future support for HTTP/2</remarks>
        public VixHeaders(IDictionary<string, IEnumerable<string>> headers)
        {
            //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
            _Headers = headers?.ToDictionary(k => k.Key.ToLower(), v => v.Value);
        }

        /// <summary>
        /// Constructor to save the key names for the provided credentials
        /// </summary>
        /// <param name="vixCredentials">A set of credentials</param>
        /// <remarks>VAI-582: We use owercase key names for case-insensitive comparisons needed for Windows 2016 HTTPS and future support for HTTP/2</remarks>
        public VixHeaders(VixCredentials vixCredentials)
        {
            _Headers = new Dictionary<string, IEnumerable<string>>();

            //VAI-582: Replaced string literals with established header names
            _Headers[VixHeaderName.AppName] = new string[] { vixCredentials.AppName };
            _Headers[VixHeaderName.FullName] = new string[] { vixCredentials.UserFullName };
            _Headers[VixHeaderName.DUZ] = new string[] { vixCredentials.UserDuz };
            _Headers[VixHeaderName.SecurityToken] = new string[] { vixCredentials.SecurityToken };
            _Headers[VixHeaderName.SiteName] = new string[] { vixCredentials.SiteName };
            _Headers[VixHeaderName.SiteNumber] = new string[] { vixCredentials.SiteNumber };
            _Headers[VixHeaderName.SSN] = new string[] { vixCredentials.UserSSN };
        }

        /// <summary>
        /// For each of our header names, if it is an already-known/base header name, add it to the given parameter
        /// </summary>
        /// <param name="headers">(out) pre-existing headers</param>
        public void CopyTo(System.Net.WebHeaderCollection headers)
        {
            if (_Headers == null)
                return;
            foreach (KeyValuePair<string, IEnumerable<string>> header in _Headers)
            {
                if (!IsKnown(header.Key))
                    continue;

                headers.Add(header.Key, header.Value.SingleOrDefault()); //NOTE: Forces to only one value for some reason
            }
        }

        /// <summary>
        /// Determine whether the header name exists in our Dictionary
        /// </summary>
        /// <param name="headerName">The header name</param>
        /// <returns>true if it does, false if it does not</returns>
        public bool Contains(string headerName)
        {
            if (_Headers == null)
                return false;
            //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
            return _Headers.ContainsKey(headerName.ToLower());
        }

        /// <summary>
        /// Get the value associated with the parameter
        /// </summary>
        /// <param name="headerName">The header name</param>
        /// <returns>The single value associated with the parameter</returns>
        public string GetValue(string headerName)
        {
            if (!Contains(headerName))
                throw new InvalidOperationException($"Specified headerName is not known: {headerName}");
            //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
            return string.Join(",", _Headers[headerName.ToLower()]);
        }

        /// <summary>
        /// Ensure all the known/base headers are accounted for
        /// </summary>
        public bool IsValid
        {
            get
            {
                if (_Headers == null)
                    return false;

                if (!_Headers.ContainsKey(VixHeaderName.ApiToken)) return false;
                if (!_Headers.ContainsKey(VixHeaderName.AppName)) return false;
                if (!_Headers.ContainsKey(VixHeaderName.DUZ)) return false;
                if (!_Headers.ContainsKey(VixHeaderName.FullName)) return false;
                if (!_Headers.ContainsKey(VixHeaderName.SecurityToken)) return false;
                if (!_Headers.ContainsKey(VixHeaderName.SiteName)) return false;
                if (!_Headers.ContainsKey(VixHeaderName.SiteNumber)) return false;
                if (!_Headers.ContainsKey(VixHeaderName.SSN)) return false;

                return true;
            }
        }

        private bool IsKnown(string headerName)
        {
            if (headerName == VixHeaderName.ApiToken) return true;
            if (headerName == VixHeaderName.AppName) return true;
            if (headerName == VixHeaderName.DUZ) return true;
            if (headerName == VixHeaderName.FullName) return true;
            if (headerName == VixHeaderName.SecurityToken) return true;
            if (headerName == VixHeaderName.SiteName) return true;
            if (headerName == VixHeaderName.SiteNumber) return true;
            if (headerName == VixHeaderName.SSN) return true;

            return false;
        }
    }
}
