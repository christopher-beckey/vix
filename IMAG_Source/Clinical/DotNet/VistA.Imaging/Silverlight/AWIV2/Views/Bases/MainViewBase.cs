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
using VistA.Imaging.AWIV2.ViewModels;
using VistA.Imaging.Prism;
using Microsoft.Practices.Unity;

namespace VistA.Imaging.AWIV2.Views.Bases
{
    public class MainViewBase : UserControlView<MainViewModel>
    {
        public MainViewBase() { }
        [InjectionConstructor]
        public MainViewBase(MainViewModel viewModel) : base(viewModel) { }
    }
}
