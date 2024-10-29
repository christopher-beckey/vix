using GalaSoft.MvvmLight;
using VISACommon;
using System.Collections.ObjectModel;
using VISAHealthMonitorCommon;
using VISAHealthMonitorCommon.messages;
using GalaSoft.MvvmLight.Messaging;
using GalaSoft.MvvmLight.Command;
using System.Collections.Generic;
using VixHealthMonitor.messages;
using VixHealthMonitor.Model;
using System.Windows;
using VISAHealthMonitorCommonControls;
using VISAHealthMonitorCommon.wiki;
using VixHealthMonitorCommon;
using VixHealthMonitorCommonControls;
using VISAChecksums;


namespace VixHealthMonitor.ViewModel
{
    delegate ObservableCollection<VixHealthSource> GetSourcesDelegate();
    delegate void VisaHealthUpdateSourceDelegate(VisaHealthUpdatedMessage msg);

    /// <summary>
    /// This class contains properties that a View can data bind to.
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
    public class VixListViewModel : ViewModelBase
    {
        public ListViewSortedCollectionViewSource VisaSources { get; set; }
        public RelayCommand ListMouseDoubleClickCommand { get; set; }
        public object SelectedItem { get; set; }
        public RelayCommand<string> SortCommand { get; private set; }
        public Dictionary<string, int> ColumnWidths { get; private set; }
        public RelayCommand AddWatchCommand { get; private set; }
        public Visibility AddWatchVisibility { get; private set; }
        
        public ListViewColumns ListViewColumns { get; set; }

        public VixListViewMode VixListviewMode { get; set; }
        private WatchedSiteConfiguration WatchedSiteConfiguration;
        public RelayCommand RemoveWatchedSourceCommand { get; private set; }
        public Visibility RemoveWatchVisibility { get; private set; }
        public RelayCommand ShowSiteDetailsCommand { get; private set; }
        public RelayCommand ViewTransactionLogCommand { get; private set; }
        public RelayCommand ViewSiteServiceCommand { get; private set; }
        public RelayCommand ViewJavaLogsCommand { get; private set; }
        public RelayCommand ViewVixAdministratorsCommand { get; private set; }

        public RelayCommand ViewThreadsCommand { get; set; }
        public RelayCommand ViewMemoryInformationCommand { get; private set; }

        public RelayCommand ViewLoggedTestResultsCommand { get; private set; }
        public Visibility AdminVisibility { get; private set; }
        public RelayCommand ViewTomcatLibsCommand { get; private set; }
        public RelayCommand ViewJreLibExtLibsCommand { get; private set; }
        public RelayCommand ViewJmxUtilityCommand { get; private set; }
        public RelayCommand ViewVixSystemInformationCommand { get; private set; }
        public RelayCommand ViewChecksumsCommand { get; private set; }

        public RelayCommand ViewVixRootCommand { get; private set; }
        public RelayCommand ViewROIStatusCommand { get; private set; }

        public RelayCommand RefreshTestSitesCommand { get; private set; }
        public Visibility RefreshTestSitesVisibility { get; private set; }

