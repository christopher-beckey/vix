using Hydra.IX.Common;
using Hydra.IX.Configuration;
using Hydra.IX.Database;
using Hydra.IX.Database.Common;
using Hydra.IX.Storage;
using Hydra.Log;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Z.EntityFramework.Plus;

namespace Hydra.IX.Core
{
    public class PurgeHandler : Hydra.IX.Core.IPurgeHandler
    {
        private static readonly ILogger _PurgeLogger = LogManager.GetPurgeLogger();
        private CancellationTokenSource _TaskCancelToken = null;
        private Task _Task = null;
        private object _SyncLock = new object();
        
        public void Start(PurgeRequest purgeRequest)
        {
            lock (_SyncLock)
            {
                if ((_Task != null) && !_Task.IsCompleted)
                {
                    if (_PurgeLogger.IsWarnEnabled)
                        _PurgeLogger.Warn("Cannot start purge. Purge already in progress");
                    
                    return;
                }

                _TaskCancelToken = new CancellationTokenSource();
                _Task = Task.Factory.StartNew(() =>
                    {
                        Execute(purgeRequest, _TaskCancelToken.Token);
                    });
            }
        }

        public void Stop()
        {
            lock (_SyncLock)
            {
                if ((_Task != null) && !_Task.IsCompleted)
                {
                    if (_PurgeLogger.IsInfoEnabled)
                        _PurgeLogger.Info("Stopping purge.");

                    _TaskCancelToken.Cancel();
                    _Task.Wait();
                    _Task = null;
                    _TaskCancelToken = null;

                    if (_PurgeLogger.IsInfoEnabled)
                        _PurgeLogger.Info("Purge stopped.");
                }
            }
        }

