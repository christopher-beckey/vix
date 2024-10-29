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
using VixHealthMonitor.ViewModel;

namespace VixHealthMonitor
{
    /// <summary>
    /// Interaction logic for VixTestInformationView.xaml
    /// </summary>
    public partial class VixTestInformationView : UserControl
    {
        public VixTestInformationView()
        {
            InitializeComponent();

            VixListViewModel failedViewModel = new VixListViewModel();
            failedViewModel.SetShowErrorsOnly();
            failedVixList.DataContext = failedViewModel;
        }
    }
}
