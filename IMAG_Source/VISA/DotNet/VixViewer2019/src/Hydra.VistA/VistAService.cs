using Hydra.Common.Exceptions;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;

namespace Hydra.VistA
{
    public class VistAService
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private static readonly Lazy<VistAService> _Instance = new Lazy<VistAService>(() => new VistAService());
        private DisplayObjectQueueProcessor _QueueProcessor = null;
        private object _SyncLock = new object();
        private volatile bool _isInitialized = false;

        public static VistAService Instance
        {
            get
            {
                return VistAService._Instance.Value;
            }
        }

        public void Initialize()
        {
            lock (_SyncLock)
            {
                if (!_isInitialized)
                {
                    try
                    {
                        _Logger.Info("VistAService - starting...");

                        _QueueProcessor = new DisplayObjectQueueProcessor();
                        _QueueProcessor.Start();

                        _Logger.Info("VistAService - started");

                        _isInitialized = true;
                    }
                    catch (Exception ex)
                    {
                        _Logger.Error("Error starting VistAService", "Exception", ex.ToString());
                        throw;
                    }
                }
            }
        }

        public void Uninitialize()
        {
            lock (_SyncLock)
            {
                if (_isInitialized)
                {
                    if (_QueueProcessor != null)
                    {
                        _QueueProcessor.Stop();
                        _QueueProcessor = null;
                    }

                    _isInitialized = false;
                }
            }
        }

        public void QueueDisplayContext(string contextId, IEnumerable<Hydra.IX.Common.ImageRecord> imageRecords, string securityToken, string transactionUid)
        {
            _QueueProcessor.QueueDisplayContext(contextId, imageRecords, securityToken, transactionUid);
        }
    }
}
