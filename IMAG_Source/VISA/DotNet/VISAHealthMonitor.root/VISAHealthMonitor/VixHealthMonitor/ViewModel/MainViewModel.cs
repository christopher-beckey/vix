using GalaSoft.MvvmLight;
using System.Windows.Input;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using System.Windows;
using VISAHealthMonitorCommon;
using VISACommon;
using System.Timers;
using VixHealthMonitor.messages;
using System.Collections.ObjectModel;
using System;
using VixHealthMonitorCommon;
using VixHealthMonitorCommon.testresult;
using VixHealthMonitorCommon.monitoredproperty;

namespace VixHealthMonitor.ViewModel
{

    public delegate bool? ShowSettingsDialogDelegate();

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
        public Cursor Cursor { get; set; }
        public RelayCommand ExitApplicationCommand { get; set; }
        public RelayCommand WindowClosingCommand { get; set; }
        public RelayCommand WindowLoadedCommand { get; set; }
        public string ApplicationCaption { get; set; }
        public RelayCommand SettingsCommand { get; set; }
        public string WindowIcon { get; set; }
        public string LongRunningThreadsTabTitle { get; private set; }
        public Visibility LongRunningThreadsErrorVisibility { get; private set; }
        public string ErrorIcon { get; private set; }

        public string TestSitesErrorIcon { get; private set; }

        public event EventHandler<WarningMessage> WarningMessage;
        public event ShowSettingsDialogDelegate OnShowSettingsDialogEvent;

        private Timer intervalTimer = null;
        private Timer startupTimer = null;
        /// <summary>
        /// Determines if the interval timer was enabled by the user
        /// </summary>
        private bool intervalTimerEnabled = false;

        private bool currentlyUpdatingAllSites = false;

        public ObservableCollection<VixHealthSource> VixSources { get; private set; }

        public WindowPosition MainWindowPosition { get; set; }

        private static string mainWindowName = "Main";
        public int SelectedTabIndex { get; set; }
        public Visibility SiteUtilitiesVisibility { get; private set; }

        private bool StartIntervalTestingImmediately { get; set; }

        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>
        public MainViewModel()
        {
            int reloadInterval = 20;
            StartIntervalTestingImmediately = false;
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
                MainWindowPosition = new WindowPosition(mainWindowName);
                SiteUtilitiesVisibility = Visibility.Visible;
            }
            else
            {
                Messenger.Default.Register<CursorChangeMessage>(this, action => ReceiveCursorMessage(action));
                
                Messenger.Default.Register<UpdateSourcesMessage>(this, action => ReceiveUpdateSourcesMessage(action));
                Messenger.Default.Register<ReloadSourcesMessage>(this, msg => ReceiveReloadSourcesMessage(msg));
                Messenger.Default.Register<StartStopIntervalTestMessage>(this, msg => ReceiveStartStopIntervalTestMessage(msg));
                Messenger.Default.Register<VisaHealthUpdatedMessage>(this, msg => ReceiveVisaHealthUpdatedMessage(msg));
                Messenger.Default.Register<AllSourcesHealthUpdateMessage>(this, msg => ReceiveAllSourcesHealthUpdateMessage(msg));
                Messenger.Default.Register<TestAllSourcesMessage>(this, msg => ReceieveTestAllSourcesMessage(msg));
                ExitApplicationCommand = new RelayCommand(() => ExitApplication());
                SettingsCommand = new RelayCommand(() => Settings());
                WindowClosingCommand = new RelayCommand(() => WindowClosing());
                WindowLoadedCommand = new RelayCommand(() => WindowLoaded());

                string settingsFilename = System.AppDomain.CurrentDomain.BaseDirectory + @"\settings.xml";
                if (App.mArgs != null && App.mArgs.Length > 0)
                {
                    if ("start".Equals(App.mArgs[0], StringComparison.CurrentCultureIgnoreCase))
                    {
                        StartIntervalTestingImmediately = true;
                    }
                    else
                    {
                        // contains an alternative location for the settings.xml file
                        settingsFilename = App.mArgs[0];
                    }
                }


                
                VixHealthMonitorConfiguration.Initialize(settingsFilename);
                reloadInterval =  VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().ReloadInterval;
                MainWindowPosition = VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().GetWindowPosition(mainWindowName);
                Messenger.Default.Register<DisplayVisaSourceMessage>(this, msg => ReceiveDisplayVisaSourceMessage(msg));


                VisaHealthTestResultManager.Initialize(VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration());
                VixHealthMonitorConfiguration config = VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration();
                SiteUtilitiesVisibility = (config.Admin == true ? Visibility.Visible : Visibility.Collapsed);

                MonitoredPropertyManager.Initialize(VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration(), null);

            }
            VixSources = new ObservableCollection<VixHealthSource>();
            intervalTimer = new Timer(1000 * 60 * reloadInterval);
            intervalTimer.Enabled = false;
            intervalTimer.Elapsed += IntervalTimerEllapsed;
            ApplicationCaption = "VIX Health Monitor";
            SelectedTabIndex = 0;
            LongRunningThreadsTabTitle = "Long Running Threads";
            SiteUtilitiesVisibility = Visibility.Collapsed;
            ErrorIcon = Icons.failed;
            TestSitesErrorIcon = Icons.unknown;

