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
using VixHealthMonitorCommon;
using VISACommon;
using VISAHealthMonitorCommonControls;
using VISAHealthMonitorCommon.jmx;
using VISAHealthMonitorCommon;

namespace VixHealthMonitor
{
    /// <summary>
    /// Interaction logic for LongRunningThreadsView.xaml
    /// </summary>
    public partial class LongRunningThreadsView : UserControl
    {
        private LongRunningThreadsViewModel longRunningThreadsViewModel;

        public LongRunningThreadsView()
        {
            InitializeComponent();
            longRunningThreadsViewModel = (LongRunningThreadsViewModel)this.DataContext;
            longRunningThreadsViewModel.OnShowThreadDetailsDialog += ShowThreadDetailsDialog;
        }

        private void ShowThreadDetailsDialog(VisaSource visaSource, VisaHealth visaHealth,
            ThreadProcessingTime threadProcessingTime)
        {
            if (JmxUtility.IsJmxSupported(visaHealth))
            {
                ThreadDetails threadDetails = new ThreadDetails(visaSource, threadProcessingTime.ThreadName);
                threadDetails.Show();
            }
            else
            {
                MessageBox.Show("Version '" + visaHealth.VisaVersion + "' does not support thread details",
                    "Version not supported", MessageBoxButton.OK, MessageBoxImage.Stop);
            }
        }
    }
}
