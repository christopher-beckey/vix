using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    [ServiceContract]
    public interface IVistAWorker
    {
        [OperationContract]
        void Connect();

        [OperationContract]
        void ProcessDisplayContext(VistAWorkerData data);

        [OperationContract]
        void Shutdown();
    }
}
