using Hydra.Common.Exceptions;
using Hydra.IX.Common;
using Hydra.IX.Core.Modules;
using Hydra.IX.Database.Common;
using Hydra.IX.Storage;
using Hydra.Log;
using Nancy;
using Nancy.Json;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;

namespace Hydra.IX.Core
{
    public static class ImageWorkflow
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static bool CacheStudyMetadata { get; set; }
        public static bool EnableDirectCacheAccess { get; set; }
        public static IImageManager ImageManager { get; set; }

        static ImageWorkflow()
        {
            JsonSettings.MaxJsonLength = Int32.MaxValue;
            EnableDirectCacheAccess = true;
        }

        public static List<NewImageResponse> CreateImageRecord(IHixDbContextFactory ctxFactory, NewImageRequest request)
        {
            using (var ctx = ctxFactory.Create())
            {
                ImageGroup parentImageGroup = ctx.ImageGroups.FirstOrDefault(x => (x.GroupUid == request.GroupUid));
                if (parentImageGroup == null)
                    throw new BadRequestException("Image group {0} does not exist", request.GroupUid);

                if (!string.IsNullOrEmpty(request.RefImageUid))
                {
                    if (!ctx.Images.Where(x => x.ImageUid == request.RefImageUid).Any())
                    {
                        throw new BadRequestException("Referenced image uid {0} does not exist", request.RefImageUid);
                    }
                }

                try
                {
                    var imageResponseList = new List<NewImageResponse>();
                    Tag tag = null;

                    // update tag table
                    if (!string.IsNullOrEmpty(request.Tag))
                    {
                        tag = TagUtil.AddOrGetTag(ctx, request.Tag);
                    }

                    foreach (var imageData in request.ImageData)
                    {
                        // create empty image record
                        var imageFile = new ImageFile
                        {
                            ImageUid = !string.IsNullOrEmpty(imageData.RequestedImageUid) ? imageData.RequestedImageUid : Guid.NewGuid().ToString(),
                            GroupUid = request.GroupUid,
                            RootGroupUid = parentImageGroup.RootGroupUid,
                            FileName = imageData.FileName,
                            FileType = imageData.FileType,
                            RefImageUid = string.IsNullOrEmpty(request.RefImageUid) ? null : request.RefImageUid,
                            //ImageType = (imageData.FileType == Hydra.Common.FileType.Blob) ? Hydra.Common.ImageType.Blob : Hydra.Common.ImageType.Unknown,
                            ImageType = Hydra.Common.ImageType.Unknown,
                            Description = imageData.Description,
                            IsOwner = request.IsOwner,
                            ExternalImageId = imageData.ExternalImageId
                        };

                        ctx.Images.Add(imageFile);

                        if (tag != null)
                        {
                            TagUtil.AssociateTag(ctx, imageFile, tag);
                        }

                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Image added to group.", "ImageUid", imageFile.ImageUid, "GroupUid", imageFile.GroupUid);
                            
                        imageResponseList.Add(new NewImageResponse { ImageUid = imageFile.ImageUid, FileName = imageFile.FileName, ImageId = imageFile.Id });
                    }

                    ctx.SaveChanges();


                    return imageResponseList;
                }
                catch (Exception ex)
                {
                    _Logger.Error("Error creating image record", "Exception", ex.ToString());

                    throw;
                }
            }
        }

        public static DicomDirResponse CreateDicomDir(IHixDbContextFactory ctxFactory, DicomDirRequest request)
        {
            return DicomDirBuilder.CreateDicomDir(ctxFactory, request);
        }

        public static NewImageGroupResponse CreateImageGroupRecord(IHixDbContextFactory ctxFactory, NewImageGroupRequest request)
        {
            using (var ctx = ctxFactory.Create())
            {
                ImageGroup parentImageGroup = null;

                // parent group if specified must exist
                if (!string.IsNullOrEmpty(request.ParentGroupUid))
                {
                    parentImageGroup = ctx.ImageGroups.FirstOrDefault(x => (x.GroupUid == request.ParentGroupUid));
                    if (parentImageGroup == null)
                        throw new BadRequestException("Image group {0} does not exist", request.ParentGroupUid);
                }

                // get available image store
                ImageStore imageStore = StorageManager.Instance.GetPrimaryImageStore();
                
                try
                {
                    int folderNumber = 0;
                    string path;
                    if (parentImageGroup == null)
                    {
                        int? maxValue = ctx.ImageGroups.Select(x => (int?)x.FolderNumber).Max();
                        folderNumber = (maxValue == null) ? 0 : maxValue.Value + 1;

                        string text = folderNumber.ToString().PadLeft((imageStore.FolderLevels - 1) * 2, '0');
                        StringBuilder sb = new StringBuilder();
                        for (int i = 0; i < text.Length; i += 2)
                        {
                            sb.Append(text.Substring(i, 2));
                            sb.Append('\\');
                        }
                        path = sb.ToString();
                    }
                    else
                    {
                        int? maxValue = ctx.ImageGroups.Where(x => (x.ParentGroupUid == parentImageGroup.GroupUid)).Select(x => (int?)x.FolderNumber).Max();
                        folderNumber = (maxValue == null) ? 0 : maxValue.Value + 1;
                        path = Path.Combine(parentImageGroup.RelativePath, folderNumber.ToString().PadLeft(2, '0'));
                    }

                    var groupUid = !string.IsNullOrEmpty(request.RequestedImageGroupUid) ?
                        request.RequestedImageGroupUid :
                        Guid.NewGuid().ToString();

                    // create new image group record
                    var imageGroup = new ImageGroup
                    {
                        GroupUid = groupUid,
                        ParentGroupUid = request.ParentGroupUid,
                        RootGroupUid = (parentImageGroup != null) ? parentImageGroup.RootGroupUid : groupUid,
                        ImageStoreId = (parentImageGroup != null) ? parentImageGroup.ImageStoreId : imageStore.Id,
                        FolderNumber = folderNumber,
                        RelativePath = path,
                        DateCreated = DateTime.UtcNow,
                        DateAccessed = DateTime.UtcNow,
                        Name = request.Name
                    };

                    ctx.ImageGroups.Add(imageGroup);

                    // update tag table
                    if (!string.IsNullOrEmpty(request.Tag))
                    {
                        var tag = TagUtil.AddOrGetTag(ctx, request.Tag);
                        TagUtil.AssociateTag(ctx, imageGroup, tag);
                    }

                    ctx.SaveChanges();

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Group created.", "GroupUid", imageGroup.GroupUid);
                    
                    return new NewImageGroupResponse
                    {
                        GroupUid = imageGroup.GroupUid,
                        ParentGroupUid = imageGroup.ParentGroupUid,
                        Path = imageGroup.RelativePath,
                        Name = imageGroup.Name,
                        DbId = imageGroup.Id
                    };
                }
                catch (Exception ex)
                {
                    _Logger.Error("Error creating image group record", "Exception", ex.ToString());

                    throw;
                }
            }
        }

