using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Web; //VAI-1284

namespace Hydra.Common
{
    /// <summary>
    /// General / Utility methods
    /// </summary>
    public class Util
    {
        public static string Base64Encode(string plainText)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
        }

        public static string Base64Decode(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }

        /// <summary>
        /// Get the Fully Qualified Domain Name.
        /// </summary>
        /// <returns>The NETBIOS name of the host</returns>
        /// <remarks>We use IPGlobalProperties, because this always returns the FQDN, whereas 
        /// Dns.GetHostEntry("LocalHost").HostName returns "localhost" when not on a LAN, which we should
        /// always be, but it's good to be precise.</remarks>
        public static string GetFqdn()
        {
            string domainName = IPGlobalProperties.GetIPGlobalProperties().DomainName;
            string fqdn = Dns.GetHostName();

            domainName = "." + domainName;
            if (!fqdn.EndsWith(domainName))
                fqdn += domainName;

            return fqdn;
        }

        /// <summary>
        /// Given a host address, remove its % suffix, if any (IPv6 addresses might have a %... suffix)
        /// </summary>
        /// <param name="givenHostAddress">the given host address</param>
        /// <returns>the address without the suffix or empty string if empty/null</returns>
        public static string GetHostAddressNoSuffix(string givenHostAddress)
        {
            if (string.IsNullOrWhiteSpace(givenHostAddress))
                return "";
            int i = givenHostAddress.IndexOf('%');
            if (i < 0)
                return givenHostAddress;
            return givenHostAddress.Substring(0, i - 1);
        }

        /// <summary>
        /// Given a delimited string, remove any elements that equal the string to match
        /// </summary>
        /// <param name="given">The given string</param>
        /// <param name="match">The element to match</param>
        /// <param name="delim">The delimiter</param>
        /// <returns>The string resulting from removing the element(s)</returns>
        public static string SplitRemoveJoin(string given, string match, string delim)
        {
            IEnumerable<string> filteredList = given.Split(new string[] {delim}, StringSplitOptions.None).Where(x => string.Compare(x, match, true) != 0);
            return string.Join(delim, filteredList);
        }

        /// <summary>
        /// See if a string is URL encoded
        /// </summary>
        /// <param name="text"></param>
        /// <returns>true it is; false it isn't</returns>
        /// <remarks>Created for VAI-1284</remarks>
        public static bool IsUrlEncoded(string text)
        {
            //Take the initial string and compare it with the result of decoding it.
            //If the result is the same or the decoding fails
            //Then    The initial string is not encoded.
            //Else    The initial string is encoded.
            try
            {
                if (HttpUtility.UrlDecode(text) == text)
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }
            return true;
        }
    }
}
