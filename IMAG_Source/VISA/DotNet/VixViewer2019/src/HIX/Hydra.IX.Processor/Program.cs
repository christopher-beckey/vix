using Hydra.IX.Core;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Processor
{
    class Program
    {
        static void Main(string[] args)
        {
            string logDirectory = Environment.GetEnvironmentVariable("ProcessorLogRoot");
            string logLevel = Environment.GetEnvironmentVariable("ProcessorLogLevel");

            LogManager.Configuration = new LogConfiguration
            {
                LogFolder = logDirectory,
                LogFilePrefix = string.Format("Processor-{0}", Process.GetCurrentProcess().Id.ToString()),
                LogLevel = logLevel
            };

            //Debugger.Break();
            //System.Windows.Forms.MessageBox.Show("Attach Now!");
            ILogger _Logger = LogManager.GetCurrentClassLogger();
            _Logger.Info("Worker Process started", "ProcessGuid", Environment.GetEnvironmentVariable("ProcessGuid"));

            _Logger.Info("Worker Process - Starting Hix Service");
            HixService.Instance.Start(null, HixServiceMode.Worker);

            _Logger.Info("Worker Process - Waiting for Hix Service to stop");
            HixService.Instance.WaitForExit();

            HixService.Instance.Stop();
        }
    }
}
