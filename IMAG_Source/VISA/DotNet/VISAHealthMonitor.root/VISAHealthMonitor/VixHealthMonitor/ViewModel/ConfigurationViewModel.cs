using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using System.Collections.ObjectModel;
using VISAHealthMonitorCommon;
using VixHealthMonitorCommon;
using VixHealthMonitorCommon.monitoredproperty;
using System.Windows;
using VISACommon;

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
    public class ConfigurationViewModel : ViewModelBase
    {
        public VixHealthMonitorConfiguration VixHealthConfiguration { get; private set; }
        public RelayCommand SaveCommand { get; set; }
        public RelayCommand CloseCommand { get; set; }
        public RelayCommand WindowLoadedCommand { get; set; }
        public bool? DialogResult { get; set; }
        public RelayCommand DefaultSiteServiceCommand { get; private set; }

        public ObservableCollection<VixLoadOption> HealthOptions { get; private set; }

        public ListViewSortedCollectionViewSource MonitoredProperties { get; private set; }
        public object SelectedMonitoredProperty { get; set; }
        public string NewMonitoredPropertyValue { get; set; }
        public RelayCommand AddMonitoredPropertyCommand { get; private set; }
        public ObservableCollection<ConfiguredMonitoredPropertyType> ConfiguredMonitoredPropertyTypes { get; private set; }
        public object SelectedConfiguredMonitoredPropertyType { get; set; }
        public RelayCommand<string> SortCommand { get; private set; }
        public RelayCommand RemoveMonitoredPropertyCommand { get; private set; }

        public Visibility EnvironmentTitleVisibility { get; private set; }

        public ListViewSortedCollectionViewSource TestSites { get; private set; }
        public RelayCommand<string> SortTestSitesCommand { get; private set; }
        public object SelectedTestSite { get; set; }
        public RelayCommand RemoveTestSiteCommand { get; private set; }
        public RelayCommand AddTestSiteCommand { get; private set; }

        public string TestSiteName { get; set; }
        public string TestSiteID { get; set; }
        public string TestSiteAbbr { get; set; }
        public string TestVistaHost { get; set; }
        public string TestVistaPort { get; set; }
        public string TestVixHost { get; set; }
        public string TestVixPort { get; set; }
        public string TestSiteEnvironmentName { get; set; }

        /// <summary>
        /// Initializes a new instance of the ConfigurationViewModel class.
        /// </summary>
        public ConfigurationViewModel()
        {
            this.DialogResult = null;
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
            }
            else
            {
                // Code runs "for real": Connect to service, etc...
            }
            if (VixHealthMonitorConfiguration.IsInitialized())
            {
                VixHealthConfiguration = VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration();
            }
            SaveCommand = new RelayCommand(() => Save());
            CloseCommand = new RelayCommand(() => Close());
            WindowLoadedCommand = new RelayCommand(() => WindowLoaded());
            DefaultSiteServiceCommand = new RelayCommand(() => DefaultSiteService());
            HealthOptions = new ObservableCollection<VixLoadOption>();
            TestSites = new ListViewSortedCollectionViewSource();
            TestSites.Sort("Name");
            SortTestSitesCommand = new RelayCommand<string>(msg => TestSites.Sort(msg));
            if (VixHealthConfiguration != null)
            {
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.custom_tomcatLogs, 
                    VixHealthConfiguration.IsVisaHealthOptionSelected(VisaHealthOption.custom_tomcatLogs)));
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.custom_transactionLog, 
                    VixHealthConfiguration.IsVisaHealthOptionSelected(VisaHealthOption.custom_transactionLog)));
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.custom_vixCache, 
                    VixHealthConfiguration.IsVisaHealthOptionSelected(VisaHealthOption.custom_vixCache)));
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.environment_variables, 
                    VixHealthConfiguration.IsVisaHealthOptionSelected(VisaHealthOption.environment_variables)));
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.jmx, 
                    VixHealthConfiguration.IsVisaHealthOptionSelected(VisaHealthOption.jmx)));
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.monitoredError,
                    VixHealthConfiguration.IsVisaHealthOptionSelected(VisaHealthOption.monitoredError)));
                EnvironmentTitleVisibility = Visibility.Visible;
            }
            else
            {
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.custom_tomcatLogs, true));
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.custom_transactionLog, true));
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.custom_vixCache, false));
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.environment_variables, true));
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.jmx, true));
                HealthOptions.Add(new VixLoadOption(VisaHealthOption.monitoredError, false));
                EnvironmentTitleVisibility = Visibility.Collapsed;
            }
            SelectedMonitoredProperty = null;
            NewMonitoredPropertyValue = null;
            SelectedTestSite = null;
            MonitoredProperties = new ListViewSortedCollectionViewSource();            
            MonitoredProperties.Sort("Name");
            SortCommand = new RelayCommand<string>(msg => MonitoredProperties.Sort(msg));

            SetMonitoredProperties();
            RemoveMonitoredPropertyCommand = new RelayCommand(() => RemoveMonitoredProperty());

            AddMonitoredPropertyCommand = new RelayCommand(() => AddMonitoredProperty());
            ConfiguredMonitoredPropertyTypes = new ObservableCollection<ConfiguredMonitoredPropertyType>();
            ConfiguredMonitoredPropertyTypes.Add(ConfiguredMonitoredPropertyType.property);
            ConfiguredMonitoredPropertyTypes.Add(ConfiguredMonitoredPropertyType.value);

            SelectedConfiguredMonitoredPropertyType = ConfiguredMonitoredPropertyType.value;

            AddTestSiteCommand = new RelayCommand(() => AddTestSite());
            RemoveTestSiteCommand = new RelayCommand(() => RemoveTestSite());
            SetTestSites();
        }

        private void AddTestSite()
        {
            int vistaPort = int.Parse(TestVistaPort);
            int vixPort = int.Parse(TestVixPort);
            TestSiteID += "." + TestSiteEnvironmentName;
            TestSiteName = TestSiteEnvironmentName + "-" + TestSiteName;

            VaSite site = new VaSite(TestSiteName, TestSiteID, TestSiteAbbr, "", TestVistaHost, vistaPort, TestVixHost, vixPort);
            VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().TestSites.Add(site);
            SetTestSites();
            TestSiteAbbr = "";
            TestSiteID = "";
            TestSiteName = "";
            TestVistaHost = "";
            TestVistaPort = "";
            TestVixHost = "";
            TestVixPort = "";
            TestSiteEnvironmentName = "";
        }

        private void RemoveTestSite()
        {
            if (SelectedTestSite != null)
            {
                VaSite selectedSite = (VaSite)SelectedTestSite;
                VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().TestSites.Remove(selectedSite);
                SetTestSites();
            }
        }

        private void RemoveMonitoredProperty()
        {
            if (SelectedMonitoredProperty != null)
            {
                ConfiguredMonitoredProperty monitoredProperty = (ConfiguredMonitoredProperty)SelectedMonitoredProperty;
                if (MonitoredPropertyManager.IsInitialized)
                {
                    MonitoredPropertyManager.Manager.MonitoredProperties.Remove(monitoredProperty);
                    SetMonitoredProperties();
                }
            }
        }

        private void AddMonitoredProperty()
        {
            if (NewMonitoredPropertyValue != null && SelectedConfiguredMonitoredPropertyType != null)
            {
                ConfiguredMonitoredPropertyType configuredMonitoredPropertyType = (ConfiguredMonitoredPropertyType)SelectedConfiguredMonitoredPropertyType;
                if (MonitoredPropertyManager.IsInitialized)
                {
                    MonitoredPropertyManager.Manager.MonitoredProperties.Add(
                        new ConfiguredMonitoredProperty(NewMonitoredPropertyValue, configuredMonitoredPropertyType));
                    SetMonitoredProperties();
                }
            }
        }

        private void SetMonitoredProperties()
        {
            if (MonitoredPropertyManager.IsInitialized)
            {
                MonitoredProperties.SetSource(
                    new ObservableCollection<ConfiguredMonitoredProperty>(
                        MonitoredPropertyManager.Manager.MonitoredProperties));
            }
        }

        private void SetTestSites()
        {
            if (VixHealthMonitorConfiguration.IsInitialized())
            {
                TestSites.SetSource(VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().TestSites);
            }
        }

        private void WindowLoaded()
        {
            // necessary to reset this value each time the Window is loaded so that the value will change when Save or Close is clicked. The ViewModel is static so it persists after
            // the form is closed so the previous DialogResult value persists as well - it needs to be changed here so it can change later
            this.DialogResult = null;
        }

        private void DefaultSiteService()
        {
            if (VixHealthMonitorConfiguration.IsInitialized())
            {
                VixHealthConfiguration.SiteServiceUrl = VixHealthMonitorConfiguration.DefaultSiteServiceUrl;
            }
        }

        private void Save()
        {
            if (VixHealthMonitorConfiguration.IsInitialized())
            {
                VixHealthConfiguration.HealthLoadOptions.Clear();
                foreach (VixLoadOption vlo in HealthOptions)
                {
                    if (vlo.Selected)
                    {
                        VixHealthConfiguration.HealthLoadOptions.Add(vlo.VisaHealthOption);
                    }
                }
                VixHealthMonitorConfiguration.Save();
            }
            this.DialogResult = true;
            RaisePropertyChanged("DialogResult");
            if (MonitoredPropertyManager.IsInitialized)
            {
                MonitoredPropertyManager.Manager.Save();
            }
        }

        private void Close()
        {
            this.DialogResult = true;
            RaisePropertyChanged("DialogResult");
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }

    public class VixLoadOption
    {
        public VisaHealthOption VisaHealthOption { get; private set; }
        public bool Selected { get; set; }

        public VixLoadOption(VisaHealthOption option, bool selected)
        {
            this.VisaHealthOption = option;
            this.Selected = selected;
        }

    }
}