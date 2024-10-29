/*
  In App.xaml:
  <Application.Resources>
      <vm:ViewModelLocatorTemplate xmlns:vm="clr-namespace:VixHealthMonitor.ViewModel"
                                   x:Key="Locator" />
  </Application.Resources>
  
  In the View:
  DataContext="{Binding Source={StaticResource Locator}, Path=ViewModelName}"
  
  OR (WPF only):
  
  xmlns:vm="clr-namespace:VixHealthMonitor.ViewModel"
  DataContext="{Binding Source={x:Static vm:ViewModelLocatorTemplate.ViewModelNameStatic}}"
*/

namespace VixHealthMonitor.ViewModel
{
    /// <summary>
    /// This class contains static references to all the view models in the
    /// application and provides an entry point for the bindings.
    /// <para>
    /// Use the <strong>mvvmlocatorproperty</strong> snippet to add ViewModels
    /// to this locator.
    /// </para>
    /// <para>
    /// In Silverlight and WPF, place the ViewModelLocatorTemplate in the App.xaml resources:
    /// </para>
    /// <code>
    /// &lt;Application.Resources&gt;
    ///     &lt;vm:ViewModelLocatorTemplate xmlns:vm="clr-namespace:VixHealthMonitor.ViewModel"
    ///                                  x:Key="Locator" /&gt;
    /// &lt;/Application.Resources&gt;
    /// </code>
    /// <para>
    /// Then use:
    /// </para>
    /// <code>
    /// DataContext="{Binding Source={StaticResource Locator}, Path=ViewModelName}"
    /// </code>
    /// <para>
    /// You can also use Blend to do all this with the tool's support.
    /// </para>
    /// <para>
    /// See http://www.galasoft.ch/mvvm/getstarted
    /// </para>
    /// <para>
    /// In <strong>*WPF only*</strong> (and if databinding in Blend is not relevant), you can delete
    /// the Main property and bind to the ViewModelNameStatic property instead:
    /// </para>
    /// <code>
    /// xmlns:vm="clr-namespace:VixHealthMonitor.ViewModel"
    /// DataContext="{Binding Source={x:Static vm:ViewModelLocatorTemplate.ViewModelNameStatic}}"
    /// </code>
    /// </summary>
    public class ViewModelLocator : VISAHealthMonitorCommonControls.ViewModel.ViewModelLocator
    {
        private static CvixListViewModel _cvixList;
        private VixListViewModel _vixList;
        private static VixCountsViewModel _vixCounts;
        private static VixDetailsViewModel _vixDetails;        
        private static MainViewModel _main;
        private static VixTreeViewModel _vixTree;
        private static ConfigurationViewModel _configuration;
        private static VixTestInformationViewModel _vixTestInformation;
        private static WatchSiteContainerViewModel _watchSiteContainer;
        private static VixSitesListViewModel _vixSitesList;
        private static SiteUtilitiesViewModel _siteUtilities;
        private static DailyMonitoredPropertiesViewModel _dailyMonitoredProperties;
        private static LongRunningThreadsViewModel _longRunningThreads;
         
        /// <summary>
        /// Initializes a new instance of the ViewModelLocator class.
        /// </summary>
        public ViewModelLocator()
        {
            ////if (ViewModelBase.IsInDesignModeStatic)
            ////{
            ////    // Create design time view models
            ////}
            ////else
            ////{
            ////    // Create run time view models
            ////}

            CreateMain();
            CreateCvixList();
            CreateVixListViewModel();
            CreateVixCountsViewModel();
            CreateVixDetailsViewModel();
            CreateVixTreeViewModel();
            CreateConfigurationViewModel();
            CreateVixTestInformationViewModel();
            CreateWatchSiteContainer();
            CreateVixSitesList();
            CreateSiteUtilitiesViewModel();
            CreateDailyMonitoredPropertiesViewModel();
            CreateLongRunningThreadsViewModel();
        }

        /// <summary>
        /// Gets the Main property.
        /// </summary>
        public static MainViewModel MainStatic
        {
            get
            {
                if (_main == null)
                {
                    CreateMain();
                }

                return _main;
            }
        }

        /// <summary>
        /// Gets the Main property.
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public MainViewModel Main
        {
            get
            {
                return MainStatic;
            }
        }

        /// <summary>
        /// Provides a deterministic way to delete the Main property.
        /// </summary>
        public static void ClearMain()
        {
            if (_main != null)
            {
                _main.Cleanup();
                _main = null;
            }
        }

