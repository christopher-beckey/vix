using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon;
using VISACommon;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VISAHealthMonitorCommon.formattedvalues;
using System.ComponentModel;
using System.Collections.ObjectModel;
using VISAHealthMonitorCommon.monitorederror;

namespace VixHealthMonitorCommon
{
    delegate long GetRequestCount();
    delegate void SetUrlsDelegate();

    public class BaseVixHealth : INotifyPropertyChanged
    {        
        public static string numberFormat = "###,###,###,##0";
        public static string decimalFormat = "###,###,###,###.00";

        public VisaHealth VisaHealth { get; private set; }
        public VaSite VaSite {get; private set;}

        // cache stuff
        public string CacheDirectory { get; private set; }
        public FormattedBytes CacheSize { get; private set; }
        public FormattedBytes CacheDriveCapacity { get; private set; }
        public FormattedBytes CacheDriveAvailableSpace { get; private set; }
        public string CacheDrivePercentFull { get; private set; }
        public FormattedNumber CacheOperationsSuccessful { get; set; }
        public FormattedNumber CacheOperationsInstanceNotFound { get; set; }
        public FormattedNumber CacheOperationsInitiated { get; set; }
        public FormattedNumber CacheOperationsError { get; set; }

        public FormattedBytes JavaLogSizeFormatted { get; private set; }
        public string JavaLogsDirectory { get; private set; }
        public FormattedNumber TransactionsWrittenFormatted { get; private set; }
        public FormattedDecimal TransactionsPerMinuteFormatted { get; private set; }
        public FormattedTime LongestThreadTime { get; private set; }
        public string TransactionLogDirectory { get; private set; }
        public FormattedBytes TransactionLogSize { get; private set; }
        public FormattedNumber TransactionsPurged { get; private set; }
        public FormattedNumber TransactionLogQueries { get; private set; }
        public FormattedNumber TransactionLogWriteErrors { get; private set; }
        public FormattedNumber TransactionLogReadErrors { get; private set; }
        public FormattedNumber TransactionLogErrors { get; private set; }
        public string TransactionLogErrorPercent { get; private set; }

        public FormattedNumber Active80Threads { get; private set; }
        public FormattedNumber Active8080Threads { get; private set; }
        public FormattedNumber Active8443Threads { get; private set; }
        public FormattedNumber Active443Threads { get; private set; }

        public FormattedNumber Http80ThreadPoolMaxThreads { get; private set; }
        public FormattedNumber Http8080ThreadPoolMaxThreads { get; private set; }
        public FormattedNumber Http8443ThreadPoolMaxThreads { get; private set; }
        public FormattedNumber Http443ThreadPoolMaxThreads { get; private set; }
        
        public FormattedNumber LongThreads { get; private set; }
        public string LongThreadIcon { get; private set; }
        
        public string FederationCounts { get; private set; }
        public string RadiologyCount { get; private set; }

        public string HealthIcon { get; private set; }

        public string SiteServiceUrl { get; private set; }
        public string SiteServiceLastUpdated { get; private set; }
        public string SiteServiceSourceVersion { get; private set; }

        public string RealmVistaServer { get; private set; }
        public string RealmVistaPort { get; private set; }

        public ObservableCollection<VixServerUrl> Urls { get; private set; }

        public string CacheSizeIcon { get; private set; }

        public string OperatingSystemName { get; private set; }
        public string OperatingSystemVersion { get; private set; }
        
        public FormattedNumber NumberOfProcesors { get; private set; }
        public FormattedBytes TotalSwapSpace { get; private set; }
        public FormattedBytes FreeSwapSpace { get; private set; }
        public FormattedBytes TotalPhysicalMemory { get; private set; }
        public FormattedBytes FreePhysicalMemory { get; private set; }
        public FormattedBytes CommittedVirtualMemory { get; private set; }
        
        /// <summary>
        /// The number of requests made to get site service information
        /// </summary>
        public FormattedNumber SiteServiceRequests { get; private set; }

        private List<SiteServiceKey> siteServiceKeys = new List<SiteServiceKey>();

        public bool ROIPeriodicProcessingEnabled { get; private set; }
        public bool ROICompletedItemsPurgeEnabled { get; private set; }
        public string ROIPeriodicProcessingError { get; private set; }
        public bool ROIProcessWorkItemsImmediately { get; private set; }

        public FormattedDate CertificateExpirationDate { get; protected set; }
        public string CertificateExpiredIcon { get; protected set; }

        public BaseVixHealth(VisaHealth visaHealth, bool registerReceiveUpdatedHealthMessage)
        {
            VisaHealth = visaHealth;
            if (registerReceiveUpdatedHealthMessage)
            {
                //Messenger.Default.Register<VisaHealthUpdatedMessage>(this, action => ReceiveUpdateMessage(action));
                visaHealth.OnUpdateVisaHealthCompletedEvent += ReceiveOnUpdateVisaHealthCompletedEvent;
            }
            VaSite = (VaSite)visaHealth.VisaSource;            
            Urls = new ObservableCollection<VixServerUrl>();
            string serverAndPort = VisaHealth.VisaSource.VisaHost + ":" + VisaHealth.VisaSource.VisaPort;
            Urls.Add(new VixServerUrl("Transaction Log",
                "http://" + serverAndPort + "/Vix/secure/VixLog.jsp"));
            Urls.Add(new VixServerUrl("Site Service",
                "http://" + serverAndPort + "/VistaWebSvcs/ExchangeSiteService"));
            Urls.Add(new VixServerUrl("Java Logs",
                        "http://" + serverAndPort + "/Vix/secure/JavaLogs.jsp"));
            if (VixHealthMonitorConfiguration.IsInitialized())
            {
                VixHealthMonitorConfiguration configuration = VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration();
                if (configuration.Admin)
                {
                    Urls.Add(new VixServerUrl("Health Monitor",
                        "http://" + serverAndPort + "/VixServerHealthWebApp/secure/SelectVix.jsp"));
                    
                }
            }
            siteServiceKeys.Add(new SiteServiceKey("1", "siteservicewebapp"));
            siteServiceKeys.Add(new SiteServiceKey("2", "VistAWebSvcs"));
            siteServiceKeys.Add(new SiteServiceKey("3", "VistaWebSvcs"));
            siteServiceKeys.Add(new SiteServiceKey("4", "vistawebsvcs"));
            Update();
        }

        public string ViewTransactionLogUrl
        {
            get
            {
                return "http://" + VisaHealth.VisaSource.VisaHost + ":" + VisaHealth.VisaSource.VisaPort + "/Vix/secure/VixLog.jsp";
            }
        }

        public string ViewSiteServiceUrl
        {
            get
            {
                return "http://" + VisaHealth.VisaSource.VisaHost + ":" + VisaHealth.VisaSource.VisaPort + "/VistaWebSvcs/ExchangeSiteService";
            }
        }

        public string ViewJavaLogUrl
        {
            get
            {
                if (IsAtLeastPatch118())
                {
                    return "https://" + VisaHealth.VisaSource.VisaHost + "/Vix/ssl/JavaLogs.jsp";
                }
                else
                {
                    return "http://" + VisaHealth.VisaSource.VisaHost + ":" + VisaHealth.VisaSource.VisaPort + "/Vix/secure/JavaLogs.jsp";
                }
            }
        }

