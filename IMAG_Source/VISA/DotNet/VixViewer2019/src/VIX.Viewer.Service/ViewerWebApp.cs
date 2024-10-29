using Hydra.Log;
using Hydra.VistA;
using Microsoft.Owin.Hosting;
using System;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;

namespace VIX.Viewer.Service
{
    public class ViewerWebApp : IViewerWebApp
    {
        private static IDisposable _Server = null;
        private static IDisposable _SecureServer = null;
        private ManualResetEvent _ShutDownEvent = new ManualResetEvent(false);
        private ManualResetEvent _StoppedEvent = null;

        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private static readonly ILogger _StartupLogger = LogManager.GetStartupLogger();

#if DEBUG
        static void DebugMode()
        {
            if (!Debugger.IsAttached)
                Debugger.Launch();
            Debugger.Break();
        }
#endif

        public bool IsRunning { get; private set; }
        public int ExitCode { get; set; }

        public void StartAsService()
        {
            var task = Task.Factory.StartNew(() =>
            {
                try
                {
#if DEBUG
                    DebugMode();
#endif

                    string[] serverUrls = GetServerUrls();
                    if (string.IsNullOrEmpty(serverUrls[0]))
                        throw new Exception("Server Url not configured");

                    _Server = WebApp.Start<Startup>(serverUrls[0]);

                    if (!string.IsNullOrEmpty(serverUrls[1]))
                        _SecureServer = WebApp.Start<TrustedClientStartup>(serverUrls[1]);

                    _StartupLogger.Info("VIX Viewer Web App running", "Url", serverUrls[0], "TrustedClientUrl", serverUrls[1]);

                    IsRunning = true;
                }
                catch (Exception ex)
                {
                    _StartupLogger.Error("Error starting web app", "Exception", ex.ToString());
                    throw;
                }
            });
        }

        public void StartAsConsoleApp()
        {
            try
            {
#if DEBUG
                DebugMode();
#endif

                string[] serverUrls = GetServerUrls();
                if (string.IsNullOrEmpty(serverUrls[0]))
                    throw new Exception("Server Url not configured");

                using (WebApp.Start<Startup>(serverUrls[0]))
                {
                    Console.WriteLine("VIX Viewer Web App running - {0}", serverUrls[0]);

                    _StoppedEvent = new ManualResetEvent(false);
                    IsRunning = true;

                    if (!string.IsNullOrEmpty(serverUrls[1]))
                    {
                        using (WebApp.Start<TrustedClientStartup>(serverUrls[1]))
                        {
                            Console.WriteLine("Trusted client url - {0}", serverUrls[1]);
                            WaitForExit();
                        }
                    }
                    else
                    {
                        WaitForExit();
                    }
                }

                IsRunning = false;

                if (_StoppedEvent != null)
                    _StoppedEvent.Set();
            }
            catch (Exception ex)
            {
                _StartupLogger.Error("Error starting service", "Exception", ex.ToString());
                throw;
            }
        }

        public void Stop()
        {
            if (_Server != null)
            {
                _Server.Dispose();
                _Server = null;
            }

            if (_SecureServer != null)
            {
                _SecureServer.Dispose();
                _SecureServer = null;
            }

            // notify shutdown
            _ShutDownEvent.Set();

            // wait for service to stop (if enabled)
            if (_StoppedEvent != null)
                _StoppedEvent.WaitOne();

            IsRunning = false;

            _StartupLogger.Info("VIX Viewer web app stopped");
        }

        private static string[] GetServerUrls()
        {
            string[] urls = new string[2];

            if (VistAConfigurationSection.Instance.VixServices != null)
            {
                for (int i = 0; i < VistAConfigurationSection.Instance.VixServices.Count; i++)
                {
                    var vixService = VistAConfigurationSection.Instance.VixServices[i];
                    if (vixService.ServiceType == VixServiceType.Viewer)
                    {
                        urls[0] = vixService.RootUrl;
                        urls[1] = vixService.TrustedClientRootUrl;
                        break;
                    }
                }
            }

            return urls;
        }

        private void WaitForExit()
        {
            var tasks = new Task[2];

            tasks[0] = Task.Factory.StartNew(() =>
            {
                Console.WriteLine("Press any key to exit");
                Console.ReadKey();
            });

            tasks[1] = Task.Factory.StartNew(() =>
            {
                _ShutDownEvent.WaitOne();
            });

            Task.WaitAny(tasks);
        }
    }
}
