using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.ServiceModel;
using System.ServiceModel.Description;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class VistAWorkerProxy : ClientBase<IVistAWorker>
    {
        public VistAWorkerProxy(string uri) : base(CreateEndPoint(uri))
        {
        }

        private static ServiceEndpoint CreateEndPoint(string uri)
        {
            if (VistAConfigurationSection.Instance.WorkerBaseAddress.Contains("net.tcp"))
            {
                return new ServiceEndpoint(ContractDescription.GetContract(typeof(IVistAWorker)),
                    new NetTcpBinding(SecurityMode.None), new EndpointAddress(uri));
            }
            else
            {
                return new ServiceEndpoint(ContractDescription.GetContract(typeof(IVistAWorker)),
                    new NetNamedPipeBinding(), new EndpointAddress(uri));
            }
        }

        public void InvokeProcessDisplayContext(string contextId, IEnumerable<Hydra.IX.Common.ImageRecord> imageRecords, string securityToken, string transactionUid)
        {
            Channel.ProcessDisplayContext(new VistAWorkerData
                {
                    ContextId = contextId,
                    SecurityToken = securityToken,
                    TransactionUid = transactionUid,
                    ImageRecords = imageRecords
                });
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