        public string ViewLibsUrl(bool jreLibExt)
        {
            //http://vhapopclu2a.v15.med.va.gov:8080/VixServerHealthWebApp/secure/ViewLibs.jsp?configurationType=jreLibExt
            if (jreLibExt)
            {
                return "http://" + VisaHealth.VisaSource.VisaHost + ":" + VisaHealth.VisaSource.VisaPort + "/VixServerHealthWebApp/secure/ViewLibs.jsp?configurationType=jreLibExt";
            }
            else
            {
                return "http://" + VisaHealth.VisaSource.VisaHost + ":" + VisaHealth.VisaSource.VisaPort + "/VixServerHealthWebApp/secure/ViewLibs.jsp";
            }
        }

        public string ViewVixRootUrl
        {
            get
            {
                return "http://" + VisaHealth.VisaSource.VisaHost + ":" + VisaHealth.VisaSource.VisaPort;
            }
        }

        public string ViewROIStatusUrl
        {
            get
            {
                if (IsROISupported())
                {
                    return "http://" + VisaHealth.VisaSource.VisaHost + ":" + VisaHealth.VisaSource.VisaPort + "/ROIWebApp";
                }
                return null;
            }
        }

        public BaseVixHealth(VisaHealth visaHealth)
            : this(visaHealth, true)
        {

        }

        private void ReceiveOnUpdateVisaHealthCompletedEvent(VisaSource visaSource, VisaHealth visaHealth)
        {
            if (this.VisaHealth == visaHealth)
            {
                Update();
            }
        }

        /*
        private void ReceiveUpdateMessage(VisaHealthUpdatedMessage msg)
        {
            if (this.VisaHealth == msg.VisaHealth)
            {
                Update();
            }
        }*/

