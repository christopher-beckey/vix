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


using System;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Xml.Serialization;
using ImagingClient.Infrastructure.Exceptions;
using ImagingClient.Infrastructure.User.Model;
using ImagingClient.Infrastructure.UserDataSource;
using VistaCommon;
using VistaCommon.gov.va.med;

namespace ImagingClient.Infrastructure.Rest
{
    public static class RestUtils
    {
        private static SiteAddress site;
        private static int restMaxResponseContentBufferSize = -1;
        private static int RestMaxResponseContentBufferSize
        {
            get
            {
                if (restMaxResponseContentBufferSize == -1)
                {
                    try
                    {
                        restMaxResponseContentBufferSize = int.Parse(ConfigurationManager.AppSettings["RestMaxResponseContentBufferSize"]);
                    }
                    catch
                    {
                        restMaxResponseContentBufferSize = 16 * 1024 * 1024; // 16MB
                    }
                }
                return restMaxResponseContentBufferSize;
            }
        }

        public static String DoGetString(String serviceUrl, String resourcePath)
        {
            return DoGetString(serviceUrl, resourcePath, true);
        }

        public static String DoGetString(String serviceUrl, String resourcePath, bool isAuthenticated)
        {
            return DoGetContent(serviceUrl, resourcePath, isAuthenticated).ReadAsString();
        }

        public static T DoGetObject<T>(String fullUrl, bool isAuthenticated = true)
        {
            HttpContent result = DoGetContent(fullUrl, isAuthenticated);

            // Deserialize the response and return it
            XmlSerializer s = new XmlSerializer(typeof(T));
            T t = (T)s.Deserialize(result.ContentReadStream);
            return t;
        }

        public static T DoGetObject<T>(String serviceUrl, String resourcePath)
        {
            return DoGetObject<T>(serviceUrl, resourcePath, true);
        }

        public static T DoGetObject<T>(String serviceUrl, String resourcePath, bool isAuthenticated)
        {
            HttpContent result = DoGetContent(serviceUrl, resourcePath, isAuthenticated);

            // Deserialize the response and return it
            XmlSerializer s = new XmlSerializer(typeof(T));
            T t = (T)s.Deserialize(result.ContentReadStream);
            return t;

        }

        public static HttpContent DoGetContent(string fullUrl, bool isAuthenticated = true)
        {
            String transactionId = Guid.NewGuid().ToString();
            HttpClient httpClient = GetConfiguredHttpClient(transactionId, isAuthenticated);
            HttpResponseMessage message = httpClient.Get(fullUrl);
            if (message.IsSuccessStatusCode)
            {
                return message.Content;
            }

            // If we got down here, the response was not OK. Throw an exception with the
            // code and message
            throw ServerException.CreateServerException(message, "");
        }

        public static HttpContent DoGetContent(String serviceUrl, String resourcePath, bool isAuthenticated)
        {
            // Combine the base service url and the resource path
            String fullUrl = CreateFullUrl(serviceUrl, resourcePath);
            return DoGetContent(fullUrl, isAuthenticated);
        }

        public static T DoPost<T>(String serviceUrl, String resourcePath, HttpContent content)
        {
            return DoPost<T>(serviceUrl, resourcePath, content, true);
        }

        public static T DoPost<T>(String serviceUrl, String resourcePath, HttpContent content, bool isAuthenticated)
        {
            String transactionId = Guid.NewGuid().ToString();
            HttpClient httpClient = GetConfiguredHttpClient(transactionId, isAuthenticated);

            // Combine the base service url and the resource path
            String fullUrl = CreateFullUrl(serviceUrl, resourcePath);

            // Call the service and get the response
            HttpResponseMessage message = httpClient.Post(fullUrl, content);

            if (message.IsSuccessStatusCode)
            {
                // Deserialize the response and return it
                XmlSerializer s = new XmlSerializer(typeof(T));
                T t = (T)s.Deserialize(message.Content.ContentReadStream);
                return t;
            }

            // If we got down here, the response was not OK. Throw an exception with the
            // code and message
            throw ServerException.CreateServerException(message, transactionId);
        }

        public static bool DoPost(String serviceUrl, String resourcePath, HttpContent content)
        {
            return DoPost(serviceUrl, resourcePath, content, true);
        }

        public static bool DoPost(String serviceUrl, String resourcePath, HttpContent content, bool isAuthenticated)
        {
            String transactionId = Guid.NewGuid().ToString();
            HttpClient httpClient = GetConfiguredHttpClient(transactionId, isAuthenticated);

            // Combine the base service url and the resource path
            String fullUrl = CreateFullUrl(serviceUrl, resourcePath);

            // Call the service and get the response
            HttpResponseMessage message = httpClient.Post(fullUrl, content);

            if (message.IsSuccessStatusCode)
            {
                return true;
            }

            // If we got down here, the response was not OK. Throw an exception with the
            // code and message
            throw ServerException.CreateServerException(message, transactionId);
        }

        public static HttpClient GetConfiguredHttpClient(String transactionId, bool isAuthenticated)
        {
            // Create a new HttpClient
            HttpClient client = new HttpClient();

            client.MaxResponseContentBufferSize = RestMaxResponseContentBufferSize;

            // Add the authentication header
            if (isAuthenticated)
            {
                string user = UserContext.UserCredentials.AccessCode;
                string pwd = UserContext.UserCredentials.VerifyCode;
                string auth = "Basic " + Convert.ToBase64String(Encoding.Default.GetBytes(user + ":" + pwd));
                client.DefaultRequestHeaders.Add("Authorization", auth);
            }

            // Add the transaction id header
            client.DefaultRequestHeaders.Add("xxx-transaction-id", transactionId);

            return client;

        }

        private static String CreateFullUrl(string serviceUrl, string resourcePath)
        {
            if (serviceUrl.EndsWith("/") || serviceUrl.EndsWith("\\"))
                serviceUrl = serviceUrl.Substring(0, serviceUrl.Length - 1);

            if (resourcePath.StartsWith("/") || resourcePath.StartsWith("\\"))
                resourcePath = resourcePath.Substring(1, resourcePath.Length - 1);

            if (serviceUrl.StartsWith("http"))
            {
                return String.Format("{0}/{1}", serviceUrl, resourcePath);
            }
            else
            {
                if (site == null)
                {
                    String siteId = ConfigurationManager.AppSettings.Get("SiteId");
                    site = SiteServiceHelper.GetSite(siteId);
                }

                String siteAddress = String.Format("http://{0}:{1}", site.VixHost, site.VixPort);

                return String.Format("{0}/{1}/{2}", siteAddress, serviceUrl, resourcePath);
            }
        }
    }
}
