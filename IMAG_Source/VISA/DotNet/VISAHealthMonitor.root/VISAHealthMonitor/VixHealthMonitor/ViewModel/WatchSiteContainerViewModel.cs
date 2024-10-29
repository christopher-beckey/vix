using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VISACommon;
using VISAHealthMonitorCommon;
using GalaSoft.MvvmLight.Command;
using System.Windows.Input;
using VixHealthMonitor.Model;
using VixHealthMonitor.messages;
using VixHealthMonitorCommon;

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
    public class WatchSiteContainerViewModel : ViewModelBase
    {
        public ObservableCollection<VixHealthSource> VisaSources { get; set; }
        public RelayCommand<VisaSource> RefreshHealthCommand { get; private set; }
        public RelayCommand<VisaSource> RemoveWatchedSourceCommand { get; private set; }

        private WatchedSiteConfiguration WatchedSiteConfiguration;

        /// <summary>
        /// Initializes a new instance of the WatchSiteContainerViewModel class.
        /// </summary>
        public WatchSiteContainerViewModel()
        {
            if (IsInDesignMode)
            {
            }
            else
            {
                Messenger.Default.Register<ReloadSourcesMessage>(this, action => LoadVixSites(action));
                Messenger.Default.Register<ChangeWatchedSiteMessage>(this, action => ChangeWatchedSite(action));
            }
            RefreshHealthCommand = new RelayCommand<VisaSource>(UpdateVisaHealth);
            RemoveWatchedSourceCommand = new RelayCommand<VisaSource>(RemoveWatchedSource);
            string watchedSitesFilename = System.AppDomain.CurrentDomain.BaseDirectory + @"\watched_sites.xml";
            WatchedSiteConfiguration = WatchedSiteConfiguration.Initialize(watchedSitesFilename);
        }

        private void ChangeWatchedSite(ChangeWatchedSiteMessage msg)
        {
            VaSite site = (VaSite)msg.VisaSource;
            if (WatchedSiteConfiguration.IsSiteWatched(site.SiteNumber))
            {
                if (msg.Watch)
                {
                    // already watched, do nothing
                }
                else
                {
                    // currently watched but want to remove                                       
                    WatchedSiteConfiguration.WatchedSites.Remove(site.SiteNumber);
                    WatchedSiteConfiguration.Save();
                    VisaHealth visaHealth = VisaHealthManager.GetVisaHealth(site);
                    BaseVixHealth health = new BaseVixHealth(visaHealth);
                    VixHealthSource vixHealthSource = new VixHealthSource(site, health);
                    VisaSources.Remove(vixHealthSource);
                }
            }
            else
            {
                // not currently watching
                if (msg.Watch)
                {
                    WatchedSiteConfiguration.WatchedSites.Add(site.SiteNumber);
                    WatchedSiteConfiguration.Save();
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    VisaSources.Add(new VixHealthSource(site, new BaseVixHealth(health)));
                }
            }
        }

        private void LoadVixSites(ReloadSourcesMessage msg)
        {
            VisaSources = new ObservableCollection<VixHealthSource>();
            foreach (VaSite site in VixSourceHolder.getSingleton().VisaSources)
            {
                if (site.IsVixOrCvix)
                {
                    if (WatchedSiteConfiguration.IsSiteWatched(site.SiteNumber))
                    {
                        VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                        // correlate this list with the configured 'watch' sites
                        VisaSources.Add(new VixHealthSource(site, new BaseVixHealth(health)));
                    }
                }
            }
        }

        private void RemoveWatchedSource(VisaSource visaSource)
        {
            VisaHealth visaHealth = VisaHealthManager.GetVisaHealth(visaSource);
            VaSite site = (VaSite)visaSource;
            BaseVixHealth health = new BaseVixHealth(visaHealth);
            VixHealthSource vixHealthSource = new VixHealthSource(visaSource, health);
            VisaSources.Remove(vixHealthSource);
            WatchedSiteConfiguration.WatchedSites.Remove(site.SiteNumber);
            WatchedSiteConfiguration.Save();
        }

        private void UpdateVisaHealth(VisaSource visaSource)
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
            //DisplayHealth();
            Messenger.Default.Send<CursorChangeMessage>(new CursorChangeMessage(Cursors.Arrow));
        }

        

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}