        public virtual void Update()
        {
            // re-read properties from VisaHealth
            if (VisaHealth.LoadStatus == VixHealthLoadStatus.loaded)
            {
                // cache stuff
                CacheDirectory = VisaHealth.GetPropertyValue("VixCacheDir");
                CacheSize = VisaHealth.GetPropertyValueFormattedBytes("VixCacheDirSize");
                /*
                long cacheDirectorySize = VisaHealth.GetPropertyValueLong("VixCacheDirSize");
                if (cacheDirectorySize >= 0)
                {
                    CacheSize = new FormattedBytes(cacheDirectorySize);
                }
                else
                {
                    CacheSize = FormattedBytes.MissingFormattedBytes;
                }*/
                /*
                long cacheDriveCapacity = VisaHealth.GetPropertyValueLong("VixCacheDirRootDriveTotal");
                if (cacheDriveCapacity >= 0)
                    CacheDriveCapacity = new FormattedBytes(cacheDriveCapacity);
                else
                    CacheDriveCapacity = FormattedBytes.MissingFormattedBytes;
                 * */
                CacheDriveCapacity = VisaHealth.GetPropertyValueFormattedBytes("VixCacheDirRootDriveTotal");
                long cacheAvailableSpace = VisaHealth.GetPropertyValueLong("VixCacheDirRootDriveAvailable");
                if (cacheAvailableSpace >= 0)
                    CacheDriveAvailableSpace = new FormattedBytes(cacheAvailableSpace);
                else
                    CacheDriveAvailableSpace = FormattedBytes.MissingFormattedBytes;
                long spaceUsed = CacheDriveCapacity.Bytes - cacheAvailableSpace;
                double val = ((double)spaceUsed / (double)CacheDriveCapacity.Bytes);
                CacheDrivePercentFull = (val * 100.0).ToString("N2") + "%";
                /*
                long cacheOperationsSuccessful = VisaHealth.GetPropertyValueLong("VixJMXCacheOperationsSuccessful");
                if (cacheOperationsSuccessful >= 0)
                    CacheOperationsSuccessful = new FormattedNumber(cacheOperationsSuccessful);
                else
                    CacheOperationsSuccessful = FormattedNumber.MissingFormattedNumber;
                 * */
                CacheOperationsSuccessful = VisaHealth.GetPropertyValueFormattedNumber("VixJMXCacheOperationsSuccessful");
                /*
                long cacheOperationsInitiated = VisaHealth.GetPropertyValueLong("VixJMXCacheOperationsInitiated");
                if (cacheOperationsInitiated >= 0)
                    CacheOperationsInitiated = new FormattedNumber(cacheOperationsInitiated);// cacheOperationsInitiated.ToString(numberFormat);
                else
                    CacheOperationsInitiated = FormattedNumber.MissingFormattedNumber;
                 * */
                CacheOperationsInitiated = VisaHealth.GetPropertyValueFormattedNumber("VixJMXCacheOperationsInitiated");
                /*
                long cacheOperationsNotFound = VisaHealth.GetPropertyValueLong("VixJMXCacheOperationsInstanceNotFound");
                if (cacheOperationsNotFound >= 0)
                    CacheOperationsInstanceNotFound = new FormattedNumber(cacheOperationsNotFound);
                else
                    CacheOperationsInstanceNotFound = FormattedNumber.MissingFormattedNumber;
                 * */
                CacheOperationsInstanceNotFound = VisaHealth.GetPropertyValueFormattedNumber("VixJMXCacheOperationsInstanceNotFound");
                /*
                long cacheOperationErrors = VisaHealth.GetPropertyValueLong("VixJMXCacheOperationsError");
                if (cacheOperationErrors >= 0)
                    CacheOperationsError = new FormattedNumber(cacheOperationErrors);
                else
                    CacheOperationsError = FormattedNumber.MissingFormattedNumber;
                */
                CacheOperationsError = VisaHealth.GetPropertyValueFormattedNumber("VixJMXCacheOperationsError");
                /*
                long javaLogDirectorySize = VisaHealth.GetPropertyValueLong("VixTomcatLogsDirSize");
                if (javaLogDirectorySize >= 0)
                {
                    JavaLogSizeFormatted = new FormattedBytes(javaLogDirectorySize);
                }
                else
                {
                    JavaLogSizeFormatted = FormattedBytes.MissingFormattedBytes;
                }
                 * */
                JavaLogSizeFormatted = VisaHealth.GetPropertyValueFormattedBytes("VixTomcatLogsDirSize");
                JavaLogsDirectory = VisaHealth.GetPropertyValue("VixTomcatLogsDir");
                long transactionsWritten = VisaHealth.GetPropertyValueLong("TransactionLogStatisticsTransactionsWritten");
                if (transactionsWritten >= 0)
                {
                    TransactionsWrittenFormatted = new FormattedNumber(transactionsWritten);// transactionsWritten.ToString(numberFormat);
                    TimeSpan span = VisaHealth.JVMUptimeLong.ToTimespan();
                    TransactionsPerMinuteFormatted = new FormattedDecimal(transactionsWritten / span.TotalMinutes);
                    //NotifyPropertyChanged("TransactionsPerMinuteFormatted");
                    //NotifyPropertyChanged("TransactionsWrittenFormatted");

                }
                else
                {
                    TransactionsWrittenFormatted = FormattedNumber.MissingFormattedNumber;
                    TransactionsPerMinuteFormatted = FormattedDecimal.MissingFormattedDecimal;
                }
                ThreadProcessingTime longestThread = GetLongestRunningThread();
                if (longestThread != null)
                {
                    LongestThreadTime = new FormattedTime(longestThread.ProcessingTime.Ticks, true);
                }
                else
                {
                    LongestThreadTime = FormattedTime.MissingFormattedTime;
                }

                // get busy threads
                int threadsProcessingAboveCriticalLimit = GetThreadsProcessingAboveCriticalCount(GetThreadCriticalLimit());
                if (threadsProcessingAboveCriticalLimit >= 0)
                {
                    LongThreads = new FormattedNumber(threadsProcessingAboveCriticalLimit);
                    if (IsThreadsProcessingAboveCriticalLimit())
                    {
                        LongThreadIcon = Icons.failed;
                    }
                    else
                    {
                        LongThreadIcon = Icons.passed;
                    }
                }
                else
                {
                    LongThreads = FormattedNumber.MissingFormattedNumber;
                    LongThreadIcon = Icons.unknown;
                }

                // Federation Counts
                /*
                string federationMetadataCount = (GetFederationMetadataRequestCount() >= 0 ? GetFederationMetadataRequestCount().ToString(numberFormat) : "?");
                string federationImageCount = (GetFederationImageServletRequestCount() >= 0 ? GetFederationImageServletRequestCount().ToString(numberFormat) : "?");
                string federationExamImageCount = (GetFederationExamImageServletRequestCount() >= 0 ? GetFederationExamImageServletRequestCount().ToString(numberFormat) : "?");
                string federationExamTextImageCount = (GetFederationExamImageTextServletRequestCount() >= 0 ? GetFederationExamImageTextServletRequestCount().ToString(numberFormat) : "?");
                 * */
                string federationMetadataV4Count = (GetFederationMetadataV4RequestCount() >= 0 ? GetFederationMetadataV4RequestCount().ToString(numberFormat) : "?");
                string federationImageV4Count = (GetFederationImageServletV4RequestCount() >= 0 ? GetFederationImageServletV4RequestCount().ToString(numberFormat) : "?");
                string federationExamImageV4Count = (GetFederationExamImageServletV4RequestCount() >= 0 ? GetFederationExamImageServletV4RequestCount().ToString(numberFormat) : "?");
                string federationExamImageTextV4Count = (GetFederationExamImageTextServletV4RequestCount() >= 0 ? GetFederationExamImageTextServletV4RequestCount().ToString(numberFormat) : "?");

                string federationImageV5Count = (GetFederationImageServletV5RequestCount() >= 0 ? GetFederationImageServletV5RequestCount().ToString(numberFormat) : "?");
                string federationExamImageV5Count = (GetFederationExamImageServletV5RequestCount() >= 0 ? GetFederationExamImageServletV5RequestCount().ToString(numberFormat) : "?");
                string federationExamImageTextV5Count = (GetFederationExamImageTextServletV5RequestCount() >= 0 ? GetFederationExamImageTextServletV5RequestCount().ToString(numberFormat) : "?");

                /*
                FederationCounts = federationMetadataCount + "/" + federationImageCount + "/" + federationExamImageCount + "/" +
                    federationExamTextImageCount + "/" + federationMetadataV4Count + "/" + federationImageV4Count + "/" + federationExamImageV4Count + "/" +
                    federationExamImageTextV4Count;
                 * */
                FederationCounts = federationMetadataV4Count + "/" + federationImageV4Count + "/" + federationExamImageV4Count + "/" +
                    federationExamImageTextV4Count + "/" + federationImageV5Count + "/" + federationExamImageV5Count + "/" + federationExamImageTextV5Count;

                // Radiology (Exchange) Counts
                string radiologyMetadataCount = (GetExchangeMetadataRequestCount() >= 0 ? GetExchangeMetadataRequestCount().ToString(numberFormat) : "?");
                string radiologyImageCount = (GetExchangeImageServletRequestCount() >= 0 ? GetExchangeImageServletRequestCount().ToString(numberFormat) : "?");
                string radiologyImageV2Count = (GetExchangeImageServletV2RequestCount() >= 0 ? GetExchangeImageServletV2RequestCount().ToString(numberFormat) : "?");
                RadiologyCount = radiologyMetadataCount + "/" + radiologyImageCount + "/" + radiologyImageV2Count;

                // active threads
                Active80Threads = GetActiveThreadCount("80");
                Active8080Threads = GetActiveThreadCount("8080");
                Active8443Threads = GetActiveThreadCount("8443");
                Active443Threads = GetActiveThreadCount("443");

                TransactionLogDirectory = GetValueOrEmptyString("VixTransactionLogsDir");
                /*
                long transactionLogSize = VisaHealth.GetPropertyValueLong("VixTransactionLogsDirSize");
                if (transactionLogSize >= 0)
                    TransactionLogSize = new FormattedBytes(transactionLogSize);
                else
                    TransactionLogSize = FormattedBytes.MissingFormattedBytes;
                 * */
                TransactionLogSize = VisaHealth.GetPropertyValueFormattedBytes("VixTransactionLogsDirSize");
                /*
                long transactionsPurged = VisaHealth.GetPropertyValueLong("TransactionLogStatisticsTransactionsPurged");
                if (transactionsPurged >= 0)
                    TransactionsPurged = new FormattedNumber(transactionsPurged);
                else
                    TransactionsPurged = FormattedNumber.MissingFormattedNumber;
                 * */
                TransactionsPurged = VisaHealth.GetPropertyValueFormattedNumber("TransactionLogStatisticsTransactionsPurged");
                /*
                long transactionLogQueries = VisaHealth.GetPropertyValueLong("TransactionLogStatisticsTransactionsQueried");
                if (transactionLogQueries >= 0)
                    TransactionLogQueries = new FormattedNumber(transactionLogQueries);
                else
                    TransactionLogQueries = FormattedNumber.MissingFormattedNumber;
                 * */
                TransactionLogQueries = VisaHealth.GetPropertyValueFormattedNumber("TransactionLogStatisticsTransactionsQueried");
                TransactionLogWriteErrors = VisaHealth.GetPropertyValueFormattedNumber("TransactionLogStatisticsTransactionWriteErrors");
                TransactionLogReadErrors = VisaHealth.GetPropertyValueFormattedNumber("TransactionLogStatisticsTransactionReadErrors");
                TransactionLogErrors = VisaHealth.GetPropertyValueFormattedNumber("TransactionLogStatisticsTransactionErrors");

                if (TransactionLogErrors.IsValueSet && TransactionsWrittenFormatted.IsValueSet)
                {
                    val = ((double)TransactionLogErrors.Number / (double)TransactionsWrittenFormatted.Number);
                    TransactionLogErrorPercent = (val * 100.0).ToString("N2") + "%";
                }
                else
                {
                    TransactionLogErrorPercent = "";
                }

                SiteServiceUrl = GetValueOrEmptyString("SiteServiceUrl");
                string siteServiceLastUpdated = VisaHealth.GetPropertyValue("SiteServiceLastUpdate");
                DateTime dt;
                if (DateTime.TryParse(siteServiceLastUpdated, out dt))
                {
                    //return dt.ToLocalTime().ToString();
                    SiteServiceLastUpdated = dt.ToString();
                }
                else
                {
                    SiteServiceLastUpdated = "";
                }
                SiteServiceSourceVersion = GetValueOrEmptyString("SiteServiceSourceVersion");

                /*
                long http80ThreadPoolSize = VisaHealth.GetPropertyValueLong("CatalinaThreadPoolThreadCount_http-80_ThreadPool");
                if (http80ThreadPoolSize >= 0)
                    Http80ThreadPoolMaxThreads = new FormattedNumber(http80ThreadPoolSize);
                else
                    Http80ThreadPoolMaxThreads = FormattedNumber.MissingFormattedNumber;
                 * */
                Http80ThreadPoolMaxThreads = VisaHealth.GetPropertyValueFormattedNumber("CatalinaThreadPoolThreadCount_http-80_ThreadPool");
                /*
                long http8080ThreadPoolSize = VisaHealth.GetPropertyValueLong("CatalinaThreadPoolThreadCount_http-8080_ThreadPool");
                if (http8080ThreadPoolSize >= 0)
                    Http8080ThreadPoolMaxThreads = new FormattedNumber(http8080ThreadPoolSize);
                else
                    Http8080ThreadPoolMaxThreads = FormattedNumber.MissingFormattedNumber;
                 * */
                Http8080ThreadPoolMaxThreads = VisaHealth.GetPropertyValueFormattedNumber("CatalinaThreadPoolThreadCount_http-8080_ThreadPool");
                /*
                long http8443ThreadPoolSize = VisaHealth.GetPropertyValueLong("CatalinaThreadPoolThreadCount_http-8443_ThreadPool");
                if (http8443ThreadPoolSize >= 0)
                    Http8443ThreadPoolMaxThreads = new FormattedNumber(http8443ThreadPoolSize);
                else
                    Http8443ThreadPoolMaxThreads = FormattedNumber.MissingFormattedNumber;
                 * */
                Http8443ThreadPoolMaxThreads = VisaHealth.GetPropertyValueFormattedNumber("CatalinaThreadPoolThreadCount_http-8443_ThreadPool");
                /*
                long http443ThreadPoolSize = VisaHealth.GetPropertyValueLong("CatalinaThreadPoolThreadCount_http-443_ThreadPool");
                if (http443ThreadPoolSize >= 0)
                    Http443ThreadPoolMaxThreads = new FormattedNumber(http443ThreadPoolSize);
                else
                    Http443ThreadPoolMaxThreads = FormattedNumber.MissingFormattedNumber;
                 * */
                Http443ThreadPoolMaxThreads = VisaHealth.GetPropertyValueFormattedNumber("CatalinaThreadPoolThreadCount_http-443_ThreadPool");

                RealmVistaServer = GetValueOrEmptyString("RealmVistaServer");
                RealmVistaPort = GetValueOrEmptyString("RealmVistaPort");

                if (IsCacheDriveBelowCriticalLimit())
                {
                    CacheSizeIcon = Icons.passed;

                }
                else
                {
                    CacheSizeIcon = Icons.failed;
                }

                string osName = VisaHealth.GetPropertyValue("OSName");
                if (osName == null)
                    OperatingSystemName = "";
                else
                    OperatingSystemName = osName;
                string osVersion = VisaHealth.GetPropertyValue("OSVersion");
                if (osVersion == null)
                    OperatingSystemVersion = "";
                else
                    OperatingSystemVersion = osVersion;                
                NumberOfProcesors = VisaHealth.GetPropertyValueFormattedNumber("SystemAvailableProcessors");
                TotalSwapSpace = VisaHealth.GetPropertyValueFormattedBytes("TotalSwapSpaceSize");
                FreeSwapSpace = VisaHealth.GetPropertyValueFormattedBytes("FreeSwapSpaceSize");
                TotalPhysicalMemory = VisaHealth.GetPropertyValueFormattedBytes("TotalPhysicalMemorySize");
                FreePhysicalMemory = VisaHealth.GetPropertyValueFormattedBytes("FreePhysicalMemorySize");
                CommittedVirtualMemory = VisaHealth.GetPropertyValueFormattedBytes("CommittedVirtualMemorySize");

                SiteServiceRequests = GetSiteServiceRequestCount();

                string roiPeriodicProcessingEnabledValue = VisaHealth.GetPropertyValue("ROIPeriodicProcessingEnabled");
                ROIPeriodicProcessingEnabled = (roiPeriodicProcessingEnabledValue == null ? false : bool.Parse(roiPeriodicProcessingEnabledValue));
                string roiCompletedItemsPurgeEnabledValue = VisaHealth.GetPropertyValue("ROICompletedItemPurgeEnabled");
                ROICompletedItemsPurgeEnabled = (roiCompletedItemsPurgeEnabledValue == null ? false : bool.Parse(roiCompletedItemsPurgeEnabledValue));
                string roiPeriodicProcessingError = VisaHealth.GetPropertyValue("ROIPeriodicProcessingError");
                ROIPeriodicProcessingError = (roiPeriodicProcessingError == null ? "" : roiPeriodicProcessingError);
                string roiProcessWorkItemsImmediatelyValue = VisaHealth.GetPropertyValue("ROIProcessWorkItemsImmediately");
                ROIProcessWorkItemsImmediately = (roiProcessWorkItemsImmediatelyValue == null ? false : bool.Parse(roiProcessWorkItemsImmediatelyValue));
            }
            else
            {
                // clear values
                CacheDirectory = "";
                CacheDriveAvailableSpace = FormattedBytes.UnknownFormattedBytes;
                CacheDriveCapacity = FormattedBytes.UnknownFormattedBytes;
                CacheDrivePercentFull = "";
                CacheSize = FormattedBytes.UnknownFormattedBytes;
                JavaLogSizeFormatted = FormattedBytes.UnknownFormattedBytes;
                JavaLogsDirectory = "";
                TransactionsWrittenFormatted = FormattedNumber.UnknownFormattedNumber;
                TransactionsPerMinuteFormatted = FormattedDecimal.UnknownFormattedDecimal;
                LongestThreadTime = FormattedTime.UnknownFormattedTime;
                LongThreads = FormattedNumber.UnknownFormattedNumber;
                LongThreadIcon = Icons.unknown;
                FederationCounts = "";
                RadiologyCount = "";
                Active80Threads = FormattedNumber.UnknownFormattedNumber;
                Active8080Threads = FormattedNumber.UnknownFormattedNumber;
                Active8443Threads = FormattedNumber.UnknownFormattedNumber;
                Active443Threads = FormattedNumber.UnknownFormattedNumber;
                TransactionLogDirectory = "";
                TransactionLogSize = FormattedBytes.UnknownFormattedBytes;
                TransactionLogQueries = FormattedNumber.UnknownFormattedNumber;
                TransactionsPurged = FormattedNumber.UnknownFormattedNumber;
                TransactionLogReadErrors = FormattedNumber.UnknownFormattedNumber;                
                TransactionLogWriteErrors = FormattedNumber.UnknownFormattedNumber;
                TransactionLogErrors = FormattedNumber.UnknownFormattedNumber;
                TransactionLogErrorPercent = "";
                SiteServiceUrl = "";
                SiteServiceLastUpdated = "";
                Http80ThreadPoolMaxThreads = FormattedNumber.UnknownFormattedNumber;
                Http8080ThreadPoolMaxThreads = FormattedNumber.UnknownFormattedNumber;
                Http8443ThreadPoolMaxThreads = FormattedNumber.UnknownFormattedNumber;
                Http443ThreadPoolMaxThreads = FormattedNumber.UnknownFormattedNumber;
                RealmVistaPort = "";
                RealmVistaServer = "";
                CacheSizeIcon = Icons.unknown;

                OperatingSystemName = "";
                OperatingSystemVersion = "";                
                NumberOfProcesors = FormattedNumber.UnknownFormattedNumber;
                TotalSwapSpace = FormattedBytes.UnknownFormattedBytes;
                FreeSwapSpace = FormattedBytes.UnknownFormattedBytes;
                TotalPhysicalMemory = FormattedBytes.UnknownFormattedBytes; ;
                FreePhysicalMemory = FormattedBytes.UnknownFormattedBytes;
                CommittedVirtualMemory = FormattedBytes.UnknownFormattedBytes;
                SiteServiceRequests = FormattedNumber.UnknownFormattedNumber;

                ROIPeriodicProcessingError = "";
                ROIPeriodicProcessingEnabled = false;
                ROICompletedItemsPurgeEnabled = false;
                ROIProcessWorkItemsImmediately = false;
            }
            CertificateExpirationDate = FormattedDate.UnknownFormattedDate;
            CertificateExpiredIcon = Icons.passed;
            evaluateHealthIcon();            
        }