        /// <summary>
        /// Provides a deterministic way to create the Main property.
        /// </summary>
        public static void CreateMain()
        {
            if (_main == null)
            {
                _main = new MainViewModel();
            }
        }

        public static VixSitesListViewModel VixSitesListStatic
        {
            get
            {
                if (_vixSitesList == null)
                {
                    CreateVixSitesList();
                }

                return _vixSitesList;
            }
        }

        public static CvixListViewModel CvixListStatic
        {
            get
            {
                if (_cvixList == null)
                {
                    CreateCvixList();
                }

                return _cvixList;
            }
        }

        public VixListViewModel VixListStatic
        {
            get
            {
                if (_vixList == null)
                {
                    CreateVixListViewModel();
                }
                return _vixList;
            }
        }

        public static VixCountsViewModel VixCountsStatic
        {
            get
            {
                if (_vixCounts == null)
                {
                    CreateVixCountsViewModel();
                }
                return _vixCounts;
            }
        }

        public static VixDetailsViewModel VixDetailsStatic
        {
            get
            {
                if (_vixDetails == null)
                {
                    CreateVixDetailsViewModel();
                }
                return _vixDetails;
            }
        }

        public static VixTreeViewModel VixTreeStatic
        {
            get
            {
                if (_vixTree == null)
                {
                    CreateVixTreeViewModel();
                }
                return _vixTree;
            }
        }

        public static ConfigurationViewModel ConfigurationStatic
        {
            get
            {
                if (_configuration == null)
                {
                    CreateConfigurationViewModel();
                }
                return _configuration;
            }
        }

        public static VixTestInformationViewModel VixTestInformationStatic
        {
            get
            {
                if (_vixTestInformation == null)
                {
                    CreateVixTestInformationViewModel();
                }
                return _vixTestInformation;
            }
        }

        public static WatchSiteContainerViewModel WatchSiteContainerStatic
        {
            get
            {
                if (_watchSiteContainer == null)
                {
                    CreateWatchSiteContainer();
                }
                return _watchSiteContainer;
            }
        }

        public static SiteUtilitiesViewModel SiteUtilitiesStatic
        {
            get
            {
                if (_siteUtilities == null)
                {
                    CreateSiteUtilitiesViewModel();
                }
                return _siteUtilities;
            }
        }

        public static DailyMonitoredPropertiesViewModel DailyMonitoredPropertiesStatic
        {
            get
            {
                if (_dailyMonitoredProperties == null)
                {
                    CreateDailyMonitoredPropertiesViewModel();
                }
                return _dailyMonitoredProperties;
            }
        }

        public static LongRunningThreadsViewModel LongRunningThreadsStatic
        {
            get
            {
                if (_longRunningThreads == null)
                {
                    CreateLongRunningThreadsViewModel();
                }
                return _longRunningThreads;
            }
        }

        /// <summary>
        /// Gets the Main property.
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public VixSitesListViewModel VixSitesList
        {
            get
            {
                return VixSitesListStatic;
            }
        }

