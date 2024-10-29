using Hydra.IX.Configuration;
using Hydra.IX.Database;
using Hydra.Log;
using System;
using System.Collections.Concurrent;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Hydra.IX.Core.Remote
{
    public class HixWorkerProcess
    {
        public string ProcessGuid { get; set; }
        public Process Process { get; set; }
    }

    public class HixWorkerPool : Hydra.IX.Core.Remote.IHixWorkerPool
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private object _SyncLock = new object();
        private ConcurrentDictionary<int, HixWorkerProcess> _WorkerList = new ConcurrentDictionary<int, HixWorkerProcess>();
        private int _CurrentWorkerProcessCount = 0;
        public static int OpTimeOutMins { get; set; }

        internal int CurrentWorkerProcessCount
        {
            get
            {
                return _CurrentWorkerProcessCount;
            }
        }

        public void ProcessImage(string imageUid, int jobId)
        {
            var proxy = GetHixWorkerProxy(jobId);

            proxy.InnerChannel.OperationTimeout = new TimeSpan(0, OpTimeOutMins, 0);
            _Logger.Debug("The OpTimeOutMins setting.", "OpTimeOutMins", OpTimeOutMins.ToString());

            try
            {
                proxy.InvokeProcessImage(imageUid);
            }
            catch (Exception ex)
            {
                _Logger.Error("Severe error processing image. Worker process crashed.", "ImageUid", imageUid, "Exception", ex.ToString());

                // set image as failed
                SetImageAsFailed(imageUid, ex.Message);

                // create new process if current process terminated
                HixWorkerProcess workerProcess = null;
                if (_WorkerList.TryGetValue(jobId, out workerProcess))
                {
                    if (workerProcess != null && workerProcess.Process.HasExited)
                    {
                        InitializeWorker(jobId);
                    }
                }
            }
        }

        internal void SetImageAsFailed(string imageUid, string message)
        {
            using (var ctx = new HixDbContextFactory().Create())
            {
                // get image
                Hydra.IX.Database.Common.ImageFile imageFile = ctx.Images.Where(x => (x.ImageUid == imageUid)).FirstOrDefault();
                if (imageFile != null)
                {
                    imageFile.IsSucceeded = false;
                    imageFile.Status = message;
                    imageFile.IsProcessed = true;
                    ctx.Entry(imageFile).State = System.Data.Entity.EntityState.Modified;
                    ctx.SaveChanges();
                }
            }
        }

        internal HixWorkerProxy GetHixWorkerProxy(int jobId)
        {
            HixWorkerProcess workerProcess = null;
            if (!_WorkerList.TryGetValue(jobId, out workerProcess))
            {
                if (workerProcess == null)
                    return null;

                workerProcess = InitializeWorker(jobId);
            }

            if (workerProcess == null)
                return null;

            return new HixWorkerProxy(workerProcess.ProcessGuid);
        }

        public HixWorkerProcess InitializeWorker(int jobId)
        {
            HixWorkerProcess workerProcess = null;
            string processGuid = Guid.NewGuid().ToString();
            string workerProcessPath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "Hydra.IX.Processor.exe");

            var startInfo = new ProcessStartInfo();
            startInfo.FileName = workerProcessPath;
            startInfo.CreateNoWindow = true;
            startInfo.UseShellExecute = false;
            startInfo.EnvironmentVariables["ConfigFilePath"] = HixConfigurationSection.Instance.ConfigFilePath;
            startInfo.EnvironmentVariables["ProcessGuid"] = processGuid;
            startInfo.EnvironmentVariables["ProcessorLogRoot"] = LogManager.Configuration.LogFolder;
            startInfo.EnvironmentVariables["ProcessorLogLevel"] = LogManager.Configuration.LogLevel;

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Starting worker process.", "ProcessGuid", processGuid);
            var process = Process.Start(startInfo);

            bool connected = false;
            string errorDesc = null;
            Stopwatch s = new Stopwatch();
            s.Start();

            if (_Logger.IsDebugEnabled)
                _Logger.Info("Connecting to worker process.", "ProcessGuid", processGuid);
            while (s.Elapsed < TimeSpan.FromSeconds(10000))
            {
                try
                {
                    var proxy = new HixWorkerProxy(processGuid);
                    proxy.InvokeConnect();
                    proxy.Close();

                    connected = true;
                    s.Stop();

                    Interlocked.Increment(ref _CurrentWorkerProcessCount);

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Connected to worker process.", "ProcessGuid", processGuid);

                    break;
                }
                catch (Exception ex)
                {
                    errorDesc = ex.ToString();
                }
            }

            if (connected)
            {
                workerProcess = new HixWorkerProcess
                {
                    ProcessGuid = processGuid,
                    Process = process
                };

                _WorkerList[jobId] = workerProcess;
            }
            else
            {
                _Logger.Error("Failed to connect to worker process.", "ProcessGuid", processGuid, "Exception", errorDesc);
                // todo: terminate worker process
            }

            s.Stop();

            return workerProcess;
        }

        public void StopWorkers()
        {
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Stopping worker processes.");

            foreach (var item in _WorkerList)
            {
                try
                {
                    var proxy = new HixWorkerProxy(item.Value.ProcessGuid);
                    proxy.InvokeShutdown();
                    proxy.Close();
                }
                catch (Exception ex)
                {
                    _Logger.Error("Error stopping worker process.", "Error", ex.ToString());
                }
            }

            _WorkerList.Clear();
        }
    }
}