        /// <summary>
        /// Initializes a new instance of the VixListViewModel class.
        /// </summary>
        public VixListViewModel()
        {
            ListMouseDoubleClickCommand = new RelayCommand(() => ListMouseDoubleClick());
            AddWatchVisibility = Visibility.Visible;
            RemoveWatchVisibility = Visibility.Collapsed;
            VixListviewMode = VixListViewMode.all;
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
                AdminVisibility = Visibility.Visible;
            }
            else
            {
                Messenger.Default.Register<ReloadSourcesMessage>(this, action => LoadVixSites(action));
                Messenger.Default.Register<SaveConfigurationPropertiesMessage>(this, msg => ReceiveSaveConfigurationPropertiesMessage(msg));
                ViewVixRootCommand = new RelayCommand(() => ViewVixRootPage());
                ViewROIStatusCommand = new RelayCommand(() => ViewROIStatusPage());
                SortCommand = new RelayCommand<string>(msg => VisaSources.Sort(msg));
                AddWatchCommand = new RelayCommand(AddWatch);
                ShowSiteDetailsCommand = new RelayCommand(ShowSiteDetails);
                ViewTransactionLogCommand = new RelayCommand(() => viewTransactionLogs());
                ViewSiteServiceCommand = new RelayCommand(() => viewSiteService());
                ViewJavaLogsCommand = new RelayCommand(() => viewJavaLogs());
                ViewVixAdministratorsCommand = new RelayCommand(() => ViewVixAdministrators());
                ViewThreadsCommand = new RelayCommand(() => ViewVixThreads());
                ViewMemoryInformationCommand = new RelayCommand(() => ViewMemoryInformation());
                ViewLoggedTestResultsCommand = new RelayCommand(() => ViewLoggedTestResults());
                ViewJreLibExtLibsCommand = new RelayCommand(() => ViewJreLibExtLibs());
                ViewTomcatLibsCommand = new RelayCommand(() => ViewTomcatLibs());
                ViewJmxUtilityCommand = new RelayCommand(() => ViewJmxUtility());
                ViewVixSystemInformationCommand = new RelayCommand(() => ViewVixSystemInformation());
                ViewChecksumsCommand = new RelayCommand(() => ViewChecksums());
                RefreshTestSitesCommand = new RelayCommand(() => RefreshTestSites());

                AdminVisibility = (VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().Admin == true ? Visibility.Visible : Visibility.Collapsed);
                // Code runs "for real": Connect to service, etc...
            }

            if (VixHealthMonitorConfiguration.IsInitialized())
            {
                
                VixHealthMonitorConfiguration configuration =
                    VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration();
                ListViewColumns = configuration.GetListViewColumns("Main", "VixListViewModel");
                
                
                /*
                foreach (ListViewColumns columnWidths in configuration.ColumnWidths)
                {
                    if (columnWidths.ContainerName == "Main" && columnWidths.ViewName == "VixListViewModel")
                    {
                         columnWidths.ColumnSizes.Clear();
                        columnWidths
                        break;
                    }
                    
                }*/
            }
            else
            {
            }

            VisaSources = new ListViewSortedCollectionViewSource();
            VisaSources.Sort("VisaSource.DisplayName");
            RefreshTestSitesVisibility = Visibility.Collapsed;
            
        }

        private void ViewChecksums()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;

                VaSite site = (VaSite)source.VisaSource;
                VisaType visaType = VisaType.vix;
                if (site.IsCvix)
                {
                    visaType = VisaType.cvix;
                }