        /// <summary>
        /// Gets the Main property.
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public CvixListViewModel CvixList
        {
            get
            {
                return CvixListStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public VixListViewModel VixList
        {
            get
            {
                return VixListStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public VixCountsViewModel VixCounts
        {
            get
            {
                return VixCountsStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public VixDetailsViewModel VixDetails
        {
            get
            {
                return VixDetailsStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public VixTreeViewModel VixTree
        {
            get
            {
                return VixTreeStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public ConfigurationViewModel Configuration
        {
            get
            {
                return ConfigurationStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public VixTestInformationViewModel VixTestInformation
        {
            get
            {
                return VixTestInformationStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public WatchSiteContainerViewModel WatchSiteContainer
        {
            get
            {
                return WatchSiteContainerStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public SiteUtilitiesViewModel SiteUtilities
        {
            get
            {
                return SiteUtilitiesStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public DailyMonitoredPropertiesViewModel DailyMonitoredProperties
        {
            get
            {
                return DailyMonitoredPropertiesStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public LongRunningThreadsViewModel LongRunningThreads
        {
            get
            {
                return LongRunningThreadsStatic;
            }
        }

        /// <summary>
        /// Provides a deterministic way to delete the Main property.
        /// </summary>
        public static void ClearVixSitesList()
        {
            _vixSitesList.Cleanup();
            _vixSitesList = null;
        }

        /// <summary>
        /// Provides a deterministic way to delete the Main property.
        /// </summary>
        public static void ClearCvixList()
        {
            _cvixList.Cleanup();
            _cvixList = null;
        }

        public void ClearVixListViewModel()
        {
            _vixList.Cleanup();
            _vixList = null;
        }

        public static void ClearVixCountsViewModel()
        {
            _vixCounts.Cleanup();
            _vixCounts = null;
        }

        public static void ClearVixDetailsViewModel()
        {
            _vixDetails.Cleanup();
            _vixDetails = null;
        }

        public static void ClearVixTreeViewModel()
        {
            _vixTree.Cleanup();
            _vixTree = null;
        }

        public static void ClearConfigurationViewModel()
        {
            _configuration.Cleanup();
            _configuration = null;
        }

        public static void ClearVixTestInformationViewModel()
        {
            _vixTestInformation.Cleanup();
            _vixTestInformation = null;
        }

        public static void ClearWatchSiteContainer()
        {
            _watchSiteContainer.Cleanup();
            _watchSiteContainer = null;
        }

        public static void ClearSiteUtilitiesViewModel()
        {
            _siteUtilities.Cleanup();
            _siteUtilities = null;
        }

        public static void ClearDailyMonitoredPropertiesViewModel()
        {
            _dailyMonitoredProperties.Cleanup();
            _dailyMonitoredProperties = null;
        }

        public static void ClearLongRunningThreadsViewModel()
        {
            _longRunningThreads.Cleanup();
            _longRunningThreads = null;
        }

        public static void CreateVixSitesList()
        {
            if (_vixSitesList == null)
            {
                _vixSitesList = new VixSitesListViewModel();
            }
        }

        /// <summary>
        /// Provides a deterministic way to create the Main property.
        /// </summary>
        public static void CreateCvixList()
        {
            if (_cvixList == null)
            {
                _cvixList = new CvixListViewModel();
            }
        }

        public void CreateVixListViewModel()
        {
            if (_vixList == null)
            {
                _vixList = new VixListViewModel();
            }
        }

        public static void CreateVixCountsViewModel()
        {
            if (_vixCounts == null)
            {
                _vixCounts = new VixCountsViewModel();
            }
        }

        public static void CreateVixDetailsViewModel()
        {
            if (_vixDetails == null)
            {
                _vixDetails = new VixDetailsViewModel();
            }
        }

        public static void CreateVixTreeViewModel()
        {
            if (_vixTree == null)
            {
                _vixTree = new VixTreeViewModel();
            }
        }

        public static void CreateConfigurationViewModel()
        {
            if (_configuration == null)
            {
                _configuration = new ConfigurationViewModel();
            }
        }

        public static void CreateVixTestInformationViewModel()
        {
            if (_vixTestInformation == null)
            {
                _vixTestInformation = new VixTestInformationViewModel();
            }
        }

        public static void CreateWatchSiteContainer()
        {
            if (_watchSiteContainer == null)
            {
                _watchSiteContainer = new WatchSiteContainerViewModel();
            }
        }

        public static void CreateSiteUtilitiesViewModel()
        {
            if (_siteUtilities == null)
            {
                _siteUtilities = new SiteUtilitiesViewModel();
            }
        }

        public static void CreateDailyMonitoredPropertiesViewModel()
        {
            if (_dailyMonitoredProperties == null)
            {
                _dailyMonitoredProperties = new DailyMonitoredPropertiesViewModel();
            }
        }

        public static void CreateLongRunningThreadsViewModel()
        {
            if (_longRunningThreads == null)
            {
                _longRunningThreads = new LongRunningThreadsViewModel();
            }
        }

        /// <summary>
        /// Cleans up all the resources.
        /// </summary>
        public static void Cleanup() 
        {
            CleanupBaseTypes();
            ClearMain();
            ClearCvixList();
            //ClearVixListViewModel();
            ClearVixCountsViewModel();
            ClearVixDetailsViewModel();
            ClearVixTreeViewModel();
            ClearConfigurationViewModel();
            ClearVixTestInformationViewModel();
            ClearWatchSiteContainer();
            ClearVixSitesList();
            ClearSiteUtilitiesViewModel();
            ClearDailyMonitoredPropertiesViewModel();
            ClearLongRunningThreadsViewModel();
        }
    }
}