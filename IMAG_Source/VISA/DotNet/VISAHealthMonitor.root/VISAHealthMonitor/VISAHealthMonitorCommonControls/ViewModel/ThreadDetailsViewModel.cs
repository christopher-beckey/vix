using GalaSoft.MvvmLight;
using VISACommon;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using System.Windows.Input;
using VISAHealthMonitorCommon.jmx;
using VISAHealthMonitorCommon;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using GalaSoft.MvvmLight.Command;
using System.Windows;
using System;

namespace VISAHealthMonitorCommonControls.ViewModel
{
    public delegate void CloseWindowDelegate();


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
    public class ThreadDetailsViewModel : ViewModelBase
    {
        public VisaSource VisaSource { get; set; }
        public string SiteName { get; set; }
        public string RequestName { get; set; }
        public string Title { get; set; }
        public string WorkerThread { get; set; }
        public RelayCommand RefreshCommand { get; set; }
        public RelayCommand CloseCommand { get; set; }

        public ListViewSortedCollectionViewSource StackTrace { get; private set; }
        public event CloseWindowDelegate OnCloseWindowEvent;

        public int RequestRowHeight { get; set; }
        public Visibility ShowRequestRowHeight { get; set; }
        public string StatusMessage { get; set; }
        public Visibility ErrorIconVisibility { get; set; }

        private JmxThread thread = null;


        /// <summary>
        /// Initializes a new instance of the ThreadDetailsModel class.
        /// </summary>
        public ThreadDetailsViewModel()
        {
            if (IsInDesignMode)
            {
            ////    // Code runs in Blend --> create design time data.
                SetStatusMessage("Status Message", false);
            }
            else
            {
                // Code runs "for real": Connect to service, etc...
                StackTrace = new ListViewSortedCollectionViewSource();
                ClearStatusMessage();
            }
            RefreshCommand = new RelayCommand(() => Refresh());
            CloseCommand = new RelayCommand(() => CloseDetails());
            setShowRequestRow(true);
            
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

        private void setShowRequestRow(bool visible)
        {
            if (visible)
            {
                RequestRowHeight = 26;
                ShowRequestRowHeight = Visibility.Visible;
            }
            else
            {
                RequestRowHeight = 0;
                ShowRequestRowHeight = Visibility.Collapsed;
            }
        }

        private void CloseDetails()
        {
            if (OnCloseWindowEvent != null)
                OnCloseWindowEvent();
        }

        private void Refresh()
        {
            LoadThreadDetails();
        }

        public void setThreadDetails(VisaSource visaSource, string requestName)
        {
            setShowRequestRow(true);
            this.VisaSource = visaSource;
            this.RequestName = requestName;
            this.SiteName = visaSource.DisplayName;
            Title = VisaSource + " - " + RequestName;
            LoadThreadDetails();
        }

        public void setThreadDetails(VisaSource visaSource, JmxThread thread)
        {
            setShowRequestRow(false);
            this.thread = thread;            
            this.VisaSource = visaSource;
            this.WorkerThread = thread.ThreadName;
            this.SiteName = visaSource.DisplayName;
            Title = VisaSource + " - " + WorkerThread;
            LoadThreadDetails();
        }

        private void LoadThreadDetails()
        {
            try
            {
                Messenger.Default.Send<CursorChangeMessage>(new CursorChangeMessage(Cursors.Wait));
                ClearStatusMessage();
                StackTrace.ClearSource();
                if (thread == null)
                {
                    WorkerThread = JmxUtility.GetRequestProcessorWorkerThread(VisaSource, RequestName);
                }
                if (!string.IsNullOrEmpty(WorkerThread))
                {
                    ObservableCollection<JmxThreadStackTraceElement> stackTraceElements =
                        new ObservableCollection<JmxThreadStackTraceElement>(JmxUtility.getThreadStackTrace(VisaSource, WorkerThread));
                    StackTrace.SetSource(stackTraceElements);
                }
            }
            catch (Exception ex)
            {
                SetStatusMessage(ex.Message, true);
            }
            finally
            {
                Messenger.Default.Send<CursorChangeMessage>(new CursorChangeMessage(Cursors.Arrow));
            }
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}