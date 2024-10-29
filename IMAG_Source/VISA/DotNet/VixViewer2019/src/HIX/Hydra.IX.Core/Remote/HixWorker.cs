using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Hydra.IX.Core.Remote
{
    public class HixWorker : IHixWorker
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private ServiceHost _ServiceHost = null;
        private static ManualResetEvent _ShutDownEvent = new ManualResetEvent(false);
        private IImageManager _ImageManager = null;

        public HixWorker()
        {
            _ImageManager = new ImageManager();
        }

        public void Connect()
        {
        }

        public void Shutdown()
        {
            _ShutDownEvent.Set();
        }

        public void WaitForExit()
        {
            _ShutDownEvent.WaitOne();
        }

        public void ProcessImage(string imageUid)
        {
            _ImageManager.ProcessImage(imageUid, CancellationToken.None);
        }

        public void Start(string processGuid)
        {
            if (_ServiceHost != null)
                return;

            string baseAddress = HixWorkerUri.FormatUri(processGuid);
            _Logger.Info("Starting worker service host.", "BaseAddress", baseAddress);
            _ServiceHost = new ServiceHost(typeof(HixWorker), new Uri[] { new Uri(baseAddress) });
            _ServiceHost.AddServiceEndpoint(typeof(IHixWorker), new NetNamedPipeBinding(), "");
            _ServiceHost.Open();
            _Logger.Info("Worker service host started");
        }

        //public void Stop()
        //{
        //    if (_ServiceHost != null)
        //    {
        //        _ServiceHost.Close();
        //        _ServiceHost = null;
        //    }
        //}
    }
}
