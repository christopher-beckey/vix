using System.Windows;
using VISACommon;
using VISAHealthMonitorCommonControls.ViewModel;

namespace VISAHealthMonitorCommonControls
{
    /// <summary>
    /// Description for JmxView.
    /// </summary>
    public partial class JmxView : Window
    {
        /// <summary>
        /// Initializes a new instance of the JmxView class.
        /// </summary>
        public JmxView(VisaSource visaSource)
        {
            InitializeComponent();
            JmxViewModel jmxViewModel = new JmxViewModel();
            jmxViewModel.OnCloseWindowEvent += new CloseJmxWindowDelegate(jmxViewModel_OnCloseWindowEvent);
            this.DataContext = jmxViewModel;
            jmxViewModel.Initialize(visaSource);
        }

        void jmxViewModel_OnCloseWindowEvent()
        {
            this.Close();
        }
    }
}   