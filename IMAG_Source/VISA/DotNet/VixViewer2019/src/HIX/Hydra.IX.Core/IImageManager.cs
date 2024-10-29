using System;
namespace Hydra.IX.Core
{
    public interface IImageManager
    {
        void ProcessImage(ImageManager.JobData jobData, int jobId, System.Threading.CancellationToken token);
        void ProcessImage(string imageUid, System.Threading.CancellationToken token);
        void QueueImage(string imageUid);
        void QueuePendingImages();
        void Start(bool useWorkerPool, int workerPoolSize);
        void Stop();
    }
}
