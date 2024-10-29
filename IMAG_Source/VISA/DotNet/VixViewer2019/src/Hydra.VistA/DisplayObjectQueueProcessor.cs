using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class DisplayObjectQueueProcessor
    {
        class DisplayContextJob
        {
            public string ContextId { get; set; }
            public string SecurityToken { get; set; }
            public string TransactionUid { get; set; }
            public IEnumerable<Hydra.IX.Common.ImageRecord> ImageRecords { get; set; }
        }

        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private Hydra.IX.Common.BackgroundWorker<DisplayContextJob> _JobQueue = null;

        private object _SyncLock = new object();
        private volatile bool _isInitialized = false;

        private void ProcessJob(DisplayContextJob jobData, int jobId, CancellationToken token)
        {
            VistAWorkerPool.Instance.ProcessDisplayContext(jobData.ContextId, jobData.ImageRecords, jobData.SecurityToken, jobData.TransactionUid, jobId);
        }

        private void InitializeWorker(int jobId)
        {
            VistAWorkerPool.Instance.InitializeWorker(jobId);
        }

        public void QueueDisplayContext(string contextId, IEnumerable<Hydra.IX.Common.ImageRecord> imageRecords, string securityToken, string transactionUid)
        {
            _JobQueue.QueueJob(new DisplayContextJob
            {
                ContextId = contextId,
                SecurityToken = securityToken,
                TransactionUid = transactionUid,
                ImageRecords = imageRecords
            });
        }

        public void Start()
        {
            lock (_SyncLock)
            {
                if (!_isInitialized)
                {
                    try
                    {
                        // start background worker
                        _JobQueue = new Hydra.IX.Common.BackgroundWorker<DisplayContextJob>(VistAConfigurationSection.Instance.WorkerPoolSize,
                                                                                 (job, workerId, workerIndex, token) => ProcessJob(job, workerId, token),
                                                                                 (workerId) => InitializeWorker(workerId));
                        _JobQueue.Start(true); //wait until all workers are running.

                        _isInitialized = true;
                    }
                    catch (Exception ex)
                    {
                        throw;
                    }
                }
            }
        }

        public void Stop()
        {
            lock (_SyncLock)
            {
                if (_isInitialized)
                {
                    if (_JobQueue != null)
                    {
                        _JobQueue.Stop();
                        _JobQueue = null;
                    }

                    VistAWorkerPool.Instance.Clear();

                    _isInitialized = false;
                }
            }
        }
    }
}