        private void Execute(PurgeRequest purgeRequest, CancellationToken token)
        {
            try
            {
                if (_PurgeLogger.IsInfoEnabled)
                    _PurgeLogger.Info("Performing cache purge");

                // perform disk based purge
                if (purgeRequest.MaxCacheSizeMB.HasValue && (purgeRequest.MaxCacheSizeMB.Value > 0))
                {
                    if (_PurgeLogger.IsDebugEnabled)
                        _PurgeLogger.Debug("Checking Cache directory size");

                    double currentDirSizeMB = 0;
                    if (StorageManager.Instance.IsCacheFull(purgeRequest.MaxCacheSizeMB.Value, out currentDirSizeMB))
                    {
                        if (_PurgeLogger.IsWarnEnabled)
                            _PurgeLogger.Warn("Cache directory full", "CurrentDirSizeMB", currentDirSizeMB, "MaxCacheSizeMB", purgeRequest.MaxCacheSizeMB.Value);

                        // traverse image groups oldest to newest blockwise
                        var ctxFactory = new HixDbContextFactory();
                        int blockNumber = 0;

                        bool purgeComplete = false;
                        while (!purgeComplete)
                        {
                            var codeClock = Hydra.Common.CodeClock.Start();
                            List<ImageGroupPurgeData> imageGroupList = null;

                            using (var ctx = ctxFactory.Create())
                            {
                                if (_PurgeLogger.IsDebugEnabled)
                                    _PurgeLogger.Debug("Searching for image groups to delete");

                                imageGroupList = ctx.ImageGroups.OrderByDescending(x => x.DateAccessed)
                                                                    .Select(x => new ImageGroupPurgeData
                                                                    {
                                                                        GroupUid = x.GroupUid,
                                                                        ParentGroupUid = x.ParentGroupUid,
                                                                        FolderNumber = x.FolderNumber,
                                                                        ImageStoreId = x.ImageStoreId,
                                                                        RelativePath = x.RelativePath
                                                                    })
                                                                    .Skip(blockNumber)
                                                                    .Take(purgeRequest.ImageGroupPurgeBlockSize.Value).ToList();

                                if (_PurgeLogger.IsDebugEnabled)
                                    _PurgeLogger.Debug("Found image groups to delete", "Count", imageGroupList.Count(), "Time", codeClock.ElapsedSeconds);
                            }

                            if (imageGroupList.Count == 0)
                                break;

                            blockNumber += purgeRequest.ImageGroupPurgeBlockSize.Value;
                            using (var ctx = ctxFactory.Create())
                            {
                                foreach (var imageGroup in imageGroupList)
                                {
                                
                                    DeleteImageGroup(ctx, imageGroup);
                                    
                                }

                                token.ThrowIfCancellationRequested();
                                ctx.SaveChanges();
                            }

                            // check cache directory size after a block of image groups have been deleted.
                            currentDirSizeMB = 0;
                            if (!StorageManager.Instance.IsCacheFull(purgeRequest.MaxCacheSizeMB.Value, out currentDirSizeMB))
                            {
                                if (_PurgeLogger.IsDebugEnabled)
                                    _PurgeLogger.Debug("Cache directory purged", "CurrentCacheSizeMB", currentDirSizeMB, "MaxCacheSizeMB", purgeRequest.MaxCacheSizeMB.Value);

                                purgeComplete = true;
                                break;
                            }
                        }
                    }
                }

                if (purgeRequest.MaxAgeDays.HasValue && (purgeRequest.MaxAgeDays.Value > 0))
                {
                    DateTime expirationDate = DateTime.UtcNow - TimeSpan.FromDays(purgeRequest.MaxAgeDays.Value);

                    var codeClock = Hydra.Common.CodeClock.Start();
                    List<ImageGroupPurgeData> imageGroupList = null;

                    var ctxFactory = new HixDbContextFactory();
                    using (var ctx = ctxFactory.Create())
                    {
                        if (_PurgeLogger.IsDebugEnabled)
                            _PurgeLogger.Debug("Searching for image groups that have expired", "ExpirationDate", expirationDate.ToShortDateString());

                        imageGroupList = ctx.ImageGroups.Where(x => x.DateAccessed < expirationDate)
                                                            .Select(x => new ImageGroupPurgeData
                                                            {
                                                                GroupUid = x.GroupUid,
                                                                ParentGroupUid = x.ParentGroupUid,
                                                                FolderNumber = x.FolderNumber,
                                                                ImageStoreId = x.ImageStoreId,
                                                                RelativePath = x.RelativePath
                                                            }).ToList();

                        if (_PurgeLogger.IsDebugEnabled)
                            _PurgeLogger.Debug("Found image groups that have expired", "Count", imageGroupList.Count(), "Time", codeClock.ElapsedSeconds);
                    }

                    // loop through image groups, deleting images and corresponding display contexts
                    using (var ctx = ctxFactory.Create())
                    {
                        foreach (var imageGroup in imageGroupList)
                        {
                                DeleteImageGroup(ctx, imageGroup);
                        }

                        token.ThrowIfCancellationRequested();
                        ctx.SaveChanges();
                    }
                }

                if (purgeRequest.MaxEventLogAgeDays.HasValue && (purgeRequest.MaxEventLogAgeDays.Value > 0))
                {
                    try
                    {
                        DateTime expirationDate = DateTime.UtcNow - TimeSpan.FromDays(purgeRequest.MaxEventLogAgeDays.Value);

                        // delete expired event logs
                        var ctxFactory = new HixDbContextFactory();
                        using (var ctx = ctxFactory.Create())
                        {
                            ctx.EventLogRecords.Where(x => x.StartTime < expirationDate).Delete();
                            ctx.SaveChanges();
                        }
                    }
                    catch (Exception ex)
                    {
                        _PurgeLogger.Error("Error deleting expired event log records", "Exception", ex.Message);
                    }
                }

                //try
                //{
                //    // delete image parts with no corresponding image groups
                //    var ctxFactory = new HixDbContextFactory();
                //    using (var ctx = ctxFactory.Create())
                //    {
                //        // get image uids whose images parts have no corresponding image groups
                //        var imageUidList = ctx.ImageParts.Where(x => !ctx.ImageGroups.Select(y => y.GroupUid).Contains(x.GroupUid)).Select(z => z.ImageUid).Distinct().ToList();
                //        if (imageUidList.Count > 0)
                //        {
                //            if (_PurgeLogger.IsInfoEnabled)
                //                _PurgeLogger.Info("Deleting images with orphaned image parts.", "Count", imageUidList.Count);

                //            foreach (var imageUid in imageUidList)
                //            {
                //                DeleteImageParts(ctx, )
                //                StorageManager.Instance.DeleteImageParts(imageUid);
                //            }
                //        }
                //    }
                //}
                //catch (Exception ex)
                //{
                //    _PurgeLogger.Error("Error deleting images with orphaned image parts.", "Exception", ex.Message);
                //}

                token.ThrowIfCancellationRequested();

                try
                {
                    // delete study parent records no corresponding image groups
                    var ctxFactory = new HixDbContextFactory();
                    using (var ctx = ctxFactory.Create())
                    {
                        ctx.StudyParentRecords.Where(x => !ctx.ImageGroups.Select(y => y.GroupUid).Contains(x.GroupUid)).Delete();
                        ctx.SaveChanges();
                    }
                }
                catch (Exception ex)
                {
                    _PurgeLogger.Error("Error deleting orphaned study parent records", "Exception", ex.Message);
                }

                token.ThrowIfCancellationRequested();

                try
                {
                    if (_PurgeLogger.IsInfoEnabled)
                        _PurgeLogger.Info("Deleting empty folders in cache");

                    int folderCount = StorageManager.Instance.DeleteEmptyFolders();

                    if (_PurgeLogger.IsInfoEnabled)
                        _PurgeLogger.Info("Deleting empty folders in cache completed", "Count", folderCount);
                }
                catch (Exception ex)
                {
                    _PurgeLogger.Error("Error empty folders in cache", "Exception", ex.Message);
                }

                if (_PurgeLogger.IsInfoEnabled)
                    _PurgeLogger.Info("Cache purge completed");
            }
            catch (Exception ex)
            {
                if (ex is OperationCanceledException)
                    _PurgeLogger.Info("Cache purge cancelled");
                else
                    _PurgeLogger.Error("Error performing cache purge.", "Exception", ex.Message);
            }
            finally
            {
            }
        }

