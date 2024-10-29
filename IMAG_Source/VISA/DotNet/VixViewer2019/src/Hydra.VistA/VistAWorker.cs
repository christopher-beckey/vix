using Hydra.IX.Client;
using Hydra.Log;
using System;
using System.IO;
using System.ServiceModel;
using System.Threading;

namespace Hydra.VistA
{
    [ServiceBehavior(IncludeExceptionDetailInFaults = true, InstanceContextMode = InstanceContextMode.PerSession)]
    public class VistAWorker : IVistAWorker
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private string _WorkerId = null;
        private static Hydra.IX.Common.BackgroundWorker<JobData> _JobQueue = null;

        class JobData
        {
            public string SecurityToken { get; set; }
            public string TransactionUid { get; set; }
            public Hydra.IX.Common.ImageRecord ImageRecord { get; set; }
        }

        public VistAWorker()
        {
            var vixServiceElement = VistAConfigurationSection.Instance.GetVixService(VixServiceType.Render);
            if (vixServiceElement != null)
                HixConnectionFactory.HixUrl = vixServiceElement.RootUrl;

            _WorkerId = System.Diagnostics.Process.GetCurrentProcess().Id.ToString();

        }

        public void Connect()
        {
            _Logger.Info("Client connected. Starting job queue.", "WorkerId", _WorkerId);

            if (_JobQueue == null)
            {
                _JobQueue = new Hydra.IX.Common.BackgroundWorker<JobData>(
                                                    VistAConfigurationSection.Instance.WorkerThreadPoolSize,
                                                    (job, workerId, workerIndex, token) => ProcessJob(job.ImageRecord, job.SecurityToken, job.TransactionUid, workerId, token));
                _JobQueue.Start(true);

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Job queue ready", "WorkerId", _WorkerId);
            }
        }

        public void Shutdown()
        {
            if (_JobQueue != null)
            {
                _JobQueue.Wait();
                _JobQueue = null;

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Job queue destroyed.", "WorkerId", _WorkerId);
            }

            VistAWorkerHost.EnableShutdown();
        }

        public void ProcessDisplayContext(VistAWorkerData data)
        {
            int startTickCount = Environment.TickCount;
            _Logger.Info("Caching started.", "WorkerId", _WorkerId, "ContextId", data.ContextId);

            try
            {
                var imageRecords = data.ImageRecords;

                if (imageRecords == null)
                {
                    // get display context record 
                    var hixConnection = HixConnectionFactory.Create();
                    var displayContextRecord = hixConnection.GetDisplayContextRecord(data.ContextId);

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Retrieved DisplayContext record.", "WorkerId", _WorkerId, "ContextId", data.ContextId);

                    var imageGroupRecord = hixConnection.GetImageGroupRecord(displayContextRecord.GroupUid);

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Retrieved ImageGroup record.", "WorkerId", _WorkerId, "ContextId", data.ContextId);

                    imageRecords = imageGroupRecord.Images;
                }

                foreach (var imageRecord in imageRecords)
                {
                    _JobQueue.QueueJob(new JobData { ImageRecord = imageRecord, 
                                                     SecurityToken = data.SecurityToken, 
                                                     TransactionUid = data.TransactionUid });
                }

                _JobQueue.WaitUntilEmpty(500);

                var elapsed = (Environment.TickCount - startTickCount);
                _Logger.Info("Caching completed.", "WorkerId", _WorkerId, "ContextId", data.ContextId, "Time", elapsed);

            }
            catch (Exception ex)
            {
                var elapsed = (Environment.TickCount - startTickCount);
                _Logger.Error("Error processing display context.", "Exception", ex.ToString(), "Time", elapsed);
                throw;
            }
        }

        private void ProcessJob(Hydra.IX.Common.ImageRecord imageRecord, string securityToken, string transactionUid, int jobId, CancellationToken token)
        {
            // ignore if already uploaded
            if (imageRecord.IsUploaded)
                return;

            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Getting image.", "WorkerId", _WorkerId, "ImageUid", imageRecord.ImageUid, "FilePath", imageRecord.FileName);

                if (VixServiceUtil.CanAccessVixCache)
                {
                    // try to locate image in vix cache
                    string imageCacheLocation = VixServiceUtil.GetImageCacheLocation(imageRecord.FileName, securityToken, transactionUid);
                    if (!string.IsNullOrEmpty(imageCacheLocation))
                    {
                        if (File.Exists(imageCacheLocation))
                        {
                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("Using image from cache.", "WorkerId", _WorkerId, "ImageUid", imageRecord.ImageUid, "FilePath", imageRecord.FileName, "CacheLocation", imageCacheLocation);

                            var hixConnection = HixConnectionFactory.Create();
                            hixConnection.ProcessImageFile(imageRecord.ImageUid, imageCacheLocation);

                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("Image sent to Hix for processing", "WorkerId", _WorkerId, "ImageUid", imageRecord.ImageUid, "FilePath", imageRecord.FileName, "CacheLocation", imageCacheLocation);

                            return;
                        }
                        else
                        {
                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("Image not found in cache location.", "WorkerId", _WorkerId, "ImageUid", imageRecord.ImageUid, "FilePath", imageRecord.FileName, "CacheLocation", imageCacheLocation);
                        }
                    }
                }

                // get image via http
                using (var stream = VixServiceUtil.GetImage(imageRecord.FileName, securityToken, transactionUid))
                {
                    int startTickCount = Environment.TickCount;
                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Uploading image to Hix.", "WorkerId", _WorkerId, "ImageUid", imageRecord.ImageUid, "FilePath", imageRecord.FileName);

                    var hixConnection = HixConnectionFactory.Create();
                    hixConnection.UploadImageFile(imageRecord.ImageUid, stream, "vixfile.org");

                    var elapsed = (Environment.TickCount - startTickCount);
                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Uploading image to Hix completed", "WorkerId", _WorkerId, "ImageUid", imageRecord.ImageUid, "FilePath", imageRecord.FileName, "Time", elapsed);
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Failed to get image.", "WorkerId", _WorkerId, "ImageUid", imageRecord.ImageUid, "FilePath", imageRecord.FileName, "Exception", ex.ToString());

                // mark image as failed
                var hixConnection = HixConnectionFactory.Create();
                hixConnection.SetImageRecordError(imageRecord.ImageUid, ex.ToString());

                throw;
            }
        }
    }
}
