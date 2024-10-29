using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon.messages;
using System.Collections.ObjectModel;
using VISAHealthMonitorCommon;
using VISACommon;
using VISAHealthMonitorCommon.formattedvalues;
using GalaSoft.MvvmLight.Messaging;
using GalaSoft.MvvmLight;

namespace VixHealthMonitorCommon.model
{
    public delegate void ValuesUpdatedDelegate();

    public abstract class VixCountsModel : ViewModelBase
    {
        public ObservableCollection<VixHealthSource> VixSources { get; set; }

        public FormattedNumber TotalCacheOperations { get; private set; }
        public FormattedBytes TotalCached { get; private set; }
        public FormattedNumber TotalClinicalDisplayRequests { get; private set; }
        public FormattedNumber TotalVistaRadRequests { get; private set; }
        public FormattedNumber TotalFederationRequests { get; private set; }
        public FormattedNumber TotalAwivRequests { get; private set; }
        public FormattedNumber TotalXcaRequests { get; private set; }
        public FormattedNumber TotalExchangeRequests { get; private set; }
        public FormattedNumber TotalTransactions { get; private set; }
        public FormattedDecimal TotalTransactionsPerMinute { get; private set; }
        public FormattedDecimal TotalTransactionsPerDay { get; private set; }
        public FormattedNumber TotalActive80Threads { get; private set; }
        public FormattedNumber TotalActive8080Threads { get; private set; }
        public FormattedNumber TotalActive8443Threads { get; private set; }
        public FormattedNumber TotalActive443Threads { get; private set; }
        public FormattedNumber TotalSiteServiceRequests { get; private set; }
        public FormattedBytes TotalCvixBytes { get; private set; }
        public FormattedBytes TotalCvixBytesPerDay { get; private set; }
        public FormattedNumber TotalRequestsToDoD { get; private set; }
        public string PercentNonCorrelatedRequestsToDoD { get; private set; }

        private bool fullSourceUpdating = false;

        //public abstract ObservableCollection<VixHealthSource> GetVixSources();

        public abstract List<VisaSource> GetVisaSources();

        public event ValuesUpdatedDelegate OnValuesUpdatedEvent = null;

