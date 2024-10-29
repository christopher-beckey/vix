using System.Windows;
using VixHealthMonitor.ViewModel;
using System.Timers;
using VixHealthMonitorCommon;

namespace VixHealthMonitor
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        private MainViewModel mainViewModel = null;
        private Timer balloonTipTimer = null;

        public MainWindow()
        {
            InitializeComponent();
            Closing += (s, e) => ViewModelLocator.Cleanup();
            mainViewModel = (MainViewModel)DataContext;
            mainViewModel.WarningMessage += ReceiveViewModel_WarningMessage;
            mainViewModel.OnShowSettingsDialogEvent += ShowSettingsDialog;
            balloonTipTimer = new Timer(1000 * 5); // 5 seconds
            balloonTipTimer.Enabled = false;
            balloonTipTimer.Elapsed += BalloonTipTimerEllapsed;

            /*
            VixListViewModel failedViewModel = new VixListViewModel();
            failedViewModel.SetShowErrorsOnly();
            failedVixList.DataContext = failedViewModel;
            */

            vixList.DataContext = new VixListViewModel();

            VixListViewModel watchedViewModel = new VixListViewModel();
            watchedViewModel.SetShowWatchSites();
            watchedVixList.DataContext = watchedViewModel;

            VixListViewModel testSitesViewModel = new VixListViewModel();
            testSitesViewModel.SetShowTestSitesOnly();
            testSitesList.DataContext = testSitesViewModel;

            /*
            VixListViewModel failedViewModel = (VixListViewModel)failedVixList.DataContext;
            failedViewModel.SetShowErrorsOnly();
             * */
        }

        private void BalloonTipTimerEllapsed(object sender, ElapsedEventArgs e)
        {
            balloonTipTimer.Enabled = false;
            tbIcon.HideBalloonTip();
        }

        private bool? ShowSettingsDialog()
        {
            ConfigurationWindow cw = new ConfigurationWindow();
            bool? result = cw.ShowDialog();
            return result;
        }

        private void ShowBalloonTip(string title, string message, Hardcodet.Wpf.TaskbarNotification.BalloonIcon icon)
        {
            tbIcon.ShowBalloonTip(title, message, icon);
            balloonTipTimer.Enabled = true;
        }

        private void ReceiveViewModel_WarningMessage(object sender, WarningMessage warningMessage)
        {
            if (VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().AlertFailedSites)
            {
                ShowBalloonTip("Error", warningMessage.Message,
                    Hardcodet.Wpf.TaskbarNotification.BalloonIcon.Error);
            }
        }

        private void Window_StateChanged(object sender, System.EventArgs e)
        {
            if (WindowState == System.Windows.WindowState.Minimized)
            {
                if(VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().HideWhenMinimized)
                {
                    this.Hide();
                }
            }
        }

        private void TaskbarIcon_TrayMouseDoubleClick(object sender, RoutedEventArgs e)
        {
            if (WindowState == System.Windows.WindowState.Minimized)
            {
                this.Show();
                this.WindowState = System.Windows.WindowState.Normal;
            }
        }

        private void MenuItem_Click(object sender, RoutedEventArgs e)
        {
            System.Reflection.Assembly assembly = System.Reflection.Assembly.GetExecutingAssembly();

            System.Version version = assembly.GetName().Version;
            MessageBox.Show("VIX Health Monitor version " + version.ToString(), 
                "About", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}
