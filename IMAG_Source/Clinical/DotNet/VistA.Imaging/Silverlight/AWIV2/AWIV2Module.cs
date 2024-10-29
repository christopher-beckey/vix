namespace VistA.Imaging.AWIV2
{
    using System;
    using System.Net;
    using System.Windows;
    using System.Windows.Controls;
    using System.Windows.Documents;
    using System.Windows.Ink;
    using System.Windows.Input;
    using System.Windows.Media;
    using System.Windows.Media.Animation;
    using System.Windows.Shapes;
    using VistA.Imaging.Prism.Modularity;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;
    using VistA.Imaging.AWIV2.ViewModels;
    using VistA.Imaging.AWIV2.Views;

    public class AWIV2Module : UnityModule
    {
        public AWIV2Module(IUnityContainer container, IRegionManager regionManager)
            : base(container, regionManager)
        {
            this.Name = "AWIV2";
        }

        public override void Initialize()
        {
            base.Initialize();

            // ViewModels
            this.Container.RegisterType<MainViewModel, MainViewModel>(new ContainerControlledLifetimeManager());
            this.Container.RegisterType<ItemNavigationViewModel, ItemNavigationViewModel>(new ContainerControlledLifetimeManager());
            this.Container.RegisterType<SelectedItemsViewModel, SelectedItemsViewModel>(new ContainerControlledLifetimeManager());

            // Views
            this.Container.RegisterType<object, MainView>("MainView", new ContainerControlledLifetimeManager());
            this.Container.RegisterType<object, ItemNavigationView>("ItemNavigationView", new ContainerControlledLifetimeManager());
            this.Container.RegisterType<object, SelectedItemsView>("SelectedItemsView", new ContainerControlledLifetimeManager());
        }
    }
}