        private void PopulateImageGroupTree(IHixDbContext ctx, ImageGroupPurgeData imageGroup, List<ImageGroupPurgeData> imageGroupList)
        {
            // find corresponding display context
            imageGroup.ContextId = ctx.DisplayContexts.Where(x => x.GroupUid == imageGroup.GroupUid).Select(x => x.ContextId).SingleOrDefault();
            if (string.IsNullOrEmpty(imageGroup.ContextId))
            {
                if (_PurgeLogger.IsDebugEnabled)
                    _PurgeLogger.Debug("No matching display context found.", "GroupUid", imageGroup.GroupUid);
            }

            imageGroupList.Add(imageGroup);

            // find immediate children
            IQueryable<ImageGroupPurgeData> imageGroupChildren = ctx.ImageGroups.Where(x => (x.ParentGroupUid == imageGroup.GroupUid))
                                                                    .Select(x => new ImageGroupPurgeData
                                                                    {
                                                                        GroupUid = x.GroupUid,
                                                                        ParentGroupUid = x.ParentGroupUid,
                                                                        FolderNumber = x.FolderNumber,
                                                                        ImageStoreId = x.ImageStoreId,
                                                                        RelativePath = x.RelativePath
                                                                    });
            foreach (var childImageGroup in imageGroupChildren)
            {
                PopulateImageGroupTree(ctx, childImageGroup, imageGroupList);
            }
        }