        /// <summary>
        /// Initializes a new instance of the VixCountsViewModel class.
        /// </summary>
        public VixCountsModel()
        {
            Messenger.Default.Register<AsyncHealthRefreshUpdateMessage>(this, msg => ReceiveAsyncHealthRefreshUpdateMessage(msg));
            Messenger.Default.Register<AllSourcesHealthUpdateMessage>(this, msg => ReceiveAllSourcesHealthUpdateMessage(msg));
            Messenger.Default.Register<VisaHealthUpdatedMessage>(this, msg => ReceiveVisaHealthUpdatedMessage(msg));
            SetDefaultValues();
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

        private void SetDefaultValues()
        {
            TotalCacheOperations = FormattedNumber.UnknownFormattedNumber;
            TotalCached = FormattedBytes.UnknownFormattedBytes;
            TotalClinicalDisplayRequests = FormattedNumber.UnknownFormattedNumber;
            TotalVistaRadRequests = FormattedNumber.UnknownFormattedNumber;
            TotalFederationRequests = FormattedNumber.UnknownFormattedNumber;
            TotalAwivRequests = FormattedNumber.UnknownFormattedNumber;
            TotalXcaRequests = FormattedNumber.UnknownFormattedNumber;
            TotalExchangeRequests = FormattedNumber.UnknownFormattedNumber;
            TotalTransactions = FormattedNumber.UnknownFormattedNumber;
            TotalTransactionsPerMinute = FormattedDecimal.UnknownFormattedDecimal;
            TotalTransactionsPerDay = FormattedDecimal.UnknownFormattedDecimal;
            TotalActive80Threads = FormattedNumber.UnknownFormattedNumber;
            TotalActive8080Threads = FormattedNumber.UnknownFormattedNumber;
            TotalActive8443Threads = FormattedNumber.UnknownFormattedNumber;
            TotalActive443Threads = FormattedNumber.UnknownFormattedNumber;
            TotalSiteServiceRequests = FormattedNumber.UnknownFormattedNumber;
            TotalCvixBytes = FormattedBytes.UnknownFormattedBytes;
            TotalCvixBytesPerDay = FormattedBytes.UnknownFormattedBytes;
            TotalRequestsToDoD = FormattedNumber.UnknownFormattedNumber;
            PercentNonCorrelatedRequestsToDoD = "";
        }

        private void UpdateValues()
        {
            // all sites updated, calculate totals
            long totalCacheOperations = 0;
            long totalCached = 0;
            long totalClinicalDisplayRequests = 0;
            long totalVistaRadRequests = 0;
            long totalFederationRequests = 0;
            long totalAwivRequests = 0;
            long totalXcaRequests = 0;
            long totalExchangeRequests = 0;
            long totalTransactions = 0;
            double totalTransactionPerMinute = 0f;
            long totalActive80Threads = 0;
            long totalActive8080Threads = 0;
            long totalActive8443Threads = 0;
            long totalActive443Threads = 0;
            long totalSiteServiceRequests = 0;
            long totalCvixBytes = 0;
            long totalCvixUptime = 0;

            long totalUptime = 0L;
            long totalRequestsToDoD = 0L;
            long totalNonCorrelatedRequestsToDoD = 0L;

            int healthLoadedCount = 0;
            int cvixHealthLoadedCount = 0;
            foreach (VixHealthSource vixHealthSource in VixSources)
            {
                if (vixHealthSource.VixHealth.VisaHealth.LoadStatus == VixHealthLoadStatus.loaded && !vixHealthSource.VixHealth.VaSite.TestSite)
                {
                    healthLoadedCount++;
                    totalCacheOperations = totalCacheOperations + vixHealthSource.VixHealth.CacheOperationsInitiated.Number;
                    totalCached = totalCached + vixHealthSource.VixHealth.CacheSize.Bytes;
                    totalClinicalDisplayRequests += vixHealthSource.VixHealth.GetTotalClinicalDisplayRequestCount();
                    totalVistaRadRequests += vixHealthSource.VixHealth.GetTotalVistaRadRequestCount();
                    totalFederationRequests += vixHealthSource.VixHealth.GetTotalFederationRequestCount();
                    totalAwivRequests += vixHealthSource.VixHealth.GetTotalAwivRequestCount();
                    totalXcaRequests += vixHealthSource.VixHealth.GetTotalXcaRequestCount();
                    totalExchangeRequests += vixHealthSource.VixHealth.GetTotalExchangeRequestCount();
                    totalTransactions += vixHealthSource.VixHealth.TransactionsWrittenFormatted.Number;
                    totalTransactionPerMinute += vixHealthSource.VixHealth.TransactionsPerMinuteFormatted.Decimal;
                    totalActive80Threads = totalActive80Threads + vixHealthSource.VixHealth.Active80Threads.Number;
                    totalActive8443Threads = totalActive8443Threads + vixHealthSource.VixHealth.Active8443Threads.Number;
                    totalActive443Threads = totalActive443Threads + vixHealthSource.VixHealth.Active443Threads.Number;
                    totalActive8080Threads = totalActive8080Threads + vixHealthSource.VixHealth.Active8080Threads.Number;
                    totalSiteServiceRequests = totalSiteServiceRequests + vixHealthSource.VixHealth.SiteServiceRequests.Number;

                    totalUptime = totalUptime + vixHealthSource.VixHealth.VisaHealth.JVMUptimeLong.Ticks;

                    if (vixHealthSource.VisaSource.VisaPort == 80)
                        totalActive80Threads--;
                    if (vixHealthSource.VisaSource.VisaPort == 8080)
                        totalActive8080Threads--;

                    if (vixHealthSource.VixHealth.VaSite.IsCvix)
                    {
                        List<GlobalRequestProcessor> globalRequestProcessors =
                            vixHealthSource.VixHealth.GetGlobalRequestProcessors();
                        foreach (GlobalRequestProcessor grp in globalRequestProcessors)
                        {
                            totalCvixBytes += grp.BytesReceived.Bytes + grp.BytesSent.Bytes;
                        }
                        totalCvixUptime = totalCvixUptime + vixHealthSource.VixHealth.VisaHealth.JVMUptimeLong.Ticks;
                        cvixHealthLoadedCount++;


                        totalRequestsToDoD += vixHealthSource.VixHealth.GetTotalDoDPatientArtifactRequests() + vixHealthSource.VixHealth.GetTotalDoDExamRequests();
                        totalNonCorrelatedRequestsToDoD += vixHealthSource.VixHealth.GetNonCorrelatedDoDPatientArtifactRequests() + vixHealthSource.VixHealth.GetNonCorrelatedDoDExamRequests();

                    }
                }
            }
            TotalCacheOperations = new FormattedNumber(totalCacheOperations);
            TotalCached = new FormattedBytes(totalCached);
            TotalClinicalDisplayRequests = new FormattedNumber(totalClinicalDisplayRequests);
            TotalVistaRadRequests = new FormattedNumber(totalVistaRadRequests);
            TotalFederationRequests = new FormattedNumber(totalFederationRequests);
            TotalAwivRequests = new FormattedNumber(totalAwivRequests);
            TotalXcaRequests = new FormattedNumber(totalXcaRequests);
            TotalExchangeRequests = new FormattedNumber(totalExchangeRequests);
            TotalTransactions = new FormattedNumber(totalTransactions);
            TotalTransactionsPerMinute = new FormattedDecimal(totalTransactionPerMinute);
            TotalActive80Threads = new FormattedNumber(totalActive80Threads);
            TotalActive8080Threads = new FormattedNumber(totalActive8080Threads);
            TotalActive8443Threads = new FormattedNumber(totalActive8443Threads);
            TotalActive443Threads = new FormattedNumber(totalActive443Threads);
            TotalSiteServiceRequests = new FormattedNumber(totalSiteServiceRequests);
            TotalCvixBytes = new FormattedBytes(totalCvixBytes);

            double uptimeMinutes = (totalUptime / (60 * 1000));
            double uptimeDays = (totalUptime / (60 * 1000 * 60 * 24));
            double transDay = 0f;
            if (uptimeMinutes > 0)
            {
                transDay = (totalTransactions / uptimeDays);
            }

            double cvixUptimeMinutes = (totalCvixUptime / (60 * 1000));
            double cvixUptimeDays = (totalCvixUptime / (60 * 1000 * 60 * 24));
            double cvixBytesDay = 0f;
            if (cvixUptimeMinutes > 0)
            {
                cvixBytesDay = (totalCvixBytes / cvixUptimeDays);
            }

            // the transMin and transDay are calculating per server, we want total for enterprise so multiply by response servers
            transDay = transDay * healthLoadedCount;
            TotalTransactionsPerDay = new FormattedDecimal(transDay);
            cvixBytesDay = cvixBytesDay * cvixHealthLoadedCount;
            TotalCvixBytesPerDay = new FormattedBytes((long)cvixBytesDay);
            TotalRequestsToDoD = new FormattedNumber(totalRequestsToDoD);

            double percentNonCorrelatedRequests = 0f;
            if (totalRequestsToDoD > 0)
            {
                percentNonCorrelatedRequests = ((double)totalNonCorrelatedRequestsToDoD / (double)totalRequestsToDoD);
            }
            percentNonCorrelatedRequests *= 100.0;
            PercentNonCorrelatedRequestsToDoD = percentNonCorrelatedRequests.ToString("N2") + "%";

            if (OnValuesUpdatedEvent != null)
                OnValuesUpdatedEvent();
        }

        private void ReceiveAsyncHealthRefreshUpdateMessage(AsyncHealthRefreshUpdateMessage msg)
        {
            // listening to AllSourcesHealthUpdateMessage - I don't think we need this here anymore
            /*
            if (msg.Completed >= msg.Total)
            {
                UpdateValues();
            }
            else
            {
                // set all values to unknown or missing
                SetDefaultValues();
            }*/
        }

        protected void LoadVixSites(ReloadSourcesMessage msg)
        {
            VixSources = new ObservableCollection<VixHealthSource>();
            System.Collections.Generic.List<VisaSource> sources = GetVisaSources();

            foreach (VaSite site in sources)
            {

                if (site.IsVixOrCvix)
                {
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    VixSources.Add(new VixHealthSource(site, new BaseVixHealth(health)));
                }
            }
        }
    }
}
