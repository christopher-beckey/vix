
namespace ImagingClient.Infrastructure.Prism.Mvvm
{
    using System;
    using System.Windows.Threading;
    using System.ComponentModel;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Prism;

    interface IViewModel : INotifyPropertyChanged, IConfirmNavigationRequest, IActiveAware
    {
        void Initialze();
        Dispatcher UIDispatcher { get; set; }
    }
}