        /// <summary>
        /// Returns the value associated with the key, if the value is null then an empty string is returned
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        protected string GetValueOrEmptyString(string key)
        {
            string value = VisaHealth.GetPropertyValue(key);
            if (value == null)
                return "";
            return value;
        }

        protected FormattedNumber GetActiveThreadCount(string threadId)
        {
            string threadString = "CatalinaThreadPoolThreadsBusy_http-" + threadId + "_ThreadPool";
            long count = VisaHealth.GetPropertyValueLong(threadString);
            if (count >= 0)
            {
                return new FormattedNumber(count);
            }
            return FormattedNumber.MissingFormattedNumber;
        }

        protected void evaluateHealthIcon()
        {
            if (VisaHealth.LoadStatus == VixHealthLoadStatus.loaded)
            {
                if (IsHealthy())
                {
                    HealthIcon = Icons.passed;
                }
                else
                {
                    HealthIcon = Icons.failed;
                }
            }
            else if (VisaHealth.LoadStatus == VixHealthLoadStatus.loading)
            {
                //HealthIcon = "images/loading_icon_1.gif";
                HealthIcon = Icons.loading;// "images/gnome-fs-loading-icon.png";
            }
            else
            {
                HealthIcon = Icons.unknown;
            }
        }

        public int GetThreadCriticalLimit()
        {
            int threadCriticalLimitTime = 1000 * 60 * 15; // 15 minutes
            if (VixHealthMonitorConfiguration.IsInitialized())
            {
                // value from configuration is in seconds, multiple by 1000 to get ms
                threadCriticalLimitTime = VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration().ThreadProcessingTimeCriticalLimit * 1000; ;
            }
            return threadCriticalLimitTime;
        }

        

