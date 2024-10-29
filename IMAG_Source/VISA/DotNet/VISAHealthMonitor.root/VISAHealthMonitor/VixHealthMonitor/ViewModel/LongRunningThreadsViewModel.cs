using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GalaSoft.MvvmLight;
using VixHealthMonitorCommon;
using System.Collections.ObjectModel;
using VISAHealthMonitorCommon;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VISACommon;
using GalaSoft.MvvmLight.Command;

namespace VixHealthMonitor.ViewModel
{
    public class LongRunningThreadsViewModel : ViewModelBase
    {
        public ListViewSortedCollectionViewSource VisaThreadProcessingTimes { get; set; }
        public object SelectedItem { get; set; }
        public RelayCommand<string> SortCommand { get; private set; }
        public RelayCommand ListMouseDoubleClickCommand { get; set; }
        public RelayCommand RefreshSiteCommand { get; set; }
        public event ShowThreadDetailsDialogDelegate OnShowThreadDetailsDialog;

        public LongRunningThreadsViewModel()
        {
            if (IsInDesignMode)
            {
                ////    // Code runs in Blend --> create design time data.
                //SetStatusMessage("Status Message", false);
            }
            else
            {
                // Code runs "for real": Connect to service, etc...
                //Messenger.Default.Register<ReloadSourcesMessage>(this, action => LoadVixSites(action));
                Messenger.Default.Register<VisaHealthUpdatedMessage>(this, action => VisaHealthUpdated(action));
                
            }
            VisaThreadProcessingTimes = new ListViewSortedCollectionViewSource();
            VisaThreadProcessingTimes.SetSource(new ObservableCollection<SourcedThreadProcessingTime>());
            VisaThreadProcessingTimes.Sort("VisaSource.DisplayName");
            SortCommand = new RelayCommand<string>(msg => VisaThreadProcessingTimes.Sort(msg));
            ListMouseDoubleClickCommand = new RelayCommand(() => DisplayThreadDetails());
            RefreshSiteCommand = new RelayCommand(() => RefreshSite());
        }

        private void RefreshSite()
        {
            if (SelectedItem != null)
            {
                SourcedThreadProcessingTime selectedItem = (SourcedThreadProcessingTime)SelectedItem;
                Messenger.Default.Send<UpdateAndDisplayVisaHealthMessage>(new UpdateAndDisplayVisaHealthMessage(selectedItem.VisaSource));
            }
        }

        private void DisplayThreadDetails()
        {
            if (SelectedItem != null)
            {
                SourcedThreadProcessingTime selectedItem = (SourcedThreadProcessingTime)SelectedItem;
                if (OnShowThreadDetailsDialog != null)
                {
                    OnShowThreadDetailsDialog(selectedItem.VisaSource, selectedItem.VisaHealth, selectedItem);
                }
            }
        }

        private void VisaHealthUpdated(VisaHealthUpdatedMessage msg)
        {
            VisaHealthUpdateSourceDelegate d = new VisaHealthUpdateSourceDelegate(VisaHealthUpdatedInternal);
            VisaThreadProcessingTimes.Sources.Dispatcher.Invoke(d, new object[] { msg });           
        }

        private void VisaHealthUpdatedInternal(VisaHealthUpdatedMessage msg)
        {
            //GetSourcesDelegate d = new GetSourcesDelegate(GetSources);
            //ObservableCollection<VixHealthSource> sources = (ObservableCollection<VixHealthSource>)VisaSources.Sources.Dispatcher.Invoke(d, new object[] { });

            ObservableCollection<SourcedThreadProcessingTime> sources = (ObservableCollection<SourcedThreadProcessingTime>)VisaThreadProcessingTimes.Sources.Source;
            VixHealth vixHealth = new VixHealth(msg.VisaHealth);
            VixHealthSource vixHealthSource = new VixHealthSource(msg.VisaSource, vixHealth);
            if (vixHealth.VisaHealth.LoadStatus == VixHealthLoadStatus.loaded)
            {
                RemoveSiteLongRunningThreads(msg.VisaSource);
                if (vixHealth.LongThreads.Number > 0)
                {
                    int threadCriticalLimitTime = vixHealth.GetThreadCriticalLimit();
                    List<ThreadProcessingTime> threads = vixHealth.GetThreadProcessingTimes();
                    foreach (ThreadProcessingTime thread in threads)
                    {
                        if (thread.ProcessingTime.Ticks > threadCriticalLimitTime)
                        {
                            // for each entry add it to the list
                            sources.Add(new SourcedThreadProcessingTime(msg.VisaSource, 
                                msg.VisaHealth, thread));
                        }
                    }   
                }
            }
        }

        private void RemoveSiteLongRunningThreads(VisaSource visaSource)
        {
            ObservableCollection<SourcedThreadProcessingTime> sources = 
                (ObservableCollection<SourcedThreadProcessingTime>)VisaThreadProcessingTimes.Sources.Source;

            List<SourcedThreadProcessingTime> removeList = new List<SourcedThreadProcessingTime>();

            foreach (SourcedThreadProcessingTime sourcedThreadProcessingTime in sources)
            {
                if (sourcedThreadProcessingTime.VisaSource.ID == visaSource.ID)
                {
                    //sources.Remove(sourcedThreadProcessingTime);
                    removeList.Add(sourcedThreadProcessingTime);
                }
            }

            foreach (SourcedThreadProcessingTime sourcedThreadProcessingTime in removeList)
            {
                sources.Remove(sourcedThreadProcessingTime);
            }
        }



        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}

        private void LoadVixSites(ReloadSourcesMessage msg)
        {
            VisaThreadProcessingTimes.ClearSource();
            ObservableCollection<SourcedThreadProcessingTime> processingTimes = new ObservableCollection<SourcedThreadProcessingTime>();

            foreach (VaSite site in VixSourceHolder.getSingleton().VisaSources)
            {
                if (site.IsVixOrCvix && !site.TestSite)
                {
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    VixHealth vixHealth = new VixHealth(health);
                    int threadCriticalLimitTime = vixHealth.GetThreadCriticalLimit();
                    if (vixHealth.LongThreads.Number > 0)
                    {
                        List<ThreadProcessingTime> threads = vixHealth.GetThreadProcessingTimes();
                        foreach (ThreadProcessingTime thread in threads)
                        {
                            if (thread.ProcessingTime.Ticks > threadCriticalLimitTime)
                            {
                                // for each entry add it to the list
                                processingTimes.Add(new SourcedThreadProcessingTime(site, health, thread));
                            }
                        }                        
                    }
                }
            }
            VisaThreadProcessingTimes.SetSource(processingTimes);
        }
    }

    public class SourcedThreadProcessingTime : ThreadProcessingTime
    {
        public VisaSource VisaSource { get; private set; }
        public VisaHealth VisaHealth { get; private set; }

        public SourcedThreadProcessingTime(VisaSource visaSource, VisaHealth visaHealth, 
            ThreadProcessingTime threadProcessingTime)
            : this(visaSource, visaHealth, threadProcessingTime.ThreadName, threadProcessingTime.ProcessingTime.Ticks)
        {
        }

        public SourcedThreadProcessingTime(VisaSource visaSource,VisaHealth visaHealth,
            string threadName, long processingTime)
            : base(threadName, processingTime)
        {
            this.VisaSource = visaSource;
            this.VisaHealth = visaHealth;
        }
    }
}
