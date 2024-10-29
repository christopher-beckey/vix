using Hydra.Common.Exceptions;
using Hydra.IX.Client;
using Hydra.IX.Common;
using Hydra.Log;
using Hydra.Security;
using Hydra.VistA;
using Hydra.VistA.Commands;
using Hydra.VistA.Parsers;
using Hydra.Web;
using Hydra.Web.Common;
using Hydra.Web.Contracts;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http.Headers;
using System.Reflection;

namespace VIX.Viewer.Service
{
    public class VistAHydraParentContext : IHydraParentContext
    {
        //VAI-707: Note that vistAQuery and vistAQuery.SecurityToken were added in many places for custom authentiation and improved security
        //For some, but not all, requests, we need to send both SecurityToken and VixJavaSecurityToken to the HIX

        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private readonly string _STATUSONLYPARAM = "StatusOnly";
        private readonly string _DEFAULTAETITLE = "NOTSPECIFIED";

        static VistAHydraParentContext()
        {
            var vixServiceElement = VistAConfigurationSection.Instance.GetVixService(VixServiceType.Render);
            if (vixServiceElement != null)
                HixConnectionFactory.HixUrl = vixServiceElement.RootUrl;
        }

        public VistAHydraParentContext()
        {
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("VistAHydraParentContext created.");
        }

        public void GetImagePart(Hydra.IX.Common.ImagePartRequest imagePartRequest, Action<Stream, int, string, HttpHeaders> responseDelegate)
        {
            var hixConnection = HixConnectionFactory.Create();
            hixConnection.GetImagePart(imagePartRequest, responseDelegate);
        }

        public DisplayContextDetails GetDisplayContext(VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.ContextId))
                throw new BadRequestException("ContextId is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting display context details.", "ContextId", vistaQuery.ContextId, "VistaQuery", vistaQuery.ToJsonLog());

            if (vistaQuery.VixHeaders != null)
            {
                if (string.IsNullOrEmpty(vistaQuery.AuthSiteNumber) &&
                    (vistaQuery.VixHeaders.Contains(VixHeaderName.SiteNumber)))
                    vistaQuery.AuthSiteNumber = vistaQuery.VixHeaders.GetValue(VixHeaderName.SiteNumber);
            }

            VixServiceUtil.Authenticate(vistaQuery);

            // get display context 
            DisplayContextDetails displayContext = GetCachedDisplayContextDetails(vistaQuery);
            if (displayContext == null)
            {
                int imageCount = 0;
                var displayObjectCollection = VixServiceUtil.GetDisplayObjectGroups(vistaQuery, out imageCount);

                CreateDisplayContextRecord(vistaQuery, displayObjectCollection);

                displayContext = GetCachedDisplayContextDetails(vistaQuery);

                // process display context
                VistAService.Instance.QueueDisplayContext(vistaQuery.ContextId, null, vistaQuery.VixJavaSecurityToken, vistaQuery.TransactionUid);
            }

            // if not caching or processing update patient information if needed
            if ((displayContext != null) &&
                ((displayContext.Status.StatusCode == ContextStatusCode.Cached) || (displayContext.Status.StatusCode == ContextStatusCode.Error)))
            {
                // check if patient information is present in the studies collection
                if ((displayContext.Studies == null) || (!displayContext.Studies.Any(item => item.Patient != null)))
                {
                    displayContext.Patient = VixServiceUtil.GetPatientInformation(vistaQuery);
                    CalculateAgeAndGender(displayContext.Patient);
                }
                else
                {
                    displayContext.Studies.ForEach(item => CalculateAgeAndGender(item.Patient));
                }
            }