        public virtual bool IsHealthy()
        {
            return !IsThreadsProcessingAboveCriticalLimit() && 
                IsRealmConfiguredProperly() && 
                IsCacheDriveBelowCriticalLimit() && 
                !IsROISupportedAndDisabled();
        }

        /// <summary>
        /// The reason why this health is not healthy
        /// </summary>
        public string UnhealthyReason
        {
            get
            {
                StringBuilder sb = new StringBuilder();
                string prefix = "";
                if (IsThreadsProcessingAboveCriticalLimit())
                {
                    sb.Append(prefix);
                    sb.Append(LongThreads.Number + " long running threads");
                    prefix = ", ";
                }
                if (!IsRealmConfiguredProperly())
                {
                    sb.Append(prefix);
                    sb.Append("Realm configured incorrectly");
                    prefix = ", ";
                }
                if (!IsCacheDriveBelowCriticalLimit())
                {
                    sb.Append(prefix);
                    sb.Append("Cache is above critical limit");
                    prefix = ", ";
                }
                if (IsROISupportedAndDisabled())
                {
                    sb.Append(prefix);
                    sb.Append("ROI is supported but disabled");
                    prefix = ", ";
                }

                return sb.ToString();
            }
        }

        /// <summary>
        /// Determines if a site has ROI support (at least Patch 130) and has it disabled so nothing will ever process
        /// </summary>
        /// <returns>True if there is a problem, false if everything is ok</returns>
        public bool IsROISupportedAndDisabled()
        {
            if (IsROISupported())
            {
                if (ROIPeriodicProcessingEnabled || ROIProcessWorkItemsImmediately)
                    return false; // all ok
                return true; // nothing will be processed

            }
            // site doesn't have ROI support, all OK
            return false;
        }

        public bool IsThreadsProcessingAboveCriticalLimit()
        {
            int threadCriticalLimitTime = GetThreadCriticalLimit(); // 15 minutes           
            int threadsProcessingAboveCriticalLimit = GetThreadsProcessingAboveCriticalCount(threadCriticalLimitTime);
            if (threadsProcessingAboveCriticalLimit > 0)
                return true;
            return false;
        }

        public bool IsCacheDriveBelowCriticalLimit()
        {
            if (VixHealthMonitorConfiguration.IsInitialized())
            {
                VixHealthMonitorConfiguration config = VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration();
                long criticalLimitBytes = (config.DriveCapacityCriticalLimitGB * 1024L * 1024L * 1024L);// bytes
                if (CacheDriveAvailableSpace.Bytes < criticalLimitBytes)
                {
                    long spaceUsed = CacheDriveCapacity.Bytes - CacheDriveAvailableSpace.Bytes;
                    double val = ((double)spaceUsed / (double)CacheDriveCapacity.Bytes);
                    double percentFull = (val * 100.0);
                    double percentAvailable = 100 - percentFull;
                    if (percentAvailable < config.DriveCapacityCriticalLimitPercent)
                        return false;
                }
                
            }
            return true;
            
        }

        public bool IsRealmConfiguredProperly()
        {
            return IsRealmVistaPortConfiguredProperly() && IsRealmVistaServerConfiguredProperly();
        }

        public bool IsRealmVistaServerConfiguredProperly()
        {
            string realmVistaServer = GetRealmVistaServer();
            if (VaSite.VistaHost != realmVistaServer)
                return false;
            return true;
        }

        public bool IsRealmVistaPortConfiguredProperly()
        {
            long realmVistaPort = GetRealmVistaPort();
            if (VaSite.VistaPort != realmVistaPort)
                return false;
            return true;
        }

        private int GetThreadsProcessingAboveCriticalCount(long threadProcessingCriticalLimit)
        {
            int count = 0;
            int threadsFound = 0;
            foreach (string key in VisaHealth.ServerProperties.Keys)
            {
                if (key.StartsWith("CatalinaRequestProcessingTime"))
                {
                    threadsFound++;
                    int timeRunning = int.Parse(VisaHealth.ServerProperties[key]);
                    if (timeRunning > threadProcessingCriticalLimit)
                    {
                        count++;
                    }
                }
            }
            if (threadsFound == 0)
                return -1; // indicate didn't find any threads, server might not be providing this data point
            return count;
        }

