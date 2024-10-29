using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;
using SiteService;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using System.Windows.Input;
using VixHealthMonitorCommon;
using VISAHealthMonitorCommon;

namespace VixHealthMonitor
{
    public class VixSourceHolder
    {
        private List<VisaSource> visaSources = new List<VisaSource>();

        public List<VisaSource> VisaSources
        {
            get { return visaSources; }
        }

        public VisaSource GetVisaSource(string id)
        {
            foreach (VisaSource visaSource in VisaSources)
            {
                if (visaSource.ID == id)
                    return visaSource;
            }
            return null;
        }

        private static VixSourceHolder singleton = null;
        public static VixSourceHolder getSingleton()
        {
            if (singleton == null)
            {
                singleton = new VixSourceHolder();
            }
            return singleton;
        }

        public VixSourceHolder()
        {
        }

        public void Refresh()
        {
            Messenger.Default.Send<CursorChangeMessage>(new CursorChangeMessage(Cursors.Wait));
            visaSources.Clear();
            // JMW 2/11/2013 - clear all sources to make sure get health from new site if sites updated
            VisaHealthManager.ClearAllSources();
            string url = "http://siteserver.vista.med.va.gov/VistaWebSvcs/ImagingExchangeSiteService.asmx";

            VixHealthMonitorConfiguration configuration = VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration();
            url = configuration.SiteServiceUrl;

            try
            {
                System.Collections.Generic.List<VaSite> sites = SiteServiceHelper.getVaSites(url, true);
                
                foreach (VaSite testSite in configuration.TestSites)
                {
                    sites.Add(testSite);
                }
                sites.Sort(new VaSiteComparer());
                visaSources.AddRange(sites);

                Messenger.Default.Send<StatusMessage>(new StatusMessage("Loaded " + sites.Count + " sites from Site Service"));
            }
            catch (Exception ex)
            {
                Messenger.Default.Send<StatusMessage>(new StatusMessage("Error loading from site service, " + ex.Message, true));
            }
            
            Messenger.Default.Send<CursorChangeMessage>(new CursorChangeMessage(Cursors.Arrow));
            Messenger.Default.Send<ReloadSourcesMessage>(new ReloadSourcesMessage());
        }


    }
}
