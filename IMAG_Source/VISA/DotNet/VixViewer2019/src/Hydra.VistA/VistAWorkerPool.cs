using Hydra.Log;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    internal class VistAWorkerProcess
    {
        public string ProcessGuid { get; set; }
        public int ProcessId { get; set; }
        public string Uri { get; set; }
    }

    public class VistAWorkerPool
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private static readonly Lazy<VistAWorkerPool> _Instance = new Lazy<VistAWorkerPool>(() => new VistAWorkerPool());

        private object _SyncLock = new object();

        private ConcurrentDictionary<int, VistAWorkerProcess> _WorkerList = new ConcurrentDictionary<int, VistAWorkerProcess>();

        public static VistAWorkerPool Instance
        {
            get
            {
                return VistAWorkerPool._Instance.Value;
            }
        }

        internal void ProcessDisplayContext(string contextId, IEnumerable<Hydra.IX.Common.ImageRecord> imageRecords, string securityToken, string transactionUid, int jobId)
        {
            var proxy = GetVistAWorkerProxy(jobId);

            proxy.InvokeProcessDisplayContext(contextId, imageRecords, securityToken, transactionUid);

            proxy.Close();
        }

        internal VistAWorkerProxy GetVistAWorkerProxy(int jobId)
        {
            VistAWorkerProcess workerProcess = null;
            if (!_WorkerList.TryGetValue(jobId, out workerProcess))
            {
                if (workerProcess == null)
                    return null;
                workerProcess = InitializeWorker(jobId);
            }
            if (workerProcess == null)
                return null;

            return new VistAWorkerProxy(workerProcess.Uri);
        }

        internal VistAWorkerProcess InitializeWorker(int jobId)
        {
            VistAWorkerProcess workerProcess = null;
            string processGuid = Guid.NewGuid().ToString();
            string uri = VistAWorkerUri.Format(processGuid);
            string workerProcessFolder = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            string workerProcessPath = Path.Combine(workerProcessFolder, "Hydra.VistA.Worker.exe");

            var startInfo = new ProcessStartInfo();
            startInfo.FileName = workerProcessPath;
            //startInfo.WorkingDirectory = workingFolder;
            startInfo.CreateNoWindow = true;
            startInfo.UseShellExecute = false;
            startInfo.EnvironmentVariables["ConfigFilePath"] = VistAConfigurationSection.Instance.ConfigFilePath;
            startInfo.EnvironmentVariables["ProcessGuid"] = processGuid;
            startInfo.EnvironmentVariables["WorkerLogRoot"] = LogManager.Configuration.LogFolder;
            startInfo.EnvironmentVariables["WorkerLogLevel"] = LogManager.Configuration.LogLevel;
            startInfo.EnvironmentVariables["Uri"] = uri;

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Starting worker process.", "ProcessGuid", processGuid);
            
            var process = Process.Start(startInfo);

            bool connected = false;
            string errorDesc = null;
            Stopwatch s = new Stopwatch();
            s.Start();

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Connecting to worker process.", "ProcessGuid", processGuid);
            
            while (s.Elapsed < TimeSpan.FromSeconds(10000))
            {
                try
                {
                    var proxy = new VistAWorkerProxy(uri);
                    proxy.InvokeConnect();

                    connected = true;
                    s.Stop();

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Connected to worker.", "ProcessGuid", processGuid);

                    break;
                }
                catch (Exception ex)
                {
                    errorDesc = ex.ToString();
                }
            }

            if (connected)
            {
                workerProcess = new VistAWorkerProcess
                {
                    ProcessGuid = processGuid,
                    ProcessId = process.Id,
                    Uri = uri
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

        internal void Clear()
        {
            _Logger.Info("Stopping worker processes");
            foreach (var item in _WorkerList)
            {
                try
                {
                    var proxy = new VistAWorkerProxy(item.Value.Uri);
                    proxy.InvokeShutdown();
                }
                catch (Exception ex)
                {
                    _Logger.Error("Error stopping worker process.", "Exception", ex.ToString());
                }
            }

            _WorkerList.Clear();
        }
    }
}
