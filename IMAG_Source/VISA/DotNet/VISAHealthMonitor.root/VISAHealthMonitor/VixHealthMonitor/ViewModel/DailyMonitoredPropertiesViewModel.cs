using GalaSoft.MvvmLight;
using System;
using VixHealthMonitorCommon.monitoredproperty;
using VISAHealthMonitorCommon;
using GalaSoft.MvvmLight.Command;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using GalaSoft.MvvmLight.Messaging;
using VixHealthMonitor.messages;
using VISACommon;

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
    public class DailyMonitoredPropertiesViewModel : ViewModelBase
    {
        public ListViewSortedCollectionViewSource DailyMonitoredProperties { get; private set; }
        public RelayCommand<string> SortDailyMonitoredPropertiesCommand { get; private set; }

        public RelayCommand RefreshDataCommand { get; private set; }
        public object SelectedItem { get; set; }

        public DateTime SelectedDate { get; set; }

        public RelayCommand ListMouseDoubleClickCommand { get; private set; }
        public RelayCommand ShowSiteDetailsCommand { get; private set; }


        /// <summary>
        /// Initializes a new instance of the DailyMonitoredPropertiesViewModel class.
        /// </summary>
        public DailyMonitoredPropertiesViewModel()
        {
            if (IsInDesignMode)
            {
            ////    // Code runs in Blend --> create design time data.
            }
            else
            {
            ////    // Code runs "for real": Connect to service, etc...
            }

            DailyMonitoredProperties = new ListViewSortedCollectionViewSource();
            DailyMonitoredProperties.Sort("VisaSource.Name");
            SortDailyMonitoredPropertiesCommand = new RelayCommand<string>(val => DailyMonitoredProperties.Sort(val));

            RefreshDataCommand = new RelayCommand(() => RefreshData());
            ListMouseDoubleClickCommand = new RelayCommand(() => DoubleClick());
            ShowSiteDetailsCommand = new RelayCommand(() => ShowSiteDetails());
            SelectedDate = DateTime.Now;
        }

        private void DoubleClick()
        {
        }

        private void RefreshData()
        {
            /*
            DateTime date = DateTime.Now;
            LoadData(date.AddDays(-1));
             * */
            LoadData(SelectedDate);
        }

        private void LoadData(DateTime date)
        {

            List<MonitoredProperty> properties =
                MonitoredPropertyManager.Manager.GetDailyMonitoredProperties(date);
            DailyMonitoredProperties.SetSource(new ObservableCollection<MonitoredProperty>(properties));

        }

        private void ShowSiteDetails()
        {
            if (SelectedItem != null)
            {
                MonitoredProperty monitoredProperty = (MonitoredProperty)SelectedItem;

                VisaSource visaSource = VixSourceHolder.getSingleton().GetVisaSource(monitoredProperty.VisaSource.ID);
                if(visaSource != null)
                    Messenger.Default.Send<DisplayVisaSourceMessage>(new DisplayVisaSourceMessage(visaSource));
            }
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}