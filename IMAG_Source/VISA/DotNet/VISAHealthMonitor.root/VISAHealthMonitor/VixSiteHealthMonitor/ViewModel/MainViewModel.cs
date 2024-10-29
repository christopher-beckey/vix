using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using System.Windows.Input;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VixHealthMonitorCommon;
using VixHealthMonitorCommon.monitoredproperty;
using VISACommon;
using VISAHealthMonitorCommon;
using System.Windows;

namespace VixSiteHealthMonitor.ViewModel
{
    /// <summary>
    /// This class contains properties that the main View can data bind to.
    /// <para>
    /// Use the <strong>mvvminpc</strong> snippet to add bindable properties to this ViewModel.
    /// </para>
    /// <para>
    /// You can also use Blend to data bind with the tool's support.
    /// </para>
    /// <para>
    /// See http://www.galasoft.ch/mvvm/getstarted
    /// </para>
    /// </summary>
    public class MainViewModel : ViewModelBase
    {

        public string SiteNumber { get; set; }
        public RelayCommand TestSiteCommand { get; private set; }
        public Cursor Cursor { get; set; }
        public BaseVixHealth BaseVixHealth { get; private set; }
        public VaSite VaSite { get; private set; }

        public Visibility DetailsVisibility { get; private set; }
        public string FailedIcon { get; private set; }
        public Visibility RealmVistaServerErrorIconVisibility { get; private set; }
        public Visibility RealmVistaPortErrorIconVisibility { get; private set; }

        public Visibility LongRunningThreadsErrorIconVisibility { get; private set; }
        public string LongRunningThreadsErrorMessage { get; private set; }

        public string Welcome
        {
            get
            {
                return "Welcome to MVVM Light";
            }
        }

        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>
        public MainViewModel()
        {
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
            }
            else
            {
                // Code runs "for real"
            }
            SiteNumber = "";
            VaSite = null;
            TestSiteCommand = new RelayCommand(() => TestSite());
            Messenger.Default.Register<CursorChangeMessage>(this, action => ReceiveCursorMessage(action));

            string settingsFilename = System.AppDomain.CurrentDomain.BaseDirectory + @"\settings.xml";
            VixHealthMonitorConfiguration.Initialize(settingsFilename);
            VixHealthMonitorConfiguration.Save();
            MonitoredPropertyManager.Initialize(VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration(), null);
            FailedIcon = Icons.failed;
            RealmVistaPortErrorIconVisibility = Visibility.Hidden;
            RealmVistaServerErrorIconVisibility = Visibility.Hidden;
            LongRunningThreadsErrorIconVisibility = Visibility.Hidden;
            LongRunningThreadsErrorMessage = "";
            DisplayHealth();
        }

        private void TestSite()
        {
            if (!string.IsNullOrEmpty(SiteNumber))
            {

                this.VaSite = SiteService.SiteServiceHelper.GetSite(
                    VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().SiteServiceUrl, SiteNumber);

                VisaHealth health = VisaHealthManager.GetVisaHealth(this.VaSite);
                Messenger.Default.Send<CursorChangeMessage>(new CursorChangeMessage(Cursors.Wait));
                if (VixHealthMonitorConfiguration.IsInitialized())
                {
                    VixHealthMonitorConfiguration config = VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration();
                    health.Update(config.GetHealthLoadOptionsArray(), config.HealthRequestTimeout);
                }
                else
                {
                    //health.UpdateAsync(
                    health.Update(null, VixHealthMonitorConfiguration.defaultHealthTimeout);
                }
                DisplayHealth();
                Messenger.Default.Send<CursorChangeMessage>(new CursorChangeMessage(Cursors.Arrow));
            }
        }

        private void DisplayHealth()
        {
            if (VaSite != null)
            {
                VisaHealth health = VisaHealthManager.GetVisaHealth(VaSite);

                if (VaSite.IsVix)
                {
                    BaseVixHealth = new VixHealth(health, false);
                }
                else
                {
                    BaseVixHealth = new CvixHealth(health, false);
                }


                if (health.LoadStatus == VixHealthLoadStatus.loaded)
                {
                    DetailsVisibility = Visibility.Visible;
                    RealmVistaServerErrorIconVisibility = (BaseVixHealth.IsRealmVistaServerConfiguredProperly() ? Visibility.Hidden : Visibility.Visible);
                    RealmVistaPortErrorIconVisibility = (BaseVixHealth.IsRealmVistaPortConfiguredProperly() ? Visibility.Hidden : Visibility.Visible);

                    if (BaseVixHealth.IsThreadsProcessingAboveCriticalLimit())
                    {
                        LongRunningThreadsErrorIconVisibility = Visibility.Visible;
                        LongRunningThreadsErrorMessage = BaseVixHealth.LongThreads + " threads have been running longer than " + BaseVixHealth.GetThreadCriticalLimit() + " ms, might indicate threads are deadlocked.";
                    }
                    else
                    {
                        LongRunningThreadsErrorIconVisibility = Visibility.Hidden;
                        LongRunningThreadsErrorMessage = "";
                    }

                }
                else
                {
                    DetailsVisibility = Visibility.Collapsed;
                    RealmVistaServerErrorIconVisibility = Visibility.Hidden;
                    RealmVistaPortErrorIconVisibility = Visibility.Hidden;
                    LongRunningThreadsErrorIconVisibility = Visibility.Hidden;
                    LongRunningThreadsErrorMessage = "";
                }
            }
            else
            {
                DetailsVisibility = Visibility.Collapsed;
                RealmVistaServerErrorIconVisibility = Visibility.Hidden;
                RealmVistaPortErrorIconVisibility = Visibility.Hidden;
                LongRunningThreadsErrorIconVisibility = Visibility.Hidden;
                LongRunningThreadsErrorMessage = "";
            }
        }

        private void ReceiveCursorMessage(CursorChangeMessage msg)
        {
            this.Cursor = msg.Cursor;
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean up if needed

        ////    base.Cleanup();
        ////}
    }
}