        public static NewImageGroupResponse UpdateImageGroupRecord(IHixDbContextFactory ctxFactory, string imageGroupUid, UpdateImageGroupRequest request)
        {
            using (var ctx = ctxFactory.Create())
            {
                try
                {
                    // group must exist
                    ImageGroup imageGroup = ctx.ImageGroups.FirstOrDefault(x => (x.GroupUid == imageGroupUid));
                    if (imageGroup == null)
                        throw new BadRequestException("Image group {0} does not exist", imageGroupUid);

                    // parent group if specified must exist
                    ImageGroup parentImageGroup = null;
                    if (!string.IsNullOrEmpty(request.ParentGroupUid))
                    {
                        parentImageGroup = ctx.ImageGroups.FirstOrDefault(x => (x.GroupUid == request.ParentGroupUid));
                        if (parentImageGroup == null)
                            throw new BadRequestException("Image group {0} does not exist", request.ParentGroupUid);
                    }

                    // update root group uid
                    string rootGroupUid = (parentImageGroup != null) ? parentImageGroup.RootGroupUid : null;
                    IQueryable<ImageFile> imageFiles = ctx.Images.Where(x => x.GroupUid == imageGroup.GroupUid);
                    foreach (var imageFile in imageFiles)
                    {
                        imageFile.RootGroupUid = rootGroupUid;
                    }

                    // update parent group uid
                    imageGroup.ParentGroupUid = (parentImageGroup != null) ? parentImageGroup.GroupUid : null;

                    ctx.SaveChanges();

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Group updated.", "GroupUid", imageGroup.GroupUid);
                    
                    return new NewImageGroupResponse
                    {
                        GroupUid = imageGroup.GroupUid,
                        ParentGroupUid = imageGroup.ParentGroupUid,
                        Path = imageGroup.RelativePath,
                        Name = imageGroup.Name,
                        DbId = imageGroup.Id
                    };
                }
                catch (Exception ex)
                {
                    _Logger.Error("Error updating image group record", "Exception", ex.ToString());

                    throw;
                }
            }
        }

