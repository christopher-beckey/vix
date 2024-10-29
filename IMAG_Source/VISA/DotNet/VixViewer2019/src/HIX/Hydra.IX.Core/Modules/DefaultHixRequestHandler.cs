using Hydra.Common.Exceptions;
using Hydra.IX.Common;
using Hydra.IX.Database.Common;
using Nancy;
using Nancy.ModelBinding;
using Nancy.Extensions;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Hydra.IX.Database;
using System.IO;
using Hydra.Log;
using Hydra.Common.Entities;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using Hydra.IX.Configuration;
using System.Threading;

namespace Hydra.IX.Core.Modules
{
    public class DefaultHixRequestHandler : IHixRequestHandler
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private IHixDbContextFactory _HixDbContextFactory = new HixDbContextFactory();

        private enum fileStatus
        {
            Complete,
            InProgress,
            NoRecords,
            MissingFile,
            NoProgress,
            NotSaved
        }
        public Response ProcessRequest(HixRequest requestType, NancyModule module, dynamic parameters)
        {
            try
            {
                switch (requestType)
                {
                    case HixRequest.CreateImageGroupRecord:
                        return CreateImageGroupRecord(module);

                    case HixRequest.CreateImageRecord:
                        return CreateImageRecord(module);

                    case HixRequest.GetImageRecord:
                        return GetImageRecord(module, parameters.imageUid);

                    case HixRequest.GetImageGroupData:
                        return GetImageGroupData(module, parameters.groupUid);

                    case HixRequest.GetImageGroupRecord:
                        return GetImageGroupRecord(module, parameters.groupUid);

                    case HixRequest.GetDisplayContextRecord:
                        return GetDisplayContextRecord(module, parameters.contextId);

                    case HixRequest.SearchDisplayContextRecords:
                        return SearchDisplayContextRecords(module);

                    case HixRequest.CreateDisplayContextRecord:
                        return CreateDisplayContextRecord(module);

                    case HixRequest.GetImageGroupStatus:
                        return GetImageGroupStatus(module, parameters.groupUid);

                    case HixRequest.GetImagePart:
                        return GetImagePart(module, parameters.imageUid);

                    case HixRequest.StoreImage:
                        return StoreImage(module, parameters.imageUid);

                    case HixRequest.ProcessImage:
                        return ProcessImage(module, parameters.imageUid);

                    case HixRequest.GetStatus:
                        return GetStatus(module);

                    case HixRequest.GetPdfFile:
                        return GetPdfFile(module, parameters.imageUid, parameters.baseDirectory);//VAI-307

                    case HixRequest.GetServePdf:
                        return GetServePdf(module, parameters.contextId, parameters.baseDirectory);//VAI-1284

                    case HixRequest.Default:
                        return GetDefault(module);

                    case HixRequest.UpdateImageGroupRecord:
                        return UpdateImageGroupRecord(module, parameters.groupUid);

                    case HixRequest.DeleteImageGroupRecord:
                        return DeleteImageGroupRecord(module, parameters.groupUid);

                    case HixRequest.DeleteDisplayContextRecord:
                        return DeleteDisplayContextRecord(module, parameters.contextId);

                    case HixRequest.CreateDicomDir:
                        return CreateDicomDir(module);

                    case HixRequest.CreateEventLogRecord:
                        return CreateEventLogRecord(module);

                    case HixRequest.SetImageRecordError:
                        return SetImageRecordError(module, parameters.imageUid);

                    case HixRequest.AddDictionaryRecord:
                        return AddDictionaryRecord(module, parameters.name);

                    case HixRequest.DeleteDictionaryRecord:
                        return DeleteDictionaryRecord(module, parameters.name);

                    case HixRequest.GetDictionaryRecord:
                        return GetDictionaryRecord(module, parameters.name);

                    case HixRequest.SearchDictionaryRecords:
                        return SearchDictionaryRecords(module, parameters.name);

                    case HixRequest.PurgeCache:
                        return PurgeCache(module);

                    case HixRequest.GetCacheStatus:
                        return GetCacheStatus(module);

                    case HixRequest.GetLogSettings:
                        return GetLogSettings(module);

                    case HixRequest.SetLogSettings:
                        return SetLogSettings(module);

                    case HixRequest.GetLogFile:
                        return GetLogFile(module);

                    case HixRequest.DeleteLogFiles:
                        return DeleteLogFiles(module);

                    case HixRequest.GetLogEvents:
                        return GetLogEvents(module);

                    case HixRequest.CreatePRFile:
                        return CreatePRFile(module);

                    default: //VAI-403: Added for robustness
                        _Logger.Error("Error invalid request.", "RequestType", requestType.ToString());
                        break;
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error processing request.", "RequestType", requestType.ToString(), "Exception", ex.ToString());
                throw;
            }

            return null;
        }

        public IEnumerable<EventLogItem> GetEventLogItems(int? pageSize, int? pageIndex)
        {
            List<EventLogItem> items = null;
            try
            {
                items = ImageWorkflow.GetEventLogItems(_HixDbContextFactory, pageSize, pageIndex);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error creating event log record.", "Exception", ex.ToString());
            }

            return items;
        }

        private Response CreateEventLogRecord(NancyModule module)
        {
            var request = module.Bind<EventLogRequest>();
            if (request == null)
                return module.BadRequest();

            try
            {
                ImageWorkflow.CreateEventLogRecord(_HixDbContextFactory, request);
                
                return module.Ok();
            }
            catch (Exception ex)
            {
                return module.Error("Error creating event log record. {0}", ex.ToString());
            }
        }

        private Response CreateDisplayContextRecord(NancyModule module)
        {
            var request = module.Bind<NewDisplayContextRequest>();
            if (request == null)
                return module.BadRequest();

            try
            {
                ImageWorkflow.CreateDisplayContextRecord(_HixDbContextFactory, request);
                return module.Ok();
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
        }

        private Response GetStatus(NancyModule module)
        {
            var dictStatus = ServiceStatus.Get(() =>
            {
                var uri = new Uri(module.Request.Url.ToString());
                return uri.GetLeftPart(UriPartial.Authority);
            });

            return module.Response.AsText(JsonConvert.SerializeObject(dictStatus));
        }

        private Response GetDefault(NancyModule module)
        {
            var stringBuilder = new StringBuilder();
            var uri = new Uri(module.Request.Url.ToString());
            stringBuilder.Append(string.Format("Hix Url: {0}\r\n", uri.GetLeftPart(UriPartial.Authority)));

            return module.Response.AsText(stringBuilder.ToString());
        }

        private Response GetImagePart(NancyModule module, string imageUid)
        {
            Hydra.IX.Common.ImagePartRequest imagePartRequest = module.Bind<Hydra.IX.Common.ImagePartRequest>();
            if (imagePartRequest == null)
                return module.BadRequest();

            if (string.IsNullOrEmpty(imagePartRequest.CacheLocator) && (module.Request != null) && (module.Request.Headers != null))
            {
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                try
                {
                    imagePartRequest.CacheLocator = module.Request.Headers["cachelocator"].FirstOrDefault();
                }
                catch
                {
                    //gracefully handle this header's non-existence in the called method below
                }
            }

            imagePartRequest.ImageUid = imageUid;

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting image part.", "ImageUid", imageUid, "Url", module.Request.Url.Path); //VAI-1336

            try
            {
                return ImageWorkflow.CreateImagePartResponse(_HixDbContextFactory, imagePartRequest, module.Request, module.Response);
            }
            catch (BadRequestException ex)
            {
                _Logger.Error("Bad Request.", "Url", module.Request.Url.Path, "Exception", ex.Message); //VAI-1336
                return module.BadRequest(ex.Message);
            }
        }

        private Response GetImageGroupRecord(NancyModule module, string groupUid)
        {
            using (var ctx = _HixDbContextFactory.Create())
            {
                var imageGroup = ctx.ImageGroups.Where(x => (x.GroupUid == groupUid)).FirstOrDefault();
                if (imageGroup == null)
                    return module.BadRequest("Image group {0} not found", groupUid);

                var imageGroupRecord = new ImageGroupRecord
                {
                    GroupUid = imageGroup.GroupUid,
                    ParentGroupUid = imageGroup.ParentGroupUid,
                    Name = imageGroup.Name
                };

                FillGroupDetails(ctx, imageGroupRecord);

                return module.Ok<ImageGroupRecord>(imageGroupRecord);
            }
        }

        private Response GetDisplayContextRecord(NancyModule module, string displayContextId)
        {
            using (var ctx = _HixDbContextFactory.Create())
            {
                var displayContext = ctx.DisplayContexts.Where(x => (x.ContextId == displayContextId)).FirstOrDefault();
                if (displayContext == null)
                    return module.NotFound("DisplayContext {0} not found", displayContextId);

                var displayContextRecord = new DisplayContextRecord
                {
                    GroupUid = displayContext.GroupUid,
                    ContextId = displayContext.ContextId,
                    Name = displayContext.Name,
                    ImageCount = displayContext.ImageCount
                };

                FillDisplayContextDetails(ctx, displayContextRecord);

                return module.Ok<DisplayContextRecord>(displayContextRecord);
            }
        }

        private Response SearchDisplayContextRecords(NancyModule module)
        {
            var request = module.Bind<SearchDisplayContextRequest>();
            if (request == null)
                return module.BadRequest();

            if (string.IsNullOrEmpty(request.ParentGroupUid))
                request.ParentGroupUid = null; // for null and empty values

            using (var ctx = _HixDbContextFactory.Create())
            {
                // search display contexts using parent image group uid

                // find image groups that are direct children of the parent image group
                var childImageGroups = ctx.ImageGroups.Where(x => x.ParentGroupUid == request.ParentGroupUid);
                var childDisplayContexts = (from i in childImageGroups
                                           join d in ctx.DisplayContexts on i.GroupUid equals d.GroupUid
                                           select d).OrderBy(x => x.Id);

                int totalRowCount = childDisplayContexts.Count();
                // return all rows if page size not specified
                int pageSize = (request.PageSize <= 0) ? totalRowCount : request.PageSize;
                int pageIndex = ((totalRowCount < pageSize) || (request.PageIndex <= 0)) ? 1 : request.PageIndex;
                int pageCount = totalRowCount / pageSize;
                if (totalRowCount % pageSize != 0)
                    pageCount++;
                pageIndex = Math.Min(pageIndex, pageCount);

                int skipRows = (pageIndex -1) * pageSize;

                var displayContextRecords = new List<DisplayContextRecord>();

                var selectedDisplayContexts = childDisplayContexts.Skip(skipRows).Take(pageSize);
                foreach (var displayContext in selectedDisplayContexts)
                {
                    var displayContextRecord = new DisplayContextRecord
                    {
                        GroupUid = displayContext.GroupUid,
                        ContextId = displayContext.ContextId,
                        Name = displayContext.Name,
                        ImageCount = displayContext.ImageCount
                    };

                    displayContextRecords.Add(displayContextRecord);
                }


                //var selectedImageGroups = childImageGroups.Skip(skipRows).Take(pageSize);
                //foreach (var imageGroup in selectedImageGroups)
                //{
                //    // find display context corresponding to the image group
                //    var displayContext = ctx.DisplayContexts.Where(x => (x.GroupUid == imageGroup.GroupUid)).FirstOrDefault();
                //    if (displayContext == null)
                //        continue;

                //    var displayContextRecord = new DisplayContextRecord
                //    {
                //        GroupUid = displayContext.GroupUid,
                //        ContextId = displayContext.ContextId,
                //        Name = displayContext.Name,
                //        ImageCount = displayContext.ImageCount
                //    };

                //    displayContextRecords.Add(displayContextRecord);
                //}

                var response = new SearchDisplayContextResponse();
                response.PageCount = pageCount;
                response.PageIndex = pageIndex;
                response.PageSize = pageSize;
                response.RecordCount = totalRowCount;
                response.Results = (displayContextRecords.Count > 0)? displayContextRecords.ToArray() : null;

                return module.Ok<SearchDisplayContextResponse>(response);
            }
        }

        private void FillDisplayContextDetails(IHixDbContext ctx, DisplayContextRecord displayContextRecord)
        {
            // find all child image groups
            var query = from p in ctx.ImageGroups
                        where p.ParentGroupUid == displayContextRecord.GroupUid
                        select p;

            List<DisplayContextRecord> children = null;

            foreach (var childImageGroup in query)
            {
                if (children == null)
                    children = new List<DisplayContextRecord>();

                //find display context associated with the image group
                var displayContext = ctx.DisplayContexts.Where(x => (x.GroupUid == childImageGroup.GroupUid)).FirstOrDefault();
                if (displayContext == null)
                    continue;

                var childDisplayContextRecord = new DisplayContextRecord
                {
                    ContextId = displayContext.ContextId,
                    GroupUid = displayContext.GroupUid,
                    Name = displayContext.Name,
                    ImageCount = displayContext.ImageCount
                };

                children.Add(childDisplayContextRecord);

                FillDisplayContextDetails(ctx, childDisplayContextRecord);
            }

            displayContextRecord.Children = children;
        }

        private void FillGroupDetails(IHixDbContext ctx, ImageGroupRecord imageGroupRecord)
        {
            // get images
            imageGroupRecord.Images = ctx.Images
                        .Where(i => i.GroupUid == imageGroupRecord.GroupUid)
                        .Select(i => new ImageRecord
                        {
                            ImageUid = i.ImageUid,
                            Path = i.RelativePath,
                            IsUploaded = i.IsUploaded,
                            IsProcessed = i.IsProcessed,
                            IsSynced = i.IsSynced,
                            Status = i.Status,
                            FileName = i.FileName,
                            ExternalImageId = i.ExternalImageId
                        }).ToList();

            // get child groups
            var query = from p in ctx.ImageGroups
                        where p.ParentGroupUid == imageGroupRecord.GroupUid
                        select p;

            foreach (var childImageGroup in query)
            {
                if (imageGroupRecord.Children == null)
                    imageGroupRecord.Children = new List<ImageGroupRecord>();

                var childImageGroupRecord = new ImageGroupRecord
                {
                    GroupUid = childImageGroup.GroupUid,
                    ParentGroupUid = childImageGroup.ParentGroupUid,
                    Name = childImageGroup.Name
                };

                FillGroupDetails(ctx, childImageGroupRecord);

                imageGroupRecord.Children.Add(childImageGroupRecord);
            }
        }

        private Response CreateImageGroupRecord(NancyModule module)
        {
            NewImageGroupRequest imageGroupRequest = module.Bind<NewImageGroupRequest>();
            if (imageGroupRequest == null)
                return module.BadRequest();

            try
            {
                NewImageGroupResponse imageGroupResponse = ImageWorkflow.CreateImageGroupRecord(_HixDbContextFactory, imageGroupRequest);

                return module.Ok<NewImageGroupResponse>(imageGroupResponse);
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
        }

        private Response UpdateImageGroupRecord(NancyModule module, string imageGroupUid)
        {
            var imageGroupRequest = module.Bind<UpdateImageGroupRequest>();
            if (imageGroupRequest == null)
                return module.BadRequest();

            try
            {
                NewImageGroupResponse imageGroupResponse = ImageWorkflow.UpdateImageGroupRecord(_HixDbContextFactory, imageGroupUid, imageGroupRequest);

                return module.Ok<NewImageGroupResponse>(imageGroupResponse);
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
        }

        private Response DeleteImageGroupRecord(NancyModule module, string imageGroupUid)
        {
            if (string.IsNullOrEmpty(imageGroupUid))
                return module.BadRequest();

            try
            {
                ImageWorkflow.DeleteImageGroupRecord(_HixDbContextFactory, imageGroupUid, false);

                return module.Ok();
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
        }

        private Response DeleteDisplayContextRecord(NancyModule module, string contextId)
        {
            if (string.IsNullOrEmpty(contextId))
                return module.BadRequest();

            try
            {
                ImageWorkflow.DeleteDisplayContextRecord(_HixDbContextFactory, contextId, deleteNow: false);

                return module.Ok();
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
        }

        private void GetImageGroupStatus(IHixDbContext ctx, string groupUid, bool isNested, ImageGroupStatus groupStatus)
        {
            var imageFiles = ctx.Images.Where(x => (x.GroupUid == groupUid)).ToList();

            groupStatus.ImageCount += imageFiles.Count();
            groupStatus.ImagesUploaded += imageFiles.Where(x => x.IsUploaded).Count();
            groupStatus.ImagesProcessed += imageFiles.Where(x => x.IsProcessed).Count();
            // images uploaded, but marked as failed (after processing)
            groupStatus.ImagesFailed += imageFiles.Where(x => (x.IsUploaded && x.IsSucceeded.HasValue && !x.IsSucceeded.Value)).Count();
            // images not uploaded, but marked as failed
            groupStatus.ImagesUploadFailed += imageFiles.Where(x => (!x.IsUploaded && x.IsSucceeded.HasValue && !x.IsSucceeded.Value)).Count();

            if (isNested)
            {
                // get child groups
                var queryable = from p in ctx.ImageGroups
                                where p.ParentGroupUid == groupUid
                                select p;

                foreach (var childImageGroup in queryable)
                {
                    GetImageGroupStatus(ctx, childImageGroup.GroupUid, isNested, groupStatus);
                }
            }
        }

        //private void GetImageGroupStatus2(IHixDbContext ctx, string groupUid, bool isNested, ImageGroupStatus parentGroupStatus)
        //{
        //    var sqlQuery = @"SELECT 
	       //                         COUNT(*) AS ImageCount, 
	       //                         SUM(CASE WHEN (dbo.ImageFiles.IsUploaded = 'true') THEN 1 ELSE 0 END) AS ImagesUploaded,
	       //                         SUM(CASE WHEN (dbo.ImageFiles.IsProcessed = 'true') THEN 1 ELSE 0 END) AS ImagesProcessed,
	       //                         SUM(CASE WHEN ((dbo.ImageFiles.IsUploaded = 'true') AND (dbo.ImageFiles.IsSucceeded = 'false')) THEN 1 ELSE 0 END) AS ImagesFailed,
	       //                         SUM(CASE WHEN ((dbo.ImageFiles.IsUploaded = 'false') AND (dbo.ImageFiles.IsSucceeded = 'false')) THEN 1 ELSE 0 END) AS ImagesUploadFailed
        //                        FROM dbo.ImageFiles
        //                        WHERE (GroupUid = @ImageGroupUid)";
        //    var sqlParameter = new SqlParameter("@ImageGroupUid", groupUid);
        //    var imageGroupStatus = ctx.Database.SqlQuery<ImageGroupStatus>(sqlQuery, sqlParameter).FirstOrDefault();

        //    parentGroupStatus.ImageCount += imageGroupStatus.ImageCount;
        //    parentGroupStatus.ImagesUploaded += imageGroupStatus.ImagesUploaded;
        //    parentGroupStatus.ImagesProcessed += imageGroupStatus.ImagesProcessed;
        //    // images uploaded, but marked as failed (after processing)
        //    parentGroupStatus.ImagesFailed += imageGroupStatus.ImagesFailed;
        //    // images not uploaded, but marked as failed
        //    parentGroupStatus.ImagesUploadFailed += imageGroupStatus.ImagesUploadFailed;

        //    if (isNested)
        //    {
        //        // get child groups
        //        sqlQuery = @"SELECT GroupUid 
        //                     FROM dbo.ImageGroups
        //                     WHERE (ParentGroupUid = @ImageGroupUid)";

        //        var childGroups = ctx.Database.SqlQuery<string>(sqlQuery, sqlParameter).ToList();
        //        foreach (var item in childGroups)
        //        {
        //            GetImageGroupStatus(ctx, item, isNested, parentGroupStatus);
        //        }
        //    }
        //}

        private Response GetImageGroupStatus(NancyModule module, string groupUid)
        {
            var request = module.Bind<ImageGroupStatusRequest>();
            if (request == null)
                return module.BadRequest();

            using (var ctx = _HixDbContextFactory.Create())
            {
                var imageGroup = ctx.ImageGroups.Where(x => (x.GroupUid == groupUid)).FirstOrDefault();
                if (imageGroup == null)
                    return module.BadRequest("Image group {0} not found", groupUid);

                var imageGroupStatus = new ImageGroupStatus
                {
                    GroupUid = groupUid
                };

                GetImageGroupStatus(ctx, groupUid, request.IsNested, imageGroupStatus);

                return module.Ok<ImageGroupStatus>(imageGroupStatus);
            }
        }

        private Response GetImageGroupData(NancyModule module, string groupUid)
        {
            return module.Response.AsText(ImageWorkflow.GetOrCreateImageGroupDetailsJson(_HixDbContextFactory, groupUid), "application/json");
        }

        //private Response GetImage(NancyModule module, string imageUid)
        //{
        //    using (var ctx = HixDbContextFactory.CreateDbContext())
        //    {
        //        var imageFile = ctx.Images.Where(x => (x.ImageUid == imageUid)).FirstOrDefault();
        //        if (imageFile == null)
        //            return module.BadRequest("ImageUid {0} is not valid", imageUid);

        //        if (!imageFile.IsUploaded)
        //            return module.NotFound("Not image file associated with ImageUid {0}", imageUid);

        //        var imageGroup = ctx.ImageGroups.Where(x => (x.GroupUid == imageFile.GroupUid)).FirstOrDefault();
        //        if (imageGroup == null)
        //            return module.Error("Group not found for ImageUid {0}. GroupUid = {1}", imageFile.ImageUid, imageFile.GroupUid);

        //        System.IO.Stream stream = ImageWorkflow.Instance.GetImageStream(imageFile, imageGroup);

        //        return new StreamResponse(stream, imageFile.ImageType.AsContentType());
        //    }
        //}

        private Response StoreImage(NancyModule module, string imageUid)
        {
            // store file
            var file = module.Request.Files.FirstOrDefault();
            if (file != null)
            {
                ImageWorkflow.StoreImage(_HixDbContextFactory, imageUid, file.Value, null);
            }
            else if ((module.Request.Body != null) && (module.Request.Body.Length > 0))
            {
                ImageWorkflow.StoreImage(_HixDbContextFactory, imageUid, module.Request.Body, null);
            }
            else
            {
                return module.BadRequest("File not found in body of request");
            }

            return module.Ok();
        }

        private Response ProcessImage(NancyModule module, string imageUid)
        {
            var filePath = module.Request.Body.AsString(Encoding.UTF8);
            if (string.IsNullOrEmpty(filePath))
                return module.BadRequest("File name not found in body of request");

            if (!File.Exists(filePath))
                return module.BadRequest("Cannot access file {0}", filePath);

            ImageWorkflow.StoreImage(_HixDbContextFactory, imageUid, null, filePath);

            return module.Ok();
        }

        private Response CreateImageRecord(NancyModule module)
        {
            var request = module.Bind<NewImageRequest>();
            if (request == null)
                return module.BadRequest();
            if (string.IsNullOrEmpty(request.GroupUid))
                return module.BadRequest("Image group id not specified");
            if ((request.ImageData == null) || (request.ImageData.Count == 0))
                return module.BadRequest("Invalid image data");

            try
            {
                var imageResponse = ImageWorkflow.CreateImageRecord(_HixDbContextFactory, request);
                return module.Ok<List<NewImageResponse>>(imageResponse);
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
        }

        private Response GetImageRecord(NancyModule module, string imageUid)
        {
            using (var ctx = _HixDbContextFactory.Create())
            {
                var imageFile = ctx.Images.Where(x => (x.ImageUid == imageUid)).FirstOrDefault();
                if (imageFile == null)
                    return module.BadRequest("Image file {0} not found in VIX Render Cache DB.", imageUid);

                var imageRecord = new ImageRecord
                {
                    ImageUid = imageFile.ImageUid,
                    Path = imageFile.RelativePath,
                    IsUploaded = imageFile.IsUploaded,
                    IsProcessed = imageFile.IsProcessed,
                    IsSynced = imageFile.IsSynced,
                    Status = imageFile.Status,
                    FileName = imageFile.FileName,
                    ExternalImageId = imageFile.ExternalImageId
                };

                return module.Ok<ImageRecord>(imageRecord);
            }
        }

        private Response CreateDicomDir(NancyModule module)
        {
            var request = module.Bind<DicomDirRequest>();
            if ((request == null) ||
                (request.GroupUids == null) ||
                (request.GroupUids.Length == 0))
                return module.BadRequest();

            try
            {
                var response = ImageWorkflow.CreateDicomDir(_HixDbContextFactory, request);
                return module.Ok<DicomDirResponse>(response);
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
        }

        private Response SetImageRecordError(NancyModule module, string imageUid)
        {
            try
            {
                ImageWorkflow.SetImageRecordError(_HixDbContextFactory, imageUid, module.Request.Body.AsString());

                return module.Ok();
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error("Error setting image record error. {0}", ex.ToString());
            }
        }

        private Response AddDictionaryRecord(NancyModule module, string name)
        {
            try
            {
                int recordId = ImageWorkflow.AddUpdateDictionaryRecord(_HixDbContextFactory, name, module.Request.Body.AsString());

                return module.Ok<int>(recordId);
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }

        private Response GetDictionaryRecord(NancyModule module, string name)
        {
            if (string.IsNullOrEmpty(name))
                return module.BadRequest();

            try
            {
                var record = ImageWorkflow.GetDictionaryRecord(_HixDbContextFactory, name);
                return module.Ok<string>(record.Value);
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }

        private Response SearchDictionaryRecords(NancyModule module, string name)
        {
            if (string.IsNullOrEmpty(name))
                return module.BadRequest();

            try
            {
                var records = ImageWorkflow.SearchDictionaryRecords(_HixDbContextFactory, name);
                if ((records == null) || (records.Length == 0))
                    return module.NoContent();

                var values = records.Select(x => x.Value).ToArray();
                return module.Ok<string[]>(values);
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }

        private Response DeleteDictionaryRecord(NancyModule module, string name)
        {
            if (string.IsNullOrEmpty(name))
                return module.BadRequest();

            try
            {
                ImageWorkflow.DeleteDictionaryRecord(_HixDbContextFactory, name);
                return module.Ok();
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }

        private Response PurgeCache(NancyModule module)
        {
            var request = module.Bind<PurgeRequest>();
            if (request == null)
                return module.BadRequest();

            if (!request.MaxCacheSizeMB.HasValue)
                request.MaxCacheSizeMB = HixConfigurationSection.Instance.Purge.MaxCacheSizeMB;

            if (!request.MaxAgeDays.HasValue)
                request.MaxAgeDays = HixConfigurationSection.Instance.Purge.MaxAgeDays;

            if (!request.ImageGroupPurgeBlockSize.HasValue)
                request.ImageGroupPurgeBlockSize = HixConfigurationSection.Instance.Purge.ImageGroupPurgeBlockSize;

            if (!request.ImagePurgeBlockSize.HasValue)
                request.ImagePurgeBlockSize = HixConfigurationSection.Instance.Purge.ImagePurgeBlockSize;

            if (!request.EnableCacheCleanup.HasValue)
                request.EnableCacheCleanup = HixConfigurationSection.Instance.Purge.EnableCacheCleanup;

            if (!request.MaxEventLogAgeDays.HasValue)
                request.MaxEventLogAgeDays = HixConfigurationSection.Instance.Purge.MaxEventLogAgeDays;

            try
            {
                HixService.Instance.PurgeScheduler.Execute(request);

                return module.Ok();
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }

        private Response GetCacheStatus(NancyModule module)
        {
            try
            {
                var cacheStatus = HixService.Instance.PurgeScheduler.GetCacheStatus();

                return module.Response.AsText(cacheStatus.ToString(), "application/json");
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }

        private Response GetLogSettings(NancyModule module)
        {
            try
            {
                var logSettings = new LogSettings
                {
                    LogLevel = LogManager.LogLevel,
                    LogFileItems = LogManager.GetLogFiles().ToArray()
                };

                return module.Ok<LogSettings>(logSettings);
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }

        private Response SetLogSettings(NancyModule module)
        {
            string logLevel = null;

            var logSettingsRequest = module.Bind<LogSettingsRequest>();
            if (logSettingsRequest != null)
                logLevel = logSettingsRequest.LogLevel;

            try
            {
                LogManager.LogLevel = logLevel;

                return module.Ok();
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }

        private Response GetLogFile(NancyModule module)
        {
            var logSettingsRequest = module.Bind<LogSettingsRequest>();
            if (logSettingsRequest == null)
                return module.BadRequest();

            try
            {
                var filePath = LogManager.GetLogFilePath(logSettingsRequest.LogFileName);

                return new Response
                {
                    Contents = stream =>
                    {
                        using (var fileStream = File.Open(filePath, FileMode.Open, FileAccess.Read, FileShare.Read))
                        {
                            fileStream.CopyTo(stream);
                        }
                    },
                    ContentType = "application/text",
                    StatusCode = HttpStatusCode.OK
                };
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }

        private Response DeleteLogFiles(NancyModule module)
        {
            string logFileName = null;

            var logSettingsRequest = module.Bind<LogSettingsRequest>();
            if (logSettingsRequest != null)
                logFileName = logSettingsRequest.LogFileName;

            try
            {
                LogManager.DeleteLogFiles((logSettingsRequest != null) ? logSettingsRequest.LogFileName : null);
                return module.Ok();
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }

        private Response GetLogEvents(NancyModule module)
        {
            var logSettingsRequest = module.Bind<LogSettingsRequest>();
            if (logSettingsRequest == null)
                return module.BadRequest();

            try
            {
                bool more = false;
                var logEventItems = LogManager.GetLogItems(logSettingsRequest.LogFileName, 
                                                           logSettingsRequest.PageSize, 
                                                           logSettingsRequest.PageIndex,
                                                           out more);

                var response = new LogSettingsResponse
                {
                    LogEventItems = logEventItems,
                    More = more
                };

                return module.Ok<LogSettingsResponse>(response);
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }

        private Response CreatePRFile(NancyModule module)
        {
            string filePath = null;
            try
            {
                var pstate = module.Bind<StudyPresentationState>();
                Storage.ImageStore tempStore = Storage.StorageManager.Instance.TempImageStore;
                if ((tempStore == null) || !tempStore.IsEnabled)
                {
                    throw new Exception("No valid temporary image store found");
                }
                List<string> imageIdList = new List<string>();
                PresentationState[] prStateArr = JsonConvert.DeserializeObject<PresentationState[]>(pstate.Data,
                                                                            new JsonSerializerSettings
                                                                            {
                                                                                NullValueHandling = NullValueHandling.Ignore,
                                                                                ContractResolver = new CamelCasePropertyNamesContractResolver()
                                                                            });
                foreach (PresentationState prState in prStateArr)
                {
                    imageIdList.Add(prState.ImageId);
                }
                using (var ctx = _HixDbContextFactory.Create())
                {
                    var imageFiles = ctx.Images.Where(x => (imageIdList.Contains(x.ImageUid) && x.DicomDirXml != null)).AsEnumerable()
                                                                        .Select(x => 
                                                                        new Dicom.ImageAttributes
                                                                        { 
                                                                            ImageUid = x.ImageUid,
                                                                            DicomXml = HipaaUtil.DescryptText(x.DicomXml)
                                                                        })
                                                                        .ToList<Dicom.ImageAttributes>();
                    Dicom.CreatePresentationState.CreatePRFile(pstate, imageFiles, tempStore.Path, out filePath);
                }
                
                return module.Ok<string>(filePath);
            }
            catch (BadRequestException ex)
            {
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return module.Error(ex.ToString());
            }
        }
        /// <summary>
        /// Determine if all the image parts files are ready before making the PDF
        /// </summary>    
        /// <returns>fileStatus (VAI-307)</returns>
        private fileStatus FileReadyStatus(string ImageUid) 
        {
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("FileReadyStatus.", "ImageUid", ImageUid);

            using (var ctx = _HixDbContextFactory.Create())
            {
                var imageParts= ctx.ImageParts.Where(x => (x.ImageUid== ImageUid));
                if (imageParts == null)
                    return (fileStatus.NoRecords); 

                int regularDelay = 120;// number of attempts to wait for completion
                int longDelay = regularDelay * 10;
                var imageFiles = new List<string>();
                string lastImageUid = string.Empty;
                
                foreach (var item in imageParts)
                {
                    if (item.Frame >= 0)
                    {
                        bool bExists = File.Exists(item.AbsolutePath);
                        while (!bExists)
                        {
                            Thread.Sleep(1000);
                            if (longDelay-- < 0)
                                return (fileStatus.MissingFile);
                            bExists = File.Exists(item.AbsolutePath);
                        }
                        //If it is a placeholder file( AKA 0 bytes), wait some more
                        long length = new System.IO.FileInfo(item.AbsolutePath).Length;
                        while (length <= 0) 
                        {
                            Thread.Sleep(1000);
                            length = new System.IO.FileInfo(item.AbsolutePath).Length;
                            if (longDelay-- < 0)
                                return (fileStatus.NoProgress);
                            
                        }
                        // Allow some extra time for the other process to finish saving the file completely
                        DateTime lastWrite = new System.IO.FileInfo(item.AbsolutePath).LastWriteTime;
                        TimeSpan elapsedFileTime = DateTime.Now - lastWrite;
                        while (elapsedFileTime.TotalMilliseconds < 500)
                        {
                            Thread.Sleep(1000);
                            lastWrite = new System.IO.FileInfo(item.AbsolutePath).LastWriteTime;
                            elapsedFileTime = DateTime.Now - lastWrite;
                            if (regularDelay-- < 0)
                                return (fileStatus.NotSaved);
                        }
                        regularDelay = 120;
                        longDelay = regularDelay * 100;
                    }
                }
            }
            return (fileStatus.Complete);
        }


        /// <summary>
        /// Determines if image parts records exist for the specified groupID (VAI-1284)
        /// </summary>
        /// <param name="groupID"></param>
        /// <returns>true if the parts are found</returns>
        private bool checkImageParts(string groupID)
        {
            using (var ctx = _HixDbContextFactory.Create()){
                var images = ctx.Images.Where(x => (x.GroupUid == groupID));
                foreach (var image in images)
                {
                    var imageParts = ctx.ImageParts.Where(x => (x.ImageUid == image.ImageUid));
                    if (imageParts.Count() == 0)
                        return (false);
                }
            }
            return (true);
        }

        /// <summary>
        ///Builds a PDF file from the document files for a given study using the contextId.(VAI-1284)
        /// </summary>
        /// <param name="module"></param>
        /// <param name="contextId"></param>
        /// <param name="base64EncodedFolder"></param>
        /// <returns>The published pdf file path</returns>
        private Response GetServePdf(NancyModule module, string contextId, string base64EncodedFolder) //VAI-1284
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedFolder);
            string baseFolder = System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
            string pdfFile = "";
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Preparing PDF for study.", "contextId", contextId);
            try
            {
                var pdfFiles = new List<string>();
                using (var ctx = _HixDbContextFactory.Create())
                {
                    string groupID = "";
                    var displayContexts = ctx.DisplayContexts.Where(x =>(x.ContextId == contextId));
                    if (displayContexts == null)
                    {
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Context not found for study.", "contextId", contextId);
                        return module.NotFound();
                    }
                    foreach (var item in displayContexts)
                    {
                        if (groupID== "")
                            groupID = item.GroupUid;
                    }
                    if (groupID == "")
                    {
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Group not found for study.", "contextId", contextId);
                        return module.NotFound();
                    }

                    int retry = 0;
                    while (checkImageParts(groupID) == false && retry++ < 60)
                    {
                        System.Threading.Thread.Sleep(2000);
                    }
                    if (retry > 60)
                    {
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Image parts not available for study.", "contextId", contextId, "groupID", groupID);
                        return module.NotFound();
                    }

                    var imageParts = ctx.ImageParts.Where(x => (x.GroupUid == groupID) && (x.AbsolutePath.ToLower().EndsWith("pdf"))).OrderBy(x=> x.AbsolutePath);
                    if (imageParts == null)
                    {
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("No PDF ImageParts for study (null).", "contextId", contextId, "groupID", groupID);
                        return module.NotFound();
                    }
                    if (imageParts.Count() == 0)
                    {
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("No PDF ImageParts for study (0 Count).", "contextId", contextId, "groupID", groupID);
                        return module.NotFound();
                    }

                    string ImageUid = "";
                    var imageFileList = new List<string>();
                    foreach (var imagePart in imageParts)
                    {
                        if (imagePart.AbsolutePath.ToLower().EndsWith("pdf"))
                        {
                            if (ImageUid.Length == 0)
                                ImageUid = imagePart.ImageUid;
                            var imageFiles = ctx.Images.Where(x => (x.ImageUid == imagePart.ImageUid));
                            if (imageFiles == null)
                            {
                                if (_Logger.IsDebugEnabled)
                                    _Logger.Debug("No ImageFiles records found for ImageUid.", "contextId", contextId, "ImageUid", imagePart.ImageUid);
                                return module.NotFound();
                            }
                            if (imageFiles.Count() > 0)
                            {
                                int retrys = 0;
                                while (!File.Exists(imagePart.AbsolutePath) && retrys++ < 60)
                                    System.Threading.Thread.Sleep(2000);
                                if (retrys < 60)
                                    imageFileList.Add(imagePart.AbsolutePath);
                                else
                                {
                                    if (_Logger.IsDebugEnabled)
                                        _Logger.Debug("ImageParts file not available for this study.","contextId", contextId);
                                    return module.NotFound();
                                }
                            }
                        }
                    }
                    if (imageFileList.Count() > 0)
                    {
                        pdfFile = publishPdfFile(ImageUid, imageFileList, baseFolder);
                        if (pdfFile.Length < 1)
                        {
                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("Could not publish PDF for study.", "contextId", contextId);
                            return module.NotFound();
                        }
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Publishing PDF for study.", "contextId", contextId);
                        return module.Ok<string>(pdfFile);
                    }else {
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("No PDF documents in study.", "contextId", contextId);
                        return module.NotFound();
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting PDF documents","Exception",ex.ToString());
                return module.Error("Error getting PDF documents. {0}", ex.ToString());
            }
        }

        /// <summary>
        ///Publish a list of PDF files using the ImageUid (VAI-1284)
        /// </summary>
        /// <param name="imageUID"></param>
        /// <param name="PdfDocuments"></param>
        /// <param name="baseFolder"></param>
        /// <returns>Path to the pdf file</returns>
        private string publishPdfFile(string imageUID, List<string>PdfDocuments, string baseFolder)
        {
            if (PdfDocuments.Count < 1)
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("No pdf documents selected.","imageUID", imageUID);
                return ("");
            }
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("PDF document requested.", "imageUID", imageUID);

            string[] strlist = PdfDocuments[0].Split('\\');
            string prepend = PdfDocuments[0].Substring(PdfDocuments[0].IndexOf(strlist[strlist.Length - 6]), PdfDocuments[0].LastIndexOf('\\') - PdfDocuments[0].IndexOf(strlist[strlist.Length - 6])).Replace("\\", "");
            string destFolder = $@"{baseFolder}Viewer\files\pdffiles";
            string pdfDestFile = $@"{destFolder}\{prepend}_{imageUID}_SPU.pdf";
            if (!Directory.Exists(destFolder))
                Directory.CreateDirectory(destFolder);
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Building PDF file for publish.", "pdfDestFile", pdfDestFile);

                if (File.Exists(pdfDestFile) && PdfDocuments.Count == 1)
                {
                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Using existing PDF file (single destfile).","pdfDestFile", pdfDestFile);
                    return (pdfDestFile);
                }

                if (File.Exists(PdfDocuments[0]) && PdfDocuments.Count == 1)
                {
                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Publishing existing PDF file (single array element).","pdfDestFile", pdfDestFile);
                    File.Copy(PdfDocuments[0], pdfDestFile);
                    return (pdfDestFile);//Normal return point for individual pdf file
                }
                else
                {
                    int pCount = Dicom.TiffProcessor.CombinePdfFiles(pdfDestFile, PdfDocuments);
                    if (pCount < 1)
                    {
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Could not combine PDF documents.","pdfDestFile", pdfDestFile);
                        return ("");
                    }
                    else
                    {
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Publishing PDF file.","pdfDestFile", pdfDestFile);
                        if (File.Exists(pdfDestFile))
                        {
                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("PDF file created.", "pdfDestFile", pdfDestFile);
                            return (pdfDestFile);
                        }
                        else
                        {
                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("PDF file does not exist.", "pdfDestFile", pdfDestFile);
                            return ("");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error publishing PDF document.", "Exception", ex.ToString());
                return ("");
            }
        }

        /// <summary>
        ///Build the PDF file from the image parts for a given ImageUid
        /// </summary>
        /// <param name="module"></param>
        /// <param name="ImageUid"></param>
        /// <param name="base64EncodedFolder"></param>
        /// <returns>(VAI-307)</returns>
        private Response GetPdfFile(NancyModule module, string ImageUid, string base64EncodedFolder) //VAI-307
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedFolder);
            string baseFolder = System.Text.Encoding.UTF8.GetString(base64EncodedBytes);

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Checking image parts.", "ImageUid", ImageUid);

            fileStatus CheckFileStatus = FileReadyStatus(ImageUid);
            string msg = CheckFileStatus.ToString();
            while (CheckFileStatus != fileStatus.Complete)
            { 
                CheckFileStatus = FileReadyStatus(ImageUid);
                if (CheckFileStatus >= fileStatus.NoRecords)
                {               
                    _Logger.Error("No image parts.", "CheckFileStatus", CheckFileStatus.ToString(), "ImageUid", ImageUid); //VAI-1336
                    return module.NotFound($"ImagePart {ImageUid} error {CheckFileStatus.ToString()}"); //VAI-1336
                }
            }
            string pdfFile = string.Empty;
            using (var ctx = _HixDbContextFactory.Create())
            {
                var imageParts = ctx.ImageParts.Where(x => (x.ImageUid == ImageUid));
                if (imageParts == null)
                    return module.NotFound($"ImagePart {imageParts} not found");
                var imageFiles = new List<string>();
                foreach (var item in imageParts) 
                {
                    if (item.Frame >= 0)
                    {
                       imageFiles.Add(item.AbsolutePath);
                    }
                }
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Converting images to PDF.", "ImageUid", ImageUid);

                pdfFile = Dicom.TiffProcessor.ConvertToPdf(ImageUid, imageFiles, baseFolder);
            }
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("PDF images converted to PDF.", "ImageUid", ImageUid);

                return module.Ok<string>(pdfFile);
            }
            catch (BadRequestException ex)
            {
                _Logger.Error("BadRequestException GetPdfFile processing PDF.", "pdfFile", pdfFile, "Exception", ex.ToString()); //VAI-1336
                return module.BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error GetPdfFile processing PDF.", "pdfFile", pdfFile, "Exception", ex.ToString()); //VAI-1336
                return module.Error(ex.ToString());
            }
        }
    }
}