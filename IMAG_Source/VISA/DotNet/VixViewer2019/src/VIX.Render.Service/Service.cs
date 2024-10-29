using Hydra.Log;
using Microsoft.Owin.Hosting;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace VIX.Render.Service
{
    public partial class Service : ServiceBase
    {
        private static IDisposable _Server = null;

        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

#if DEBUG
        static void DebugMode()
        {
            if (!Debugger.IsAttached)
                Debugger.Launch();
            Debugger.Break();
        }
#endif

        static Service()
        {
            RenderConfigurationSection.Initialize();
        }

        public Service()
        {
            InitializeComponent();

            Hydra.IX.Common.HixConfiguration.ApiRoutePrefix = "hix";
        }

        protected override void OnStart(string[] args)
        {
            var task = Task.Factory.StartNew(() =>
            {
                try
                {
#if DEBUG
                    DebugMode();
#endif

                    _Server = WebApp.Start<Startup>(RenderConfigurationSection.Instance.ServerUrl);
                    if (_Server != null)
                    {
                        _Logger.Info("VIX Render Service running", "Url", RenderConfigurationSection.Instance.ServerUrl);
                    }
                }
                catch (Exception ex)
                {
                    _Logger.Error("Error starting service", "Exception", ex.ToString());
                    throw;
                }
            });

            _Logger.Info("VIX Render Service started");
        }

        protected override void OnStop()
        {
            if (_Server != null)
            {
                _Server.Dispose();
                _Server = null;

                _Logger.Info("VIX Render Service stopped");
            }
        }

        internal static void RunConsole()
        {
            try
            {
#if DEBUG
                DebugMode();
#endif

                using (WebApp.Start<Startup>(RenderConfigurationSection.Instance.ServerUrl))
                {
                    Console.WriteLine("VIX Render Service running - {0}", RenderConfigurationSection.Instance.ServerUrl);
                    Console.WriteLine("Press any key to exit");
                    Console.ReadKey();
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error starting service", "Exception", ex.ToString());
                throw;
            }
        }
    }
}
