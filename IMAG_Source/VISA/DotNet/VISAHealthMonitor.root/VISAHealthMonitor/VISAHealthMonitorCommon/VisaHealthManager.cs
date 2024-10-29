using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using System.Runtime.CompilerServices;

namespace VISAHealthMonitorCommon
{
    public class VisaHealthManager
    {
        private static Dictionary<VisaSource, VisaHealth> visaSourceHealth =
            new Dictionary<VisaSource, VisaHealth>();

        public static void ClearAllSources()
        {
            lock (visaSourceHealth)
            {
                visaSourceHealth.Clear();
            }
        }

        public static VisaHealth GetVisaHealth(VisaSource visaSource)
        {
            lock (visaSourceHealth)
            {
                if (visaSourceHealth.ContainsKey(visaSource))
                {
                    return visaSourceHealth[visaSource];
                }
                else
                {
                    VisaHealth health = new VisaHealth(visaSource);
                    visaSourceHealth.Add(visaSource, health);
                    return health;
                }
            }
        }

        private static int completedCount = 0;
        private static int sourcesTestingCount = 0;

        public static void RefreshHealth(IEnumerable<VisaSource> sources, bool async, 
            bool onlyTestFailed, VisaHealthOption[] visaHealthOptions, int timeout)
        {
            completedCount = 0;
            sourcesTestingCount = 0;
            // this message indicates all sources are being tested
            Messenger.Default.Send<AllSourcesHealthUpdateMessage>(new AllSourcesHealthUpdateMessage(false));
            foreach (VisaSource source in sources)
            {
                VisaHealth health = visaSourceHealth[source];
                if (!onlyTestFailed || health.LoadStatus != VixHealthLoadStatus.loaded)
                {
                    sourcesTestingCount++;
                    if (async)
                    {
                        health.UpdateAsync(UpdateVisaHealthCompleted, visaHealthOptions, timeout);
                    }
                    else
                    {
                        health.Update(visaHealthOptions, timeout);
                    }
                }
            }
            if (!async)
            {
                Messenger.Default.Send<AllSourcesHealthUpdateMessage>(new AllSourcesHealthUpdateMessage(true));
                Messenger.Default.Send<StatusMessage>(new StatusMessage("Done testing all sites, " + DateTime.Now.ToString()));
            }
        }

        /// <summary>
        /// Refreshes the health for all sources.
        /// </summary>
        /// <param name="async">Indicates if the refresh should be done asynchronously</param>
        /// <param name="onlyTestFailed">If true, only unloaded sources are tested. If false, all sources are tested</param>
        public static void RefreshAllHealth(bool async, bool onlyTestFailed, VisaHealthOption[] visaHealthOptions, int timeout)
        {
            RefreshHealth(visaSourceHealth.Keys, async, onlyTestFailed, visaHealthOptions, timeout);
            /*
            completedCount = 0;
            sourcesTestingCount = 0;
            // this message indicates all sources are being tested
            Messenger.Default.Send<AllSourcesHealthUpdateMessage>(new AllSourcesHealthUpdateMessage(false));
            foreach (VisaSource source in visaSourceHealth.Keys)
            {                
                VisaHealth health = visaSourceHealth[source];
                if (!onlyTestFailed || health.LoadStatus != VixHealthLoadStatus.loaded)
                {
                    sourcesTestingCount++;
                    if (async)
                    {
                        health.UpdateAsync(UpdateVisaHealthCompleted, visaHealthOptions, timeout);
                    }
                    else
                    {
                        health.Update(visaHealthOptions, timeout);
                    }
                }
            }
            if (!async)
            {
                Messenger.Default.Send<AllSourcesHealthUpdateMessage>(new AllSourcesHealthUpdateMessage(true));
                Messenger.Default.Send<StatusMessage>(new StatusMessage("Done testing all sites, " + DateTime.Now.ToString()));
            }*/
        }

        [MethodImpl(MethodImplOptions.Synchronized)]
        private static void UpdateVisaHealthCompleted(VisaSource visaSource, VisaHealth visaHealth)
        {
            completedCount++;
            Messenger.Default.Send<AsyncHealthRefreshUpdateMessage>(new AsyncHealthRefreshUpdateMessage(completedCount, sourcesTestingCount));
            if (completedCount >= sourcesTestingCount)
            {
                Messenger.Default.Send<AllSourcesHealthUpdateMessage>(new AllSourcesHealthUpdateMessage(true));
                Messenger.Default.Send<StatusMessage>(new StatusMessage("Done testing all sites, " + DateTime.Now.ToString()));
            }
            
        }
    }
}
