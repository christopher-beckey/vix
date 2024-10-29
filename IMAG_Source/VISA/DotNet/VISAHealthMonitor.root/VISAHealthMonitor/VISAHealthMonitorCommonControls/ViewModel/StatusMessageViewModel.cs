using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using System.Windows;

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
    public class StatusMessageViewModel : ViewModelBase
    {
        public string Message { get; set; }
        public string AsyncStatus { get; set; }
        public string IntervalTestStatus { get; set; }
        public Visibility ErrorIconVisibility { get; private set; }

        private bool isTestRunning = false;

        /// <summary>
        /// Initializes a new instance of the StatusMessageViewModel class.
        /// </summary>
        public StatusMessageViewModel()
        {
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
                Message = "Status Message";
                AsyncStatus = "AsyncStatus";
                IntervalTestStatus = "Interval Test Status";
            }
            else
            {
                Messenger.Default.Register<StatusMessage>(this, msg => ReceiveStatusMessage(msg));
                Messenger.Default.Register<AsyncHealthRefreshUpdateMessage>(this, msg => ReceieveAsyncHealthRefreshUpdateMessage(msg));
                Messenger.Default.Register<StartStopIntervalTestMessage>(this, msg => ReceiveStartStopIntervalTestMessage(msg));
                // Code runs "for real": Connect to service, etc...
            }
            ErrorIconVisibility = Visibility.Collapsed;
        }

        private void EvaluateTestRunning()
        {
            IntervalTestStatus = (isTestRunning == true ? "Running" : "Stopped");
        }

        private void ReceiveStartStopIntervalTestMessage(StartStopIntervalTestMessage msg)
        {
            isTestRunning = !isTestRunning;
            EvaluateTestRunning();
        }

        protected void ReceiveStatusMessage(StatusMessage msg)
        {
            Message = msg.Message;
            ErrorIconVisibility = (msg.Error == true ? Visibility.Visible : Visibility.Collapsed);
        }

        private void ReceieveAsyncHealthRefreshUpdateMessage(AsyncHealthRefreshUpdateMessage msg)
        {
            if (msg.IsComplete)
            {
                AsyncStatus = "Done";
            }
            else
            {
                AsyncStatus = msg.Completed + " of " + msg.Total;
            }
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}