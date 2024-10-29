using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.ServiceModel;
using System.ServiceModel.Description;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Core.Remote
{
    public class HixWorkerProxy : ClientBase<IHixWorker>
    {
        public HixWorkerProxy(string serviceUid) : base(new ServiceEndpoint(ContractDescription.GetContract(typeof(IHixWorker)),
                new NetNamedPipeBinding(), new EndpointAddress(HixWorkerUri.FormatUri(serviceUid))))
        {
        }

        public void InvokeProcessImage(string imageUid)
        {
            Channel.ProcessImage(imageUid);
        }

        public void InvokeConnect()
        {
            Channel.Connect();
        }

        public void InvokeShutdown()
        {
            Channel.Shutdown();
        }
    }
}