        /// <summary>
        /// Returns the longest running thread (may not be critical)
        /// </summary>
        /// <returns>The longest running thread or null if no threads are allocated</returns>
        private ThreadProcessingTime GetLongestRunningThread()
        {
            List<ThreadProcessingTime> threads = GetThreadProcessingTimes();
            ThreadProcessingTime longestThread = null;
            foreach (ThreadProcessingTime t in threads)
            {
                if (longestThread == null)
                    longestThread = t;
                else
                {
                    if (t.ProcessingTime.Ticks > longestThread.ProcessingTime.Ticks)
                        longestThread = t;
                }
            }
            return longestThread;
        }

        /// <summary>
        /// Returns all of the threads allocated and their processing time
        /// </summary>
        /// <returns></returns>
        public List<ThreadProcessingTime> GetThreadProcessingTimes()
        {
            List<ThreadProcessingTime> result = new List<ThreadProcessingTime>();
            foreach (string key in VisaHealth.ServerProperties.Keys)
            {
                if (key.StartsWith("CatalinaRequestProcessingTime_"))
                {

                    string name = key.Substring(30);
                    long time = long.Parse(VisaHealth.ServerProperties[key]);
                    result.Add(new ThreadProcessingTime(name, time));
                }
            }
            result.Sort(new ThreadProcessingTimeComparer(false));
            return result;
        }

        public List<GenericCount> GetRoiStatistics()
        {
            List<GenericCount> result = new List<GenericCount>();

            result.Add(new GenericCount("Disclosure Requests", VisaHealth.GetPropertyValueFormattedNumber("ROIDisclosureRequests"), "Number of disclosure requests made"));
            result.Add(new GenericCount("Disclosure Processing Errors", VisaHealth.GetPropertyValueFormattedNumber("ROIDisclosureProcessingErrors"), "Number of disclosures that failed"));
            result.Add(new GenericCount("Disclosures Completed", VisaHealth.GetPropertyValueFormattedNumber("ROIDisclosuresCompleted"), "Number of successfully completed disclosures"));
            result.Add(new GenericCount("Studies Sent to Export Queue", VisaHealth.GetPropertyValueFormattedNumber("ROIStudiesSentToExportQueue"), "Number of studies sent to export queue"));
            result.Add(new GenericCount("Disclosures Cancelled", VisaHealth.GetPropertyValueFormattedNumber("ROIDisclosuresCancelled"), "Number of disclosure requests cancelled"));

            result.Add(new GenericCount("ImageGear Burn Annotation Failures", VisaHealth.GetPropertyValueFormattedNumber("ImageGearBurnAnnotationFailures"), "Number of images that failed to burn annotations"));
            result.Add(new GenericCount("ImageGear Burn Annotation Image Requests", VisaHealth.GetPropertyValueFormattedNumber("ImageGearBurnAnnotationRequests"), "Number of requests to burn annotations onto images"));
            result.Add(new GenericCount("ImageGear Burn Annotation Image Success", VisaHealth.GetPropertyValueFormattedNumber("ImageGearBurnAnnotationSuccess"), "Number of images successfully burned annotations"));
            result.Add(new GenericCount("ImageGear PDF Failures", VisaHealth.GetPropertyValueFormattedNumber("ImageGearDisclosureFailures"), "Number of disclosures failed to generate a PDF"));
            result.Add(new GenericCount("ImageGear PDF Requests", VisaHealth.GetPropertyValueFormattedNumber("ImageGearDisclosureRequests"), "Number of disclosure requests to generate a PDF"));
            result.Add(new GenericCount("ImageGear PDF Success", VisaHealth.GetPropertyValueFormattedNumber("ImageGearDisclosureSuccess"), "Number of disclosures that successfully generated a PDF"));
             
            return result;
        }

        public List<MonitoredError> GetMonitoredErrors()
        {
            List<MonitoredError> result = new List<MonitoredError>();
            foreach (string key in VisaHealth.ServerProperties.Keys)
            {
                if (key.StartsWith("MonitoredError_"))
                {

                    string name = key.Substring(15);

                    string valueString = VisaHealth.ServerProperties[key];
                    int loc = valueString.IndexOf("_");
                    long count = long.Parse(valueString.Substring(0, loc));

                    string lastOccurrenceString = valueString.Substring(loc + 1);
                    FormattedDate lastOccurrence = FormattedDate.UnknownFormattedDate;
                    if (lastOccurrenceString.Length > 0)
                    {
                        int ticks = int.Parse(lastOccurrenceString);
                        lastOccurrence = FormattedDate.createFromJavaTime(ticks, true);
                    }

                    result.Add(new MonitoredError(name, new FormattedNumber(count), lastOccurrence));
                }
            }

            return result;
        }

        public FormattedDate GetMostRecentMonitoredError()
        {
            FormattedDate mostRecentMonitoredError = FormattedDate.UnknownFormattedDate;
            foreach (MonitoredError monitoredError in GetMonitoredErrors())
            {
                if (monitoredError.LastOccurrence.IsValueSet)
                {
                    if (mostRecentMonitoredError.IsValueSet)
                    {
                        if (monitoredError.LastOccurrence.Ticks > mostRecentMonitoredError.Ticks)
                            mostRecentMonitoredError = monitoredError.LastOccurrence;
                    }
                    else
                    {
                        mostRecentMonitoredError = monitoredError.LastOccurrence;
                    }
                }
            }
            return mostRecentMonitoredError;
        }

        public FormattedNumber GetTotalMonitoredErrors()
        {
            long count = 0;
            foreach (MonitoredError monitoredError in GetMonitoredErrors())
            {
                count += monitoredError.Count.Number;
            }
            return new FormattedNumber(count);
        }

        public List<GlobalRequestProcessor> GetGlobalRequestProcessors()
        {
            Dictionary<string, GlobalRequestProcessor> processors = new Dictionary<string, GlobalRequestProcessor>();

            List<GlobalRequestProcessor> result = new List<GlobalRequestProcessor>();
            foreach (string key in VisaHealth.ServerProperties.Keys)
            {
                if (key.StartsWith("CatalinaGlobalRequestProcessing"))
                {
                    int loc = key.IndexOf("_");
                    string property = key.Substring(31, loc - 31);
                    int nameEndLoc = key.IndexOf("_", loc + 1);
                    string name = key.Substring(loc + 1, nameEndLoc - loc - 1);
                    GlobalRequestProcessor grp = null;
                    
                    if( processors.ContainsKey(name))
                    {
                        grp = processors[name];
                    }
                    else
                    {
                        grp = new GlobalRequestProcessor(name);
                        processors.Add(name, grp);
                    }

                    long value = VisaHealth.GetPropertyValueLong(key);

                    switch (property)
                    {
                        case "BytesSent":
                            grp.BytesSent = new FormattedBytes(value);
                            grp.UpdateTotalBytes();
                            break;
                        case "BytesReceived":
                            grp.BytesReceived = new FormattedBytes(value);
                            grp.UpdateTotalBytes();
                            break;
                        case "RequestCount":
                            grp.RequestCount = new FormattedNumber(value);
                            break;
                        case "ProcessingTime":
                            grp.ProcessingTime = new FormattedTime(value, true);
                            break;
                    }
                }
            }
            result.AddRange(processors.Values);
            return result;
        }

