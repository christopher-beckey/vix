using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Core.Remote
{
    [ServiceContract]
    public interface IHixWorker
    {
        [OperationContract]
        void Connect();
        [OperationContract]
        void ProcessImage(string imageUid);
        [OperationContract]
        void Shutdown();
        void Start(string processGuid);
        void WaitForExit();
    }
}
