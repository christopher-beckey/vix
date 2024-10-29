using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using System.Collections.Generic;
using VISAHealthMonitorCommon;
using VISACommon;
using VixHealthMonitorCommon;
using System.Windows;
using VISAHealthMonitorCommon.monitorederror;
using VISAHealthMonitorCommon.formattedvalues;

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
    public class VixTestInformationViewModel : ViewModelBase
    {

        public ObservableCollection<VixHealthSource> VixSources { get; set; }
        public ListViewSortedCollectionViewSource VixVersions { get; set; }
        public ListViewSortedCollectionViewSource VixTestStatuses { get; set; }
        public ListViewSortedCollectionViewSource VixOperatingSystems { get; set; }
        public ListViewSortedCollectionViewSource VixOSArchitectures { get; set; }
        public ListViewSortedCollectionViewSource MonitoredErrors { get; private set; }

        public RelayCommand<string> VixVersionsSortCommand { get; private set; }
        public RelayCommand<string> VixTestStatusSortCommand { get; private set; }
        public RelayCommand<string> VixOperatingSystemSortCommand { get; private set; }
        public RelayCommand<string> VixOSArchitectureSortCommand { get; private set; }
        public RelayCommand<string> MonitoredErrorsSortCommand { get; private set; }

        public Visibility CVIXListViewVisibility { get; private set; }

        private bool fullSourceUpdating = false;

        /// <summary>
        /// Initializes a new instance of the VixTestInformationViewModel class.
        /// </summary>
        public VixTestInformationViewModel()
        {
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
            }
            else
            {
                // Code runs "for real": Connect to service, etc...
                Messenger.Default.Register<ReloadSourcesMessage>(this, action => LoadVixSites(action));
                Messenger.Default.Register<AllSourcesHealthUpdateMessage>(this, msg => ReceiveAllSourcesHealthUpdateMessage(msg));
                Messenger.Default.Register<VisaHealthUpdatedMessage>(this, msg => ReceiveVisaHealthUpdatedMessage(msg));
            }
            VixVersions = new ListViewSortedCollectionViewSource();
            VixVersions.Sort("Version");
            VixVersionsSortCommand = new RelayCommand<string>(msg => VixVersions.Sort(msg));

            VixTestStatuses = new ListViewSortedCollectionViewSource();
            VixTestStatuses.Sort("VixTestStatus");
            VixTestStatusSortCommand = new RelayCommand<string>(msg => VixTestStatuses.Sort(msg));

            VixOperatingSystems = new ListViewSortedCollectionViewSource();
            VixOperatingSystems.Sort("OperatingSystem");
            VixOperatingSystemSortCommand = new RelayCommand<string>(msg => VixOperatingSystems.Sort(msg));

            VixOSArchitectures = new ListViewSortedCollectionViewSource();
            VixOSArchitectures.Sort("OSArchitecture");
            VixOSArchitectureSortCommand = new RelayCommand<string>(msg => VixOSArchitectures.Sort(msg));

            MonitoredErrors = new ListViewSortedCollectionViewSource();
            MonitoredErrors.Sort("Name");
            MonitoredErrorsSortCommand = new RelayCommand<string>(msg => MonitoredErrors.Sort(msg));

            if (!IsInDesignMode)
            {
                SetDefaultValues();
            }
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}

        private void SetDefaultValues()
        {
            VixVersions.ClearSource();
            VixTestStatuses.ClearSource();
            VixOperatingSystems.ClearSource();
            VixOSArchitectures.ClearSource();
            MonitoredErrors.ClearSource();
            if (VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().ShowCVIXOnQuickView)
            {
                CVIXListViewVisibility = Visibility.Visible;
            }
            else
            {
                CVIXListViewVisibility = Visibility.Collapsed;
            }
        }

        private void LoadVixSites(ReloadSourcesMessage msg)
        {
            VixSources = new ObservableCollection<VixHealthSource>();
            System.Collections.Generic.List<VisaSource> sources = VixSourceHolder.getSingleton().VisaSources;

            foreach (VaSite site in sources)
            {

                if (site.IsVix)
                {
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    VixSources.Add(new VixHealthSource(site, new BaseVixHealth(health)));
                }
            }
        }

        private void ReceiveVisaHealthUpdatedMessage(VisaHealthUpdatedMessage msg)
        {
            // occurs when a single health instance updates, if not doing all of them then want to update based on this one
            if (!fullSourceUpdating)
            {
                UpdateValues();
            }
        }

        private void ReceiveAllSourcesHealthUpdateMessage(AllSourcesHealthUpdateMessage msg)
        {
            if (msg.Completed)
                UpdateValues();
            else
                SetDefaultValues(); // clear values while doing the update
            fullSourceUpdating = !msg.Completed;
        }

        private void UpdateValues()
        {
            ObservableCollection<VixVersionCount> versions = new ObservableCollection<VixVersionCount>();
            ObservableCollection<VixTestStatusCount> testStatuses = new ObservableCollection<VixTestStatusCount>();
            ObservableCollection<OperatingSystemCount> operatingSystems = new ObservableCollection<OperatingSystemCount>();
            ObservableCollection<OSArchitectureCount> osArchitecures = new ObservableCollection<OSArchitectureCount>();
            ObservableCollection<GenericCount> monitoredErrors = new ObservableCollection<GenericCount>();

            Dictionary<VixTestStatus, int> testStatusesCounts = new Dictionary<VixTestStatus, int>();
            Dictionary<string, int> versionCounts = new Dictionary<string, int>();
            Dictionary<string, int> operatingSystemCounts = new Dictionary<string, int>();
            Dictionary<string, int> osArchitectureCounts = new Dictionary<string, int>();
            Dictionary<string, int> monitoredErrorCounts = new Dictionary<string, int>();


            foreach (VixHealthSource vixHealthSource in VixSources)
            {
                // exclude test sites from these counts
                if (vixHealthSource.VixHealth.VaSite.TestSite)
                    continue;

                VisaHealth visaHealth = vixHealthSource.VixHealth.VisaHealth;
                if (visaHealth.LoadStatus == VixHealthLoadStatus.loaded)
                {
                    string version = visaHealth.VisaVersion;
                    BaseVixHealth vixHealth = vixHealthSource.VixHealth;
                    IncrementCount(versionCounts, version);
                    if (vixHealth.IsHealthy())
                    {
                        IncrementCount(testStatusesCounts, VixTestStatus.ok);
                    }
                    else
                    {
                        IncrementCount(testStatusesCounts, VixTestStatus.failed);
                    }

                    string OSName = vixHealth.OperatingSystemName;
                    if (OSName == "")
                        OSName = "unknown";
                    IncrementCount(operatingSystemCounts, OSName);
                    IncrementCount(osArchitectureCounts, vixHealth.VisaHealth.OperatingSystemArchitecture);

                    foreach (MonitoredError monitoredError in vixHealth.GetMonitoredErrors())
                    {
                        IncrementCount(monitoredErrorCounts, monitoredError.ErrorContains, (int)monitoredError.Count.Number);
                    }
                    
                }
                else
                {
                    //IncrementVersionCount(versionCounts, "unknown");
                    IncrementCount(versionCounts, "unknown");
                    IncrementCount(testStatusesCounts, VixTestStatus.not_loaded);
                    IncrementCount(operatingSystemCounts, "unknown");
                    IncrementCount(osArchitectureCounts, "unknown");
                }
            }

            foreach (string version in versionCounts.Keys)
            {
                versions.Add(new VixVersionCount(version, versionCounts[version]));
            }
            foreach (VixTestStatus status in testStatusesCounts.Keys)
            {
                testStatuses.Add(new VixTestStatusCount(status, testStatusesCounts[status]));
            }
            foreach (string osName in operatingSystemCounts.Keys)
            {
                operatingSystems.Add(new OperatingSystemCount(osName, operatingSystemCounts[osName]));
            }
            foreach (string osArchitecture in osArchitectureCounts.Keys)
            {
                osArchitecures.Add(new OSArchitectureCount(osArchitecture, osArchitectureCounts[osArchitecture]));
            }
            foreach (string monitoredErrorContains in monitoredErrorCounts.Keys)
            {
                monitoredErrors.Add(new GenericCount(monitoredErrorContains, new FormattedNumber(monitoredErrorCounts[monitoredErrorContains])));
            }

            VixVersions.SetSource(versions);
            VixTestStatuses.SetSource(testStatuses);
            VixOperatingSystems.SetSource(operatingSystems);
            VixOSArchitectures.SetSource(osArchitecures);
            MonitoredErrors.SetSource(monitoredErrors);
        }

        private void IncrementCount<T>(Dictionary<T, int> counts, T key, int amount)
        {
            if (counts.ContainsKey(key))
            {
                int count = counts[key] + amount;
                counts[key] = count;
            }
            else
            {
                counts.Add(key, amount);
            }
        }

        private void IncrementCount<T>(Dictionary<T, int> counts, T key)
        {
            IncrementCount(counts, key, 1);
        }

        /*
        private void IncrementVersionCount(Dictionary<string, int> versionCounts, string version)
        {
            if (versionCounts.ContainsKey(version))
            {
                int count = versionCounts[version] + 1;
                versionCounts[version] = count;
            }
            else
            {
                versionCounts.Add(version, 1);
            }
        }*/
    }

    public class VixTestStatusCount
    {
        public VixTestStatus VixTestStatus { get; private set; }
        public string VixTestStatusDescription { get; private set; }
        public int Count { get; set; }

        public VixTestStatusCount(VixTestStatus vixTestStatus, int count)
        {
            this.VixTestStatus = vixTestStatus;
            this.Count = count;

            switch (vixTestStatus)
            {
                case ViewModel.VixTestStatus.failed:
                    VixTestStatusDescription = "Failed";
                    break;
                case ViewModel.VixTestStatus.not_loaded:
                    VixTestStatusDescription = "Not Loaded";
                    break;
                case ViewModel.VixTestStatus.ok:
                    VixTestStatusDescription = "OK";
                    break;
            }
        }
    }

    public enum VixTestStatus
    {
        ok, failed, not_loaded
    }
    
    public class VixVersionCount
    {
        public string Version { get; private set; }
        public int Count { get; set; }

        public VixVersionCount(string version, int count)
        {
            this.Count = count;
            this.Version = version;
        }
    }

    public class OperatingSystemCount
    {
        public string OperatingSystem { get; private set; }
        public int Count { get; set; }

        public OperatingSystemCount(string operatingSystem, int count)
        {
            this.OperatingSystem = operatingSystem;
            this.Count = count;
        }
    }

    public class OSArchitectureCount
    {
        public string OSArchitecture { get; private set; }
        public int Count { get; set; }

        public OSArchitectureCount(string osArchitecture, int count)
        {
            this.OSArchitecture = osArchitecture;
            this.Count = count;
        }
    }
}