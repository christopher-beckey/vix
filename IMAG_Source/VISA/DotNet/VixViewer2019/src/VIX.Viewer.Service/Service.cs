using Hydra.VistA;
using Microsoft.Owin.Hosting;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace VIX.Viewer.Service
{
    public partial class Service : ServiceBase
    {
        private IViewerWebApp _ViewerWebApp = null;
        private ServiceMonitor _ServiceMonitor = null;

        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private static readonly ILogger _StartupLogger = LogManager.GetStartupLogger();

        static Service()
        {
            try
            {
                VistAConfigurationSection.Initialize(Globals.ConfigFilePath); //VAI-780
                Hydra.IX.Client.EventLogger.IsEnabled = true;
            }
            catch (Exception ex)
            {
                _StartupLogger.Error("Error reading config file.", "Exception", ex.ToString());
                throw;
            }
        }

        public Service()
        {
            InitializeComponent();
            _ViewerWebApp = new ViewerWebApp();
            _ServiceMonitor = new ServiceMonitor(_ViewerWebApp);
        }

        protected override void OnStart(string[] args)
        {
            _ViewerWebApp.StartAsService();
            _ServiceMonitor.Start();
            _StartupLogger.Info("VIX Viewer Service started");
        }

        protected override void OnStop()
        {
            _ViewerWebApp.Stop();
            _ServiceMonitor.Stop();
            _StartupLogger.Info("VIX Viewer Service stopped");
        }

        internal static void RunConsole()
        {
            var viewerWebApp = new ViewerWebApp();
            var serviceMonitor = new ServiceMonitor(viewerWebApp);
            serviceMonitor.Start();
            viewerWebApp.StartAsConsoleApp();
            serviceMonitor.Stop();
        }
    }
}
