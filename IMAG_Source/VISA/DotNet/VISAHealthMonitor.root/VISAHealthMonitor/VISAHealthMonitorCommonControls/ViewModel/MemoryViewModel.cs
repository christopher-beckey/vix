using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GalaSoft.MvvmLight;
using VISACommon;
using VISAHealthMonitorCommon;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using System.Windows.Input;
using System.Collections.ObjectModel;
using VISAHealthMonitorCommon.jmx;
using System.Windows;
using System.Timers;
using VISAHealthMonitorCommon.formattedvalues;

namespace VISAHealthMonitorCommonControls.ViewModel
{
    public class MemoryViewModel : ViewModelBase
    {
        public VisaHealth VisaHealth { get; set; }
        public event CloseWindowDelegate OnCloseWindowEvent;
        public string SiteName { get; set; }
        public string Title { get; set; }
        public ListViewSortedCollectionViewSource MemoriesList { get; private set; }
        public RelayCommand<string> SortMemoriesCommand { get; set; }
        public string StatusMessage { get; set; }
        public Visibility ErrorIconVisibility { get; set; }
        public RelayCommand CloseCommand { get; set; }
        public RelayCommand RefreshCommand { get; set; }
        public Cursor Cursor { get; set; }
        public FormattedNumber JavaThreadCount { get; private set; }

        private Timer loadTimer = new Timer();

        /// <summary>
        /// Initializes a new instance of the ThreadsViewModel class.
        /// </summary>
        public MemoryViewModel()
        {
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
                //SetStatusMessage("Status Message", false);
            }
            else
            {
                MemoriesList = new ListViewSortedCollectionViewSource();
                ClearStatusMessage();
                SortMemoriesCommand = new RelayCommand<string>(val => MemoriesList.Sort(val));
                /*
                ThreadList = new ListViewSortedCollectionViewSource();
                SortThreadsCommand = new RelayCommand<string>(val => ThreadList.Sort(val));
                ClearStatusMessage();
                 * */
                // Code runs "for real": Connect to service, etc...
            }
            /*
            ThreadMouseDoubleClickCommand = new RelayCommand(() => ThreadMouseDoubleClick());
            CloseCommand = new RelayCommand(() => Close());
            RefreshCommand = new RelayCommand(() => LoadThreads());
             * */
            CloseCommand = new RelayCommand(() => Close());
            RefreshCommand = new RelayCommand(() => LoadMemoryInformation());
            loadTimer.Enabled = false;
            loadTimer.Interval = 15; // 15 ms
            loadTimer.Elapsed += new ElapsedEventHandler(timer_Elapsed);
            
        }

        public void SetVisaHealth(VisaHealth visaHealth)
        {
            this.VisaHealth = visaHealth;

            this.SiteName = visaHealth.VisaSource.DisplayName;
            Title = "Memory Information - " + SiteName;

            loadTimer.Enabled = true;
        }

        private void timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            loadTimer.Enabled = false;
            LoadMemoryInformation();
        }

        private void LoadMemoryInformation()
        {
            try
            {
                MemoriesList.ClearSource();
                JavaThreadCount = FormattedNumber.UnknownFormattedNumber;                
                ClearStatusMessage();

                if (VisaHealth.LoadStatus == VixHealthLoadStatus.loaded)
                {

                    if (JmxUtility.IsJmxSupported(VisaHealth))
                    {
                        this.Cursor = Cursors.Wait;

                        ObservableCollection<JmxMemoryInformation> memoryInformationElements =
                                new ObservableCollection<JmxMemoryInformation>(JmxUtility.GetMemoryInformation(VisaHealth));
                        MemoriesList.SetSource(memoryInformationElements);
                        JavaThreadCount = VisaHealth.GetPropertyValueFormattedNumber("JavaThreadCount");
                        if (!JavaThreadCount.IsValueSet)
                        {
                            // try to get from JMX
                            JavaThreadCount = JmxUtility.GetJavaThreads(VisaHealth.VisaSource);
                        }
                    }
                    else
                    {
                        SetStatusMessage("Site does not support memory information", true);
                    }
                }
                else
                {
                    SetStatusMessage("Health of site is not loaded, cannot retrieve memory information until health is loaded", true);
                }
            }
            catch (Exception ex)
            {
                SetStatusMessage(ex.Message, true);
            }
            finally
            {
                this.Cursor = Cursors.Arrow;
            }
        }

        private void Close()
        {
            if (OnCloseWindowEvent != null)
                OnCloseWindowEvent();
        }

        private void ClearStatusMessage()
        {
            SetStatusMessage("", false);
        }

        private void SetStatusMessage(string msg, bool error)
        {
            if (error)
            {
                ErrorIconVisibility = Visibility.Visible;
            }
            else
            {
                ErrorIconVisibility = Visibility.Collapsed;
            }
            StatusMessage = msg;
        }
    }
}
