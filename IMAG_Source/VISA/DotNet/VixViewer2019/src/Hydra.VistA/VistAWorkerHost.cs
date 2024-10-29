using Hydra.Log;
using System;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Threading;

namespace Hydra.VistA
{
    public class VistAWorkerHost
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private ServiceHost _ServiceHost = null;

        private static ManualResetEvent _ShutDownEvent = new ManualResetEvent(false);

        public void WaitForExit()
        {
            _ShutDownEvent.WaitOne();
        }

        public static void EnableShutdown()
        {
            _ShutDownEvent.Set();
        }

        public void Start(string processGuid, string uri)
        {
            if (_ServiceHost != null)
                return;

            try
            {
                _Logger.Info("VistA Worker - Starting service host", "ProcessGuid", processGuid, "Url", uri);

                _ServiceHost = new ServiceHost(typeof(VistAWorker), new Uri[] { new Uri(uri) });

                Binding binding = (uri.Contains("net.tcp"))? 
                    (Binding) new NetTcpBinding(SecurityMode.None) :
                    (Binding) new NetNamedPipeBinding();

                _ServiceHost.AddServiceEndpoint(typeof(IVistAWorker), binding, "");
                _ServiceHost.Open();

                _Logger.Info("VistA Worker - Service host started");
            }
            catch (Exception ex)
            {
                if (_ServiceHost != null)
                    _ServiceHost.Abort();

                _Logger.Error(ex.ToString());
                throw;
            }
        }

        public void Stop()
        {
            if (_ServiceHost != null)
            {
                _ServiceHost.Close();
                _ServiceHost = null;
            }
        }
    }
}
