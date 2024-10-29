using Hydra.IX.Common;
using System;
namespace Hydra.IX.Core
{
    public interface IPurgeHandler
    {
        void Start(PurgeRequest request);
        void Stop();
        object GetCacheStatus();
    }
}
