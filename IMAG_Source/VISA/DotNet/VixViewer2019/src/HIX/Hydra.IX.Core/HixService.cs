using Hydra.IX.Common;
using Hydra.IX.Configuration;
using Hydra.IX.Core.Remote;
using Hydra.IX.Database;
using Hydra.IX.Storage;
using Hydra.Log;
using System;
using System.IO;
using System.Reflection;

namespace Hydra.IX.Core
{
    public enum HixServiceMode
    {
        Controller,
        Worker
    }

    public class HixService : IHixService
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private static readonly ILogger _StartupLogger = LogManager.GetStartupLogger();

        private static readonly Lazy<HixService> _Instance = new Lazy<HixService>(() => new HixService());

        private object _SyncLock = new object();

        private volatile bool _isStarted = false;
        public HixServiceMode ServiceMode { get; set; }
        private string _ProcessGuid = null;

        private IPurgeScheduler _PurgeScheduler = null;
        private IHixWorker _HixWorker = null;
        //        private IPurgeHandler _PurgeHandler = null;

        public static HixService Instance
        {
            get
            {
                return HixService._Instance.Value;
            }
        }

        public IPurgeScheduler PurgeScheduler
        {
            get
            {
                return _PurgeScheduler;
            }
        }

        public void Start(string configFilePath = null, HixServiceMode serviceMode = HixServiceMode.Controller)
        {
            lock (_SyncLock)
            {
                if (!_isStarted)
                {
                    try
                    {
                        _StartupLogger.Info("Starting Service");

                        ServiceMode = serviceMode;

                        if (ServiceMode == HixServiceMode.Worker)
                        {
                            configFilePath = Environment.GetEnvironmentVariable("ConfigFilePath");
                            _ProcessGuid = Environment.GetEnvironmentVariable("ProcessGuid");
                            //Debugger.Break();
                        }

                        InitializeConfiguration(configFilePath);

                        InitializeDatabase();

                        InitializeStorage();

                        InitializeImageProcessor();

                        if (ServiceMode == HixServiceMode.Controller)
                        {
                            // initialize workflow manager
                            ImageWorkflow.ImageManager = new ImageManager();
                            ImageWorkflow.CacheStudyMetadata = HixConfigurationSection.Instance.Processor.CacheStudyMetadata;  //needs locking code if set to true
                            ImageWorkflow.StartQueuedImageManager(HixConfigurationSection.Instance.Processor.UseSeparateProcess,
                                                                  HixConfigurationSection.Instance.Processor.WorkerPoolSize,
                                                                  HixConfigurationSection.Instance.Processor.ReprocessFailedImages);

                            
                            // start purge scheduler
                            _PurgeScheduler = new PurgeScheduler(new PurgeHandler());
                            _PurgeScheduler.Start();

                            _isStarted = true;
                        }
                        else
                        {
                            // create remote worker service
                            _HixWorker = new HixWorker();
                            _HixWorker.Start(_ProcessGuid);
                        }
                    }
                    catch (Exception ex)
                    {
                        _Logger.Error("Error starting service", "Exception", ex.Message);

                        if (ServiceMode == HixServiceMode.Controller)
                        {
                            if (_PurgeScheduler != null)
                                _PurgeScheduler.Stop();

                            ImageWorkflow.StopQueuedImageManager();

                            throw;
                        }
                    }
                }
            }
        }

        //void _PurgeScheduler_StartPurgeEvent()
        //{
        //    // use values from the configuration
        //    var purgeRequest = new PurgeRequest()
        //    {
        //        MaxCacheSizeMB = HixConfigurationSection.Instance.Purge.MaxCacheSizeMB,
        //        MaxAgeDays = HixConfigurationSection.Instance.Purge.MaxAgeDays,
        //        ImageGroupPurgeBlockSize = HixConfigurationSection.Instance.Purge.ImageGroupPurgeBlockSize,
        //        ImagePurgeBlockSize = HixConfigurationSection.Instance.Purge.ImagePurgeBlockSize,
        //        EnableCacheCleanup = HixConfigurationSection.Instance.Purge.EnableCacheCleanup
        //    };

        //    _PurgeHandler.Start(purgeRequest);

        //    //ImageWorkflow.PerformCachePurge();
        //}

        public void WaitForExit()
        {
            if (ServiceMode == HixServiceMode.Worker)
            {
                if (_HixWorker != null)
                    _HixWorker.WaitForExit();
            }
        }

        private void InitializeStorage()
        {
            StorageManager.Instance.Initialize(new HixDbContextFactory());

            Hydra.Dicom.ImageProcessor.TempFolder = StorageManager.Instance.TempImageStore.Path;
        }

    private void InitializeImageProcessor()
        {
            Hydra.Dicom.ImageProcessor.XslFolder = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "Xsl");
            _Logger.Info("ImageProcessor setting.", "XslFolder", Hydra.Dicom.ImageProcessor.XslFolder);

            Hydra.Dicom.ImageProcessor.Is3DEnabled = HixConfigurationSection.Instance.Processor.Enable3D;
            _Logger.Info("ImageProcessor setting.", "Enable3D", Hydra.Dicom.ImageProcessor.Is3DEnabled);

            Hydra.IX.Core.Remote.HixWorkerPool.OpTimeOutMins = HixConfigurationSection.Instance.Processor.OpTimeOutMins;
            _Logger.Info("HixWorkerPool setting.", "OpTimeOutMins", Hydra.IX.Core.Remote.HixWorkerPool.OpTimeOutMins);
        }

        public void Stop()
        {
            lock (_SyncLock)
            {
                if (_isStarted)
                {
                    if (ServiceMode == HixServiceMode.Controller)
                    {
                        if (_PurgeScheduler != null)
                            _PurgeScheduler.Stop();

                        ImageWorkflow.StopQueuedImageManager();
                    }

                    StorageManager.Instance.Uninitialize();

                    _isStarted = false;
                }
            }
        }

        private void InitializeConfiguration(string configFilePath)
        {
            if (string.IsNullOrEmpty(configFilePath))
                configFilePath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "Hix.config");
            if (!File.Exists(configFilePath))
                throw new ArgumentException("Config file does not exist");

            HixConfigurationSection.Instance = HixConfigurationFile.GetHixSection<HixConfigurationSection>(configFilePath, "Hix");
            if (HixConfigurationSection.Instance == null)
                throw new ArgumentException("Config file does not contain a valid Hix section");

            if ((ServiceMode == HixServiceMode.Controller) && HixConfigurationSection.Instance.Encrypt)
                HixConfigurationFile.Encrypt(configFilePath);

            HixConfigurationSection.Instance.ConfigFilePath = configFilePath;
        }

        private void InitializeDatabase()
        {
            HixDbContextFactory.SetDbContextInitializer();
            HixDbContextFactory.ConnectionString = HixConfigurationSection.Instance.Database.DbConnectionString;
            HixDbContextFactory.CommandTimeout = HixConfigurationSection.Instance.Database.CommandTimeout;
        }
    }
}
