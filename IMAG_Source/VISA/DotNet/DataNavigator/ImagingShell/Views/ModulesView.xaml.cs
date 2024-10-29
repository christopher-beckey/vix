using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using ImagingShell.ViewModels;
using ImagingClient.Infrastructure.Views;
using ImagingClient.Infrastructure.Prism;
using ImagingClient.Infrastructure.Prism.Modularity;
using ImagingClient.Infrastructure.Prism.Mvvm;

namespace ImagingShell.Views
{
    /// <summary>
    /// Interaction logic for ModulesView.xaml
    /// </summary>
    public partial class ModulesView : View<ModulesViewModel>
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ModulesView"/> class.
        /// </summary>
        /// <param name="viewModel">The view model.</param>
        public ModulesView(ModulesViewModel viewModel)
            : base(viewModel)
        {
            InitializeComponent();
        }
    }
}