            SetWindowIcon();
        }

        private void ReceiveDisplayVisaSourceMessage(DisplayVisaSourceMessage msg)
        {
            SelectedTabIndex = 0; // just set the tab to the first one
        }

        private void ReceiveVisaHealthUpdatedMessage(VisaHealthUpdatedMessage msg)
        {
            // if a single site is being updated, want to evaluate it to set the window icon properly
            //if(!intervalTimerEnabled)
            // JMW 4/4/2013 - want to base  it on if the sites are currently in the process of being updated, not if the interval timer is active
            // also only set the icon if it is not in the process of loading (since setWindowIcon evaluates all sources, not just the updated one
            if(!currentlyUpdatingAllSites && msg.VisaHealth.LoadStatus != VixHealthLoadStatus.loading) 
                SetWindowIcon();
        }

        private void SetWindowIcon()
        {
            long longRunningThreads = 0;
            int failedCount = 0;
            bool failedFound = false;
            bool unloadedFound = false;
            bool testSitesNotLoaded = false;
            bool testSitesFailed = false;
            foreach (VixHealthSource vixHealthSource in VixSources)
            {
                if (vixHealthSource.VixHealth.VaSite.TestSite)
                {
                    if (vixHealthSource.VisaHealth.LoadStatus == VixHealthLoadStatus.loaded)
                    {
                        if (!vixHealthSource.VixHealth.IsHealthy())
                        {
                            testSitesFailed = true;
                        }
                    }
                    else
                    {
                        testSitesNotLoaded = true;
                    }
                }
                else
                {

                    if (vixHealthSource.VisaHealth.LoadStatus == VixHealthLoadStatus.loaded)
                    {
                        if (!vixHealthSource.VixHealth.IsHealthy())
                        {
                            failedFound = true;
                            failedCount++;
                            longRunningThreads += vixHealthSource.VixHealth.LongThreads.Number;
                        }
                    }
                    else
                    {
                        unloadedFound = true;
                    }
                }
            }
            if (failedFound)
                WindowIcon = Icons.failed;
            else if (unloadedFound)
                WindowIcon = Icons.unknown;
            else
                WindowIcon = Icons.passed;

            if (failedCount > 0)
            {
                if (WarningMessage != null)
                {
                    WarningMessage(this, new WarningMessage( failedCount + " sites have errors"));
                }
            }
            LongRunningThreadsErrorVisibility = ((longRunningThreads > 0) ? Visibility.Visible : Visibility.Collapsed);
            LongRunningThreadsTabTitle = "Long Running Threads (" + longRunningThreads + ")";
            if (testSitesFailed)
                TestSitesErrorIcon = Icons.failed;
            else if (testSitesNotLoaded)
                TestSitesErrorIcon = Icons.unknown;
            else
                TestSitesErrorIcon = Icons.passed;
        }

        private void WindowLoaded()
        {
            //VixSourceHolder.getSingleton().Refresh();
            startupTimer = new Timer();
            startupTimer.Enabled = false;
            startupTimer.Interval = 1000 * 1; // 1 second
            startupTimer.Elapsed += StartupTimerIntervalEllapsed;
            startupTimer.Enabled = true;
        }

        private void StartupTimerIntervalEllapsed(object sender, ElapsedEventArgs e)
        {
            if (startupTimer != null)
                startupTimer.Enabled = false;
            Messenger.Default.Send<StatusMessage>(new StatusMessage("Loading Site Service Information"));
            VixSourceHolder.getSingleton().Refresh();
            if (StartIntervalTestingImmediately)
            {
                // want to start interval timer immediately, send the message to start it
                Messenger.Default.Send<StartStopIntervalTestMessage>(new StartStopIntervalTestMessage(this));
            }
        }

        private void WindowClosing()
        {
            Messenger.Default.Send<SaveConfigurationPropertiesMessage>(new SaveConfigurationPropertiesMessage());

            VixHealthMonitorConfiguration.Save();                
        }

        private void ReceiveAllSourcesHealthUpdateMessage(AllSourcesHealthUpdateMessage msg)
        {
            // all stuff is done, if was doing interval timer, re-enable it
            if (intervalTimerEnabled && msg.Completed)
                intervalTimer.Enabled = true;
            currentlyUpdatingAllSites = !msg.Completed;
            // evaluate the icon for the Window
            if(msg.Completed)
                SetWindowIcon();
            
        }

        private void IntervalTimerEllapsed(object sender, ElapsedEventArgs e)
        {
            intervalTimer.Enabled = false; // stop the timer until all health is updated
            UpdateAllHealth(true, false);
            // don't enable it again until everything is done
        }

        private void ReceieveTestAllSourcesMessage(TestAllSourcesMessage msg)
        {
            UpdateAllHealth(msg.Async, msg.OnlyTestFailed);
        }

        private void UpdateAllHealth(bool async, bool onlyTestFailed)
        {
            VixHealthMonitorConfiguration config = VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration();
            VisaHealthOption[] options = config.GetHealthLoadOptionsArray();
            int timeout = config.HealthRequestTimeout;
            VisaHealthManager.RefreshAllHealth(async, onlyTestFailed, options, timeout);
        }

        private void ReceiveStartStopIntervalTestMessage(StartStopIntervalTestMessage msg)
        {
            // start or stop the timer for interval testing
            intervalTimerEnabled = !intervalTimerEnabled;
            // if enabling stuff, update all health and then start the timer (it will start automatically after all the health has been updated)
            if (intervalTimerEnabled)
                UpdateAllHealth(true, false);
        }

        private void ReceiveReloadSourcesMessage(ReloadSourcesMessage msg)
        {
            VixSources = new ObservableCollection<VixHealthSource>();
            System.Collections.Generic.List<VisaSource> sources = VixSourceHolder.getSingleton().VisaSources;
            int vixCount = 0;
            foreach (VaSite site in sources)
            {
                if (site.IsVix && !site.TestSite)
                {
                    vixCount++;
                }
                if (site.IsVixOrCvix)
                {
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    VixSources.Add(new VixHealthSource(site, new BaseVixHealth(health)));
                }
            }
            ApplicationCaption = "VIX Health Monitor - " + vixCount + " Site VIX Servers";
            SetWindowIcon();
        }

        private void ReceiveUpdateSourcesMessage(UpdateSourcesMessage msg)
        {
            VixSourceHolder.getSingleton().Refresh();
        }

        private void ExitApplication()
        {
            Application.Current.Shutdown();
        }

        private void ReceiveCursorMessage(CursorChangeMessage msg)
        {
            this.Cursor = msg.Cursor;
        }

        private void Settings()
        {
            if (OnShowSettingsDialogEvent != null)
            {
                bool? result = OnShowSettingsDialogEvent();
                if (result.HasValue && result.Value)
                {
                    intervalTimer.Interval = 1000 * 60 * VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().ReloadInterval;
                }
            }
            /*
            ConfigurationWindow cw = new ConfigurationWindow();
            bool? result = cw.ShowDialog();
            if(result.HasValue && result.Value)
            {
                intervalTimer.Interval = 1000 * 60 * VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().ReloadInterval;
            }*/
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean up if needed

        ////    base.Cleanup();
        ////}
    }

    public class WarningMessage : EventArgs
    {
        public string Message { get; private set; }

        public WarningMessage(string message)
        {
            this.Message = message;
        }
    }
}