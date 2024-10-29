using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Worker
{
    class Program
    {
#if DEBUG
        static void DebugMode()
        {
            if (!Debugger.IsAttached)
                Debugger.Launch();
            Debugger.Break();
        }
#endif


        static void Main(string[] args)
        {
#if DEBUG
            DebugMode();
#endif

            string configFilePath = Environment.GetEnvironmentVariable("ConfigFilePath");
            VistAConfigurationSection.Initialize(configFilePath);

            string logDirectory = Environment.GetEnvironmentVariable("WorkerLogRoot");
            string logLevel = Environment.GetEnvironmentVariable("WorkerLogLevel");

            LogManager.Configuration = new LogConfiguration
            {
                LogFolder = logDirectory,
                LogFilePrefix = string.Format("Worker-{0}", Process.GetCurrentProcess().Id.ToString()),
                LogLevel = logLevel
            };

            //System.Windows.Forms.MessageBox.Show("Attach Now!");
            string processGuid = Environment.GetEnvironmentVariable("ProcessGuid");
            string uri = Environment.GetEnvironmentVariable("Uri");

            //var worker = new VistAWorker();
            //worker.ProcessDisplayContext(new VistAWorkerData { ContextId = "", SecurityToken = "" }); 

            ILogger _Logger = LogManager.GetCurrentClassLogger();
            _Logger.Info("VistA Worker - Starting Host Service", "ProcessGuid", processGuid, "Uri", uri);
            var host = new Hydra.VistA.VistAWorkerHost();
            host.Start(processGuid, uri);

            _Logger.Info("VistA Worker - Waiting for Host Service to stop", "ProcessGuid", processGuid);
            host.WaitForExit();
            host.Stop();
            _Logger.Info("VistA Worker - Host Service Stopped. Exiting.", "ProcessGuid", processGuid);
        }
    }
}
