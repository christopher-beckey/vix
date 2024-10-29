using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VISAHealthMonitorCommon;

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
    public class ButtonBarViewModel : ViewModelBase
    {
        public RelayCommand ReloadVisaSourcesCommand { get; set; }
        public RelayCommand TestAllSourcesCommand { get; set; }
        public RelayCommand StartStopIntervalTestCommand { get; set; }
        public RelayCommand TestFailedSourcesCommand { get; set; }
        public string StartStopTestCaption { get; set; }

        private bool isTestRunning = false;

        public bool CanExecuteCommand { get; set; }

        /// <summary>
        /// Initializes a new instance of the ButtonBarViewModel class.
        /// </summary>
        public ButtonBarViewModel()
        {

            ReloadVisaSourcesCommand = new RelayCommand(() => ReloadVisaSources(), () => CanExecuteCommand);
            TestAllSourcesCommand = new RelayCommand(() => TestAllSources(), () => CanExecuteCommand);
            StartStopIntervalTestCommand = new RelayCommand(() => StartStopIntervalTest(), () => CanExecuteCommand);
            TestFailedSourcesCommand = new RelayCommand(() => TestFailedSources(), () => CanExecuteCommand);


            SetStartStopTestCaption();
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
            }
            else
            {
                Messenger.Default.Register<AsyncHealthRefreshUpdateMessage>(this, action => ReceiveAsyncHealthRefreshUpdateMessage(action));
                Messenger.Default.Register<AllSourcesHealthUpdateMessage>(this, msg => ReceiveAllSourcesHealthUpdateMessage(msg));
                Messenger.Default.Register<StartStopIntervalTestMessage>(this, msg => ReceiveStartStopIntervalTestMessage(msg));
                // Code runs "for real": Connect to service, etc...
            }
            CanExecuteCommand = true;
        }

        private void SetStartStopTestCaption()
        {
            if (isTestRunning)
            {
                StartStopTestCaption = "Stop Interval Test";
            }
            else
            {
                StartStopTestCaption = "Start Interval Test";
            }
        }

        private void ReloadVisaSources()
        {
            Messenger.Default.Send<UpdateSourcesMessage>(new UpdateSourcesMessage());
        }

        private void TestFailedSources()
        {
            //VisaHealthManager.RefreshAllHealth(true, true);
            Messenger.Default.Send<TestAllSourcesMessage>(new TestAllSourcesMessage(true, true));
        }

        private void TestAllSources()
        {
            Messenger.Default.Send<TestAllSourcesMessage>(new TestAllSourcesMessage(true, false));
            // need to disable the command associated with this
            //VisaHealthManager.RefreshAllHealth(true, false);
        }

        /// <summary>
        /// Fires when testing starts and stops
        /// </summary>
        /// <param name="msg"></param>
        private void ReceiveAllSourcesHealthUpdateMessage(AllSourcesHealthUpdateMessage msg)
        {
            CanExecuteCommand = msg.Completed;
        }

        private void ReceiveAsyncHealthRefreshUpdateMessage(AsyncHealthRefreshUpdateMessage msg)
        {
            if (msg.IsComplete)
            {
                // set the buttons/commands to enabled
            }
            else
            {
                // set buttons/commands disabled
            }
        }

        private void StartStopIntervalTest()
        {
            isTestRunning = !isTestRunning;
            SetStartStopTestCaption();
            Messenger.Default.Send<StartStopIntervalTestMessage>(new StartStopIntervalTestMessage(this));
        }

        private void ReceiveStartStopIntervalTestMessage(StartStopIntervalTestMessage msg)
        {
            if (msg.Sender != this)
            {
                isTestRunning = !isTestRunning;
                SetStartStopTestCaption();
            }
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}