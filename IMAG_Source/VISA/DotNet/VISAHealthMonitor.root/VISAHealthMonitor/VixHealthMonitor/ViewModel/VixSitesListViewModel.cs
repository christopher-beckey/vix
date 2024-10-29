using GalaSoft.MvvmLight;
using VISAHealthMonitorCommon;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VixHealthMonitor.messages;
using System.Collections.ObjectModel;
using VISACommon;
using System.Windows.Documents;
using VISAHealthMonitorCommon.wiki;
using VISAHealthMonitorCommonControls;
using VixHealthMonitorCommon;
using VixHealthMonitorCommonControls;
using System.Windows;
using VISAChecksums;

namespace VixHealthMonitor.ViewModel
{
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
    public class VixSitesListViewModel : ViewModelBase
    {
        public ListViewSortedCollectionViewSource VisaSources { get; set; }
        public RelayCommand ListMouseDoubleClickCommand { get; set; }
        //public object SelectedItem { get; set; }
        public RelayCommand<string> SortCommand { get; private set; }
        public RelayCommand AddWatchCommand { get; private set; }
        public RelayCommand SelectedItemChangedCommand { get; set; }
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

        private object selectedItem = null;
        public object SelectedItem
        {
            get
            {
                return selectedItem;
            }
            set
            {
                if (selectedItem == value)
                    return;
                selectedItem = value;
                RaisePropertyChanged("SelectedItem");
                SelectedItemChanged();
            }
        }

        /// <summary>
        /// Initializes a new instance of the VixSitesListViewModel class.
        /// </summary>
        public VixSitesListViewModel()
        {
            ListMouseDoubleClickCommand = new RelayCommand(() => ListMouseDoubleClick());
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
            ViewVixRootCommand = new RelayCommand(() => ViewVixRootPage());
            ViewROIStatusCommand = new RelayCommand(() => ViewROIStatusPage());
            ViewChecksumsCommand = new RelayCommand(() => ViewChecksums());
            //SelectedItemChangedCommand = new RelayCommand(() => SelectedItemChanged());
            //TreeSelectedItemChangedCommand = new RelayCommand<object>((i) => TreeSelectedItemChanged(i));
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
                AdminVisibility = Visibility.Visible;
            }
            else
            {
                // Code runs "for real": Connect to service, etc...
                Messenger.Default.Register<ReloadSourcesMessage>(this, action => LoadVixSites(action));
                Messenger.Default.Register<DisplayVisaSourceMessage>(this, action => DisplayVisaSource(action));
                AdminVisibility = (VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().Admin == true ? Visibility.Visible : Visibility.Collapsed);
            }
            AddWatchCommand = new RelayCommand(AddWatch);
            VisaSources = new ListViewSortedCollectionViewSource();
            VisaSources.Sort("VisaSource.DisplayName");
            SortCommand = new RelayCommand<string>(msg => VisaSources.Sort(msg));
            
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
            if (selectedItem != null)
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
        
        private void SelectedItemChanged()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                Messenger.Default.Send<DisplayVisaHealthMessage>(new DisplayVisaHealthMessage(source.VisaSource));
            }
        }

        private void DisplayVisaSource(DisplayVisaSourceMessage displayVisaSourceMessage)
        {
            VisaHealth health = VisaHealthManager.GetVisaHealth(displayVisaSourceMessage.VisaSource);
            SelectedItem = new VixHealthSource(displayVisaSourceMessage.VisaSource, new BaseVixHealth(health));
            Messenger.Default.Send<DisplayVisaHealthMessage>(new DisplayVisaHealthMessage(displayVisaSourceMessage.VisaSource));
        }

        private void AddWatch()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                Messenger.Default.Send<ChangeWatchedSiteMessage>(new ChangeWatchedSiteMessage(true, source.VisaSource));
            }
        }

        private void LoadVixSites(ReloadSourcesMessage msg)
        {
            //VisaSources = new ObservableCollection<VixHealthSource>();
            VisaSources.ClearSource();
            ObservableCollection<VixHealthSource> sources = new ObservableCollection<VixHealthSource>();
            foreach (VaSite site in VixSourceHolder.getSingleton().VisaSources)
            {
                if (site.IsVixOrCvix)
                {
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    sources.Add(new VixHealthSource(site, new BaseVixHealth(health)));
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

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}