using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;
using VISAHealthMonitorCommon.messages;
using VISAHealthMonitorCommon;
using VISACommon;
using GalaSoft.MvvmLight.Messaging;
using System.Collections.Generic;
using GalaSoft.MvvmLight.Command;
using VixHealthMonitorCommon;
using VISAHealthMonitorCommonControls;
using VixHealthMonitor.messages;
using VISAChecksums;
using VixHealthMonitorCommonControls;

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
    public class CvixListViewModel : ViewModelBase
    {
        public ListViewSortedCollectionViewSource VixSources { get; set; }
        public RelayCommand ListMouseDoubleClickCommand { get; set; }
        public object SelectedItem { get; set; }
        public RelayCommand<string> SortCommand { get; private set; }
        public RelayCommand TestCVIXCommand { get; private set; }

        public RelayCommand ShowSiteDetailsCommand { get; private set; }
        public RelayCommand ViewTransactionLogCommand { get; private set; }
        public RelayCommand ViewSiteServiceCommand { get; private set; }
        public RelayCommand ViewJavaLogsCommand { get; private set; }

        public RelayCommand ViewThreadsCommand { get; set; }
        public RelayCommand ViewMemoryInformationCommand { get; private set; }
        public RelayCommand ViewLoggedTestResultsCommand { get; private set; }
        public RelayCommand ViewChecksumsCommand { get; private set; }

        /// <summary>
        /// Initializes a new instance of the CvixListViewModel class.
        /// </summary>
        public CvixListViewModel()
        {
            ListMouseDoubleClickCommand = new RelayCommand(() => ListMouseDoubleClick());
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
            }
            else
            {
                // Code runs "for real": Connect to service, etc...
                Messenger.Default.Register<ReloadSourcesMessage>(this, action => LoadVixSites(action));
            }
            VixSources = new ListViewSortedCollectionViewSource();
            VixSources.Sort("VisaSource.DisplayName");
            SortCommand = new RelayCommand<string>(msg => VixSources.Sort(msg));
            TestCVIXCommand = new RelayCommand(() => TestCVIX());
            ShowSiteDetailsCommand = new RelayCommand(ShowSiteDetails);
            ViewTransactionLogCommand = new RelayCommand(() => viewTransactionLogs());
            ViewSiteServiceCommand = new RelayCommand(() => viewSiteService());
            ViewJavaLogsCommand = new RelayCommand(() => viewJavaLogs());
            ViewThreadsCommand = new RelayCommand(() => ViewVixThreads());
            ViewMemoryInformationCommand = new RelayCommand(() => ViewMemoryInformation());
            ViewLoggedTestResultsCommand = new RelayCommand(() => ViewLoggedTestResults());
            ViewChecksumsCommand = new RelayCommand(() => ViewChecksums());
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

        private void LoadVixSites(ReloadSourcesMessage msg)
        {
            ObservableCollection<VixHealthSource> vixSources = new ObservableCollection<VixHealthSource>();
            List<VisaSource> sources = VixSourceHolder.getSingleton().VisaSources;

            foreach (VaSite site in sources)
            {
                if (site.IsCvix && !site.TestSite)
                {
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    vixSources.Add(new VixHealthSource(site, new CvixHealth(health)));
                }
            }
            VixSources.SetSource(vixSources);
        }

        private void TestCVIX()
        {
            // only test CVIX servers
            List<VaSite> sites = new List<VaSite>();                      
            List<VisaSource> sources = VixSourceHolder.getSingleton().VisaSources;

            foreach (VaSite site in sources)
            {
                if (site.IsCvix)
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

        private void ListMouseDoubleClick()
        {
            if (SelectedItem != null)
            {
                VixHealthSource source = (VixHealthSource)SelectedItem;
                Messenger.Default.Send<UpdateAndDisplayVisaHealthMessage>(new UpdateAndDisplayVisaHealthMessage(source.VisaSource));
                source.VixHealth.Update();
            }
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}