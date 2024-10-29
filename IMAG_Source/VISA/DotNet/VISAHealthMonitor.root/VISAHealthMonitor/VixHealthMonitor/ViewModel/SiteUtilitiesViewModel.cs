using GalaSoft.MvvmLight;
using VISAHealthMonitorCommon;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using System.Collections.ObjectModel;
using VixHealthMonitorCommon;
using VISACommon;
using System.ComponentModel;
using System.Windows;
using System;
using VISAHealthMonitorCommon.roi;
using VISAHealthMonitorCommon.monitorederror;
using System.Collections.Generic;

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
    public class SiteUtilitiesViewModel : ViewModelBase
    {
        public ListViewSortedCollectionViewSource VisaSources { get; set; }
        public RelayCommand ListMouseDoubleClickCommand { get; set; }
        public object SelectedItem { get; set; }
        public RelayCommand<string> SortCommand { get; private set; }
        public RelayCommand RefreshCommand { get; private set; }
        public RelayCommand<string> SelectSitesCommand { get; private set; }
        public ObservableCollection<SiteAction> SiteActions { get; private set; }
        public RelayCommand RunSiteActionCommand { get; private set; }
        public string SelectedActionToolTip { get; private set; }

        private SiteAction _selectedSiteAction = null;
        public object SelectedSiteAction 
        {
            get
            {
                return _selectedSiteAction;
            }
            set 
            {
                if (value != null)
                {
                    _selectedSiteAction = (SiteAction)value;
                }
                else
                {
                    _selectedSiteAction = null;
                }
                if (_selectedSiteAction != null)
                {
                    SiteActionTextVisibility = (_selectedSiteAction.RequiresInput == true ? Visibility.Visible : Visibility.Collapsed);
                    SelectedActionToolTip = _selectedSiteAction.ToolTip;
                }
                else
                {
                    SiteActionTextVisibility = Visibility.Collapsed;
                    SelectedActionToolTip = "";
                }
            } 
        }
        public Visibility SiteActionTextVisibility { get; private set; }
        public string SiteActionText { get; set; }

        /// <summary>
        /// Initializes a new instance of the SiteUtilitiesViewModel class.
        /// </summary>
        public SiteUtilitiesViewModel()
        {
            ListMouseDoubleClickCommand = new RelayCommand(() => ListMouseDoubleClick());
            if (IsInDesignMode)
            {
            ////    // Code runs in Blend --> create design time data.
            }
            else
            {
                Messenger.Default.Register<ReloadSourcesMessage>(this, action => LoadVixSites(action));
            ////    // Code runs "for real": Connect to service, etc...
            }
            VisaSources = new ListViewSortedCollectionViewSource();
            VisaSources.Sort("VixHealthSource.VisaSource.DisplayName");
            SortCommand = new RelayCommand<string>(msg => VisaSources.Sort(msg));
            RefreshCommand = new RelayCommand(() => RefreshSelectedSite());
            SelectSitesCommand = new RelayCommand<string>(msg => CheckSites(msg));
            RunSiteActionCommand = new RelayCommand(() => RunSiteAction());
            InitializeActions();
            SelectedSiteAction = null;
        }

        private void RunSiteAction()
        {
            if (_selectedSiteAction != null)
            {
                System.Collections.Generic.List<CheckedVixHealthSource> checkedSites = GetSelectedSites(true);
                foreach (CheckedVixHealthSource site in checkedSites)
                {
                    try
                    {
                        site.SetStatus("Running action '" + _selectedSiteAction.Name + "'", false);
                        if (_selectedSiteAction.OnRunAction(site.VixHealthSource.VisaSource, SiteActionText))
                        {
                            site.SetStatus("Action '" + _selectedSiteAction.Name + "' completed successfully", false);
                        }
                        else
                        {
                            site.SetStatus("Failed to run action '" + _selectedSiteAction.Name + "'", true);
                        }
                    }
                    catch (Exception ex)
                    {
                        site.SetStatus("Failed to run action '" + _selectedSiteAction.Name + "', " + ex.Message, true);
                    }
                }
            }
        }

        private System.Collections.Generic.List<CheckedVixHealthSource> GetSelectedSites(bool clearStatus)
        {
            System.Collections.Generic.List<CheckedVixHealthSource> checkedSites = new System.Collections.Generic.List<CheckedVixHealthSource>();
            ObservableCollection<CheckedVixHealthSource> sites = (ObservableCollection<CheckedVixHealthSource>)VisaSources.Sources.Source;
            foreach (CheckedVixHealthSource site in sites)
            {
                if(clearStatus)
                    site.ClearStatus();
                if (site.Checked)
                {
                    checkedSites.Add(site);
                }
            }
            return checkedSites;
        }

        private void InitializeActions()
        {
            List<SiteAction> actions = new List<SiteAction>();

            actions.Add(new SiteAction("ROI Periodic Processing Enabled", "Enable ROI Periodic Processing", true, ROIPeriodicProcessingEnabled));
            actions.Add(new SiteAction("ROI Process Work Items Immediately Enabled", "Enable ROI Processing of work items as they are received", 
                true, ROIProcessWorkItemsImmediatelyEnabled));
            actions.Add(new SiteAction("Refresh Site Service", "Refresh the site service information at the site", false, RefreshSiteService));
            actions.Add(new SiteAction("Refresh Site Health", "Refresh the health of the selected sites", false, RefreshSite));
            actions.Add(new SiteAction("Add Monitored Error", "Add monitored error to selected sites", true, AddMonitoredError));
            actions.Add(new SiteAction("Remove Monitored Error", "Remove monitored error to selected sites", true, DeleteMonitoredError));

            actions.Sort(new SiteActionComparer());
            SiteActions = new ObservableCollection<SiteAction>(actions);

            SiteActionTextVisibility = Visibility.Collapsed;
            SelectedActionToolTip = "";
        }

        private bool AddMonitoredError(VisaSource visaSource, string input)
        {
            return MonitoredErrorHelper.AddMonitoredError(visaSource, input);
        }

        private bool DeleteMonitoredError(VisaSource visaSource, string input)
        {
            return MonitoredErrorHelper.DeleteMonitoredError(visaSource, input);
        }

        private bool RefreshSite(VisaSource visaSource, string input)
        {
            Messenger.Default.Send<UpdateAndDisplayVisaHealthMessage>(new UpdateAndDisplayVisaHealthMessage(visaSource));
            return true;
        }

        private bool RefreshSiteService(VisaSource visaSource, string input)
        {
            return SiteService.SiteServiceUtility.RefreshSiteService(visaSource);
        }

        private bool ROIProcessWorkItemsImmediatelyEnabled(VisaSource visaSource, string input)
        {
            bool enabled = false;
            if (bool.TryParse(input, out enabled))
            {
                // do something

                ROIConfiguration configuration = ROIConfigurationHelper.GetROIConfiguration(visaSource);
                configuration.ProcessWorkItemsImmediately = enabled;
                ROIConfiguration updatedConfiguration =
                    ROIConfigurationHelper.UpdateROIConfiguration(configuration, visaSource);
                if (updatedConfiguration.ProcessWorkItemsImmediately == enabled)
                    return true;
                return false;
            }
            else
            {
                throw new Exception("Input string must be true or false");
            }
        }

        private bool ROIPeriodicProcessingEnabled(VisaSource visaSource, string input)
        {
            bool enabled = false;
            if (bool.TryParse(input, out enabled))
            {
                // do something

                ROIConfiguration configuration = ROIConfigurationHelper.GetROIConfiguration(visaSource);
                configuration.PeriodicProcessingEnabled = enabled;
                ROIConfiguration updatedConfiguration =
                    ROIConfigurationHelper.UpdateROIConfiguration(configuration, visaSource);
                if (updatedConfiguration.PeriodicProcessingEnabled == enabled)
                    return true;
                return false;
            }
            else
            {
                throw new Exception("Input string must be true or false");
            }
        }

        private void CheckSites(string msg)
        {
            bool isChecked = bool.Parse(msg);
            ObservableCollection<CheckedVixHealthSource> sites = (ObservableCollection<CheckedVixHealthSource>)VisaSources.Sources.Source;
            foreach (CheckedVixHealthSource site in sites)
            {
                site.Checked = isChecked;
            }
        }

        private void RefreshSelectedSite()
        {
            if (SelectedItem != null)
            {
                CheckedVixHealthSource source = (CheckedVixHealthSource)SelectedItem;
                Messenger.Default.Send<UpdateAndDisplayVisaHealthMessage>(new UpdateAndDisplayVisaHealthMessage(source.VixHealthSource.VisaSource));
            }
        }

        private void LoadVixSites(ReloadSourcesMessage msg)
        {
            //VisaSources = new ObservableCollection<VixHealthSource>();
            VisaSources.ClearSource();
            ObservableCollection<CheckedVixHealthSource> sources = new ObservableCollection<CheckedVixHealthSource>();
            foreach (VaSite site in VixSourceHolder.getSingleton().VisaSources)
            {
                if (site.IsVixOrCvix)
                {
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    VixHealth vixHealth = new VixHealth(health);
                    sources.Add(new CheckedVixHealthSource(new VixHealthSource(site, vixHealth)));
                }
               
            }
            VisaSources.SetSource(sources);
        }

        private void ListMouseDoubleClick()
        {
            if (SelectedItem != null)
            {
                CheckedVixHealthSource source = (CheckedVixHealthSource)SelectedItem;
                source.Checked = !source.Checked;
            }
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }

    public class CheckedVixHealthSource : INotifyPropertyChanged
    {
        public bool Checked { get; set; }
        public VixHealthSource VixHealthSource { get; private set; }
        public string Status { get; set; }
        public Visibility StatusIconVisibility { get; private set; }

        public CheckedVixHealthSource(VixHealthSource vixHealthSource)
        {
            this.VixHealthSource = vixHealthSource;
            this.Checked = false;
            ClearStatus();
        }

        public void ClearStatus()
        {
            Status = "";
            StatusIconVisibility = Visibility.Collapsed;
        }

        public void SetStatus(string status, bool error)
        {
            this.Status = status;
            StatusIconVisibility = (error == true ? Visibility.Visible : Visibility.Collapsed);
        }

        public event PropertyChangedEventHandler PropertyChanged;
    }

    public delegate bool RunActionDelegate(VisaSource visaSource, string input);

    public class SiteAction
    {
        public string Name { get; private set; }
        public bool RequiresInput { get; private set; }
        public string ToolTip { get; private set; }
        public RunActionDelegate OnRunAction;

        public SiteAction(string name, string toolTip, bool requiresInput, RunActionDelegate onRunAction)
        {
            this.Name = name;
            this.ToolTip = toolTip;
            this.RequiresInput = requiresInput;
            this.OnRunAction = onRunAction;
            
        }

        public override string ToString()
        {
            return Name;
        }
    }

    public class SiteActionComparer : IComparer<SiteAction>
    {
        public int Compare(SiteAction x, SiteAction y)
        {
            return x.Name.CompareTo(y.Name);
        }
    }
}