        public static void DeleteImageGroupRecord(IHixDbContextFactory ctxFactory, string imageGroupUid, bool deleteNow)
        {
            try
            {
                using (var ctx = ctxFactory.Create())
                {
                    // group must exist
                    ImageGroup imageGroup = ctx.ImageGroups.FirstOrDefault(x => (x.GroupUid == imageGroupUid));
                    if (imageGroup != null)
                    {
                        // find all image groups in the hierarchy
                        var imageGroupList = GetImageGroupList(ctx, imageGroupUid);

                        foreach (var item in imageGroupList)
                        {
                            // mark image files as deleted
                            IQueryable<ImageFile> imageFiles = ctx.Images.Where(x => x.GroupUid == item.GroupUid);
                            foreach (var imageFile in imageFiles)
                            {
                                imageFile.IsDeleted = true;
                                ctx.Entry(imageFile).State = System.Data.Entity.EntityState.Modified;
                            }

                            // mark image group as deleted
                            item.IsDeleted = true;
                            ctx.Entry(item).State = System.Data.Entity.EntityState.Modified;

                            // delete related records
                            ctx.SeriesRecords.RemoveRange(ctx.SeriesRecords.Where(x => (x.GroupUid == item.GroupUid)));
                            ctx.StudyRecords.RemoveRange(ctx.StudyRecords.Where(x => (x.GroupUid == item.GroupUid)));
                            ctx.StudyParentRecords.RemoveRange(ctx.StudyParentRecords.Where(x => (x.GroupUid == item.GroupUid)));
                        }

                        ctx.SaveChanges();

                        // start deleting image groups and images in the background
                        StorageManager.Instance.DeleteImageGroups(imageGroupList, deleteNow);

                        _Logger.Info("Group(s) marked for deletion.", "GroupUid", imageGroup.GroupUid);
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error deleting image group record", "Exception", ex.ToString());
            }
        }

        private static void GetChildDisplayContexts(List<DisplayContext> list, IHixDbContext ctx, DisplayContext parentDisplayContext)
        {
            // find all image groups which are direct children of parentDisplayContext's GroupUid
            IQueryable<ImageGroup> childImageGroups = ctx.ImageGroups.Where(x => (x.ParentGroupUid == parentDisplayContext.GroupUid));
            foreach (var childImageGroup in childImageGroups)
            {
                // find display context associated with the child image group
                IQueryable<DisplayContext> displayContexts = ctx.DisplayContexts.Where(x => (x.GroupUid == childImageGroup.GroupUid));
                foreach (var displayContext in displayContexts)
                {
                    list.Add(displayContext);

                    // add child display contexts
                    GetChildDisplayContexts(list, ctx, displayContext);
                }
            }
        }

        public static void DeleteDisplayContextRecord(IHixDbContextFactory ctxFactory, string contextId, bool deleteNow)
        {
            DisplayContext displayContext = null;

            try
            {
                using (var ctx = ctxFactory.Create())
                {
                    displayContext = ctx.DisplayContexts.FirstOrDefault(x => (x.ContextId == contextId));
                    if (displayContext != null)
                    {
                        var list = new List<DisplayContext>();
                        list.Add(displayContext); // this is the top-level display context.

                        // get child display contexts
                        GetChildDisplayContexts(list, ctx, displayContext);

                        ctx.DisplayContexts.RemoveRange(list);
                        ctx.SaveChanges();

                        _Logger.Info("Display context record deleted.", "ContextId", contextId);
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error deleting display context", "Exception", ex.ToString());
            }

            // delete associated image group
            if (displayContext != null)
                DeleteImageGroupRecord(ctxFactory, displayContext.GroupUid, deleteNow);
        }

        public static int GetTotalImageCount(IHixDbContextFactory ctxFactory)
        {
            using (var ctx = ctxFactory.Create())
            {
                return ctx.Images.Count();
            }
        }

        private static Response CreateImagePartResponseDirect(Hydra.IX.Common.ImagePartRequest imagePartRequest,
                                                              Request request,
                                                              IResponseFormatter responseFormatter)
        {
            if (string.IsNullOrEmpty(imagePartRequest.CacheLocator))
                return null;

            // cannot handle following types
            if (imagePartRequest.Type == Hydra.Common.ImagePartType.DcmPR)
                return null;

            // get cache file location and image type
            var tokens = imagePartRequest.CacheLocator.Split(';');
            if ((tokens == null) || (tokens.Length < 2))
                return null;

            var cacheRelativePath = tokens[1];
            Hydra.Common.ImageType cacheImageType = Hydra.Common.ImageType.Unknown;
            Enum.TryParse<Hydra.Common.ImageType>(tokens[0], out cacheImageType);

            // get full path
            cacheRelativePath = Path.Combine(StorageManager.Instance.CacheImageStore.Path, cacheRelativePath);

            switch (imagePartRequest.Type)
            {
                case Hydra.Common.ImagePartType.Original:
                {
                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Sending original file for image.", "ImageUid", imagePartRequest.ImageUid, "FilePath", cacheRelativePath);

                    Hydra.Common.ImagePartTransform transform = (imagePartRequest.Transform == Hydra.Common.ImagePartTransform.Mp4) ?
                                                                Hydra.Common.ImagePartTransform.Mp4 : Hydra.Common.ImagePartTransform.Default;

                    return ResponseHelper.FromFile((int)cacheImageType, cacheRelativePath, StorageManager.Instance.CacheImageStore.IsEncrypted, transform);
                }

                case Hydra.Common.ImagePartType.Abstract:
                {
                    var filename = Path.ChangeExtension(cacheRelativePath, null);
                    filename = filename + "_ABS.jpeg";

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Sending abtract file for image.", "ImageUid", imagePartRequest.ImageUid, "FilePath", filename);

                    if (imagePartRequest.Transform == Hydra.Common.ImagePartTransform.Jpeg)
                    {
                        return ResponseHelper.FromFile((int)cacheImageType, filename, StorageManager.Instance.CacheImageStore.IsEncrypted, Hydra.Common.ImagePartTransform.Jpeg);
                    }
                    else if ((imagePartRequest.Transform == Hydra.Common.ImagePartTransform.Json) ||
                             (imagePartRequest.Transform == Hydra.Common.ImagePartTransform.Default))
                    {
                        byte[] content = StorageManager.Instance.GetBytes(filename, StorageManager.Instance.CacheImageStore.IsEncrypted);
                        return responseFormatter.AsJson<Hydra.Entities.Thumbnail>(new Hydra.Entities.Thumbnail(content));
                    }
                    else
                        throw new BadRequestException("Transfrom type not supported. ImageUid:{0}, Type:{1}, Frame:{2}, Transform:{3}",
                                                      imagePartRequest.ImageUid, imagePartRequest.Type, imagePartRequest.FrameNumber, imagePartRequest.Transform);
                }

                case Hydra.Common.ImagePartType.Header:
                {
                    var filename = Path.ChangeExtension(cacheRelativePath, null);
                    filename = filename + "_HDR.json";

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Sending header file for image.", "ImageUid", imagePartRequest.ImageUid, "FilePath", filename);
                    
                    string content = StorageManager.Instance.GetText(filename, StorageManager.Instance.CacheImageStore.IsEncrypted);
                    return responseFormatter.AsJson<List<Hydra.Entities.DicomTag>>(
                        Dicom.ImageProcessor.ParseJsonText<List<Hydra.Entities.DicomTag>>(content));
                }

                case Hydra.Common.ImagePartType.ImageInfo:
                {
                    var filename = Path.ChangeExtension(cacheRelativePath, null);
                    filename = filename + "_INF.json";

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Sending imageinfo file for image.", "ImageUid", imagePartRequest.ImageUid, "FilePath", filename);
                    
                    string content = StorageManager.Instance.GetText(filename, StorageManager.Instance.CacheImageStore.IsEncrypted);
                    return responseFormatter.AsJson<Hydra.Entities.ImageInfo>(
                        Dicom.ImageProcessor.ParseJsonText<Hydra.Entities.ImageInfo>(content));
                }

                case Hydra.Common.ImagePartType.Frame:
                {
                    var filename = Path.ChangeExtension(cacheRelativePath, null);

                    switch (imagePartRequest.Transform)
                    {
                        case Hydra.Common.ImagePartTransform.Default:
                        case Hydra.Common.ImagePartTransform.DicomData:
                            filename = string.Format("{0}_F{1}.pix", filename, imagePartRequest.FrameNumber);
                            break;

                        case Hydra.Common.ImagePartTransform.Jpeg:
                            filename = string.Format("{0}_F{1}.jpeg", filename, imagePartRequest.FrameNumber);
                            break;

                        case Hydra.Common.ImagePartTransform.Pdf:
                            filename = string.Format("{0}_F.pdf", filename);
                            break;

                        case Hydra.Common.ImagePartTransform.Html:
                            filename = string.Format("{0}_F.html", filename);
                            break;

                        default:
                            return null;
                    }

                    if (!imagePartRequest.ExcludeImageInfo)
                    {
                        var imageInfoFilename = Path.ChangeExtension(cacheRelativePath, null);
                        imageInfoFilename = imageInfoFilename + "_INF.json";

                        string content = StorageManager.Instance.GetText(imageInfoFilename, StorageManager.Instance.CacheImageStore.IsEncrypted);
                        var responseHeaders = new Dictionary<string, string>();
                        //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                        responseHeaders.Add("imageinfo", JsonConvert.SerializeObject(JsonConvert.DeserializeObject<Hydra.Entities.ImageInfo>(content),
                                Newtonsoft.Json.Formatting.None,
                                new JsonSerializerSettings
                                {
                                    NullValueHandling = NullValueHandling.Ignore,
                                    ContractResolver = new CamelCasePropertyNamesContractResolver()
                                }));

                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Sending frame file for image with image info.", "ImageUid", imagePartRequest.ImageUid, "FilePath", filename);

                        return ResponseHelper.FromFile((int)cacheImageType, filename, StorageManager.Instance.CacheImageStore.IsEncrypted, imagePartRequest.Transform, responseHeaders);
                    }
                    else
                    {
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Sending frame file for image.", "ImageUid", imagePartRequest.ImageUid, "FilePath", filename);

                        return ResponseHelper.FromFile((int)cacheImageType, filename, StorageManager.Instance.CacheImageStore.IsEncrypted, imagePartRequest.Transform);
                    }
                }

                case Hydra.Common.ImagePartType.Overlay:
                {
                    if (!imagePartRequest.OverlayIndex.HasValue)
                        return null;

                    var filename = Path.ChangeExtension(cacheRelativePath, null);
                    filename = string.Format("{0}_F{1}_O{2}.pix", filename, imagePartRequest.FrameNumber, imagePartRequest.OverlayIndex);

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Sending overlay file for image.", "ImageUid", imagePartRequest.ImageUid, "Frame", imagePartRequest.FrameNumber, "OverlayIndex", imagePartRequest.OverlayIndex, "FilePath", filename);

                    return ResponseHelper.FromFile((int)cacheImageType, filename, StorageManager.Instance.CacheImageStore.IsEncrypted, imagePartRequest.Transform);
                }

                //case Hydra.Common.ImagePartType.Media:
                //{
                //    var filename = Path.GetFileNameWithoutExtension(cacheRelativePath);

                //    switch (imagePartRequest.Transform)
                //    {
                //        case Hydra.Common.ImagePartTransform.Mp4:
                //            filename = string.Format("{0}_AV.mp4", filename);
                //            break;

                //        case Hydra.Common.ImagePartTransform.Avi:
                //            filename = string.Format("{0}_AV.avi", filename);
                //            break;

                //        default:
                //            return null;
                //    }

                //    if (_Logger.IsDebugEnabled)
                //        _Logger.Debug("Sending media file for image.", "ImageUid", imagePartRequest.ImageUid, "FilePath", filename);

                //    return responseFormatter.AsMedia(cacheImageType, filename, StorageManager.Instance.CacheImageStore.IsEncrypted, imagePartRequest.Transform);
                //}
            }

            return null;
        }

        public static Response CreateImagePartResponse(IHixDbContextFactory ctxFactory,
                                                       Hydra.IX.Common.ImagePartRequest imagePartRequest,
                                                       Request request,
                                                       IResponseFormatter responseFormatter)
        {
            if (EnableDirectCacheAccess)
            {
                var response = CreateImagePartResponseDirect(imagePartRequest, request, responseFormatter);
                if (response != null)
                    return response;
            }

            if (imagePartRequest.Type == Hydra.Common.ImagePartType.DcmPR)
            {
                // handle dicom PR request at group level
                if (string.IsNullOrEmpty(imagePartRequest.GroupUid))
                    throw new BadRequestException("GroupUid must be valid when requesting DcmPr part");

                using (var ctx = ctxFactory.Create())
                {
                    var imageParts = ctx.ImageParts.Where(x => ((x.GroupUid == imagePartRequest.GroupUid) &&
                                                                (x.Type == (int)imagePartRequest.Type)));
                    if ((imageParts == null) || (imageParts.Count() == 0))
                        return HttpStatusCode.NoContent;

                    if (imagePartRequest.Transform == Hydra.Common.ImagePartTransform.Default)
                    {
                        // for now default to json
                        imagePartRequest.Transform = Hydra.Common.ImagePartTransform.Json;
                    }

                    string jsonText = "";
                    StringBuilder sb = new StringBuilder();
                    sb.Append("[");
                    bool first = true;
                    foreach (var imagePart in imageParts)
                    {
                        if (!first)
                            sb.Append(",");
                        first = false;

                        string content = StorageManager.Instance.GetText(imagePart);
                        sb.Append(content);
                    }
                    sb.Append("]");
                    jsonText = sb.ToString();

                    return responseFormatter.AsText(jsonText, imagePartRequest.Transform.AsContentType());
                }
            }
            else
            {
                ImagePart imagePart = GetImagePart(ctxFactory, imagePartRequest);

                switch (imagePartRequest.Type)
                {
                    case Hydra.Common.ImagePartType.Original:
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Sending original file for image.", "ImageUid", imagePart.ImageUid, "FilePath", imagePart.AbsolutePath);
                        Hydra.Common.ImagePartTransform transform = (imagePartRequest.Transform == Hydra.Common.ImagePartTransform.Mp4) ?
                                                                        Hydra.Common.ImagePartTransform.Mp4 : Hydra.Common.ImagePartTransform.Default;

                        return ResponseHelper.FromFile(imagePart, transform);

                    case Hydra.Common.ImagePartType.Abstract:
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Sending abtract file for image.", "ImageUid", imagePart.ImageUid, "FilePath", imagePart.AbsolutePath);
                        if (imagePartRequest.Transform == Hydra.Common.ImagePartTransform.Jpeg)
                            return ResponseHelper.FromFile(imagePart, Hydra.Common.ImagePartTransform.Jpeg);
                        else if ((imagePartRequest.Transform == Hydra.Common.ImagePartTransform.Json) ||
                                 (imagePartRequest.Transform == Hydra.Common.ImagePartTransform.Default))
                        {
                            byte[] content = StorageManager.Instance.GetBytes(imagePart);
                            return responseFormatter.AsJson<Hydra.Entities.Thumbnail>(new Hydra.Entities.Thumbnail(content));
                        }
                        else
                            throw new BadRequestException("Transfrom type not supported. ImageUid:{0}, Type:{1}, Frame:{2}, Transform:{3}",
                                                          imagePartRequest.ImageUid, imagePartRequest.Type, imagePartRequest.FrameNumber, imagePartRequest.Transform);

                    case Hydra.Common.ImagePartType.Header:
                        {
                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("Sending header file for image.", "ImageUid", imagePart.ImageUid, "FilePath", imagePart.AbsolutePath);
                            string content = StorageManager.Instance.GetText(imagePart);
                            return responseFormatter.AsJson<List<Hydra.Entities.DicomTag>>(
                                Dicom.ImageProcessor.ParseJsonText<List<Hydra.Entities.DicomTag>>(content));
                        }

                    case Hydra.Common.ImagePartType.ImageInfo:
                        {
                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("Sending imageinfo file for image.", "ImageUid", imagePart.ImageUid, "FilePath", imagePart.AbsolutePath);
                            string content = StorageManager.Instance.GetText(imagePart);
                            return responseFormatter.AsJson<Hydra.Entities.ImageInfo>(
                                Dicom.ImageProcessor.ParseJsonText<Hydra.Entities.ImageInfo>(content));
                        }

                    case Hydra.Common.ImagePartType.Frame:
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Sending frame file for image.", "ImageUid", imagePart.ImageUid, "FilePath", imagePart.AbsolutePath);
                        return ResponseHelper.FromFile(imagePart, imagePartRequest.Transform);

                    case Hydra.Common.ImagePartType.DcmHeader:
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Sending dicom header file for image.", "ImageUid", imagePart.ImageUid, "FilePath", imagePart.AbsolutePath);
                        return ResponseHelper.FromFile(imagePart, imagePartRequest.Transform);

                    case Hydra.Common.ImagePartType.Overlay:
                        _Logger.Debug("Sending overlay file for image.", "ImageUid", imagePart.ImageUid, "Frame", imagePart.Frame, "OverlayIndex", imagePart.OverlayIndex, "FilePath", imagePart.AbsolutePath);
                        return ResponseHelper.FromFile(imagePart, imagePartRequest.Transform);

                    case Hydra.Common.ImagePartType.Media:
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Sending media file for image.", "ImageUid", imagePart.ImageUid, "FilePath", imagePart.AbsolutePath);
                        return responseFormatter.AsMedia(imagePart, imagePartRequest.Transform, request);

                    case Hydra.Common.ImagePartType.Waveform:
                        if (imagePart.IsStatic)
                        {
                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("Sending waveform file for image.", "ImageUid", imagePart.ImageUid, "FilePath", imagePart.AbsolutePath);
                            return ResponseHelper.FromFile(imagePart, imagePartRequest.Transform);
                        }
                        else
                        {
                            if (imagePartRequest.ECGParams == null)
                                throw new BadRequestException("ECG request is not valid");

                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("Sending waveform data for image.", "ImageUid", imagePart.ImageUid);

                            // generate ecg response dynamically
                            return ResponseHelper.FromStream(imagePartRequest.Transform, p =>
                            {
                                using (var stream = StorageManager.Instance.GetStream(imagePart))
                                {
                                    Dicom.ImageProcessor.ProcessWaveform(stream, imagePartRequest.ECGParams, p);
                                }
                            });
                        }

                    default: throw new BadRequestException("Unknown request type");
                }
            }
        }

        public static ImagePart GetImagePart(IHixDbContextFactory ctxFactory, Hydra.IX.Common.ImagePartRequest request)
        {
            int startTickCount = Environment.TickCount;
            using (var ctx = ctxFactory.Create())
            {
                ImagePart imagePart = null;

                if (request.Type != Hydra.Common.ImagePartType.Original)
                {
                    imagePart = ctx.ImageParts.Where(x => ((x.ImageUid == request.ImageUid) &&
                                                           (x.Frame == request.FrameNumber) &&
                                                           (x.OverlayIndex == request.OverlayIndex) &&
                                                           (x.Type == (int)request.Type) &&
                                                           ((request.Transform == Hydra.Common.ImagePartTransform.Default) ||
                                                                (x.Transform == (int)request.Transform)))).FirstOrDefault();
                    if (imagePart == null)
                        throw new BadRequestException("Image part does not exist. ImageUid:{0}, Type:{1}, Frame:{2}, OverlayIndex:{3}, Transform:{4}",
                                                      request.ImageUid, request.Type, request.FrameNumber, request.OverlayIndex, request.Transform);
                }
                else
                {
                    // get original image
                    Hydra.IX.Database.Common.ImageFile imageFile = ctx.Images.Where(x => (x.ImageUid == request.ImageUid)).FirstOrDefault();
                    if (imageFile == null)
                        throw new BadRequestException("Image Uid {0} does not exist.", request.ImageUid);

                    Hydra.IX.Database.Common.ImageGroup imageGroup = ctx.ImageGroups.Where(x => (x.GroupUid == imageFile.GroupUid)).FirstOrDefault();
                    if (imageGroup == null)
                        throw new BadRequestException("ImageGroup Uid {0} does not exist.", imageFile.GroupUid);

                    if (!imageFile.IsUploaded)
                        throw new BadRequestException("No file uploaded for Image Uid:{0}", request.ImageUid);

                    // create dynamic image part
                    imagePart = new ImagePart
                    {
                        IsStatic = true,
                        IsEncrypted = imageFile.IsEncrypted,
                        AbsolutePath = StorageManager.Instance.GetImagePath(imageFile, imageGroup),
                        Type = (int)imageFile.ImageType
                    };
                }

                // update last access date

                if (imagePart.IsStatic)
                {
                    // ensure file exists
                    EnsureFileExists(imagePart.AbsolutePath, request.ImageUid);
                }

                var elapsed = (Environment.TickCount - startTickCount);
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Getting image part", "Time", elapsed);

                return imagePart;
            }
        }

        public static void StoreImage(IHixDbContextFactory ctxFactory, string imageUid, Stream fileStream, string alternateFilePath)
        {
            int startTickCount = Environment.TickCount;
            using (var ctx = ctxFactory.Create())
            {
                // find image file
                ImageFile imageFile = ctx.Images.FirstOrDefault(x => (x.ImageUid == imageUid));
                if (imageFile == null)
                    throw new BadRequestException(string.Format("Image {0} does not exist", imageUid));

                // find image group
                ImageGroup imageGroup = ctx.ImageGroups.FirstOrDefault(x => (x.GroupUid == imageFile.GroupUid));
                if (imageGroup == null)
                    throw new BadRequestException(string.Format("Image group {0} does not exist", imageFile.GroupUid));

                try
                {
                    // store image encrypted
                    StorageManager.Instance.StoreImage(imageFile, imageGroup, fileStream, alternateFilePath);

                    ctx.Entry(imageFile).State = System.Data.Entity.EntityState.Modified;
                    ctx.SaveChanges();

                    // add image to job queue for processing
                    ImageManager.QueueImage(imageFile.ImageUid);

                    var elapsed = (Environment.TickCount - startTickCount);
                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Storing image", "Time", elapsed);
                }
                catch (Exception ex)
                {
                    var elapsed = (Environment.TickCount - startTickCount);
                    _Logger.Error("Error storing image.", "ImageUid", imageUid, "Exception", ex.ToString(), "Time", elapsed);
                    throw;
                }
            }
        }

        public static void UpdateImage(IHixDbContextFactory ctxFactory, string imageUid, CancellationToken token)
        {
            try
            {
                using (var ctx = ctxFactory.Create())
                {
                    // get image
                    ImageFile imageFile = ctx.Images.Where(x => (x.ImageUid == imageUid)).FirstOrDefault();
                    if (imageFile == null)
                        throw new Exception("Image uid is not valid");

                    // get image group
                    ImageGroup imageGroup = ctx.ImageGroups.Where(x => (x.GroupUid == imageFile.GroupUid)).FirstOrDefault();
                    if (imageGroup == null)
                        throw new Exception("Image group Uid not valid");

                    // check if update is necessary
                    if ((imageFile.DicomXml != null) && (imageFile.DicomDirXml != null))
                        return;

                    _Logger.Info("Updating image.", "ImageUid", imageFile.ImageUid);

                    try
                    {
                        string filePath = null;
                        Dicom.ImageUpdateResultset resultset = null;
                        var fileStorage = StorageManager.Instance.GetFileStorage();
                        var studyBuilder = new StudyBuilder(imageGroup, imageFile.StudyId, HixService.Instance.ServiceMode == HixServiceMode.Worker);

                        // get header
                        if (imageFile.IsEncrypted)
                        {
                            using (var memoryStream = StorageManager.Instance.GetImageStream(imageFile, imageGroup, out filePath))
                            {
                                resultset = Dicom.ImageProcessor.UpdateImage(memoryStream, null, studyBuilder);
                            }
                        }
                        else
                        {
                            filePath = StorageManager.Instance.GetImagePath(imageFile, imageGroup);
                            resultset = Dicom.ImageProcessor.UpdateImage(null, filePath, studyBuilder);
                        }

                        imageFile.DicomDirXml = resultset.DicomDirXml;

                        if (resultset.Tags != null)
                        {
                            imageFile.DicomXml = HipaaUtil.Encrypt(resultset.Tags);
                        }

                        ctx.Entry(imageFile).State = System.Data.Entity.EntityState.Modified;
                        ctx.SaveChanges();

                        _Logger.Info("Completed updating image", "ImageUid", imageFile.ImageUid);
                    }
                    catch (Exception ex)
                    {
                        _Logger.Error("Error updating image.", "ImageUid", imageFile.ImageUid, "Exception", ex.ToString());
                    }
                    finally
                    {
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error updating image.", "ImageUid", imageUid, "Exception", ex.ToString());
            }
            finally
            {
            }
        }

        public static void StartQueuedImageManager(bool useWorkerPool,
                                                   int workerPoolSize,
                                                   bool reprocessFailedImages = true)
        {
            ImageManager.Start(useWorkerPool, workerPoolSize);

            if (reprocessFailedImages)
            {
                _Logger.Info("Reprocessing failed images...");
                ImageManager.QueuePendingImages();
            }
        }

        public static void StopQueuedImageManager()
        {
            if (ImageManager != null)
                ImageManager.Stop();
        }

        internal static void EnsureFileExists(string filePath, string imageUid)
        {
        }

        public static string GetOrCreateImageGroupDetailsJson(IHixDbContextFactory ctxFactory, string groupUid)
        {
            using (var ctx = ctxFactory.Create())
            {
                var imageGroup = ctx.ImageGroups.Where(x => (x.GroupUid == groupUid)).FirstOrDefault();
                if (imageGroup == null)
                    throw new BadRequestException("Image group {0} not found", groupUid);

                // todo: lock here
                if (string.IsNullOrEmpty(imageGroup.Xml) || !CacheStudyMetadata)
                {
                    ImageGroupDetails imageGroupDetails = new ImageGroupDetails
                    {
                        GroupUid = groupUid
                    };

                    ImageGroupUtil.CreateImageGroupDetails(ctxFactory, imageGroupDetails);

                    JavaScriptSerializer serializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
                    imageGroup.Xml = serializer.Serialize(imageGroupDetails);
                }

                imageGroup.DateAccessed = DateTime.UtcNow;

                ctx.Entry(imageGroup).State = System.Data.Entity.EntityState.Modified;
                ctx.SaveChanges();

                return imageGroup.Xml;
            }
        }

        // get specified image group and all its children as a list. If specified group does not exist, then 
        // get its children
        private static List<ImageGroup> GetImageGroupList(IHixDbContext ctx, string imageGroupUid)
        {
            var imageGroupList = new List<ImageGroup>();

            ImageGroup imageGroup = ctx.ImageGroups.Where(x => (x.GroupUid == imageGroupUid)).FirstOrDefault();
            if (imageGroup != null)
                imageGroupList.Add(imageGroup);

            AddImageGroupChildren(ctx, imageGroupUid, imageGroupList);

            return imageGroupList;
        }

        private static void AddImageGroupChildren(IHixDbContext ctx, string imageGroupUid, List<ImageGroup> imageGroupList)
        {
            // find immediate children
            IQueryable<ImageGroup> imageGroupChildren = ctx.ImageGroups.Where(x => (x.ParentGroupUid == imageGroupUid));
            foreach (var childImageGroup in imageGroupChildren)
            {
                imageGroupList.Add(childImageGroup);

                AddImageGroupChildren(ctx, childImageGroup.GroupUid, imageGroupList);
            }
        }

        public static void CreateDisplayContextRecord(IHixDbContextFactory ctxFactory, NewDisplayContextRequest request)
        {
            int startTickCount = Environment.TickCount;
            using (var ctx = ctxFactory.Create())
            {
                // create image group in separate transaction. it can be deleted explicity in case of error
                var imageGroupRecord = CreateImageGroupRecord(ctxFactory, new NewImageGroupRequest
                    {
                        ParentGroupUid = request.ParentGroupUid,
                        RequestedImageGroupUid = request.RequestedImageGroupUid
                    });

                try
                {
                    // create new display context
                    var displayContext = new DisplayContext
                    {
                        ContextId = request.ContextId,
                        Data = request.Data,
                        GroupUid = imageGroupRecord.GroupUid,
                        Name = request.Name
                    };

                    if (request.ImageDataGroupList != null)
                        foreach (var imageDataGroup in request.ImageDataGroupList)
                        {
                            if (imageDataGroup.ImageData != null)
                                displayContext.ImageCount += imageDataGroup.ImageData.Count;
                        }

                    ctx.DisplayContexts.Add(displayContext);

                    // update tag table
                    if (!string.IsNullOrEmpty(request.Tag))
                    {
                        var tag = TagUtil.AddOrGetTag(ctx, request.Tag);
                        TagUtil.AssociateTag(ctx, displayContext, tag);
                    }

                    // createa image records
                    if (request.ImageDataGroupList != null)
                    {
                        foreach (var imageDataGroup in request.ImageDataGroupList)
                        {
                            if (imageDataGroup.ImageData == null)
                                continue;

                            foreach (var imageData in imageDataGroup.ImageData)
                            {
                                // create empty image record
                                var imageFile = new ImageFile
                                {
                                    ImageUid = !string.IsNullOrEmpty(imageData.RequestedImageUid) ? imageData.RequestedImageUid : Guid.NewGuid().ToString(),
                                    GroupUid = imageGroupRecord.GroupUid,
                                    RootGroupUid = imageGroupRecord.ParentGroupUid, //todo: check this later.
                                    FileName = imageData.FileName,
                                    FileType = imageData.FileType,
                                    RefImageUid = null,
                                    //ImageType = (imageData.FileType == Hydra.Common.FileType.Blob) ? Hydra.Common.ImageType.Blob : Hydra.Common.ImageType.Unknown,
                                    ImageType = Hydra.Common.ImageType.Unknown,
                                    Description = imageData.Description,
                                    StudyId = imageDataGroup.StudyId,
                                    StudyDescription = imageDataGroup.StudyDescription,
                                    StudyDateTime = imageDataGroup.StudyDateTime,
                                    PatientDescription = imageDataGroup.PatientDescription,
                                    IsOwner = imageDataGroup.IsOwner,
                                    ExternalImageId = imageData.ExternalImageId
                                };

                                ctx.Images.Add(imageFile);

                                _Logger.Info("Image added to group.", "ImageUid", imageFile.ImageUid, "GroupUid", imageFile.GroupUid, "FilePath", imageFile.FileName);
                            }
                        }
                    }

                    ctx.SaveChanges();


                    var elapsed = (Environment.TickCount - startTickCount);
                    _Logger.Info("Display context created.", "ContextId", displayContext.ContextId, "Time", elapsed);
                }
                catch (Exception ex)
                {
                    var elapsed = (Environment.TickCount - startTickCount);
                    _Logger.Error("Error creating display context record", "ContextId", request.ContextId, "Exception", ex.ToString(), "Time", elapsed);
                    // todo: delete image group

                    throw;
                }

            }
        }

        public static void CreateEventLogRecord(IHixDbContextFactory ctxFactory, EventLogRequest request)
        {
            using (var ctx = ctxFactory.Create())
            {
                var eventLogRecord = new EventLogRecord
                {
                    TransactionUid = request.TransactionUid,
                    ContextType = (int)request.ContextType,
                    Context = request.Context,
                    MessageType = (int)request.MessageType,
                    Message = request.Message
                };

                DateTime dateTime;
                if (DateTime.TryParse(request.StartTime, out dateTime))
                    eventLogRecord.StartTime = dateTime;
                if (DateTime.TryParse(request.EndTime, out dateTime))
                    eventLogRecord.EndTime = dateTime;

                ctx.EventLogRecords.Add(eventLogRecord);
                ctx.SaveChanges();
            }
        }

        public static void SetImageRecordError(IHixDbContextFactory ctxFactory, string imageUid, string error)
        {
            using (var ctx = ctxFactory.Create())
            {
                // find image file
                ImageFile imageFile = ctx.Images.FirstOrDefault(x => (x.ImageUid == imageUid));
                if (imageFile == null)
                    throw new BadRequestException(string.Format("Image {0} does not exist", imageUid));

                try
                {
                    imageFile.IsSucceeded = false;
                    imageFile.ImageXml = error;

                    ctx.Entry(imageFile).State = System.Data.Entity.EntityState.Modified;
                    ctx.SaveChanges();
                }
                catch (Exception ex)
                {
                    _Logger.Error("Error setting image record error", "ImageUid", imageUid, "Exception", ex.ToString());
                    throw;
                }
            }
        }

        public static List<EventLogItem> GetEventLogItems(IHixDbContextFactory ctxFactory, int? pageSize, int? pageIndex)
        {
            pageSize = !pageSize.HasValue ? 100 : Math.Max(10, pageSize.Value);
            pageIndex = !pageIndex.HasValue ? 1 : Math.Max(1, pageIndex.Value);
            int skipRows = (pageIndex.Value - 1) * pageSize.Value;

            var items = new List<EventLogItem>();

            using (var ctx = ctxFactory.Create())
            {
                var records = ctx.EventLogRecords.OrderByDescending(x => x.Id).Skip(skipRows).Take(pageSize.Value);
                foreach (var record in records)
                {
                    var item = new EventLogItem
                        {
                            Id = record.Id,
                            StartTime = record.StartTime.HasValue ? record.StartTime.ToString() : null,
                            EndTime = record.EndTime.HasValue ? record.EndTime.ToString() : null,
                            TransactionUid = record.TransactionUid,
                            ContextType = record.ContextType,
                            Context = record.Context,
                            MessageType = record.MessageType,
                            Message = record.Message
                        };

                    if (record.StartTime.HasValue && record.EndTime.HasValue)
                        item.TimeSpan = (record.EndTime.Value - record.StartTime.Value).Milliseconds;

                    items.Add(item);
                }
            }

            return items;
        }

        public static int AddUpdateDictionaryRecord(IHixDbContextFactory ctxFactory, string name, string value)
        {
            using (var ctx = ctxFactory.Create())
            {
                var uppercaseName = name.ToUpper();
                var record = ctx.DictionaryRecords.Where(x => x.Name == uppercaseName).SingleOrDefault();
                if (record != null)
                {
                    record.Value = value;
                    ctx.Entry(record).State = System.Data.Entity.EntityState.Modified;
                }
                else
                {
                    record = new DictionaryRecord
                    {
                        Name = name,
                        Value = value
                    };

                    ctx.DictionaryRecords.Add(record);
                }

                ctx.SaveChanges();

                return record.Id;
            }
        }

        public static void DeleteDictionaryRecord(IHixDbContextFactory ctxFactory, string name)
        {
            using (var ctx = ctxFactory.Create())
            {
                var uppercaseName = name.ToUpper();
                var record = ctx.DictionaryRecords.Where(x => x.Name == uppercaseName).SingleOrDefault();
                if (record == null)
                    throw new BadRequestException("Dictionary record does not exist");

                ctx.DictionaryRecords.Remove(record);
                ctx.SaveChanges();
            }
        }

        public static DictionaryRecord GetDictionaryRecord(IHixDbContextFactory ctxFactory, string name)
        {
            using (var ctx = ctxFactory.Create())
            {
                var uppercaseName = name.ToUpper();
                var record = ctx.DictionaryRecords.Where(x => x.Name == uppercaseName).SingleOrDefault();
                if (record == null)
                    throw new BadRequestException("Dictionary record does not exist");

                return record;
            }
        }

        public static DictionaryRecord[] SearchDictionaryRecords(IHixDbContextFactory ctxFactory, string name)
        {
            using (var ctx = ctxFactory.Create())
            {
                var uppercaseName = name.ToUpper();

                var records = ctx.DictionaryRecords.Where(x => x.Name.Contains(uppercaseName)).ToArray();
                return records;
            }
        }
    }
}