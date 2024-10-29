using System.Windows;
using VISAHealthMonitorCommonControls.ViewModel;
using VISAHealthMonitorCommon;

namespace VISAHealthMonitorCommonControls
{
    /// <summary>
    /// Description for MemoryView.
    /// </summary>
    public partial class MemoryView : Window
    {
        /// <summary>
        /// Initializes a new instance of the MemoryView class.
        /// </summary>
        public MemoryView(VisaHealth visaHealth)
        {
            InitializeComponent();

            MemoryViewModel memoryViewModel = new MemoryViewModel();
            memoryViewModel.OnCloseWindowEvent += new CloseWindowDelegate(memoryViewModel_OnCloseWindowEvent);
            this.DataContext = memoryViewModel;
            memoryViewModel.SetVisaHealth(visaHealth);
        }

        void memoryViewModel_OnCloseWindowEvent()
        {
            this.Close();
        }
    }
}