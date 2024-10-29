namespace VistA.Imaging.AWIV2.ViewModels
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
    using VistA.Imaging.Prism;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;
    using System.Windows.Controls.Data;

    public class MainViewModel : ViewModel
    {
        public MainViewModel()
        {

        }

        [InjectionConstructor]
        public MainViewModel(
            IRegionManager regionManager,
            ItemNavigationViewModel itemNavigationViewModel,
            SelectedItemsViewModel selectedItemsViewModel)
            : base(regionManager)
        {
            this.ItemNavigationViewModel = itemNavigationViewModel;
            this.SelectedItemsViewModel = selectedItemsViewModel;
        }

        #region Properties

        public ItemNavigationViewModel ItemNavigationViewModel { get; set; }
        public SelectedItemsViewModel SelectedItemsViewModel { get; set; }

        #endregion
    }
}
