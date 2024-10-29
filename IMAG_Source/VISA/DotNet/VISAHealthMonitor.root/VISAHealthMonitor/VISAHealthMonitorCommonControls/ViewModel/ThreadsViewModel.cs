using GalaSoft.MvvmLight;
using VISACommon;
using VISAHealthMonitorCommon;
using System.Windows.Input;
using VISAHealthMonitorCommon.messages;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.jmx;
using System.Collections.ObjectModel;
using GalaSoft.MvvmLight.Command;
using System;
using System.Windows;
using System.Timers;

namespace VISAHealthMonitorCommonControls.ViewModel
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
    public class ThreadsViewModel : ViewModelBase
    {
        public VisaSource VisaSource { get; set; }
        public string SiteName { get; set; }
        public string Title { get; set; }
        public ListViewSortedCollectionViewSource ThreadList { get; private set; }
        public RelayCommand<string> SortThreadsCommand { get; set; }
        public object ThreadSelectedItem { get; set; }
        public RelayCommand ThreadMouseDoubleClickCommand { get; set; }
        public RelayCommand CloseCommand { get; set; }
        public RelayCommand RefreshCommand { get; set; }
        public event CloseWindowDelegate OnCloseWindowEvent;
        public string StatusMessage { get; set; }
        public Visibility ErrorIconVisibility { get; set; }
        public Cursor Cursor { get; set; }

        private Timer loadTimer = new Timer();

        /// <summary>
        /// Initializes a new instance of the ThreadsViewModel class.
        /// </summary>
        public ThreadsViewModel()
        {
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
                SetStatusMessage("Status Message", false);
            }
            else
            {
                ThreadList = new ListViewSortedCollectionViewSource();
                SortThreadsCommand = new RelayCommand<string>(val => ThreadList.Sort(val));
                ClearStatusMessage();
                // Code runs "for real": Connect to service, etc...
            }
            ThreadMouseDoubleClickCommand = new RelayCommand(() => ThreadMouseDoubleClick());
            CloseCommand = new RelayCommand(() => Close());
            RefreshCommand = new RelayCommand(() => LoadThreads());
            loadTimer.Enabled = false;
            loadTimer.Interval = 15; // 15 ms
            loadTimer.Elapsed += new ElapsedEventHandler(timer_Elapsed);
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

        private void Close()
        {
            if (OnCloseWindowEvent != null)
                OnCloseWindowEvent();
        }

        private void ThreadMouseDoubleClick()
        {
            if (ThreadSelectedItem != null)
            {                
                JmxThread jmxThread = (JmxThread)ThreadSelectedItem;
                ThreadDetails threadDetails = new ThreadDetails(VisaSource, jmxThread);
                threadDetails.Show();                
            }
        }

        public void SetSiteDetails(VisaSource visaSource)
        {
            this.VisaSource = visaSource;
            this.SiteName = VisaSource.DisplayName;
            Title = "Threads - " + SiteName;
            loadTimer.Enabled = true;
        }

        private void timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            loadTimer.Enabled = false;
            LoadThreads();
        }

        private void LoadThreads()
        {
            try
            {
                ThreadList.ClearSource();
                ClearStatusMessage();
                this.Cursor = Cursors.Wait;

                ObservableCollection<JmxThread> threadElements =
                        new ObservableCollection<JmxThread>(JmxUtility.GetActiveThreads(VisaSource));
                ThreadList.SetSource(threadElements);
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

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}