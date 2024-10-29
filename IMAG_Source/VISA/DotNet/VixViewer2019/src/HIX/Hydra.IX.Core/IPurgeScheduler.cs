using Hydra.IX.Common;
using System;
namespace Hydra.IX.Core
{
    public interface IPurgeScheduler
    {
        void Start();
        void Stop();
        void Execute(PurgeRequest purgeRequest);
        object GetCacheStatus();
    }
}
