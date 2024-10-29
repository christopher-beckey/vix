using Hydra.Web.Common;
using Ionic.Zip;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace VIX.Viewer.Service.Client
{
    public class ServiceClient
    {
        private double _httpClientTimeoutSeconds = 120.0;
        public string BaseAddress { get; set; }
        public UserCredentials UserCredentials { get; set;  } 

        public double TimeoutSeconds
        {
            get
            {
                return _httpClientTimeoutSeconds;
            }

            set
            {
                _httpClientTimeoutSeconds = value;
            }
        }

        public ServiceClient()
        {
        }

        private HttpClient GetHttpClient()
        {
            HttpClient client = new HttpClient(new HttpClientHandler
            {
                AutomaticDecompression = DecompressionMethods.GZip
                                         | DecompressionMethods.Deflate
            })
            {
                Timeout = TimeSpan.FromSeconds(_httpClientTimeoutSeconds),
                BaseAddress = new Uri(BaseAddress)
            };

            // use headers only if vix security token is not set
            if ((this.UserCredentials != null) && (string.IsNullOrEmpty(this.UserCredentials.VixSecurityToken)))
                this.UserCredentials.SetHeaders(client.DefaultRequestHeaders);

            return client;
        }

        public DisplayContextStatus CacheDisplayContext(DisplayContext displayContext)
        {
            using (var client = GetHttpClient())
            {
                string url = string.Format("/vix/viewer/context?ContextId={0}&StatusOnly=true", displayContext.ContextId);
                
                if (!string.IsNullOrEmpty(displayContext.PatientICN))
                    url += "&PatientICN=" + displayContext.PatientICN;

                if (!string.IsNullOrEmpty(displayContext.PatientDFN))
                    url += "&PatientDFN=" + displayContext.PatientDFN;

                if (!string.IsNullOrEmpty(displayContext.SiteNumber))
                    url += "&SiteNumber=" + displayContext.SiteNumber;

                if (!string.IsNullOrEmpty(UserCredentials.VixSecurityToken))
                    url += "&VixSecurityToken=" + UserCredentials.VixSecurityToken;

                HttpResponseMessage response = client.GetAsync(url).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }

                string data = response.Content.ReadAsStringAsync().Result;
                var displayContextDetails = JsonConvert.DeserializeObject<DisplayContextDetails>(data);
                if (displayContextDetails == null)
                {
                    throw new Exception("Internal Error. Reponse not valid");
                }

                return displayContextDetails.Status;
            }
        }

        public void GetImage(string imageUrn, Stream outputStream)
        {
            using (var client = GetHttpClient())
            {
                string url = string.Format("/vix/viewer/images?{0}", imageUrn);

                if (!string.IsNullOrEmpty(UserCredentials.VixSecurityToken))
                    url += "&VixSecurityToken=" + UserCredentials.VixSecurityToken;

                HttpResponseMessage response = client.GetAsync(url).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }

                var task = response.Content.CopyToAsync(outputStream);
                task.Wait();

                outputStream.Seek(0, SeekOrigin.Begin);
            }
        }

        public void CacheDisplayContext(DisplayContext displayContext, TimeSpan retryInterval, CancellationToken token, Action<DisplayContextStatus> statusDelegate)
        {
            while (true)
            {
                var status = CacheDisplayContext(displayContext);

                if (statusDelegate != null)
                    statusDelegate(status);

                if ((status.StatusCode == ContextStatusCode.Cached) ||
                    (status.StatusCode == ContextStatusCode.Error))
                {
                    break;
                }

                if ((token != null) & token.IsCancellationRequested)
                    break;

                Thread.Sleep(retryInterval.Milliseconds);
            }
        }

        public void CacheDisplayContext(IEnumerable<DisplayContext> displayContexts, TimeSpan retryInterval, CancellationToken token, Action<DisplayContext, DisplayContextStatus> statusDelegate)
        {
            Task[] tasks = new Task[displayContexts.Count()];

            int index = 0;
            foreach (var item in displayContexts)
            {
                tasks[index++] = Task.Factory.StartNew(() =>
                    {
                        while (true)
                        {
                            if ((token != null) && token.IsCancellationRequested)
                                break;

                            var status = CacheDisplayContext(item);

                            if (statusDelegate != null)
                                statusDelegate(item, status);

                            if ((status.StatusCode == ContextStatusCode.Cached) ||
                                (status.StatusCode == ContextStatusCode.Error))
                            {
                                break;
                            }

                            if ((token != null) && token.IsCancellationRequested)
                                break;

                            Thread.Sleep(retryInterval.Milliseconds);
                        }
                    });
            }

            Task.WaitAll(tasks);
        }

        public DicomDirManifest GetDicomDirManifest(IEnumerable<DisplayContext> displayContexts, string AETitle)
        {
            DisplayContext displayContext = displayContexts.First();

            using (var client = GetHttpClient())
            {
                string url = @"/vix/viewer/context/dicomdir?";
                foreach (var item in displayContexts)
                    url += string.Format("ContextId={0}&", item.ContextId);
                url = url.TrimEnd('&');

                if (!string.IsNullOrEmpty(displayContext.PatientICN))
                    url += "&PatientICN=" + displayContext.PatientICN;

                if (!string.IsNullOrEmpty(displayContext.PatientDFN))
                    url += "&PatientDFN=" + displayContext.PatientDFN;

                if (!string.IsNullOrEmpty(displayContext.SiteNumber))
                    url += "&SiteNumber=" + displayContext.SiteNumber;

                if (!string.IsNullOrEmpty(UserCredentials.VixSecurityToken))
                    url += "&VixSecurityToken=" + UserCredentials.VixSecurityToken;

                url += "&AETitle=" + AETitle;

                HttpResponseMessage response = client.GetAsync(url).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }

                string data = response.Content.ReadAsStringAsync().Result;
                var dicomDirManifest = JsonConvert.DeserializeObject<DicomDirManifest>(data);
                if (dicomDirManifest == null)
                {
                    throw new Exception("Internal Error. Reponse not valid");
                }

                return dicomDirManifest;
            }
        }

        public void CreateDicomDirZip(IEnumerable<DisplayContext> displayContexts, string AETitle, string fileName, CancellationToken token)
        {
            try
            {
                // get dicomdir manifest
                var dicomDirManifest = GetDicomDirManifest(displayContexts, AETitle);

                if (token != null)
                    token.ThrowIfCancellationRequested();

                using (ZipOutputStream zipOutputStream = new ZipOutputStream(fileName)) 
                { 
                    // save raw manifest as DicomDir
                    if (!string.IsNullOrEmpty(dicomDirManifest.Base64Manifest))
                    {
                        byte[] rawManifest = Convert.FromBase64String(dicomDirManifest.Base64Manifest);
                        zipOutputStream.PutNextEntry("DICOMDIR");
                        zipOutputStream.Write(rawManifest, 0, rawManifest.Length);
                    }

                    if (token != null)
                        token.ThrowIfCancellationRequested();

                    if (dicomDirManifest.FileList != null)
                    {
                        foreach (var file in dicomDirManifest.FileList)
                        {
                            // Note: FileName is imageUrn
                            using (var inputStream = new MemoryStream())
                            {
                                GetImage(file.FileName, inputStream);

                                zipOutputStream.PutNextEntry(file.DestinationFilePath);
                                inputStream.CopyTo(zipOutputStream);

                                if (token != null)
                                    token.ThrowIfCancellationRequested();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                if (File.Exists(fileName))
                    File.Delete(fileName);

                if (!(ex is System.OperationCanceledException))
                    throw;
            }
        }

        public DisplayContextItemCollection StudyQuery(StudyQuery studyQuery)
        {
            // create body

            using (var client = GetHttpClient())
            {
                var payload = JsonConvert.SerializeObject(studyQuery);
                var content = new StringContent(payload.ToString(), Encoding.UTF8, "application/json");

                string url = "/vix/viewer/studyquery";
                if (!string.IsNullOrEmpty(UserCredentials.VixSecurityToken))
                    url += "?VixSecurityToken=" + UserCredentials.VixSecurityToken;

                HttpResponseMessage response = client.PostAsync(url, content).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }

                string data = response.Content.ReadAsStringAsync().Result;
                var result = JsonConvert.DeserializeObject<DisplayContextItemCollection>(data, 
                                                                                            new JsonSerializerSettings()
                                                                                            {
                                                                                                ContractResolver = new CamelCasePropertyNamesContractResolver()
                                                                                            });
                if (result == null)
                {
                    throw new Exception("Internal Error. Reponse not valid");
                }

                return result;
            }
        }

    }
}
