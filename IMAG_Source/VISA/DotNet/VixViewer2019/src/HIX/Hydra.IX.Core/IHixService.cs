using System;
namespace Hydra.IX.Core
{
    interface IHixService
    {
        HixServiceMode ServiceMode { get; set; }
        void Start(string configFilePath = null, HixServiceMode serviceMode = HixServiceMode.Controller);
        void Stop();
        void WaitForExit();
        IPurgeScheduler PurgeScheduler { get; }

    }
}
