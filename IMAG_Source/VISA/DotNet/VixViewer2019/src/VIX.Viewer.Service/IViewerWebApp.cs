using System;
namespace VIX.Viewer.Service
{
    public interface IViewerWebApp
    {
        void StartAsConsoleApp();
        void StartAsService();
        void Stop();
        bool IsRunning { get; }
    }
}