            return displayContext;
        }

        private string GetSecurityTokens(VistAQuery vistaQuery)
        {
            return vistaQuery.VixJavaSecurityToken; //currently, all HIX calls use the VIX Java Security Token
            //this is a way we can send both in the future without having to change all the method calls on the HIX side with one central handler to split
            //if (string.IsNullOrWhiteSpace(vistaQuery.VixJavaSecurityToken))
            //    return vistaQuery.SecurityToken;
            //else
            //    return $"{vistaQuery.VixJavaSecurityToken}_DELIM_{vistaQuery.SecurityToken}";
        }

        public void CacheDisplayContext(VistAQuery vistaQuery, string requestBody)
        {
            // Note: authenticating via api token only
            if (vistaQuery.VixHeaders != null)
            {
                if (string.IsNullOrEmpty(vistaQuery.VixJavaSecurityToken) &&
                    (vistaQuery.VixHeaders.Contains(VixHeaderName.SecurityToken)))
                    vistaQuery.VixJavaSecurityToken = vistaQuery.VixHeaders.GetValue(VixHeaderName.SecurityToken);
            }
            VixServiceUtil.Authenticate(vistaQuery);

            // parse cache request object
            var displayObjectGroups = DisplayObjectParser.Parse(requestBody);

            // process each display object group (study)
            var hixConnection = HixConnectionFactory.Create();
            foreach (var displayObjectGroup in displayObjectGroups)
            {
                // check if the study is cached
                var displayContextRecord = hixConnection.GetDisplayContextRecord(displayObjectGroup.StudyId);
                if (displayContextRecord == null)
                {
                    if (_Logger.IsInfoEnabled)
                        _Logger.Info("Caching display context.", "ContextId", displayObjectGroup.StudyId);

                    // not cached. get metadata using vix
                    var storedDisplayObjectGroup = VixServiceUtil.GetDisplayObjectGroups(displayObjectGroup.StudyId,
                                                                                         displayObjectGroup.PatientICN,
                                                                                         displayObjectGroup.PatientDFN,
                                                                                         displayObjectGroup.SiteNumber,
                                                                                         vistaQuery.VixJavaSecurityToken);
                    if (storedDisplayObjectGroup != null)
                    {
                        if ((displayObjectGroup.Items == null) || (displayObjectGroup.Items.Count == 0))
                        {
                            // no images passed, create display context using metadata
                            List<DisplayObjectGroup> tempList = new List<DisplayObjectGroup>();
                            tempList.Add(displayObjectGroup);
                            CreateDisplayContextRecord(vistaQuery, storedDisplayObjectGroup);

                            // process display context
                            VistAService.Instance.QueueDisplayContext(displayObjectGroup.StudyId, null, vistaQuery.VixJavaSecurityToken, vistaQuery.TransactionUid);
                        }
                        else
                        {
                            // create display context with no images first, and then append images.
                            // this approach is useful for testing
                            CreateDisplayContextRecord(vistaQuery, storedDisplayObjectGroup, excludeImages: true);

                            displayContextRecord = hixConnection.GetDisplayContextRecord(displayObjectGroup.StudyId);
                            if (displayContextRecord != null)
                            {
                                var imageGroupRecord = hixConnection.GetImageGroupRecord(displayContextRecord.GroupUid);
                                if (imageGroupRecord != null)
                                {
                                    // create image records
                                    var imageRecords = AddDisplayObjects(imageGroupRecord.GroupUid, displayObjectGroup.Items);

                                    // start uploading images
                                    VistAService.Instance.QueueDisplayContext(displayObjectGroup.StudyId,
                                                                              imageRecords,
                                                                              GetSecurityTokens(vistaQuery), 
                                                                              vistaQuery.TransactionUid);
                                }
                                else
                                {
                                    // todo
                                }
                            }
                            else
                            {
                                // todo
                            }
                        }
                    }
                    else
                    {
                        if (_Logger.IsWarnEnabled)
                            _Logger.Warn("Unable to cache display context.", "ContextId", displayObjectGroup.StudyId);
                    }
                }
                else
                {
                    // already cached. 
                    if ((displayObjectGroup.Items == null) || (displayObjectGroup.Items.Count == 0))
                    {
                        if (_Logger.IsInfoEnabled)
                            _Logger.Info("Display context is already cached.", "ContextId", displayObjectGroup.StudyId);

                        // no images to cache. 
                        continue;
                    }

                    var imageGroupRecord = hixConnection.GetImageGroupRecord(displayContextRecord.GroupUid);
                    if (imageGroupRecord != null)
                    {
                        // remove images that have already been cached.
                        if (imageGroupRecord.Images != null)
                        {
                            displayObjectGroup.Items.RemoveAll(x => 
                                        (imageGroupRecord.Images.Any(y => 
                                            string.Compare(y.ExternalImageId, x.ImageIEN, true) == 0)));
                        }

                        // exit, if no images to cache
                        if (displayObjectGroup.Items.Count == 0)
                        {
                            if (_Logger.IsInfoEnabled)
                                _Logger.Info("No new images to cache.", "ContextId", displayObjectGroup.StudyId);

                            continue;
                        }

                        // create image records
                        var imageRecords = AddDisplayObjects(imageGroupRecord.GroupUid, displayObjectGroup.Items);

                        if (_Logger.IsInfoEnabled)
                            _Logger.Info("Caching new images.", "ContextId", displayObjectGroup.StudyId, "ImageCount", imageRecords.Count());

                        // start uploading images
                        VistAService.Instance.QueueDisplayContext(displayObjectGroup.StudyId, 
                                                                  imageRecords,
                                                                  GetSecurityTokens(vistaQuery),
                                                                  vistaQuery.TransactionUid);
                    }
                    else
                    {
                        // todo
                    }
                }
            }
        }

        private void CalculateAgeAndGender(Hydra.Entities.Patient patient)
        {
            try
            {
                if (patient != null)
                {
                    switch (patient.Sex.ToLower())
                    {
                        case "m":
                        case "male":
                            patient.Sex = "M";
                            break;
                        case "f":
                        case "female":
                            patient.Sex = "F";
                            break;
                    }
                    if (patient.dob != null)
                    {
                        DateTime dateOfBirth = Convert.ToDateTime(patient.dob);
                        int age = 0;
                        age = DateTime.Now.Year - dateOfBirth.Year;
                        if (DateTime.Now.DayOfYear < dateOfBirth.DayOfYear)
                            age = age - 1;
                        patient.Age = age.ToString();
                    }
                }
            }
            catch (Exception)
            {
            }
        }

        private DisplayContextDetails GetCachedDisplayContextDetails(VistAQuery vistaQuery)
        {
            var hixConnection = HixConnectionFactory.Create();
            var displayContextRecord = hixConnection.GetDisplayContextRecord(vistaQuery.ContextId);
            if (displayContextRecord == null)
                return null;

            var displayContext = new DisplayContextDetails();

            // check for StatusOnly field
            if (vistaQuery.RequestParams != null) //VAI-707: check if null before use
            {
                object value = null;
                vistaQuery.RequestParams.TryGetValue(_STATUSONLYPARAM, out value);
                bool statusOnly = ((value != null) && (value is string) && (string.Compare(value as string, "true", true) == 0));

                if (!statusOnly)
                {
                    var imageGroupDetails = hixConnection.GetImageGroupDetails(displayContextRecord.GroupUid);
                    if (imageGroupDetails != null)
                    {
                        displayContext.Studies = imageGroupDetails.Studies;
                        displayContext.Images = imageGroupDetails.Images;
                        displayContext.Blobs = imageGroupDetails.Blobs;
                    }

                    value = null;
                    if (vistaQuery.RequestParams != null) //VAI-707: check for null before use
                    {
                        vistaQuery.RequestParams.TryGetValue("Selected", out value);
                        string imageUid = ((value != null) && (value is string)) ? value as string : null;
                        if (!string.IsNullOrEmpty(imageUid))
                            displayContext.SelectedUid = imageUid;

                        value = null;
                        vistaQuery.RequestParams.TryGetValue("PrefOption", out value);
                        string prefOption = ((value != null) && (value is string)) ? value as string : null;
                        if (!string.IsNullOrEmpty(prefOption))
                        {
                            if (prefOption.IndexOf("layouts", StringComparison.OrdinalIgnoreCase) > -1)
                            {
                                try
                                {
                                    displayContext.DisplayPref = GetDictionaryItem("user", "layouts", vistaQuery);
                                }
                                catch (Exception ex)
                                {
                                    _Logger.Error("Error reading layout preferences.", "Exception", ex.ToString());
                                }
                            }
                        }
                    }
                }
            }

            // get cached status
            var displayContextStatus = new DisplayContextStatus();
            var imageGroupStatus = hixConnection.GetImageGroupStatus(displayContextRecord.GroupUid);
            if (imageGroupStatus != null)
            {
                if ((imageGroupStatus.ImagesUploaded + imageGroupStatus.ImagesUploadFailed) == imageGroupStatus.ImageCount)
                {
                    if ((imageGroupStatus.ImagesProcessed + imageGroupStatus.ImagesFailed) >= (imageGroupStatus.ImageCount - imageGroupStatus.ImagesUploadFailed))
                        displayContextStatus.StatusCode = ContextStatusCode.Cached;
                    else
                        displayContextStatus.StatusCode = ContextStatusCode.Processing;
                }
                else
                {
                    // still uploading
                    displayContextStatus.StatusCode = ContextStatusCode.Caching;
                }

                displayContextStatus.TotalImageCount = imageGroupStatus.ImageCount;
                displayContextStatus.ImagesProcessed = imageGroupStatus.ImagesProcessed;
                displayContextStatus.ImagesUploaded = imageGroupStatus.ImagesUploaded;
                displayContextStatus.ImagesFailed = imageGroupStatus.ImagesFailed;
                displayContextStatus.ImagesUploadFailed = imageGroupStatus.ImagesUploadFailed;
            }
            else
            {
                displayContextStatus.StatusCode = ContextStatusCode.Error;
            }

            displayContext.Status = displayContextStatus;

            return displayContext;
        }

        private IEnumerable<ImageRecord> AddDisplayObjects(string imageGroupUid, List<DisplayObject> displayObjects)
        {
            var images = new List<NewImageData>();
            foreach (var displayObject in displayObjects)
            {
                images.Add(new NewImageData
                    {
                        FileName = displayObject.Path,
                        FileType = VixServiceUtil.DetectFileType(displayObject.Path),
                        Description = displayObject.Description,
                        ExternalImageId = displayObject.ImageIEN
                    });
            }

            var hixConnection = HixConnectionFactory.Create();
            var newImageResponse = hixConnection.CreateImages(imageGroupUid, null, null, images, true);

            var imageRecords = new List<ImageRecord>();
            foreach (var newImage in newImageResponse)
            {
                imageRecords.Add(new ImageRecord
                    {
                        ImageUid = newImage.ImageUid,
                        FileName = newImage.FileName,
                        IsUploaded = false
                    });
            }

            return imageRecords;
        }

        private void CreateDisplayContextRecord(VistAQuery vistAQuery, List<DisplayObjectGroup> displayObjectGroups, bool excludeImages = false)
        {
            NewDisplayContextRequest newDisplayContextRequest = new NewDisplayContextRequest
            {
                ContextId = vistAQuery.ContextId,
                ImageDataGroupList = new List<NewImageDataGroup>()
            };

            foreach (var item in displayObjectGroups)
            {
                var newImageDataGroup = new NewImageDataGroup
                {
                    StudyId = item.StudyId,
                    StudyDescription = item.StudyDescription,
                    StudyDateTime = item.StudyDateTime,
                    PatientDescription = item.PatientDescription,
                    ImageData = new List<NewImageData>(),
                    IsOwner = true
                };

                if (!excludeImages)
                {
                    foreach (var displayObject in item.Items)
                    {
                        var newImageData = new NewImageData
                        {
                            FileName = displayObject.Path,
                            FileType = VixServiceUtil.DetectFileType(displayObject.Path),
                            Description = displayObject.Description,
                            ExternalImageId = displayObject.ImageIEN
                        };

                        newImageDataGroup.ImageData.Add(newImageData);
                    }
                }

                newDisplayContextRequest.ImageDataGroupList.Add(newImageDataGroup);
            }

            var hixConnection = HixConnectionFactory.Create();
            hixConnection.CreateDisplayContextRecord(newDisplayContextRequest);
        }

        public void DeleteDisplayContext(VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.ContextId))
                throw new BadRequestException("ContextId is missing");

            MyDeleteDisplayContext(vistaQuery);
        }

        private void MyDeleteDisplayContext(VistAQuery vistaQuery)
        {
            _Logger.Info("Deleting context.", "ContextId", vistaQuery.ContextId);

            var hixConnection = HixConnectionFactory.Create();
            hixConnection.DeleteDisplayContext(vistaQuery.ContextId);
        }

        public void PrepareForDisplay(VistAQuery vistaQuery)
        {
            //VAI-373 - Add more logging for troubleshooting at run-time
            if (vistaQuery.RequestParams == null)
                _Logger.TraceVariable("VHPC-PrepareForDisplay-requestParams.Count().", 0);
            else
            {
                _Logger.TraceVariable("VHPC-PrepareForDisplay-requestParams.Count().", vistaQuery.RequestParams.Count());
                foreach (var p in vistaQuery.RequestParams)
                    _Logger.TraceVariable(p.Key, p.Value);
            }

            _Logger.TraceVariable("PatientICN", vistaQuery.PatientICN);

            if (string.IsNullOrEmpty(vistaQuery.ContextId))
                throw new BadRequestException("ContextId is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Preparing for display #2.", "ContextId", vistaQuery.ContextId, "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            var hixConnection = HixConnectionFactory.Create();
            var displayContextRecord = hixConnection.GetDisplayContextRecord(vistaQuery.ContextId);
            if (displayContextRecord == null)
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Not cached.", "ContextId", vistaQuery.ContextId);
                return;
            }

            // get image group status
            var imageGroupStatus = hixConnection.GetImageGroupStatus(displayContextRecord.GroupUid);
            if (imageGroupStatus == null)
            {
                if (_Logger.IsWarnEnabled)
                    _Logger.Warn("Purging context because ImageGroupStatus not found.", "ContextId", vistaQuery.ContextId);
                MyDeleteDisplayContext(vistaQuery);
                return;
            }

            // get image count stored in VistA
            int imageCount = 0;
            var displayObjectCollection = VixServiceUtil.GetDisplayObjectGroups(vistaQuery, out imageCount);
            if (displayObjectCollection == null)
            {
                if (_Logger.IsWarnEnabled)
                    _Logger.Warn("Purging context because GetDisplayObjectGroups not found.", "ContextId", vistaQuery.ContextId);
                MyDeleteDisplayContext(vistaQuery);
                return;
            }

            // purge cache if image count do not match
            if (imageGroupStatus.ImageCount != imageCount)
            {
                if (_Logger.IsWarnEnabled)
                    _Logger.Warn("Purging context because a change in imagecount is detected.", "ContextId", vistaQuery.ContextId, "ImageCount", imageCount, "CachedImageCount", imageGroupStatus.ImageCount);
                MyDeleteDisplayContext(vistaQuery);
            }
        }

        /// <summary>
        /// Get the ImageURN associated with the ImageUID
        /// </summary>
        /// <param name="imageUid">the ImageUID</param>
        /// <returns>The ImageURN if it was possible, otherwise Exception</returns>
        /// <remarks>Created for VAI-707</remarks>
        public string GetImageUrn(string imageUid)
        {
            if (string.IsNullOrWhiteSpace(imageUid))
                throw new BadRequestException("ImageUid is null, so cannot get ImageURN.");

            var hixConnection = HixConnectionFactory.Create();
            var imageRecord = hixConnection.GetImageRecord(imageUid);
            if (imageRecord == null)
                throw new BadRequestException("Image record not found.");

            // get image urn from image uri
            string[] parameters = imageRecord.FileName.Split(new char[] { '&' });
            foreach (var parameter in parameters)
            {
                string[] tokens = parameter.Split(new char[] { '=' });
                if ((tokens.Length == 2) && (string.Compare(tokens[0], "imageURN", true) == 0))
                {
                    return tokens[1];
                }
            }

            throw new BadRequestException($"Image Urn not found in database for ImageUid {imageUid}.");
        }

        public string GetMetadata(MetadataQuery metadataQuery)
        {
            if (string.IsNullOrEmpty(metadataQuery.ImageUid))
                throw new BadRequestException("ImageUid is missing/invalid");

            metadataQuery.ImageUrn = GetImageUrn(metadataQuery.ImageUid);

            return GetImagingDataCommand.Execute(metadataQuery);
        }

        public List<EventLogItem> GetEvents(Dictionary<string, object> requestParams)
        {
            List<EventLogItem> events = null;

            try
            {
                object value = null;
                int pageSize = -1;
                int pageIndex = -1;

                if (requestParams != null) //VAI-707: check for null before use
                {
                    requestParams.TryGetValue("pageSize", out value);
                    if (((value != null) && (value is string)))
                    {
                        int.TryParse(value as string, out pageSize);
                    }

                    requestParams.TryGetValue("pageIndex", out value);
                    if (((value != null) && (value is string)))
                    {
                        int.TryParse(value as string, out pageIndex);
                    }
                }
                var hixConnection = HixConnectionFactory.Create();
                events = hixConnection.GetEvents(pageSize, pageIndex);
            }
            catch (Exception)
            { 
            }

            if (events == null)
            {
                events = new List<EventLogItem>();
            }

            return events;
        }

        public void AddDictionaryItem(string level, string name, string value, VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("SecurityToken is missing");
            //if (string.IsNullOrEmpty(vistaQuery.AuthSiteNumber))
            //    throw new BadRequestException("AuthSiteNumber is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Adding dictionary item.", "Name", name, "Level", level);

            VixServiceUtil.Authenticate(vistaQuery);

            VixServiceUtil.StorePreference(vistaQuery, level, name, value);
        }

        public void DeleteDictionaryItem(string level, string name, VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("SecurityToken is missing");
            //if (string.IsNullOrEmpty(vistaQuery.AuthSiteNumber))
            //    throw new BadRequestException("AuthSiteNumber is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Deleting dictionary item.", "Name", name, "Level", level);

            VixServiceUtil.Authenticate(vistaQuery);

            VixServiceUtil.DeletePreference(vistaQuery, level, name);
        }

        public string GetDictionaryItem(string level, string name, VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("SecurityToken is missing");
            //if (string.IsNullOrEmpty(vistaQuery.AuthSiteNumber))
            //    throw new BadRequestException("AuthSiteNumber is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Retrieving dictionary item.", "Name", name, "Level", level);

            VixServiceUtil.Authenticate(vistaQuery);

            string value = VixServiceUtil.RetrievePreference(vistaQuery, level, name);

            if (_Logger.IsTraceEnabled)
                _Logger.Trace("Retrieving dictionary item complete.", "Name", name, "Value", value);
            else if (_Logger.IsDebugEnabled)
                _Logger.Debug("Retrieving dictionary item complete.", "Name", name);

            return value;
        }

        public void ExportDisplayContext(VistAQuery vistaQuery, Action<Stream, int, string, HttpHeaders> responseDelegate)
        {
            if (string.IsNullOrEmpty(vistaQuery.ContextId))
                throw new BadRequestException("ContextId is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Exporting display context.", "ContextId", vistaQuery.ContextId, "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            // check display context status only
            vistaQuery.RequestParams[_STATUSONLYPARAM] = true;
            var hixConnection = HixConnectionFactory.Create();

            //Note: Multiple contextIds could be passed
            string[] contextIds = vistaQuery.ContextId.Split(',');

            var groupUids = new List<string>();
            foreach (var contextId in contextIds)
            {
                var displayContext = GetCachedDisplayContextDetails(vistaQuery);
                if (displayContext == null)
                    throw new BadRequestException(string.Format("Display context {0} not found", contextId));

                if (displayContext.Status.StatusCode != ContextStatusCode.Cached)
                    throw new BadRequestException(string.Format("Display context {0} is not cached", contextId));

                // get groud uid for the cached display context.
                var displayContextRecord = hixConnection.GetDisplayContextRecord(contextId);
                if (displayContextRecord == null)
                    throw new BadRequestException(string.Format("Display context {0} is not cached. Internal error", contextId));

                groupUids.Add(displayContextRecord.GroupUid);
            }

            object value = null;
            if (vistaQuery.RequestParams != null) //VAI-707: check for null before use
                vistaQuery.RequestParams.TryGetValue("AETitle", out value);
            string aeTitle = ((value != null) && (value is string)) ? value as string : null;
            if (string.IsNullOrEmpty(aeTitle))
                aeTitle = _DEFAULTAETITLE;

            // Note: it is the responsibility of the caller to dispose the stream
            var stream = new MemoryStream();
            hixConnection.CreateDicomDirZip(groupUids, aeTitle, false, stream);
            stream.Seek(0, SeekOrigin.Begin);
            responseDelegate(stream, (int) System.Net.HttpStatusCode.OK, "application/zip, application/octet-stream", null);
        }

        public void ValidateSession(string securityToken, Dictionary<string, IEnumerable<string>> requestHeaders, string clientHostAddress)
        {
            if (PolicyUtil.IsPolicyEnabled("Security.EnablePromiscuousMode"))
                return; //session validation disabled

            if (!SessionManager.Instance.IsSessionValid(securityToken, clientHostAddress))
                throw new BadRequestException("Invalid session.");
        }

        public DicomDirManifest CreateDicomDirManifest(VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.ContextId))
                throw new BadRequestException("ContextId is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Creating Dicomdir.", "ContextId", vistaQuery.ContextId, "VistaQuery", vistaQuery.ToJsonLog());

            if (vistaQuery.VixHeaders != null)
            {
                if (string.IsNullOrEmpty(vistaQuery.AuthSiteNumber) &&
                    (vistaQuery.VixHeaders.Contains(VixHeaderName.SiteNumber)))
                    vistaQuery.AuthSiteNumber = vistaQuery.VixHeaders.GetValue(VixHeaderName.SiteNumber);
            }

            VixServiceUtil.Authenticate(vistaQuery);

            // check display context status only
            vistaQuery.RequestParams[_STATUSONLYPARAM] = true;
            var hixConnection = HixConnectionFactory.Create();

            //Note: Multiple contextIds could be passed
            string[] contextIds = vistaQuery.ContextId.Split(',');

            var groupUids = new List<string>();
            foreach (var contextId in contextIds)
            {
                var displayContext = GetCachedDisplayContextDetails(vistaQuery);
                if (displayContext == null)
                    throw new BadRequestException(string.Format("Display context {0} not found", contextId));

                if (displayContext.Status.StatusCode != ContextStatusCode.Cached)
                    throw new BadRequestException(string.Format("Display context {0} is not cached", contextId));

                // get groud uid for the cached display context.
                var displayContextRecord = hixConnection.GetDisplayContextRecord(contextId);
                if (displayContextRecord == null)
                    throw new BadRequestException(string.Format("Display context {0} is not cached. Internal error", contextId));

                groupUids.Add(displayContextRecord.GroupUid);
            }

            object value = null;
            if (vistaQuery.RequestParams != null) //VAI-707: check for null before use
                vistaQuery.RequestParams.TryGetValue("AETitle", out value);
            string aeTitle = ((value != null) && (value is string)) ? value as string : null;
            if (string.IsNullOrEmpty(aeTitle))
                aeTitle = _DEFAULTAETITLE;

            var response = hixConnection.GetDicomDirManifest(groupUids, aeTitle, false);

            var dicomDirManifest = new DicomDirManifest
            {
                Base64Manifest = response.Base64Manifest,
                FileList = new List<DicomDirManifest.File>()
            };

            if (response.FileList != null)
            {
                foreach (var item in response.FileList)
                {
                    dicomDirManifest.FileList.Add(new DicomDirManifest.File
                        {
                            DestinationFilePath = item.DestinationFilePath,
                            ImageUid = item.ImageUid,
                            FileName = item.FileName
                        });
                }
            }

            return dicomDirManifest;
        }

        public void GetImage(ImageQuery imageQuery, Action<Stream, int, string, HttpHeaders> responseDelegate)
        {
            if (string.IsNullOrEmpty(imageQuery.ImageURN) )
                throw new BadRequestException("ImageUrn is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting image.", "ImageURN", imageQuery.ImageURN, "ImageQuery", imageQuery.ToJsonLog());

            VixServiceUtil.Authenticate(imageQuery);

            var stream = new MemoryStream();
            VixServiceUtil.GetImage(imageQuery, stream);
            stream.Seek(0, SeekOrigin.Begin);
            responseDelegate(stream, (int)System.Net.HttpStatusCode.OK, "application/octet-stream", null);
        }

        private string CreatePStateKey(VistAQuery vistaQuery)
        {
            return string.Format("{0}|{1}", vistaQuery.ContextId.ToUpper(), vistaQuery.UserId);
        }

        public List<Hydra.Common.Entities.StudyPresentationState> GetPresentationStates(VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.ContextId))
                throw new BadRequestException("ContextId is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting presentation states.", "ContextId", vistaQuery.ContextId, "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            // get display context image group
            var hixConnection = HixConnectionFactory.Create();
            var displayContextRecord = hixConnection.GetDisplayContextRecord(vistaQuery.ContextId);
            if (displayContextRecord == null)
                throw new BadRequestException("ContextId record not found.");

            var imagePartRequest = new ImagePartRequest
            {
                GroupUid = displayContextRecord.GroupUid,
                Type = Hydra.Common.ImagePartType.DcmPR,
                Transform = Hydra.Common.ImagePartTransform.Json
            };

            Hydra.Common.Entities.StudyPresentationState[] dcmPRPresentationStates = null;
            try
            {
                hixConnection.GetImagePart(imagePartRequest, (stream, statusCode, contentType, httpHeaders) =>
                {
                    if (statusCode == (int)System.Net.HttpStatusCode.OK)
                    {
                        StreamReader reader = new StreamReader(stream);
                        string text = reader.ReadToEnd();

                        // serialize dcmPRText into study presentation state.
                        dcmPRPresentationStates = JsonConvert.DeserializeObject<Hydra.Common.Entities.StudyPresentationState[]>(text);
                        foreach(Hydra.Common.Entities.StudyPresentationState psState in dcmPRPresentationStates)
                        {
                            psState.ContextId = vistaQuery.ContextId;
                            psState.UserId = vistaQuery.UserId;
                        }
                    }
                });
            }
            catch (Exception ex)
            {
                _Logger.Error("Error reading Dicom presentation state.", "Exception", ex.ToString());
            }

            var pStates = VixServiceUtil.GetPresentationStateRecords(vistaQuery,
                                                                     () =>
                                                                     {
                                                                         var imageGroupRecord = hixConnection.GetImageGroupRecord(displayContextRecord.GroupUid);
                                                                         if ((imageGroupRecord != null) && (imageGroupRecord.Images != null))
                                                                            return imageGroupRecord.Images.ToDictionary(x => x.ExternalImageId, x => x.ImageUid);
                                                                         return null;
                                                                     });
            var list =  (pStates != null) ? pStates.ToList() : null;
            if (dcmPRPresentationStates != null)
            {
                var dcmPRStates = dcmPRPresentationStates;
                if (list != null)
                {
                    var dcmprIdList = dcmPRPresentationStates.Select(item => item.Id);
                    var duplicatePStates = list.Where(item => dcmprIdList.Contains(item.Id)).ToList();
                    duplicatePStates.ForEach(pstate => list.Remove(pstate));

                    var pstateIdList = duplicatePStates.Select(item => item.Id);
                    var duplicatePRStates = dcmPRPresentationStates.Where(item => pstateIdList.Contains(item.Id)).ToArray();
                    foreach (Hydra.Common.Entities.StudyPresentationState prState in duplicatePRStates)
                    {
                        var pstate = duplicatePStates.Find(item => (item.Id == prState.Id));
                        prState.Description = pstate.Description;
                        prState.UserId = pstate.UserId;
                        prState.Tooltip = pstate.Tooltip;
                    }
                    list.AddRange(duplicatePRStates);
                    dcmPRStates = dcmPRPresentationStates.Where(item => !pstateIdList.Contains(item.Id)).ToArray();
                }
                else
                {
                    list = new List<Hydra.Common.Entities.StudyPresentationState>();
                }

                list.Insert(0, CombinePRStates(hixConnection, displayContextRecord.GroupUid, dcmPRStates, vistaQuery));
            }

            return list;
        }

        private Hydra.Common.Entities.StudyPresentationState CombinePRStates(HixConnection hixConn, string groupId, Hydra.Common.Entities.StudyPresentationState[] dcmPRPresentationStates, VistAQuery vistaQuery)
        {
            Hydra.Common.Entities.StudyPresentationState dcmPRState = dcmPRPresentationStates[0];
            Hydra.Common.Entities.PresentationState[] dcmStateArr = null;
            foreach (Hydra.Common.Entities.StudyPresentationState psState in dcmPRPresentationStates)
            {

                Hydra.Common.Entities.PresentationState[] prStateArr = JsonConvert.DeserializeObject<Hydra.Common.Entities.PresentationState[]>(psState.Data,
                                                                            new JsonSerializerSettings
                                                                            {
                                                                                NullValueHandling = NullValueHandling.Ignore,
                                                                                ContractResolver = new CamelCasePropertyNamesContractResolver()
                                                                            });
                foreach (Hydra.Common.Entities.PresentationState prState in prStateArr)
                {
                    var imageGroupDetails = hixConn.GetImageGroupDetails(groupId);
                    if (imageGroupDetails != null)
                    {
                        prState.ImageId = GetPRStateImageId(imageGroupDetails, prState.ImageId);
                    }
                }
                if (dcmStateArr == null)
                    dcmStateArr = prStateArr;
                else
                    dcmStateArr = dcmStateArr.Concat(prStateArr).ToArray();
            }
            dcmPRState.Data = JsonConvert.SerializeObject(dcmStateArr,
                                                    new JsonSerializerSettings
                                                    {
                                                        NullValueHandling = NullValueHandling.Ignore,
                                                        ContractResolver = new CamelCasePropertyNamesContractResolver()
                                                    });

            return dcmPRState;
        }

        private string GetPRStateImageId(ImageGroupDetails imageGroupDetails, string sopInstanceId)
        {
            if (imageGroupDetails.Studies != null)
            {
                foreach (var study in imageGroupDetails.Studies)
                {
                    if ((study.Series != null) && (study.Series.Count > 0))
                    {
                        foreach (Hydra.Entities.Series series in study.Series)
                        {
                            if ((series.Images != null) && (series.Images.Count > 0))
                            {
                                foreach (Hydra.Entities.Image image in series.Images)
                                {
                                    // dicom PR
                                    if (image.SopInstanceUid == sopInstanceId)
                                    {
                                        return image.ImageUid;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return Guid.NewGuid().ToString();
        }

        public string AddPresentationState(VistAQuery vistaQuery, Hydra.Common.Entities.StudyPresentationState pstate)
        {
            if (string.IsNullOrEmpty(vistaQuery.ContextId))
                throw new BadRequestException("ContextId is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Adding presentation state.", "ContextId", vistaQuery.ContextId, "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            if (string.IsNullOrEmpty(pstate.Id))
            {
                string dicomOrg = PolicyUtil.GetPolicySettingsText("VIX.DicomUid.Org");
                pstate.Id = GenerateNewUid(dicomOrg);
            }

            var hixConnection = HixConnectionFactory.Create();
            string filePath = hixConnection.CreatePRFile(pstate);

            VixServiceUtil.AddUpdatePresentationStateRecord(vistaQuery, pstate, filePath);

            return pstate.Id;
        }

        private string GenerateNewUid(string dicomOrg)
        {
            //Gets date/time
            var now = DateTime.Now;

            //Gets numeric date info without year
            string zeroDate = now.Month.ToString() + now.Day.ToString() + "." + now.Hour.ToString() + now.Minute.ToString() + now.Second.ToString() + now.Millisecond.ToString();

            //Globally Unique Identifier
            string guid = new string(Guid.NewGuid().ToString().Where(char.IsDigit).ToArray());

            //Combines the strings
            string sopUid = string.Format("{0}.{1}.{2}", dicomOrg, zeroDate, guid);

            //check the length of the string to see if it's over 64 characters long, if it is, then make a substring of it that is 64 chars long starting at char index 0
            //otherwise, use the original string
            sopUid = sopUid.Length > 64 ? sopUid.Substring(0, 64) : sopUid;
            return sopUid.Trim('.');
        }

        public void DeletePresentationState(VistAQuery vistaQuery, Hydra.Common.Entities.StudyPresentationState pstate)
        {
            if (string.IsNullOrEmpty(vistaQuery.ContextId))
                throw new BadRequestException("ContextId is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Delete presentation state.", "ContextId", vistaQuery.ContextId, "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            VixServiceUtil.DeletePresentationStateRecord(vistaQuery, pstate);
        }

        public DisplayContextMetadata GetDisplayContextMetadata(VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.ContextId))
                throw new BadRequestException("ContextId is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Get display context metadata.", "ContextId", vistaQuery.ContextId, "VistaQuery", vistaQuery.ToJsonLog());
            VixServiceUtil.Authenticate(vistaQuery);

            var displayContextMetadata = VixServiceUtil.GetDisplayContextMetadata(vistaQuery);

            return displayContextMetadata;
        }

        public ImageDeleteResponse[] DeleteImageMetadata(VistAQuery vistaQuery, ImageDeleteRequest request)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Deleting image metadata.", "ContextId", vistaQuery.ContextId, "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.DeleteImageMetadata(vistaQuery, request);
        }

        public UserDetails GetUserDetails(VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Get user details.", "UserId", vistaQuery.UserId, "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            var userDetails = VixServiceUtil.GetUserDetails(vistaQuery);

            return userDetails;
        }

        public string UserClientHostAddress { get; set; }

        public string GetMetadataImageInfo(Nancy.NancyContext ctx)
        {
            MetadataQuery metadataQuery = QueryUtil.Create<MetadataQuery>(ctx);
            if (string.IsNullOrEmpty(metadataQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (string.IsNullOrEmpty(metadataQuery.ImageUrn))
                throw new BadRequestException("Image Urn not found in request");

            return GetImagingDataCommand.Execute(metadataQuery);
        }

        public void SensitiveImageMetadata(VistAQuery vistaQuery, SensitiveImageRequest request)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Sensitive image metadata.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            VixServiceUtil.SensitiveImageMetadata(vistaQuery, request);
        }       

        public List<string> GetImageDeleteReasons(VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting image delete reasons.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.GetImageDeleteReasons(vistaQuery);
        }

        public List<string> GetPrintReasons(VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting print reasons.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.GetPrintReasons(vistaQuery);
        }

        public ExternalLink[] GetExternalLinks(Dictionary<string, object> requestParams)
        {
            var list = new List<ExternalLink>();
            ExternalLink link = null;

            string externalLinkDisplay = PolicyUtil.GetPolicySettingsText("Viewer.ImageInformationLink", "Hide");
            if (string.Compare(externalLinkDisplay, "Hide", true) != 0)
            {
                link = new ExternalLink
                {
                    Name = "Image Information",
                    Path = string.Format("{0}/manage", HydraConfiguration.ViewerRoutePrefix),
                    Type = ExternalLinkType.General,
                    Display = externalLinkDisplay
                };
                list.Add(link);
            }

            externalLinkDisplay = PolicyUtil.GetPolicySettingsText("Viewer.QAReviewLink", "Hide");
            if (string.Compare(externalLinkDisplay, "Hide", true) != 0)
            {
                link = new ExternalLink
                {
                    Name = "Image QA",
                    Path = string.Format("{0}/qa", HydraConfiguration.ViewerRoutePrefix),
                    Type = ExternalLinkType.General,
                    Display = externalLinkDisplay
                };
                list.Add(link);
            }

            externalLinkDisplay = PolicyUtil.GetPolicySettingsText("Viewer.QAReportLink", "Hide");
            if (string.Compare(externalLinkDisplay, "Hide", true) != 0)
            {
                link = new ExternalLink
                {
                    Name = "Image QA Report",
                    Path = string.Format("{0}/qareport", HydraConfiguration.ViewerRoutePrefix),
                    Type = ExternalLinkType.General,
                    Display = externalLinkDisplay
                };
                list.Add(link);
            }

            externalLinkDisplay = PolicyUtil.GetPolicySettingsText("Viewer.ROIStatusLink", "Popup");
            if (string.Compare(externalLinkDisplay, "Hide", true) != 0)
            {
                link = new ExternalLink
                {
                    Name = "ROI Status",
                    Path = string.Format("{0}", VixRootPath.ROIRootPath),
                    Type = ExternalLinkType.General,
                    Display = externalLinkDisplay
                };
                list.Add(link);
            }

            externalLinkDisplay = PolicyUtil.GetPolicySettingsText("Viewer.ROISubmissionLink", "Popup");
            if (string.Compare(externalLinkDisplay, "Hide", true) != 0)
            {
                link = new ExternalLink
                {
                    Name = "ROI Submission",
                    Path = string.Format("{0}/submit", VixRootPath.ROIRootPath),
                    Type = ExternalLinkType.General,
                    Display = externalLinkDisplay
                };
                list.Add(link);
            }

            externalLinkDisplay = PolicyUtil.GetPolicySettingsText("Viewer.UserGuideLink", "New");
            if (string.Compare(externalLinkDisplay, "Hide", true) != 0)
            {
                link = new ExternalLink
                {
                    Name = "User Guide",
                    Path = $"{HydraConfiguration.ViewerRoutePrefix}/VIX_Viewer_User_Guide", //VAI-461
                    Type = ExternalLinkType.Help,
                    Display = externalLinkDisplay
                };
                list.Add(link);
            }

            return list.ToArray();
        }

        public string HelpFilePath
        {
            get
            {
                return Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "VIX_Viewer_User_Guide.pdf"); //VAI-461
            }
        }

        public void PurgeCache(VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Purging cache.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            var hixConnection = HixConnectionFactory.Create();
            hixConnection.PurgeCache();
        }

        public Hydra.IX.Common.LogSettingsResponse GetLogSettings(string application)
        {
            Hydra.IX.Common.LogSettingsResponse response = null;

            if (string.Compare(application, "VIEWER", true) == 0)
            {
                response = new Hydra.IX.Common.LogSettingsResponse
                {
                    Application = application,
                    LogLevel = LogManager.LogLevel
                };
            }
            else if (string.Compare(application, "RENDER", true) == 0)
            {
                var hixConnection = HixConnectionFactory.Create();
                var logSettings = hixConnection.GetLogSettings();

                response = new Hydra.IX.Common.LogSettingsResponse
                {
                    Application = application,
                    LogLevel = logSettings.LogLevel
                };
            }
            else
                throw new ArgumentException("Invalid application name");

            return response;
        }

        public void SetLogSettings(Hydra.IX.Common.LogSettingsRequest request)
        {
            if (string.IsNullOrEmpty(request.LogLevel))
                throw new ArgumentException("Log level is invalid");

            if (string.Compare(request.Application, "VIEWER", true) == 0)
            {
                LogManager.LogLevel = request.LogLevel;
            }
            else if (string.Compare(request.Application, "RENDER", true) == 0)
            {
                var hixConnection = HixConnectionFactory.Create();
                hixConnection.SetLogSettings(request);
            }
            else
                throw new ArgumentException("Invalid application name");
        }

        public Hydra.IX.Common.LogSettingsResponse GetLogFiles(string application)
        {
            Hydra.IX.Common.LogSettingsResponse response = null;

            if (string.Compare(application, "VIEWER", true) == 0)
            {
                response = new Hydra.IX.Common.LogSettingsResponse
                {
                    Application = application,
                    LogFileItems = LogManager.GetLogFiles()
                };
            }
            else if (string.Compare(application, "RENDER", true) == 0)
            {
                var hixConnection = HixConnectionFactory.Create();
                var logSettings = hixConnection.GetLogSettings();

                response = new Hydra.IX.Common.LogSettingsResponse
                {
                    Application = application,
                    LogFileItems = logSettings.LogFileItems
                };
            }
            else
                throw new ArgumentException("Invalid application name");

            return response;
        }

        public void GetLogFile(string application, string logFileName, Action<Stream, int, string, HttpHeaders> responseDelegate)
        {
            if (string.Compare(application, "VIEWER", true) == 0)
            {
                var stream = new FileStream(LogManager.GetLogFilePath(logFileName), FileMode.Open, FileAccess.Read);
                responseDelegate(stream, (int) System.Net.HttpStatusCode.OK, "application/text", null);
            }
            else if (string.Compare(application, "RENDER", true) == 0)
            {
                var hixConnection = HixConnectionFactory.Create();
                hixConnection.GetLogFile(logFileName, responseDelegate);
            }
            else
                throw new ArgumentException("Invalid application name");
        }

        public Hydra.IX.Common.LogSettingsResponse GetLogEvents(string application, string logFileName, int pageSize, int pageIndex)
        {
            Hydra.IX.Common.LogSettingsResponse response = null;

            if (string.Compare(application, "VIEWER", true) == 0)
            {
                bool more = false;
                response = new Hydra.IX.Common.LogSettingsResponse
                {
                    Application = application,
                    LogEventItems = LogManager.GetLogItems(logFileName, pageSize, pageIndex, out more)
                };
                response.More = more;
            }
            else if (string.Compare(application, "RENDER", true) == 0)
            {
                var hixConnection = HixConnectionFactory.Create();
                var logResponse = hixConnection.GetLogEvents(logFileName, pageSize, pageIndex);

                response = new Hydra.IX.Common.LogSettingsResponse
                {
                    Application = application,
                    LogEventItems = logResponse.LogEventItems,
                    More = logResponse.More
                };
            }
            else
                throw new ArgumentException("Invalid application name");

            return response;
        }

        public void DeleteLogFiles(string application, string logFileName)
        {
            if (string.Compare(application, "VIEWER", true) == 0)
            {
                LogManager.DeleteLogFiles(logFileName);
            }
            else if (string.Compare(application, "RENDER", true) == 0)
            {
                var hixConnection = HixConnectionFactory.Create();
                hixConnection.DeleteLogFiles(logFileName);
            }
            else
                throw new ArgumentException("Invalid application name");
        }

        public IDictionary<string, string> GetServiceStatus()
        {
            var status = new Dictionary<string, string>();

            // viewer vix
            var viewerVix = VistAConfigurationSection.Instance.GetVixService(VixServiceType.Viewer);
            if (viewerVix != null)
            {
                status["VIEWER.RootUrl"] = viewerVix.RootUrl;

                if (!string.IsNullOrEmpty(viewerVix.PublicHostName))
                    status["VIEWER.PublicHostName"] = viewerVix.PublicHostName;

                if (!string.IsNullOrEmpty(viewerVix.TrustedClientRootUrl))
                    status["VIEWER.TrustedClientRootUrl"] = viewerVix.TrustedClientRootUrl;
            }

            // local vix
            var localVix = VistAConfigurationSection.Instance.GetVixService(VixServiceType.Local);
            if (localVix != null)
            {
                status["VIEWER.LocalVixUrl"] = localVix.RootUrl;
                status["VIEWER.LocalVixVersion"] = VixServiceUtil.GetVixVersion();
            }

            // process
            status["VIEWER.MemoryUsageKB"] = Hydra.Common.ProcessUtil.GetMemoryUsageKB().ToString();


            // get render service status
            try
            {
                var hixConnection = HixConnectionFactory.Create();
                var text = hixConnection.GetStatus();

                var renderStatus = JsonConvert.DeserializeObject<Dictionary<string, string>>(text);
                if (renderStatus != null)
                {
                    foreach (var item in renderStatus)
                    {
                        status[item.Key] = item.Value;
                    }
                }
            }
            catch (Exception)
            {
            }

            return status;
        }

        public string GetCDBurners(VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting CD burners.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.GetCDBurners(vistaQuery);
        }

        public string GetCaptureUsers(VistAQuery vistaQuery, string fromDate, string throughDate)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting capture users.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.GetCaptureUsers(vistaQuery, fromDate, throughDate);
        }

        public string GetImageFilters(VistAQuery vistaQuery, string userId)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting image filters.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.GetImageFilters(vistaQuery, userId);
        }

        public string GetImageFilterDetails(VistAQuery vistaQuery, string filterIEN)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting image filter details.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.GetImageFilterDetails(vistaQuery, filterIEN);
        }

        public string SetImageProperties(VistAQuery vistaQuery, dynamic imgArgs)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Setting image properties.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.SetImageProperties(vistaQuery, imgArgs);
        }

        public string GetImageProperties(VistAQuery vistaQuery, string imageIEN)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting image properties.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.GetImageProperties(vistaQuery, imageIEN);
        }

        public string SearchStudy(VistAQuery vistaQuery, string siteId, string studyFilter)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Searching for studies.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.SearchStudy(vistaQuery, siteId, studyFilter);
        }

        public string GetQAReviewReportStat(VistAQuery vistaQuery, string flags, string fromDate, string throughDate)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting qa report.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.GetQAReviewReportStat(vistaQuery, flags, fromDate, throughDate);
        }

        public string GetQAReviewReports(VistAQuery vistaQuery, string userId)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting user qa reports.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.GetQAReviewReports(vistaQuery, userId);
        }

        public void DownloadDisclosure(VistAQuery vistaQuery, string patientId, string guid, Action<Stream, int, string, HttpHeaders> responseDelegate)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Setting image properties.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            var stream = new MemoryStream();
            VixServiceUtil.DownloadDisclosure(vistaQuery, patientId, guid, stream);
            stream.Seek(0, SeekOrigin.Begin);
            responseDelegate(stream, (int)System.Net.HttpStatusCode.OK, "application/zip", null);
        }

        public dynamic GetImageEditOptions(VistAQuery vistaQuery, string indexes)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                throw new BadRequestException("Security token is missing");

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Setting image properties.", "VistaQuery", vistaQuery.ToJsonLog());

            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.GetImageEditOptions(vistaQuery, indexes);
        }
    }
}