        private void DeleteImageGroup(IHixDbContext ctx, ImageGroupPurgeData imageGroup)
        {
            try
            {
                if (_PurgeLogger.IsInfoEnabled)
                    _PurgeLogger.Info("Deleting image group.", "GroupUid", imageGroup.GroupUid);

                // find all image groups in the hierarchy
                var imageGroupList = new List<ImageGroupPurgeData>();
                PopulateImageGroupTree(ctx, imageGroup, imageGroupList);

                // reverse image group list so that children are deleted first
                imageGroupList.Reverse();

                foreach (var item in imageGroupList)
                {
                    ctx.SeriesRecords.Where(x => (x.GroupUid == item.GroupUid)).Delete();
                    ctx.StudyRecords.Where(x => (x.GroupUid == item.GroupUid)).Delete();
                    ctx.StudyParentRecords.Where(x => (x.GroupUid == item.GroupUid)).Delete();

                    if (_PurgeLogger.IsInfoEnabled)
                        _PurgeLogger.Info("Image group (and its children) staged for deletion.", "GroupUid", item.GroupUid);
                }

                var contextIdList = imageGroupList.Where(x => x.ContextId != null).Select(x => x.ContextId).ToList(); 
                ctx.DisplayContexts.Where(x => contextIdList.Contains(x.ContextId)).Delete();

                if (_PurgeLogger.IsInfoEnabled)
                    _PurgeLogger.Info("Display context (and its children) staged for deletion.", "GroupUid", imageGroup.GroupUid);

                // start deleting images and image parts using the parent image group only
                DeleteImages(ctx, imageGroup);
                DeleteImageParts(ctx, imageGroup);

                var groupUidList = imageGroupList.Select(y => y.GroupUid).ToList();
                ctx.ImageGroups.Where(x => groupUidList.Contains(x.GroupUid)).Delete();
            }
            catch (Exception ex)
            {
                _PurgeLogger.Error("Error deleting image group record", "Exception", ex.ToString());
            }
        }

        private void SafeDeleteFolder(string folder, string groupUid)
        {
            if (Directory.Exists(folder))
            {
                // delete folder
                try
                {
                    if (_PurgeLogger.IsInfoEnabled)
                        _PurgeLogger.Info("Deleting folder for image group", "GroupUid", groupUid, "Folder", folder);

                    Directory.Delete(folder, true);
                }
                catch (Exception ex)
                {
                    _PurgeLogger.Info("Error deleting folder for image group", "GroupUid", groupUid, "Folder", folder, "Exception", ex.ToString());
                }
            }
            else
            {
                if (_PurgeLogger.IsWarnEnabled)
                    _PurgeLogger.Warn("Folder does not exist", "GroupUid", groupUid, "Folder", folder);
            }
        }

        private void DeleteImages(IHixDbContext ctx, ImageGroupPurgeData imageGroup)
        {
            if (_PurgeLogger.IsInfoEnabled)
                _PurgeLogger.Info("Deleting images for image group", "GroupUid", imageGroup.GroupUid, "RelativePath", imageGroup.RelativePath);

            // get folder path for images folder
            if (!string.IsNullOrEmpty(imageGroup.RelativePath))
            {
                string folder = StorageManager.Instance.GetPrimaryFolder(imageGroup.ImageStoreId, imageGroup.RelativePath);

                if (_PurgeLogger.IsInfoEnabled)
                    _PurgeLogger.Info("Deleting folder for image group", "GroupUid", imageGroup.GroupUid, "Folder", folder);
                
                SafeDeleteFolder(folder, imageGroup.GroupUid);
            }

            // delete all image parts
            ctx.Images.Where(x => x.GroupUid == imageGroup.GroupUid).Delete();
        }

        private void DeleteImageParts(IHixDbContext ctx, ImageGroupPurgeData imageGroup)
        {
            DeleteImageParts(ctx, imageGroup.GroupUid);
        }

        private void DeleteImageParts(IHixDbContext ctx, string groupUid)
        {
            if (_PurgeLogger.IsInfoEnabled)
                _PurgeLogger.Info("Deleting image parts for image group", "GroupUid", groupUid);

            //VAI-307 Purge the related PDF file if there is one
            var imageParts = ctx.ImageParts.Where(x => (x.GroupUid == groupUid ) && (x.Frame==0) );
            if (imageParts != null)
            {
                foreach (var imagePartx in imageParts)
                {
                    StorageManager.Instance.PurgePdf(imagePartx.ImageUid, imagePartx.AbsolutePath);
                }
            }
        
            // find the first image part in the image group
            var imagePart = ctx.ImageParts.Where(x => x.GroupUid == groupUid).FirstOrDefault();
            if (imagePart != null)
            {
                var folder = Path.GetDirectoryName(imagePart.AbsolutePath);

                SafeDeleteFolder(folder, groupUid);
            }

            // delete all image parts
            ctx.ImageParts.Where(x => x.GroupUid == groupUid).Delete();
        }

