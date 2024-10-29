using Hydra.IX.Common;
using Nancy;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Web.Modules
{
    public class ProxyHixRequestHandler : IHixRequestHandler
    {
        private readonly double httpClientTimeoutSeconds = 120.0;

        public string BaseAddress { get; private set; }

        public ProxyHixRequestHandler(string hixUrl)
        {
            BaseAddress = hixUrl;
        }

        private HttpClient GetHttpClient()
        {
            HttpClient client = new HttpClient()
            {
                Timeout = TimeSpan.FromSeconds(httpClientTimeoutSeconds),
                BaseAddress = new Uri(BaseAddress)
            };

            return client;
        }

        public Nancy.Response ProcessRequest(HixRequest requestType, Nancy.NancyModule module, dynamic parameters)
        {
            switch (requestType)
            {
                case HixRequest.CreateImageGroupRecord:
                case HixRequest.CreateImageRecord:
                case HixRequest.CreateDisplayContextRecord:
                case HixRequest.CreateEventLogRecord:
                case HixRequest.SetImageRecordError:
                {
                    string text;
                    using (var reader = new StreamReader(module.Request.Body))
                    {
                        text = reader.ReadToEnd();
                    }

                    var content = new StringContent(text, Encoding.UTF8, "application/json");

                    using (var client = GetHttpClient())
                    {
                        HttpResponseMessage httpResponse = client.PostAsync(module.Request.Path, content).Result;
                        if (!httpResponse.IsSuccessStatusCode)
                        {
                            throw new Exception(httpResponse.ToString());
                        }

                        if ((requestType == HixRequest.CreateEventLogRecord) ||
                            (requestType == HixRequest.SetImageRecordError))
                            return new Response
                            {
                                StatusCode = (Nancy.HttpStatusCode)httpResponse.StatusCode
                            };

                        return new Response
                        {
                            Contents = stream =>
                            {
                                httpResponse.Content.ReadAsStreamAsync().Result.CopyTo(stream);
                            },
                            ContentType = "application/json",
                            StatusCode = (Nancy.HttpStatusCode) httpResponse.StatusCode
                        };
                    }
                }

                case HixRequest.ProcessImage:
                {
                    string text;
                    using (var reader = new StreamReader(module.Request.Body))
                    {
                        text = reader.ReadToEnd();
                    }
                    var content = new StringContent(text, Encoding.UTF8, "text/plain");

                    using (var client = GetHttpClient())
                    {
                        HttpResponseMessage httpResponse = client.PostAsync(module.Request.Path, content).Result;
                        if (!httpResponse.IsSuccessStatusCode)
                        {
                            throw new Exception(httpResponse.ToString());
                        }

                        return new Response
                        {
                            StatusCode = (Nancy.HttpStatusCode)httpResponse.StatusCode
                        };
                    }
                }

                case HixRequest.UpdateImageGroupRecord:
                {
                    string text;
                    using (var reader = new StreamReader(module.Request.Body))
                    {
                        text = reader.ReadToEnd();
                    }

                    var content = new StringContent(text, Encoding.UTF8, "application/json");

                    using (var client = GetHttpClient())
                    {
                        HttpResponseMessage httpResponse = client.PutAsync(module.Request.Path, content).Result;
                        if (!httpResponse.IsSuccessStatusCode)
                        {
                            throw new Exception(httpResponse.ToString());
                        }

                        return new Response
                        {
                            Contents = stream =>
                            {
                                httpResponse.Content.ReadAsStreamAsync().Result.CopyTo(stream);
                            },
                            ContentType = "application/json",
                            StatusCode = (Nancy.HttpStatusCode)httpResponse.StatusCode
                        };
                    }
                }

                case HixRequest.DeleteImageGroupRecord:
                case HixRequest.DeleteDisplayContextRecord:
                {
                    using (var client = GetHttpClient())
                    {
                        HttpResponseMessage httpResponse = client.DeleteAsync(module.Request.Path).Result;
                        if (!httpResponse.IsSuccessStatusCode)
                        {
                            throw new Exception(httpResponse.ToString());
                        }

                        return new Response
                        {
                            StatusCode = (Nancy.HttpStatusCode)httpResponse.StatusCode
                        };
                    }
                }

                case HixRequest.StoreImage:
                {
                    var file = module.Request.Files.FirstOrDefault();
                    if (file == null)
                        throw new Exception("No file found");

                    using (var memoryStream = new MemoryStream())
                    {
                        file.Value.CopyTo(memoryStream);
                        memoryStream.Seek(0, SeekOrigin.Begin);
                        var content = new MultipartFormDataContent();
                        content.Add(CreateFileContent(memoryStream, file.Name, "application/octet-stream"));

                        using (var client = GetHttpClient())
                        {
                            HttpResponseMessage httpResponse = client.PostAsync(module.Request.Path, content).Result;

                            return new Response
                            {
                                StatusCode = (Nancy.HttpStatusCode)httpResponse.StatusCode
                            };
                        }
                    }
                }

                case HixRequest.GetImageGroupData:
                case HixRequest.GetImageGroupRecord:
                case HixRequest.GetDisplayContextRecord:
                case HixRequest.SearchDisplayContextRecords:
                case HixRequest.GetImageGroupStatus:
                {
                    using (var client = GetHttpClient())
                    {
                        HttpResponseMessage httpResponse = client.GetAsync(module.Request.Path).Result;
                        if (!httpResponse.IsSuccessStatusCode)
                        {
                            throw new Exception(httpResponse.ToString());
                        }

                        return new Response
                        {
                            Contents = stream =>
                            {
                                httpResponse.Content.ReadAsStreamAsync().Result.CopyTo(stream);
                            },
                            ContentType = "application/json",
                            StatusCode = (Nancy.HttpStatusCode)httpResponse.StatusCode
                        };
                    }
                }

                case HixRequest.GetImagePart:
                {
                    using (var client = GetHttpClient())
                    {
                        //var url = new Uri(module.Request.Url.Path); //VAI-1336
                        var urlPath = module.Request.Url.Path + module.Request.Url.Query;
                        HttpResponseMessage httpResponse = client.GetAsync(urlPath).Result;//url.PathAndQuery).Result;
                        if (!httpResponse.IsSuccessStatusCode)
                        {
                            throw new Exception(httpResponse.ToString());
                        }

                        return new Response
                        {
                            Contents = stream =>
                            {
                                httpResponse.Content.ReadAsStreamAsync().Result.CopyTo(stream);
                            },
                            StatusCode = (Nancy.HttpStatusCode)httpResponse.StatusCode
                        };
                    }
                }

                case HixRequest.Default:
                case HixRequest.GetStatus:
                {
                    using (var client = GetHttpClient())
                    {
                        string hixStatus;

                        try
                        {
                            HttpResponseMessage httpResponse = client.GetAsync(module.Request.Path).Result;
                            if (!httpResponse.IsSuccessStatusCode)
                            {
                                throw new Exception(httpResponse.ToString());
                            }

                            hixStatus = httpResponse.Content.ReadAsStringAsync().Result;
                        }
                        catch (Exception ex)
                        {
                            hixStatus = ex.Message;
                        }

                        var stringBuilder = new StringBuilder();
                        var uri = new Uri(module.Request.Url.ToString());
                        stringBuilder.Append(string.Format("Proxy Url: {0}\r\n", uri.GetLeftPart(UriPartial.Authority)));
                        stringBuilder.Append(hixStatus);

                        return new Response
                        {
                            Contents = stream =>
                            {
                                StreamWriter writer = new StreamWriter(stream);
                                writer.Write(stringBuilder.ToString());
                                writer.Flush();
                            },
                            ContentType = "application/json",
                            StatusCode = Nancy.HttpStatusCode.OK
                        };
                    }
                }

            }

            return null;
        }

        private StreamContent CreateFileContent(Stream stream, string fileName, string contentType = null)
        {
            var fileContent = new StreamContent(stream);
            fileContent.Headers.ContentDisposition = new ContentDispositionHeaderValue("form-data")
            {
                Name = "\"files\"",
                FileName = "\"" + fileName + "\""
            };

            if (!string.IsNullOrEmpty(contentType))
                fileContent.Headers.ContentType = new MediaTypeHeaderValue(contentType);

            return fileContent;
        }

        public IEnumerable<EventLogItem> GetEventLogItems(int? pageSize, int? pageIndex)
        {
            // not implemented
            return null;
        }
    }
}
