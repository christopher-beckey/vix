using System.Windows;
using VISAHealthMonitorCommonControls.ViewModel;
using VISACommon;

namespace VISAHealthMonitorCommonControls
{
    /// <summary>
    /// Description for Threads.
    /// </summary>
    public partial class Threads : Window
    {
        /// <summary>
        /// Initializes a new instance of the Threads class.
        /// </summary>
        public Threads(VisaSource visaSource)
        {
            InitializeComponent();

            ThreadsViewModel threadsViewModel = new ThreadsViewModel();
            threadsViewModel.OnCloseWindowEvent += new CloseWindowDelegate(threadsViewModel_OnCloseWindowEvent);
            this.DataContext = threadsViewModel;
            threadsViewModel.SetSiteDetails(visaSource);


        }

        void threadsViewModel_OnCloseWindowEvent()
        {
            this.Close();
        }
    }
}