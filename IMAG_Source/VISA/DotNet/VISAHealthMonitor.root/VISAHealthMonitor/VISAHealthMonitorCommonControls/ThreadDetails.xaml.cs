using System.Windows;
using VISACommon;
using VISAHealthMonitorCommonControls.ViewModel;
using VISAHealthMonitorCommon.jmx;

namespace VISAHealthMonitorCommonControls
{
    /// <summary>
    /// Description for ThreadDetails.
    /// </summary>
    public partial class ThreadDetails : Window
    {
        /// <summary>
        /// Initializes a new instance of the ThreadDetails class.
        /// </summary>
        public ThreadDetails(VisaSource visaSource, string threadName)
        {
            InitializeComponent();

            // need to create a new view model so we can have multiple instances of the window
            ThreadDetailsViewModel threadDetailsViewModel = new ThreadDetailsViewModel();
            threadDetailsViewModel.OnCloseWindowEvent += new CloseWindowDelegate(threadDetailsViewModel_OnCloseWindowEvent);
            this.DataContext = threadDetailsViewModel;
            threadDetailsViewModel.setThreadDetails(visaSource, threadName);
        }

        public ThreadDetails(VisaSource visaSource, JmxThread jmxThread)
        {
            InitializeComponent();

            // need to create a new view model so we can have multiple instances of the window
            ThreadDetailsViewModel threadDetailsViewModel = new ThreadDetailsViewModel();
            threadDetailsViewModel.OnCloseWindowEvent += new CloseWindowDelegate(threadDetailsViewModel_OnCloseWindowEvent);
            this.DataContext = threadDetailsViewModel;
            threadDetailsViewModel.setThreadDetails(visaSource, jmxThread);
        }

        void threadDetailsViewModel_OnCloseWindowEvent()
        {
            this.Close();
        }
    }
}