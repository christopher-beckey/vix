using Hydra.Common;
using Hydra.IX.Client;
using Hydra.Log;  //VAI-397
using Hydra.Security;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq; //VAI-397
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.CompilerServices; //VAI-397
using System.Text;
using System.Threading;
using System.Web;
using System.Xml;
using System.Xml.Linq;

namespace Hydra.VistA
{
    public class VixClient : IVixClient
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private static readonly HttpClient _HttpClient = null;

        private readonly int _BufferSize = 5 * 1024 * 1024;

        public string BaseUrl { get; private set; }
        public ICredentials Credentials { get; set; }
        public VixFlavor Flavor { get; private set; }

        static VixClient()
        {
            _HttpClient = new HttpClient(new HttpClientTimeoutHandler
            {
                //DefaultTimeout = TimeSpan.FromSeconds(5),
                InnerHandler = new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                }
            });

            _HttpClient.Timeout = Timeout.InfiniteTimeSpan;
        }

        public VixClient(string baseUrl, VixFlavor flavor = VixFlavor.Vix, ICredentials credentials = null)
        {
            if (string.IsNullOrEmpty(baseUrl))
                throw new ArgumentException("Vix base url cannot be empty");

            BaseUrl = baseUrl.TrimEnd(new[] { '/', '\\' });
            Credentials = credentials;
            Flavor = flavor;
        }

        public VixClient(string baseUrl, string vixUserName, string vixPassword, VixFlavor flavor = VixFlavor.Vix)
        {
            if (string.IsNullOrEmpty(baseUrl))
                throw new ArgumentException("Vix base url cannot be empty");

            BaseUrl = baseUrl.TrimEnd(new[] { '/', '\\' });

            if (!string.IsNullOrEmpty(vixUserName))
                Credentials = new NetworkCredential(vixUserName, vixPassword);

            Flavor = flavor;
        }

        public string GetStudyMetadata(string transactionUid, string contextId, string token, string dfn, string icn, string siteNumber)
        {
            string url = null;

            using (var eventLogger = EventLogger.Create(transactionUid, contextId, IX.Common.EventLogContextType.DisplayContext))
            {
                try
                {
                    string format = (Flavor == VixFlavor.Vix) ?
                        "/ViewerStudyWebApp/token/restservices/study/cprs/{0}?cprsIdentifier={1}{2}{3}" :
                        "/StudyWebApp/token/restservices/study/cprs/{0}?cprsIdentifier={1}{2}{3}";
                    url = string.Format(BaseUrl + format,
                                        siteNumber,
                                        HttpUtility.UrlEncode(contextId),
                                        !string.IsNullOrEmpty(dfn) ? string.Format("&dfn={0}", dfn) : string.Format("&icn={0}", icn),
                                        !string.IsNullOrEmpty(token) ? string.Format("&securityToken={0}", token) : "");

                    eventLogger.BeginEvent(url);

                    string text = null;
                    WebRequest request = WebRequest.Create(url);
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());

                    if (Credentials != null)
                        request.Credentials = Credentials;

                    DebugOrTraceLogRequest("Fetching study metadata.", request);
                    var codeClock = CodeClock.Start();
                    using (WebResponse response = request.GetResponse())
                    {
                        using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                        {
                            text = reader.ReadToEnd();
                        }
                    }
                    codeClock.Stop();
                    DebugOrTraceLogResponse("Fetching study metadata complete.", text, codeClock.ElapsedMilliseconds);
                    return text;
                }
                catch (Exception ex)
                {
                    _Logger.Error("Error fetching study metadata.", "Url", url, "Exception", ex.ToString());
                    eventLogger.EndEvent(ex.ToString(), IX.Common.EventLogType.Error);

                    if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                    {
                        throw new VixTimeoutException();
                    }

                    throw;
                }
            }
        }

        public string GetStudiesMetadata(string transactionUid, IEnumerable<string> contextIds, string vixSecurityToken, string patientDFN, string patientICN, string siteNumber, TimeSpan timeout)
        {
            string url = null;

            try
            {
                url = string.Format(@"{0}/ViewerStudyWebApp/token/restservices/study/cprs/viewer/{1}?{2}{3}",
                                            BaseUrl,
                                            siteNumber,
                                            !string.IsNullOrEmpty(patientDFN) ? string.Format("dfn={0}", patientDFN) : string.Format("icn={0}", patientICN),
                                            !string.IsNullOrEmpty(vixSecurityToken) ? string.Format("&securityToken={0}", vixSecurityToken) : "");

                // format request body
                var xmlDoc = new XmlDocument();
                var cprsIdentifiersNode = xmlDoc.CreateElement("cprsIdentifiers");
                xmlDoc.AppendChild(cprsIdentifiersNode);

                foreach (var contextId in contextIds)
                {
                    var cprsIdentifierNode = xmlDoc.CreateElement("cprsIdentifier");
                    cprsIdentifierNode.AppendChild(xmlDoc.CreateTextNode(contextId));
                    cprsIdentifiersNode.AppendChild(cprsIdentifierNode);
                }

                var content = new StringContent(cprsIdentifiersNode.OuterXml, Encoding.UTF8, "application/xml");
                string transactionId = Guid.NewGuid().ToString();
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                content.Headers.Add("xxx-transaction-id", transactionId);
                DebugOrTraceLogRequestUrlTransaction("Performing bulk study query with POST.", url, transactionId);
                var request = new HttpRequestMessage(HttpMethod.Post, url);
                request.Content = content;
                request.SetTimeout(timeout);

                var cts = new CancellationTokenSource();
                using (HttpResponseMessage response = VixClient._HttpClient.SendAsync(request, cts.Token).Result)
                {
                    response.EnsureSuccessStatusCode();

                    var text = response.Content.ReadAsStringAsync().Result;
                    DebugOrTraceLogResponse("Bulk study query with POST complete.", text);
                    return text;
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error performing bulk query.", "Url", url, "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string GetStudyReport(string transactionUid, string contextId, string token, string dfn, string icn, string siteNumber)
        {
            using (var eventLogger = EventLogger.Create(transactionUid, contextId, IX.Common.EventLogContextType.DisplayContext))
            {
                string url = null;

                try
                {
                    string format = "/Study/token/restservices/study/report/{0}?securityToken={1}";
                    url = string.Format(BaseUrl + format,
                                               HttpUtility.UrlEncode(contextId),
                                               token);

                    eventLogger.BeginEvent(url);

                    string text = null;
                    WebRequest request = WebRequest.Create(url);
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());

                    if (Credentials != null)
                        request.Credentials = Credentials;

                    DebugOrTraceLogRequest("Getting study report.", request);
                    var codeClock = CodeClock.Start();
                    using (WebResponse response = request.GetResponse())
                    {
                        using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                        {
                            text = reader.ReadToEnd();
                        }
                    }
                    codeClock.Stop();
                    DebugOrTraceLogResponse("Getting study report complete.", text, codeClock.ElapsedMilliseconds);

                    return text;
                }
                catch (Exception ex)
                {
                    _Logger.Error("Error fetching study report.", "Url", url, "Exception", ex.ToString());
                    eventLogger.EndEvent(ex.ToString(), IX.Common.EventLogType.Error);

                    if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                    {
                        throw new VixTimeoutException();
                    }

                    throw;
                }
            }
        }

        public void GetImage(string imageUrn, string securityToken, string transactionUid, Stream outputStream, TimeSpan timeout, int retryCount)
        {
            string url;

            while (retryCount > 0)
            {
                var transactionId = Guid.NewGuid().ToString();
                bool isInternalServerError = false;

                try
                {
                    string format = (Flavor == VixFlavor.Vix) ?
                        "{0}/ViewerStudyWebApp/token/image?{1}&securityToken={2}" :
                        "{0}/StudyWebApp/token/image?{1}&securityToken={2}";
                    url = string.Format(format, BaseUrl.TrimEnd('/'), imageUrn, securityToken);

                    var requestMessage = new HttpRequestMessage(HttpMethod.Get, url);
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    requestMessage.Headers.Add("xxx-transaction-id", transactionId);
                    requestMessage.SetTimeout(timeout);

                    DebugOrTraceLogRequestUrlTransaction("Getting image.", url, transactionId);

                    var cts = new CancellationTokenSource();
                    var stopWatch = new Stopwatch();
                    stopWatch.Start();
                    using (HttpResponseMessage response = VixClient._HttpClient.SendAsync(requestMessage, cts.Token).Result)
                    {
                        isInternalServerError = (response.StatusCode == HttpStatusCode.InternalServerError);
                        response.EnsureSuccessStatusCode();

                        using (Stream stream = response.Content.ReadAsStreamAsync().Result)
                        {
                            stream.CopyTo(outputStream);
                        }
                        stopWatch.Stop();
                        DebugOrTraceLogResponse("Getting image complete.", "(stream)", stopWatch.ElapsedMilliseconds);
                        return;
                    }
                }
                catch (Exception ex)
                {
                    _Logger.Error("Error getting image.", "Exception", ex.Message);

                    bool hasTimedOut = false;

                    if (ex is TimeoutException)
                    {
                        hasTimedOut = true;
                    }
                    else if (ex is AggregateException)
                    {
                        (ex as AggregateException).Handle(x =>
                        {
                            return (hasTimedOut = (x is TimeoutException));
                        });
                    }

                    if (hasTimedOut || isInternalServerError)
                    {
                        retryCount--;

                        if (retryCount > 0)
                        {
                            if (hasTimedOut)
                                _Logger.Warn("Request timed out. Trying again.", "RetryCount", retryCount, "TransId", transactionId);
                            else
                                _Logger.Warn("Request failed. Trying again.", "RetryCount", retryCount, "TransId", transactionId);
                        }
                    }
                    else
                        throw;
                }
            }

            throw new TimeoutException("Failed to get image");
        }

        public string GetImageCacheLocation(string imageUrn, string securityToken, string transactionUid, TimeSpan timeout, int retryCount)
        {
            string url = null;

            while (retryCount > 0)
            {
                using (var eventLogger = EventLogger.Create(transactionUid, imageUrn, IX.Common.EventLogContextType.Image))
                {
                    var transactionId = Guid.NewGuid().ToString();
                    bool isInternalServerError = false;

                    try
                    {
                        string format = (Flavor == VixFlavor.Vix) ?
                            "{0}/ViewerStudyWebApp/token/image?{1}&securityToken={2}" :
                            "{0}/StudyWebApp/token/image?{1}&securityToken={2}";
                        url = string.Format(format, BaseUrl.TrimEnd('/'), imageUrn, securityToken);
                        eventLogger.BeginEvent(url);

                        var requestMessage = new HttpRequestMessage(HttpMethod.Head, url);
                        //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                        requestMessage.Headers.Add("xxx-transaction-id", transactionId);
                        requestMessage.SetTimeout(timeout);

                        DebugOrTraceLogRequestUrlTransaction("Getting image cache location.", url, transactionId);

                        var cts = new CancellationTokenSource();
                        var stopWatch = new Stopwatch();
                        stopWatch.Start();
                        using (HttpResponseMessage response = VixClient._HttpClient.SendAsync(requestMessage, cts.Token).Result)
                        {
                            stopWatch.Stop();
                            isInternalServerError = (response.StatusCode == HttpStatusCode.InternalServerError);
                            response.EnsureSuccessStatusCode();

                            IEnumerable<string> values;
                            if (!response.Headers.TryGetValues("xxx-filename", out values))
                            {
                                _Logger.Warn("Failed to get Vix image cache location", "TransId", transactionId);
                                return null;
                            }

                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("Getting image cache location completed.", "Duration", stopWatch.Elapsed.ToString(@"mm\:ss\.fff"));

                            return values.First();
                        }
                    }
                    catch (Exception ex)
                    {
                        eventLogger.EndEvent(ex.ToString(), IX.Common.EventLogType.Error);

                        bool hasTimedOut = false;

                        if (ex is TimeoutException)
                        {
                            hasTimedOut = true;
                        }
                        else if (ex is AggregateException)
                        {
                            (ex as AggregateException).Handle(x =>
                            {
                                return (hasTimedOut = (x is TimeoutException));
                            });
                        }

                        if (hasTimedOut || isInternalServerError)
                        {
                            retryCount--;

                            if (retryCount > 0)
                            {
                                if (hasTimedOut)
                                    _Logger.Warn("Request timed out. Trying again.", "RetryCount", retryCount, "TransId", transactionId);
                                else
                                    _Logger.Warn("Request failed. Trying again.", "RetryCount", retryCount, "TransId", transactionId);
                            }
                        }
                        else
                            throw;
                    }
                }
            }

            throw new TimeoutException("Failed to get image cache location");
        }

        public string QuerySiteService(string siteNumber)
        {
            try
            {
                string url = string.Format(BaseUrl.TrimEnd('/') + "/vistawebsvcs/restservices/siteservice/site/{0}", siteNumber);

                string text = null;
                WebRequest request = WebRequest.Create(url);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());

                DebugOrTraceLogRequest("Querying site service (single siteNumber.", request);
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Site service request (single siteNumber) complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error querying site service (single siteNumber).", "Exception", ex.ToString());
                throw;
            }
        }

        public string QuerySiteService(IEnumerable<string> siteNumbers)
        {
            try
            {
                string text = string.Join("%5E", siteNumbers);
                string url = string.Format(BaseUrl.TrimEnd('/') + "/siteservicewebapp/restservices/siteservice/sites/{0}", text);

                text = null;
                WebRequest request = WebRequest.Create(url);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());

                DebugOrTraceLogRequest("Queryig site service (multiple siteNumbers.", request);
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Site service request (multiple siteNumbers) complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error querying site service (multiple siteNumbers).", "Exception", ex.ToString());
                throw;
            }
        }

        public string GetVixJavaSecurityToken(VixHeaders vixHeaders)
        {
            string url = "";
            try
            {
                string format = (Flavor == VixFlavor.Vix) ?
                    "/ViewerStudyWebApp/restservices/study/user/token" :
                    "/StudyWebApp/restservices/study/user/token";
                url = BaseUrl.TrimEnd('/') + format;

                string text = null;
                WebRequest request = WebRequest.Create(url);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                if (vixHeaders != null)
                    vixHeaders.CopyTo(request.Headers);

                if (Credentials != null)
                    request.Credentials = Credentials;

                DebugOrTraceLogRequest("Getting security token.", request);
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Security token request complete.", text);
                return VixTextParser.Parse(text);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting security token.", "url", url, "Exception", ex.ToString());
                throw;
            }
        }

        public string GetPatientStudies(string patientICN, string patientDFN, string siteNumber, string securityToken, string imageFilter, bool isDash, VixHeaders vixHeaders = null)
        {
            try
            {
                string facade = (Flavor == VixFlavor.Vix) ? "ViewerStudyWebApp" : "StudyWebApp";
                string patientLookup = (!string.IsNullOrEmpty(patientICN)) ? $"icn={patientICN}" : $"dfn={patientDFN}";
                string url = BaseUrl.TrimEnd('/') + $"/{facade}/token/restservices/study/studies/{siteNumber}?{patientLookup}&securityToken={securityToken}";

                if (!string.IsNullOrEmpty(imageFilter))
                    url += $"&imageFilter={HttpUtility.UrlEncode(imageFilter)}";
                if (isDash)
                    url += "&appName=DASH";

                string text = null;
                WebRequest request = WebRequest.Create(url);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                if (vixHeaders != null)
                    vixHeaders.CopyTo(request.Headers);

                DebugOrTraceLogRequest("Getting patient studies.", request);
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Patient studies request complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting patient studies.", "Exception", ex.ToString());
                throw;
            }
        }

        public string GetDevFields(string objectUrn, string securityToken, VixHeaders vixHeaders = null)
        {
            try
            {
                string url = BaseUrl.TrimEnd('/') + string.Format("/ImagingDataWebApp/token/restservices/image/devfields/{0}?flags=IERN{1}",
                                                                    HttpUtility.UrlEncode(objectUrn),
                                                                    !string.IsNullOrEmpty(securityToken) ? string.Format("&securityToken={0}", securityToken) : "");

                string text = null;
                WebRequest request = WebRequest.Create(url);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                if (vixHeaders != null)
                    vixHeaders.CopyTo(request.Headers);

                DebugOrTraceLogRequest("Getting Dev Fields.", request);
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Get Dev Fields complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting Dev Fields.", "ObjectUrn", objectUrn, "Exception", ex.ToString());
                throw;
            }
        }

        public string GetGlobalNodes(string objectUrn, string securityToken, VixHeaders vixHeaders = null)
        {
            try
            {
                string url = BaseUrl.TrimEnd('/') + string.Format("/ImagingDataWebApp/token/restservices/image/globalnodes/{0}?flags=IERN{1}",
                                                                  HttpUtility.UrlEncode(objectUrn),
                                                                  !string.IsNullOrEmpty(securityToken) ? string.Format("&securityToken={0}", securityToken) : "");

                string text = null;
                WebRequest request = WebRequest.Create(url);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                if (vixHeaders != null)
                    vixHeaders.CopyTo(request.Headers);

                DebugOrTraceLogRequest("Getting Global Nodes.", request);
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Get Global Nodes request complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting Global Nodes.", "ObjectUrn", objectUrn, "Exception", ex.ToString());
                throw;
            }
        }

        public string GetPStateRecords(string contextId, string vixSecurityToken, bool includeDetailsFlag, bool includeOtherUsersFlag)
        {
            try
            {
                string text = "";
                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                                | DecompressionMethods.Deflate,
                    Credentials = this.Credentials
                }))
                {
                    string url = string.Format(@"{0}/PresentationStateWebApp/token/restservices/presentationstate/get/records{1}",
                                               BaseUrl,
                                               !string.IsNullOrEmpty(vixSecurityToken) ? string.Format("?securityToken={0}", vixSecurityToken) : "");

                    // format request body
                    var jsonObject = JsonConvert.SerializeObject(
                        new
                        {
                            studyid = contextId,
                            includeDeleted = false,
                            includeOtherUsers = includeOtherUsersFlag,
                            includeDetails = includeDetailsFlag
                        });

                    var content = new StringContent(jsonObject, Encoding.UTF8, "application/json");

                    DebugOrTraceLogRequestUrlBody("Fetching PState Records with POST.", url, jsonObject);
                    using (HttpResponseMessage response = client.PostAsync(url, content).Result)
                    {
                        response.EnsureSuccessStatusCode();
                        text = response.Content.ReadAsStringAsync().Result;
                    }
                }
                DebugOrTraceLogResponse("PState Records request complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error fetching PState records.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public void AddPStateRecord(string contextId, string pStateUid, string psName, string psSource, string psData, string vixSecurityToken, string psFilePath)
        {
            try
            {
                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                                | DecompressionMethods.Deflate,
                    Credentials = this.Credentials
                }))
                {
                    string url = string.Format(@"{0}/PresentationStateWebApp/token/restservices/presentationstate/create/record{1}",
                                               BaseUrl,
                                               !string.IsNullOrEmpty(vixSecurityToken) ? string.Format("?securityToken={0}", vixSecurityToken) : "");
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("filename", psFilePath);

                    // format request body
                    var jsonObject = JsonConvert.SerializeObject(
                        new
                        {
                            studyid = contextId,
                            pstateuid = pStateUid,
                            name = psName,
                            source = psSource,
                            data = psData
                        });

                    var content = new StringContent(jsonObject, Encoding.UTF8, "application/json");

                    DebugOrTraceLogRequestUrlBody("Adding PState Record with POST.", url, jsonObject);
                    using (HttpResponseMessage response = client.PostAsync(url, content).Result)
                    {
                        response.EnsureSuccessStatusCode();
                    }
                }
                DebugOrTraceLogResponse("Adding PState Record complete.");
            }
            catch (Exception ex)
            {
                _Logger.Error("Error adding PState record.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public void DeletePStateRecord(string contextId, string pStateUid, string vixSecurityToken)
        {
            try
            {
                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                                | DecompressionMethods.Deflate,
                    Credentials = this.Credentials
                }))
                {
                    string url = string.Format(@"{0}/PresentationStateWebApp/token/restservices/presentationstate/delete/record{1}",
                                               BaseUrl,
                                               !string.IsNullOrEmpty(vixSecurityToken) ? string.Format("?securityToken={0}", vixSecurityToken) : "");
                    ////VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    //client.DefaultRequestHeaders.Add("xxx-transaction-id", Guid.NewGuid().ToString());

                    // format request body
                    var jsonObject = JsonConvert.SerializeObject(
                        new
                        {
                            studyid = contextId,
                            pstateuid = pStateUid
                        });

                    var content = new StringContent(jsonObject, Encoding.UTF8, "application/json");

                    DebugOrTraceLogRequestUrlBody("Deleting PState Record with DELETE.", url, content.ToString());
                    var msg = new HttpRequestMessage(HttpMethod.Delete, url)
                    {
                        Content = content
                    };

                    using (HttpResponseMessage response = client.SendAsync(msg).Result)
                    {
                        response.EnsureSuccessStatusCode();
                    }
                }
                DebugOrTraceLogResponse("Deleting PState Record complete.");
            }
            catch (Exception ex)
            {
                _Logger.Error("Error deleting PState record.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string GetUserDetails(string userId, string siteNumber, string securityToken, VixHeaders vixHeaders = null)
        {
            try
            {
                string url = BaseUrl.TrimEnd('/') +
                             string.Format("/ViewerImagingWebApp/token/restservices/viewerImaging/getUserInformation?securityToken={0}{1}{2}",
                                            securityToken,
                                            !string.IsNullOrEmpty(siteNumber) ? string.Format("&siteId={0}", siteNumber) : "",
                                            !string.IsNullOrEmpty(userId) ? string.Format("&userId={0}", userId) : "");

                string text = null;
                WebRequest request = WebRequest.Create(url);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                if (vixHeaders != null)
                    vixHeaders.CopyTo(request.Headers);

                DebugOrTraceLogRequest("Getting user details.", request);
                request.Timeout = 600000; //needs more time on slower networks
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Get user information request complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting user information.", "Exception", ex.ToString());
                throw;
            }
        }

        public string VerifyElectronicSignature(string eSignature, string siteNumber, string securityToken, VixHeaders vixHeaders = null)
        {
            try
            {
                string url = BaseUrl.TrimEnd('/') +
                             string.Format("/UserWebApp/token/restservices/user/verifyElectronicSignature/{0}/{1}?securityToken={2}",
                                            siteNumber, eSignature, securityToken);

                string text = null;
                WebRequest request = WebRequest.Create(url);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                if (vixHeaders != null)
                    vixHeaders.CopyTo(request.Headers);

                if (Credentials != null)
                    request.Credentials = Credentials;

                DebugOrTraceLogRequest("Verifying electronic signature.", request);
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Electronic signature verification request complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error verifying electronic signature.", "Exception", ex.ToString());
                throw;
            }
        }

        public string DeleteImages(string[] imageUrns, string reasonForDelete, string siteNumber, string securityToken, VixHeaders vixHeaders)
        {
            try
            {
                string text = "";
                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                                | DecompressionMethods.Deflate,
                    Credentials = this.Credentials
                }))
                {
                    string url = string.Format("{0}/ViewerImagingWebApp/token/restservices/viewerImaging/deleteImages?securityToken={1}",
                                               BaseUrl.TrimEnd('/'), securityToken);
                    ////VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    //client.DefaultRequestHeaders.Add("xxx-transaction-id", Guid.NewGuid().ToString());

                    // format request body
                    // format delete request
                    var deleteImageUrns = new XElement("deleteImageUrns",
                                                       new XElement("defaultDeleteReason", reasonForDelete),
                                                       from imageId in imageUrns
                                                       select new XElement("deleteImageUrn",
                                                                           new XElement("value", imageId)));

                    var content = new StringContent(deleteImageUrns.ToString(), Encoding.UTF8, "application/xml");

                    DebugOrTraceLogRequestUrlBody("Deleting images with POST.", url, content.ToString());
                    using (HttpResponseMessage response = client.PostAsync(url, content).Result)
                    {
                        response.EnsureSuccessStatusCode();
                        text = response.Content.ReadAsStringAsync().Result;
                    }
                }
                DebugOrTraceLogResponse("Deleting images complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error deleting images.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public void SensitiveImages(string[] imageUrns, bool isSensitive, string siteNumber, string securityToken, VixHeaders vixHeaders)
        {
            try
            {
                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                                | DecompressionMethods.Deflate,
                    Credentials = this.Credentials
                }))
                {
                    string url = string.Format("{0}/ViewerImagingWebApp/token/restservices/viewerImaging/flagImagesAsSensitive?securityToken={1}",
                                               BaseUrl.TrimEnd('/'), securityToken);
                    ////VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    //client.DefaultRequestHeaders.Add("xxx-transaction-id", Guid.NewGuid().ToString());

                    // format request body
                    // format sensitive request
                    var sensitiveImageUrns = new XElement("flagSensitiveImageUrns",
                                                       new XElement("defaultSensitive", isSensitive),
                                                       from imageId in imageUrns
                                                       select new XElement("flagSensitiveImageUrn",
                                                                           new XElement("imageUrn", imageId)));

                    var content = new StringContent(sensitiveImageUrns.ToString(), Encoding.UTF8, "application/xml");

                    DebugOrTraceLogRequestUrlBody("Sensitive images request with POST.", url, content.ToString());
                    using (HttpResponseMessage response = client.PostAsync(url, content).Result)
                    {
                        response.EnsureSuccessStatusCode();
                    }
                }
                DebugOrTraceLogResponse("Sensitive images request complete.");
            }
            catch (Exception ex)
            {
                _Logger.Error("Error in sensitive images request.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public List<string> GetImageDeleteReasons(string securityToken)
        {
            try
            {
                string reasons = string.Empty;

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = BaseUrl.TrimEnd('/') + string.Format("/ViewerImagingWebApp/token/restservices/viewerImaging/getDeleteReasons?securityToken={0}", securityToken);

                    string transactionId = Guid.NewGuid().ToString();
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", transactionId);
                    DebugOrTraceLogRequestUrlTransaction("Getting image delete reasons.", url, transactionId);
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        response.EnsureSuccessStatusCode();

                        using (StreamReader reader = new StreamReader(response.Content.ReadAsStreamAsync().Result))
                        {
                            reasons = reader.ReadToEnd();
                        }
                    }
                }

                List<string> deleteReasons = new List<string>();
                if (!string.IsNullOrEmpty(reasons))
                {
                    XDocument.Parse(reasons).Element("deleteReasons").Elements("deleteReason").ToList().ForEach(item =>
                    {
                        deleteReasons.Add(item.Value);
                    });
                }
                DebugOrTraceLogResponse("Getting image delete reasons complete.", reasons);
                return deleteReasons;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting image delete reasons.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        private HttpClient GetHttpClient()
        {
            HttpClient client = new HttpClient(new HttpClientHandler
            {
                AutomaticDecompression = DecompressionMethods.GZip
                                                | DecompressionMethods.Deflate,
                Credentials = this.Credentials
            });

            //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
            client.DefaultRequestHeaders.Add("xxx-transaction-id", Guid.NewGuid().ToString());

            return client;
        }

        public void StorePreference(string name, string value, string userId, bool isSystemLevel, string vixSecurityToken)
        {
            try
            {
                string text = "";
                using (var client = GetHttpClient())
                {
                    string url = string.Format(@"{0}/VistaUserPreferenceWebApp/token/restservices/userPreference/store?securityToken={1}&key={2}&entity={3}",
                                               BaseUrl, vixSecurityToken, name,
                                               isSystemLevel ? "SYS" : HttpUtility.UrlEncode(string.Format("USR.`{0}", userId)));

                    if (value == null)
                        value = "";

                    // split value into lines
                    int maxlineLength = 250;
                    if (value.Length > 250)
                    {
                        var sb = new StringBuilder();

                        for (int i = 0; i < value.Length; i += maxlineLength)
                        {
                            if (i == 0)
                                sb.Append(value.Substring(i, Math.Min(maxlineLength, value.Length - i)));
                            else
                                sb.AppendFormat("\n{0}", value.Substring(i, Math.Min(maxlineLength, value.Length - i)));
                        }

                        value = sb.ToString();
                    }

                    var content = new StringContent(value, Encoding.UTF8, "text/xml");

                    DebugOrTraceLogRequestUrlBody("Storing preference with POST.", url, content.ToString());
                    using (HttpResponseMessage response = client.PostAsync(url, content).Result)
                    {
                        response.EnsureSuccessStatusCode();
                        text = response.Content.ReadAsStringAsync().Result;
                    }
                }
                DebugOrTraceLogResponse("Storing preference request complete.", text);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error storing preference.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string RetrievePreference(string name, string userId, bool isSystemLevel, string vixSecurityToken)
        {
            string text = "";
            try
            {
                //string text = "";
                using (var client = GetHttpClient())
                {
                    string url = string.Format(@"{0}/VistaUserPreferenceWebApp/token/restservices/userPreference/load?securityToken={1}&key={2}&entity={3}",
                                               BaseUrl, vixSecurityToken, name,
                                               isSystemLevel ? "SYS" : HttpUtility.UrlEncode(string.Format("USR.`{0}", userId)));

                    client.Timeout= TimeSpan.FromMinutes(10); // added to reduce failures

                    DebugOrTraceLogRequestUrlBody("Retrieving preference.", url);
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        response.EnsureSuccessStatusCode();
                        text = response.Content.ReadAsStringAsync().Result;
                    }
                }
                DebugOrTraceLogResponse("Retrieving preference complete.", text);
                //return text;
            }
            catch (Exception ex)
            {
                _Logger.Warn("Error retrieving preference; treating as a warning, because it happens frequently.", "Exception", ex.ToString());

                //if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                //{
                //    throw new VixTimeoutException();
                //}

                //throw;
            }
            return text;
        }

        public string GetOtherPStateInformation(string contextId, string vixSecurityToken)
        {
            try
            {
                string text = "";
                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                                | DecompressionMethods.Deflate,
                    Credentials = this.Credentials
                }))
                {
                    string url = string.Format(@"{0}/PresentationStateWebApp/token/restservices/presentationstate/get/annotations?studyContext={1}&securityToken={2}",
                                               BaseUrl, contextId, vixSecurityToken);
                    ////VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    //client.DefaultRequestHeaders.Add("xxx-transaction-id", Guid.NewGuid().ToString());

                    DebugOrTraceLogRequestUrlBody("Fetching other PState information.", url);
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        response.EnsureSuccessStatusCode();
                        text = response.Content.ReadAsStringAsync().Result;
                    }
                }
                DebugOrTraceLogResponse("Fetching other PState information complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error fetching other PState information.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public List<string> GetPrintReasons(string securityToken)
        {
            try
            {
                string reasons = string.Empty;

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromMinutes(10.0)
                })
                {
                    string url = BaseUrl.TrimEnd('/') + string.Format("/ViewerImagingWebApp/token/restservices/viewerImaging/getPrintReasons?securityToken={0}", securityToken);

                    string transactionId = Guid.NewGuid().ToString();
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", transactionId);
                    DebugOrTraceLogRequestUrlTransaction("Retrieving print reasons.", url, transactionId);
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        response.EnsureSuccessStatusCode();

                        using (StreamReader reader = new StreamReader(response.Content.ReadAsStreamAsync().Result))
                        {
                            reasons = reader.ReadToEnd();
                        }
                    }
                }

                List<string> printReasons = new List<string>();
                if (!string.IsNullOrEmpty(reasons))
                {
                    XDocument.Parse(reasons).Element("printReasons").Elements("printReason").ToList().ForEach(item =>
                    {
                        printReasons.Add(item.Value);
                    });
                }
                DebugOrTraceLogResponse("Retrieving print reasons complete.", reasons);
                return printReasons;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting print reasons.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string LogImageExport(string siteNumber, string imageUrn, string reason, string vixSecurityToken, VixHeaders vixHeaders = null)
        {
            try
            {
                string url = BaseUrl.TrimEnd('/') +
                             string.Format("/ViewerImagingWebApp/token/restservices/viewerImaging/logPrintImageAccess?siteId={0}&imageUrn={1}&reason={2}&securityToken={3}",
                                            siteNumber, imageUrn, reason, vixSecurityToken);

                string text = null;
                WebRequest request = WebRequest.Create(url);
                string transactionId = Guid.NewGuid().ToString();
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", transactionId);
                DebugOrTraceLogRequestUrlTransaction("Logging image export.", url, transactionId);
                if (vixHeaders != null)
                    vixHeaders.CopyTo(request.Headers);

                if (Credentials != null)
                    request.Credentials = Credentials;

                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Logging image export complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error logging image export.", "Exception", ex.ToString());
                throw;
            }
        }

        public string GetPatientInformation(string patientICN, string patientDFN, string siteNumber, string vixSecurityToken, VixHeaders vixHeaders)
        {
            string result = null; //VAI-397
            try
            {
                string url = BaseUrl.TrimEnd('/') +
                             string.Format("/PatientWebApp/token/restservices/patient/information/{0}/{1}?securityToken={2}",
                             siteNumber, !string.IsNullOrEmpty(patientICN) ? patientICN : patientDFN, vixSecurityToken);

                WebRequest request = WebRequest.Create(url);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                if (vixHeaders != null)
                    vixHeaders.CopyTo(request.Headers);

                if (Credentials != null)
                    request.Credentials = Credentials;

                DebugOrTraceLogRequest("Getting patient information.", request);
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        result = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Getting patient information complete.", result);
            }
            catch (Exception ex)
            {
                if (_Logger.IsTraceEnabled)
                    _Logger.Trace("Error getting patient information, but continuing.", "Exception", ex.ToString());
                throw;
            }
            return result;
        }

        public string GetROIStatus(string patientICN, string patientDFN, string siteNumber, string vixSecurityToken, VixHeaders vixHeaders)
        {
            try
            {
                //string url = BaseUrl.TrimEnd('/') +
                //             string.Format("/ROIWebApp/token/restservices/ROI/status/securityToken={0}",
                //             siteNumber, !string.IsNullOrEmpty(patientICN) ? patientICN : patientDFN, vixSecurityToken);
                string url = BaseUrl.TrimEnd('/') +
                             string.Format("/ROIWebApp/token/restservices/roi/status?securityToken={0}", vixSecurityToken);

                string text = null;
                WebRequest request = WebRequest.Create(url);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                if (vixHeaders != null)
                    vixHeaders.CopyTo(request.Headers);

                if (Credentials != null)
                    request.Credentials = Credentials;

                DebugOrTraceLogRequest("Getting ROI status.", request);
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Getting ROI status complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting ROI status.", "Exception", ex.ToString());
                throw;
            }
        }

        public string GetTreatingFacilities(string patientICN, string patientDFN, string siteNumber, string vixSecurityToken, VixHeaders vixHeaders)
        {
            string url = null;

            try
            {
                url = BaseUrl.TrimEnd('/') +
                      string.Format("/ViewerImagingWebApp/token/restservices/viewerImaging/getTreatingFacilities?siteId={0}{1}{2}",
                                    siteNumber, // Note: request will work if siteNumber is empty
                                    !string.IsNullOrEmpty(patientDFN) ? string.Format("&dfn={0}", patientDFN) : string.Format("&icn={0}", patientICN),
                                    !string.IsNullOrEmpty(vixSecurityToken) ? string.Format("&securityToken={0}", vixSecurityToken) : "");

                string text = null;
                WebRequest request = WebRequest.Create(url);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                request.Headers.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                if (vixHeaders != null)
                    vixHeaders.CopyTo(request.Headers);

                if (Credentials != null)
                    request.Credentials = Credentials;

                DebugOrTraceLogRequest("Fecthing treating facilities.", request);
                var codeClock = CodeClock.Start();
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Fetching treating facilities complete.", text, codeClock.ElapsedMilliseconds);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error fetching treating facilities.", "Url", url, "Exception", ex.ToString());
                throw;
            }
        }

        public string GetVixVersion()
        {
            string text = null;

            try
            {
                string url = BaseUrl.TrimEnd('/');

                WebRequest request = WebRequest.Create(url);
                DebugOrTraceLogRequestUrlBody("Getting VIX version.", url);
                using (WebResponse response = request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        text = reader.ReadToEnd();
                    }
                }
                DebugOrTraceLogResponse("Getting VIX version complete.", text);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting ROI status.", "Exception", ex.ToString());
            }

            return text;
        }

        public string GetCDBurners(string securityToken)
        {
            try
            {
                string burners = string.Empty;

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = BaseUrl.TrimEnd('/') + string.Format("/ROIWebApp/token/restservices/exportqueue/dicom?securityToken={0}", securityToken);
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                    DebugOrTraceLogRequestUrlBody("Retrieving CD burners.", url);

                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        response.EnsureSuccessStatusCode();

                        using (StreamReader reader = new StreamReader(response.Content.ReadAsStreamAsync().Result))
                        {
                            burners = reader.ReadToEnd();
                        }
                    }
                }
                DebugOrTraceLogResponse("Retrieving CD burners complete.", burners);
                return burners;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting CD burners.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string SubmitROIRequest(string patientICN, string siteNumber, List<string> groupIENs, string target, string securityToken)
        {
            try
            {
                string text = string.Empty;

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = "";
                    if (string.IsNullOrEmpty(target))
                    {
                        url += BaseUrl.TrimEnd('/') + string.Format("/ROIWebApp/token/restservices/roi/queue/icn/{0}/{1}/{2}?securityToken={3}",
                                         patientICN, siteNumber, String.Join("^", groupIENs), securityToken);
                    }
                    else
                    {
                        url += BaseUrl.TrimEnd('/') + string.Format("/ROIWebApp/token/restservices/roi/queue/icn/{0}/{1}/{2}/{3}?securityToken={4}",
                                         patientICN, siteNumber, String.Join("^", groupIENs), target, securityToken);
                    }

                    DebugOrTraceLogRequestUrlBody("Submitting ROI request.", url);
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        response.EnsureSuccessStatusCode();

                        using (StreamReader reader = new StreamReader(response.Content.ReadAsStreamAsync().Result))
                        {
                            text = reader.ReadToEnd();
                        }
                    }
                }
                DebugOrTraceLogResponse("Submitting ROI request complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error submitting ROI request.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string GetCaptureUsers(string vixSecurityToken, string fromDate, string throughDate)
        {
            try
            {
                string captureUsers = string.Empty;

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = BaseUrl.TrimEnd('/') + string.Format("/ViewerImagingWebApp/token/restservices/viewerImagingQA/getCaptureUsers?appFlag=C&fromDate={0}&throughDate={1}&securityToken={2}", fromDate, throughDate, vixSecurityToken);

                    DebugOrTraceLogRequestUrlBody("Retrieving capture users.", url);
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        using (StreamReader reader = new StreamReader(response.Content.ReadAsStreamAsync().Result))
                        {
                            captureUsers = reader.ReadToEnd();
                        }
                    }
                }
                DebugOrTraceLogResponse("Retrieving capture users complete.", captureUsers);
                return captureUsers;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting capture users.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string GetImageFilters(string vixSecurityToken, string userId)
        {
            try
            {
                string imageFilters = string.Empty;

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = BaseUrl.TrimEnd('/') + string.Format("/ViewerImagingWebApp/token/restservices/viewerImagingFilter/getImageFilters?securityToken={0}&userId={1}", vixSecurityToken, userId);

                    DebugOrTraceLogRequestUrlBody("Retrieving image filters users.", url);
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", Guid.NewGuid().ToString());
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        using (StreamReader reader = new StreamReader(response.Content.ReadAsStreamAsync().Result))
                        {
                            imageFilters = reader.ReadToEnd();
                        }
                    }
                }
                DebugOrTraceLogResponse("Retrieving image filters complete.", imageFilters);
                return imageFilters;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting image filters.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string GetImageFilterDetails(string vixSecurityToken, string filterIEN)
        {
            try
            {
                string imageFilterDetails = string.Empty;

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = BaseUrl.TrimEnd('/') + string.Format("/ViewerImagingWebApp/token/restservices/viewerImagingFilter/getImageFilterDetail?securityToken={0}&filterIen={1}", vixSecurityToken, filterIEN);
                    string transactionId = Guid.NewGuid().ToString();
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", transactionId);
                    DebugOrTraceLogRequestUrlTransaction("Retrieving image filter details.", url, transactionId);
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        using (StreamReader reader = new StreamReader(response.Content.ReadAsStreamAsync().Result))
                        {
                            imageFilterDetails = reader.ReadToEnd();
                        }
                    }
                }
                DebugOrTraceLogResponse("Retrieving image filter details complete.", imageFilterDetails);
                return imageFilterDetails;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting image filter details.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string SetImageProperties(string vixSecurityToken, dynamic imgArgs)
        {
            var text = "";
            try
            {
                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                                | DecompressionMethods.Deflate,
                    Credentials = this.Credentials
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = string.Format("{0}/ViewerImagingWebApp/token/restservices/viewerImagingQA/setImageProperties?securityToken={1}",
                                               BaseUrl.TrimEnd('/'), vixSecurityToken);
                    ////VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    //client.DefaultRequestHeaders.Add("xxx-transaction-id", Guid.NewGuid().ToString());

                    // format request body
                    // format image property request

                    string imageProps = string.Empty;
                    var imageArguments = new Dictionary<String, Object>(imgArgs as IDictionary<String, Object>);
                    if (imageArguments == null)
                    {
                        throw new NullReferenceException("Input image properties are empty");
                    }

                    if (imageArguments.ContainsKey("props"))
                    {
                        imageProps = imageArguments["props"] as string;
                    }

                    if (string.IsNullOrEmpty(imageProps))
                    {
                        throw new NullReferenceException("Input image properties are invalid or empty");
                    }

                    var content = new StringContent(imageProps, Encoding.UTF8, "application/xml");
                    DebugOrTraceLogRequestUrlBody("Setting image properties with POST.", url, content.ToString());
                    using (HttpResponseMessage response = client.PostAsync(url, content).Result)
                    {
                        response.EnsureSuccessStatusCode();

                        text = response.Content.ReadAsStringAsync().Result;
                    }
                }
                DebugOrTraceLogResponse("Setting image properties complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error Setting image properties.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string GetImageProperties(string vixSecurityToken, string imageIEN)
        {
            try
            {
                string imageProperties = string.Empty;

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = BaseUrl.TrimEnd('/') + string.Format("/ViewerImagingWebApp/token/restservices/viewerImagingQA/getImageProperties?securityToken={0}&imageIEN={1}&props=*&flags=EI", vixSecurityToken, imageIEN);
                    string transactionId = Guid.NewGuid().ToString();
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", transactionId);
                    DebugOrTraceLogRequestUrlTransaction("Retrieving image properties.", url, transactionId);
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        using (StreamReader reader = new StreamReader(response.Content.ReadAsStreamAsync().Result))
                        {
                            imageProperties = reader.ReadToEnd();
                        }
                    }
                }
                DebugOrTraceLogResponse("Retrieving image properties complete.", imageProperties);
                return imageProperties;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting image properties.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string SearchStudy(string vixSecurityToken, string siteId, string studyFilter)
        {
            var text = "";
            try
            {
                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                                | DecompressionMethods.Deflate,
                    Credentials = this.Credentials
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = string.Format("{0}/ViewerStudyWebApp/token/restservices/study/viewer/qareview/{1}?securityToken={2}",
                                               BaseUrl.TrimEnd('/'), siteId, vixSecurityToken);
                    ////VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    //client.DefaultRequestHeaders.Add("xxx-transaction-id", Guid.NewGuid().ToString());

                    var content = new StringContent(studyFilter.ToString(), Encoding.UTF8, "application/xml");
                    DebugOrTraceLogRequestUrlBody("Searching study with POST.", url, content.ToString());
                    using (HttpResponseMessage response = client.PostAsync(url, content).Result)
                    {
                        response.EnsureSuccessStatusCode();

                        text = response.Content.ReadAsStringAsync().Result;
                    }
                }
                DebugOrTraceLogResponse("Searching study with POST complete.", text);
                return text;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error Searching study.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string GetQAReviewReportStat(string vixSecurityToken, string flags, string fromDate, string throughDate)
        {
            try
            {
                string qaReport = string.Empty;

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = BaseUrl.TrimEnd('/') + string.Format("/ViewerImagingWebApp/token/restservices/viewerImagingQA/getQAReviewReportStat?flags={0}&fromDate={1}&throughDate={2}&mque=Q&securityToken={3}", flags, fromDate, throughDate, vixSecurityToken);
                    string transactionId = Guid.NewGuid().ToString();
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", transactionId);
                    DebugOrTraceLogRequestUrlTransaction("Retrieving QA report statistic.", url, transactionId);
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        using (StreamReader reader = new StreamReader(response.Content.ReadAsStreamAsync().Result))
                        {
                            qaReport = reader.ReadToEnd();
                        }
                    }
                }
                DebugOrTraceLogResponse("Retrieving QA report statistic complete.", qaReport);
                return qaReport;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting QA report statistic.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public string GetQAReviewReports(string vixSecurityToken, string userId)
        {
            try
            {
                string userQAReports = string.Empty;

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = BaseUrl.TrimEnd('/') + string.Format("/ViewerImagingWebApp/token/restservices/viewerImagingQA/getQAReviewReports?securityToken={0}&userId={1}", vixSecurityToken, userId);
                    string transactionId = Guid.NewGuid().ToString();
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", transactionId);
                    DebugOrTraceLogRequestUrlTransaction("Retrieving user QA report statistic.", url, transactionId);
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        using (StreamReader reader = new StreamReader(response.Content.ReadAsStreamAsync().Result))
                        {
                            userQAReports = reader.ReadToEnd();
                        }
                    }
                }
                DebugOrTraceLogResponse("Retrieving user QA report statistic complete.", userQAReports);
                return userQAReports;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting user QA report statistic.", "Exception", ex.ToString());

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public void DownloadDisclosure(string securityToken, string patientId, string guid, Stream outputStream)
        {
            try
            {
                if (string.IsNullOrEmpty(patientId) || patientId == null || string.IsNullOrEmpty(guid) || guid == null)
                {
                    throw new NullReferenceException("Input download properties are invalid or empty");
                }

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = BaseUrl.TrimEnd('/') + string.Format("/ROIWebApp/disclosure?patientId={0}&guid={1}", patientId, guid);
                    string transactionId = Guid.NewGuid().ToString();
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", transactionId);
                    DebugOrTraceLogRequestUrlTransaction("Getting disclosure.", url, transactionId);
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        response.EnsureSuccessStatusCode();

                        using (Stream stream = response.Content.ReadAsStreamAsync().Result)
                        {
                            stream.CopyTo(outputStream);
                        }
                    }
                }
                DebugOrTraceLogResponse("Getting disclosure complete.");
                return;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error downloading disclosure.", "Exception", ex.Message);

                if ((ex is WebException) && ((ex as WebException).Status == WebExceptionStatus.Timeout))
                {
                    throw new VixTimeoutException();
                }

                throw;
            }
        }

        public dynamic GetImageEditOptions(string securityToken, string indexes)
        {
            List<string> typeList = indexes.Split('^').ToList();
            var editOptions = new Dictionary<string, string>();
            foreach (var type in typeList)
            {
                editOptions[type.Split('|')[0]] = GetEditOptions(securityToken, type);
            }

            return editOptions;
        }

        public string GetEditOptionUrl(string type)
        {
            string url = BaseUrl.TrimEnd('/') + string.Format("/IndexTermWebApp/token/restservices/indexTerms");
            string[] indexes = type.Split('|');
            switch (indexes[0])
            {
                case "origin":
                    url += "/origins";
                    break;
                case "type":
                    url += "/types";
                    break;
                case "specsubspec":
                    url += "/specialties" + (indexes.Length > 1 ? string.Format("/{0}", indexes[1]) : "");
                    break;
                case "procedureevent":
                    url += "/procedureevents" + (indexes.Length > 1 ? string.Format("/{0}", indexes[1]) : "");
                    break;
                case "statusreason":
                    url = BaseUrl.TrimEnd('/') + string.Format("/ViewerImagingWebApp/token/restservices/viewerImaging/getStatusReasons");
                    break;
            }
            return url;
        }

        public string GetEditOptions(string securityToken, string type)
        {
            string editOptions = "";
            try
            {
                if (string.IsNullOrEmpty(type) || type == null)
                {
                    throw new NullReferenceException("Image edit options input is invalid or empty");
                }

                using (HttpClient client = new HttpClient(new HttpClientHandler
                {
                    AutomaticDecompression = DecompressionMethods.GZip
                                             | DecompressionMethods.Deflate
                })
                {
                    Timeout = TimeSpan.FromSeconds(120.0)
                })
                {
                    string url = GetEditOptionUrl(type) + string.Format("?securityToken={0}", securityToken);
                    string transactionId = Guid.NewGuid().ToString();
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    client.DefaultRequestHeaders.Add("xxx-transaction-id", transactionId);
                    DebugOrTraceLogRequestUrlTransaction("Getting image edit option.", url, transactionId);
                    using (HttpResponseMessage response = client.GetAsync(url).Result)
                    {
                        response.EnsureSuccessStatusCode();

                        using (StreamReader reader = new StreamReader(response.Content.ReadAsStreamAsync().Result))
                        {
                            editOptions = reader.ReadToEnd();
                        }
                    }
                }
                DebugOrTraceLogResponse("Getting image edit options complete.", editOptions);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting image edit options.", "Exception", ex.Message);
            }
            return editOptions;
        }

        //VAI-397
        private void DebugOrTraceLogRequestUrlBody(string phrase, string url, string body = "", [CallerMemberName] string memberName = "")
        {
            if (_Logger.IsTraceEnabled)
            {
                if (string.IsNullOrWhiteSpace(body))
                    _Logger.Trace("Sending Request.", "C#Method", memberName, "url", url);
                else
                    _Logger.Trace("Sending Request.", "C#Method", memberName, "url", url, "body", body);
            }
            else if (_Logger.IsDebugEnabled)
            {
                if (string.IsNullOrWhiteSpace(body))
                    _Logger.Debug(phrase, "url", url, "body", body);
                else
                    _Logger.Debug(phrase, "url", url);
            }
        }

        private void DebugOrTraceLogRequestUrlTransaction(string phrase, string url, string transactionId = "", [CallerMemberName] string memberName = "")
        {
            if (_Logger.IsTraceEnabled)
            {
                if (string.IsNullOrWhiteSpace(transactionId))
                    _Logger.Trace("Sending Request.", "C#Method", memberName, "url", url);
                else
                    _Logger.Trace("Sending Request.", "C#Method", memberName, "url", url, "transactionId", transactionId);
            }
            else if (_Logger.IsDebugEnabled)
            {
                if (string.IsNullOrWhiteSpace(transactionId))
                    _Logger.Debug(phrase, "url", url, "transactionId", transactionId);
                else
                    _Logger.Debug(phrase, "url", url);
            }
        }

        private void DebugOrTraceLogRequest(string phrase, WebRequest request, [CallerMemberName] string memberName = "", string body = "")
        {
            if (_Logger.IsTraceEnabled)
            {
                TraceLogRequest(request, memberName, body);
            }
            else if (_Logger.IsDebugEnabled)
            {
                _Logger.Debug(phrase, "request.RequestUri", request.RequestUri);
            }
        }

        private void TraceLogRequest(WebRequest request, string memberName, string body)
        {
            if (!_Logger.IsTraceEnabled)
                return;

            try
            {
                string headers = "";
                List<string> ls = ParseHeaderKeysRequest(request.Headers);
                ls.ForEach(s => headers = headers + " [" + s + "]");

                #region maskForLogging

                string jsonString = Credentials.ToJsonLogLine();
                dynamic properties = JsonConvert.DeserializeObject(jsonString);
                string maskedCredentials = "(null)";
                if (properties != null)
                {
                    foreach (JProperty prop in properties)
                    {
                        if (prop.Name.Contains("Password"))
                        {
                            prop.Value = CryptoUtil.EncryptAES(prop.Value.ToString());
                        }
                    }
                    maskedCredentials = JsonConvert.SerializeObject(properties);
                }
                #endregion maskForLogging

                string requestLog;
                if (string.IsNullOrWhiteSpace(body))
                {
                    requestLog = string.Format("HttpMethod = {0}, URL = {1}, Headers.Count = {2}, Headers = {3}, Masked Credentials = {4}",
                        request.Method, request.RequestUri, ls.Count, headers, maskedCredentials);
                }
                else
                {
                    requestLog = string.Format("HttpMethod = {0}, URL = {1}, Headers.Count = {2}, Headers = {3}, Masked Credentials = {4}, Body = {5}",
                        request.Method, request.RequestUri, ls.Count, headers, maskedCredentials, body);
                }

                _Logger.Trace("Sending Request.", "C#Method", memberName, "Request parts", requestLog);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error recording request.", "Exception", ex.ToString());
            }
        }

        private static List<string> ParseHeaderKeysRequest(WebHeaderCollection headers)
        {
            List<string> ls = new List<string>();
            for (int i = 0; i < headers.Count; ++i)
            {
                string key = headers.GetKey(i);
                ls.Add(headers.GetKey(i) + " = " + headers.GetValues(i).FirstOrDefault());
            }
            return ls;
        }

        private void DebugOrTraceLogResponse(string phrase, string response = "", long ms = -1, [CallerMemberName] string memberName = "")
        {
            if (_Logger.IsTraceEnabled)
            {
                TraceLogResponse(response, memberName, ms);
            }
            else if (_Logger.IsDebugEnabled)
            {
                if (ms != -1)
                    _Logger.Debug(phrase, "Duration", TimeSpan.FromMilliseconds(ms).ToString(@"mm\:ss\.fff"));
                else
                    _Logger.Debug(phrase);
            }
        }

        private void TraceLogResponse(string response, string memberName, long ms)
        {
            if (!_Logger.IsTraceEnabled)
                return;
            try
            {
                if (!string.IsNullOrWhiteSpace(response))
                {
                    if (ms == -1)
                        _Logger.Trace("Received Response.", "C#Method", memberName, "Response", response);
                    else
                        _Logger.Trace("Received Response.", "C#Method", memberName, "Response", response, "Duration", TimeSpan.FromMilliseconds(ms).ToString(@"mm\:ss\.fff"));
                }
                else
                {
                    if (ms == -1)
                        _Logger.Trace("Received Response.", "C#Method", memberName);
                    else
                        _Logger.Trace("Received Response.", "C#Method", memberName, "Duration", TimeSpan.FromMilliseconds(ms).ToString(@"mm\:ss\.fff"));
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error recording response.", "Exception", ex.ToString());
            }
        }
    }
}