                ChecksumsView checksumsView = new ChecksumsView(source.VisaSource,
                    visaType, VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration());
                checksumsView.Show();
            }
        }

        private void RefreshTestSites()
        {
            // only test Test Site servers
            List<VaSite> sites = new List<VaSite>();
            List<VisaSource> sources = VixSourceHolder.getSingleton().VisaSources;

            foreach (VaSite site in sources)
            {
                if (site.TestSite)
                {
                    sites.Add(site);
                }
            }

            if (VixHealthMonitorConfiguration.IsInitialized())
            {
                VixHealthMonitorConfiguration config = VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration();
                VisaHealthManager.RefreshHealth(sites, true, false,
                    config.GetHealthLoadOptionsArray(), config.HealthRequestTimeout);
            }
            else
            {
                VisaHealthManager.RefreshHealth(sites, true, false, null, VixHealthMonitorConfiguration.defaultHealthTimeout);
            }
        }

        private void ViewVixRootPage()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                VixHealthMonitorHelper.LaunchUrl(source.VixHealth.ViewVixRootUrl);
            }
        }

        private void ViewROIStatusPage()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                string roiUrl = source.VixHealth.ViewROIStatusUrl;
                if (roiUrl != null)
                    VixHealthMonitorHelper.LaunchUrl(roiUrl);
                else
                    Messenger.Default.Send<StatusMessage>(new StatusMessage("Site '" + source.VisaSource.DisplayName + "' does not have ROI functionality", true));
            }
        }

        private void ViewVixSystemInformation()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                VixSystemInformationView systemInformationView = new VixSystemInformationView(source.VisaSource);
                systemInformationView.Show();
            }
        }

        private void ViewJmxUtility()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                JmxView jmxView = new JmxView(source.VisaSource);
                jmxView.Show();
            }
        }

        private void ViewTomcatLibs()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                VixHealthMonitorHelper.LaunchUrl(source.VixHealth.ViewLibsUrl(false));
            }
        }

        private void ViewJreLibExtLibs()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                VixHealthMonitorHelper.LaunchUrl(source.VixHealth.ViewLibsUrl(true));
            }
        }

        private void ViewLoggedTestResults()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                LoggedTestResultView testResultsView = new LoggedTestResultView(source.VisaSource);
                testResultsView.Show();
            }
        }

        private void ViewMemoryInformation()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;

                MemoryView memoryView = new MemoryView(source.VisaHealth);
                memoryView.Show();
            }
        }

        private void ViewVixThreads()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                Threads threadsViewer = new Threads(source.VisaSource);
                threadsViewer.Show();
            }
        }

        private void ViewVixAdministrators()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                VixAdministratorsView administratorsView = new VixAdministratorsView(source.VisaSource, 
                    VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration());
                administratorsView.Show();
            }
        }

        private void viewJavaLogs()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                VixHealthMonitorHelper.LaunchUrl(source.VixHealth.ViewJavaLogUrl);
            }
        }

        private void viewTransactionLogs()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                VixHealthMonitorHelper.LaunchUrl(source.VixHealth.ViewTransactionLogUrl);
            }
        }

        private void viewSiteService()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                VixHealthMonitorHelper.LaunchUrl(source.VixHealth.ViewSiteServiceUrl);
            }
        }

        private void ShowSiteDetails()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                Messenger.Default.Send<DisplayVisaSourceMessage>(new DisplayVisaSourceMessage(source.VisaSource));
            }
        }

        private void AddWatch()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                Messenger.Default.Send<ChangeWatchedSiteMessage>(new ChangeWatchedSiteMessage(true, source.VisaSource));
            }
            
        }

        public void SetShowTestSitesOnly()
        {
            RefreshTestSitesVisibility = Visibility.Visible;
            VixListviewMode = VixListViewMode.testSites;
            if (!IsInDesignMode)
            {
                Messenger.Default.Register<VisaHealthUpdatedMessage>(this, action => VisaHealthUpdated(action));
            }
        }

        public void SetShowErrorsOnly()
        {
            VixListviewMode = VixListViewMode.errorsOnly;
            if (!IsInDesignMode)
            {
                Messenger.Default.Register<VisaHealthUpdatedMessage>(this, action => VisaHealthUpdated(action));
            }
        }

        public void SetShowWatchSites()
        {
            VixListviewMode = VixListViewMode.watchSites;
            if (!IsInDesignMode)
            {
                Messenger.Default.Register<ChangeWatchedSiteMessage>(this, action => ChangeWatchedSite(action));
            }
            RemoveWatchedSourceCommand = new RelayCommand(RemoveWatchedSource);
            string watchedSitesFilename = System.AppDomain.CurrentDomain.BaseDirectory + @"\watched_sites.xml";
            WatchedSiteConfiguration = WatchedSiteConfiguration.Initialize(watchedSitesFilename);
            AddWatchVisibility = Visibility.Collapsed;
            RemoveWatchVisibility = Visibility.Visible;
        }

        private void RemoveWatchedSource()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;                
                //VisaHealth visaHealth = VisaHealthManager.GetVisaHealth(visaSource);
                VaSite site = (VaSite)source.VisaSource;
                BaseVixHealth health = new BaseVixHealth(source.VisaHealth);// visaHealth);
                VixHealthSource vixHealthSource = new VixHealthSource(source.VisaSource, health);
                ObservableCollection<VixHealthSource> sources = (ObservableCollection<VixHealthSource>)VisaSources.Sources.Source;
                sources.Remove(vixHealthSource);
                WatchedSiteConfiguration.WatchedSites.Remove(site.SiteNumber);
                WatchedSiteConfiguration.Save();
            }
        }

        private void ChangeWatchedSite(ChangeWatchedSiteMessage msg)
        {
            VaSite site = (VaSite)msg.VisaSource;
            ObservableCollection<VixHealthSource> sources = (ObservableCollection<VixHealthSource>)VisaSources.Sources.Source;
            if (WatchedSiteConfiguration.IsSiteWatched(site.SiteNumber))
            {
                if (msg.Watch)
                {
                    // already watched, do nothing
                }
                else
                {
                    // currently watched but want to remove                                       
                    WatchedSiteConfiguration.WatchedSites.Remove(site.SiteNumber);
                    WatchedSiteConfiguration.Save();
                    VisaHealth visaHealth = VisaHealthManager.GetVisaHealth(site);
                    BaseVixHealth health = new BaseVixHealth(visaHealth);
                    VixHealthSource vixHealthSource = new VixHealthSource(site, health);

                    sources.Remove(vixHealthSource);
                }
            }
            else
            {
                // not currently watching
                if (msg.Watch)
                {
                    WatchedSiteConfiguration.WatchedSites.Add(site.SiteNumber);
                    WatchedSiteConfiguration.Save();
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    sources.Add(new VixHealthSource(site, new BaseVixHealth(health)));
                }
            }
        }

        private void VisaHealthUpdated(VisaHealthUpdatedMessage msg)
        {
            if (this.VixListviewMode == VixListViewMode.errorsOnly)
            {
                VisaHealthUpdateSourceDelegate d = new VisaHealthUpdateSourceDelegate(VisaHealthUpdatedInternal);
                VisaSources.Sources.Dispatcher.Invoke(d, new object[] { msg });
            }

            /*
            GetSourcesDelegate d = new GetSourcesDelegate(GetSources);
            ObservableCollection<VixHealthSource> sources = (ObservableCollection<VixHealthSource>)VisaSources.Sources.Dispatcher.Invoke(d, new object[] { });

            //ObservableCollection<VixHealthSource> sources = (ObservableCollection<VixHealthSource>)VisaSources.Sources.Source;
            VixHealth vixHealth = new VixHealth( msg.VisaHealth);
            VixHealthSource vixHealthSource = new VixHealthSource(msg.VisaSource, vixHealth);
            if (vixHealth.VisaHealth.LoadStatus != VixHealthLoadStatus.loading)
            {
                if (vixHealth.VisaHealth.LoadStatus == VixHealthLoadStatus.unknown)
                {
                    ensureInSources(sources, vixHealthSource);
                }
                else
                {
                    if (vixHealth.IsHealthy())
                    {
                        if (sources.Contains(vixHealthSource))
                            sources.Remove(vixHealthSource);
                    }
                    else
                    {
                        ensureInSources(sources, vixHealthSource);    
                    }
                }
            }
            */
        }

        private void VisaHealthUpdatedInternal(VisaHealthUpdatedMessage msg)
        {
            //GetSourcesDelegate d = new GetSourcesDelegate(GetSources);
            //ObservableCollection<VixHealthSource> sources = (ObservableCollection<VixHealthSource>)VisaSources.Sources.Dispatcher.Invoke(d, new object[] { });

            ObservableCollection<VixHealthSource> sources = (ObservableCollection<VixHealthSource>)VisaSources.Sources.Source;
            VixHealth vixHealth = new VixHealth(msg.VisaHealth);
            VixHealthSource vixHealthSource = new VixHealthSource(msg.VisaSource, vixHealth);
            if (vixHealth.VisaHealth.LoadStatus != VixHealthLoadStatus.loading)
            {
                if (vixHealth.VisaHealth.LoadStatus == VixHealthLoadStatus.unknown)
                {
                    ensureInSources(sources, vixHealthSource);
                }
                else
                {
                    if (vixHealth.IsHealthy())
                    {
                        if (sources.Contains(vixHealthSource))
                            sources.Remove(vixHealthSource);
                    }
                    else
                    {
                        ensureInSources(sources, vixHealthSource);
                    }
                }
            }
            //sources.Remove(
        }

        private ObservableCollection<VixHealthSource> GetSources()
        {
            return (ObservableCollection<VixHealthSource>)VisaSources.Sources.Source;
        }

        private void ensureInSources(ObservableCollection<VixHealthSource> sources, VixHealthSource vixHealthSource)
        {
            if (!sources.Contains(vixHealthSource))
            {
                sources.Add(vixHealthSource);
            }
        }

        private void LoadVixSites(ReloadSourcesMessage msg)
        {
            //VisaSources = new ObservableCollection<VixHealthSource>();
            VisaSources.ClearSource();
            ObservableCollection<VixHealthSource> sources = new ObservableCollection<VixHealthSource>();
            foreach (VaSite site in VixSourceHolder.getSingleton().VisaSources)
            {
                if (site.TestSite && this.VixListviewMode == VixListViewMode.testSites)
                {
                    // include vix and cvix in this list
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    VixHealth vixHealth = new VixHealth(health);
                    sources.Add(new VixHealthSource(site, vixHealth));
                }
                else if (site.IsVix)
                {
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    VixHealth vixHealth = new VixHealth(health);
                    if (this.VixListviewMode == VixListViewMode.errorsOnly)
                    {
                        // exclude test sites from this list
                        if (site.TestSite)
                            continue;
                        if (health.LoadStatus == VixHealthLoadStatus.loaded)
                        {
                            if (!vixHealth.IsHealthy())
                            {
                                sources.Add(new VixHealthSource(site, vixHealth));
                            }
                        }
                        else if (health.LoadStatus == VixHealthLoadStatus.unknown)
                        {
                            sources.Add(new VixHealthSource(site, vixHealth));
                        }
                    }
                    else if (this.VixListviewMode == VixListViewMode.watchSites)
                    {                        
                        if (WatchedSiteConfiguration.IsSiteWatched(site.SiteNumber))
                        {
                            sources.Add(new VixHealthSource(site, vixHealth));
                        }
                    }
                    else if(this.VixListviewMode == VixListViewMode.all)
                    {
                        // exclude test sites from this list
                        if (site.TestSite)
                            continue;
                        sources.Add(new VixHealthSource(site, vixHealth));
                    }
                }
            }
            VisaSources.SetSource(sources);
        }

        private void ListMouseDoubleClick()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                Messenger.Default.Send<UpdateAndDisplayVisaHealthMessage>(new UpdateAndDisplayVisaHealthMessage(source.VisaSource));
            }
        }

        private void ReceiveSaveConfigurationPropertiesMessage(SaveConfigurationPropertiesMessage msg)
        {
            // save settings now!
            /*
            if (VixHealthMonitorConfiguration.IsInitialized())
            {
                VixHealthMonitorConfiguration configuration =
                    VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration();
                foreach (ListViewColumns columnWidths in configuration.ColumnWidths)
                {
                    if (columnWidths.ContainerName == "Main" && columnWidths.ViewName == "VixListViewModel")
                    {
                         columnWidths.ColumnSizes.Clear();
                        columnWidths
                        break;
                    }
                    
                }
            }*/
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }

    public enum VixListViewMode
    {
        all, errorsOnly, watchSites, testSites
    }
}