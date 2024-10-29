using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VISAHealthMonitorCommon;
using VISACommon;
using GalaSoft.MvvmLight.Command;
using System.Diagnostics;
using VixHealthMonitor.messages;
using System.ComponentModel;
using VISAHealthMonitorCommonControls;
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
    public class VixTreeViewModel : ViewModelBase
    {
        public ObservableCollection<VixTreeHealthSource> VisaSources { get; set; }
        public VisaSource SelectedTreeItem { get; set; }
        public RelayCommand TreeMouseDoubleClickCommand { get; set; }
        public RelayCommand<object> TreeSelectedItemChangedCommand { get; set; }
        private object selectedItem = null;
        public RelayCommand AddWatchCommand { get; private set; }

        /// <summary>
        /// Initializes a new instance of the VixTreeViewModel class.
        /// </summary>
        public VixTreeViewModel()
        {
            TreeMouseDoubleClickCommand = new RelayCommand(() => TreeMouseDoubleClick());
            TreeSelectedItemChangedCommand = new RelayCommand<object>((i) => TreeSelectedItemChanged(i));
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
            }
            else
            {
                // Code runs "for real": Connect to service, etc...
                Messenger.Default.Register<ReloadSourcesMessage>(this, action => LoadVixSites(action));
                Messenger.Default.Register<DisplayVisaSourceMessage>(this, action => DisplayVisaSource(action));
            }
            AddWatchCommand = new RelayCommand(AddWatch);
        }

        private void DisplayVisaSource(DisplayVisaSourceMessage displayVisaSourceMessage)
        {
            ///TODO: need a way to set the selected tree item
            foreach (VixTreeHealthSource vths in VisaSources)
            {
                if (vths.VisaSource.Equals(displayVisaSourceMessage.VisaSource))
                {
                    vths.IsSelected = true;
                    break;
                }
            }
            Messenger.Default.Send<DisplayVisaHealthMessage>(new DisplayVisaHealthMessage(displayVisaSourceMessage.VisaSource));
        }

        private void AddWatch()
        {
            VisaHealthSource visaHealthSource = getSelectedVisaHealthSource();
            if (visaHealthSource != null)
            {
                Messenger.Default.Send<ChangeWatchedSiteMessage>(new ChangeWatchedSiteMessage(true, visaHealthSource.VisaSource));
            }
        }

        public void TreeSelectedItemChanged(object item)
        {
            this.selectedItem = item;
            VisaHealthSource source = getSelectedVisaHealthSource();
            if (source != null)
            {
                Messenger.Default.Send<DisplayVisaHealthMessage>(new DisplayVisaHealthMessage(source.VisaSource));
            }
        }

        private VisaHealthSource getSelectedVisaHealthSource()
        {
            if (this.selectedItem != null)
            {
                VisaHealthSource source = null;
                if (selectedItem.GetType().IsArray)
                {
                    object[] selectedItems = (object[])selectedItem;
                    object item = selectedItems[0];
                    if(item is VisaHealthSource)
                        source = (VisaHealthSource)selectedItems[0];
                }
                else
                {
                    if(this.selectedItem is VisaHealthSource)
                        source = (VisaHealthSource)this.selectedItem;
                }
                return source;
            }
            return null;
        }

        private VixServerUrl getSelectedUrl()
        {
            if (this.selectedItem != null)
            {
                VixServerUrl url = null;
                if (selectedItem.GetType().IsArray)
                {
                    object[] selectedItems = (object[])selectedItem;
                    object item = selectedItems[0];
                    if (item is VixServerUrl)
                        url = (VixServerUrl)selectedItems[0];
                }
                else
                {
                    if (this.selectedItem is VixServerUrl)
                        url = (VixServerUrl)this.selectedItem;
                }
                return url;
            }
            return null;
        }

        private void TreeMouseDoubleClick()
        {
            VisaHealthSource source = getSelectedVisaHealthSource();
            if (source != null)
            {
                Messenger.Default.Send<UpdateAndDisplayVisaHealthMessage>(new UpdateAndDisplayVisaHealthMessage(source.VisaSource));
            }
            else
            {
                VixServerUrl url = getSelectedUrl();                
                if (url != null)
                {
                    VixHealthMonitorHelper.LaunchUrl(url.Url);
                }
            }
        }

        private void LoadVixSites(ReloadSourcesMessage msg)
        {
            VisaSources = new ObservableCollection<VixTreeHealthSource>();
            foreach (VaSite site in VixSourceHolder.getSingleton().VisaSources)
            {
                if (site.IsVixOrCvix)
                {
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    VisaSources.Add(new VixTreeHealthSource(site, new BaseVixHealth(health)));
                }
            }
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}