        public object GetCacheStatus()
        {
            try
            {
                JObject cacheStatus = new JObject();

                var ctxFactory = new HixDbContextFactory();
                using (var ctx = ctxFactory.Create())
                {
                    var count = ctx.DisplayContexts.Count();
                    cacheStatus.Add("NumStudies", count);

                    count = ctx.ImageGroups.Count();
                    cacheStatus.Add("NumImageGroups", count);

                    count = ctx.Images.Count();
                    cacheStatus.Add("NumImages", count);

                    count = ctx.ImageParts.Count();
                    cacheStatus.Add("NumImageParts", count);

                    count = ctx.StudyRecords.Count();
                    cacheStatus.Add("NumStudyRecords", count);

                    count = ctx.SeriesRecords.Count();
                    cacheStatus.Add("NumSeriesRecords", count);

                    count = ctx.StudyParentRecords.Count();
                    cacheStatus.Add("NumStudyParentRecords", count);

                    count = ctx.EventLogRecords.Count();
                    cacheStatus.Add("NumEventLogRecords", count);

                    var bad = new JObject();

                    // total number of broken studies
                    count = ctx.DisplayContexts.Where(x => !ctx.ImageGroups.Select(y => y.GroupUid).Contains(x.GroupUid)).Count();
                    bad.Add("NumStudies", count);

                    // total number of broken image groups
                    count = ctx.ImageGroups.Where(x => !ctx.DisplayContexts.Select(y => y.GroupUid).Contains(x.GroupUid)).Count();
                    bad.Add("NumImageGroups", count);

                    count = ctx.Images.Where(x => !ctx.ImageGroups.Select(y => y.GroupUid).Contains(x.GroupUid)).Count();
                    bad.Add("NumImages", count);

                    count = ctx.ImageParts.Where(x => !ctx.ImageGroups.Select(y => y.GroupUid).Contains(x.GroupUid)).Count();
                    bad.Add("NumImageParts", count);

                    count = ctx.StudyRecords.Where(x => !ctx.ImageGroups.Select(y => y.GroupUid).Contains(x.GroupUid)).Count();
                    bad.Add("NumStudyRecords", count);

                    count = ctx.SeriesRecords.Where(x => !ctx.ImageGroups.Select(y => y.GroupUid).Contains(x.GroupUid)).Count();
                    bad.Add("NumSeriesRecords", count);

                    count = ctx.StudyParentRecords.Where(x => !ctx.ImageGroups.Select(y => y.GroupUid).Contains(x.GroupUid)).Count();
                    bad.Add("NumStudyParentRecords", count);

                    cacheStatus.Add("Bad", bad);

                    // get db size
                    var dbSpaceUsed = ctx.GetSpaceUsed();
                    var spaceUsed = new JObject();
                    spaceUsed.Add("DatabaseSize", dbSpaceUsed.DatabaseSize);
                    cacheStatus.Add("Database", spaceUsed);
                }

                // get cache size
                double currentCacheSizeMB = 0;
                bool isCacheFull = StorageManager.Instance.IsCacheFull(HixConfigurationSection.Instance.Purge.MaxCacheSizeMB, out currentCacheSizeMB);
                cacheStatus.Add("CacheSizeMB", currentCacheSizeMB.ToString("F"));
                cacheStatus.Add("MaxCacheSizeMB", HixConfigurationSection.Instance.Purge.MaxCacheSizeMB);

                return cacheStatus;
            }
            catch (Exception ex)
            {
                _PurgeLogger.Error("Error getting cache status.", "Exception", ex.Message);
                throw;
            }
        }

    }
}
