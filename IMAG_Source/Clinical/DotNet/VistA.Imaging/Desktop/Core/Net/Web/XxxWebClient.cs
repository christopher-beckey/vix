// -----------------------------------------------------------------------
// <copyright file="XxxWebClient.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Net.Web
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net;
    using System.Text;
    using VistA.Imaging.Security.Principal;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public static class XxxWebClient
    {
        /// <summary>
        /// Sets the XXX headers.
        /// </summary>
        /// <param name="client">The client.</param>
        /// <param name="transactionId">The transaction id.</param>
        public static void SetXxxHeaders(this WebClient client, string transactionId = null)
        {
            if (string.IsNullOrWhiteSpace(transactionId))
            {
                transactionId = Guid.NewGuid().ToString();
            }

            client.Headers["xxx-transaction-id"] = transactionId;
            client.Headers["xxx-client-version"] = "AWIV2.0";
            if (VistAPrincipal.Current != null && VistAPrincipal.Current.Credentials != null)
            {
                VistABSECredential bseCredential = VistAPrincipal.Current.Credentials.Where(c => c is VistABSECredential).FirstOrDefault() as VistABSECredential;
                if (bseCredential != null)
                {
                    client.Headers["xxx-securityToken"] = bseCredential.BSEToken;
                }

                VistACapriCredential capriCredential = VistAPrincipal.Current.Credentials.Where(c => c is VistACapriCredential).FirstOrDefault() as VistACapriCredential;
                if (capriCredential != null)
                {
                    client.Headers["xxx-duz"] = capriCredential.Duz;
                    client.Headers["xxx-fullname"] = capriCredential.FullName;
                    client.Headers["xxx-sitename"] = capriCredential.Institution.Name;
                    client.Headers["xxx-sitenumber"] = capriCredential.Institution.Id;
                    client.Headers["xxx-ssn"] = capriCredential.Ssn;
                }
            }
        }

        /// <summary>
        /// Sets the credentials.
        /// </summary>
        /// <param name="client">The client.</param>
        public static void SetCredentials(this WebClient client)
        {
            byte[] authBytes = Encoding.UTF8.GetBytes("alexdelarge:655321".ToCharArray());
            client.Headers[HttpRequestHeader.Authorization] = "Basic " + Convert.ToBase64String(authBytes);
        }
    }
}