        protected int GetServletRequestCount(string servletName, string webApplication, string webAppPath, bool appendWebApp)
        {
            StringBuilder key = new StringBuilder();
            key.Append("Catalina");
            key.Append(webApplication);
            key.Append("RequestCount_");
            key.Append(servletName);
            key.Append("_none_none_Servlet_//");
            if (this.VaSite.IsCvix)
                key.Append("2001");
            else
                key.Append(this.VaSite.SiteNumber);
            key.Append(".med.va.gov/");
            key.Append(webAppPath);
            if (appendWebApp)
                key.Append("WebApp");
            if (VisaHealth.ServerProperties.ContainsKey(key.ToString()))
            {
                return int.Parse(VisaHealth.ServerProperties[key.ToString()]);
            }

            return -1;
        }

        private int GetServletRequestCount(string servletName, string webApplication, string webAppPath)
        {
            return GetServletRequestCount(servletName, webApplication, webAppPath, true);
        }

        protected int GetServletRequestCount(string servletName, string webApplication)
        {
            return GetServletRequestCount(servletName, webApplication, webApplication);
        }       

        /// <summary>
        /// Returns the total number of requests for the interface (all types of requests)
        /// </summary>
        /// <returns></returns>
        public long GetTotalClinicalDisplayRequestCount()
        {
            long total = 0L;

            total += GetInterfaceRequestCount(GetClinicalDisplayMetadataRequestCount);
            total += GetInterfaceRequestCount(GetClinicalDisplayImageServletRequestCount);
            total += GetInterfaceRequestCount(GetClinicalDisplayImageServletV4RequestCount);
            total += GetInterfaceRequestCount(GetClinicalDisplayImageServletV5RequestCount);
            total += GetInterfaceRequestCount(GetClinicalDisplayImageServletV6RequestCount);            
            total += GetInterfaceRequestCount(GetClinicalDisplayImageServletV7RequestCount);

            return total;
        }

        /// <summary>
        /// Returns the total number of requests for the interface (all types of requests)
        /// </summary>
        /// <returns></returns>
        public long GetTotalVistaRadRequestCount()
        {
            long total = 0L;

            total += GetInterfaceRequestCount(GetVistaRadExamImageServletRequestCount);
            total += GetInterfaceRequestCount(GetVistaRadExamImageTextFileServletRequestCount);
            total += GetInterfaceRequestCount(GetVistaRadMetadataRequestCount);

            return total;
        }

        /// <summary>
        /// Returns the total number of requests for the interface (all types of requests)
        /// </summary>
        /// <returns></returns>
        public long GetTotalFederationRequestCount()
        {
            long total = 0L;

            total += GetInterfaceRequestCount(GetFederationExamImageServletRequestCount);
            total += GetInterfaceRequestCount(GetFederationExamImageTextServletRequestCount);
            total += GetInterfaceRequestCount(GetFederationImageServletRequestCount);
            total += GetInterfaceRequestCount(GetFederationMetadataRequestCount);
            total += GetInterfaceRequestCount(GetFederationDocumentServletV4RequestCount);
            total += GetInterfaceRequestCount(GetFederationExamImageServletV4RequestCount);
            total += GetInterfaceRequestCount(GetFederationExamImageTextServletV4RequestCount);
            total += GetInterfaceRequestCount(GetFederationImageServletV4RequestCount);
            total += GetInterfaceRequestCount(GetFederationMetadataV4RequestCount);
            total += GetInterfaceRequestCount(GetFederationImageTextServletV4RequestCount);
            total += GetInterfaceRequestCount(GetFederationDocumentServletV5RequestCount);
            total += GetInterfaceRequestCount(GetFederationExamImageServletV5RequestCount);
            total += GetInterfaceRequestCount(GetFederationExamImageTextServletV5RequestCount);
            total += GetInterfaceRequestCount(GetFederationImageServletV5RequestCount);
            total += GetInterfaceRequestCount(GetFederationImageTextServletV5RequestCount);

            return total;
        }

        /// <summary>
        /// Returns the total number of requests for the interface (all types of requests)
        /// </summary>
        /// <returns></returns>
        public long GetTotalExchangeRequestCount()
        {
            long total = 0L;

            total += GetInterfaceRequestCount(GetExchangeImageServletRequestCount);
            total += GetInterfaceRequestCount(GetExchangeImageServletV2RequestCount);
            total += GetInterfaceRequestCount(GetExchangeMetadataRequestCount);

            return total;
        }

        /// <summary>
        /// Returns the total number of requests for the interface (all types of requests)
        /// </summary>
        /// <returns></returns>
        public long GetTotalAwivRequestCount()
        {
            long total = 0L;

            total += GetInterfaceRequestCount(GetAWIVPhotoIDRequestCount);
            total += GetInterfaceRequestCount(GetAWIVMetadataRequestCount);
            total += GetInterfaceRequestCount(GetAWIVImageRequestCount);
            total += GetInterfaceRequestCount(GetAWIVImageV2RequestCount);
            total += GetInterfaceRequestCount(GetAWIVPhotoIDV2RequestCount);

            return total;
        }

        /// <summary>
        /// Returns the total number of requests for the interface (all types of requests)
        /// </summary>
        /// <returns></returns>
        public long GetTotalXcaRequestCount()
        {
            long total = 0L;

            total += GetInterfaceRequestCount(GetXCARequestCount);

            return total;
        }

        /// <summary>
        /// Get the count from the requestCount method, if less than 0, return 0
        /// </summary>
        /// <param name="count"></param>
        /// <returns></returns>
        private long GetInterfaceRequestCount(GetRequestCount count)
        {
            long v = count();
            if (v > 0)
                return v;
            return 0;
        }

        public long GetExchangeMetadataRequestCount()
        {
            return GetServletRequestCount("AxisServlet", "Exchange", "ImagingExchange");
        }

        public long GetExchangeImageServletV2RequestCount()
        {
            return GetServletRequestCount("ImageServletV2", "Exchange", "ImagingExchange");
        }

        public long GetExchangeImageServletRequestCount()
        {
            return GetServletRequestCount("ImageServlet", "Exchange", "ImagingExchange");
        }

        public long GetFederationMetadataRequestCount()
        {
            return GetServletRequestCount("AxisServlet", "Federation");
        }

        public long GetFederationMetadataV4RequestCount()
        {
            return GetServletRequestCount("JAX-RS REST Servlet", "Federation");
        }

        public long GetFederationImageServletRequestCount()
        {
            return GetServletRequestCount("FederationServlet", "Federation");
        }

        public long GetFederationImageServletV4RequestCount()
        {
            return GetServletRequestCount("FederationImageServletV4", "Federation");
        }

        public long GetFederationImageServletV5RequestCount()
        {
            return GetServletRequestCount("FederationImageServletV5", "Federation");
        }

        public long GetFederationImageTextServletV4RequestCount()
        {
            return GetServletRequestCount("FederationTextServletV4", "Federation");
        }

        public long GetFederationImageTextServletV5RequestCount()
        {
            return GetServletRequestCount("FederationTextServletV5", "Federation");
        }

