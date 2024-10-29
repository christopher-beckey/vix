using Hydra.Entities;
using Hydra.IX.Common;
using Hydra.Log;
using Ionic.Zip;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Hydra.IX.Client
{
    public class HixConnection
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private readonly double httpClientTimeoutSeconds = 120.0;
        private IHixAuthentication _HixAuthentication = null;

        public string BaseAddress { get; private set; }

        internal HixConnection(string baseAddress, IHixAuthentication hixAuthentication)
        {
            BaseAddress = baseAddress;
            _HixAuthentication = hixAuthentication;
        }

        private HttpClient GetHttpClient()
        {
            HttpClient client = new HttpClient(new HttpClientHandler
            {
                AutomaticDecompression = DecompressionMethods.GZip
                                         | DecompressionMethods.Deflate
            })
            {
                Timeout = TimeSpan.FromSeconds(httpClientTimeoutSeconds),
                BaseAddress = new Uri(BaseAddress)
            };

            if (_HixAuthentication != null)
            {
                _HixAuthentication.PrepareClient(client);
            }

            return client;
        }

        private void ProcessMessageResponse(HttpResponseMessage response)
        {
            if (_HixAuthentication != null)
            {
                _HixAuthentication.ProcessResult(response);
            }
        }

        //public void CreateImage(string imageGroupUid, string fileName, Hydra.Common.FileType fileType, string refImageUid, string tag, out string imageUid)
        //{
        //    imageUid = null;

        //    using (var client = GetHttpClient())
        //    {
        //        var imageData = new List<NewImageData>();
        //        imageData.Add(new NewImageData
        //            {
        //                FileName = fileName,
        //                FileType = fileType
        //            });

        //        var response = CreateImages(client, imageGroupUid, refImageUid, tag, imageData);

        //        imageUid = response[0].ImageUid;
        //    }
        //}

        public List<NewImageResponse> CreateImages(string imageGroupUid, string refImageUid, string tag, List<NewImageData> imageData, bool isOwner)
        {
            using (var client = GetHttpClient())
            {
                return CreateImages(client, imageGroupUid, refImageUid, tag, imageData, isOwner);
            }
        }

        public ImageRecord GetImageRecord(string imageUid)
        {
            string url = string.Format("hix/images/{0}/record", imageUid);

            using (var client = GetHttpClient())
            {
                DebugOrTraceLogRequestUrl("Getting image record.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting image record complete.", response);
                if (response.StatusCode == HttpStatusCode.NotFound)
                    return null;
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                string data = response.Content.ReadAsStringAsync().Result;
                if (string.IsNullOrEmpty(data))
                    return null;

                var imageRecord = JsonConvert.DeserializeObject<ImageRecord>(data);
                return imageRecord;
            }
        }

        public DicomDirResponse GetDicomDirManifest(IEnumerable<string> imageGroupUids, string aeTitle, bool dicomOnly)
        {
            using (var client = GetHttpClient())
            {
                var dicomDirRequest = new DicomDirRequest
                {
                    GroupUids = imageGroupUids.ToArray(),
                    AETitle = aeTitle,
                    KeepFileNames = false,
                    DicomOnly = dicomOnly
                };

                var payload = JsonConvert.SerializeObject(dicomDirRequest);
                var content = new StringContent(payload, Encoding.UTF8, "application/json");
                string url = "hix/groups/dicomdir";
                DebugOrTraceLogRequestUrl("Getting DICOM menifest with POST.", url);
                HttpResponseMessage response = client.PostAsync(url, content).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting DICOM menifest complete.", response);
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }

                string data = response.Content.ReadAsStringAsync().Result;
                var dicomDirReponse = JsonConvert.DeserializeObject<DicomDirResponse>(data);
                if ((dicomDirReponse == null))
                {
                    throw new Exception("Internal Error. Reponse not valid");
                }

                //if (!string.IsNullOrEmpty(dicomDirReponse.Base64Manifest))
                //    dicomDirReponse.RawManifest = Convert.FromBase64String(dicomDirReponse.Base64Manifest);

                return dicomDirReponse;
            }
        }

        public void CreateDicomDirZip(IEnumerable<string> imageGroupUids, string aeTitle, bool dicomOnly, Stream outputStream)
        {
            ZipOutputStream zipOutputStream = new ZipOutputStream(outputStream, true);

            // get dicomdir manifest
            var dicomDirManifest = GetDicomDirManifest(imageGroupUids, aeTitle, dicomOnly);

            // save raw manifest as DicomDir
            if (!string.IsNullOrEmpty(dicomDirManifest.Base64Manifest))
            {
                byte[] rawManifest = Convert.FromBase64String(dicomDirManifest.Base64Manifest);
                zipOutputStream.PutNextEntry("DICOMDIR");
                zipOutputStream.Write(rawManifest, 0, rawManifest.Length);
            }

            if (dicomDirManifest.FileList != null)
            {
                using (var client = GetHttpClient())
                {
                    foreach (var file in dicomDirManifest.FileList)
                    {
                        Stream inputStream = null;
                        GetImage(file.ImageUid, (stream, statusCode, contentType, headers) =>
                        {
                            if (statusCode == (int)HttpStatusCode.OK)
                            {
                                inputStream = new MemoryStream();
                                stream.CopyTo(inputStream);
                                inputStream.Seek(0, SeekOrigin.Begin);
                            }
                            else
                            {
                                throw new Exception(string.Format("Failed to retrieve image {0}", file.ImageUid));
                            }
                        });

                        zipOutputStream.PutNextEntry(file.DestinationFilePath);
                        inputStream.CopyTo(zipOutputStream);
                    }
                }
            }

            zipOutputStream.Flush();
            zipOutputStream.Close();
        }

        private List<NewImageResponse> CreateImages(HttpClient httpClient, string imageGroupUid, string refImageUid, string tag, List<NewImageData> imageData, bool isOwner)
        {
            var imageRequest = new NewImageRequest
            {
                GroupUid = imageGroupUid,
                RefImageUid = refImageUid,
                Tag = tag,
                ImageData = imageData,
                IsOwner = isOwner
            };

            var payload = JsonConvert.SerializeObject(imageRequest);
            var content = new StringContent(payload, Encoding.UTF8, "application/json");
            string url = "hix/images";
            DebugOrTraceLogRequestUrl("Create images with POST.", url);
            HttpResponseMessage response = httpClient.PostAsync(url, content).Result;
            ProcessMessageResponse(response);
            DebugOrTraceLogResponse("Create images with POST complete.", response);
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception(response.ToString());
            }

            string data = response.Content.ReadAsStringAsync().Result;
            var imageReponse = JsonConvert.DeserializeObject<List<NewImageResponse>>(data);
            if ((imageReponse == null) || (imageReponse.Count == 0))
            {
                throw new Exception("Internal Error. Reponse not valid");
            }

            return imageReponse;
        }


        public void CreateImageGroup(NewImageGroupRequest imageGroupRequest, out string imageGroupUid)
        {
            using (var client = GetHttpClient())
            {
                CreateImageGroupRecord(client, imageGroupRequest, out imageGroupUid);
            }
        }

        //public void CreateImageGroup(string parentImageGroupUid, string name, string tag, out string imageGroupUid)
        //{
        //    using (var client = GetHttpClient())
        //    {
        //        var imageGroupRequest = new NewImageGroupRequest
        //        {
        //            ParentGroupUid = parentImageGroupUid,
        //            Name = name,
        //            Tag = tag
        //        };
        //        CreateImageGroupRecord(client, imageGroupRequest, out imageGroupUid);
        //    }
        //}

        private void CreateImageGroupRecord(HttpClient httpClient, NewImageGroupRequest imageGroupRequest, out string imageGroupUid)
        {
            imageGroupUid = null;

            var payload = JsonConvert.SerializeObject(imageGroupRequest);
            var content = new StringContent(payload, Encoding.UTF8, "application/json");
            string url = "hix/groups";
            DebugOrTraceLogRequestUrl("Creating image group record with POST.", url);
            HttpResponseMessage response = httpClient.PostAsync(url, content).Result;
            ProcessMessageResponse(response);
            DebugOrTraceLogResponse("Creating image group record with POST complete.", response);
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception(response.ToString());
            }

            string data = response.Content.ReadAsStringAsync().Result;
            NewImageGroupResponse imageGroupReponse = JsonConvert.DeserializeObject<NewImageGroupResponse>(data);
            if (imageGroupReponse == null)
            {
                throw new Exception("Internal Error. Reponse not valid");
            }

            if (imageGroupUid != null)
                imageGroupUid = imageGroupReponse.GroupUid;
        }

        public void MoveImageGroup(string imageGroupUid, string parentImageGroupUid)
        {
            using (var client = GetHttpClient())
            {
                var updateImageGroupRequest = new UpdateImageGroupRequest
                {
                    ParentGroupUid = parentImageGroupUid,
                };

                var payload = JsonConvert.SerializeObject(updateImageGroupRequest);
                var content = new StringContent(payload, Encoding.UTF8, "application/json");
                string url = string.Format("hix/groups/{0}", imageGroupUid);
                DebugOrTraceLogRequestUrl("Moving image group with POST.", url);
                HttpResponseMessage response = client.PutAsync(url, content).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Moving image group with POST complete.", response);
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }

                string data = response.Content.ReadAsStringAsync().Result;
                NewImageGroupResponse imageGroupReponse = JsonConvert.DeserializeObject<NewImageGroupResponse>(data);
                if (imageGroupReponse == null)
                {
                    throw new Exception("Internal Error. Reponse not valid");
                }
            }
        }

        public void DeleteImageGroup(string imageGroupUid)
        {
            using (var client = GetHttpClient())
            {
                string url = string.Format("hix/groups/{0}", imageGroupUid);
                DebugOrTraceLogRequestUrl("Deleting image group with DELETE.", url);
                HttpResponseMessage response = client.DeleteAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Deleting image group with DELETE complete.", response);
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }
            }
        }

        public void DeleteDisplayContext(string contextId)
        {
            using (var client = GetHttpClient())
            {
                string url = string.Format("hix/dispctx/{0}", contextId);
                DebugOrTraceLogRequestUrl("Deleting display context with DELETE.", url);
                HttpResponseMessage response = client.DeleteAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Deleting display context with DELETE complete.", response);
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }
            }
        }

        //public void StoreFile(string imageGroupUid, string path, Hydra.Common.FileType fileType, string refImageUid, string tag, out string imageUid)
        //{
        //    // create image record first
        //    string fileName = Path.GetFileName(path);
        //    CreateImage(imageGroupUid, fileName, fileType, refImageUid, tag, out imageUid);

        //    UploadImageFile(imageUid, path);
        //}

        //private void StoreFile(HttpClient httpClient, string imageGroupUid, string path, bool isBlob, string refImageUid, string tag, out string imageUid)
        //{
        //    // create image record first
        //    string fileName = Path.GetFileName(path);
        //    CreateImage(httpClient, imageGroupUid, fileName, isBlob, refImageUid, tag, out imageUid);

        //    using (var fileStream = File.OpenRead(path))
        //    {
        //        UploadImageFile(httpClient, fileStream, imageUid, fileName);
        //    }
        //}

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

        public void UploadImageFile(string imageUid, string path)
        {
            using (var fileStream = File.OpenRead(path))
            {
                using (var client = GetHttpClient())
                {
                    UploadImageFile(client, fileStream, imageUid, Path.GetFileName(path));
                }
            }
        }

        public void UploadImageFile(string imageUid, Stream stream, string fileName)
        {
            using (var client = GetHttpClient())
            {
                UploadImageFile(client, stream, imageUid, fileName);
            }
        }

        private void UploadImageFile(HttpClient httpClient, Stream stream, string imageUid, string fileName)
        {
            var content = new MultipartFormDataContent();
            content.Add(CreateFileContent(stream, fileName));

            // store image
            string url = String.Format("hix/images/{0}", imageUid);
            DebugOrTraceLogRequestUrl("Uploading image file with POST.", url);
            HttpResponseMessage response = httpClient.PostAsync(url, content).Result;
            DebugOrTraceLogResponse("Uploading image file with POST complete.", response);
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception(response.ToString());
            }
        }

        public void ProcessImageFile(string imageUid, string filePath)
        {
            using (var httpClient = GetHttpClient())
            {
                var content = new StringContent(filePath, Encoding.UTF8, "text/plain");

                // store image
                string url = String.Format("hix/images/{0}/process", imageUid);
                DebugOrTraceLogRequestUrl("Processing image file with POST.", url);
                HttpResponseMessage response = httpClient.PostAsync(url, content).Result;
                DebugOrTraceLogResponse("Processing image file with POST complete.", response);
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }
            }
        }

        public void GetImage(string imageUid, Action<Stream, int, string, HttpHeaders> responseDelegate)
        {
            GetImagePart(new ImagePartRequest { ImageUid = imageUid, Type = Hydra.Common.ImagePartType.Original },
                         responseDelegate);
        }

        public void GetImagePart(ImagePartRequest imagePartRequest, Action<Stream, int, string, HttpHeaders> responseDelegate)
        {
            string url = string.Format("hix/cache/{0}/part?format={1}&framenumber={2}&transform={3}{4}&excludeImageInfo={5}",
                string.IsNullOrEmpty(imagePartRequest.ImageUid) ? "*" : imagePartRequest.ImageUid, imagePartRequest.Type, imagePartRequest.FrameNumber, imagePartRequest.Transform,
                    string.IsNullOrEmpty(imagePartRequest.GroupUid) ? "" : "&groupUid=" + imagePartRequest.GroupUid, imagePartRequest.ExcludeImageInfo);

            if (imagePartRequest.ECGParams != null)
            {
                url += string.Format("&drawtype={0}&gridtype={1}&gridcolor={2}&signalthickness={3}&gain={4}&extraleads={5}",
                    imagePartRequest.ECGParams.DrawType, imagePartRequest.ECGParams.GridType,
                    imagePartRequest.ECGParams.GridColor, imagePartRequest.ECGParams.SignalThickness,
                    imagePartRequest.ECGParams.Gain, imagePartRequest.ECGParams.ExtraLeads);
            }

            using (var client = GetHttpClient())
            {
                HttpResponseMessage response=null;
                client.Timeout = TimeSpan.FromMinutes(15); //Needs more time to get image parts

                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                client.DefaultRequestHeaders.Add("cachelocator", imagePartRequest.CacheLocator);
                DebugOrTraceLogRequestUrl("Getting image part.", url);

                try
                {
                    response = client.GetAsync(url).Result; //If this failes, it also corrupts the communications with SignalR
                }
                catch (Exception ex)
                {
                    string msg = string.Format("GetImagePart url error. [{0}][{1}]", ex.Message.ToString(), url);
                    DebugOrTraceLogResponse(msg, response );
                    throw;
                }
           
                
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting image part complete.", response);

                Stream stream = null;
                string mediaType = null;
                if (response.IsSuccessStatusCode)
                {
                    stream = response.Content.ReadAsStreamAsync().Result;
                    //mediaType = (response.Content.Headers.ContentType != null)? response.Content.Headers.ContentType.MediaType : "application/dicom";
                }

                responseDelegate(stream, (int)response.StatusCode, mediaType, response.Headers);
            }
        }

        public ImageGroupStatus GetImageGroupStatus(string imageGroupUid)
        {
            string url = string.Format("hix/groups/{0}/status", imageGroupUid);

            using (var client = GetHttpClient())
            {
                DebugOrTraceLogRequestUrl("Getting image group status.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting image group status complete.", response);
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                string data = response.Content.ReadAsStringAsync().Result;
                ImageGroupStatus imageGroupStatus = JsonConvert.DeserializeObject<ImageGroupStatus>(data);
                if (imageGroupStatus == null)
                {
                    throw new Exception("Internal Error. Reponse not valid");
                }

                return imageGroupStatus;
            }
        }

        public ImageGroupDetails GetImageGroupDetails(string imageGroupUid)
        {
            string url = string.Format("hix/groups/{0}/data", imageGroupUid);

            using (var client = GetHttpClient())
            {
                DebugOrTraceLogRequestUrl("Getting image group details.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting image group details complete.", response);
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                string data = response.Content.ReadAsStringAsync().Result;
                ImageGroupDetails result = JsonConvert.DeserializeObject<ImageGroupDetails>(data);
                if (result == null)
                {
                    throw new Exception("Internal Error. Reponse not valid");
                }

                return result;
            }
        }

        public ImageGroupRecord GetImageGroupRecord(string imageGroupUid)
        {
            string url = string.Format("hix/groups/{0}", imageGroupUid);

            using (var client = GetHttpClient())
            {
                DebugOrTraceLogRequestUrl("Getting image group record.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting image group record complete.", response);
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                string data = response.Content.ReadAsStringAsync().Result;
                ImageGroupRecord imageGroupRecord = JsonConvert.DeserializeObject<ImageGroupRecord>(data);
                if (imageGroupRecord == null)
                {
                    throw new Exception("Internal Error. Reponse not valid");
                }

                return imageGroupRecord;
            }
        }

        public DisplayContextRecord GetDisplayContextRecord(string displayContextId)
        {
            string url = string.Format("hix/dispctx/{0}", displayContextId);

            using (var client = GetHttpClient())
            {
                DebugOrTraceLogRequestUrl("Getting display context record.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting display context record complete.", response);
                if (response.StatusCode == HttpStatusCode.NotFound)
                    return null;
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                string data = response.Content.ReadAsStringAsync().Result;
                if (string.IsNullOrEmpty(data))
                    return null;

                DisplayContextRecord displayContextRecord = JsonConvert.DeserializeObject<DisplayContextRecord>(data);
                return displayContextRecord;
            }
        }

        public SearchDisplayContextResponse SearchDisplayContexts(SearchDisplayContextRequest searchDisplayContextRequest)
        {
            string url = string.Format("hix/dispctx?PageIndex={0}&PageSize={1}{2}",
                                        searchDisplayContextRequest.PageIndex,
                                        searchDisplayContextRequest.PageSize,
                                        string.IsNullOrEmpty(searchDisplayContextRequest.ParentGroupUid) ? "" : "&ParentGroupUid=" + searchDisplayContextRequest.ParentGroupUid);

            using (var client = GetHttpClient())
            {
                DebugOrTraceLogRequestUrl("Searching display contexts.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Searching display contexts complete.", response);
                if (response.StatusCode == HttpStatusCode.NotFound)
                    return null;
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                string data = response.Content.ReadAsStringAsync().Result;
                if (string.IsNullOrEmpty(data))
                    return null;

                var searchDisplayContextResponse = JsonConvert.DeserializeObject<SearchDisplayContextResponse>(data);
                return searchDisplayContextResponse;
            }
        }

        private void CreateDisplayContextRecord(HttpClient httpClient, NewDisplayContextRequest displayContextRequest)
        {
            var payload = JsonConvert.SerializeObject(displayContextRequest);
            var content = new StringContent(payload, Encoding.UTF8, "application/json");
            string url = "hix/dispctx";
            DebugOrTraceLogRequestUrl("Creating display context record with POST.", url);
            HttpResponseMessage response = httpClient.PostAsync(url, content).Result;
            ProcessMessageResponse(response);
            DebugOrTraceLogResponse("Creating display context record with POST complete.", response);
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception(response.ToString());
            }
        }

        public void CreateDisplayContextRecord(NewDisplayContextRequest displayContextRequest)
        {
            using (var client = GetHttpClient())
            {
                CreateDisplayContextRecord(client, displayContextRequest);
            }
        }

        //public string CreateDicomDirJob(string imageGroupUid, DicomDirPackageType packageType, bool dicomOnly = false)
        //{
        //    string url = string.Format("hix/dicomdir/{0}", imageGroupUid);
        //    var requestContent = new DicomDirRequest
        //    {
        //        PackageType = packageType,
        //        DicomOnly = dicomOnly
        //    };

        //    var payload = JsonConvert.SerializeObject(requestContent);
        //    var content = new StringContent(payload, Encoding.UTF8, "application/json");

        //    using (var client = GetHttpClient())
        //    {
        //        HttpResponseMessage response = client.PostAsync(url, content).Result;
        //        ProcessMessageResponse(response);
        //        if (!response.IsSuccessStatusCode)
        //            throw new Exception(response.ToString());

        //        string data = response.Content.ReadAsStringAsync().Result;

        //        return data;
        //    }
        //}

        public System.Drawing.Image GetAbstract(string imageUid)
        {
            System.Drawing.Image abstractImage = null;
            var imagePartRequest = new ImagePartRequest
            {
                ImageUid = imageUid,
                Type = Hydra.Common.ImagePartType.Abstract,
                FrameNumber = -1,
                Transform = Hydra.Common.ImagePartTransform.Jpeg
            };

            GetImagePart(imagePartRequest, (stream, statusCode, contentType, headers) =>
            {
                if (statusCode == (int)HttpStatusCode.OK)
                {
                    var memoryStream = new MemoryStream();
                    {
                        stream.CopyTo(memoryStream);
                        abstractImage = System.Drawing.Image.FromStream(memoryStream);
                    }
                }
            });

            return abstractImage;
        }

        //public bool SaveImageAs(string imageUid, string filePath)
        //{
        //    bool result = false;

        //    GetImagePart(new ImagePartRequest { ImageUid = imageUid, Type = Hydra.Common.ImagePartType.Original },
        //                 (stream, statusCode, contentType, headers) =>
        //                 {
        //                    if (statusCode == (int) HttpStatusCode.OK)
        //                    {
        //                        using (var fileStream = File.Create(filePath))
        //                        {
        //                            stream.CopyTo(fileStream);
        //                        }

        //                        result = true;
        //                    }
        //                 });

        //    return result;
        //}

        public string GetMediaUrl(string imageUid, string transform = null)
        {
            string url = string.Format("{0}/hix/cache/{1}/part?format=Media&framenumber=-1", BaseAddress.TrimEnd('/'), imageUid);
            if (string.IsNullOrEmpty(transform))
                transform = "Mp4";
            url += string.Format("&transform={0}", transform);

            if (_HixAuthentication != null)
            {
                _HixAuthentication.PrepareUrl(ref url);
            }

            return url;
        }

        public string GetAudioUrl(string imageUid)
        {
            string url = string.Format("{0}/hix/cache/{1}/part?format=Media&transform=Mp3", BaseAddress.TrimEnd('/'), imageUid);

            if (_HixAuthentication != null)
            {
                _HixAuthentication.PrepareUrl(ref url);
            }

            return url;
        }

        public string GetPreference(string context, string key = null, string userId = null, string application = null)
        {
            var url = GetPreferenceUrl(context, key, userId, application);

            using (var client = GetHttpClient())
            {
                DebugOrTraceLogRequestUrl("Getting preference.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                DebugOrTraceLogResponse("Getting preference complete.", response);
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                return response.Content.ReadAsStringAsync().Result;
            }
        }

        private string GetPreferenceUrl(string context, string key, string userId, string application, string action = null)
        {
            var sb = new StringBuilder();
            sb.Append("hix/prefs");

            if (!string.IsNullOrEmpty(action))
                sb.Append(@"/" + action);
            sb.Append("?");

            string ampersand = null;
            if (!string.IsNullOrEmpty(context))
            {
                sb.Append(string.Format("{0}Context={1}", ampersand, context));
                ampersand = "&";
            }
            if (!string.IsNullOrEmpty(key))
            {
                sb.Append(string.Format("{0}Key={1}", ampersand, key));
                ampersand = "&";
            }
            if (!string.IsNullOrEmpty(userId))
            {
                sb.Append(string.Format("{0}UserId={1}", ampersand, userId));
                ampersand = "&";
            }
            if (!string.IsNullOrEmpty(application))
            {
                sb.Append(string.Format("{0}App={1}", ampersand, application));
                ampersand = "&";
            }

            string url = sb.ToString();

            if (_HixAuthentication != null)
            {
                _HixAuthentication.PrepareUrl(ref url);
            }

            return url;
        }

        public void PutPreference(string context, object value, string key = null, string userId = null, string application = null)
        {
            var url = GetPreferenceUrl(context, key, userId, application);

            using (var client = GetHttpClient())
            {
                var payload = JsonConvert.SerializeObject(value);
                var content = new StringContent(payload, Encoding.UTF8, "application/json");

                HttpResponseMessage response = client.PostAsync("url", content).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }
            }
        }

        public void ClearPreference(string context, string key = null, string userId = null, string application = null)
        {
            var url = GetPreferenceUrl(context, key, userId, application, "clear");

            using (var client = GetHttpClient())
            {
                HttpResponseMessage response = client.PostAsync("url", null).Result;
                ProcessMessageResponse(response);
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }
            }
        }

        public void CreateEventLogRecord(EventLogRequest eventLogRequest)
        {
            using (var client = GetHttpClient())
            {
                var payload = JsonConvert.SerializeObject(eventLogRequest);
                var content = new StringContent(payload, Encoding.UTF8, "application/json");

                HttpResponseMessage response = client.PostAsync("hix/events", content).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }
            }
        }

        public void SetImageRecordError(string imageUid, string error)
        {
            using (var client = GetHttpClient())
            {
                var content = new StringContent(error, Encoding.UTF8, "text/plain");

                HttpResponseMessage response = client.PostAsync(string.Format("hix/images/{0}/error", imageUid), content).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }
            }
        }

        public List<EventLogItem> GetEvents(int? pageSize, int? pageIndex)
        {
            using (var client = GetHttpClient())
            {
                string url = string.Format("hix/events?pageSize={0}&pageIndex={1}", pageSize, pageIndex);
                DebugOrTraceLogRequestUrl("Getting events.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                DebugOrTraceLogResponse("Getting events complete.", response);
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                string data = response.Content.ReadAsStringAsync().Result;
                if (string.IsNullOrEmpty(data))
                    return null;

                return JsonConvert.DeserializeObject<List<EventLogItem>>(data);
            }
        }

        public void AddDictionaryRecord(string name, string value)
        {
            using (var client = GetHttpClient())
            {
                HttpResponseMessage response = client.PostAsync(string.Format("hix/dict/{0}", name), new StringContent(value)).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }
            }
        }

        public string GetDictionaryRecord(string name)
        {
            using (var client = GetHttpClient())
            {
                string url = string.Format("hix/dict/{0}", name);
                DebugOrTraceLogRequestUrl("Getting disctionary record.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting disctionary record complete.", response);
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                return response.Content.ReadAsStringAsync().Result;
            }
        }

        public string[] SearchDictionaryRecords(string name)
        {
            using (var client = GetHttpClient())
            {
                string url = string.Format("hix/dict/{0}/search", name);
                DebugOrTraceLogRequestUrl("Searching dictionary records.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Searching dictionary records complete.", response);
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                string data = response.Content.ReadAsStringAsync().Result;
                if (string.IsNullOrEmpty(data))
                    return null;

                return JsonConvert.DeserializeObject<string[]>(data);
            }
        }

        public void DeleteDictionaryRecord(string name)
        {
            using (var client = GetHttpClient())
            {
                HttpResponseMessage response = client.DeleteAsync(string.Format("hix/dict/{0}", name)).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }
            }
        }

        public void PurgeCache()
        {
            using (var client = GetHttpClient())
            {
                HttpResponseMessage response = client.PostAsync("hix/cache/purge", null).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }
            }
        }

        public Hydra.Log.LogSettings GetLogSettings()
        {
            using (var client = GetHttpClient())
            {
                string url = "hix/service/log/settings";
                DebugOrTraceLogRequestUrl("Getting log settings.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting log settings complete.", response);
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                string data = response.Content.ReadAsStringAsync().Result;
                if (string.IsNullOrEmpty(data))
                    return null;

                return JsonConvert.DeserializeObject<Hydra.Log.LogSettings>(data);
            }
        }

        public void GetLogFile(string logFileName, Action<Stream, int, string, HttpHeaders> responseDelegate)
        {
            string url = string.Format("hix/service/log/files?LogFileName={0}", logFileName);

            using (var client = GetHttpClient())
            {
                DebugOrTraceLogRequestUrl("Getting log file.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting log file complete.", response);

                Stream stream = null;
                string mediaType = null;
                if (response.IsSuccessStatusCode)
                {
                    stream = response.Content.ReadAsStreamAsync().Result;
                    //mediaType = (response.Content.Headers.ContentType != null)? response.Content.Headers.ContentType.MediaType : "application/dicom";
                }

                responseDelegate(stream, (int)response.StatusCode, mediaType, response.Content.Headers);
            }
        }

        public LogSettingsResponse GetLogEvents(string logFileName, int pageSize, int pageIndex)
        {
            string url = string.Format("hix/service/log/events?LogFileName={0}&PageSize={1}&PageIndex={2}", logFileName, pageSize, pageIndex);

            using (var client = GetHttpClient())
            {
                DebugOrTraceLogRequestUrl("Getting log events.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting log events complete.", response);
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                string data = response.Content.ReadAsStringAsync().Result;
                if (string.IsNullOrEmpty(data))
                    return null;

                return JsonConvert.DeserializeObject<LogSettingsResponse>(data);
            }
        }

        public void DeleteLogFiles(string logFileName)
        {
            string url = "hix/service/log/files";
            if (!string.IsNullOrEmpty(logFileName))
                url += string.Format("?LogFileName={0}", logFileName);

            using (var client = GetHttpClient())
            {
                HttpResponseMessage response = client.DeleteAsync(url).Result;
                ProcessMessageResponse(response);
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());
            }
        }

        public void SetLogSettings(LogSettingsRequest request)
        {
            using (var client = GetHttpClient())
            {
                var payload = JsonConvert.SerializeObject(request);
                var content = new StringContent(payload, Encoding.UTF8, "application/json");

                HttpResponseMessage response = client.PostAsync("hix/service/log/settings", content).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }
            }
        }

        public string CreatePRFile(Hydra.Common.Entities.StudyPresentationState pstate)
        {
            using (var client = GetHttpClient())
            {
                var payload = JsonConvert.SerializeObject(pstate);
                var content = new StringContent(payload, Encoding.UTF8, "application/json");

                HttpResponseMessage response = client.PostAsync("hix/dispctx/pstate", content).Result;
                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception(response.ToString());
                }

                string filePath = response.Content.ReadAsStringAsync().Result;
                if (string.IsNullOrEmpty(filePath))
                    return null;

                return filePath;
            }
        }

        /// <summary>
        ///  Request the servePDF URL
        /// </summary>
        /// <returns>PDF URL</returns>
        public string RequestServePdfUrl(string contextID)//VAI-1284
        {
            using (var client = GetHttpClient())
            {
                string baseFolder = HttpUtility.UrlEncode(AppDomain.CurrentDomain.BaseDirectory);
                var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(AppDomain.CurrentDomain.BaseDirectory);
                baseFolder = System.Convert.ToBase64String(plainTextBytes);
                string url = $"hix/service/servepdfurl/{contextID}&{baseFolder}";

                DebugOrTraceLogRequestUrl("Processing serve PDF request.", "url", url);
                try
                {
                    client.Timeout = TimeSpan.FromMinutes(10); 
                    HttpResponseMessage response = client.GetAsync(url).Result;

                    ProcessMessageResponse(response);
                    DebugOrTraceLogResponse("Serve PDF request complete.", response);

                    if (!response.IsSuccessStatusCode)
                        throw new Exception(response.ToString());
                            
                    string pdfFileName = response.Content.ReadAsStringAsync().Result.Replace("\"", "").Replace(@"\\", @"\");
                    return pdfFileName;
                }
                catch (Exception ex )
                {
                    _Logger.Error("Error requesting PDF document.", "Exception", ex.ToString());
                    return string.Empty;
                }
            }
        }

        /// <summary>
        /// Request the PDF file from render service. Called by session.js via SignalR Hub
        /// </summary>    
        /// <returns>Response</returns>
        public string RequestPdfBuild(string imageUid)//VAI-307
        {
            using (var client = GetHttpClient())
            {
                string baseFolder = HttpUtility.UrlEncode(AppDomain.CurrentDomain.BaseDirectory);
                var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(AppDomain.CurrentDomain.BaseDirectory);
                baseFolder = System.Convert.ToBase64String(plainTextBytes);

                string url = string.Format("hix/service/pdffile/{0}&{1}", imageUid, baseFolder);

                DebugOrTraceLogRequestUrl("Getting PDF from VR", url);
                try
                {
                    client.Timeout = TimeSpan.FromMinutes(10); //Big TIFFs can take a while
                    HttpResponseMessage response = client.GetAsync(url).Result;

                    ProcessMessageResponse(response);
                    DebugOrTraceLogResponse("RequestPdfBuild", response);
                    if (!response.IsSuccessStatusCode)
                        throw new Exception(response.ToString());
                            
                    string pdfFile = response.Content.ReadAsStringAsync().Result.Replace("\"", "").Replace(@"\\", @"\");
                    DebugOrTraceLogRequestUrl("Received PDF from VR", "OK");
                    return (pdfFile);
                }
                catch (Exception ex )
                {
                    string msg = string.Format("Error requesting pdf data {0}", ex.Message);
                    DebugOrTraceLogRequestUrl("Error Requesting Pdf Build from VR", msg);
                    return (msg);
                }
                     
            }
        }

        public string GetStatus()
        {
            using (var client = GetHttpClient())
            {
                string url = "hix/service/status";
                DebugOrTraceLogRequestUrl("Getting status.", url);
                HttpResponseMessage response = client.GetAsync(url).Result;
                ProcessMessageResponse(response);
                DebugOrTraceLogResponse("Getting status complete.", response);
                if (!response.IsSuccessStatusCode)
                    throw new Exception(response.ToString());

                return response.Content.ReadAsStringAsync().Result;
            }
        }

        private void DebugOrTraceLogRequestUrl(string phrase, string url, [CallerMemberName] string memberName = "")
        {
            if (_Logger.IsTraceEnabled)
            {
                _Logger.Trace("Sending Request.", "C#Method", memberName, "url", url);
            }
            else if (_Logger.IsDebugEnabled)
            {
                _Logger.Debug(phrase, "url", url);
            }
        }


        private void DebugOrTraceLogResponse(string phrase, HttpResponseMessage response = null, long ms = -1, [CallerMemberName] string memberName = "")
        {
            string statusDescription = phrase;
            if (response != null)
            {
                int statusNumber = (int)response.StatusCode;
                statusDescription = $"{phrase} {statusNumber}: {response.ReasonPhrase}.";
                
            }
            if (_Logger.IsTraceEnabled)
            {
                TraceLogResponse(statusDescription, memberName, ms);
            }
            else if (_Logger.IsDebugEnabled)
            {
                if (ms != -1)
                    _Logger.Debug(statusDescription, "Duration", TimeSpan.FromMilliseconds(ms).ToString(@"mm\:ss\.fff"));
                else
                    _Logger.Debug(statusDescription);
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
