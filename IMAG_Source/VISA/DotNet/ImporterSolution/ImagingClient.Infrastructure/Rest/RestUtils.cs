/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */
namespace ImagingClient.Infrastructure.Rest
{
    using System;
    using System.Configuration;
    using System.Net.Http;
    using System.Text;
    using System.Xml.Serialization;

    using ImagingClient.Infrastructure.Exceptions;
    using ImagingClient.Infrastructure.User.Model;
    using ImagingClient.Infrastructure.Utilities;

    using VistaCommon;

    using log4net;
    using System.IO;
    using log4net.Util;
    using System.Text.RegularExpressions;

    /// <summary>
    /// The rest utils.
    /// </summary>
    public static class RestUtils
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(RestUtils));

        /// <summary>
        /// The sec key used for HTTP Authentication.
        /// </summary>
        private static readonly string SecKey =
            ConfigurationManager.AppSettings.Get("SecKey");

        /// <summary>
        /// The rest max response content buffer size.
        /// </summary>
        private static int restMaxResponseContentBufferSize = -1;

        #endregion

        #region Properties

        /// <summary>
        /// Gets RestMaxResponseContentBufferSize.
        /// </summary>
        private static int RestMaxResponseContentBufferSize
        {
            get
            {
                if (restMaxResponseContentBufferSize == -1)
                {
                    try
                    {
                        restMaxResponseContentBufferSize =
                            int.Parse(ConfigurationManager.AppSettings["RestMaxResponseContentBufferSize"]);
                    }
                    catch
                    {
                        restMaxResponseContentBufferSize = 16 * 1024 * 1024; // 16MB
                    }
                }

                return restMaxResponseContentBufferSize;
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// The do get content.
        /// </summary>
        /// <param name="serviceUrl">
        /// The service url.
        /// </param>
        /// <param name="resourcePath">
        /// The resource path.
        /// </param>
        /// <param name="isAuthenticated">
        /// The is authenticated.
        /// </param>
        /// <returns>The Http Content
        /// </returns>
        /// <exception cref="ServerException">Can possibly thow a server exception
        /// </exception>
        public static HttpContent DoGetContent(string serviceUrl, string resourcePath, bool isAuthenticated)
        {
            string transactionId = Guid.NewGuid().ToString();
            HttpClient httpClient = GetConfiguredHttpClient(transactionId, isAuthenticated);
            
            // Combine the base service url and the resource path
            string fullUrl = CreateFullUrl(serviceUrl, resourcePath);

            // Log the transaction id and url being called
            LogUrlAndTransactionId(transactionId, fullUrl);

            // Call the service and get the response
            HttpResponseMessage message;
            try
            {
                message = RetryUtility.RetryFunction(() => httpClient.Get(fullUrl));
            }
            catch (Exception e)
            {
                throw new ServerException("Unknown error accessing the VIX", e);
            }

            if (message != null && message.IsSuccessStatusCode)
            {
                return message.Content;
            }

            // If we got down here, the response was not OK. Throw an exception with the
            // code and message
            throw ServerException.CreateServerException(message, string.Empty);
        }

        /// <summary>
        /// Gets an object from the server.
        /// </summary>
        /// <param name="serviceUrl">
        /// The service url.
        /// </param>
        /// <param name="resourcePath">
        /// The resource path.
        /// </param>
        /// <typeparam name="T">The type of the object to get
        /// </typeparam>
        /// <returns>
        /// The object from the server
        /// </returns>
        public static T DoGetObject<T>(string serviceUrl, string resourcePath)
        {
            return DoGetObject<T>(serviceUrl, resourcePath, true);
        }

        /// <summary>
        /// Gets an object from the server.
        /// </summary>
        /// <param name="serviceUrl">
        /// The service url.
        /// </param>
        /// <param name="resourcePath">
        /// The resource path.
        /// </param>
        /// <param name="isAuthenticated">
        /// The is authenticated.
        /// </param>
        /// <typeparam name="T">
        /// The type of the object to get
        /// </typeparam>
        /// <returns>
        /// The object from the server
        /// </returns>
        public static T DoGetObject<T>(string serviceUrl, string resourcePath, bool isAuthenticated)
        {
            HttpContent result = DoGetContent(serviceUrl, resourcePath, isAuthenticated);

            // Deserialize the response and return it
            var s = new XmlSerializer(typeof(T));
            var t = (T)s.Deserialize(result.ContentReadStream);
            return t;
        }

        /// <summary>
        /// Gets a string from the server.
        /// </summary>
        /// <param name="serviceUrl">
        /// The service url.
        /// </param>
        /// <param name="resourcePath">
        /// The resource path.
        /// </param>
        /// <returns>
        /// The string from the server.
        /// </returns>
        public static string DoGetString(string serviceUrl, string resourcePath)
        {
            return DoGetString(serviceUrl, resourcePath, true);
        }

        /// <summary>
        /// Gets a string from the server.
        /// </summary>
        /// <param name="serviceUrl">
        /// The service url.
        /// </param>
        /// <param name="resourcePath">
        /// The resource path.
        /// </param>
        /// <param name="isAuthenticated">
        /// The is authenticated.
        /// </param>
        /// <returns>
        /// The string from the server.
        /// </returns>
        public static string DoGetString(string serviceUrl, string resourcePath, bool isAuthenticated)
        {
            return DoGetContent(serviceUrl, resourcePath, isAuthenticated).ReadAsString();
        }

        /// <summary>
        /// Posts an object to the server.
        /// </summary>
        /// <param name="serviceUrl">
        /// The service url.
        /// </param>
        /// <param name="resourcePath">
        /// The resource path.
        /// </param>
        /// <param name="content">
        /// The content.
        /// </param>
        /// <typeparam name="T">
        /// The type of the object to post
        /// </typeparam>
        /// <returns>
        /// The updated object
        /// </returns>
        public static T DoPost<T>(string serviceUrl, string resourcePath, HttpContent content)
        {
            return DoPost<T>(serviceUrl, resourcePath, content, true);
        }

        /// <summary>
        /// Posts an object to the server.
        /// </summary>
        /// <param name="serviceUrl">
        /// The service url.
        /// </param>
        /// <param name="resourcePath">
        /// The resource path.
        /// </param>
        /// <param name="content">
        /// The content.
        /// </param>
        /// <param name="isAuthenticated">
        /// The is authenticated.
        /// </param>
        /// <typeparam name="T">
        /// The type of the object to post
        /// </typeparam>
        /// <returns>
        /// The updated object
        /// </returns>
        /// <exception cref="ServerException">
        /// Can possibly throw a serverexception
        /// </exception>
        public static T DoPost<T>(string serviceUrl, string resourcePath, HttpContent content, bool isAuthenticated)
        {
            string transactionId = Guid.NewGuid().ToString();
            HttpClient httpClient = GetConfiguredHttpClient(transactionId, isAuthenticated);

            // Combine the base service url and the resource path
            string fullUrl = CreateFullUrl(serviceUrl, resourcePath);

            // Log the transaction id and url being called
            LogUrlAndTransactionId(transactionId, fullUrl);

            // Call the service and get the response
            HttpResponseMessage message;
            try
            {
                message = RetryUtility.RetryFunction(() => httpClient.Post(fullUrl, content));
            }
            catch (Exception e)
            {
                throw new ServerException("Unknown error accessing the VIX", e);
            }

            if (message != null && message.IsSuccessStatusCode)
            {
                // Deserialize the response and return it
                var s = new XmlSerializer(typeof(T));
                var t = (T)s.Deserialize(message.Content.ContentReadStream);

                return t;
            }

            // If we got down here, the response was not OK. Throw an exception with the
            // code and message
            throw ServerException.CreateServerException(message, transactionId);
        }

        /// <summary>
        /// Posts an object to the server.
        /// </summary>
        /// <param name="serviceUrl">
        /// The service url.
        /// </param>
        /// <param name="resourcePath">
        /// The resource path.
        /// </param>
        /// <param name="content">
        /// The content.
        /// </param>
        /// <returns>
        /// Whether or not the post was successful.
        /// </returns>
        public static bool DoPost(string serviceUrl, string resourcePath, HttpContent content)
        {
            return DoPost(serviceUrl, resourcePath, content, true);
        }

        /// <summary>
        /// Posts an object to the server.
        /// </summary>
        /// <param name="serviceUrl">
        /// The service url.
        /// </param>
        /// <param name="resourcePath">
        /// The resource path.
        /// </param>
        /// <param name="content">
        /// The content.
        /// </param>
        /// <param name="isAuthenticated">
        /// The is authenticated.
        /// </param>
        /// <returns>
        /// The do post.
        /// </returns>
        /// <exception cref="ServerException">
        /// Can possibly throw serverexception
        /// </exception>
        public static bool DoPost(string serviceUrl, string resourcePath, HttpContent content, bool isAuthenticated)
        {
            string transactionId = Guid.NewGuid().ToString();
            HttpClient httpClient = GetConfiguredHttpClient(transactionId, isAuthenticated);

            // Combine the base service url and the resource path
            string fullUrl = CreateFullUrl(serviceUrl, resourcePath);

            // Log the transaction id and url being called
            LogUrlAndTransactionId(transactionId, fullUrl);

            // Call the service and get the response
            HttpResponseMessage message;
            try
            {
                message = RetryUtility.RetryFunction(() => httpClient.Post(fullUrl, content));
            }
            catch (Exception e)
            {
                throw new ServerException("Unknown error accessing the VIX", e);
            }

            if (message != null && message.IsSuccessStatusCode)
            {
                return true;
            }

            // If we got down here, the response was not OK. Throw an exception with the
            // code and message
            throw ServerException.CreateServerException(message, transactionId);
        }

        /// <summary>
        /// Gets a configured http client.
        /// </summary>
        /// <param name="transactionId">
        /// The transaction id.
        /// </param>
        /// <param name="isAuthenticated">
        /// The is authenticated.
        /// </param>
        /// <returns>
        /// A configured http client
        /// </returns>
        public static HttpClient GetConfiguredHttpClient(string transactionId, bool isAuthenticated)
        {
            // Create a new HttpClient
            var client = new HttpClient { MaxResponseContentBufferSize = RestMaxResponseContentBufferSize };

            // Add the authentication header
            if (isAuthenticated)
            {
                string auth = "Basic " + SecKey;
                client.DefaultRequestHeaders.Add("Authorization", auth);

                // Add user info including BSE Token to header
                client.DefaultRequestHeaders.Add("xxx-sitename", UserContext.UserCredentials.SiteName);
                client.DefaultRequestHeaders.Add("xxx-duz", UserContext.UserCredentials.Duz);
                client.DefaultRequestHeaders.Add("xxx-ssn", UserContext.UserCredentials.Ssn);
                client.DefaultRequestHeaders.Add("xxx-sitenumber", UserContext.UserCredentials.SiteNumber);
                client.DefaultRequestHeaders.Add("xxx-fullname", UserContext.UserCredentials.Fullname);
                client.DefaultRequestHeaders.Add("xxx-securityToken", UserContext.UserCredentials.SecurityToken);
            }

            // Add the transaction id header
            client.DefaultRequestHeaders.Add("xxx-transaction-id", transactionId);

            return client;
        }

        /// <summary>
        /// Logs the transaction id and URL.
        /// </summary>
        /// <param name="transactionId">The transaction id.</param>
        /// <param name="fullUrl">The full URL.</param>
        private static void LogUrlAndTransactionId(string transactionId, string fullUrl)
        {
            //Commented for (p289-OITCOPondiS)
            //Logger.Debug("Calling " + fullUrl + " with transaction id: " + transactionId);////P237 - High  fix - Log forging -Hp fortify 
            //Logger.Debug("Calling " + fullUrl + transactionId);////P237 - High  fix - Log forging -Hp fortify 
            // Logger.DebugFormat("Calling {0}  with transaction id: {1} ", fullUrl + transactionId);////P237 - High  fix - Log forging -Hp fortify 
            //Logger.DebugFormat("Calling {0}  with transaction id: {1} {2}", fullUrl, transactionId, Environment.NewLine);////P237 - High  fix - Log forging -Hp fortify 


            //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.(p289-OITCOPondiS)
            Uri uriResult;
            bool result = Uri.TryCreate(fullUrl, UriKind.Absolute, out uriResult) && (uriResult.Scheme == Uri.UriSchemeHttp || uriResult.Scheme == Uri.UriSchemeHttps);
            if (result)
            {
                Logger.Debug("Calling " + uriResult.AbsoluteUri + " with transaction id: " + transactionId);
                Logger.DebugFormat("Calling {0}  with transaction id: {1} \r\n", uriResult.AbsoluteUri, transactionId);
            }
            else
            {
                Logger.Debug("URL validation failed for ...");
                Logger.DebugFormat("URL validation failed for transaction id {0}  \r\n", transactionId);
            }
            //Logger.Debug("Calling " + fullUrl + " with transaction id: " + transactionId);
            //END
        }

        #endregion

        #region Methods

        /// <summary>
        /// Create a full url from the URL pieces.
        /// </summary>
        /// <param name="serviceUrl">
        /// The service url.
        /// </param>
        /// <param name="resourcePath">
        /// The resource path.
        /// </param>
        /// <returns>
        /// The full URL.
        /// </returns>
        private static string CreateFullUrl(string serviceUrl, string resourcePath)
        {
            string siteId = UserContext.StationNumber;
            Site site = SiteServiceHelper.GetSite(siteId);

            string siteAddress = string.Format("http://{0}:{1}", site.VixHost, site.VixPort);

            if (serviceUrl.EndsWith("/") || serviceUrl.EndsWith("\\"))
            {
                serviceUrl = serviceUrl.Substring(0, serviceUrl.Length - 1);
            }

            if (resourcePath.StartsWith("/") || resourcePath.StartsWith("\\"))
            {
                resourcePath = resourcePath.Substring(1, resourcePath.Length - 1);
            }

            return string.Format("{0}/{1}/{2}", siteAddress, serviceUrl, resourcePath);
        }

        #endregion
    }
}