        public long GetFederationDocumentServletV4RequestCount()
        {
            return GetServletRequestCount("FederationDocumentServletV4", "Federation");
        }

        public long GetFederationDocumentServletV5RequestCount()
        {
            return GetServletRequestCount("FederationDocumentServletV5", "Federation");
        }

        public long GetFederationExamImageServletRequestCount()
        {
            return GetServletRequestCount("FederationExamImageServlet", "Federation");
        }

        public long GetFederationExamImageTextServletRequestCount()
        {
            return GetServletRequestCount("FederationExamImageTextServlet", "Federation");
        }

        public long GetFederationExamImageServletV4RequestCount()
        {
            return GetServletRequestCount("FederationExamImageServletV4", "Federation");
        }

        public long GetFederationExamImageTextServletV4RequestCount()
        {
            return GetServletRequestCount("FederationExamImageTextServletV4", "Federation");
        }

        public long GetFederationExamImageServletV5RequestCount()
        {
            return GetServletRequestCount("FederationExamImageServletV5", "Federation");
        }

        public long GetFederationExamImageTextServletV5RequestCount()
        {
            return GetServletRequestCount("FederationExamImageTextServletV5", "Federation");
        }

        public long GetClinicalDisplayMetadataRequestCount()
        {
            return GetServletRequestCount("AxisServlet", "ClinicalDisplay");
        }

        public long GetClinicalDisplayImageServletRequestCount()
        {
            return GetServletRequestCount("ImageServlet", "ClinicalDisplay");
        }

        public long GetClinicalDisplayImageServletV4RequestCount()
        {
            return GetServletRequestCount("ImageServletV4", "ClinicalDisplay");
        }

        public long GetClinicalDisplayImageServletV5RequestCount()
        {
            return GetServletRequestCount("ImageServletV5", "ClinicalDisplay");
        }

        public long GetClinicalDisplayImageServletV6RequestCount()
        {
            return GetServletRequestCount("ImageServletV6", "ClinicalDisplay");
        }

        public long GetClinicalDisplayImageServletV7RequestCount()
        {
            return GetServletRequestCount("ImageServletV7", "ClinicalDisplay");
        }

        public long GetVistaRadMetadataRequestCount()
        {
            return GetServletRequestCount("AxisServlet", "VistaRad");
        }

        public long GetVistaRadExamImageServletRequestCount()
        {
            return GetServletRequestCount("ImageServlet", "VistaRad");
        }

        public long GetVistaRadExamImageTextFileServletRequestCount()
        {
            return GetServletRequestCount("ExamImageTextServlet", "VistaRad");
        }

        public long GetXCARequestCount()
        {
            return GetServletRequestCount("AxisServlet", "XCA", "XCARespondingGateway", false);
        }

        public long GetAWIVMetadataRequestCount()
        {
            return GetServletRequestCount("AxisServlet", "AWIV");
        }

        public long GetAWIVImageRequestCount()
        {
            return GetServletRequestCount("ImageServlet", "AWIV");
        }

        public long GetAWIVImageV2RequestCount()
        {
            return GetServletRequestCount("ImageServletV2", "AWIV");
        }

        public long GetAWIVPhotoIDRequestCount()
        {
            return GetServletRequestCount("PhotoIDServlet", "AWIV");
        }

        public long GetAWIVPhotoIDV2RequestCount()
        {
            return GetServletRequestCount("PhotoIDServletV2", "AWIV");
        }

        public string GetRealmVistaServer()
        {
            return VisaHealth.GetPropertyValue("RealmVistaServer");
        }

        public long GetRealmVistaPort()
        {
            return VisaHealth.GetPropertyValueLong("RealmVistaPort");
        }

        public long GetNonCorrelatedDoDExamRequests()
        {
            return VisaHealth.GetPropertyValueLong("NonCorrelatedDoDExamRequests");
        }

        public long GetTotalDoDExamRequests()
        {
            return VisaHealth.GetPropertyValueLong("TotalDoDExamRequests");
        }

        public long GetTotalDoDPatientArtifactRequests()
        {
            return VisaHealth.GetPropertyValueLong("TotalDoDPatientArtifactRequests");
        }

        public long GetNonCorrelatedDoDPatientArtifactRequests()
        {
            return VisaHealth.GetPropertyValueLong("NonCorrelatedDoDPatientArtifactRequests");
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void NotifyPropertyChanged(String info)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(info));
            }
        }

        protected FormattedNumber GetSiteServiceRequestCount()
        {            
            long count = 0;
            bool allMissing = true;
            foreach (SiteServiceKey ssk in siteServiceKeys)
            {
                StringBuilder key = new StringBuilder();
                key.Append("CatalinaSiteServiceRequestCount_");
                key.Append(ssk.Number);
                key.Append("_AxisServlet_none_none_Servlet_//");
                if (this.VaSite.IsCvix)
                    key.Append("2001");
                else
                    key.Append(this.VaSite.SiteNumber);
                key.Append(".med.va.gov/");
                key.Append(ssk.WebAppName);

                FormattedNumber value = VisaHealth.GetPropertyValueFormattedNumber(key.ToString());
                if (value.IsValueSet)
                {
                    count = count + value.Number;
                    allMissing = false;
                }
            }
            if (allMissing)
                return FormattedNumber.MissingFormattedNumber;
            return new FormattedNumber(count);
        }

        /*
        private string[] patch122Versions = new string[] { "30.118", "30.122", "30.119", "30.124" };

        public bool IsAtLeastPatch122()
        {
            string version = VisaHealth.VisaVersion;
            if (version.StartsWith("30.83"))
                return false;
            foreach (string p104Ver in patch122Versions)
            {
                if (version.StartsWith(p104Ver))
                    return true;
            }
            return false;
        }*/

        /// <summary>
        /// Supported in P118 and beyond
        /// </summary>
        private static string[] olderThanPatch118Versions =
            new string[] { "30.83", "30.104", "30.105" };

        public bool IsAtLeastPatch118()
        {
            if (this.VisaHealth != null)
            {
                string version = this.VisaHealth.VisaVersion;
                if (version == null)
                    return false;
                foreach (string unsupportedVersion in olderThanPatch118Versions)
                {
                    if (version.StartsWith(unsupportedVersion))
                        return false;
                }
                return true;
            }
            return false;
        }

        private string[] nonRoiVersions = 
            new string[] { "30.83", "30.104", "30.105", 
                "30.122", "30.118", "30.119", "30.130.9" }; // T9 of P130 did not include all of the health keys

        public bool IsROISupported()
        {
            if (this.VisaHealth != null)
            {
                if (this.VaSite.IsVix)
                {
                    string version = this.VisaHealth.VisaVersion;
                    if (version == null)
                        return false;
                    foreach (string unsupportedVersion in nonRoiVersions)
                    {
                        if (version.StartsWith(unsupportedVersion))
                            return false;
                    }
                    return true;
                }
            }
            return false;
        }

    }

    class SiteServiceKey
    {
        public string Number { get; private set; }
        public string WebAppName { get; private set; }

        public SiteServiceKey(string number, string webAppName)
        {
            this.Number = number;
            this.WebAppName = webAppName;
        }
    }
    
}
