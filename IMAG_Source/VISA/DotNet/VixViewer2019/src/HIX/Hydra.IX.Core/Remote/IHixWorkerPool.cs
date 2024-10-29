using System;
namespace Hydra.IX.Core.Remote
{
    public interface IHixWorkerPool
    {
        HixWorkerProcess InitializeWorker(int jobId);
        void ProcessImage(string imageUid, int jobId);
        void StopWorkers();
    }
}
