using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VISACommon;
using System;
using System.Text;
using System.Windows.Input;
using VISAHealthMonitorCommon;
using System.Windows;
using System.Collections.ObjectModel;
using System.Windows.Data;
using System.ComponentModel;
using GalaSoft.MvvmLight.Command;
using System.Diagnostics;
using VixHealthMonitor.messages;
using VISAHealthMonitorCommon.jmx;
using VISAHealthMonitorCommonControls;
using VixHealthMonitorCommon;
using VISAHealthMonitorCommon.monitorederror;
using VixHealthMonitorCommon.monitoredproperty;
using System.Collections.Generic;
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
    public class VixDetailsViewModel : VISADetailsViewModel
    {
        public string SiteName { get; set; }
        private VisaSource visaSource = null;

        public BaseVixHealth BaseVixHealth { get; private set; }
        public ExpanderVisibility CvixVisibility { get; private set; }
        public ExpanderVisibility VixVisibility { get; private set; }

        //public ObservableCollection<ThreadProcessingTime> ThreadProcessingTimes { get; private set; }
        public ListViewSortedCollectionViewSource ThreadProcessingTimes { get; private set; }
        public ListViewSortedCollectionViewSource ServletRequests { get; private set; }
        public ListViewSortedCollectionViewSource RawData { get; private set; }
        public ListViewSortedCollectionViewSource GlobalRequestProcessors { get; private set; }
        public ListViewSortedCollectionViewSource ROIStatistics { get; private set; }
        public ListViewSortedCollectionViewSource MonitoredErrors { get; private set; }
        public ListViewSortedCollectionViewSource MonitoredProperties { get; private set; }

        public RelayCommand<string> SortServletRequestsCommand { get; private set; }
        public RelayCommand<string> SortThreadProcessingTimesCommand { get; private set; }
        public RelayCommand<string> SortRawDataCommand { get; private set; }
        public RelayCommand<string> SortGlobalRequestProcessorsCommand { get; private set; }
        public RelayCommand<string> SortROIStatisticsCommand { get; private set; }
        public RelayCommand<string> SortMonitoredErrorsCommand { get; private set; }
        public RelayCommand<string> SortMonitoredPropertiesCommand { get; private set; }

        public Visibility RealmVistaServerErrorIconVisibility { get; private set; }
        public Visibility RealmVistaPortErrorIconVisibility { get; private set; }

        public Visibility LongRunningThreadsErrorIconVisibility { get; private set; }
        public string LongRunningThreadsErrorMessage { get; private set; }

        public Visibility CacheAvailableErrorIconVisibility { get; private set; }
        public string CacheAvailableErrorMessage { get; private set; }

        public bool SiteServiceExpanded { get; private set; }
        public bool SystemInformationExpanded { get; private set; }

        public string FailedIcon { get; private set; }

        public RelayCommand ViewTransactionCommand { get; private set; }
        public RelayCommand ViewCVIXTransactionCommand { get; private set; }
        public int ViewCVIXTransactionButtonWidth { get; private set; }
        public RelayCommand AddWatchCommand { get; private set; }
        public string ViewTransactionID { get; set; }
        public RelayCommand ViewThreadsCommand { get; set; }
        public bool ViewThreadsEnabled { get; set; }

        public object ThreadProcessingTimeSelectedItem { get; set; }
        public RelayCommand ThreadProcessingTimeMouseDoubleClickCommand { get; set; }
        public event ShowThreadDetailsDialogDelegate OnShowThreadDetailsDialog;

        public ExpanderVisibility ROIVisibility { get; private set; }
        public Visibility ROIErrorIconVisibility { get; private set; }
        public string ROIErrorMessage { get; private set; }

        /// <summary>
        /// Initializes a new instance of the VixDetailsViewModel class.
        /// </summary>
        public VixDetailsViewModel()
        {
            if (IsInDesignMode)
            {

                // Code runs in Blend --> create design time data.
                ROIVisibility = new ExpanderVisibility(true);
            }
            else
            {
                Messenger.Default.Register<UpdateAndDisplayVisaHealthMessage>(this, action => ReceiveUpdateAndDisplayVisaHealthMessage(action));
                Messenger.Default.Register<DisplayVisaHealthMessage>(this, action => ReceieveDisplayVisaSourceMessage(action));
                ROIVisibility = new ExpanderVisibility(false);
                // Code runs "for real"
            }
            ServletRequests = new ListViewSortedCollectionViewSource();
            ServletRequests.Sort("ServletName"); // default sort to servlet name
            ThreadProcessingTimes = new ListViewSortedCollectionViewSource();
            RawData = new ListViewSortedCollectionViewSource();
            ThreadProcessingTimes.ListSortDirection = ListSortDirection.Descending;
            ThreadProcessingTimes.Sort("ProcessingTime");            
            CvixVisibility = new ExpanderVisibility(false);
            VixVisibility = new ExpanderVisibility(true);
            
            SortServletRequestsCommand = new RelayCommand<string>(val => ServletRequests.Sort(val));// SortServletRequests(val));
            SortThreadProcessingTimesCommand = new RelayCommand<string>(val => ThreadProcessingTimes.Sort(val));
            SortRawDataCommand = new RelayCommand<string>(val => RawData.Sort(val));
            RealmVistaPortErrorIconVisibility = Visibility.Hidden;
            RealmVistaServerErrorIconVisibility = Visibility.Hidden;
            LongRunningThreadsErrorIconVisibility = Visibility.Hidden;
            SiteServiceExpanded = true;
            LongRunningThreadsErrorMessage = "";
            CacheAvailableErrorIconVisibility = Visibility.Hidden;
            CacheAvailableErrorMessage = "";
            FailedIcon = Icons.failed;
            RefreshHealthCommand = new RelayCommand(() => UpdateVisaHealth());            
            SystemInformationExpanded = true;

            GlobalRequestProcessors = new ListViewSortedCollectionViewSource();
            GlobalRequestProcessors.Sort("TotalBytes");
            SortGlobalRequestProcessorsCommand = new RelayCommand<string>(val => GlobalRequestProcessors.Sort(val));
            ViewTransactionCommand = new RelayCommand(() => ViewTransaction());
            ViewCVIXTransactionCommand = new RelayCommand(() => ViewCVIXTransaction());
            ViewTransactionID = "";
            AddWatchCommand = new RelayCommand(() => AddWatch());
            ThreadProcessingTimeMouseDoubleClickCommand = new RelayCommand(() => ThreadProcessingTimeMouseDoubleClick());
            ViewThreadsCommand = new RelayCommand(() => ViewThreads());
            ViewThreadsEnabled = false;

            ROIStatistics = new ListViewSortedCollectionViewSource();
            ROIStatistics.Sort("Name");
            SortROIStatisticsCommand = new RelayCommand<string>(val => ROIStatistics.Sort(val));

            MonitoredErrors = new ListViewSortedCollectionViewSource();
            MonitoredErrors.Sort("ErrorContains");
            SortMonitoredErrorsCommand = new RelayCommand<string>(val => MonitoredErrors.Sort(val));

            MonitoredProperties = new ListViewSortedCollectionViewSource();
            MonitoredProperties.Sort("Name");
            SortMonitoredPropertiesCommand = new RelayCommand<string>(val => MonitoredProperties.Sort(val));

            ROIErrorIconVisibility = Visibility.Collapsed;
            ROIErrorMessage = "";
        }

        private void ViewThreads()
        {
            Threads threadsViewer = new Threads(this.visaSource);
            threadsViewer.Show();
        }

        private void ThreadProcessingTimeMouseDoubleClick()
        {
            if (ThreadProcessingTimeSelectedItem != null)
            {
                ThreadProcessingTime threadProcessingTime = (ThreadProcessingTime)ThreadProcessingTimeSelectedItem;
                if (OnShowThreadDetailsDialog != null)
                {
                    OnShowThreadDetailsDialog(visaSource, BaseVixHealth.VisaHealth, threadProcessingTime);
                }
            }
        }

        private void ViewCVIXTransaction()
        {
            List<string> urls = new List<string>();
            foreach (VaSite site in VixSourceHolder.getSingleton().VisaSources)
            {
                if (site.IsCvix)
                {
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    urls.Add(CreateViewTransactionUrl(site, ViewTransactionID));
                }
            }
            foreach (string url in urls)
            {
                LaunchUrl(url);
            }
        }

        private string CreateViewTransactionUrl(VisaSource visaSource, string transactionId)
        {
            string serverAndPort = visaSource.VisaHost + ":" + visaSource.VisaPort;
            return "http://" + serverAndPort + "/Vix/secure/VixLogViewTransaction.jsp?transactionId=" + transactionId;
        }

        private void ViewTransaction()
        {
            //http://vhadurclu3a.v06.med.va.gov:8080/Vix/secure/VixLogViewTransaction.jsp?transactionId={BC006D22-20FC-4665-9FD9-9875C8C7D057}
            //string serverAndPort = BaseVixHealth.VisaHealth.VisaSource.VisaHost + ":" + BaseVixHealth.VisaHealth.VisaSource.VisaPort;
            //string url = "http://" + serverAndPort + "/Vix/secure/VixLogViewTransaction.jsp?transactionId=" + ViewTransactionID;
            //LaunchUrl(url);
            LaunchUrl(CreateViewTransactionUrl(BaseVixHealth.VisaHealth.VisaSource, ViewTransactionID));
        }

        private void LaunchUrl(string url)
        {
            Process proc = new Process();
            proc.StartInfo.FileName = url;
            proc.Start();
        }

        private void AddWatch()
        {
            Messenger.Default.Send<ChangeWatchedSiteMessage>(new ChangeWatchedSiteMessage(true, visaSource));
        }

        protected override void UpdateVisaHealth()
        {
            VisaHealth health = VisaHealthManager.GetVisaHealth(visaSource);
            Messenger.Default.Send<CursorChangeMessage>(new CursorChangeMessage(Cursors.Wait));
            if (VixHealthMonitorConfiguration.IsInitialized())
            {
                VixHealthMonitorConfiguration config = VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration();
                health.Update(config.GetHealthLoadOptionsArray(), config.HealthRequestTimeout);
            }
            else
            {
                health.Update(null, VixHealthMonitorConfiguration.defaultHealthTimeout);
            }
            DisplayHealth();
            Messenger.Default.Send<CursorChangeMessage>(new CursorChangeMessage(Cursors.Arrow));
        }

        public void ReceiveUpdateAndDisplayVisaHealthMessage(UpdateAndDisplayVisaHealthMessage msg)
        {
            visaSource = msg.VisaSource;
            UpdateVisaHealth();
            // done by the update
            //DisplayHealth();            
        }

        public void ReceieveDisplayVisaSourceMessage(DisplayVisaHealthMessage msg)
        {
            visaSource = msg.VisaSource;
            DisplayHealth();
        }

        /// <summary>
        /// This gets called when the health is updated, update properties of this view model based on the health information
        /// </summary>
        private void DisplayHealth()
        {
            VaSite vaSite = (VaSite)visaSource;
            SiteName = vaSite.Name;
            VisaHealth health = VisaHealthManager.GetVisaHealth(visaSource);
            //ServletRequests = new ObservableCollection<ServletRequests>();
            //ServletRequests = new CollectionViewSource();
            ObservableCollection<ServletRequests> servletRequests = new ObservableCollection<VixHealthMonitor.ServletRequests>();
            ObservableCollection<ThreadProcessingTime> threadProcessingTimes = new ObservableCollection<ThreadProcessingTime>();
            ObservableCollection<VixHealthProperty> healthProperties = new ObservableCollection<VixHealthProperty>();            

            if (vaSite.IsVix)
            {
                BaseVixHealth = new VixHealth(health, false);
                CvixVisibility = new ExpanderVisibility(false);
                VixVisibility = new ExpanderVisibility(true);
                ViewCVIXTransactionButtonWidth = 0;
            }
            else
            {
                BaseVixHealth = new CvixHealth(health, false);
                CvixVisibility = new ExpanderVisibility(true);
                VixVisibility = new ExpanderVisibility(false);
                ViewCVIXTransactionButtonWidth = 80;
            }

            if (BaseVixHealth.VisaHealth.LoadStatus == VixHealthLoadStatus.loaded)
            {
                // update servlet request counts
                servletRequests.Add(new ServletRequests("Federation Metadata", "Federation Metadata Requests (From other VIX servers)",
                    BaseVixHealth.GetFederationMetadataRequestCount()));
                servletRequests.Add(new ServletRequests("Federation Image", "Federation Image Requests (From other VIX servers for Clinical Display)",
                    BaseVixHealth.GetFederationImageServletRequestCount()));
                servletRequests.Add(new ServletRequests("Federation Exam Image", "Federation Exam Image Requests (From other VIX servers for VistARad)",
                    BaseVixHealth.GetFederationExamImageServletRequestCount()));
                servletRequests.Add(new ServletRequests("Federation Exam Image Text", "Federation Exam Image Text File Requests (From other VIX servers for VistARad)",
                    BaseVixHealth.GetFederationExamImageTextServletRequestCount()));
                servletRequests.Add(new ServletRequests("Federation Metadata V4,V5", "Federation Metadata V4, V5 Requests (From other P104+ VIX servers)",
                    BaseVixHealth.GetFederationMetadataV4RequestCount()));
                servletRequests.Add(new ServletRequests("Federation Image V4", "Federation Image V4 Requests (From other P104 VIX servers)",
                        BaseVixHealth.GetFederationImageServletV4RequestCount()));
                servletRequests.Add(new ServletRequests("Federation Image V5", "Federation Image V5 Requests (From other P122/P118 VIX servers)",
                        BaseVixHealth.GetFederationImageServletV5RequestCount()));
                servletRequests.Add(new ServletRequests("Federation Exam Image V4", "Federation Exam Image Requests (From other P104 VIX servers for VistARad)",
                    BaseVixHealth.GetFederationExamImageServletV4RequestCount()));
                servletRequests.Add(new ServletRequests("Federation Exam Image V5", "Federation Exam Image Requests (From other P122/P118 VIX servers for VistARad)",
                    BaseVixHealth.GetFederationExamImageServletV5RequestCount()));
                servletRequests.Add(new ServletRequests("Federation Exam Image Text V4", "Federation Exam Image Text File Requests (From other P104 VIX servers for VistARad)",
                    BaseVixHealth.GetFederationExamImageTextServletV4RequestCount()));
                servletRequests.Add(new ServletRequests("Federation Exam Image Text V5", "Federation Exam Image Text File Requests (From other P122/P118 VIX servers for VistARad)",
                    BaseVixHealth.GetFederationExamImageTextServletV5RequestCount()));
                servletRequests.Add(new ServletRequests("Federation Document V4", "Federation Document Requests (From other P104 VIX servers for Documents)",
                    BaseVixHealth.GetFederationDocumentServletV4RequestCount()));
                servletRequests.Add(new ServletRequests("Federation Document V5", "Federation Document Requests (From other P122/P118 VIX servers for Documents)",
                    BaseVixHealth.GetFederationDocumentServletV5RequestCount()));


                servletRequests.Add(new ServletRequests("Exchange Metadata", "Exchange Metadata Requests (From the DoD)",
                        BaseVixHealth.GetExchangeMetadataRequestCount()));
                servletRequests.Add(new ServletRequests("Exchange Image", "Exchange Image Requests (From the DoD)",
                    BaseVixHealth.GetExchangeImageServletRequestCount()));


                // sadly cannot do this above
                if (vaSite.IsVix)
                {
                    servletRequests.Add(new ServletRequests("Clinical Display Metadata", "Clinical Display Metadata Requests",
                        BaseVixHealth.GetClinicalDisplayMetadataRequestCount()));
                    servletRequests.Add(new ServletRequests("Clinical Display Image V2", "Clinical Display Image V2 Requests (Patch 72)",
                        BaseVixHealth.GetClinicalDisplayImageServletRequestCount()));
                    servletRequests.Add(new ServletRequests("Clinical Display Image V4", "Clinical Display Image V4 Requests (Patch 93)",
                        BaseVixHealth.GetClinicalDisplayImageServletV4RequestCount()));
                    servletRequests.Add(new ServletRequests("Clinical Display Image V5", "Clinical Display Image V5 Requests (Patch 94)",
                        BaseVixHealth.GetClinicalDisplayImageServletV5RequestCount()));
                    servletRequests.Add(new ServletRequests("Clinical Display Image V6", "Clinical Display Image V6 Requests (Patch 117)",
                        BaseVixHealth.GetClinicalDisplayImageServletV6RequestCount()));
                    servletRequests.Add(new ServletRequests("Clinical Display Image V7", "Clinical Display Image V7 Requests (Patch 122)",
                        BaseVixHealth.GetClinicalDisplayImageServletV7RequestCount()));

                    servletRequests.Add(new ServletRequests("VistARad Metadata", "VistARad Metadata Requests",
                        BaseVixHealth.GetVistaRadMetadataRequestCount()));
                    servletRequests.Add(new ServletRequests("VistARad Exam Image", "VistARad Exam Image Requests",
                        BaseVixHealth.GetVistaRadExamImageServletRequestCount()));
                    servletRequests.Add(new ServletRequests("VistARad Exam Image Text", "VistARad Exam Image Text File Requests",
                        BaseVixHealth.GetVistaRadExamImageTextFileServletRequestCount()));
                }
                else
                {
                    // CVIX
                    servletRequests.Add(new ServletRequests("AWIV Metadata", "AWIV Metadata Requests (Patch 105/124)", BaseVixHealth.GetAWIVMetadataRequestCount()));
                    servletRequests.Add(new ServletRequests("AWIV Image", "AWIV Image Requests (Patch 105)", BaseVixHealth.GetAWIVImageRequestCount()));
                    servletRequests.Add(new ServletRequests("AWIV Image V2", "AWIV Image V2 Requests (Patch 124)", BaseVixHealth.GetAWIVImageV2RequestCount()));
                    servletRequests.Add(new ServletRequests("AWIV Photo ID", "AWIV Photo ID Requests (Patch 105)", BaseVixHealth.GetAWIVPhotoIDRequestCount()));
                    servletRequests.Add(new ServletRequests("AWIV Photo ID V2", "AWIV Photo ID V2 Requests (Patch 124)", BaseVixHealth.GetAWIVPhotoIDV2RequestCount()));

                    servletRequests.Add(new ServletRequests("XCA", "XCA Query and Retrieve Requests", BaseVixHealth.GetXCARequestCount()));
                    servletRequests.Add(new ServletRequests("Exchange Image V2", "Exchange Image V2 Requests (From the DoD)",
                        BaseVixHealth.GetExchangeImageServletV2RequestCount()));
                }

                ServletRequests.SetSource(servletRequests);

                foreach (ThreadProcessingTime tpt in BaseVixHealth.GetThreadProcessingTimes())
                {
                    threadProcessingTimes.Add(tpt);
                }
                ThreadProcessingTimes.SetSource(threadProcessingTimes);


                foreach (string key in BaseVixHealth.VisaHealth.ServerProperties.Keys)
                {
                    healthProperties.Add(new VixHealthProperty(key, BaseVixHealth.VisaHealth.ServerProperties[key]));
                }
                RawData.SetSource(healthProperties);

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

                SiteServiceExpanded = IsPatch104Installed();
                SystemInformationExpanded = IsPatch104Installed();

                if (BaseVixHealth.IsCacheDriveBelowCriticalLimit())
                {
                    CacheAvailableErrorIconVisibility = Visibility.Hidden;
                    CacheAvailableErrorMessage = "";
                }
                else
                {
                    CacheAvailableErrorIconVisibility = Visibility.Visible;
                    CacheAvailableErrorMessage = "VIX Cache is close to running out of space";
                }
                ObservableCollection<GlobalRequestProcessor> globalRequestProcessors = 
                    new ObservableCollection<GlobalRequestProcessor>(BaseVixHealth.GetGlobalRequestProcessors());
                GlobalRequestProcessors.SetSource(globalRequestProcessors);
                ViewThreadsEnabled = JmxUtility.IsJmxSupported(BaseVixHealth.VisaHealth);

                if (vaSite.IsVix)
                {
                    // ROI only exists on the VIX, not the CVIX
                    ROIStatistics.SetSource(new ObservableCollection<GenericCount>(BaseVixHealth.GetRoiStatistics()));
                    ROIVisibility = new ExpanderVisibility(BaseVixHealth.IsROISupported());

                    if (BaseVixHealth.IsROISupportedAndDisabled())
                    {
                        ROIErrorMessage = "No ROI processing will ever occur, periodic or immediate processing must be enabled";
                        ROIErrorIconVisibility = Visibility.Visible;
                    }
                    else
                    {
                        ROIErrorMessage = "";
                        ROIErrorIconVisibility = Visibility.Collapsed;
                    }
                }
                else
                {
                    ROIVisibility = new ExpanderVisibility(false);
                    ROIErrorIconVisibility = Visibility.Collapsed;
                    ROIErrorMessage = "";
                }
                MonitoredErrors.SetSource(new ObservableCollection<MonitoredError>(BaseVixHealth.GetMonitoredErrors()));

                //MonitoredPropertyHolder

                List<MonitoredProperty> monitoredProperties = MonitoredPropertyManager.Manager.GetSiteMonitoredProperties(visaSource);
                List<MonitoredPropertyHolder> monitorPropertiesHolder = new List<MonitoredPropertyHolder>(monitoredProperties.Count);
                foreach (MonitoredProperty monitoredProperty in monitoredProperties)
                {
                    foreach (MonitoredPropertyHistory history in monitoredProperty.MonitoredPropertyHistory.Values)
                    {
                        monitorPropertiesHolder.Add(
                            new MonitoredPropertyHolder(monitoredProperty.Name, history.Value, new FormattedDate(history.DateUpdated.ToUniversalTime().Ticks, false)));
                    }
                }

                MonitoredProperties.SetSource(new ObservableCollection<MonitoredPropertyHolder>(monitorPropertiesHolder));

            }
            else
            {
                //ServletRequests.Source = null;
                ServletRequests.ClearSource();
                ThreadProcessingTimes.ClearSource();
                GlobalRequestProcessors.ClearSource();
                RawData.ClearSource();
                ROIStatistics.ClearSource();
                MonitoredErrors.ClearSource();
                MonitoredProperties.ClearSource();
                RealmVistaServerErrorIconVisibility = Visibility.Hidden;
                RealmVistaPortErrorIconVisibility = Visibility.Hidden;
                LongRunningThreadsErrorIconVisibility = Visibility.Hidden;
                LongRunningThreadsErrorMessage = "";
                CacheAvailableErrorIconVisibility = Visibility.Hidden;
                CacheAvailableErrorMessage = "";
                SystemInformationExpanded = true;
                SiteServiceExpanded = true;
                ViewThreadsEnabled = false;
                ROIVisibility = new ExpanderVisibility(false);
                ROIErrorIconVisibility = Visibility.Collapsed;
                ROIErrorMessage = "";
            }
        }

        private string[] nonPatch104Versinos = new String[] { "30.83", "30.105" };

        private bool IsPatch104Installed()
        {
            string version = BaseVixHealth.VisaHealth.VisaVersion;
            foreach (string nonP104Ver in nonPatch104Versinos)
            {
                if (version.StartsWith(nonP104Ver))
                    return false;
            }
            return true;
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }

    public class MonitoredPropertyHolder
    {
        public string Name { get; private set; }
        public string Value { get; private set; }
        public FormattedDate DateUpdated { get; private set; }

        public MonitoredPropertyHolder(string name, string value, FormattedDate dateUpdated)
        {
            this.Name = name;
            this.Value = value;
            this.DateUpdated = dateUpdated;
        }
    }
}